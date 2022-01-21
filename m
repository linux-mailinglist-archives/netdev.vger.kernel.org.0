Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D77496541
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiAUSur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiAUSuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:50:16 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2338DC06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 10:50:13 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id s13so2526425ejy.3
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 10:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DNRS8Anpj2A3AnDmPfNqzTpLxfMiFhjADv4KSwcHcow=;
        b=XMSkemzpUdeapL7uTq54zathw9/884R4IzutN1UA8avYMdtfpFC1XVk7vIhjUhIioP
         7Pyom5eVfw7CuKtf+qBo93h5OD7jECv0Ec9eGbt5AlTE9Hu4XF6xD2a/A24tzyIJmjCM
         rW+t65sBp0mttfe0MAd//sMlYLf2bMl7K/hplaXZDLVY4iYHNVQwqCVJypJzcufemh58
         bYXVvIrQ3GbsCR0Ts87iLOqjDZyhkoBqsvoZPdb7qO8+nKQbj+h5WaiTKPVYKxnsZ1MA
         uX/V3WM717kKmzIJ9X0eLd1704wl/ZYiVXoeSPzEH3L3OlvjTPyCNbyLCS7cd+v0YR0x
         5m5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DNRS8Anpj2A3AnDmPfNqzTpLxfMiFhjADv4KSwcHcow=;
        b=UNN5aFaMOGSdZWR4z55XVLHMBNdJ4e9moR/4Uxs+0/KIrNMW5C7QZz5Hrs3W75MyG2
         G0dA+/eKc+4HNHEni+jo5MWFjE1nydHnKqLIRSZjSKXFVxJUyKVcJcrNyB3SEdanPG1Q
         Wk6Y7FlZFjpjCoXhgit1DPIr0MMsXRY2I+656GesF8gGsVLKaEKiz8aPoWPYz9Jzy9A0
         OX2BsvdKbwsP5m90Lwg2881DiJh2aGU0EgXJ6gEx9fNYfhn6MmMdxfV3BpWtK3fNC6Jh
         ktE+IqgE6shPGg3glxU/yDIGzBNTcVA0seIDgAxk6bAcVH1O/2Rz3IyFKzld+RUdnp5u
         cKSw==
X-Gm-Message-State: AOAM530BXOOG9AMSmjCwXiltERbADdcL6uA7IHj8By8imlWnDxRG7jqs
        d2jV/hkcxT1yVDMx3+OBtoM=
X-Google-Smtp-Source: ABdhPJyFATJ5tODskkmN4jnwwGqMGZiWYCYwuaBqYQ9fXAnVtSsJtt4mFZAkY0WN5GuJQuU1eEUIgA==
X-Received: by 2002:a17:906:53d5:: with SMTP id p21mr4127326ejo.315.1642791011486;
        Fri, 21 Jan 2022 10:50:11 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id jt14sm2295382ejc.32.2022.01.21.10.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 10:50:10 -0800 (PST)
Date:   Fri, 21 Jan 2022 20:50:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220121185009.pfkh5kbejhj5o5cs@skbuf>
References: <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch>
 <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 12:13:58AM -0300, Luiz Angelo Daros de Luca wrote:
> > :) device tree properties are not the fix for everything!
> 
> I'm still getting used to it ;-)
> 
> In this thread, Alvin suggested adding a new property to define which
> port will be used as trap_port instead of using the last CPU port.
> Should I try something different?
> 
>         switch1 {
>                compatible = "realtek,rtl8367s";
>                reg = <29>;
> 
>                realtek,trap-port = <&port7>;
> 
>                ports {
>                         ....
>                         port7: port@7 {
>                             ...
>                        };
>         };
> 
> Should I do something differently?

To clarify, I don't know what a trap_port is. I just saw this
description in rtl8365mb.c:

 * @trap_port: forward trapped frames to this port

but I still don't know to which packets does this configuration apply
(where are the packet traps installed, and for what kind of packets).

Speculating here, but it appears quite arbitrary, and I'd guess also
broken, to make the trap_port the last CPU port. Is this also part of
the things which you didn't really test? See commit 8d5f7954b7c8 ("net:
dsa: felix: break at first CPU port during init and teardown") for a
similar issue with this. When there are multiple 'ethernet = <&phandle>'
properties in the device tree, DSA makes the owners of all those
phandles a DSA master, and all those switch ports as CPU ports. But out
of all those CPU ports, only the first one is an active CPU port. The
others have no dp->cpu_dp pointing to them.
See dsa_tree_setup_default_cpu() -> dsa_tree_find_first_cpu().
Even when DSA gets full-blown support for multiple CPU ports, I think
it's safe to say that this default will remain the way it is: a single
CPU port will be active to begin with: the first one. Given that fact
(and depending on what you need to do with the trap_port info exactly),
it might be broken to set as the trap port a CPU port that isn't used.
Stuff like dsa_port_host_fdb_add()/dsa_port_host_fdb_del() will be
broken, because they rely on the dp->cpu_dp association, and
dp->cpu_dp->index will be != trap_port.

> > I think I know what the problem is. But I'd need to know what the driver
> > for the DSA master is, to confirm. To be precise, what I'd like to check
> > is the value of master->vlan_features.
> 
> Here it is 0x1099513266227 (I hope).

That's quite an extraordinary set of vlan_features. In that number, I
notice BIT(2) is set, which corresponds to __UNUSED_NETIF_F_1. So it
probably isn't correctly printed.

This is what I would have liked to see:

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 22241afcac81..b41f1b414c69 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1909,6 +1909,7 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	p->xmit = cpu_dp->tag_ops->xmit;
 
 	slave->features = master->vlan_features | NETIF_F_HW_TC;
+	netdev_err(slave, "master %s vlan_features 0x%llx\n", master->name, master->vlan_features);
 	slave->hw_features |= NETIF_F_HW_TC;
 	slave->features |= NETIF_F_LLTX;
 	if (slave->needed_tailroom)

And I don't think you fully answered Florian's questions either, really.
Can we see the a link to the code of the Ethernet controller whose role
is to be a host port (DSA master) for the rtl8365mb switch? If that DSA
master is a DSA switch itself, could you please unroll the chain all the
way with more links to drivers? No matter whether upstream or downstream,
just what you use.

I hate to guess, but since both you and Arınç have mentioned the
mt7620a/mt7621 SoCs, I'd guess that the top-most DSA driver in both
cases is "mediatek,eth-mac" (drivers/net/ethernet/mediatek/mtk_eth_soc.c).
If so, this would confirm my suspicions, since it sets its vlan_features
to include NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. Please confirm that
master->vlan_features contains these 2 bits.

> Oh, this DSA driver still does not implement vlan nor bridge offload.
> Maybe it would matter.

It doesn't matter. The vlan_features is a confusing name for what it
really does here. I'll explain in a bit once you clarify the other
things I asked for.
