Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2820C42DF2E
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhJNQea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhJNQe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:34:27 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CE6C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 09:32:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id g5so4554927plg.1
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 09:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=1P6t73TdrKue96+G1h/DQ/mbMd5pJZx8xHuLTMwuJD8=;
        b=lotvLR/SrukF0Cej719fV4B+1Iq+dsXWDOkAbZHUfleFG1x+HyBp5JaDaLENu7xqz1
         0DsxtZTS71O+snkB1fGsS6eq4lV2KUDScNWMkCFcb+7bSiszzyrBnKNK5+vwAwulXxXs
         M64PQrQfP/+70rUSjBv3BGAfRDUlqi4y4ZK1G0c51drQux03Kxi7Qjg4TRXKNtzpQptZ
         D2weSbXWUAaNjYCO4HIoBmHSgawboHF3IH2HqJ55xjSe8FCGDHsrmcso7cdDl5a3ipos
         LaapD6CEHS4lzKUhYCcOsdn2Eq+9Gz9ric+JTnXLDat7PuMeQXCWqMTY1C5gU3uyPhEa
         hi5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1P6t73TdrKue96+G1h/DQ/mbMd5pJZx8xHuLTMwuJD8=;
        b=mDgcakqRrOoBaxhPUyoT8hi7GQ9645chtHEM0y36onv0TGaMVjQckTX8o+mc0FJEyt
         zZ7IcDp7EqbqxJCb0JckOQC/rA+VN7PP/SogkkSi7geuHimejgB310AeZxcv/U+s/jjK
         qtNgQ8TX6vag4DgQraFQVhQmNKAaihiWEo7UE02MMxAPmPAUJyOa2udlRN+Yh/d1Og6T
         /u3cqtNU9EWWS4Kjm2ihqpI30+k59KXa4Dx8r5H5Ri35S2w9kPDDkqTapCxZoLJusAFt
         O1IsK+lv/1+rmEI9jC+gZDG/Tlw9ULIMmf8Piq+cuG5hgJKC095DEiZ2hCt2rOgQUh8N
         RPSA==
X-Gm-Message-State: AOAM532pB+fqYctk3Z18B8ZLJOWSbP9Y3oNFPaj3hF6uSNSRNsYbuODo
        1mbIfZkiNxBhueLH05kTk6Xgfb60bx0=
X-Google-Smtp-Source: ABdhPJxgFo7tGJGULlr4sJajKghVRPEZRUrUcm+D+Mt4MQX9QvRS61dFZ/o3HUygaBpipSGx/YGGmg==
X-Received: by 2002:a17:90b:1c82:: with SMTP id oo2mr7406625pjb.53.1634229141782;
        Thu, 14 Oct 2021 09:32:21 -0700 (PDT)
Received: from [192.168.254.55] ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id j126sm3072194pfd.113.2021.10.14.09.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 09:32:21 -0700 (PDT)
Message-ID: <10e8c5b435c3d19d062581b31e34de8e8511f75d.camel@gmail.com>
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
From:   James Prestwood <prestwoj@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Thu, 14 Oct 2021 09:29:05 -0700
In-Reply-To: <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
         <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, 2021-10-13 at 16:37 -0700, Jakub Kicinski wrote:
