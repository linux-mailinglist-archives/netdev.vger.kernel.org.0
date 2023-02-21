Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A056369E620
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbjBURkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBURkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:40:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDF826CED
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677001160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MPuIrvpqk087p+R5h2joKaFXJupChM4KtrAD5lv9Wqw=;
        b=BEGLbbVoT7XEsYo//zHjmYEXRQ79MqTM1s5aN0Rhoa5+7H5zLwdkQjkfm+2Ww39eWzEJ73
        NifO3XGMt1VzUAT/pryzfGgOe0DPOawmwjIHxA66H0PivHQmwVYs6yP+DY+q319y7kW768
        KJkC5ZnBdEIln2cXZ3/QJC3jRVydwXM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-451-wjM3C_e2Ma6zEaSKRaik1A-1; Tue, 21 Feb 2023 12:39:19 -0500
X-MC-Unique: wjM3C_e2Ma6zEaSKRaik1A-1
Received: by mail-wm1-f71.google.com with SMTP id f14-20020a7bcc0e000000b003dd41ad974bso2103993wmh.3
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:39:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MPuIrvpqk087p+R5h2joKaFXJupChM4KtrAD5lv9Wqw=;
        b=sCvjQR3bdDXRiBJxRp5Bm25VP83086qlrFIrHt3KTwKI07DuNDHZh2PUkV25S9OMR4
         RxaB4gdWSZgcoEw5+cUhYXhi1gWYCQmeENVHaA7LwSOvCYlFVI4Ym6zWIUhxMKIUWCzb
         MP1YGmNMX8jPUlBf4XsAOlpbriRHvJDLZXysV2YzjodJh7QKLMVsaJBYxbmg58h4w4Rf
         QpmZIwwIkOo0GgIJGhn6C73luQ/D5XijgSDwmsq2GyQxszp6rPdO32fz1yfXVHY9RGZE
         w4xr7Aut7mvH8i0uEqdFMVSmfKjCijD9hQFswmBcaD0uwL+BA/kReR0/4LdVLEEUpedz
         Jmhg==
X-Gm-Message-State: AO0yUKVPlaenNBJdcH1M1mY9yat+GkXRZOsXCVMk8S7UXMqLxwqG7M29
        1yQdhyPxFPpA9XYoxufcH8NaT/V8EqNDaKZrciJqQGVXd8ySq+Z2t3b5eXEojiV7M0Kv72MSfLY
        5Ohmg85FY4nc4+ikI
X-Received: by 2002:adf:dfd0:0:b0:2c5:54a7:3646 with SMTP id q16-20020adfdfd0000000b002c554a73646mr4633684wrn.5.1677001157981;
        Tue, 21 Feb 2023 09:39:17 -0800 (PST)
X-Google-Smtp-Source: AK7set9wztbZgAM6luozt0YiTQObP3jqXSOKc3Fe3WqAJGUETTWXCPM1umIXBSiSiwaNKLULuxY00w==
X-Received: by 2002:adf:dfd0:0:b0:2c5:54a7:3646 with SMTP id q16-20020adfdfd0000000b002c554a73646mr4633673wrn.5.1677001157701;
        Tue, 21 Feb 2023 09:39:17 -0800 (PST)
Received: from redhat.com ([2.52.2.78])
        by smtp.gmail.com with ESMTPSA id i18-20020adfe492000000b002c56287bd2csm5471677wrm.114.2023.02.21.09.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 09:39:17 -0800 (PST)
Date:   Tue, 21 Feb 2023 12:39:13 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Subject: Re: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Message-ID: <20230221123857-mutt-send-email-mst@kernel.org>
References: <20230221144741.316477-1-jiri@resnulli.us>
 <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
 <Y/TltJnD4k5hB6Z1@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/TltJnD4k5hB6Z1@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 04:39:32PM +0100, Jiri Pirko wrote:
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
> 
> 
> >still need to be careful against malicious drivers, so cannot assume
> >much beyond what they do today (i.e., a hint).
> 
> Malicious how? There is upper limit of size in tap which is checked.
> I assume that for hw implementation, that would be the same.
> 
> But anyway, this discussion would be rather part of the spec/device
> patch, don't you think?
> 
> 
> >
> >Might be good to point to the definition commit:
> >https://github.com/oasis-tcs/virtio-spec/commit/4f1981a1ff46b7aeb801c4c524ff76e93d9ce022
> 
> There were couple of fixes to the spec since then, that's why I didn't
> include it. It is trivial to look it up in the spec.

This might be a good link:

https://docs.oasis-open.org/virtio/virtio/v1.2/cs01/virtio-v1.2-cs01.html#x1-230006x3


