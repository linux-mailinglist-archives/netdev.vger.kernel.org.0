Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591BA69F779
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjBVPOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjBVPOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:14:24 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2106722A13
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:14:23 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id w23so7887901qtn.6
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MP1pABxMzHpo8AMSOhxmhgtFnSUnUlB+dz2nSbkmVCQ=;
        b=kZ1fJnQ2f3gOa5uXlR2LpEgx6VA++mAR1qwnk0jNLxQIaqMmCKjpuI84eJL7NafRnD
         XxT+fvn+mo7gXp+UEUecXMoXKRAMvwQ9N4xwvwGpQyC/SJs0WoXUtDi9gALRFKzKYnQq
         Y01H1UF0RiJOxBiuUSj9w+PyyM6Zsk0Htyc/M6Z0ZkuqjiohQ48Yt4syLlsdu+V6tfqb
         m7oIRQ7CehOYcX6No6m8n1oQP8WMS0C7gy3dLGJOB1EwQhNF9eOPr6z2IaJFkIZwJf4i
         fLGGhI6AlF1JG7cIgeFFQOO2a9WhUF0vak2xm6jDjEKVi/vEAd8h2GIGxNWau0+rUbox
         QREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MP1pABxMzHpo8AMSOhxmhgtFnSUnUlB+dz2nSbkmVCQ=;
        b=LcLeKLBjPHrN9Oq2gC/+PipKd/8+fQqkKvD1uQRaZYQG7S9Lyd/zKPK+D8mZlkidN2
         7lz+7i9fJoGfr5tU9+yEsfJyHQPJ2CNe9N5/sL6lPXQvsspwMeoQ/yVnCAisKgrDUuLs
         o9XquJ9DbjXnCh3gKyBKp5ffAWe+5MsMg/5A5M3kksKmtvYff0sgmmN6wAVJR+joyEDq
         +jifQ3hdp6PE4LX07GOtq2Ld/dMofTNVqsozbOup3c/qjR9wlNJZBi3sySwz+TYO9K0R
         Z62+2l2S1XIjV2FnOCdodxEURxEiS92qdOP3IMxdXQjb4ZAD/ugh6AmKtP2PcMBBZGFi
         jecQ==
X-Gm-Message-State: AO0yUKWkmTU7fCNEg4d1VVb6INtfw1ok+ldDmeiKu1MJu4ACIf/itgSK
        6TNQl+lJ4lBtMADCmYkDYSw=
X-Google-Smtp-Source: AK7set+Q2a5jr0Nuelg2LNI7xaz7htgjSkqBaSR0VnulEScQizwo/0NwhpPrYspCF+rzIDzIb9ZI9w==
X-Received: by 2002:ac8:5cce:0:b0:3b8:2a6c:d1e9 with SMTP id s14-20020ac85cce000000b003b82a6cd1e9mr11314604qta.18.1677078862133;
        Wed, 22 Feb 2023 07:14:22 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b003b860983973sm4060867qts.60.2023.02.22.07.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 07:14:21 -0800 (PST)
Date:   Wed, 22 Feb 2023 10:14:21 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Message-ID: <63f6314d678bc_2ab6208a@willemb.c.googlers.com.notmuch>
In-Reply-To: <Y/XLIs+4eg7xPyF0@nanopsycho>
References: <20230221144741.316477-1-jiri@resnulli.us>
 <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
 <Y/TltJnD4k5hB6Z1@nanopsycho>
 <63f4ed716af37_d174a20880@willemb.c.googlers.com.notmuch>
 <Y/XLIs+4eg7xPyF0@nanopsycho>
Subject: Re: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko wrote:
> Tue, Feb 21, 2023 at 05:12:33PM CET, willemdebruijn.kernel@gmail.com wrote:
> >Jiri Pirko wrote:
> >> Tue, Feb 21, 2023 at 04:11:53PM CET, willemdebruijn.kernel@gmail.com wrote:
> >> >Jiri Pirko wrote:
> >> >> From: Jiri Pirko <jiri@nvidia.com>
> >> >> 
> >> >> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> >> >> set implicates that the driver provides the exact size of the header.
> >> >> 
> >> >> Quoting the original virtio spec:
> >> >> "hdr_len is a hint to the device as to how much of the header needs to
> >> >>  be kept to copy into each packet"
> >> >> 
> >> >> "a hint" might not be clear for the reader what does it mean, if it is
> >> >> "maybe like that" of "exactly like that". This feature just makes it
> >> >> crystal clear and let the device count on the hdr_len being filled up
> >> >> by the exact length of header.
> >> >> 
> >> >> Also note the spec already has following note about hdr_len:
> >> >> "Due to various bugs in implementations, this field is not useful
> >> >>  as a guarantee of the transport header size."
> >> >> 
> >> >> Without this feature the device needs to parse the header in core
> >> >> data path handling. Accurate information helps the device to eliminate
> >> >> such header parsing and directly use the hardware accelerators
> >> >> for GSO operation.
> >> >> 
> >> >> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> >> >> The driver already complies to fill the correct value. Introduce the
> >> >> feature and advertise it.
> >> >> 
> >> >> Note that virtio spec also includes following note for device
> >> >> implementation:
> >> >> "Caution should be taken by the implementation so as to prevent
> >> >>  a malicious driver from attacking the device by setting
> >> >>  an incorrect hdr_len."
> >> >> 
> >> >> There is a plan to support this feature in our emulated device.
> >> >> A device of SolidRun offers this feature bit. They claim this feature
> >> >> will save the device a few cycles for every GSO packet.
> >> >> 
> >> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >> >> ---
> >> >> v1->v2:
> >> >> - extended patch description
> >> >
> >> >Is the expectation that in-kernel devices support this feature, and
> >> >if so how would it affect them? If I read the spec correctly, devices
> >> 
> >> Well, the tap driver actually trusts the hdr_len to be of correct header
> >> size nowadays.
> >
> >tap_get_user performs basic bounds checking on the length passed.
> 
> Sure. It trusts the hdr_len, but it sanitizes the input.
>
> 
> > 
> >> 
> >> >still need to be careful against malicious drivers, so cannot assume
> >> >much beyond what they do today (i.e., a hint).
> >> 
> >> Malicious how? There is upper limit of size in tap which is checked.
> >> I assume that for hw implementation, that would be the same.
> >
> >A device cannot blindly trust a hdr_len passed from a driver. We have
> >had bugs in the kernel with this before, such as the one fixed in
> >commit 57031eb79490 ("packet: round up linear to header len").
> >
> >> But anyway, this discussion would be rather part of the spec/device
> >> patch, don't you think?
> >
> >I disagree. If it's not much effort to make a commit self-documenting
> >that is preferable. And if not, then an explicit reference to an
> >authoratitive external reference is preferable over "it is trivial to
> >look it up".
> 
> Sorry, I don't follow. What exactly do you want me to do?

Either including the link that Michael shared or quoting the relevant
part verbatim in the commit message would help, thanks.

Thinking it over, my main concern is that the prescriptive section in
the spec does not state what to do when the value is clearly garbage,
as we have seen with syzkaller.

Having to sanitize input, by dropping if < ETH_HLEN or > length, to
me means that the device cannot trust the field, as the spec says it
should. 

Sanitization is harder in the kernel, because it has to support all
kinds of link layers, including variable length.

Perhaps that's a discussion for the spec rather than this commit. But
it's a point to clarify as we add support to the code.