> On Wed, 13 Oct 2021 15:27:07 -0700 James Prestwood wrote:
> > This change introduces a new sysctl parameter, arp_evict_nocarrier.
> > When set (default) the ARP cache will be cleared on a NOCARRIER
> > event.
> > This new option has been defaulted to '1' which maintains existing
> > behavior.
> > 
> > Clearing the ARP cache on NOCARRIER is relatively new, introduced
> > by:
> > 
> > commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
> > Author: David Ahern <dsahern@gmail.com>
> > Date:   Thu Oct 11 20:33:49 2018 -0700
> > 
> >     net: Evict neighbor entries on carrier down
> > 
> > The reason for this changes is to prevent the ARP cache from being
> > cleared when a wireless device roams. Specifically for wireless
> > roams
> > the ARP cache should not be cleared because the underlying network
> > has not
> > changed. Clearing the ARP cache in this case can introduce
> > significant
> > delays sending out packets after a roam.
> > 
> > A user reported such a situation here:
> > 
> > https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/
> > 
> > After some investigation it was found that the kernel was holding
> > onto
> > packets until ARP finished which resulted in this 1 second delay.
> > It
> > was also found that the first ARP who-has was never responded to,
> > which is actually what caues the delay. This change is more or less
> > working around this behavior, but again, there is no reason to
> > clear
> > the cache on a roam anyways.
> > 
> > As for the unanswered who-has, we know the packet made it OTA since
> > it was seen while monitoring. Why it never received a response is
> > unknown.
> > 
> > Signed-off-by: James Prestwood <prestwoj@gmail.com>
> 
> Seems sensible at a glance, some quick feedback.
> 
> Please make sure you run ./scripts/get_maintainers.pl on the patch
> and add appropriate folks to CC.
> 
> Please rebase the code on top of this tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
> 
> > diff --git a/include/linux/inetdevice.h
> > b/include/linux/inetdevice.h
> > index 53aa0343bf69..63180170fdbd 100644
> > --- a/include/linux/inetdevice.h
> > +++ b/include/linux/inetdevice.h
> > @@ -133,6 +133,7 @@ static inline void ipv4_devconf_setall(struct
> > in_device *in_dev)
> >  #define IN_DEV_ARP_ANNOUNCE(in_dev)    IN_DEV_MAXCONF((in_dev),
> > ARP_ANNOUNCE)
> >  #define IN_DEV_ARP_IGNORE(in_dev)      IN_DEV_MAXCONF((in_dev),
> > ARP_IGNORE)
> >  #define IN_DEV_ARP_NOTIFY(in_dev)      IN_DEV_MAXCONF((in_dev),
> > ARP_NOTIFY)
> > +#define IN_DEV_ARP_EVICT_NOCARRIER(in_dev)
> > IN_DEV_CONF_GET((in_dev), ARP_EVICT_NOCARRIER)
> 
> IN_DEV_ANDCONF() makes most sense, I'd think.

So given we want '1' as the default as well as the ability to toggle
this option per-netdev I thought this was more appropriate. One caviat
is this would not work for setting ALL netdev's, but I don't think this
is a valid use case; or at least I can't imagine why you'd want to ever
do this.

This is a whole new area to me though, so if I'm understanding these
macros wrong please educate me :)

> 
> >  struct in_ifaddr {
> >         struct hlist_node       hash;
> 
> > diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> > index 922dd73e5740..50cfe4f37089 100644
> > --- a/net/ipv4/arp.c
> > +++ b/net/ipv4/arp.c
> > @@ -1247,6 +1247,7 @@ static int arp_netdev_event(struct
> > notifier_block *this, unsigned long event,
> >  {
> >         struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> >         struct netdev_notifier_change_info *change_info;
> > +       struct in_device *in_dev = __in_dev_get_rcu(dev);
> 
> Don't we need to hold the RCU lock to call this?

I was wondering that as well. It seems to be used in some places and
not others. Maybe the caller locked prior in places where there was no
lock, I'll look further into it.

> 
> >         switch (event) {
> >         case NETDEV_CHANGEADDR:
> > @@ -1257,7 +1258,8 @@ static int arp_netdev_event(struct
> > notifier_block *this, unsigned long event,
> >                 change_info = ptr;
> >                 if (change_info->flags_changed & IFF_NOARP)
> >                         neigh_changeaddr(&arp_tbl, dev);
> > -               if (!netif_carrier_ok(dev))
> > +               if (IN_DEV_ARP_EVICT_NOCARRIER(in_dev) &&
> > +                   !netif_carrier_ok(dev))
> >                         neigh_carrier_down(&arp_tbl, dev);
> >                 break;
> >         default:


