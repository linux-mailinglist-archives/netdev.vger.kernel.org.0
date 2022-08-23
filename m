Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D74259CCE8
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbiHWALj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiHWALf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:11:35 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF9657231;
        Mon, 22 Aug 2022 17:11:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=If+ed6LlNvqBPsJRiNDeKRyzYG72Pu7fviClHvVbRdj0aWvKVDtu+BfHMt4DVgqeCRiR5cI9Kv0GzP02meH4RLAbc3Fk0+fRyNPWW1QPtI6DFhpEmRDRszwr670T7ELQbbgnk7bnXdnR5BW31vMSZACkCb2hXxcJ0GHbmlVVI71fRF8iBXkuzTbIDSAtySs+42whs+LzlLVuTr6uvCDgcTwYrGGMOWZJdjMzKYRl3Wf5kGeisEaj1FS9gpXlbZxUhnNX1uhdEmbTzXW7QNR8a5ooZA7kmdwdy6vWFhV32QG83tgNEXBE5mP7jnDf4ROqF+kCtGaV96woprnXDn+i/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phsiTmFsyC3SdiNZMzqTCL5Go0NJaBTxYGCPHlMUCNY=;
 b=PdjYt7JJRo4XxHB+i9pihLezeUyEC3dF1V41Tmo8Sy4EGZkaZrlEOsSLpoKlzx/LHZ9TuSkY/0Sxm2LCWw1urX7t4Iz/0vPG1d7BcAqiJZcR16nmeApGoP++MohgMIU1lnEULbiBHoIcJq3ujqL8aJ4CHMd1GY/nbADWDYNVt6dVhmI+7/WGWk6KGnvh933EjFRMpSqeAQhMeP4XIFVsEIybBns9waB4HaUPVJETWiDwPKOGD6ZqKy0wz5VHg6g4JCZPwMWm/e1X7LKugTIp/06WA4OpJAap+raugP0KF/CZ35YByMrkMYgXVxRyW3s8hM+EMPPgTYS7D0by7o14Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phsiTmFsyC3SdiNZMzqTCL5Go0NJaBTxYGCPHlMUCNY=;
 b=GN4vQh7VwW2lD4BUMlYz5AqSxnwyfvOMS2X1W1SXPzKAt+W9fNdr3yl8cMdmbXuXLkT1bFsZu+MPAxiXNvVV0psjZeDZZXLDrJvyp1Suhi/hbbsLpDyDUnvzK/lfeAXXbfLMlWtzpjK5oRHW7z6kIfZFU6eFH2ZhlctM+r+yNI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:29 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:29 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v3 2/9] net: marvell: prestera: Add cleanup of allocated fib_nodes
