Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA8F60FAA5
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiJ0OnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbiJ0OnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:43:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E80418980D;
        Thu, 27 Oct 2022 07:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666881799; x=1698417799;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v0XTJ3Nv1TiA5oAIdEGKqGuDbvZqe4fFSa+/9Fdppj0=;
  b=dYytZwRSqI7jQHYyq5iTZI08QygSj5V9BNJBIfx8tyRYdzvBfIC4VAoX
   QChP+N4VCzwf59Da25HvWSgBv9q9GAoobSstseHvPwWTiWGSv9BAlVTxV
   UB1qY3Sw1xsRmZRWMeHR7mEkDaXHo022mkKiMv2vhxQlfRhDGg2Tz3CTl
   Y3ntxpueSj/vJlv3qRbi7wF0Qyte8YUTY/YsoYhmNRJadsoZhmEErx8ev
   X0fOiIzSFUBwJ4Neyr8zr7x4FeukfB7yVGvq16UVwZJVATOa0q1xoQWTP
   fRtt53iu3/zZBMdOuCSw7nOFhrxP8xMKDgo0x80KPnZBNGb12kxXXa4Ft
   g==;
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="186548683"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2022 07:43:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 27 Oct 2022 07:43:16 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 27 Oct 2022 07:43:13 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next 0/5] Extend TC key support for Sparx5 IS2 VCAP
Date:   Thu, 27 Oct 2022 16:42:55 +0200
Message-ID: <20221027144300.2936955-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides extended tc flower filter key support for the Sparx5 VCAP
functionality.

It builds on top of the initial IS2 VCAP support found in this series:

https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/

Overview:
=========

The added flower filter key (dissector) support is this:

- ipv4_addr (sip and dip)
- ipv6_addr (sip and dip)
- control (IPv4 fragments)
- portnum (tcp and udp port numbers)
- basic (L3 and L4 protocol)
- vlan (outer vlan tag info)
- tcp (tcp flags)
- ip (tos field)

The IS2 VCAP supports classified VLAN information which amounts to the
outer VLAN info in case of multiple tags.

Functionality:
==============

Before frames can match IS2 VCAP rules with e.g an IPv4 source address, the
IS2 VCAPs keyset configuration must include keyset that contains a IPv4
source address and this must be configured for the lookup/port/traffic-type
that you want to match on.

The Sparx5 IS2 VCAP has the following traffic types:

- Non-Ethernet frames
- IPv4 Unicast frames
- IPv4 Multicast frames
- IPv6 Unicast frames
- IPv6 Multicast frames
- ARP frames

So to cover IPv4 traffic the two IPv4 categories must be configured with a
keyset that contains IPv4 address information such as the
VCAP_KFS_IP4_TCP_UDP keyset.

The IPv4 and IPv6 traffic types are configured with useful default keysets,
in later series we will use the tc template functionality when we want to
change these defaults.

Delivery:
=========

This is current plan for delivering the full VCAP feature set of Sparx5:

- support for TC protocol all
- debugfs support for inspecting rules
- TC flower filter statistics using VCAP counters
- Sparx5 IS0 VCAP support and more TC keys and actions to support this
- add TC policer and drop action support (depends on the Sparx5 QoS support
  upstreamed separately)
- Sparx5 ES0 VCAP support and more TC actions to support this
- TC flower template support
- TC matchall filter support for mirroring and policing ports
- TC flower filter mirror action support
- Sparx5 ES2 VCAP support

Steen Hegelund (5):
  net: microchip: sparx5: Differentiate IPv4 and IPv6 traffic in keyset
    config
  net: microchip: sparx5: Adding more tc flower keys for the IS2 VCAP
  net: microchip: sparx5: Match keys in configured port keysets
  net: microchip: sparx5: Let VCAP API validate added key- and
    actionfields
  net: microchip: sparx5: Adding KUNIT tests of key/action values in
    VCAP API

 .../microchip/sparx5/sparx5_tc_flower.c       | 410 +++++++++++++++++-
 .../microchip/sparx5/sparx5_vcap_impl.c       | 168 ++++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 251 ++++++++++-
 .../ethernet/microchip/vcap/vcap_api_client.h |  13 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 406 +++++++++++++++++
 5 files changed, 1215 insertions(+), 33 deletions(-)

-- 
2.38.1

