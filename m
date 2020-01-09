Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189D4135E0F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 17:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733059AbgAIQTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 11:19:17 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43010 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbgAIQTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 11:19:16 -0500
Received: by mail-pl1-f193.google.com with SMTP id p27so2738546pli.10
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 08:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fvXjjGfX/0aEoaa+z96ocToPdOyz4XVCqqYcAqf7xY8=;
        b=U8HbGedleEZxd8pBvzlhQudi8nGy6k+yAIwWVawzrT9KXxyQmj85iOyDbSueBg2bi8
         dbIMSi9oZ61AOxKZXak6cL0k6iJFZ3z7JbfF8pTjOPcTEp/3+Ily0lyUPCFfEsrCMbcK
         jYYMG56vRgeEHTQPqwV2IWdtdXQnL5l9/gpNoGbJZ22cBaDYxOqUkVyDjNirti3Xatnq
         TTsHrB4VovbCgJ/hcdpP5B2Wc6olLve2X0j6a0Nx9dYY3BylTrXva5mx5+cEnSLsHz+W
         gnZlkBHgNaKEK4/SEA9QapdTjhiPlqfRx4dPKni2eze66k7dUVEf0XpnYrvK2FI1OoQP
         EM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fvXjjGfX/0aEoaa+z96ocToPdOyz4XVCqqYcAqf7xY8=;
        b=l+dFdDPxyaJIgbTaV8ZDk+svglOF+XYBNyhTLQuF1ga6bwVUNH0j6b6PcYBpJWDuY7
         gYcHsFAmiQ2444eZDQGqGReROuSa38ESHb86urzphTrVeSI/4Suzvjb0yqbybgakKqeA
         vwQyDzURjroLCR/tILAzVKkNJxnkLSHgiz4d4OTs45GbTR5XZutgXU7BFZtDAJmav7aa
         2sKQ6tMSb9oEt1l+ucH1WdKCfmtnh9loaeKujtNeGbNvXrrxHrn2WPoK9Va2MVTT5rUP
         zi2kmv4sqKKQk//pr39Rjz7ZTZQvGY5i5N/rV+FJzhGqgRufDPLWYLi5u9aEeC9ZQlCH
         afsg==
X-Gm-Message-State: APjAAAULNj0PB2a6k1Lup6OQtyLV/ydjhaXMjbHkWULqBVpQrdDDWXc6
        fFjYuFbXDjwF0y+2fO/bgkInBQ==
X-Google-Smtp-Source: APXvYqzNNDhp6g7WvuAaM9xpP0y6XC4pB4Rs3KBf6REubmvhIR+wffAL55NEmJVFZdXetgj2Pg0GRg==
X-Received: by 2002:a17:902:b498:: with SMTP id y24mr11984010plr.97.1578586755478;
        Thu, 09 Jan 2020 08:19:15 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u26sm7910317pfn.46.2020.01.09.08.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 08:19:15 -0800 (PST)
Date:   Thu, 9 Jan 2020 08:19:07 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <jakub.kicinski@netronome.com>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <olteanv@gmail.com>, <anirudh.venkataramanan@intel.com>,
        <dsahern@gmail.com>, <jiri@mellanox.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch 0/3] net: bridge: mrp: Add support for
 Media Redundancy Protocol(MRP)
Message-ID: <20200109081907.06281c0f@hermes.lan>
In-Reply-To: <20200109150640.532-1-horatiu.vultur@microchip.com>
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jan 2020 16:06:37 +0100
Horatiu Vultur <horatiu.vultur@microchip.com> wrote:

