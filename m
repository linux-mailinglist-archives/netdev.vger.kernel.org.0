Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D759D5A131E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241864AbiHYOOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241229AbiHYONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:13:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428EC9E0DC
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:13:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvy6B3kjcXdY5M+qScXNVBmXP+dJ4siUgTmorhZRnZn6Sclknuj8Grswemeg60B/1UGfgH/dU0gaqMxgOLDDlrowLlLrPYc8VR6MBarsbPGQJ1Z0p7KDRwey3/k9Tux01I/rI7iRSIO9lxDDTTQnQTfeqkyQd/rk0vEMesKz+zIlSxgGkQTxSxELK/UOvcg5/p2ScACLhytKM0VtybVckFZb7VyppwhZXRao/grKFbLRj9oYoXusA1bBZbRKfj1+Jae0P/PPvbEnFpiNY8VlmdJcZNHeBzhBauwv5+vQx6r/kTSEYymgPL+53hsX4t0zLNJLEfTx6P0i5ebHmEC4rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuKu7PlIdgF+NWM62Xe6i+zMocafsAB4slMA52+BU+U=;
 b=CX1/YlsmCQQSt7671+4C2olELuT6xtBY/fscjoB0b/UJ92W5kTN3OjHh4tmx8Q6f8DTH+UPeSUZCUnxtx2mXOhdZftMyIk7DWrZEQAjj/fnyRHCZCsRqNz4iHaczpbyd0wlbvopprsd/urDSP6MjgT9Z9Qqd4trwOgHwaJsaUhNKKMPsjIDIEJ1LiV6jDO8T1c3XXFIZJ9YfdglIrp48tPNixa+8m/OFfT2j6Z0Yof9gqERO0aF5R6zvbNw8NVI1UKfP1dTsUieWm2oCOVAaJuOy/g8Uv7I+vxIOHI13hPERzxzHYNczqaiTSe6dK4mLzwv6cLtRF4NmqWQJORylpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuKu7PlIdgF+NWM62Xe6i+zMocafsAB4slMA52+BU+U=;
 b=D49wKqcAbyFPUN2haMRq+vH1ACpPnOu8Y9qbGDlmrYwH++qbkVHapX3CRTOVcweO4NEz35wASZkOo1bZZd2W0zVTFjs6ljW2q7MWo1pNS3wQHvBQ6gLkZxc2SV6t8z0uzcmoZ2jOMo2kXt7guxt/DtOCgTLOGT9pEbLLrBHXsQw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5401.namprd13.prod.outlook.com (2603:10b6:a03:424::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 14:12:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%8]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 14:12:42 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 2/3] nfp: check if application firmware is indifferent to port speed
