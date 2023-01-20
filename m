Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32486675038
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjATJIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjATJIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:08:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED57526C;
        Fri, 20 Jan 2023 01:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674205721; x=1705741721;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FYB5GHXd7qMXK5pW/4qFeibiAIi0jeycEJNE6wVIobo=;
  b=zDSz1ACQUzV7govsQSP9DwvK+2ljm8SreQaYYwIugVLAg1mrm3wISfWj
   BH/vFDgjOWftM0zvVhAzvknVU4xajeKaCQ4Wz2Z8p8mAZkItscN6Gny2y
   wNaozoURKkb0iPdAuPeXZSIsHP507texZ1WZ1foakrXEh9WAokXJt+KEU
   Sv/p4QEdH4LzbdXKcCtJ9j/2gBZeSXqMcqgVITBdbq9Rq89APHYKe0aMQ
   DdvssC/GejI7eoQsxj3g+73XJjyUd3JeRL1x+IkJG/B3XYtoLM4dm9FSM
   IJZZ4ADsMD2PPsfgbopBe8IgjW4J0f2V4JMce9dvhopmV6UhMLUGP++TE
   A==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="197598466"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:08:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:08:39 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:08:36 -0700
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
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/8] Adding Sparx5 IS0 VCAP support
Date:   Fri, 20 Jan 2023 10:08:23 +0100
Message-ID: <20230120090831.20032-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
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

This provides the Ingress Stage 0 (IS0) VCAP (Versatile Content-Aware
Processor) support for the Sparx5 platform.

The IS0 VCAP (also known in the datasheet as CLM) is a classifier VCAP that
mainly extracts frame information to metadata that follows the frame in the
Sparx5 processing flow all the way to the egress port.

The IS0 VCAP has 4 lookups and they are accessible with a TC chain id:

- chain 1000000: IS0 Lookup 0
- chain 1100000: IS0 Lookup 1
- chain 1200000: IS0 Lookup 2
- chain 1300000: IS0 Lookup 3
- chain 1400000: IS0 Lookup 4
- chain 1500000: IS0 Lookup 5

Each of these lookups have their own port keyset configuration that decides
which keys will be used for matching on which traffic type.

The IS0 VCAP has these traffic classifications:

- IPv4 frames
- IPv6 frames
- Unicast MPLS frames (ethertype = 0x8847)
- Multicast MPLS frames (ethertype = 0x8847)
- Other frame types than MPLS, IPv4 and IPv6

The IS0 VCAP has an action that allows setting the value of a PAG (Policy
Association Group) key field in the frame metadata, and this can be used
for matching in an IS2 VCAP rule.

This allow rules in the IS0 VCAP to be linked to rules in the IS2 VCAP.

The linking is exposed by using the TC "goto chain" action with an offset
from the IS2 chain ids.

As an example a "goto chain 8000001" will use a PAG value of 1 to chain to
a rule in IS2 Lookup 0.


Steen Hegelund (8):
  net: microchip: sparx5: Add IS0 VCAP model and updated KUNIT VCAP
    model
  net: microchip: sparx5: Add IS0 VCAP keyset configuration for Sparx5
  net: microchip: sparx5: Add actionset type id information to rule
  net: microchip: sparx5: Add TC support for IS0 VCAP
  net: microchip: sparx5: Add TC filter chaining support for IS0 and IS2
    VCAPs
  net: microchip: sparx5: Add automatic selection of VCAP rule actionset
  net: microchip: sparx5: Add support for IS0 VCAP ethernet protocol
    types
  net: microchip: sparx5: Add support for IS0 VCAP CVLAN TC keys

 .../microchip/sparx5/sparx5_main_regs.h       |   64 +-
 .../microchip/sparx5/sparx5_tc_flower.c       |  227 +-
 .../microchip/sparx5/sparx5_vcap_ag_api.c     | 1110 ++++++++-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    |  131 +-
 .../microchip/sparx5/sparx5_vcap_impl.c       |  401 +++-
 .../microchip/sparx5/sparx5_vcap_impl.h       |   61 +
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  336 +--
 .../net/ethernet/microchip/vcap/vcap_api.c    |  184 +-
 .../net/ethernet/microchip/vcap/vcap_api.h    |    7 +
 .../ethernet/microchip/vcap/vcap_api_client.h |    2 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |    2 +-
 .../microchip/vcap/vcap_model_kunit.c         | 1994 ++---------------
 12 files changed, 2360 insertions(+), 2159 deletions(-)

-- 
2.39.1

