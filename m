Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50DA625AE7
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiKKNFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiKKNFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:05:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E0F120A4;
        Fri, 11 Nov 2022 05:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668171929; x=1699707929;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OkhSa88+pvWXzzNAdUKByN9C89JcvFoOdQy9ZtA7Az4=;
  b=cM+grD8TaT0LhSUEiPn8h9wK/zm5Sh14+fbp2JVJZSmKlQkH//wQxVjk
   Q88LCEF1TjUv9pWc4c8csNpeaKehgIvSSUj7N5vE7ueRVf2g/YtmJJd+I
   dYOTZ2LQ6ZrTIHyphRrUdvlapOuL6b29T+cuuZrwmKtqGaoake3df4EcY
   KNQfYcAZXPc6t5dTzsLCYj9K58Qp1DMuKdr26944vIHX5sB+lN59cIDmA
   xmKRVxayZaX7fISPDh54oCtVwZ7t7E5kyYjlDTt3Wla/BvLyQkE9Y+PLB
   9kcSaHpmJyXtM2OdEOSUxi84/tmF6TTkN1lP26rm1om6MwndxhBpD0itM
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="123000811"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2022 06:05:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 11 Nov 2022 06:05:28 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 11 Nov 2022 06:05:24 -0700
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
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Simon Horman <simon.horman@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "Wojciech Drewek" <wojciech.drewek@intel.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 0/6] Add support for sorted VCAP rules in Sparx5
Date:   Fri, 11 Nov 2022 14:05:13 +0100
Message-ID: <20221111130519.1459549-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides support for adding Sparx5 VCAP rules in sorted order, VCAP
rule counters and TC filter matching on ARP frames.

It builds on top of the initial IS2 VCAP support found in these series:

https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/
https://lore.kernel.org/all/20221109114116.3612477-1-steen.hegelund@microchip.com/

Functionality
=============

When a new VCAP rule is added the driver will now ensure that the rule is
inserted in sorted order, and when a rule is removed, the remaining rules
will be moved to keep the sorted order and remove any gaps in the VCAP
address space.

A VCAP rule is ordered using these 3 values:

 - Rule size: the count of VCAP addresses used by the rule.  The largest
   rule have highest priority

 - Rule User: The rules are ordered by the user enumeration

 - Priority: The priority provided in the flower filter.  The lowest value
   has the highest priority.

A VCAP instance may contain the counter as part of the VCAP cache area, and
this counter may be one or more bits in width.  This type of counter
automatically increments its value when the rule is hit.

Other VCAP instances have a dedicated counter area outside of the VCAP and
in this case the rule must contain the counter id to be able to locate the
counter value and cause the counter to be incremented.  In this case there
must also be a VCAP rule action that sets the counter id.

The Sparx5 IS2 VCAP uses a dedicated counter area with 32bit counters.

This series adds support for getting VCAP rule counters and provide these
via the TC statistic interface.

This only support packet counters, not byte counters.

Finally the series adds support for the ARP frame dissector and configures
the Sparx5 IS2 VCAP to generate the ARP keyset when ARP traffic is
received.

Delivery:
=========

This is current plan for delivering the full VCAP feature set of Sparx5:

- DebugFS support for inspecting rules
- TC protocol all support
- Sparx5 IS0 VCAP support
- TC policer and drop action support (depends on the Sparx5 QoS support
  upstreamed separately)
- Sparx5 ES0 VCAP support
- TC flower template support
- TC matchall filter support for mirroring and policing ports
- TC flower filter mirror action support
- Sparx5 ES2 VCAP support


Steen Hegelund (6):
  net: flow_offload: add support for ARP frame matching
  net: microchip: sparx5: Add support for TC flower ARP dissector
  net: microchip: sparx5: Add/delete rules in sorted order
  net: microchip: sparx5: Add support for IS2 VCAP rule counters
  net: microchip: sparx5: Add support for TC flower filter statistics
  net: microchip: sparx5: Add KUNIT test of counters and sorted rules

 .../microchip/sparx5/sparx5_tc_flower.c       | 144 +++++
 .../microchip/sparx5/sparx5_vcap_impl.c       |  76 ++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 233 +++++++-
 .../ethernet/microchip/vcap/vcap_api_client.h |  14 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 526 ++++++++++++++++++
 include/net/flow_offload.h                    |   6 +
 net/core/flow_offload.c                       |   7 +
 7 files changed, 990 insertions(+), 16 deletions(-)

-- 
2.38.1

