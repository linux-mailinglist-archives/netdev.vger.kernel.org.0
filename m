Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1173F63D416
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbiK3LMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiK3LMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:12:47 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2047.outbound.protection.outlook.com [40.107.7.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6184E1C918;
        Wed, 30 Nov 2022 03:12:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqRrbahmEjd5U7jQ3Li8L+morFvDzn5rc7OQ2+xKVhQ+Jj3Rhk5/yafWGO58/t6o8GbhWsKbu/m6bHNIhxBAEw4RXzy75cPJ5y5cyLw9adzGrpMm8eO6qAlR1EXpZyzbM7OIIiVKPFkADBIdsuykrGjqG8Ae/hdvXS1cWYK/Yd340k9BfqtS5JfCANIZTzTlPNfvTGgWufS9y2J9/Hl52TOw/RXxA5hITpN3Ii51QkotWT7ocZqBVlkHrwzENcwhjC2UetBIHtq2QqVbgkPdKw6leEhpOth0/vvNMg2FOEQVNLXTCraGNAQwphmIar/JSzQ1yho6A3t5oeIYqYPmdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOU8PEQY2yDwQEEQ63eF/ws2Gr3p7Lr0IH/5wwxzc0Y=;
 b=a1mMuuovz2aPMpu2NuvJUyglES2SOq3CDqmQkDO4mkxHZfTQYQ5IdZXSzATqeAi65ggTDYjB331Juz2j+8W/QCwFFYnUN6vhR2SLtH5/kKDKRHrZSFYVw/5mUBTz3DKP5AGa2N1MC13oKQ0Y4SKxJAMfhc1rdC7lRvjjvlPrkMWBKz2txujrPMiLkK4GcmnL0hlHy3f51s0aGMdCQ6TRSCJDLwCPoc4qoWyPzep3zz95A1KT6LHuapAhpLwLclZVuwH582voWhc0l9DEmolU51Qyxrk/aNJiWHlJr+w+XYQa6FEoFp1c1JUmN49LJdoz/sANAo8k6tVwQ2NvX3l3xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOU8PEQY2yDwQEEQ63eF/ws2Gr3p7Lr0IH/5wwxzc0Y=;
 b=FnOicuBg28KcNcVycu1n8jbJlrskmqh1WJcuIiAoSUHt6pAHKKnHJHLnyzYAXky50eFG+d/Hxk6p2eQHrwPCM0EvV5MXfRY99LWNFCg19JTXA3RNxCfs4irtMzKFRjGCkgtGucfBRgvm1YWkClEPF+LD9DNsrOH3J7mMJuMjQPQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by VI1PR04MB6783.eurprd04.prod.outlook.com (2603:10a6:803:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Wed, 30 Nov
 2022 11:12:40 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d%10]) with mapi id 15.20.5857.023; Wed, 30 Nov
 2022 11:12:39 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     linux@armlinux.org.uk, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume issue with WoL enabled