Date:   Thu, 25 Aug 2022 16:12:22 +0200
Message-Id: <20220825141223.22346-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825141223.22346-1-simon.horman@corigine.com>
References: <20220825141223.22346-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fa373a6-86bb-4f9f-0d82-08da86a3e034
X-MS-TrafficTypeDiagnostic: SJ0PR13MB5401:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SuaEzUNiV9con8oSZfTPKwye/uNUEFjIVOOId8SgiTG6BYXaGeRJRXb8q4Mmmxg7Wnrw3xvYYGEicwYLTXkJqsJRzBvWZi4nYdSfJRLnNVouGW9Q3Ls61by8awyO9giQYC7VPf9Rt2+ysPmuThru44kwEX1ZGUZ1YzGfTeVRfjIfFOZM/5zucJYuhSuDNMO3LwFoLOAg5zEBs92K6C2FG7IR8/WEPHJ2WiRjaTLQWsvNjR8138XzN6h74zmns9ciFV8ZUXcFykHGMNUhIxIWaY87vnwfVZwzFtdLE+cP/CHB++u+0e6mHnP9Pe7iA2oeloSPk4JenfYUasxYG8uL24VcRcsJkJgZTB0h9JbwoahBQj+ao/iVKpZl8DoTNtq1nKiR8sZZ4mUz726J86YFjiiPNycZsxgjL/JGQ1gd5ge30uLraei/dXlK6xDzF1enNsZ597Xksx4GH9fAspvyG3ZBrVaeof9XFd0S/suLm/g/Wt8izu7QGVEEmt+MtznMecYFbHutL4byzJJQCluzU4YBQ2llhjOB+KQKN+mX+y7RiGltMR1tdRrP3GdUVpVHS4Ru1LhehxYMUOUK/bz0lctdOj+b0G+8dgQZCw6Xu23g81HF3C047bq7v/bI0KhXE6eEgP0vXe0qMYKQ+SO89EvZel6hFVSo29CainW4pjRhZTQwxdq/Wx2fS97zbo835Z2p6uBf9BrzZ3CB1X8kfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(136003)(346002)(39840400004)(86362001)(83380400001)(38100700002)(8936002)(4326008)(66946007)(6486002)(478600001)(8676002)(66476007)(66556008)(52116002)(110136005)(316002)(44832011)(6666004)(1076003)(2906002)(6512007)(36756003)(5660300002)(107886003)(186003)(41300700001)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?falCIFburidmQbxS03H7FB8YvvsHdGW9k3czzSml9Pk7hnaEO2l6tXrQ4Sbd?=
 =?us-ascii?Q?PZP1j8DENSKQb7juH/CBHHQ4dS3bdZcKrlYS47Ix17SNIQpbAJg01twPkjQV?=
 =?us-ascii?Q?wS/NkSpWLHBrQbmFsjA3LqAbR8tcIoTRk0v/cNj2jaG9m0zwRjqzwzC/7cl6?=
 =?us-ascii?Q?ZdA+knQ5jwH4E/VwcBbsYhVABU2r3ljB0LD9b5/9YWkKWoCOAA1eE2CQ+0rt?=
 =?us-ascii?Q?Ae1/HfYA1Jq4cVE+cbEG+QvrHSO5MBivASGQvLjg4xgLvxtvV0x8A9n7WSwl?=
 =?us-ascii?Q?WLr+gppuJkAl2Y9m0GFv6cakWTZ3MXr4icZX+uHUf9wuyTsiVBLMSrz23Ama?=
 =?us-ascii?Q?DmkZk/JJ5/np3l8c1/QPtXKsBBID2f2aBF/N3b29MM/ikaZMhELbP3Nn0BMj?=
 =?us-ascii?Q?y3vm7HDL1MjPn7RiwF/yZzsugZJn66F1CaZM7bktZeoSgOwQkllGiteNHXRj?=
 =?us-ascii?Q?T5o9SdpKqlcusOgKvn6K9u+Anl0o/jPMzsXcyG/0BjAgmC6C8THB9dMY8ef/?=
 =?us-ascii?Q?UHFHU9KRCZk2tjGourmrg4dwzrcREBghcOPLP6o+koHvAwvo1Zsjj6pIuaeX?=
 =?us-ascii?Q?3VMOfK5m4byra0VvNK/ntDhMykkZttNaVEq1NpzrVvbpc+FrHXwwbTVD1sFq?=
 =?us-ascii?Q?jeiSCPlJGzaxEnt3gwK1E+f5Te/gM1vgPSlPaG80trqqzRkb5mAl0auIGlus?=
 =?us-ascii?Q?h+w2dSQag3sUrRKSpnpf/HUpuHSIj9UHdZWixVUosBXIeTheOGLR3VwANqK8?=
 =?us-ascii?Q?I2mCTet3JQTA4k8Du2rI2XIHoLDFM3n8uWXPktOZJIlpp93cIxFrqBgWo458?=
 =?us-ascii?Q?Iq9xPbAgmdfE/L9RDHog4rWF//bhBO6RxjVBRi8KMaU5+Ms+UGVFAczmoe5x?=
 =?us-ascii?Q?MMZSUpxllSWvYoU4lWMWHCM/uc+ZO3S0jmiqqqoFrPnI83176uGWEspVrITB?=
 =?us-ascii?Q?NLBIJHQvKWLxwQ6UG/nT+1svH5eYVBC2gDp4zQPGxflx+AW9BO6KMObFI4MH?=
 =?us-ascii?Q?ArY8Q2qGE0bh+KwHkEHV8bSgg0pT+SMGVYXOqfVhjllH4C4Yb7wXQHh04IKV?=
 =?us-ascii?Q?DVFNcMvRaULnEHwwFciHON9WSD9kW7FzuiqsIscjBHGDdOyeN9VPvWIWRuEo?=
 =?us-ascii?Q?UrQqCmqE273foqrpP47vE2p3UCkxEO4DRCJKGHlufFuqd9ofm1fuMByOvavr?=
 =?us-ascii?Q?URJ0MzX/78fUFSjiGTbojZISXHQ/dYEV/PwTY0eyGAY9ueDVEKRS0Yi0mzI3?=
 =?us-ascii?Q?hIE6QxzTgo+PHjNOXjbDE1i978WbDJzDb67hydFt8KAMsgqVTYJ2yXsvrGLP?=
 =?us-ascii?Q?EmdZmt4nH7p1UB6Ecws/bLwch78IoxME9RtFgUv1ObqDkpLK1va/UbWxiyWO?=
 =?us-ascii?Q?ZP9bSNINlJEXd/tEeuzWhJDJ7mbMZnT/HPJQFc35rVP6gmT3aVQjy6uGixUv?=
 =?us-ascii?Q?HjsSpckHXJ1SGiS06je1LQ+VyiXTrYMIvs/O7JDQtpbYn2jdNdHu+wkC8d2g?=
 =?us-ascii?Q?zNqIUodpS61D8UC1i0v5YqwKV93zVoLRPQHdNFM0mMPF21CiZxcmQF5Oc7KB?=
 =?us-ascii?Q?ivyqdHJZ+honG19Yf6/q4Namz4If41vhGNiHRvHOiB/gEWXWcz4TBo45nkVL?=
 =?us-ascii?Q?ej6lztfYTYZBWJLsmyak5MDwSTSdKWWKxTLQyYGbMYbNKnAampBYLFOLVRzM?=
 =?us-ascii?Q?+/MxPA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa373a6-86bb-4f9f-0d82-08da86a3e034
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 14:12:42.6895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vr3hUBk4qVzKizEcLB1LfxxyQQ49Vn1kaJP/q/EhAos8I7wtap5TWWzMHKZG7DoFSWGn5hGKo5LF3TOZNNMHrQ10eSdytsW+GkX2XaC9//c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5401
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

