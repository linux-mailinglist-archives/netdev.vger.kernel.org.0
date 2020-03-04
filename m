Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3E7178AC8
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 07:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgCDGpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 01:45:13 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46762 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgCDGpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 01:45:13 -0500
Received: by mail-qt1-f195.google.com with SMTP id x21so529121qto.13
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 22:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=9OA9xPXvl39NvBtEJKFog/ZMktpcV46LJR8DPKaeTbw=;
        b=quB341FSHfwRspYpO4ntPoXWjOlBFuzlR6r2QRRmujy2Hme1IfNuf6Qn0Lj9EHZQH9
         AQB8K5iHFVhuTP+y2m8AUlwLoDUjmIcgP8CFo9yGh2I0/NPFG3fBYqCApotGrnvyZYc6
         Lf5r17wBD+k8KokLOQuEZRmYQCviffZY01TH9URfZERFhWxd/xVPl4t9775FvIiZ+5ex
         taVdhUFm5u2wiP7Et0vVExt8pMcqug6IA3LW9Q5eDcFY7RUnixWpxuOb+kVRDEKncDDW
         /WDND/Nk6gLW+xh00qN5zTWf8Q0DN4DzEKkUfEZxaeJIUeSrjVyTSWj0ABvDA5wEg53p
         w5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=9OA9xPXvl39NvBtEJKFog/ZMktpcV46LJR8DPKaeTbw=;
        b=aVaN5eNN3L4MXaPBPonkx1U5IvDAlZZ9AgAupLzveG1fBFaC4xjjQDFEQhYKy0aibt
         TEJU6XZhkWGhRq8UgC9VbH/XyB+VYW00/W9I7zmqpWdOigTSYqD5g0Cd7K+UEUSzulh1
         vUcGficxF4TkDKnU4/Nz9kbMKM1dRsI1wInpoHenRPps5vxRiaiZKhOYpp64dkDs3XZM
         33/t9oU4n6CYDPu1ycm3wfHirINiQhYKPwOEUjaJOD/g1DLUIGc4mMUrbG3coftX+18v
         gocorekENN6P/kJWbDWY4xMsLab+M8MX8BCmNEkRBdPy7imhrALrMIT0gB6q90TCln8V
         XOUg==
X-Gm-Message-State: ANhLgQ2YELn6oN67FxyzWXSpNfRMk5iF80/OO6vHOd94LgyjVE6QNfxp
        J+0EGCrLG2roYT6JWVywPylMjnVpM9Q=
X-Google-Smtp-Source: ADFU+vvCuAfdI+9/PYri6KgWhGn9N/VzDdXmZQawPwYc+9X00jZ2rcaapS8/egCWFJopjIrrX8a6Xg==
X-Received: by 2002:ac8:4993:: with SMTP id f19mr1137749qtq.305.1583304312278;
        Tue, 03 Mar 2020 22:45:12 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f12sm5172299qkm.13.2020.03.03.22.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 22:45:11 -0800 (PST)
Date:   Wed, 4 Mar 2020 14:45:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 10:23:12AM +0100, Rafał Miłecki wrote:
> On 03.03.2020 10:11, Hangbin Liu wrote:
> > On Tue, Mar 03, 2020 at 05:00:35PM +0800, Hangbin Liu wrote:
> > > On Tue, Mar 03, 2020 at 07:16:44AM +0100, Rafał Miłecki wrote:
> > > > It appears that every interface up & down sequence results in adding a
> > > > new ff02::2 entry to the idev->mc_tomb. Doing that over and over will
> > > > obviously result in running out of memory at some point. That list isn't
> > > > cleared until removing an interface.
> > > 
> > > Thanks Rafał, this info is very useful. When we set interface up, we will
> > > call ipv6_add_dev() and add in6addr_linklocal_allrouters to the mcast list.
> > > But we only remove it in ipv6_mc_destroy_dev(). This make the link down save
> > > the list and link up add a new one.
> > > 
> > > Maybe we should remove the list in ipv6_mc_down(). like:
> > 
> > Or maybe we just remove the list in addrconf_ifdown(), as opposite of
> > ipv6_add_dev(), which looks more clear.
> > 
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index 164c71c54b5c..4369087b8b74 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -3841,6 +3841,12 @@ static int addrconf_ifdown(struct net_device *dev, int how)
> >                  ipv6_ac_destroy_dev(idev);
> >                  ipv6_mc_destroy_dev(idev);
> >          } else {
> > +               ipv6_dev_mc_dec(dev, &in6addr_interfacelocal_allnodes);
> > +               ipv6_dev_mc_dec(dev, &in6addr_linklocal_allnodes);
> > +
> > +               if (idev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
> > +                       ipv6_dev_mc_dec(dev, &in6addr_linklocal_allrouters);
> > +
> >                  ipv6_mc_down(idev);
> >          }
> 
> FWIW I can confirm it fixes the problem for me!
> 
> Only one ff02::2 entry is present when removing interface:
> 
> [  105.686503] [ipv6_mc_destroy_dev] idev->dev->name:mon-phy0
> [  105.692056] [ipv6_mc_down] idev->dev->name:mon-phy0
> [  105.696957] [ipv6_mc_destroy_dev -> __mld_clear_delrec] kfree(pmc:c64fd880) ff02::2

Hi Rafał,

When review the code, I got confused. On the latest net code, we only
add the allrouter address to multicast list in function
1) ipv6_add_dev(), which only called when there is no idev. But link down and
   up would not re-create idev.
2) dev_forward_change(), which only be called during forward change, this
   function will handle add/remove allrouter address correctly.

So I still don't know how you could added the ff02::2 on same dev multi times.
Does just do `ip link set $dev down; ip link set $dev up` reproduce your
problem? Or did I miss something?

Thanks
Hangbin
