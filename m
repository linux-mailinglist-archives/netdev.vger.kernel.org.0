Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74EC687E18
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjBBM6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjBBM6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:58:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FA2193;
        Thu,  2 Feb 2023 04:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342728; x=1706878728;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M4PS6q2vlELtVeU299jusw0WmeBgXsL/prLMnsK3L9I=;
  b=tmu36813dCCkMxBY3xx56EHFYezViHFriEGINhSmuuDlu+IHYQPTzvsx
   4ZA3IofW5nE8GGRLzP3fGYYILfTF2fCQpURgn0M4jgF2Vj+oW2j4hTElH
   ZkGqL5Sf/q64O8A5MPmubFDcjo57ulWL2p3vmgk9tH90SzaU4H2m6VI5h
   QAzvpam+WFEklwBkMg2ixXp+LrpsErhfIHP3Iui+oYRzwkIgQBnjDXnzd
   Lii3+f4417YHXVDXMZk0J6l5dpimBKJalnAIVR2NfhByzy6R6cmv67YCs
   5Du1U1Ecnj5g/mn9EtrdF/mNX7XztZyobjOYTjKRpIyiEOS6+u/TAwjiN
   w==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135251457"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:58:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:58:27 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:58:23 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 00/11] net: dsa: microchip: lan937x: add switch cascade support
Date:   Thu, 2 Feb 2023 18:29:19 +0530
Message-ID: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x switch series support cascade mode of operation, in which two
switch can be connected to work like a single switch having the
advantage of increased number of ports. Two switches can be connected
using SPI, and a dedicated port from each switch will be inter-connected 
forming a data path between two switches, known as cascaded port.

This patch series add support for cascade mode of operation using SPI
protocol and configures cascaded ports from each switches based on the
requirement.

Patch series tested on LAN9373 Dual Board, which is a custom board
with two LAN9373 switches connected in cascaded mode, and PORT 4
used as cascaded port from each switch.

Rakesh Sankaranarayanan (11):
  net: dsa: microchip: lan937x: add cascade tailtag
  net: dsa: microchip: lan937x: update SMI index
  net: dsa: microchip: lan937x: enable cascade port
  net: dsa: microchip: lan937x: update port number for LAN9373
  net: dsa: microchip: lan937x: add shared global interrupt
  net: dsa: microchip: lan937x: get cascade tag protocol
  net: dsa: microchip: lan937x: update switch register
  net: dsa: microchip: lan937x: avoid mib read for cascaded port
  net: dsa: microchip: lan937x: update port membership with dsa port
  net: dsa: microchip: lan937x: update vlan untag membership
  net: dsa: microchip: lan937x: update multicast table

 drivers/net/dsa/microchip/ksz9477.c      |  8 ++-
 drivers/net/dsa/microchip/ksz_common.c   | 47 ++++++++++----
 drivers/net/dsa/microchip/ksz_common.h   |  3 +
 drivers/net/dsa/microchip/lan937x.h      |  1 +
 drivers/net/dsa/microchip/lan937x_main.c | 33 +++++++++-
 drivers/net/dsa/microchip/lan937x_reg.h  |  3 +
 include/net/dsa.h                        | 17 +++++
 net/dsa/tag_ksz.c                        | 80 ++++++++++++++++++++++--
 8 files changed, 173 insertions(+), 19 deletions(-)

-- 
2.34.1