A new tlv type is introduced to indicate if application firmware is
indifferent to port speed, and inform management firmware of the
result.

And the result is always true for flower application firmware since
it's indifferent to port speed from the start and will never change.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  2 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.c |  8 ++++
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  7 +++
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 43 ++++++++++++++++++-
 4 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index be3746cbc58b..6805af186f1b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -65,6 +65,7 @@ struct nfp_dumpspec {
  * @num_vfs:		Number of SR-IOV VFs enabled
  * @fw_loaded:		Is the firmware loaded?
  * @unload_fw_on_remove:Do we need to unload firmware on driver removal?
+ * @sp_indiff:		Is the firmware indifferent to physical port speed?
  * @ctrl_vnic:		Pointer to the control vNIC if available
  * @mip:		MIP handle
  * @rtbl:		RTsym table
@@ -114,6 +115,7 @@ struct nfp_pf {
 
 	bool fw_loaded;
 	bool unload_fw_on_remove;
+	bool sp_indiff;
 
 	struct nfp_net *ctrl_vnic;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
index c3a763134e79..d81bd8697047 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
@@ -148,6 +148,14 @@ int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
 							  true))
 				return -EINVAL;
 			break;
+		case NFP_NET_CFG_TLV_TYPE_SP_INDIFF:
+			if (length) {
+				dev_err(dev, "Unexpected len of SP_INDIFF TLV:%u\n", length);
+				return -EINVAL;
+			}
+
+			caps->sp_indiff = true;
+			break;
 		default:
 			if (!FIELD_GET(NFP_NET_CFG_TLV_HEADER_REQUIRED, hdr))
 				break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 91708527a47c..1d53f721a1c8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -492,6 +492,10 @@
  * %NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS_RX_SCAN:
  * Same as %NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS, but crypto TLS does stream scan
  * RX sync, rather than kernel-assisted sync.
+ *
+ * %NFP_NET_CFG_TLV_TYPE_SP_INDIFF:
+ * Empty, indicate the firmware is indifferent to port speed. Then no need to
+ * reload driver and firmware when port speed is changed.
  */
 #define NFP_NET_CFG_TLV_TYPE_UNKNOWN		0
 #define NFP_NET_CFG_TLV_TYPE_RESERVED		1
@@ -505,6 +509,7 @@
 #define NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS		11 /* see crypto/fw.h */
 #define NFP_NET_CFG_TLV_TYPE_VNIC_STATS		12
 #define NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS_RX_SCAN	13
