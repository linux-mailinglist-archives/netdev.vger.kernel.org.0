Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EEA67E624
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbjA0NJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbjA0NJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:09:26 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797D17EFFD;
        Fri, 27 Jan 2023 05:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824940; x=1706360940;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6OU5WNoVZZvJd9NlVlGxnPHtjT/vU2I5rNLU9tH7Wmw=;
  b=2Phi9Rlut0FaZOs+P5K7tgM/UZJetmMlwJnJ8u90kcAjaN9XhaIrKRxN
   1RE6klRcyZUk6RQjIGYObuudnWfmcD4mKSwjOusp+8GeOg1taGycDMmPs
   lFGT3UNKCGYhAt2uCImKwooQG6WgveXHMxiwEPzyoh5B3gvHY+1h49R8I
   5mWZyzimqW2sJjT8OymDQlIuoCGMLQa2Au2l0LlCNpxd4+Jfcbk1TEYiQ
   WYyyHSxZLbBXTeLweaScxfHlqjcorZmvPAdSvDhXot5ytrHAZNGuOp3JG
   YngdH1Hg3aWT4tFQ4CYqhqC1k18lTJuCfAq5t5L3Z0LrTDKeRlxZoeaNT
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="194150129"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:08:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:08:40 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:08:34 -0700
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
Subject: [PATCH net-next 0/8] Adding Sparx5 ES2 VCAP support
Date:   Fri, 27 Jan 2023 14:08:22 +0100
Message-ID: <20230127130830.1481526-1-steen.hegelund@microchip.com>
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

This provides the Egress Stage 2 (ES2) VCAP (Versatile Content-Aware
Processor) support for the Sparx5 platform.

The ES2 VCAP is an Egress Access Control VCAP that uses frame keyfields and
previously classified keyfields to apply e.g. policing, trapping or
mirroring to frames.

The ES2 VCAP has 2 lookups and they are accessible with a TC chain id:

- chain 20000000: ES2 Lookup 0
- chain 20100000: ES2 Lookup 1

As the other Sparx5 VCAPs the ES2 VCAP has its own lookup/port keyset
configuration that decides which keys will be used for matching on which
traffic type.

The ES2 VCAP has these traffic classifications:

- IPv4 frames
- IPv6 frames
- Other frames

The ES2 VCAP can match on an ISDX key (Ingress Service Index) as one of the
frame metadata keyfields.  The IS0 VCAP can update this key using its
actions, and this allows a IS0 VCAP rule to be linked to an ES2 rule.

This is similar to how the IS0 VCAP and the IS2 VCAP use the PAG
(Policy Association Group) keyfield to link rules.

From user space this is exposed via "chain offsets", so an IS0 rule with a
"goto chain 20000015" action will use an ISDX key value of 15 to link to a
rule in the ES2 VCAP attached to the same chain id.

Steen Hegelund (8):
  net: microchip: sparx5: Add support for getting keysets without a type
    id
  net: microchip: sparx5: Improve the IP frame key match for IPv6 frames
  net: microchip: sparx5: Improve error message when parsing CVLAN
    filter
  net: microchip: sparx5: Add ES2 VCAP model and updated KUNIT VCAP
    model
  net: microchip: sparx5: Add ES2 VCAP keyset configuration for Sparx5
  net: microchip: sparx5: Add ingress information to VCAP instance
  net: microchip: sparx5: Add TC support for the ES2 VCAP
  net: microchip: sparx5: Add  KUNIT tests for enabling/disabling chains

 .../ethernet/microchip/lan966x/lan966x_main.h |    3 +-
 .../ethernet/microchip/lan966x/lan966x_tc.c   |    2 +-
 .../microchip/lan966x/lan966x_tc_flower.c     |   16 +-
 .../microchip/lan966x/lan966x_vcap_impl.c     |    3 +
 .../ethernet/microchip/sparx5/sparx5_main.c   |    1 +
 .../microchip/sparx5/sparx5_main_regs.h       |  227 +++-
 .../microchip/sparx5/sparx5_tc_flower.c       |   57 +-
 .../microchip/sparx5/sparx5_vcap_ag_api.c     | 1166 ++++++++++++++++-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    |  117 ++
 .../microchip/sparx5/sparx5_vcap_impl.c       |  786 +++++++++--
 .../microchip/sparx5/sparx5_vcap_impl.h       |   34 +
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |   11 +-
 .../net/ethernet/microchip/vcap/vcap_api.c    |   36 +-
 .../net/ethernet/microchip/vcap/vcap_api.h    |    1 +
 .../ethernet/microchip/vcap/vcap_api_client.h |    2 +-
 .../microchip/vcap/vcap_api_debugfs.c         |    6 +-
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |    4 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |   66 +
 .../microchip/vcap/vcap_model_kunit.c         |   14 +-
 19 files changed, 2390 insertions(+), 162 deletions(-)

-- 
2.39.1

