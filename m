Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D585EF10E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbiI2I7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiI2I67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:58:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20712.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::712])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97C713EE95
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:58:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+kVh7vQlaoeCU4cpKAEIoH40teTe5H8DcKzb3UhLEMcSu2aqGDjCEFDhAbVOoFioeeFDdV7ixiqouCPudbsl6Y13RrhMNMZ/CTH/SIBfIptqjHx0bCtphymnWmv/nXOBmspW0G/k6wzgDUDCBaxcIR/T3DasBupELv/6TZ922XFF7OCW2iIjCecAkjP2ETdI07id4Ze8Mful0I7pMv2Z5CqC9DELcWDhYvc+gG+ZHZFeFCa9ten2XpNeGkZbs8hGkWMerxolxukTt3kq2Gsc7ysPo8f9LEwph6Lo67pNQLFWeAPdTWSwBQqylAkRWlGKWiwZ8+kF0wzTswoKwr8qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSpw37fd8rsgeFOVNuYetaA/YdAGQkPN7VKrjboGTyc=;
 b=fK0ikgVHNUEt0obw5SnF3Gnwz/8FZAIE84T0aY1zcghcJF4Idb9cKE4StAH2awGRcv4N+QM4L1DlresYODmPlICXQPb14F6nm7aQ5xueyeCDs7gijUdzxUUHf347Dz2aGDVpKwOdfBnnJwrhjp8jaQB4jbi4aMgqDFNQq5wF8BE8+hWbNY0UDWlFfBHtJ4q6Pj+7q3PCVnZ5RQLfhdlAISXh0Iw1t7bm7/ivDnM6JLPDo/KT/CA4q9cFIUzl9PuRNYm44tG+2cm5kCpSyPSBCKE0a2M54TJ6PIB0VTm/AwB0BnCVkbKMuddl5cW4aEwxju7sv4p56PpcqgwniJhYCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSpw37fd8rsgeFOVNuYetaA/YdAGQkPN7VKrjboGTyc=;
 b=VCnPwalWpkmgTDRlUJo5T6YC4DWJ2AIjWA9s8lPnXns33PmTz3c+4pPiU9DcD9DhH0IZtNTtr1T8d3eF435sNDM+I2XCq4Ngr2Y65Tt9Gbz4omG9Zghq8IDFSx4JP6BLV4B3ndehEi5XgziqOlqdTWXYsB6CPIvT7JOPW18lIgU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3854.namprd13.prod.outlook.com (2603:10b6:208:19e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 08:58:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Thu, 29 Sep 2022
 08:58:54 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next v2 1/5] nfp: add support for reporting active FEC mode
