Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D53305102
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343698AbhA0Efr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238409AbhA0EQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 23:16:16 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BB1C061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:15:35 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id j21so321915pls.7
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QYiDQ/GkVeugLJvhcCfQckoHPeFbIgca/K6Imf4T2Po=;
        b=g62gD4vzWIF3VJ6sQ63vSGCprMOkLtpsQr+09uEI2uxILNQAN+iKr4H2cB3njLv1pm
         8PY10A9S4awrbe8wzxhFyGyIcQIQyFqRDP54icTqouq7Sia3U/AfkAeWo80AugFyplQk
         YmN9oOSPR2Hrv1Elw0IwO5zQXtzppsKvQCwnNKWPPEASgdnSqjdTsFHzRaJqwpAIpX99
         yZIf+5D90X+7G4y0r1HMfsQ1ksmd6YzT+o67ZRskSuo6dfAvt7Jq3D4XyQDKRKtMCelg
         7FKDO6dPIQp/GpzvJmBNlkFiU5Q8ISZmKihEr4LvankepFU2UAqb1RWCTHuU8BvsGq4H
         eL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QYiDQ/GkVeugLJvhcCfQckoHPeFbIgca/K6Imf4T2Po=;
        b=ClZIok6xjbovFqfBgJF7GIJFXLbMuRH06rP7Jn3r+5U/TaSJBWi9HIMT35TGmFXPzh
         FarVXK9vuAvHSFU4dIXWEh+nkPB0O9xOfE2FbHmzlJdLXI66CvgXc+8Ww27kt7UeIx1q
         YSPZEHyT6lgJ5+b7ewzB80dRnxxn+wpRlzW6SLvLkq81JgNnIQL9kDP0TFq21tiRPCPF
         R/MI99+9DDH8X0iTsBoLxSMQlt3HWgD3SuFiD3X6vk0Rjid/yJp/SLiu5wgpABJWTH2P
         r6NP5//aSrdZYGtmIV5Yphg3E+SZeZqjVecX6Xfn1mh0Msnd4HBPK42z6oAv7KcTHRmU
         uloQ==
X-Gm-Message-State: AOAM533lG6R1oi45XLJDMyyB1uqik8z7nYzBmVnrClEZy3pvCQIvih9h
        Ir8xN/TY8Kj/bzg5a121rbw=
X-Google-Smtp-Source: ABdhPJxBfZoRMhIL8toqa9z7R22+wb5e8HwfzKaGzPTqXqM1dSAKHOsTvvLozQRQdydKZKkb/pj3Gw==
X-Received: by 2002:a17:902:ed94:b029:de:8844:a650 with SMTP id e20-20020a170902ed94b02900de8844a650mr9250211plj.56.1611720934705;
        Tue, 26 Jan 2021 20:15:34 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 77sm564860pfz.100.2021.01.26.20.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 20:15:33 -0800 (PST)
Date:   Wed, 27 Jan 2021 12:15:21 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, Jarod Wilson <jarod@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net-next] bridge: Propagate NETDEV_NOTIFY_PEERS notifier
Message-ID: <20210127041521.GO1421720@Leo-laptop-t470s>
References: <20210126040949.3130937-1-liuhangbin@gmail.com>
 <8a34f089-204f-aeb1-afc7-26ccc06419eb@nvidia.com>
 <20210126132448.GN1421720@Leo-laptop-t470s>
 <90df4fe6-fcc5-f59a-c89c-6f596443af4d@nvidia.com>
 <0b5741b6-48c0-0c34-aed8-257f3e203ac5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b5741b6-48c0-0c34-aed8-257f3e203ac5@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 04:55:22PM +0200, Nikolay Aleksandrov wrote:
> >> Thanks for the reply. There are a few reasons I think the bridge should
> >> handle NETDEV_NOTIFY_PEERS:
> >>
> >> 1. Only a few devices will call NETDEV_NOTIFY_PEERS notifier: bond, team,
> >>    virtio, xen, 6lowpan. There should have no much notification message.
> > 
> > You can't send a broadcast to all ports because 1 bond's link status has changed.
> > That makes no sense, the GARP needs to be sent only on that bond. The bond devices
> > are heavily used with bridge setups, and in general the bridge is considered a switch
> > device, it shouldn't be broadcasting GARPs to all ports when one changes link state.
> > 
> 
> Scratch the last sentence, I guess you're talking about when the bond's mac causes
> the bridge to change mac address by br_stp_recalculate_bridge_id(). I was wondering

Yes, that's what I mean. Sorry I didn't make it clear in commit description.

> at first why would you need to send garp, but in fact, as Ido mentioned privately,
> it is already handled correctly, but you need to have set arp_notify sysctl.
> Then if the bridge's mac changes because of the bond flapping a NETDEV_NOTIFY_PEERS will be
> generated. Check:
> devinet.c inetdev_event() -> case NETDEV_CHANGEADDR

Yes, this is a generic work around. It will handle all mac changing instead of
failover.

For IGMP, although you said they are different. In my understanding, when
bridge mac changed, we need to re-join multicast group, while a gratuitous
ARP is also needed. I couldn't find a reason why IGMP message is OK but GARP
is not.

> 
> Alternatively you can always set the bridge mac address manually and then it won't be
> changed by such events.

Thanks for this tips. I'm not sure if administers like this way.

This remind me another issue. Should we resend IGMP when got port
NETDEV_RESEND_IGMP notify, Even the bridge mac address may not changed?
Shouldn't we only resend IGMP, GARP when bridge mac address changed, e.g.

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 1b169f8e7491..74571f24bb18 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -80,8 +80,11 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 		changed_addr = br_stp_recalculate_bridge_id(br);
 		spin_unlock_bh(&br->lock);
 
-		if (changed_addr)
+		if (changed_addr) {
 			call_netdevice_notifiers(NETDEV_CHANGEADDR, br->dev);
+			call_netdevice_notifiers(NETDEV_RESEND_IGMP, br->dev);
+			call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, br->dev);
+		}
 
 		break;
 
@@ -124,11 +127,6 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 	case NETDEV_PRE_TYPE_CHANGE:
 		/* Forbid underlaying device to change its type. */
 		return NOTIFY_BAD;
-
-	case NETDEV_RESEND_IGMP:
-		/* Propagate to master device */
-		call_netdevice_notifiers(event, br->dev);
-		break;
 	}
 
 	if (event != NETDEV_UNREGISTER)


Thanks
Hangbin
