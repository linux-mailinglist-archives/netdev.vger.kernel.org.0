Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE8E172BC6
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgB0Wy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:54:29 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:40083 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgB0Wy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 17:54:29 -0500
Received: by mail-lj1-f178.google.com with SMTP id 143so1114564ljj.7
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 14:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=iTU/SDq7uYV9y9In9DkLe5ApMN0GwI2MOYTtzWU5wLU=;
        b=hZEx1khQvYl48qeBhw9XSA7c2v2eP0oWTdsIWsjp2hyZ6lFVqUAgQM7sZYYRwvZPQL
         tfjyFU1CgdDZQPKy/iwwl8xJs4IPgQNVER0ipLjs6PNeu5NLraSFyuAyxqrwBE0MLMvF
         zEmPVUNDPb6DC2tuOz6GzG5H9QDfHo32EIsMsAZ3/U6NvrTBCYbUwf4eqPX/uGSSB0sR
         xmHIJuuaD6CGJ2nmqmcCWpxJ9QZnb+uELhfrB9TLvuzgOrMJxZLDR6M+yEUIAC1FN/Dx
         TmrhrMDJwe8pNrgv3oog6N2uaXw1Q0i2Hoqu32b92zvXHOZCD79mge2FGH+jEqCMFMml
         3/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iTU/SDq7uYV9y9In9DkLe5ApMN0GwI2MOYTtzWU5wLU=;
        b=ZkiUyV5u6lBbOs8UDHc1ueyEa8HzJaIN0qsLvZHM/oMtDO3hzzInP7U2z0SLL+wqgu
         xUz+YWGN/dFkFly1KT6ctGl4neAntu6iviOyRHmwBLjgB/LC2yagifEA5tXQ9ZluW4vl
         trR9YVVVqJOM/r+FBxTR+7hW8+VIHYwcxZDHhCl/W7j+nR+efQ7W0Phkbo3NEoXv6n9r
         aCWMIqaliG9pvOPOLdg+nMcnitzG16b7EXPJ7qZTpBEtenmX615ppUtGqUKu+fvPSXUq
         wBy8m0FHpjJeEGmiK5G1B8g68iUMtETUo7NnuzkVLPctGX4nkurOenrHtmcyLgcycITU
         7TfA==
X-Gm-Message-State: ANhLgQ22WL9fvuKWt0E6euwksQS9pdt5wNAJeTZiwH4R8+qpbicgOOZl
        /xNxZ4OfZk6ZEmLg5pCq+m3UBS4IM0c4CQYUxp0dpQsRms8=
X-Google-Smtp-Source: ADFU+vs0DVTMJkrMkrhXj8mM4rBJjCTRFlzdnbqOUM+WO3/p3S/G7eJ1rcZSNBtL2T1m0LbUbLIuUFzfdfT3XuvDF5Q=
X-Received: by 2002:a2e:9e4c:: with SMTP id g12mr830532ljk.15.1582844067140;
 Thu, 27 Feb 2020 14:54:27 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 27 Feb 2020 14:54:15 -0800
Message-ID: <CAHo-OozeA2Dp_4pRZr84A+nH8pLbM3L26_50enHgPV4HpevpCg@mail.gmail.com>
Subject: ixgbe 2.5 / 5 gbit support works but is not reported as supported/advertised
To:     Linux NetDev <netdev@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

https://www.startech.com/Networking-IO/Adapter-Cards/dual-port-network-card~ST10GPEXNDPI

84:00.0 Ethernet controller [0200]: Intel Corporation Ethernet
Controller 10G X550T [8086:1563] (rev 01)
84:00.1 Ethernet controller [0200]: Intel Corporation Ethernet
Controller 10G X550T [8086:1563] (rev 01)

This card will negotiate 2.5g or 5g if plugged in to a 2.5/5g port on
the other end of a 7ft cat 5e cable.
But it doesn't *claim* to support it.

# ethtool eix1
Settings for eix1:
        Supported ports: [ TP ]
        Supported link modes:   100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
        Supported pause frame use: Symmetric
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 2500Mb/s     <-- or 5000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: Unknown
        Supports Wake-on: d
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes

(note the lack of
                                2500baseT/Full
                                5000baseT/Full
under supported/advertised)

5.2.17-1rodete3-amd64 #1 SMP Debian
[240677.031802] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver
- version 5.1.0-k
[240677.031806] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
[240677.717538] ixgbe 0000:84:00.0: Multiqueue Enabled: Rx Queue count
= 56, Tx Queue count = 56 XDP Queue count = 0
[240677.816262] ixgbe 0000:84:00.0: 31.504 Gb/s available PCIe
bandwidth (8 GT/s x4 link)
[240677.844663] ixgbe 0000:84:00.0: MAC: 4, PHY: 0, PBA No: 000500-000
[240677.844668] ixgbe 0000:84:00.0: 00:0a:...
[240677.994928] ixgbe 0000:84:00.0 eix1: renamed from eth1
[240678.005278] ixgbe 0000:84:00.0: Intel(R) 10 Gigabit Network Connection
[240678.005360] libphy: ixgbe-mdio: probed
[240678.694408] ixgbe 0000:84:00.1: Multiqueue Enabled: Rx Queue count
= 56, Tx Queue count = 56 XDP Queue count = 0
[240678.792505] ixgbe 0000:84:00.1: 31.504 Gb/s available PCIe
bandwidth (8 GT/s x4 link)
[240678.820671] ixgbe 0000:84:00.1: MAC: 4, PHY: 0, PBA No: 000500-000
[240678.820677] ixgbe 0000:84:00.1: 00:0a:...
[240678.970174] ixgbe 0000:84:00.1 eix2: renamed from eth1
[240678.980665] ixgbe 0000:84:00.1: Intel(R) 10 Gigabit Network Connection
[240678.980747] libphy: ixgbe-mdio: probed
[242612.969243] ixgbe 0000:84:00.0: registered PHC device on eix1
[242615.246740] ixgbe 0000:84:00.1: registered PHC device on eix2
[242620.138766] ixgbe 0000:84:00.0 eix1: NIC Link is Up 10 Gbps, Flow
Control: RX/TX
[242620.162687] ixgbe 0000:84:00.1 eix2: NIC Link is Up 10 Gbps, Flow
Control: RX/TX
[242712.081620] ixgbe 0000:84:00.0 eix1: NIC Link is Down
[242712.280592] ixgbe 0000:84:00.1 eix2: NIC Link is Down
[242867.346797] ixgbe 0000:84:00.0 eix1: NIC Link is Up 5 Gbps, Flow
Control: RX/TX
[243018.281569] ixgbe 0000:84:00.0 eix1: NIC Link is Down
[243028.975451] ixgbe 0000:84:00.0 eix1: NIC Link is Up 2.5 Gbps, Flow
Control: RX/TX
[243405.309056] ixgbe 0000:84:00.0 eix1: NIC Link is Down
