Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF7869E44B
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjBUQMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjBUQMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:12:36 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B762B621
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 08:12:35 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id h19so2044719qtk.7
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 08:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOVbf0Jj7n0h+rN9B1b7a1tvZN7i0xM79+a5LjkHtlE=;
        b=K0OiTMBfOnSIY8WOlxZhTFPJvou6xpIF16T/n7FMod0hUZcxYky8baFfXb0uUQy3bi
         PLXqH885WLbdNgSdVL/drKFtRK+De6tto3o1TjV6YuBH7LwkhsZX4e2GTefmB0QlBujH
         45xvv6Zw5VYxfEoKpPm7aNPjvB7sLpSQ3ejOBMbkS2OEj/hvPibfbxi74AXIpjphLZHO
         7RVwNQwf8Dyr9RoEMtHm62X9C/h9vlCP5MZWS1L/W0KrVcMoiyv7nllzhGk8gPhdbdIL
         ol1Md3RK1C2LyQtVURYrsEF56LX8nW9GOzKopkKesHi0HoPXCdsV8mL99uWM7aS8sDGt
         CYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iOVbf0Jj7n0h+rN9B1b7a1tvZN7i0xM79+a5LjkHtlE=;
        b=F1bUC2EgazNvuG0G+ysSyZUuuk9N82s37umD1qTZsAsJsj9REPVfEYUPZvjUEZZ4ba
         1v64Pcn4CH3HH/Xy04A69IY1YwUq/nbhGpT3rljdisUgC9IENv8j+0LKm0JoTAOudH+j
         PuOx5NcDCCQBObWUkMm1Yrc5adpbsMPhxON9jrxIiIxPW/esZ+1P5A5R+SaWUx4ZYg/Z
         r1niKhFO+lWRQ/8DzsmivWzgcTpfDIFsEfiYcjQTcDz98aEf2fd8Lzwd2STIbiDojezV
         rb3whhbjH0z/Eq7vpdrB6lIWbHZgPyFlhRdnlzRLsPXtgVJfp3DxkBxqwAU86D4sLyTo
         7NDQ==
X-Gm-Message-State: AO0yUKWHpaAWMw6YwEhbcbKQnPFSWbKmwkNhz+cjMiGuXtR76UXwVY7h
        ysIiL3mRz0JFHIiN6306WUs=
X-Google-Smtp-Source: AK7set9eeoptqYWwTH+BLMC80x39U+80hiB79zey4MYkBCR4KDidVutUrAIBq2AGQo1Shhv9o8oMyg==
X-Received: by 2002:ac8:5f13:0:b0:3b9:abfb:61cd with SMTP id x19-20020ac85f13000000b003b9abfb61cdmr8641505qta.26.1676995954091;
        Tue, 21 Feb 2023 08:12:34 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id ca26-20020a05622a1f1a00b003b62e8b77e7sm2516427qtb.68.2023.02.21.08.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:12:33 -0800 (PST)
Date:   Tue, 21 Feb 2023 11:12:33 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Message-ID: <63f4ed716af37_d174a20880@willemb.c.googlers.com.notmuch>
In-Reply-To: <Y/TltJnD4k5hB6Z1@nanopsycho>
References: <20230221144741.316477-1-jiri@resnulli.us>
 <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
 <Y/TltJnD4k5hB6Z1@nanopsycho>
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
> Tue, Feb 21, 2023 at 04:11:53PM CET, willemdebruijn.kernel@gmail.com wrote:
> >Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> >> set implicates that the driver provides the exact size of the header.
> >> 
> >> Quoting the original virtio spec:
> >> "hdr_len is a hint to the device as to how much of the header needs to
> >>  be kept to copy into each packet"
> >> 
> >> "a hint" might not be clear for the reader what does it mean, if it is
> >> "maybe like that" of "exactly like that". This feature just makes it
> >> crystal clear and let the device count on the hdr_len being filled up
> >> by the exact length of header.
> >> 
> >> Also note the spec already has following note about hdr_len:
> >> "Due to various bugs in implementations, this field is not useful
> >>  as a guarantee of the transport header size."
> >> 
> >> Without this feature the device needs to parse the header in core
> >> data path handling. Accurate information helps the device to eliminate
> >> such header parsing and directly use the hardware accelerators
> >> for GSO operation.
> >> 
> >> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> >> The driver already complies to fill the correct value. Introduce the
> >> feature and advertise it.
> >> 
> >> Note that virtio spec also includes following note for device
> >> implementation:
> >> "Caution should be taken by the implementation so as to prevent
> >>  a malicious driver from attacking the device by setting
> >>  an incorrect hdr_len."
> >> 
> >> There is a plan to support this feature in our emulated device.
> >> A device of SolidRun offers this feature bit. They claim this feature
> >> will save the device a few cycles for every GSO packet.
> >> 
> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >> ---
> >> v1->v2:
> >> - extended patch description
> >
> >Is the expectation that in-kernel devices support this feature, and
> >if so how would it affect them? If I read the spec correctly, devices
> 
> Well, the tap driver actually trusts the hdr_len to be of correct header
> size nowadays.

tap_get_user performs basic bounds checking on the length passed.
 
> 
> >still need to be careful against malicious drivers, so cannot assume
> >much beyond what they do today (i.e., a hint).
> 
> Malicious how? There is upper limit of size in tap which is checked.
> I assume that for hw implementation, that would be the same.

A device cannot blindly trust a hdr_len passed from a driver. We have
had bugs in the kernel with this before, such as the one fixed in
commit 57031eb79490 ("packet: round up linear to header len").

> But anyway, this discussion would be rather part of the spec/device
> patch, don't you think?

I disagree. If it's not much effort to make a commit self-documenting
that is preferable. And if not, then an explicit reference to an
authoratitive external reference is preferable over "it is trivial to
look it up".
 
> 
> >
> >Might be good to point to the definition commit:
> >https://github.com/oasis-tcs/virtio-spec/commit/4f1981a1ff46b7aeb801c4c524ff76e93d9ce022
> 
> There were couple of fixes to the spec since then, that's why I didn't
> include it. It is trivial to look it up in the spec.
