Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2297E69ACFB
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjBQNtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjBQNs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:48:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AC96ABF4
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676641662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j566sxiFR30aTmiG4rGSD34hpOB39mjJ2E7i4/yghZo=;
        b=M2BphFaRSKVjKeHuI1NJBKQwRV240PgItekZUD3D+1LUb23In6zR25s5tdyY9PrYsWBG3X
        XGJ9Q0IrD+8fHpFiUnRfwsJHnFIkIQTwOOjQSRsziX2SpJh8JNkmp5DpeeXEJPhX+7Ydok
        typyZ8nJ71e+C6mZXkl5R4HsbT57wdE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-471-GK_4PNkwPPy69m131B5BrA-1; Fri, 17 Feb 2023 08:47:41 -0500
X-MC-Unique: GK_4PNkwPPy69m131B5BrA-1
Received: by mail-wm1-f72.google.com with SMTP id l32-20020a05600c1d2000b003e0107732f4so755875wms.1
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:47:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j566sxiFR30aTmiG4rGSD34hpOB39mjJ2E7i4/yghZo=;
        b=0al7+1wgt+5qu7Qt8Smnhs3utTjjf4OIQ8ACVK3RJ/M/mECXs4gh7Hw5YvDx+uzQSq
         Aung6VCv5pye534GTzOwrXkg/RuVgLlUeAnOhP3Szpl6gaVeXErjYasz2vT88D0v2Jx8
         e3jeI2TkCsw65+A3hRF7cQMtOLVoSMOJIPd11i0vREh+QGiM/NQnGTtTgx+N+y3fINNW
         4DDbsAgyWd+ttUWHFHrOF9YDE296VcQtkzINbkSXj576JO2t0f0QLbALdshsSSgOnJLD
         Lxip0tpOUqH4WWcNqzEAd5nfja3BvhQT73qb1b3NVaD+XSKbx+5sCpoUJdULfEOfQzSX
         GF9Q==
X-Gm-Message-State: AO0yUKVDbSUQfBVQ6UF4Z2zZ/6LiFiMBxxQ9efh5I4MSDoFadPrQKdtz
        TB5heK8eqOXAL+f6VjxnDlR8uRKw9/gFRj5ItETw0shI80pkKWg24UL8PtYESMG4cjiEq2Drcjo
        T4vvbe8OjBjE1dOAM
X-Received: by 2002:a05:600c:4591:b0:3df:9858:c038 with SMTP id r17-20020a05600c459100b003df9858c038mr5078948wmo.13.1676641660747;
        Fri, 17 Feb 2023 05:47:40 -0800 (PST)
X-Google-Smtp-Source: AK7set+oXntli+obuZQPsa34EK1fBtgGYx9q6alm4B/8LEVVaw4ZU1QEArkNeZvSg69zjWc09iakSg==
X-Received: by 2002:a05:600c:4591:b0:3df:9858:c038 with SMTP id r17-20020a05600c459100b003df9858c038mr5078939wmo.13.1676641660475;
        Fri, 17 Feb 2023 05:47:40 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id y11-20020a05600c364b00b003dc0cb5e3f1sm4622433wmq.46.2023.02.17.05.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 05:47:39 -0800 (PST)
Date:   Fri, 17 Feb 2023 08:47:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        Vitaly Mireyno <vmireyno@marvell.com>
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Message-ID: <20230217083915-mutt-send-email-mst@kernel.org>
References: <20230217121547.3958716-1-jiri@resnulli.us>
 <20230217072032-mutt-send-email-mst@kernel.org>
 <Y+94418p73aUQyIn@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+94418p73aUQyIn@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 01:53:55PM +0100, Jiri Pirko wrote:
> Fri, Feb 17, 2023 at 01:22:01PM CET, mst@redhat.com wrote:
> >On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> >> 
> >> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> >> set implicates that the driver provides the exact size of the header.
> >> 
> >> The driver already complies to fill the correct value. Introduce the
> >> feature and advertise it.
> >> 
> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >
> >Could you add a bit of motivation just for the record?
> >Does this improve performance for some card? By how much?
> >Expected to help some future card?
> 
> I can get that info, but isn't that rather something to be appended to
> the virtio-spec patch? I mean, the feature is there, this is just
> implementing it in one driver.

It is more like using it in the driver.  It's not like we have to use
everything - it could be useful for e.g. dpdk but not linux.
Implementing it in the Linux driver has support costs - for example what
if there's a bug and sometimes the length is incorrect?
We'll be breaking things.

The patch was submitted by Marvell but they never bothered with
using it in Linux. I guess they are using it for something else?
CC Vitaly who put this in.

> 
> >
> >thanks!
> >
> >
> >> ---
> >>  drivers/net/virtio_net.c        | 6 ++++--
> >>  include/uapi/linux/virtio_net.h | 1 +
> >>  2 files changed, 5 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >> index fb5e68ed3ec2..e85b03988733 100644
> >> --- a/drivers/net/virtio_net.c
> >> +++ b/drivers/net/virtio_net.c
> >> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
> >>  	VIRTIO_NET_F_GUEST_UFO,
> >>  	VIRTIO_NET_F_GUEST_CSUM,
> >>  	VIRTIO_NET_F_GUEST_USO4,
> >> -	VIRTIO_NET_F_GUEST_USO6
> >> +	VIRTIO_NET_F_GUEST_USO6,
> >> +	VIRTIO_NET_F_GUEST_HDRLEN
> >>  };
> >>  
> >>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> >> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
> >>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
> >>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> >>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> >> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
> >> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
> >> +	VIRTIO_NET_F_GUEST_HDRLEN
> >>  
> >>  static unsigned int features[] = {
> >>  	VIRTNET_FEATURES,
> >> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> >> index b4062bed186a..12c1c9699935 100644
> >> --- a/include/uapi/linux/virtio_net.h
> >> +++ b/include/uapi/linux/virtio_net.h
> >> @@ -61,6 +61,7 @@
> >>  #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
> >>  #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
> >>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
> >> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
> >>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
> >>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> >>  #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
> >> -- 
> >> 2.39.0
> >