> Media Redundancy Protocol is a data network protocol standardized by
> International Electrotechnical Commission as IEC 62439-2. It allows rings of
> Ethernet switches to overcome any single failure with recovery time faster than
> STP. It is primarily used in Industrial Ethernet applications.
> 
> This is the first proposal of implementing a subset of the standard. It supports
> only 2 roles of an MRP node. It supports only Media Redundancy Manager(MRM) and
> Media Redundancy Client(MRC). In a MRP ring, each node needs to support MRP and
> in a ring can be only one MRM and multiple MRC. It is possible to have multiple
> instances of MRP on a single node. But a port can be part of only one MRP
> instance.
> 
> The MRM is responsible for detecting when there is a loop in the ring. It is
> sending the frame MRP_Test to detect the loops. It would send MRP_Test on both
> ports in the ring and if the frame is received at the other end, then the ring
> is closed. Meaning that there is a loop. In this case it sets the port state to
> BLOCKED, not allowing traffic to pass through except MRP frames. In case it
> stops receiving MRP_Test frames from itself then the MRM will detect that the
> ring is open, therefor it would notify the other nodes of this change and will
> set the state of the port to be FORWARDING.
> 
> The MRC is responsible for forwarding MRP_Test frames between the ring ports
> (and not to flood on other ports) and to listen when there is a change in the
> network to clear the FDB.
> 
> Similar with STP, MRP is implemented on top of the bridge and they can't be
> enable at the same time. While STP runs on all ports of the bridge, MRP needs to
> run only on 2 ports.
> 
> The bridge needs to:
> - notify when the link of one of the ports goes down or up, because MRP instance
>   needs to react to link changes by sending MRP_LinkChange frames.
> - notify when one of the ports are removed from the bridge or when the bridge
>   is destroyed, because if the port is part of the MRP ring then MRP state
>   machine should be stopped.
> - add a handler to allow MRP instance to process MRP frames, if MRP is enabled.
>   This is similar with STP design.
> - add logic for MRP frames inside the bridge. The bridge will just detect MRP
>   frames and it would forward them to the upper layer to allow to process it.
> - update the logic to update non-MRP frames. If MRP is enabled, then look also
>   at the state of the port to decide to forward or not.
> 
> To create a MRP instance on the bridge:
> $ bridge mrp add dev br0 p_port eth0 s_port eth1 ring_role 2 ring_id 1
> 
> Where:
> p_port, s_port: can be any port under the bridge
> ring_role: can have the value 1(MRC - Media Redundancy Client) or
>            2(MRM - Media Redundancy Manager). In a ring can be only one MRM.
> ring_id: unique id for each MRP instance.
> 
> It is possible to create multiple instances. Each instance has to have it's own
> ring_id and a port can't be part of multiple instances:
> $ bridge mrp add dev br0 p_port eth2 s_port eth3 ring_role 1 ring_id 2
> 
> To see current MRP instances and their status:
> $ bridge mrp show
> dev br0 p_port eth2 s_port eth3 ring_role 1 ring_id 2 ring_state 3
> dev br0 p_port eth0 s_port eth1 ring_role 2 ring_id 1 ring_state 4
> 
> If this patch series is well received, the in the future it could be extended
> with the following:
> - add support for Media Redundancy Automanager. This role allows a node to
>   detect if needs to behave as a MRM or MRC. The advantage of this role is that
>   the user doesn't need to configure the nodes each time they are added/removed
>   from a ring and it adds redundancy to the manager.
> - add support for Interconnect rings. This allow to connect multiple rings.
> - add HW offloading. The standard defines 4 recovery times (500, 200, 30 and 10
>   ms). To be able to achieve 30 and 10 it is required by the HW to generate the
>   MRP_Test frames and detect when the ring is open/closed.
> 
> Horatiu Vultur (3):
>   net: bridge: mrp: Add support for Media Redundancy Protocol
>   net: bridge: mrp: Integrate MRP into the bridge
>   net: bridge: mrp: Add netlink support to configure MRP
> 
>  include/uapi/linux/if_bridge.h |   27 +
>  include/uapi/linux/if_ether.h  |    1 +
>  include/uapi/linux/rtnetlink.h |    7 +
>  net/bridge/Kconfig             |   12 +
>  net/bridge/Makefile            |    2 +
>  net/bridge/br.c                |   19 +
>  net/bridge/br_device.c         |    3 +
>  net/bridge/br_forward.c        |    1 +
>  net/bridge/br_if.c             |   10 +
>  net/bridge/br_input.c          |   22 +
>  net/bridge/br_mrp.c            | 1517 ++++++++++++++++++++++++++++++++
>  net/bridge/br_mrp_timer.c      |  227 +++++
>  net/bridge/br_netlink.c        |    9 +
>  net/bridge/br_private.h        |   30 +
>  net/bridge/br_private_mrp.h    |  208 +++++
>  security/selinux/nlmsgtab.c    |    5 +-
>  16 files changed, 2099 insertions(+), 1 deletion(-)
>  create mode 100644 net/bridge/br_mrp.c
>  create mode 100644 net/bridge/br_mrp_timer.c
>  create mode 100644 net/bridge/br_private_mrp.h
> 

Can this be implemented in userspace?

Putting STP in the kernel was a mistake (even original author says so).
Adding more control protocols in kernel is a security and stability risk.
