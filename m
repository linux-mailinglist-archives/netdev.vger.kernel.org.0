Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E653E8696
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 01:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhHJXe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 19:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbhHJXeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 19:34:24 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B040C061765;
        Tue, 10 Aug 2021 16:34:01 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id by4so756114edb.0;
        Tue, 10 Aug 2021 16:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dz63oFqB23ZK7oXauEgmlAa45wZtmY16ciHcDqSX5T0=;
        b=JDi1GreUPpndfLX1Yb2K6N5skJqc1Hs4+cPB6+3LFT/Je0Pqpwh/mZajldBUtBfzPb
         CgJTINtaDcVxewInSL6ZP4tCBzF1sKwOFwOwux8/JK9YDEiLEKcXiSm5lG43gO/+6gCy
         le47d/3DkVNWvfVk2q8MsxfQo+cvSIV1IYe1vkqqxyzymgG1RMNLhIvhrfqGtDAWLUqk
         16MDbX6XoQniCoV9wEwnkQx+xRbggj688NXDx1DjBZOU1v5OC9FmMYa9j1kAfRqvk2Fj
         k6okWrXB36/0skAbs4vJD6JAyZwbQsJ/VhAty1dBW7IRa375/J8kVzqA7jUaQNLRyFgq
         WozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dz63oFqB23ZK7oXauEgmlAa45wZtmY16ciHcDqSX5T0=;
        b=GW04RMxqvYV+r8B5HgIrFb1clxtbzbHjssno7rqB6tgbq66PvSiDMqvFvNrnfb9ebw
         AOLpVDfwrxZB78qd184gOZyWjVF5gwmaXk+8V17v82t7WdQAzb5J6+Oix1hYI2mrJojN
         tAOXC/rhgs3uOiqLTV5dHyUhMuJ4PVa9GtkPHguVrGKWpmxbSvcbXp/Q19XNqIMdIokK
         vHLEBRvE8d/6NCbS+bqbpnfi3C3uYag/0/caZQl1ccpZQZQftwIW1tpydRXwbybS7aya
         Y9M8TlIdABAnDQI9u6dWcv4V4W1ucpu/yvX9cw6o7fdEw8jFOFnv1u/V809nS2iLKb5q
         LWtg==
X-Gm-Message-State: AOAM531nDLc9z/C7Lu933mDuAoqPyr4ZJnRA2wovgEzN6bfgi4H8I61x
        J8EqvXiOnHOnQ9ywLyz/QVA=
X-Google-Smtp-Source: ABdhPJwtOwZjlzZPd2Y88RGJbB5FxL99YfFlYWCefmRD3kWouhAsmZwoefdz4CDUAftrRJzbOa3B8Q==
X-Received: by 2002:a05:6402:35d2:: with SMTP id z18mr7994056edc.282.1628638440186;
        Tue, 10 Aug 2021 16:34:00 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id ov4sm7377510ejb.122.2021.08.10.16.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 16:33:59 -0700 (PDT)
Date:   Wed, 11 Aug 2021 02:33:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andre Valentin <avalentin@marcant.net>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>
Subject: Re: [RFC net-next 2/3] net: dsa: qca8k: enable assisted learning on
 CPU port
Message-ID: <20210810233358.aqicu4mm75zacr3v@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com>
 <20210807120726.1063225-3-dqfext@gmail.com>
 <20210807222555.y6r7qxhdyy6d3esx@skbuf>
 <20210808160503.227880-1-dqfext@gmail.com>
 <0072b721-7520-365d-26ef-a2ad70117ac2@marcant.net>
 <20210810175324.ijodmycvxfnwu4yf@skbuf>
 <7af5c79e-fe18-a6fa-4282-1aa2bee187d6@marcant.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7af5c79e-fe18-a6fa-4282-1aa2bee187d6@marcant.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 11:09:07PM +0200, Andre Valentin wrote:
> Am 10.08.21 um 19:53 schrieb Vladimir Oltean:
> > On Tue, Aug 10, 2021 at 07:27:05PM +0200, Andre Valentin wrote:
> >> On Sun, Aug 08, 2021 at 1805, DENG Qingfang wrote:
> >>> On Sun, Aug 08, 2021 at 01:25:55AM +0300, Vladimir Oltean wrote:
> >>>> On Sat, Aug 07, 2021 at 08:07:25PM +0800, DENG Qingfang wrote:
> >>>>> Enable assisted learning on CPU port to fix roaming issues.
> >>>>
> >>>> 'roaming issues' implies to me it suffered from blindness to MAC
> >>>> addresses learned on foreign interfaces, which appears to not be true
> >>>> since your previous patch removes hardware learning on the CPU port
> >>>> (=> hardware learning on the CPU port was supported, so there were no
> >>>> roaming issues)
> >>
> >> The issue is with a wifi AP bridged into dsa and previously learned
> >> addresses.
> >>
> >> Test setup:
> >> We have to wifi APs a and b(with qca8k). Client is on AP a.
> >>
> >> The qca8k switch in AP b sees also the broadcast traffic from the client
> >> and takes the address into its fdb.
> >>
> >> Now the client roams to AP b.
> >> The client starts DHCP but does not get an IP. With tcpdump, I see the
> >> packets going through the switch (ap->cpu port->ethernet port) and they
> >> arrive at the DHCP server. It responds, the response packet reaches the
> >> ethernet port of the qca8k, and is not forwarded.
> >>
> >> After about 3 minutes the fdb entry in the qca8k on AP b is
> >> "cleaned up" and the client can immediately get its IP from the DHCP server.
> >>
> >> I hope this helps understanding the background.
> > 
> > How does this differ from what is described in commit d5f19486cee7
> > ("net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign
> > bridge neighbors")?
> > 
> I lost a bit, It is a bit different.
> 
> I've been also working a bit on the ipq807x device with such a switch on
> OpenWRT. There is a backport of that commit. To fix the problems described
> by d5f19486cee7, I enabled assisted_learning on qca8k. And it solves the
> problem.
> 
> But initially, the device was unreachable until I created traffic from the device
> to a client (cpu port->ethernet). At first, I did not notice this because a wifi client
> with it's traffic immediately solved the issue automatically.
> Later I verified this in detail.
> 
> Hopefully DENG Qingfang patches help. But I cannot proove atm.

I don't understand. You're saying that when the device sends a packet
from its new position, the switch learns it on the CPU port, and that
fixes the issue?

Isn't that always how issues like that get fixed? If hardware learning
is supported on the CPU port, it is no different than a device roaming
from one switch port to another (but isn't directly connected to that
switch port, otherwise the switch might fast age the port when the
device roams) - it is inaccessible until it says something.

I still have no idea what we're talking about, and why this patch is
necessary. Does the qca8k switch support hardware learning on the CPU
port or not?