+#define NFP_NET_CFG_TLV_TYPE_SP_INDIFF		14
 
 struct device;
 
@@ -519,6 +524,7 @@ struct device;
  * @vnic_stats_off:	offset of vNIC stats area
  * @vnic_stats_cnt:	number of vNIC stats
  * @tls_resync_ss:	TLS resync will be performed via stream scan
+ * @sp_indiff:		Firmware is indifferent to port speed
  */
 struct nfp_net_tlv_caps {
 	u32 me_freq_mhz;
@@ -531,6 +537,7 @@ struct nfp_net_tlv_caps {
 	unsigned int vnic_stats_off;
 	unsigned int vnic_stats_cnt;
 	unsigned int tls_resync_ss:1;
+	unsigned int sp_indiff:1;
 };
 
 int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index dd668520851e..e2d4c487e8de 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -206,6 +206,7 @@ nfp_net_pf_alloc_vnics(struct nfp_pf *pf, void __iomem *ctrl_bar,
 			nn->port->link_cb = nfp_net_refresh_port_table;
 
 		ctrl_bar += NFP_PF_CSR_SLICE_SIZE;
+		pf->sp_indiff |= nn->tlv_caps.sp_indiff;
 
 		/* Kill the vNIC if app init marked it as invalid */
 		if (nn->port && nn->port->type == NFP_PORT_INVALID)
@@ -307,6 +308,37 @@ static int nfp_net_pf_init_vnics(struct nfp_pf *pf)
 	return err;
 }
 
+static int nfp_net_pf_cfg_nsp(struct nfp_pf *pf, bool sp_indiff)
+{
+	struct nfp_nsp *nsp;
+	char hwinfo[32];
+	int err;
+
+	nsp = nfp_nsp_open(pf->cpp);
+	if (IS_ERR(nsp)) {
+		err = PTR_ERR(nsp);
+		return err;
+	}
+
+	snprintf(hwinfo, sizeof(hwinfo), "sp_indiff=%d", sp_indiff);
+	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
+	if (err)
+		nfp_warn(pf->cpp, "HWinfo(sp_indiff=%d) set failed: %d\n", sp_indiff, err);
+
+	nfp_nsp_close(nsp);
+	return err;
+}
+
+static int nfp_net_pf_init_nsp(struct nfp_pf *pf)
+{
+	return nfp_net_pf_cfg_nsp(pf, pf->sp_indiff);
+}
+
+static void nfp_net_pf_clean_nsp(struct nfp_pf *pf)
+{
+	(void)nfp_net_pf_cfg_nsp(pf, false);
+}
+
 static int
 nfp_net_pf_app_init(struct nfp_pf *pf, u8 __iomem *qc_bar, unsigned int stride)
 {
@@ -318,6 +350,8 @@ nfp_net_pf_app_init(struct nfp_pf *pf, u8 __iomem *qc_bar, unsigned int stride)
 	if (IS_ERR(pf->app))
 		return PTR_ERR(pf->app);
 
+	pf->sp_indiff |= pf->app->type->id == NFP_APP_FLOWER_NIC;
+
 	devl_lock(devlink);
 	err = nfp_app_init(pf->app);
 	devl_unlock(devlink);
@@ -780,10 +814,14 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_clean_ddir;
 
-	err = nfp_net_pf_alloc_irqs(pf);
+	err = nfp_net_pf_init_nsp(pf);
 	if (err)
 		goto err_free_vnics;
 
+	err = nfp_net_pf_alloc_irqs(pf);
+	if (err)
+		goto err_clean_nsp;
+
 	err = nfp_net_pf_app_start(pf);
 	if (err)
 		goto err_free_irqs;
@@ -801,6 +839,8 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	nfp_net_pf_app_stop(pf);
 err_free_irqs:
 	nfp_net_pf_free_irqs(pf);
+err_clean_nsp:
+	nfp_net_pf_clean_nsp(pf);
 err_free_vnics:
 	nfp_net_pf_free_vnics(pf);
 err_clean_ddir:
@@ -831,6 +871,7 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 		nfp_net_pf_free_vnic(pf, nn);
 	}
 
+	nfp_net_pf_clean_nsp(pf);
 	nfp_net_pf_app_stop(pf);
 	/* stop app first, to avoid double free of ctrl vNIC's ddir */
 	nfp_net_debugfs_dir_clean(&pf->ddir);
-- 
2.30.2

