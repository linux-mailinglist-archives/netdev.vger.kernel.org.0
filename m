Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C426369EFB9
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 08:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjBVH6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 02:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjBVH6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 02:58:44 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCA444A8
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 23:58:29 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i34so1541357eda.7
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 23:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tMiHi/cBJFvMvMXsiQE7+Z5SH+iPrBno2vV9oiQq5+M=;
        b=zIORBVKs5wvYIt/NE+95SxKobhocieC/ab4iUtKOu1iTlcULph/CGpmg5l/fsuByuy
         YUD48KmVUS6hbh8FjmN2MD0s0ES0djEMXJyDq9erNtjOSUlwVkuwP455NYItUOATyhhl
         0HOaV86zenfQ/PbZ2PFoR5/TcMqf7z59TjW7gycrn1LIDH8TKPc/vhMWD619wVQz8JR1
         0I1/EYMzB72FMU24Ae7DZyaZTMo/6era7fWdGS45TNAqnJ7srPqlQwKlrIKTBm3Fs7gJ
         0yyhs5Fo645+P82hUzsDUuDjk/5TTT3bcRH/Be6TjFbXBar/nsRF2ox/gfUJdD4F58GR
         K8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMiHi/cBJFvMvMXsiQE7+Z5SH+iPrBno2vV9oiQq5+M=;
        b=zuil0BTqet5brYUVCXKU2wGjuaTppsCwY7ReEKE/uiwEEVXw+86tTkaJPPz1m1vbL4
         wkaBhEQnCxpPFslRUZwWlSQ9rWbtFVlXv4OUiPeMqDpUPcSvhg4XYs7W1UITl1HTdWGP
         LoZ9d+AeTHdePdGCq2YAGO8bMbjl0yN89ao3bkZJ41wSTQ0pwEMsf257xysO2zv5vo63
         mgLVX48u9zakT8HX9e1teSM0Z2WRQQ/11kVJq31jOkpj84bsQlvB7aUcNqmZiGf4KVcg
         +xBWobBtDeKeA3ZUSAgJHCHTINztcMmiypCskny5H455s5rhDmasMScpVw2h/5fXKTz3
         BBPA==
X-Gm-Message-State: AO0yUKUQebbkLq9QWDzXoYrrl7j6cyQ51vc21tq+2zMjSiy6R48jfBM1
        k4DVyC++wZaQswYApk0EWF3SKg==
X-Google-Smtp-Source: AK7set+BkOGRM5kYs510JAPgZTtyESbkJMRNL8UAs6qXdnNB0GfMt1fVlMxFEvZx9acOG/OyHuCbgQ==
X-Received: by 2002:a17:907:a40d:b0:878:7349:5ce6 with SMTP id sg13-20020a170907a40d00b0087873495ce6mr19275302ejc.71.1677052708175;
        Tue, 21 Feb 2023 23:58:28 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y6-20020a50ce06000000b004acc6c67089sm3676070edi.75.2023.02.21.23.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 23:58:27 -0800 (PST)
Date:   Wed, 22 Feb 2023 08:58:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Subject: Re: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Message-ID: <Y/XLIs+4eg7xPyF0@nanopsycho>
References: <20230221144741.316477-1-jiri@resnulli.us>
 <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
 <Y/TltJnD4k5hB6Z1@nanopsycho>
 <63f4ed716af37_d174a20880@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63f4ed716af37_d174a20880@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 21, 2023 at 05:12:33PM CET, willemdebruijn.kernel@gmail.com wrote:
>Jiri Pirko wrote:
>> Tue, Feb 21, 2023 at 04:11:53PM CET, willemdebruijn.kernel@gmail.com wrote:
>> >Jiri Pirko wrote:
>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >> 
>> >> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
>> >> set implicates that the driver provides the exact size of the header.
>> >> 
>> >> Quoting the original virtio spec:
>> >> "hdr_len is a hint to the device as to how much of the header needs to
>> >>  be kept to copy into each packet"
>> >> 
>> >> "a hint" might not be clear for the reader what does it mean, if it is
>> >> "maybe like that" of "exactly like that". This feature just makes it
>> >> crystal clear and let the device count on the hdr_len being filled up
>> >> by the exact length of header.
>> >> 
>> >> Also note the spec already has following note about hdr_len:
>> >> "Due to various bugs in implementations, this field is not useful
>> >>  as a guarantee of the transport header size."
>> >> 
>> >> Without this feature the device needs to parse the header in core
>> >> data path handling. Accurate information helps the device to eliminate
>> >> such header parsing and directly use the hardware accelerators
>> >> for GSO operation.
>> >> 
>> >> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
>> >> The driver already complies to fill the correct value. Introduce the
>> >> feature and advertise it.
>> >> 
>> >> Note that virtio spec also includes following note for device
>> >> implementation:
>> >> "Caution should be taken by the implementation so as to prevent
>> >>  a malicious driver from attacking the device by setting
>> >>  an incorrect hdr_len."
>> >> 
>> >> There is a plan to support this feature in our emulated device.
>> >> A device of SolidRun offers this feature bit. They claim this feature
>> >> will save the device a few cycles for every GSO packet.
>> >> 
>> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> >> ---
>> >> v1->v2:
>> >> - extended patch description
>> >
>> >Is the expectation that in-kernel devices support this feature, and
>> >if so how would it affect them? If I read the spec correctly, devices
>> 
>> Well, the tap driver actually trusts the hdr_len to be of correct header
>> size nowadays.
>
>tap_get_user performs basic bounds checking on the length passed.

Sure. It trusts the hdr_len, but it sanitizes the input.


> 
>> 
>> >still need to be careful against malicious drivers, so cannot assume
>> >much beyond what they do today (i.e., a hint).
>> 
>> Malicious how? There is upper limit of size in tap which is checked.
>> I assume that for hw implementation, that would be the same.
>
>A device cannot blindly trust a hdr_len passed from a driver. We have
>had bugs in the kernel with this before, such as the one fixed in
>commit 57031eb79490 ("packet: round up linear to header len").
>
>> But anyway, this discussion would be rather part of the spec/device
>> patch, don't you think?
>
>I disagree. If it's not much effort to make a commit self-documenting
>that is preferable. And if not, then an explicit reference to an
>authoratitive external reference is preferable over "it is trivial to
>look it up".

Sorry, I don't follow. What exactly do you want me to do?


> 
>> 
>> >
>> >Might be good to point to the definition commit:
>> >https://github.com/oasis-tcs/virtio-spec/commit/4f1981a1ff46b7aeb801c4c524ff76e93d9ce022
>> 
>> There were couple of fixes to the spec since then, that's why I didn't
>> include it. It is trivial to look it up in the spec.
