Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06CCC13EF
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 10:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfI2Ib3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 04:31:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35299 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfI2Ib3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 04:31:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so6386148lji.2;
        Sun, 29 Sep 2019 01:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kdg/X1gRFWrRcjXeopdKgWFJCbdlHG/7tw/5ynKD8NM=;
        b=KBpWBZhA1HI60TphaSFN6NGXpCo5zpNdI/H7EbzP/LwfDtiT2s60gNgxvzvugOmmc1
         rDcWLBhA4qRzeIB/UYr1/GrwgBfjcu/i5jWoHVowEDHUWEnCT2ZXgwzI2QuT/8ps1WBP
         N6FF3sIgdpHxsZu/heA4MRrhKuzXsIK5AMld4kBiBTP52FG+tKRzuWTcs600ICS5juJ3
         hjngsvQLw15YDCiU9SGpxM1+xAeyqfhppKOEvoiuFJZtaNrNCdREpt/nybHbyASFPmPF
         bSuRzoOxulQ0jSx8/8Q6j0miQt1LpXNsfHwCxuoua1TxAkNPKCuDNc7vzI36F7xejfgS
         2UCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kdg/X1gRFWrRcjXeopdKgWFJCbdlHG/7tw/5ynKD8NM=;
        b=UAMI+4adBEKIWZobJY0+Js/tGKEPHn1rYAZYhU/hxrTFoBfid7ejdC7iifLiu6D/1M
         Apa4p5IvBzL5icFySr640J+OjKHbBFVpf7pqL9lIIJAjSB4sgayTmN5bnbNaBanAkAaq
         /POJuh5681boEInH8tO/cRdY4HoM/VROwVEgS8HNmMaLh6/HTsWNxt5+UKc1uOzKnSEd
         863OrvzusIa9Dj0uvwWkl30307aFTmmsjh4gBgXzSnOoE920bre9UhxQUwxsaB2L9lQu
         snUskq6JSdTxQmD3rWO+o5qVJOmwMw5GiC3YDjx6ndP+euxE7PCjkcv+Kh5mst9DQCbV
         jOcQ==
X-Gm-Message-State: APjAAAX8ozosFYjr0kbl+gVu2UwzrooiEdB9M325qeOmkX25O92TVhVM
        XJtineTraZps63eYthH2+GTkDZsc2WrDzEP8Lc4=
X-Google-Smtp-Source: APXvYqy9MLPg9uoPt91au00rfc5HZxwlQkH2JaQzACuIld+jNMM26xwAyZrIPkCoicj2S3nV1oUL243lNzYB3rLWMyY=
X-Received: by 2002:a2e:8616:: with SMTP id a22mr2921297lji.6.1569745886863;
 Sun, 29 Sep 2019 01:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <2e836018c7ea299037d732e5138ca395bd1ae50f.camel@sipsolutions.net>
In-Reply-To: <2e836018c7ea299037d732e5138ca395bd1ae50f.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 29 Sep 2019 17:31:15 +0900
Message-ID: <CAMArcTWs3wzad7ai_zQPCwzC62cFp-poELn+jnDaP7eT1a9ucw@mail.gmail.com>
Subject: Re: [PATCH net v4 00/12] net: fix nested device bugs
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Sep 2019 at 04:20, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>
> > VLAN, BONDING, TEAM, MACSEC, MACVLAN, IPVLAN, VIRT_WIFI and VXLAN.
> > But I couldn't test all interface types so there could be more device
> > types which have similar problems.
>
> Did you test virt_wifi? I don't see how it *doesn't* have the nesting
> problem, and you didn't change it?
>
> No, I see. You're limiting the nesting generally now in patch 1, and the
> others are just lockdep fixups (I guess it's surprising virt_wifi
> doesn't do this at all?).

virt_wifi case is a little bit different case.
I add the last patch that is to fix refcnt leaks in the virt_wifi module.
The way to fix this is to add notifier routine.
The notifier routine could delete lower device before deleting
virt_wifi device.
If virt_wifi devices are nested, notifier would work recursively.
At that time, it would make stack memory overflow.

Actually, before this patch, virt_wifi doesn't have the same problem.
So, I will update a comment in a v5 patch.

>
> FWIW I don't think virt_wifi really benefits at all from stacking, so we
> could just do something like
>
> --- a/drivers/net/wireless/virt_wifi.c
> +++ b/drivers/net/wireless/virt_wifi.c
> @@ -508,6 +508,9 @@ static int virt_wifi_newlink(struct net *src_net, struct net_device *dev,
>         else if (dev->mtu > priv->lowerdev->mtu)
>                 return -EINVAL;
>
> +       if (priv->lowerdev->ieee80211_ptr)
> +               return -EINVAL;
> +
>         err = netdev_rx_handler_register(priv->lowerdev, virt_wifi_rx_handler,
>                                          priv);
>         if (err) {
>

Many other devices use this way to avoid wrong nesting configuration.
And I think it's a good way.
But we should think about the below configuration.

vlan5
   |
virt_wifi4
   |
vlan3
   |
virt_wifi2
   |
vlan1
   |
dummy0

That code wouldn't avoid this configuration.
And all devices couldn't avoid this config.
I have been considering this case, but I couldn't make a decision yet.
Maybe common netdev function is needed to find the same device type
 in their graph.

>
>
> IMHO, but of course generally limiting the stack depth is needed anyway
> and solves the problem well enough for virt_wifi.
>
>

This is a little bit different question for you.
I found another bug in virt_wifi after my last patch.
Please test below commands
    ip link add dummy0 type dummy
    ip link add vw1 link dummy0 type virt_wifi
    ip link add vw2 link vw1 type virt_wifi
    modprobe -rv virt_wifi

Then, you can see the warning messages.
If SET_NETDEV_DEV() is deleted in the virt_wifi_newlink(),
you can avoid that warning message.
But I'm not sure about it's safe to remove that.
I would really appreciate it if you let me know about that.

> johannes
>