Date:   Tue, 23 Aug 2022 03:10:40 +0300
Message-Id: <20220823001047.24784-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a283b685-f8b3-4438-b815-08da849c06af
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9mIVFCSvOiSzmCZ2wIFExdfrDh6/m3jIm4K5OyUzAZdenrrqYhvkyds2HV3OEzH0brMo7cHpi8CODRaRBFLsDhnvxYFD335yyvvJxqxW1u909J86EOP44D2X6n0GvA3NCIY+GwAtnkhxxLH8ZUXTVRplUBfyiY0tcRZIpJtlgehv2/B6vMfr8/rwKC20u5qO4FD20U39wsaII+qmRG11r4TXHG/g2Jh6Bb2hGeuexUpJ0Wf/OdexsthrC97OGknaKObDnVQBUYFHg7QgS6Ye5NKdIA8ChGXAqp0NsTeU3eYoekt1+1b/Uu/pIq5W+hjq8uVPnJO82MImpHa/jczAP86EQX5PraUMLi3Y0dodocs8r7LjzOkbZXDY697tCfGWXAxpcCZpB8DLYwtN88mV2AVTcxaaHvPQzNZTapPC7C6ithVNDkCF9mZk36R8TwRv3P4UVcr6rT0KDf8c+w7XLWTDYMCAKQ+OBQnDdF1dWtYlEwAdHFkjCx/xR+snAL3epqlbdye3Ad7Xtrzq1ZIbIRgj+bPzI9p66TKBMjnPFAVrLlL7W3XqF8vVTsjBnWLoc7PW/UUF8D2EbI9UiyBJyZV9MHK/SYz8bSvmzJuFqWIBHX671la+t3noO7tQqEVgMZtjyf14xhgujMddEvrZlHjUKaYpcXfVF7VeUL3U8yxCmlzE2xgpE4UAqJ62939sMrJ6RtS5BqvarxvFRLAOLlAv1OK4jM9uCrrmIWUcOhScoB95fX0HGNr2p/CCA4aZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(7416002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ivyAuLcFPqqPn9I2Nwy57r2v4OVRaLMIKIyoJ09JIszNjqWe+f8CVnnZSxt?=
 =?us-ascii?Q?pnVsjFqqyOcsjwJOzmIOV9gxOtlz3R3pyl7HAUIaS6Q35TnUgi/B68uYB37P?=
 =?us-ascii?Q?ZUpl7fwUVqjtiS3C+YnVoJsbxXGnsb2opfykYhzKTO/iz4dlZPnDP0V2kSF+?=
 =?us-ascii?Q?4seNrFAsfzk37R5EDdTkmPvNiL5MabDuzFDkNbnMIY8rW8KLahsnl1qZJfGQ?=
 =?us-ascii?Q?lX6RaXrUTZUvr3l98nWxh8AenDwsYzWBLbQE4ruIxJHaQcaHtdnw+NJJcF+C?=
 =?us-ascii?Q?/Bini0NhKAY173X9HueuiVdyArLhGLl2R58BIzXPepQGnhZtUk7toHGdKvrg?=
 =?us-ascii?Q?9nhWyGvTSnvDTlBPNRKx2pkd8iYcExh5MNcnf9DJUcgbenelpeNBSajgULhQ?=
 =?us-ascii?Q?UZJPG8pctjPUAz4UBumRJNic5QVtrXnJFsL1OcwbFGSNJWvZnEkS+3vJ1gqJ?=
 =?us-ascii?Q?g/hc2h4nwv9bEBdP7nCqJVcYv43U+ydgm89dSYgDBIW7xrjLhB3ZPRYBUgsl?=
 =?us-ascii?Q?8l3PvtBqn3NVduyUwsP6RbP6T1zTZq3HMiqT/0Jcs6i9uNpiam+lvsROgjWE?=
 =?us-ascii?Q?KDkj8h5/3QztLfwNFWS4e9FMNQAkv6bB7fzJRr2+HwxVKqFSdf3sziiNMdeb?=
 =?us-ascii?Q?GtbMBpP3SwznRyI8v1RrZTCFMo8D/Zg2+GTOA6pIRXbk5Ciu9+gFqrHe81Yk?=
 =?us-ascii?Q?F3gxLXHLjl5L/YPB/9kiYgSO9PLYJnngs4UBsTfc/koMSkrmUJT/G0Sq0Cb9?=
 =?us-ascii?Q?3bLE9O86qa+k2bb/sZGZgfs6TibWDmQAKy6EluUxCzfhdTL1OkM8TSAMcbPS?=
 =?us-ascii?Q?6vOL1+ItSeDkim8cRaDMRdxZ0W/WiaQf75JrD2Z4/a81+Gbf6BS3z6u0/2wg?=
 =?us-ascii?Q?u4wNh6tJ8MXmiE1AGMtaX5gy4wK0rdHh8ySWSr8UtBkxoE8WeueOoDXBjDON?=
 =?us-ascii?Q?IZoPVyjBkyF5J7rJIHfWG43aomxhBxix4+vmCRX3DAe3+Ur53cB9byOX/EyC?=
 =?us-ascii?Q?jdR3KKGw/+sTeAGYKh4ob1Fpan3fOUl/2kk4vHWjWI9y86Wku+gk/3HoC1JK?=
 =?us-ascii?Q?6Gob8Nel+kQHgFxoklCWMsA65SFuYDJCLCVGEFgpt05VSz7hQdWFB1FH/Unm?=
 =?us-ascii?Q?pqwvrX7NKhxzwIQE92Jn/C0KHKuZWoU7FZ09+X3R2LvpKBndUyKzQcMhZntF?=
 =?us-ascii?Q?Gl3HkrX48lkyRuPSdmw7+nH+cbx0JqwLeW/dAkdDLrOYNV8FVQ77XC726YOw?=
 =?us-ascii?Q?DOZfQOvdIlXHvgtMyl93b+GLdd/VJ1HLcs8PUTKNAD5WSGdmPeD5u4DndpcC?=
 =?us-ascii?Q?A2oLslFcQQs6TJaZFP0fi3vdu2IvfH5Yn+6zgmIZZ1vDSb6nQ4feyukv5xNt?=
 =?us-ascii?Q?aOyqELMuej9OhtZXFGbDdJ1QAN+qdeB9PjoufKy1sB2SYIPQqwTZjVxk6KWo?=
 =?us-ascii?Q?A3AU6wyp9vBKBIE7gHf3DwmYiJmkccJGovTbOIbCOWqlXIPiLNng6E09cG4T?=
 =?us-ascii?Q?08uls0hRc0em074FgUJAgMFu0QnAeRbzCgs4Jocr9hKKgyPmeGhM3UcuZIs7?=
 =?us-ascii?Q?to9QN1e+RkzwvKAWS1UWQtQf+278MKOEBg9k71mfK0QkQrOdRBdAcoax4ldi?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a283b685-f8b3-4438-b815-08da849c06af
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:28.9696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jh8V+cmUlewbSwqr1ki4/fTrVvY2z6zJVo9BBCs9eWHi+KqXux5kGsQ9PljfCYWr5RpH9CsscpXlqmW4RmanuMn444Fy5/oQjhZvdXNxUAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do explicity cleanup on router_hw_fini, to ensure, that all allocated
objects cleaned. This will be used in cases, when upper layer (cache) is not
mapped to router_hw layer.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router_hw.c     | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index b5407bb88d51..407f465f7562 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -57,6 +57,7 @@ static int prestera_nexthop_group_set(struct prestera_switch *sw,
 static bool
 prestera_nexthop_group_util_hw_state(struct prestera_switch *sw,
 				     struct prestera_nexthop_group *nh_grp);
+static void prestera_fib_node_destroy_ht(struct prestera_switch *sw);
 
 /* TODO: move to router.h as macros */
 static bool prestera_nh_neigh_key_is_valid(struct prestera_nh_neigh_key *key)
@@ -98,6 +99,7 @@ int prestera_router_hw_init(struct prestera_switch *sw)
 
 void prestera_router_hw_fini(struct prestera_switch *sw)
 {
+	prestera_fib_node_destroy_ht(sw);
 	WARN_ON(!list_empty(&sw->router->vr_list));
 	WARN_ON(!list_empty(&sw->router->rif_entry_list));
 	rhashtable_destroy(&sw->router->fib_ht);
@@ -606,6 +608,27 @@ void prestera_fib_node_destroy(struct prestera_switch *sw,
 	kfree(fib_node);
 }
 
+static void prestera_fib_node_destroy_ht(struct prestera_switch *sw)
+{
+	struct prestera_fib_node *node;
+	struct rhashtable_iter iter;
+
+	while (1) {
+		rhashtable_walk_enter(&sw->router->fib_ht, &iter);
+		rhashtable_walk_start(&iter);
+		node = rhashtable_walk_next(&iter);
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+
+		if (!node)
+			break;
+		else if (IS_ERR(node))
+			continue;
+		else if (node)
+			prestera_fib_node_destroy(sw, node);
+	}
+}
+
 struct prestera_fib_node *
 prestera_fib_node_create(struct prestera_switch *sw,
 			 struct prestera_fib_key *key,
-- 
2.17.1

