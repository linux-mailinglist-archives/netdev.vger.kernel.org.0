Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9D6AE0E9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjCGNmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjCGNlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:41:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE7984F52;
        Tue,  7 Mar 2023 05:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678196481; x=1709732481;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cdS6mHiBTixmTNOVf/8YRXIdd/vQ3albcHU65V9xm3g=;
  b=i/nlkkmS/Nzx7ml/TVKpw2BC2p9hcknKzzvHKMTxrd7o0NGkfrw8W1p3
   liwtMr75XIAes1egq7gXFwe7QtvQzv9Y/In8xYPKEd2+HCjkIQpTjiZd7
   dIIh20PT2YJa1JddtXPqmIZ8Y6rE+IUZDlNYKWQiu+fbYfNnbeKvKW7NR
   Do2QsOfoRGV+sqY0mEAvbDSlYa3vVOGhsMWB9JFgPgzivXcilWKH+coAB
   rloKBueW9+Yt1VUGNNcMjp8WM2cEklFkiBxlpVUxfBF49bIs14mMI9rB0
   4K1vVygnV2TD1Y9lpYoXZAO30Y0vnHvY7zP1oQ9GYGmTIqTrQajyzHsNz
   w==;
X-IronPort-AV: E=Sophos;i="5.98,241,1673938800"; 
   d="scan'208";a="140729354"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 06:41:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 06:41:18 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 06:41:14 -0700
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
Subject: [PATCH net-next 1/5] net: microchip: sparx5: Correct the spelling of the keysets in debugfs
Date:   Tue, 7 Mar 2023 14:40:59 +0100
Message-ID: <20230307134103.2042975-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307134103.2042975-1-steen.hegelund@microchip.com>
References: <20230307134103.2042975-1-steen.hegelund@microchip.com>
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

Correct the name used in the debugfs output.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
index 07b472c84a47..12722f728ef7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
@@ -198,7 +198,7 @@ static void sparx5_vcap_is2_port_keys(struct sparx5 *sparx5,
 			out->prf(out->dst, "ip6_std");
 			break;
 		case VCAP_IS2_PS_IPV6_MC_IP4_TCP_UDP_OTHER:
-			out->prf(out->dst, "ip4_tcp_udp ipv4_other");
+			out->prf(out->dst, "ip4_tcp_udp ip4_other");
 			break;
 		}
 		out->prf(out->dst, "\n      ipv6_uc: ");
-- 
2.39.2