Date:   Thu, 29 Sep 2022 10:58:28 +0200
Message-Id: <20220929085832.622510-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220929085832.622510-1-simon.horman@corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3854:EE_
X-MS-Office365-Filtering-Correlation-Id: 6815c824-1538-4af0-6f13-08daa1f8d61c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8BCpcghipYDWqKagqYLN6L4NecIPHIwctEYsOzgqcnS6C65cB3ZVfRCesklbfct0dSpdWwFMYNI84DhCCwAGiTG5C78LsWfy8Bh16lYWusOZZJiswIwIGd3+KI6+JpUpcTq0OsFjmW6FmVQy/G9cHEjirZw/yW+m8N0aQDvl90PiZFfRD3QFnFxZIovCcVE9gI8IICDx/nD+owKBgn6YB2iVOYtY1zkvNm8BD+antm7hNnetxWZ7ZrvBw4nrhlkCTh7SWRlx99uuXNBCquiEo5E1byDoZeiwvzDwhqVtOOmXCe6yGxulx54sr4DCEwsjX7GVnCHTULUSlo/CDbGu2lfDoG5+pqObFTGVUz7j8xWwLWDZBDCUSOHoj6A/PvfBCjF+4DXIWbUNBbafMCagAbnxx1p1jpGnuUBwPH02ndj1utOkfR7s/hOKVrlJzK7g8UR0m39Ij9C1HfNUnnS8l0uWUFd0xS541WNMo+VirxnrYFlFEnrnPhWCZOA0JLDrEuyZ/bD6EQdIY/FYBoYOu+bx9sKFCmExNcLCLjb9stDpLdciTeNmtZ8hKeehKZKEjuNmK5mLW84bV6ah4plknWUaEBBetRSOq9JhJ03zM0exF7eYHTpU2xf83WKN3EyLRrkRfnO7XhOyOiBHLr3e0pEq3OG6w0lRGVvlZiVzQLySvch6NDO5M1gOkM4tJ88jsY8lEUrCPTAcuuMQvv2n2vzso6vUE6t7BRcc/27iAJwz80UFpfBQ5tJdaOtIgz8+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199015)(8676002)(2616005)(1076003)(186003)(83380400001)(6512007)(86362001)(66946007)(4326008)(54906003)(5660300002)(66476007)(6666004)(107886003)(2906002)(36756003)(6506007)(38100700002)(66556008)(6486002)(44832011)(52116002)(41300700001)(478600001)(8936002)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rLj6dbX2SX6JyQuks/lM8Hb4RUTWbVf41O1gVGe3csps9tt6JTOPX4ds/Psc?=
 =?us-ascii?Q?pkdbY30jzgY6oCaehkT0W2iAZM+2qNYGXMMr32jGVqiNEoW2ByTF6Bzb2vZm?=
 =?us-ascii?Q?XBcVu4IYtHV7uEWWBfeXVoDl1uYbj6zMupmZ+m7z+wQ1INSYAwmdIG+YgTgF?=
 =?us-ascii?Q?0TFNHajiRNhCWxc8K9te7kAWWyVirmujqYIEpCLZ2eoCnnHTGj4T/YAn+An0?=
 =?us-ascii?Q?IE33XOY41iOZJeidx7FVUYX4V0JWkVzA4x9/31gf2YY2etY4Z/nHWcwp0+dY?=
 =?us-ascii?Q?hVslamZ23ZKxTbmF9kXhUvDNlpQeVnoZSsIy2P5kNO8R7k+XIViXxnzmufhi?=
 =?us-ascii?Q?mvBpIfhZ8IobFzG4LLgbTrOQ4cTWq7LdLhMcyrrbQxtZ6wAybiOz26SMOy0S?=
 =?us-ascii?Q?NOHxws/s+hYtqQ7ma+URWav6Z3eASgGu0/PgO6LhYvVN2ZM9Af2/AZ1JwtVl?=
 =?us-ascii?Q?vRAZtCubRL+74U/ni9BbIHHYzvXrIBD+W71guLWoPZ9DoNXCkFx9kmPsr16o?=
 =?us-ascii?Q?I+6esjTpZ3rSGNQki8Biz+RlUlHex1Wq/OTUXLrKC04ESniA1IQsaAok8U1r?=
 =?us-ascii?Q?sGAkMHhSLxlB+gA0PQ/roJt/TNYnMwWuTVpkNe4TIImqWI9XIi9GAxrVfv9z?=
 =?us-ascii?Q?ONclyqf6EgZfojgBiqeS79OuOdRjMlMUq2IykakeYxZsSyTF5KHBfhlJI9L4?=
 =?us-ascii?Q?O4K+kWt15g+Y1kW9UStU/UFrdrbsOo9cC8XZK3puYujYP49+xLMK9gYogCfF?=
 =?us-ascii?Q?hIFrH2sDxynnavxoc4PMfpbqp5jcTXPfhF1a2oM2LjLklk1TqmRBYc88hoko?=
 =?us-ascii?Q?gURMOpCh5Qe8hlNAQb/p7PpMBCBg7dTQq1vuMYvPp8SDcbuOGfzOnxY1BI73?=
 =?us-ascii?Q?CcgOO4zub/4nGgQtyO77BqO2cTdeYk+1Qukc4GdCkS2YQ/U3y7OvxvbnDKqo?=
 =?us-ascii?Q?kE+htd6TiU9cVvreE5rFAe60iOwCBQ/cuCUbrRCPLyVwnyA6wFyHTRJfNPvi?=
 =?us-ascii?Q?BsKBUmymUl0vqa4jKQpEM3jScYWTUyZIaYLGpdhl5HFlO3u0fMWXOLsVNdCt?=
 =?us-ascii?Q?R5kl/qZTGRli68fhFG9br/rgtIm3lkX2ZBOeR/IuEd7arap0W/knAudV2cs8?=
 =?us-ascii?Q?o2+5m78Eoyi+kxIrUlr/IWb6mNbkxnNmrA+eiihjZ1FIi4TWET2f6Qj2Pb6P?=
 =?us-ascii?Q?3Yb+fbhaNSYhizsl8TT8G0x4uT86JlIDme8DwT7fOI/psBzRYVByUl1vuN4/?=
 =?us-ascii?Q?P/NaBBOPD8WFx2eV0jAzEWqvPkS435Knk0l/EL1x+rTaMwn48gJC4WZnnlAj?=
 =?us-ascii?Q?VzRd5Y/AGib9j2H7YhvrUlIl3/eJXXFTTuUKtsBL4IY3aiiwlvboB2DvYXhJ?=
 =?us-ascii?Q?QeMT+NTn1++j1Jh7N7CY6IIVb6NpEFUMTH90ynn1zDT7NAx6iPcprZBhcAXP?=
 =?us-ascii?Q?rMaKzu+QMqtu8fa+IKB1Wg7nLzFFqa6bfzOnhsAxoRUf0qGyeiknkiKL0MOb?=
 =?us-ascii?Q?q0myh1OHRDFQsjUme0jFsvXmrNqou8VVcZFAD2IJ0dohq+yYVF8USF+WUhQr?=
 =?us-ascii?Q?R/jxn1yXs0fOppD71tqb9FKagd+amqwQtRKn8ijw5JPx8/htRpy1D5iz7v+A?=
 =?us-ascii?Q?XmqHUXfRO7sB8Xwd+vhqjE+BU1qgmi0u0QG3aLPnc/siyxa4B4VNvFqTfx0C?=
 =?us-ascii?Q?Hjbypw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6815c824-1538-4af0-6f13-08daa1f8d61c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 08:58:54.3588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6moADQcB2up117NZ4I+JX+0freNIU1dBLWnXq+gBaMffpeusD9NhImak79VkN7QxL7qprG8A87oBTSECuxkgo6gHaRyYDpKsrLezU0+mRx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3854
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The latest management firmware can now report the active FEC
mode. Adapt driver accordingly so that user can get the active
FEC mode by running command:

  # ethtool --show-fec <intf>

