Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DDA69C6CB
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjBTIfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjBTIfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:35:06 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816462D61
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 00:35:03 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o14so662987wms.1
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 00:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9SCHZxVrWwYhFPaFM40+xiOddaLbOPVW0nERIbBzocA=;
        b=jYU6POCxFUND3/EhWp0vLbfxGd6X9j+wTVfSZHOcl9SvJ6Ytgh31RoDZETK7XPQDe+
         OwTs8YchQVEzQWc6IzuxFoG/mE9zZCh3gg24Ghlc/bAkIIDIgsoTf68JXHcRaZeiyhoq
         jvL2WJgtNdbbOjhOzeYOAex4SEqts1ZpJFtVSmyQTKylXI2HqMgZEAULl8c2fyOwqDZv
         XpEeVJxIex6CDEgDpW7dhtELYs2E2Q7ZaVFw9uNKT3Jj5NtZAN9wr72ISaHV+0zlcot2
         24MAqeO1WtgHEM/pZ/AeD+4AUzI9N9UkhE2lqihtaVSQmjgaHy+aFCce+y0KVWHli4iC
         22wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SCHZxVrWwYhFPaFM40+xiOddaLbOPVW0nERIbBzocA=;
        b=lDL6jST+LxVwwda7uri38r4vxucw1QA3ybKUcj3BHY1n3IrrOXqRCX//4z2CExGNR9
         8TKPqx0UWnagVn4wIxY4Wy61hq2SU7qY644iyyCxRuxJHGiT+uetYgJSLNcrj9+1b6To
         FxmKK0KvMsrJKq15f2PGrliBlX/G74xfDmpFKP1VSkoQktNzbWP9cyf4kV7htUsf5uIf
         oJbVOnDEzP39EPGv2E6LiBXvPDq4kMZzVeCmXhHBfgObEnJTN+bC40c5cHWOFrtHLYLM
         CrdfDLOgiK4R8srBHd66/deqEjPuMEO5uhZJNk6beoEq1RF2tHrPyVm4YH9Oz3pfWasG
         DDhw==
X-Gm-Message-State: AO0yUKWlhJgrAjf9/aGPlKDo8dMUEm0+Amf9/dXH2taHGA1UJuOtD7Fn
        Gz7FXQ+0eQ294BAgSCU6oB5y+g==
X-Google-Smtp-Source: AK7set8pFtDwXHwFt/xEKrv7KMNJQcIXafy9lFeFquhgZ29Gzy1IsywfC0RnGIiy0jnxAc9zFhSVtg==
X-Received: by 2002:a05:600c:13ca:b0:3e2:522:45f7 with SMTP id e10-20020a05600c13ca00b003e2052245f7mr105649wmg.13.1676882102026;
        Mon, 20 Feb 2023 00:35:02 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z6-20020adfe546000000b002425be3c9e2sm622456wrm.60.2023.02.20.00.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 00:35:01 -0800 (PST)
Date:   Mon, 20 Feb 2023 09:35:00 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        Vitaly Mireyno <vmireyno@marvell.com>
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Message-ID: <Y/MwtAGru3yAY7r3@nanopsycho>
References: <20230217121547.3958716-1-jiri@resnulli.us>
 <20230217072032-mutt-send-email-mst@kernel.org>
 <Y+94418p73aUQyIn@nanopsycho>
 <20230217083915-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217083915-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 17, 2023 at 02:47:36PM CET, mst@redhat.com wrote:
>On Fri, Feb 17, 2023 at 01:53:55PM +0100, Jiri Pirko wrote:
>> Fri, Feb 17, 2023 at 01:22:01PM CET, mst@redhat.com wrote:
>> >On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >> 
>> >> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
>> >> 
>> >> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
>> >> set implicates that the driver provides the exact size of the header.
>> >> 
>> >> The driver already complies to fill the correct value. Introduce the
>> >> feature and advertise it.
>> >> 
>> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> >
>> >Could you add a bit of motivation just for the record?
>> >Does this improve performance for some card? By how much?
>> >Expected to help some future card?
>> 
>> I can get that info, but isn't that rather something to be appended to
>> the virtio-spec patch? I mean, the feature is there, this is just
>> implementing it in one driver.
>
>It is more like using it in the driver.  It's not like we have to use
>everything - it could be useful for e.g. dpdk but not linux.
>Implementing it in the Linux driver has support costs - for example what
>if there's a bug and sometimes the length is incorrect?
>We'll be breaking things.

I understand. To my understanding this feature just fixes the original
ambiguity in the virtio spec.

Quoting the original virtio spec:
"hdr_len is a hint to the device as to how much of the header needs to
 be kept to copy into each packet"

"a hint" might not be clear for the reader what does it mean, if it is
"maybe like that" of "exactly like that". This feature just makes it
crystal clear.

If you look at the tap implementation, it uses hdr_len to alloc
skb linear part. No hint, it counts with the provided value.
So if the driver is currently not precise, it breaks tap.

I will add this to the patch description and send v2.


>
>The patch was submitted by Marvell but they never bothered with
>using it in Linux. I guess they are using it for something else?
>CC Vitaly who put this in.
>
>> 
>> >
>> >thanks!
>> >
>> >
>> >> ---
>> >>  drivers/net/virtio_net.c        | 6 ++++--
>> >>  include/uapi/linux/virtio_net.h | 1 +
>> >>  2 files changed, 5 insertions(+), 2 deletions(-)
>> >> 
>> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> >> index fb5e68ed3ec2..e85b03988733 100644
>> >> --- a/drivers/net/virtio_net.c
>> >> +++ b/drivers/net/virtio_net.c
>> >> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
>> >>  	VIRTIO_NET_F_GUEST_UFO,
>> >>  	VIRTIO_NET_F_GUEST_CSUM,
>> >>  	VIRTIO_NET_F_GUEST_USO4,
>> >> -	VIRTIO_NET_F_GUEST_USO6
>> >> +	VIRTIO_NET_F_GUEST_USO6,
>> >> +	VIRTIO_NET_F_GUEST_HDRLEN
>> >>  };
>> >>  
>> >>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
>> >> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
>> >>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>> >>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>> >>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
>> >> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
>> >> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
>> >> +	VIRTIO_NET_F_GUEST_HDRLEN
>> >>  
>> >>  static unsigned int features[] = {
>> >>  	VIRTNET_FEATURES,
>> >> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
>> >> index b4062bed186a..12c1c9699935 100644
>> >> --- a/include/uapi/linux/virtio_net.h
>> >> +++ b/include/uapi/linux/virtio_net.h
>> >> @@ -61,6 +61,7 @@
>> >>  #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
>> >>  #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
>> >>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>> >> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
>> >>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>> >>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
>> >>  #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
>> >> -- 
>> >> 2.39.0
>> >
>
