Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A625231F3
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiEKLkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiEKLjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:39:52 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2117.outbound.protection.outlook.com [40.107.244.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A153B2415EF
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 04:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcPyL/0f0JhWMalqh7bArRmp4HGwctMxC5Rup3RXGn/BKP/a+EQysKSO2Za/fpFakLaf4hZTWkS6+uuSvNY5wWKHbWKiGL69M4z/Eou7Mcg2soD9XdGu0JoBtm2QKNDFo9/NM2Dkd++SHTWPjQ/EwwvP9/eYi7QEnFS7cGH8CN7HonU0egdBI70geAHTj7za4AHHNPK2E7RdBv4mvLJSpW+AX72MtjWB/SP8/ygHqkS/LV9tQgCoTK9OkUc7aZt+mdB6haOhtMQUS1a7hA/zA5CHkxbO9Hfu788I+8/p7Ei2CALx99GERcJqEDoypP8adrtoSwN6Y6KkFxG64w+e2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrBMgqr416+ZL4uNfJKoIOnZbLMK9w/iGZWDF9V7ORY=;
 b=eaxyLZjmS7F8cuFGJws91laoOPBHFRXtFF+1QmHchPmtykbdkSofKavq5uNzDAVhX59w6MhaTX0R/TmTcUTGGIkFUCljZqQLJSPITCVkTp4e1U49f0lAGBZHWOts9kx2UbiFziHh7oa+NTyc/TUAXHMcKqr2AXJL4KxiQUeTxQuCdRsIn3reAuXkT77To+m9wcWCx7S1tFpAxmPFWeQHSEkZuQOMI01DTHL1cnMNTNgRIgr5aTYOT+quUQGIEOmRqKi1wQYUWZxlXe9hoViGtxPVpoL9zANj7T8bOZdNBDqhOEsh32Bcp1ibwkO708kmEbLS5MVT3SaezbqPD3L4KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrBMgqr416+ZL4uNfJKoIOnZbLMK9w/iGZWDF9V7ORY=;
 b=TB+gLrcI0PDPU3GZXLnj81MklFNkk89XjCMEjTGbnFl88WHgcr06DjEtw5IIhxcKcMY/5Y9+syIYZ86KUylV2gsBIAEXn7mHfysfs6hKeYg0k/fYj/17/HZqouNkR3SB+iga2PYGL+JHtACWX71v/bTNOECLl0zLPtbQQTfYCr8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR1301MB1988.namprd13.prod.outlook.com (2603:10b6:405:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.4; Wed, 11 May
 2022 11:39:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5250.012; Wed, 11 May 2022
 11:39:47 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>
Subject: [PATCH v2 net-next 2/2] nfp: VF rate limit support
Date:   Wed, 11 May 2022 13:39:32 +0200
Message-Id: <20220511113932.92114-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220511113932.92114-1-simon.horman@corigine.com>
References: <20220511113932.92114-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ba9144b-28dd-4bb1-0502-08da3342f3b3
X-MS-TrafficTypeDiagnostic: BN6PR1301MB1988:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1301MB1988BD21EADB747A06653CC8E8C89@BN6PR1301MB1988.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nl29gWwiS2V+vDDXC32rZrEPqkkTd0Y1gNIq64hUvCxQ49dhkHIpetYktF0mrs4E6vMjZ3qNYkBzFt7RpxSUdgbRd2QO9vwngMX8HdsHgQOXmo0LqLgODjUh3CbG88re14Zj8dqvUu38BsTgQNXpy7o4h+0MOq/G1mqxpxjL6xReVyXMyCMkyKwXzb2M9sJA9lPjkt8G3jq5dpanQpuumJsNw0ElUGAlmipxhuDqGjkAMkdiUC2/5Wihh5oyomX90521hq8LLpXNT5yJLsRn54LxMeY06fyVHkWVCOK2ThJnOuj9kaBUooFvTAYvHOWApiJsi+kz4nbTtutZ0RGJhD/5G3oWYT3kUAJH1F+2TFhFqYEmEofpYnW7l7TtnGg7E2Z0fe3TOAsJmPovufdNOOt/THfGVePMXntffEwZ/aOxbZ97hXXxMeV/bfNPqbr6G97+cn4nlZdFsiz1/DOBLkaaR3jMedJ7gMr7eEiPcRuNOAkW/NZL4m6PEDHIPnvkRoOJXHycywYze6UGzQkl/YzI6b5oHiNF5hwxIDiWACX3I6jlPRgQTXqqpnzOOILsReESbrtQVuQI5oRw0fik+A7AVWnlqYdOuqWy1JEfxvDVPKxJ65dmG1GT4ij/kt3ZuISw17HBKI+yYcm2Uc+L7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(396003)(39840400004)(346002)(136003)(6486002)(4326008)(6666004)(66946007)(66476007)(66556008)(508600001)(52116002)(83380400001)(2906002)(36756003)(8676002)(8936002)(44832011)(1076003)(107886003)(186003)(6512007)(316002)(5660300002)(2616005)(6506007)(38100700002)(86362001)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jiw1a9ly6SQEmOBVKapsxNm5uc6xqtCr9xayOq2tprN5OiPjxbQXQT83VArU?=
 =?us-ascii?Q?9ykFj+6lgw1LtFtWSEwhWyqxHQ16pECpIo+5JPM8gCpjvdgvPWD++hr44nB/?=
 =?us-ascii?Q?Qr93eE29ISEwvQvESzt9JkDB/cvCtxwJ4w4dtcwpPei5yACf0RTH4zYn+ocA?=
 =?us-ascii?Q?iezjo1OisQLBUbFizER/4mXGIS2uTf+Hb6fyFbI3khR1uHr2V+9/8+EblatA?=
 =?us-ascii?Q?18QOLYBBslQy1ucSGbzO4UcLJMcBvur+MZ2C6cpLV5DcLgKzfrCKGPbC3tcL?=
 =?us-ascii?Q?cTa1D/Y7KOP3Mn5ZQcsErxJ88UAHBm3s6K+r8OgwpD1/Ww0ZuHQoYGobwqg8?=
 =?us-ascii?Q?NdH57pc4Uf9j41oUmTRGVdirpD+SotE4A/zmvbRxRRF/PZdhFVKLFtkeko3B?=
 =?us-ascii?Q?6EC4/z4+g/+VyBTOHH5LDygNSqVmGWJulJhWByRHKg7KwcVNg8A2dSDp4efo?=
 =?us-ascii?Q?aoEzG3W+6Dewup52TiA0Ff7abyGfNK7XrhWDEkLYDfqukPLV4aPYh4uroP/Z?=
 =?us-ascii?Q?cvPBVWDPKaYDiFtCdXnVDiLwKbB6KZJlQH7Rkb2nU/TU11jwg/xpE2vzbN/r?=
 =?us-ascii?Q?xYEAcmcBBfQ/TgxS25ca1ks/7R4d8x7XyKvMn8cU39w7gPTGn/RkZnTb+rXM?=
 =?us-ascii?Q?YELVT7f3kDs+0PF5L8JzeZDCvWPLX1F5qcTjS9qxvYMkKfbVkQIqoKpiUKKt?=
 =?us-ascii?Q?Rmy/VObo1pwnSPvEUcK+k+RhhrYG8hQphW/9lTi7GEUI99h3bU/6CF14yq35?=
 =?us-ascii?Q?wjN7YttgUWOKFX8/IbUUlAX/izfkhI4lHV5EnBpWgizDH6N1mdiGNu2A0r44?=
 =?us-ascii?Q?qlYhR2+G7z+UVw0RVBokVpE2zNP971UcDpLgKDkEgqXmb3x76CvySw/HzgPe?=
 =?us-ascii?Q?Pgo8v0tQAiWJznM6jj4UkEV/NRIUEYDdEgJXzXkymYTcEBY7UvahJRKg0eO7?=
 =?us-ascii?Q?NUIyj4x9i8AN3QYZt086KrmSdbVNxnn2e8XQih9V3QvwG3Ax0gLS2hk9BY2Z?=
 =?us-ascii?Q?at4MvdJ6LnMbfjGvTIsPcbS1mbfbH4KJcPrvbEq6RdIFOy8Tt0lb6JwveVnq?=
 =?us-ascii?Q?EuhEkOUWOZSsxgx70ks4TrNSKb7mvsItP84rKpx6Ga4gPlQtcHvhUZJYxKlm?=
 =?us-ascii?Q?jWnPUWe519UyiM0FCtUV3jZtktByZcfB521ylxA1D49DSsbD4c5kjEdSTAP+?=
 =?us-ascii?Q?3nmPlTsFJO1eRzX74mwD54OksLjJBw7PjUdi34AsW0+svwfbnHx86o27UkMj?=
 =?us-ascii?Q?sdl4MBCG+YCdNtSbFMdwMMpLmYwG5EZqrtQ7l80ZAuPXISSyJCYqfDEYwRnk?=
 =?us-ascii?Q?1uLxqIexcRdz7IG7N5cOMr53VSl6Y3kRO37qH24FXR0yUwaclmbUsCOPb78j?=
 =?us-ascii?Q?a1Qm7085hvrdzaJ+Gno1/C2PEZ4cfIrIlDXg+pidGysX2UXD6r+o5712PbSa?=
 =?us-ascii?Q?olEpDDmHC2G36mskdKANT9FdYrA7cpCvZUz0pGGRKK4foy1taPa7iugG3zje?=
 =?us-ascii?Q?DaLuMT26rOnHgu8H4KHjKg+pe9GdSp9xsqqeMtFavukJbMZGonozbDljw9n+?=
 =?us-ascii?Q?8fxSz3ZYaBkBW89zP2tBq1tm+e7lUP0jAjJteNu+tXgPRVWFEpZcPtSFY/1n?=
 =?us-ascii?Q?wtQd5/aEHhEoBPUbxppPx/vefLwnEFpw7OuZ6CT/eLxhQt6ZlZahY4uKtzGo?=
 =?us-ascii?Q?AFA7sxgvMjCbeimNraSkZWbyxNId77zAGzWIgdIyypnIlwToV6hgFl2weZFI?=
 =?us-ascii?Q?YyR5TIiI4ywcwznvIBPAcpUzewmj4+52Fa3polNfLhY6TLV4UKZljdx+bGw3?=
X-MS-Exchange-AntiSpam-MessageData-1: J/7edkECwyBdbgQn3eiwFMSYkTZFlOARDpE=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba9144b-28dd-4bb1-0502-08da3342f3b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 11:39:47.7050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtP/BYSu63ALND6xCQEavLApRQzmKccaZHmj/VaXxdD+mvuqeejEUIC1duUqpPhhzChF/p0C1fWlT43Mz+VAADnMPvlcpLwFNjuWwfB+kc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1301MB1988
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bin Chen <bin.chen@corigine.com>

Add VF rate limit feature

This patch enhances the NFP driver to supports assignment of
both max_tx_rate and min_tx_rate to VFs

The template of configurations below is all supported.
e.g.
 # ip link set $DEV vf $VF_NUM max_tx_rate $RATE_VALUE
 # ip link set $DEV vf $VF_NUM min_tx_rate $RATE_VALUE
 # ip link set $DEV vf $VF_NUM max_tx_rate $RATE_VALUE \
			       min_tx_rate $RATE_VALUE
 # ip link set $DEV vf $VF_NUM min_tx_rate $RATE_VALUE \
			       max_tx_rate $RATE_VALUE

The max RATE_VALUE is limited to 0xFFFF which is about
63Gbps (using 1024 for 1G)

Signed-off-by: Bin Chen <bin.chen@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_common.c   |  1 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 48 ++++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |  9 ++++
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index e3594a5c2a85..4e56a99087fa 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1903,6 +1903,7 @@ const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= nfp_net_vlan_rx_kill_vid,
 	.ndo_set_vf_mac         = nfp_app_set_vf_mac,
 	.ndo_set_vf_vlan        = nfp_app_set_vf_vlan,
+	.ndo_set_vf_rate	= nfp_app_set_vf_rate,
 	.ndo_set_vf_spoofchk    = nfp_app_set_vf_spoofchk,
 	.ndo_set_vf_trust	= nfp_app_set_vf_trust,
 	.ndo_get_vf_config	= nfp_app_get_vf_config,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
index 4627715a5e32..54af30961351 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
@@ -142,6 +142,37 @@ int nfp_app_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 	return nfp_net_sriov_update(app, vf, update, "vlan");
 }
 
+int nfp_app_set_vf_rate(struct net_device *netdev, int vf,
+			int min_tx_rate, int max_tx_rate)
+{
+	struct nfp_app *app = nfp_app_from_netdev(netdev);
+	u32 vf_offset, ratevalue;
+	int err;
+
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate");
+	if (err)
+		return err;
+
+	if (max_tx_rate >= NFP_NET_VF_RATE_MAX ||
+	    min_tx_rate >= NFP_NET_VF_RATE_MAX) {
+		nfp_warn(app->cpp, "tx-rate exceeds %d.\n",
+			 NFP_NET_VF_RATE_MAX);
+		return -EINVAL;
+	}
+
+	vf_offset = NFP_NET_VF_CFG_MB_SZ + vf * NFP_NET_VF_CFG_SZ;
+	ratevalue = FIELD_PREP(NFP_NET_VF_CFG_MAX_RATE,
+			       max_tx_rate ? max_tx_rate :
+			       NFP_NET_VF_RATE_MAX) |
+		    FIELD_PREP(NFP_NET_VF_CFG_MIN_RATE, min_tx_rate);
+
+	writel(ratevalue,
+	       app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_RATE);
+
+	return nfp_net_sriov_update(app, vf, NFP_NET_VF_CFG_MB_UPD_RATE,
+				    "rate");
+}
+
 int nfp_app_set_vf_spoofchk(struct net_device *netdev, int vf, bool enable)
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
@@ -228,9 +259,8 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 			  struct ifla_vf_info *ivi)
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
-	unsigned int vf_offset;
+	u32 vf_offset, mac_hi, rate;
 	u32 vlan_tag;
-	u32 mac_hi;
 	u16 mac_lo;
 	u8 flags;
 	int err;
@@ -261,5 +291,19 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 	ivi->trusted = FIELD_GET(NFP_NET_VF_CFG_CTRL_TRUST, flags);
 	ivi->linkstate = FIELD_GET(NFP_NET_VF_CFG_CTRL_LINK_STATE, flags);
 
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate");
+	if (!err) {
+		rate = readl(app->pf->vfcfg_tbl2 + vf_offset +
+			     NFP_NET_VF_CFG_RATE);
+
+		ivi->max_tx_rate = FIELD_GET(NFP_NET_VF_CFG_MAX_RATE, rate);
+		ivi->min_tx_rate = FIELD_GET(NFP_NET_VF_CFG_MIN_RATE, rate);
+
+		if (ivi->max_tx_rate == NFP_NET_VF_RATE_MAX)
+			ivi->max_tx_rate = 0;
+		if (ivi->min_tx_rate == NFP_NET_VF_RATE_MAX)
+			ivi->min_tx_rate = 0;
+	}
+
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
index 7b72cc083476..2d445fa199dc 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
@@ -20,6 +20,7 @@
 #define   NFP_NET_VF_CFG_MB_CAP_LINK_STATE		  (0x1 << 3)
 #define   NFP_NET_VF_CFG_MB_CAP_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO		  (0x1 << 5)
