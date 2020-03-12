Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C657183CA5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgCLWij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:38:39 -0400
Received: from hs2.cadns.ca ([149.56.24.197]:32760 "EHLO hs2.cadns.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgCLWij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 18:38:39 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        by hs2.cadns.ca (Postfix) with ESMTPSA id 9E94784605C
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 18:38:36 -0400 (EDT)
Authentication-Results: hs2.cadns.ca;
        spf=pass (sender IP is 209.85.210.53) smtp.mailfrom=sriram.chadalavada@mindleap.ca smtp.helo=mail-ot1-f53.google.com
Received-SPF: pass (hs2.cadns.ca: connection is authenticated)
Received: by mail-ot1-f53.google.com with SMTP id a49so5324452otc.11
 for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 15:38:36 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1OlwTHrnuh67Xc041wtmrGkVV4GpW2buGDZgYya0zeLII+W24O
 8L3kU+wvsNyvvELBlO3FjMRXNNrbE8TG5nKNuJU=
X-Google-Smtp-Source: ADFU+vvMMKB24Jrj7H8FPlRGSOOwLF2yE+3ifnSDWP1vcSOSQ1Cw+PhFhEsJRQym0jNBs5LaVMSLnxSnXEquwwwIRGM=
X-Received: by 2002:a05:6830:4035:: with SMTP id
 i21mr7953703ots.348.1584052715964; 
 Thu, 12 Mar 2020 15:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAOK2joFxzSETFgHX7dRuhWPVSSEYswJ+-xfSxbPr5n3LcsMHzw@mail.gmail.com>
 <20200305225115.GC25183@lunn.ch>
In-Reply-To: <20200305225115.GC25183@lunn.ch>
From:   Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Date:   Thu, 12 Mar 2020 18:38:24 -0400
X-Gmail-Original-Message-ID: <CAOK2joHQRaBaW0_xexZLTp432ByvC6uhgJvjsY8t3HNyL9GUwg@mail.gmail.com>
Message-ID: <CAOK2joHQRaBaW0_xexZLTp432ByvC6uhgJvjsY8t3HNyL9GUwg@mail.gmail.com>
Subject: Re: Information on DSA driver initialization
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-PPP-Message-ID: <20200312223837.11856.62080@hs2.cadns.ca>
X-PPP-Vhost: mindleap.ca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
   Thank you for your response.

  Yes. There are patches applied.  I did scatter printks/pr_info but
don't see anything yet from the Marvell 6176 switch without
CONFIG_NET_DSA_LEGACY enabled.

    One question I have is if CONFIG_NET_DSA_LEGACY is NOT selected,
what in the 4.19 kernel takes over the function of dsa_probe function
in net/dsa/legacy.c and mv88e6xxx_drv_probe in
drivers/net/dsa/mv88e6xxx/chip.c ?

- Sriram




On Thu, Mar 5, 2020 at 5:51 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Mar 05, 2020 at 05:24:47PM -0500, Sriram Chadalavada wrote:
> > Is there information in kernel documentation or elsewhere about DSA
> > initialization process starting from the device tree parse to the
> > Marvell switch being detected?
> >
> > The specific problem I'm facing is that while I see this:
> > root@SDhub:/# dmesg | grep igb
> > [ 1.314324] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
> > [ 1.314332] igb: Copyright (c) 2007-2014 Intel Corporation.
> > [ 1.314679] igb 0000:03:00.0: enabling device (0140 -> 0142)
> > [ 1.343926] igb 0000:03:00.0: added PHC on eth0
> > [ 1.343938] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
> > [ 1.343949] igb 0000:03:00.0: eth0: (PCIe:2.5Gb/s:Width x1) c4:48:38:00:63:eb
> > [ 1.344019] igb 0000:03:00.0: eth0: PBA No: 000300-000
> > [ 1.344030] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s), 4
> > tx queue(s)
> > [ 1.344464] libphy: igb_enet_mii_bus: probed
> >
> > I do NOT see this in the log:
> > [ 1.505474] libphy: mdiobus_find: mii bus [igb_enet_mii_bus] found
> > [ 1.645075] igb 0000:03:00.0 eth0: [0]: detected a Marvell 88E6176 switch
> > [ 24.341748] igb 0000:03:00.0 eth0: igb_enet_mii_probe starts
> > [ 24.344928] igb 0000:03:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps
> > Full Duplex, Flow Control: RX/TX
> >
> > Any suggestions/speculations what may be going on here?
>
> I think you have some patches applied here, because i don't think igb
> supports linux mdio. It has its own implementation.
>
> Assuming that is what you have, the probe of the switch normally fails
> the first time. Generally, the mdio bus is registered before the
> network interface. So when the switch tried to lookup the ethernet
> interface, it does not exist. -EPROBE_DEFFER is returned. The core
> will then try again, by which time the interfaces does exist.
>
> You probably want to scatter some printk() in the code to see what is
> happening.
>
>         Andrew