Date:   Wed, 30 Nov 2022 19:11:47 +0800
Message-Id: <20221130111148.1064475-2-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
References: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::9) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|VI1PR04MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: 69c0892a-3957-4eae-b407-08dad2c3cb37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZW9cku3yhxTlk5ysohZ+c0h2Xj71qlSsZ1eQKXN1YK/TzDWaDVObVjNg6qvXem5tCDTcUJycaJS+xOaweq6cICFWyqV7dutlZLOiwS8W0NngzoCSpNtEYnd4Nhtswju1LfaQa5TJP293c4IQ95KrDCj3De6MvtkVLcEf9SMBxZOH53Nvmu9fshCYsrfkqWHVFZXjkYECh0+vfuFyzPGX3d+TgEJd484FOWP37t2IdlpozcZhM94kh/16p29tS/+wGq1YZ1oaHjbUBeSHop9Vg001+6ESJrY7gSHQzMYRwIKaiGYTTANrlxvgsVnwfBVIo/ImS7xfoAeO7/gjPAarxn8L1kAdBd4jqYDe05Y/ob5UDT1QHuXbKP3+dMf8r0/kBblhTx4cDOQt/9QSfc7qarpN3Sjxa+9nk0KSZg4rbE5/Jg8ISMIu3L0lsXnBwOQLdTboQ8wIlkXs3HIT/pNeSAZxPYcwFXeONMe+BtTObKLyjxIGxAp+/MnDWWbW7xpfS4zdAUWrnkUtUfW1iGvb9uNHt/Jo29TgyrdeoR43HqLYfAuXCNXvd/px7sJ1zUdmsttqEYWKViP6pgpvgIjIUK6O64LezdZQAUsCM845RxElikkUMN+Kyb51rwbB8+hPMRah6VVkAJgil3H+kFTQXC7O6HM6eFM0BbB6SqBOeipFz96SWoiVWmURqaL9pgCtfkmkw5yuOkQ6mH18yTmaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(36756003)(921005)(41300700001)(7416002)(2906002)(38350700002)(478600001)(38100700002)(86362001)(83380400001)(66556008)(8676002)(6486002)(316002)(2616005)(66946007)(66476007)(8936002)(5660300002)(6666004)(26005)(186003)(1076003)(52116002)(6512007)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FLlFobYSEuJm4rUY8LqTrAj2ihCxLwJ3XyHPH719ZOu5nFaOltiHvXp93YL4?=
 =?us-ascii?Q?PmoEZdy6pTsWNlG+76GmzXojhoDNNu7FL1OEC1lw7HBZXVyQnjnBotEtHpjW?=
 =?us-ascii?Q?yUvE4Kdw5YTGgkxn4wxVUZAlK4Da9UDkODbn/TyIjEh1omYYvo0lIkydzJm9?=
 =?us-ascii?Q?OkYF7GwtSTyakRy8tnq6BvwIWn/C42Eh/F1x7HoGgZRQ69f6Vqr4R+I8XXPy?=
 =?us-ascii?Q?xmMD4mpOlV2p5AMzXUJE+KMQmPYK4JlpHh3mOEWHhaSZkJov0C/F+/KS9IbC?=
 =?us-ascii?Q?emTbZD3eCXtSo3bbvwOwZCuPEb/a2rfUcPPOa9OCzmQSCRgse2NR7tOZTnPK?=
 =?us-ascii?Q?DRfCKuejHCOTA4rA5TP3m2wqXNL4dvq7tUDNxFj9QB3HEuMo9AMbaJLMoLqC?=
 =?us-ascii?Q?lO1C0eOx0Fm72hLgijaL9XJ46lq/dR/76f6dGSpGYFZfwb4ihlPgu+EXHEFf?=
 =?us-ascii?Q?W7L0Jep9pSDb2tNTTRaG7VccNmCTiLvunhcC0/xJ2HasM8K6mb/A4yIAUISU?=
 =?us-ascii?Q?X6+a/jbdXxcOO3mDvVIaU0uxW4xlVNKtVvGL7yZ5fIOiow6OrPi4fNZE6Wkc?=
 =?us-ascii?Q?CguN1qv3wlXAK5qxBb82/nJIprn+HWCHg3k0nfSvqcFg9ws+ngyYT5BsDQyR?=
 =?us-ascii?Q?yMgcNqYY5ObjZ50H1PZpPxufR0ITM6g5Wnr7LVrF6SSyqmD4oAQ5lL/3QOxX?=
 =?us-ascii?Q?ba4Gfu8GYc2Z3H2cg7sUhCKj8uOFCcviw2A7knlt3mglcmmbWT5bF1ZfOiCL?=
 =?us-ascii?Q?2j7UdfP52wZrxQ9W8zVvoS94drxxa720bEQWmtuZXT/YlzbduXFsINI+PGcw?=
 =?us-ascii?Q?03+/wsvXLClevgZLITLDeuHo4Ao0awiEICK4EgU2W27QZS7dWmsCZKKj34bQ?=
 =?us-ascii?Q?DENqXGuyiEgOZl0R04Y7nxIh3Zy0MfbcJEwFugWPXePtPxVlgoiavzEwkFY5?=
 =?us-ascii?Q?ldAc4RnEFYwTvpPydM8LbmyMuoRlE4fyPwQIU8JEPtCUri7NGRj47SYmUahS?=
 =?us-ascii?Q?92oa0XXxinfhTT58qrbgbnbjvYHdnSlKL2U8SnOcv+zmY5RXOgn7tZte1ba6?=
 =?us-ascii?Q?DrgHopeWzZ5KBUsmyt4qwel2FR9YAFtMVdca4F/aMnzd6SgFIbF6rnHnEGAw?=
 =?us-ascii?Q?cz8/gHbZwwReaqHHu7DoUusct5NJGJu0rMrFlvz+QvNpqCbIW9biHtFfJj4i?=
 =?us-ascii?Q?5OL1e82J4SlrH0Lja5z2j81m1mY0szv0wviI/iFv0GSstj8bIq6UwawfHEqV?=
 =?us-ascii?Q?4S3cYrG+rxqNUbOGGvtcT58OXP55kTnVMzDVONQrvpEQb+uBCQbXKQDqn8Nj?=
 =?us-ascii?Q?ni7pjYRG2d4z4v7twBZezTd687S4zG1sZH95w5SRj9+keYGVoldyM0AuYdEW?=
 =?us-ascii?Q?nv/pa2cZn3mzqvZJwpyJ4XyOJdBe3XIrALxjYwzalK0ChXxzrn5pUD/jQ7U4?=
 =?us-ascii?Q?bhVS0NkZnZfkA9bzr+mNB4FbDfsFJtw19B1CnDypk0sGYsn9V5ys5XHzdk9p?=
 =?us-ascii?Q?ACdwPNpcBz3tHpu0HWJBJmBsAWqC0ITzxlIeMy/QZLLvG5jBpesA3U3O/V11?=
 =?us-ascii?Q?cTZDM5HYKqb5ZMrvy2fU4QXCLDxx0ZZ8Azd+3XEe?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69c0892a-3957-4eae-b407-08dad2c3cb37
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:12:39.8727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olX4FSS8GTb7KlUkGZAWZwTUQ6Hkn2/K4uz8tiLcw8yhObgMQh5ONDjlCRiYX3+jyxQ/1JVveahJO0ngbg+2uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue we met:
On some platforms, mac cannot work after resumed from the suspend with WoL
enabled.

