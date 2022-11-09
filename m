Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B1862348D
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiKIU31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiKIU30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:29:26 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2106.outbound.protection.outlook.com [40.107.94.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6684E630C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:29:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyKrsA1JsbfSfw97kMF6GdL5igjbM8oppXj3lcY5nuOWW01RLMqt9jOWJiR53ByQjkMyG0jp46RD6UHB9fJ0ZwsRkO2ZaygyLQ8bqp0uRHR32kzGQaFV2RykN+lr6ohXsoVR6YEWQZvsB3gNASAiPgsNQ3KH+yfFzFafSRQzD51XIA2pigaQ80P0Gm8cKM3l3LMWHEhxIuUoE7oMNwdVUeh7M1lVuXABF4CMRDEfchk+zFGOMGzVB4/9iIE6Sx2/p95RlI35f4Mg4cEZd1C/nTW7HN5P/FpIsTNgcJm1ZJYCivNPTqyQQr+ap/04axP7KeNpEyzV5EFVFYo12/79Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWA24i4EKFkHNyRI7kE3m2xSP+4YggiW2X/O0QmcEoI=;
 b=X9mEVQ0GprPwtdHoaFFVmmLpHl24a5sNxrwfs3WNqFEw0O2OdOEdKpU81TdaUWay7+VnSZrscftZBSpbEVw6Y/xY20bCWPkTvC7HWdcUXCOt7O8CmC1JrNJF9KDuaw2owDWha8Ky8oBTkoSzu+L8IjGxxw4rB6CTELJItr2wl0iEzEAgL+gIEqH9+9+lAXpMum6F7uI5TFoPkDpV8PT3l2UBxktUIK5lfKJdMSheCXO1rm96gJBhgvpJC2ECRFnynyap/iE8pW7VxGKRbttFjv98qtwJUJNINUC5NsyspiPtiHp4RZps9Wqxb2m506vOfPIQiHH2D+n/6loqWKi7YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWA24i4EKFkHNyRI7kE3m2xSP+4YggiW2X/O0QmcEoI=;
 b=fG3Bl9LBMO5dVL5wTA1HPGmfG+klNrbTcezRaNwn1dcqhZAJaSSorB6QQLUG8Hguttd1hfLIDJaXxXS9dMhG+aK7Hy00zJWOkvc37w5tn9584eTXxO2Sn91a8wddZlWXOtFF0VRkRVv8gf9Ze+bMi/EsDSJixzhH1yHu7sav4qs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4061.namprd13.prod.outlook.com (2603:10b6:806:99::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 20:29:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 20:29:22 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Jaco Coetzee <jaco.coetzee@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: change eeprom length to max length enumerators
Date:   Wed,  9 Nov 2022 15:27:57 -0500
Message-Id: <20221109202757.147024-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:208:2be::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4061:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cea9bb7-cc01-4a8b-3c96-08dac29115bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +hEMuB3eZNBsyFzl4DP9reeVW/EAJp8Rs3qzi0YLHEsWMswg0/nITlL6Tvp+ZAQnX7F7msIP9F8BBgl/6z9Q+WWFuSxZUvXmCYzy6PQ1uEiJBEorSu7qJDOnqd4FYE0RlpWvH6o6Qd2dROWAn08bMBz5W3PGeWkx15osas2yqCg9GchHSefmwDFz026SEKMGMgZqjVtngRjxipCkVzpW3P42r1MxEXdO/atdU2RopbvfPvVupMAtTSls+lFVVA2Je5tgnKEYH55at6QN5QKVhORrHfYhUJZNfIUyERaN0V7y1RKdWY1bpbYw6PNNcjNssR+Ll3sGvNe0kO9M2Y72yW/FcLzCrD3yFfNcUfx67MdxvgOYK7JuuP4EZOlUPxMJDX/l/0WLzBVMoMHf21c/3dacP82L9sKrOMGplGOoLaNqYQQQS4g3vrxeWgIWbBck6xUB8fzRUn65YeegBNjQmAT8ZuFM6rBbgcFjPCKs7L1m05d29locR1/jNU9LBWpKGO0py4R1ebxwZf9QK8/0kmHCjn+rwY4ijCUa3f3nB2ea0F2vqEx0BAV6txCzfSafoydMPz9ZlAzvEW1R05giJ6sUl53qIycdvVq8syJnzycEjARKULRJBnJbE6SWi4ckB67ppVS1nH18O1/ve2L2NpC77rowDTgMBWX/2gnTpHVGXsB2I/WecVyl3vE14tIscdHTyLPEvRhq5JfQoItLBdjNTlMT1DCQ9FC0s5vavo7zxrlpkeGBWGxZ9J5RWCdIR8OiisAz7PqVp3EtX3dP8f2Uu4QzOVGHlKs74LYanaO/Zc0FOaJjaN8jSyN8ZG8S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39840400004)(136003)(451199015)(38350700002)(38100700002)(8936002)(41300700001)(66556008)(6486002)(6666004)(26005)(6512007)(2616005)(107886003)(86362001)(478600001)(52116002)(6506007)(8676002)(4326008)(66946007)(110136005)(54906003)(186003)(1076003)(36756003)(316002)(83380400001)(5660300002)(44832011)(2906002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ghXk1I+y2JwlItPujKBCjY/GdRPBc60QXM3XXmyoArTwsro2BQAhLFQjuoXc?=
 =?us-ascii?Q?Px33/Z1PSGTbayOHLT2/0pQrtbmCoJjbn0pdAhvLmyfHi6Zdj7CWFwN8bCFW?=
 =?us-ascii?Q?Fcjg52zwea1HHTg7n5Trp71rVgJx9MKQbOrEiEsprZN68WSFjvRMHRG2dGlZ?=
 =?us-ascii?Q?HW0J1zpPwDnyJ4HUytJVAQ8yn78MulV4i6ifa/Di94ZE4lwsn79UAFPbUO1s?=
 =?us-ascii?Q?gITVWcE1oJNp/4LiN/1L5Hw4waeCdMrGUDpFD2+KidYQVXyV1ckFwwPYbzS0?=
 =?us-ascii?Q?h/UvgmUdkC0JxHM+mlYs8nm4DykUidi6qotuBcoebL6ohOpU2jJZCgQTBMNE?=
 =?us-ascii?Q?brGquVRppED08bzprQyuhlmdHxrWoqSQhYHO83K7wKR8kJIYz8+9l2VJ3sUZ?=
 =?us-ascii?Q?WoCh5g8jRxOjbbSpaXPDUAFryMI3Ya4F06E8+I8eUl91tdxtMokRR7P2gORP?=
 =?us-ascii?Q?A6CEYF1bEDj+KEuwj6eCywHuoiUweZ8R01ZCg626eKaHfwuJK2uJU9f7BxVB?=
 =?us-ascii?Q?8ULsWntmP8UVG/tp/YMmN+viGagcRGzh+6DnWA+Q1S0+XgIiZcEouQaAMEsT?=
 =?us-ascii?Q?ecxFP1dtFHgVhUtYU/BLFgnMyNpVEr0T6uMSMPQF+eYbgJD/OFx93md1gJkH?=
 =?us-ascii?Q?jYnhj9nrtl2dkMTvAF8D71VbYnupPwC9rptub8Xjpi4dJI+fQgL0Z4OmQmpH?=
 =?us-ascii?Q?JE1PTH4YPMG3Oa+kqNzU5oT4lAwKoB91uYZmrqiEwLA0xnSLM28FtJictVMk?=
 =?us-ascii?Q?xqZEbaTmBfXggiwcCk30W6D6vaTQZZlag80eycSJ68AVyvo11L84YbLgVrdH?=
 =?us-ascii?Q?1oAOvcV6iR8GCgqHNjMwih9FKjiZA2APRoIvvUIvXlSHfoMAv92zWom6aLqn?=
 =?us-ascii?Q?2ZksMxMkblwGkOiXMXyKAqZK5OjQXbIZWz3MxwLtq636hWetfRlewVkgssCp?=
 =?us-ascii?Q?exPriGh9JvP0bz5QAjiN7ze/CmGUBPTs/PI6k9KvG+QpqWn+2tq5jYyUGoaD?=
 =?us-ascii?Q?UaKUI340ZhnoV6BVJck2lsah15abG6iFcNuB1rb17LZpkHLSjDOWiG9iarcT?=
 =?us-ascii?Q?1gvv3q4muZsyz31gjuJiBPxaWQ7evfONyxPAMxLS/iDOhrn6dJGdNtvrgjIu?=
 =?us-ascii?Q?1TWMUi/vN5oFv/AEAR6h92qGSuCJsjpKge1KzPFKm9op90E/fr07zvsdWf+Z?=
 =?us-ascii?Q?HC/DVY8wgG2lBEvCcA5iWQdUGZs5lSVLX+YnRqkFbgesxOVQNEzKF+TGtOnc?=
 =?us-ascii?Q?aeOkAJe257BnI8YGNtFX0nfyjJhJVfgoT6S64tv98Yt2p/kq0wnxPxMj55pa?=
 =?us-ascii?Q?BIDHF41pxJ/+MFcbn24LgSqBg8BE1GJrmv0yVxNuwp9Ul53tkqbDH6dQj22h?=
 =?us-ascii?Q?KRjiuPn0BF+RQX0rQ9YrZxEaSlv6Rb/rrEB40fANE5uQgbbXNcXVIFQvRxiw?=
 =?us-ascii?Q?T4RhoOvCi4HYxXp4H+3TEKGGDFPk3aB8+MoXXUWAwMyJpOWtoLjiDP/SSOSD?=
 =?us-ascii?Q?NFbA3/+GxiHSxyEXMTqJNdSX6xo/tKeDfhuXyduxXdXcYa+3lM8VER3UsRNi?=
 =?us-ascii?Q?lF4vVscBLk7wxlO5XlWGkshcR+iU2xpJE7R8e5qsPC6kV+2tZbBIYnPcM+/H?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cea9bb7-cc01-4a8b-3c96-08dac29115bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 20:29:21.9081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AFEQDPTTfISvRJqcloI9llJpFflQxQ2UY1jubI6I7rYuXxeTjkpvgeSCkghGqm4pd77ck/zfmjqU7Av3vFEk7/TfW6QN9JT1S7JNKCEyPZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4061
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jaco Coetzee <jaco.coetzee@corigine.com>

Extend the size of QSFP EEPROM for types SSF8436 and SFF8636
from 256 to 640 bytes in order to expose all the EEPROM pages by
ethtool.

For SFF-8636 and SFF-8436 specifications, the driver exposes
256 bytes of EEPROM data for ethtool's get_module_eeprom()
callback, resulting in "netlink error: Invalid argument" when
an EEPROM read with an offset larger than 256 bytes is attempted.

Changing the length enumerators to the _MAX_LEN
variants exposes all 640 bytes of the EEPROM allowing upper
pages 1, 2 and 3 to be read.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Signed-off-by: Jaco Coetzee <jaco.coetzee@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 22a5d2419084..1775997f9c69 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1477,15 +1477,15 @@ nfp_port_get_module_info(struct net_device *netdev,
 
 		if (data < 0x3) {
 			modinfo->type = ETH_MODULE_SFF_8436;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		} else {
 			modinfo->type = ETH_MODULE_SFF_8636;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		}
 		break;
 	case NFP_INTERFACE_QSFP28:
 		modinfo->type = ETH_MODULE_SFF_8636;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		break;
 	default:
 		netdev_err(netdev, "Unsupported module 0x%x detected\n",
-- 
2.30.2

