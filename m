Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6806429B38F
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 15:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1776156AbgJ0Ox3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:53:29 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46595 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1773337AbgJ0Ov5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:51:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7CAC5177A;
        Tue, 27 Oct 2020 10:51:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 27 Oct 2020 10:51:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gaWmFOhZ7RmMIks54
        RdQpRVe0CB7A0yR2aL5Q3B2vL0=; b=DVYaTI9gKKjNBtT86UlyD57iK85h43Q7h
        DgjZBObfGYvvIKfLll/B3Y1j+LE9fgEMg7NdaNNGzADqwZvCKPFgle8pMg0SD4Mh
        ybawKnkcdoGUO+g5pawZGlV55NlamBaxUnxkFZws920MsuatHBSr5t/1/CVKyUdm
        VU5bSGYscWsmgCajqNdv573hHKZxIQ447XTpINeVlM44JSb+qg9K4itFK5YwtVRa
        XVTyBhtlh9dC+lcG/e9o/C8GCTK5ILEQGHugLqCgLvulljAq7B23gyLVgQpor4U2
        hjIuRhwxWZZZ30H2L+2pOuXJ8h4mPJqXu50hIusdhbQFkKbaCk1gA==
X-ME-Sender: <xms:DDSYX1zcU5CnLpWQKVpnlrOpoOSONAkFyofAtDk4vFmhlNSKyQhukg>
    <xme:DDSYX1SXdQB0YJtHbh13LScUUH5PFHL59y2RTQYu6WHOstRefSdpA6mGkxztA4bki
    noyJugGd0q2gNc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkeelgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdelnecuvehl
    uhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhse
    hiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DDSYX_U-1yg7XCQx7xQ5ONKqkPNdb51PBWRkpYU885iAAZu4xnD9EA>
    <xmx:DDSYX3hY9YoUwctDn1q08YljRfDzAK7puv5y681E-Hww9BgUa6j_Hw>
    <xmx:DDSYX3A_1nII6qFu_tnPAhGjpHOt9lVoXiGfWJ-vUbOaISVFlSBmKg>
    <xmx:DDSYXy7groSLjA01kiECfYMEEl35N0Fnz_kmJmHOlCaaWdDFX1j-Gg>
Received: from shredder.mtl.com (igld-84-229-153-9.inter.net.il [84.229.153.9])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACED73280064;
        Tue, 27 Oct 2020 10:51:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, David.Laight@aculab.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool 0/2] Improve compatibility between netlink and ioctl interfaces
Date:   Tue, 27 Oct 2020 16:51:45 +0200
Message-Id: <20201027145147.227053-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set teaches ethtool to set the 'ETHTOOL_FLAG_LEGACY' flag in
the ethtool netlink request header of the various commands mapped to
'ethtool set' in order to improve compatibility with the legacy ioctl
interface.

The current use case is to ensure that the kernel will advertise all the
supported link modes when autoneg is enabled, but without specifying
other parameters.

To prevent the kernel from complaining about unknown flags, the flag is
only set in the request header in case the kernel supports it. This is
achieved by using the recently introduced per-operation policy dump
infrastructure.

Example #1 - ethtool and kernel are both aware of the flag
==========================================================

# ethtool -s eth0 advertise 0xC autoneg on
# ethtool -s eth0 autoneg on
# ethtool eth0
Settings for eth0:
	Supported ports: [ TP ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: on
	Port: Twisted Pair
	PHYAD: 0
	Transceiver: internal
	MDI-X: on (auto)
	Supports Wake-on: umbg
	Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
	Link detected: yes

Example #2 - only ethtool is aware of the flag
==============================================

# ethtool -s eth0 advertise 0xC autoneg on
# ethtool -s eth0 autoneg on
# ethtool eth0
Settings for eth0:
	Supported ports: [ TP ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  100baseT/Half 100baseT/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: on
	Port: Twisted Pair
	PHYAD: 0
	Transceiver: internal
	MDI-X: off (auto)
	Supports Wake-on: umbg
	Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
	Link detected: yes

In example #2 the kernel does not advertise all the supported link
modes, but it does not complain about unknown flags either, thus
preventing breakage with old kernels.

Ido Schimmel (2):
  update UAPI header copies
  netlink: Set 'ETHTOOL_FLAG_LEGACY' for compatibility with legacy ioctl
    interface

 netlink/netlink.c            | 13 +++++++++++++
 netlink/netlink.h            |  2 ++
 netlink/parser.c             |  5 ++++-
 uapi/linux/ethtool_netlink.h |  5 ++++-
 4 files changed, 23 insertions(+), 2 deletions(-)

-- 
2.26.2

