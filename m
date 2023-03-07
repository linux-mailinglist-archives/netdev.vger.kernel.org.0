Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55AE6AE0E8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCGNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjCGNln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:41:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915553646D;
        Tue,  7 Mar 2023 05:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678196476; x=1709732476;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0zDakawvvGFutcHa9xipFSfIiYJWbcFRCndb+rI1VNE=;
  b=wOXG9IaPMaf10jCIB/EbM2dZQPjJr4QqNbQEU95j7GmRYJdnl8md6ZwD
   OGtdyaiZN7JstImiiFu64MMFOcT+uYMUDXMwqGJvGvG8ighsyvjhp4P6x
   JICRgFEL0SpvZ5LKf1C2JQUkrOlP24cdFhwmSRhlDVE6aPfegJ6ymCBDx
   gcVIoYn8rn19WVvEqgAeq+capbUg/HxOB9JZR90dfe7x4Pif6HFIX7oda
   H4jWiKxFcjZ0LYW7E6LKhlB1xQdZhMseeKOJqtUNWixLXNBoAayECOuT7
   zxH5iBGZNz/K9k8JnHUiAInNXff14JY3l3ecZRbk90LoP7ed10hFuw/p9
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,241,1673938800"; 
   d="scan'208";a="200373210"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 06:41:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 06:41:14 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 06:41:10 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Qiheng Lin <linqiheng@huawei.com>,
        "Shang XiaoJing" <shangxiaojing@huawei.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/5] Add support for TC flower templates in Sparx5
Date:   Tue, 7 Mar 2023 14:40:58 +0100
Message-ID: <20230307134103.2042975-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the TC template mechanism in the Sparx5 flower filter
implementation.

Templates are as such handled by the TC framework, but when a template is
created (using a chain id) there are by definition no filters on this
chain (an error will be returned if there are any).

If the templates chain id is one that is represented by a VCAP lookup, then
when the template is created, we know that it is safe to use the keys
provided in the template to change the keyset configuration for the (port,
lookup) combination, if this is needed to improve the match on the
template.

The original port keyset configuration is captured in the template state
information which is kept per port, so that when the template is deleted
the port keyset configuration can be restored to its previous setting.

The template also provides the protocol parameter which is the basic
information that is used to find out which port keyset configuration needs
to be changed.

The VCAPs and lookups are slightly different when it comes to which keys,
keysets and protocol are supported and used for selection, so in some
cases a bit of tweaking is needed to find a useful match.  This is done by
e.g. removing a key that prevents the best matching keyset from being
selected.

The debugfs output that is provided for a port allows inspection of the
currently used keyset in each of the VCAPs lookups.  So when a template has
been created the debugfs output allows you to verify if the keyset
configuration has been changed successfully.

Steen Hegelund (5):
  net: microchip: sparx5: Correct the spelling of the keysets in debugfs
  net: microchip: sparx5: Provide rule count, key removal and keyset
    select
  net: microchip: sparx5: Add TC template list to a port
  net: microchip: sparx5: Add port keyset changing functionality
  net: microchip: sparx5: Add TC template support

 .../ethernet/microchip/sparx5/sparx5_main.c   |   1 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |   1 +
 .../microchip/sparx5/sparx5_tc_flower.c       | 209 +++++++++++++-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    |   2 +-
 .../microchip/sparx5/sparx5_vcap_impl.c       | 270 ++++++++++++++++++
 .../microchip/sparx5/sparx5_vcap_impl.h       |   6 +
 .../net/ethernet/microchip/vcap/vcap_api.c    |  61 ++++
 .../ethernet/microchip/vcap/vcap_api_client.h |  11 +
 8 files changed, 553 insertions(+), 8 deletions(-)

-- 
2.39.2