Also correct use of `fec` field.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c     | 2 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h     | 2 ++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c | 9 ++++++++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index db58532364b6..d50af23642a2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -996,7 +996,7 @@ nfp_port_get_fecparam(struct net_device *netdev,
 		return 0;
 
 	param->fec = nfp_port_fec_nsp_to_ethtool(eth_port->fec_modes_supported);
-	param->active_fec = nfp_port_fec_nsp_to_ethtool(eth_port->fec);
+	param->active_fec = nfp_port_fec_nsp_to_ethtool(BIT(eth_port->act_fec));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 77d66855be42..52465670a01e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -132,6 +132,7 @@ enum nfp_eth_fec {
  * @ports.interface:	interface (module) plugged in
  * @ports.media:	media type of the @interface
  * @ports.fec:		forward error correction mode
+ * @ports.act_fec:	active forward error correction mode
  * @ports.aneg:		auto negotiation mode
  * @ports.mac_addr:	interface MAC address
  * @ports.label_port:	port id
@@ -162,6 +163,7 @@ struct nfp_eth_table {
 		enum nfp_eth_media media;
 
 		enum nfp_eth_fec fec;
+		enum nfp_eth_fec act_fec;
 		enum nfp_eth_aneg aneg;
 
 		u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index 4cc38799eabc..18ba7629cdc2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -40,6 +40,7 @@
 #define NSP_ETH_STATE_OVRD_CHNG		BIT_ULL(22)
 #define NSP_ETH_STATE_ANEG		GENMASK_ULL(25, 23)
 #define NSP_ETH_STATE_FEC		GENMASK_ULL(27, 26)
+#define NSP_ETH_STATE_ACT_FEC		GENMASK_ULL(29, 28)
 
 #define NSP_ETH_CTRL_CONFIGURED		BIT_ULL(0)
 #define NSP_ETH_CTRL_ENABLED		BIT_ULL(1)
@@ -170,7 +171,13 @@ nfp_eth_port_translate(struct nfp_nsp *nsp, const union eth_table_entry *src,
 	if (dst->fec_modes_supported)
 		dst->fec_modes_supported |= NFP_FEC_AUTO | NFP_FEC_DISABLED;
 
-	dst->fec = 1 << FIELD_GET(NSP_ETH_STATE_FEC, state);
+	dst->fec = FIELD_GET(NSP_ETH_STATE_FEC, state);
+	dst->act_fec = dst->fec;
+
+	if (nfp_nsp_get_abi_ver_minor(nsp) < 33)
+		return;
+
+	dst->act_fec = FIELD_GET(NSP_ETH_STATE_ACT_FEC, state);
 }
 
 static void
-- 
2.30.2