+#define   NFP_NET_VF_CFG_MB_CAP_RATE			  (0x1 << 6)
 #define NFP_NET_VF_CFG_MB_RET				0x2
 #define NFP_NET_VF_CFG_MB_UPD				0x4
 #define   NFP_NET_VF_CFG_MB_UPD_MAC			  (0x1 << 0)
@@ -28,6 +29,7 @@
 #define   NFP_NET_VF_CFG_MB_UPD_LINK_STATE		  (0x1 << 3)
 #define   NFP_NET_VF_CFG_MB_UPD_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_UPD_VLAN_PROTO		  (0x1 << 5)
+#define   NFP_NET_VF_CFG_MB_UPD_RATE			  (0x1 << 6)
 #define NFP_NET_VF_CFG_MB_VF_NUM			0x7
 
 /* VF config entry
@@ -48,10 +50,17 @@
 #define   NFP_NET_VF_CFG_VLAN_PROT			  0xffff0000
 #define   NFP_NET_VF_CFG_VLAN_QOS			  0xe000
 #define   NFP_NET_VF_CFG_VLAN_VID			  0x0fff
+#define NFP_NET_VF_CFG_RATE				0xc
+#define   NFP_NET_VF_CFG_MIN_RATE			0x0000ffff
+#define   NFP_NET_VF_CFG_MAX_RATE			0xffff0000
+
+#define NFP_NET_VF_RATE_MAX			0xffff
 
 int nfp_app_set_vf_mac(struct net_device *netdev, int vf, u8 *mac);
 int nfp_app_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 			__be16 vlan_proto);
+int nfp_app_set_vf_rate(struct net_device *netdev, int vf, int min_tx_rate,
+			int max_tx_rate);
 int nfp_app_set_vf_spoofchk(struct net_device *netdev, int vf, bool setting);
 int nfp_app_set_vf_trust(struct net_device *netdev, int vf, bool setting);
 int nfp_app_set_vf_link_state(struct net_device *netdev, int vf,
-- 
2.30.2

