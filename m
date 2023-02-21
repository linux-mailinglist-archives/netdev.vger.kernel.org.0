Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCFF69E071
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjBUMcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbjBUMcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:32:08 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CF82684
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:32:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id f13so16002234edz.6
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=psfYQ5q9tEH5+H+Q55pYMK3ZVAM+wEPZbT8old+Dmfw=;
        b=dpzKGYelknCiy0y2DNdPuRiS9nHCPyMXD1QJ6WhDH3pAkhjMeESwbc4GhQ//lkFfk0
         BukBuwMZ11R4zA3qplaNrgU7jEL5E9UeiM5XZ+QB9/RfGGcFVc5X6csPVLwXdigCxGen
         u23W1RG5irItofd5Z5ohAG+FCMnK2UEViUvmyeA4u7pMViJXSdY9Tv4SAD54kxVm1vcb
         QNC3o29WViSz7XAkdvinwpo4462cdO6jWXAQEnqC5vYPt6R+QCmVP7/YaqG9JYJnYsMR
         ku8zmdGlqaHBVL8vJvHUuTs0Zwi5RWD+7/oNhAX6Qp5aR6hn9gpDTJrgfyS7589CWLCw
         AAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=psfYQ5q9tEH5+H+Q55pYMK3ZVAM+wEPZbT8old+Dmfw=;
        b=ThpsjnQCEDpLRINJsQnG/mMzdUDNwXidD9OiHBgpkQsjpK6HfKIC/cofTwd1wz2rpd
         JQWjcKLrbL02OLIiZvOsxitT9djOtZu4g1n0hSHAeJANZzSgSPQ0S25129/33bzc0vH2
         5VmVjHpnbqYeIXyRS2ClTb3+UU5Q1MiJkI3mjcc+PiodMfUbYQWpoot7dnNINUPN9Ts6
         T9RxlvzZDNbC75J300eQ4KfD4bLfMxhJhNrtw63g7xsAyQEl2hdNdNoRky1e+X40ReRD
         T1N5PXzzZqKhsq8Io8dA4EiQQPtng2WkA2Yk5f522Yx78rJimLhdip5Vn1iixjLD569F
         yx+Q==
X-Gm-Message-State: AO0yUKULKEm673OMy0fu4CvvZCKU6V1d0VLWBJvHqGdE3MeCzC2//OE1
        VTPE3PVIS4ykjFnaI88fGf2RCw==
X-Google-Smtp-Source: AK7set+HrH7ypeL2hPssofyMl9d9wasWxYFll//DPGZByw6SdSB5rlDUtcKRBNMrhdJh7giZ5DpLRg==
X-Received: by 2002:a17:906:6956:b0:88c:a43d:81bc with SMTP id c22-20020a170906695600b0088ca43d81bcmr9924049ejs.58.1676982725289;
        Tue, 21 Feb 2023 04:32:05 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q22-20020a50cc96000000b004acbdf23cd2sm2545400edi.29.2023.02.21.04.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 04:32:04 -0800 (PST)
Date:   Tue, 21 Feb 2023 13:32:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        Vitaly Mireyno <vmireyno@marvell.com>
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Message-ID: <Y/S5wzQISm7y22i4@nanopsycho>
References: <20230217121547.3958716-1-jiri@resnulli.us>
 <20230217072032-mutt-send-email-mst@kernel.org>
 <Y+94418p73aUQyIn@nanopsycho>
 <20230217083915-mutt-send-email-mst@kernel.org>
 <Y/MwtAGru3yAY7r3@nanopsycho>
 <20230220074947-mutt-send-email-mst@kernel.org>
 <Y/N7+IJ+gzvP0IEf@nanopsycho>
 <20230220174110-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220174110-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 20, 2023 at 11:43:52PM CET, mst@redhat.com wrote:
>On Mon, Feb 20, 2023 at 02:56:08PM +0100, Jiri Pirko wrote:
>> Mon, Feb 20, 2023 at 01:55:33PM CET, mst@redhat.com wrote:
>> >On Mon, Feb 20, 2023 at 09:35:00AM +0100, Jiri Pirko wrote:
>> >> Fri, Feb 17, 2023 at 02:47:36PM CET, mst@redhat.com wrote:
>> >> >On Fri, Feb 17, 2023 at 01:53:55PM +0100, Jiri Pirko wrote:
>> >> >> Fri, Feb 17, 2023 at 01:22:01PM CET, mst@redhat.com wrote:
>> >> >> >On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
>> >> >> >> From: Jiri Pirko <jiri@nvidia.com>
>> >> >> >> 
>> >> >> >> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
>> >> >> >> 
>> >> >> >> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
>> >> >> >> set implicates that the driver provides the exact size of the header.
>> >> >> >> 
>> >> >> >> The driver already complies to fill the correct value. Introduce the
>> >> >> >> feature and advertise it.
>> >> >> >> 
>> >> >> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> >> >> >
>> >> >> >Could you add a bit of motivation just for the record?
>> >> >> >Does this improve performance for some card? By how much?
>> >> >> >Expected to help some future card?
>> >> >> 
>> >> >> I can get that info, but isn't that rather something to be appended to
>> >> >> the virtio-spec patch? I mean, the feature is there, this is just
>> >> >> implementing it in one driver.
>> >> >
>> >> >It is more like using it in the driver.  It's not like we have to use
>> >> >everything - it could be useful for e.g. dpdk but not linux.
>> >> >Implementing it in the Linux driver has support costs - for example what
>> >> >if there's a bug and sometimes the length is incorrect?
>> >> >We'll be breaking things.
>> >> 
>> >> I understand. To my understanding this feature just fixes the original
>> >> ambiguity in the virtio spec.
>> >> 
>> >> Quoting the original virtio spec:
>> >> "hdr_len is a hint to the device as to how much of the header needs to
>> >>  be kept to copy into each packet"
>> >> 
>> >> "a hint" might not be clear for the reader what does it mean, if it is
>> >> "maybe like that" of "exactly like that". This feature just makes it
>> >> crystal clear.
>> >> 
>> >> If you look at the tap implementation, it uses hdr_len to alloc
>> >> skb linear part. No hint, it counts with the provided value.
>> >> So if the driver is currently not precise, it breaks tap.
>> >
>> >Well that's only for gso though right?
>> 
>> Yep.
>> 
>> 
>> >And making it bigger than necessary works fine ...
>> 
>> Well yeah. But tap does not do that, does it? it uses hdr_len directly.
>> 
>
>I mean if hdr_len is bigger than necessary tap does work.
>
>
>> >
>> >> I will add this to the patch description and send v2.
>> >> 
>> >
>> >I feel this does not answer the question yet, or maybe I am being dense.
>> >My point was not about making hdr_len precise.  My point was that we are
>> >making a change here for no apparent reason. I am guessing you are not
>> >doing it for fun - so why? Is there a device with this feature bit
>> >you are aware of?
>> 
>> Afaik real hw which does emulation of virtio_net would benefit from
>> that, our hw including.
>
>OK so do you have hardware which exposes this feature?

I believe it is not implemented yet, but it most certainly will be in
near future.

>That is the bit I am missing. Maybe mention the make
>in the commit log so
>we know where to turn if we need to make changes here?
>Or "under development" if it is not on the market yet.

Will put a note in the commit log.


>
>> 
>> >
>> >
>> >
>> >> 
>> >> >
>> >> >The patch was submitted by Marvell but they never bothered with
>> >> >using it in Linux. I guess they are using it for something else?
>> >> >CC Vitaly who put this in.
>> >> >
>> >> >> 
>> >> >> >
>> >> >> >thanks!
>> >> >> >
>> >> >> >
>> >> >> >> ---
>> >> >> >>  drivers/net/virtio_net.c        | 6 ++++--
>> >> >> >>  include/uapi/linux/virtio_net.h | 1 +
>> >> >> >>  2 files changed, 5 insertions(+), 2 deletions(-)
>> >> >> >> 
>> >> >> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> >> >> >> index fb5e68ed3ec2..e85b03988733 100644
>> >> >> >> --- a/drivers/net/virtio_net.c
>> >> >> >> +++ b/drivers/net/virtio_net.c
>> >> >> >> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
>> >> >> >>  	VIRTIO_NET_F_GUEST_UFO,
>> >> >> >>  	VIRTIO_NET_F_GUEST_CSUM,
>> >> >> >>  	VIRTIO_NET_F_GUEST_USO4,
>> >> >> >> -	VIRTIO_NET_F_GUEST_USO6
>> >> >> >> +	VIRTIO_NET_F_GUEST_USO6,
>> >> >> >> +	VIRTIO_NET_F_GUEST_HDRLEN
>> >> >> >>  };
>> >> >> >>  
>> >> >> >>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
>> >> >> >> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
>> >> >> >>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>> >> >> >>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>> >> >> >>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
>> >> >> >> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
>> >> >> >> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
>> >> >> >> +	VIRTIO_NET_F_GUEST_HDRLEN
>> >> >> >>  
>> >> >> >>  static unsigned int features[] = {
>> >> >> >>  	VIRTNET_FEATURES,
>> >> >> >> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
>> >> >> >> index b4062bed186a..12c1c9699935 100644
>> >> >> >> --- a/include/uapi/linux/virtio_net.h
>> >> >> >> +++ b/include/uapi/linux/virtio_net.h
>> >> >> >> @@ -61,6 +61,7 @@
>> >> >> >>  #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
>> >> >> >>  #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
>> >> >> >>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>> >> >> >> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
>> >> >> >>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>> >> >> >>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
>> >> >> >>  #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
>> >> >> >> -- 
>> >> >> >> 2.39.0
>> >> >> >
>> >> >
>> >
>