The cause of the issue:
1. phylink_resolve() is in a workqueue which will not be executed immediately.
   This is the call sequence:
       phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
   For stmmac driver, mac_link_up() will set the correct speed/duplex...
   values which are from link_state.
2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
   phylink_resume(). stmmac_core_init() is called in function stmmac_hw_setup(),
   which will reset the mac and set the speed/duplex... to default value.
Conclusion: Because phylink_resolve() cannot determine when it is called, it
            cannot be guaranteed to be called after stmmac_core_init().
	    Once stmmac_core_init() is called after phylink_resolve(),
	    the mac will be misconfigured and cannot be used.

In order to solve this problem, the mac_ready flag is added to the phylink
structure to synchronize the state of the mac in the phylink_resolve()
function. To prevent the correct configuration from being overwritten.

By default, mac_ready will be configured as true, that is, it will not affect
other drivers that do not use this flag.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
 drivers/net/phy/phylink.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..312b47fdc12b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -74,6 +74,7 @@ struct phylink {
 
 	bool mac_link_dropped;
 	bool using_mac_select_pcs;
+	bool mac_ready;
 
 	struct sfp_bus *sfp_bus;
 	bool sfp_may_have_phy;
@@ -1276,6 +1277,12 @@ static void phylink_resolve(struct work_struct *w)
 	bool retrigger = false;
 	bool cur_link_state;
 
+	/* If mac is not ready, retrigger this work queue to wait it ready*/
+	if (!pl->mac_ready) {
+		queue_work(system_power_efficient_wq, &pl->resolve);
+		return;
+	}
+
 	mutex_lock(&pl->state_mutex);
 	if (pl->netdev)
 		cur_link_state = netif_carrier_ok(ndev);
@@ -1450,6 +1457,34 @@ static int phylink_register_sfp(struct phylink *pl,
 	return ret;
 }
 
+/**
+ * phylink_clear_mac_ready() - clear mac_ready flag
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * set mac_ready to false, which means the mac is not ready,
+ * if the pl->mac_ops->mac_link_up function in resolve is called at this time,
+ * the correct speed/duplex and other parameters set in this function will
+ * be reset to the default values by mac.
+ */
+void phylink_clear_mac_ready(struct phylink *pl)
+{
+	pl->mac_ready = false;
+}
+EXPORT_SYMBOL_GPL(phylink_clear_mac_ready);
+
+/**
+ * phylink_set_mac_ready() - set mac_ready flag
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * set mac_ready to true, which means the mac is ready now, can reslove the
+ * phylink and set the correct speed/duplex settings for mac.
+ */
+void phylink_set_mac_ready(struct phylink *pl)
+{
+	pl->mac_ready = true;
+}
+EXPORT_SYMBOL_GPL(phylink_set_mac_ready);
+
 /**
  * phylink_create() - create a phylink instance
  * @config: a pointer to the target &struct phylink_config
@@ -1518,6 +1553,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 	pl->link_config.duplex = DUPLEX_UNKNOWN;
 	pl->link_config.an_enabled = true;
 	pl->mac_ops = mac_ops;
+	pl->mac_ready = true;
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c492c26202b5..759c8041f3d2 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -570,6 +570,8 @@ void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
 
+void phylink_clear_mac_ready(struct phylink *pl);
+void phylink_set_mac_ready(struct phylink *pl);
 struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops);
-- 
2.34.1

