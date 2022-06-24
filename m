Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E68D559446
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiFXHiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFXHiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:38:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F0B56F9F
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:38:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISAC9E7QXaaufP/RwXqWdbJFOFJvv0e0KErCdNVoGT73HobTSi8oFaSz/aW/BGvaBDrgSTGd65tUlB2Es7oPVfIQFOYtQlen+4A+H90OxNQSqeupsLIsBBwD9zjkzvPgi+egwX/XxmKWskZgWI2eNlY3GfbgpkmI2Bw73wMEvE64WHu/VAjeaJoKb133jHKocVVovP/hK6AMvMgETyD7sz2cLwYKZs35qvMISGCFjWSKvjvl/XCfcvubEYTFxdUZ9S+AeopIZd3HZr18ThQTQwydI9BmZwFcgUnerQgtmGYyE8fZ6ViWUBfsxXWbi5dOQYOGP2sKIxMyZfVvLW7e/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZejlmLIBHfnyvwsVTnXcxFejPmCH71U2zXD/NWI5o0=;
 b=BNEEKcpufIcYB+pl2pYAp+yztD4tthoY97KAgx8qA7hbmOVdUsDtMrjkiA9SePe46kKJy4NyLHqON7kOcYzLKDC4cUqoeGabWxLeSQfOhROm1pagGPwcvdYY2j4nnYeeTVFkCtBBMANNDRr0eh/IsAP4ssfnyJsq4ol9xoSyJmDVIBD+k4hKfnVFrQkUuFnBfQzJn8sXiU4ST0iVtPZTzSqtT4rq9np8r47Ip21QhS2oT/UsTfS6Ud8TxDap2shpuIdlKhw+lufEG1x4us//RVMOxxqol1Ku3zVjhkYpRfM6q8/tAa6vo7EFzxkRsyY6Wbb8p1/5PVDvqQ9AKqcIGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZejlmLIBHfnyvwsVTnXcxFejPmCH71U2zXD/NWI5o0=;
 b=kcAQsReh/PENy1fUv0P4W3GXqXMfM6rAeWFlgkqBDurLRFT+FnFJPb6zoJFFOBDOuYEM9LhuJQbnk6cB+seXi4tBAA9ZPW2O5Z1K08BNeWLFTk4SHgqn1NwGUljuAPCfwodifW9sWtkvqYnCec3oqQx4CYb5cesJVMtKHi1Z2ss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1494.namprd13.prod.outlook.com (2603:10b6:903:13b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 07:38:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%6]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 07:38:47 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next 2/2] nfp: add support for 'ethtool -t DEVNAME' command
Date:   Fri, 24 Jun 2022 09:38:16 +0200
Message-Id: <20220624073816.1272984-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220624073816.1272984-1-simon.horman@corigine.com>
References: <20220624073816.1272984-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c6288b1-5154-4bea-5b3b-08da55b492ab
X-MS-TrafficTypeDiagnostic: CY4PR13MB1494:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BlE29N2Uki+0dztadIexzuSKAL7JS5WMWxpuX9zGTWGEQcJCygbsowxr7Vw9dIhfJpBGdytRWfRZAxoOSOt0H2EJgnenZTfADwUrmwF6NH2hnCCgKZBEphJM8kjB60h0rFBm3nD3v/o1xlPeeH36cxa7zsYqNZtp2ZEiqGZ+wkINDx9U4TfnwabNpKXweIzcSkdukF1L8j8qRDqVxhxFrZE6iiwurlMRjs1PECLznkiNxQJvVACzUZMJ4nLsaGX1IU9rSbMCHRnXG3FaEECcx9odJwf0BAVmRtM+JGx+UJU3eaMkg+HHY+lWtGY80SvEOB+q5/4cv3jJS5hWCjiD9JwwAcqq86Ic0WspXzHoZ8+5jziyTOoxTqYkOac7LDxyY+8GLBm3AuhL1083RsBo3CL3zEarMj/HStcqRoXWKAeeOBMw6vQO0Q+bStdjrcfo9I13+Ef5jKQbclFl87Y+NtAvGx4xCwjshNfVb5rIv8f34nPQ6CbjnGtfc6q89LvyJqpQSG/nkr43H/J9pTwnqQIXLmoRLf4PtSicLF0/jkbpSgE4r4qoLSUFQvs/YTAc5edmzyMYYr1ffsPpOav7wlU5SmDsBJInjE6i8yRjRuf+Y+zukdlPRzgPqOq3x8uJ28VisWuwlKoRw7+FxA4VbOQhLcBZlpQNsYS3jumXYHSGR9MU26X8JMxZxXEh9e3+wtu3yX6Aps+2E6jhFOUQ5KWcWxEEkJoYOJcy75CYWao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39830400003)(366004)(376002)(396003)(346002)(316002)(86362001)(8936002)(83380400001)(110136005)(36756003)(6506007)(186003)(8676002)(6486002)(38100700002)(107886003)(6666004)(478600001)(66946007)(66556008)(6512007)(44832011)(66476007)(52116002)(4326008)(2616005)(1076003)(41300700001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FotAKH0eQULFMegekPlEeYfyHZWVabqgnHWyhLC+oky7FVmAzK4BH4ak6G5q?=
 =?us-ascii?Q?q2L/fDZOp1L4Lj+DskMTa2oaSWAHajAeZHwvrK6zFJdcW4RTzyxjw7slz7Qn?=
 =?us-ascii?Q?jhy8fAeP+ysOJHvxUwItM6OYKpTxFqEH3/HoNoIMUYHY/XThQ6/EGdmQtk8H?=
 =?us-ascii?Q?5h4+ZFao0kYHEIkuV11ASb3owgmByIRuB5wGg7Xhn6w28/Jggis3prFUtn/A?=
 =?us-ascii?Q?A18ZvtA4pc1+vL+iafu2KzrFef3HgVSHYRzyXHqwTlBEwwX1l0yxDE/tzStN?=
 =?us-ascii?Q?CtzhdEexlDJ6Na92pQd30WKj9JyuFX3DRNAMSh2ekIjfuVvmWU8LLLk0xc0g?=
 =?us-ascii?Q?rKq6fP/7PAEf1Fst2ooSRKPGv4FyHHKMNAGRCylekJuH2SA9S+AXpoP5a0ev?=
 =?us-ascii?Q?Lo/JrfGctDa3q2Am2ST2K6OiimK7Pfmc6dwv1ehYRkKRQqW3Nj+O6H0Cpsww?=
 =?us-ascii?Q?CrWy06weEKZ+sf7WZBlZi+OchVv/nE/Jyj5URJaxBYOpwpsBRaYg4T+T/UPq?=
 =?us-ascii?Q?1I/SHfg2pqCKHOvO38YRb47h6C7Igz78xaKYwk/zL34Gyt+uUstoa8v6a6vT?=
 =?us-ascii?Q?IsOIPomfP2bIyLMI2i4DpzBbdEWPkgHY9Z1danF/KQS/Y0WTdzN0rgn855RC?=
 =?us-ascii?Q?7OmPISUELtwknuURAhb0k99wdhNhYO/VxH6lZ8MYTmwIzbGbvziaX4gm6hVj?=
 =?us-ascii?Q?jojLyyEfaqnAQ9gIIsP95Tpb80URiaPdvncvKt0VGIlsz47825eIysuM/ymX?=
 =?us-ascii?Q?vF4U/Wzf/ihMpjqLIdLf0nRmN4XHFVELe/Dd5/bOoqmQgEWG5slO0WII1eMw?=
 =?us-ascii?Q?/6GLkDw2VczXN16t8YyiECNHNbFHMu28DNKRMEPIByuWFH113ju7UAmPnr4K?=
 =?us-ascii?Q?lb558Ev6vk6PPubL5K0KxZAq9/7GUIZaC9NHbtwh1iWaNfi6Bg6nFvIViJP6?=
 =?us-ascii?Q?GuZFiHnhsfa7hYzPhnqS6A0ek6ss+YjP7zxPGqNJ2Fn1b7uPo2ignHl0p+Te?=
 =?us-ascii?Q?5XETaUfNGL8Wrf69AfRdeyEiOZuaXQJMevpRqs30hykFw+v44kE2bLqTaGeL?=
 =?us-ascii?Q?7tb1oSRrWI9u3II9lOWuTd+3TRphQtWWX3BcYb6RT7Qo3TVLzEdDV+Aq5+5M?=
 =?us-ascii?Q?TBjV61yyhaB52h9qAmnY9ELYp0PD/zzVGgV+NYD55lU+gDzvxpGhX4550/MT?=
 =?us-ascii?Q?b7yr7kmBz/utLdGYq/jLVzFurcdq6y0heuG790vNQNUff/njxX25JREAp7UX?=
 =?us-ascii?Q?rBYZIFBCP4E6mDlYGqhOOoI6x+FR/rKFEzk61n85o/zX7468hTxIqxiSr1m3?=
 =?us-ascii?Q?0ZNsLwyK7evXvUQ3zqUAu7FGHyANDR0pXCtW8stv1ZWpY/KNshlGZuZ4+i7n?=
 =?us-ascii?Q?BA8zMsH8xAo9htSmi15p3soB3SafPU1YCAHOBlTk9VvmTarMwQuzcMk7Zupy?=
 =?us-ascii?Q?PznKsB0HmLNYnEb1I2DLK8R+ze7imkuwpry32SOYCndhJzW7TOpFI+8MWV1f?=
 =?us-ascii?Q?CVIcapcsWn3/JURnEaaiy5IhDcVT5oUGafvRpaYLigdUN0m4qHo80X54YRD/?=
 =?us-ascii?Q?4HC29WSBcyuLEmTG8EaUKn7KjRbs+JYI9rYfuTZuibB0r+3cOkhYeS9YQBxA?=
 =?us-ascii?Q?B8CAQObyq2XoY30LPLF90rh4Q/gDwvhNf/tmzVyJuUzSBGPMB2WJg16eM8FY?=
 =?us-ascii?Q?JABCMg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6288b1-5154-4bea-5b3b-08da55b492ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 07:38:47.1723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 955V+V1+IbBNsWJMuy2Mjd/7/FUnwuQSnA/cx9fpQX63pl504Rk9cjstPB0CUjPDH1HhvMpUGiYr1GS1580YiUNR3PgvTXxZnAbhiQEIUtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

Add support for ethtool selftest.

e.g.
 # ethtool -t DEVNAME

test result like:
The test result is PASS
The test extra info:
Link Test        0
NSP Test         0
Firmware Test    0
Register Test    0

Signed-off-by: Fei Qin <fei.qin@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 167 ++++++++++++++++++
 1 file changed, 167 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 7475b209353f..c922dfab8080 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -29,6 +29,7 @@
 #include "nfp_net_dp.h"
 #include "nfp_net.h"
 #include "nfp_port.h"
+#include "nfpcore/nfp_cpp.h"
 
 struct nfp_et_stat {
 	char name[ETH_GSTRING_LEN];
@@ -442,6 +443,160 @@ static int nfp_net_set_ringparam(struct net_device *netdev,
 	return nfp_net_set_ring_size(nn, rxd_cnt, txd_cnt);
 }
 
+static int nfp_test_link(struct net_device *netdev)
+{
+	if (!netif_carrier_ok(netdev) || !(netdev->flags & IFF_UP))
+		return 1;
+
+	return 0;
+}
+
+static int nfp_test_nsp(struct net_device *netdev)
+{
+	struct nfp_app *app = nfp_app_from_netdev(netdev);
+	struct nfp_nsp_identify *nspi;
+	struct nfp_nsp *nsp;
+	int err;
+
+	nsp = nfp_nsp_open(app->cpp);
+	if (IS_ERR(nsp)) {
+		err = PTR_ERR(nsp);
+		netdev_info(netdev, "NSP Test: failed to access the NSP: %d\n", err);
+		goto exit;
+	}
+
+	if (nfp_nsp_get_abi_ver_minor(nsp) < 15) {
+		err = -EOPNOTSUPP;
+		goto exit_close_nsp;
+	}
+
+	nspi = kzalloc(sizeof(*nspi), GFP_KERNEL);
+	if (!nspi) {
+		err = -ENOMEM;
+		goto exit_close_nsp;
+	}
+
+	err = nfp_nsp_read_identify(nsp, nspi, sizeof(*nspi));
+	if (err < 0)
+		netdev_info(netdev, "NSP Test: reading bsp version failed %d\n", err);
+
+	kfree(nspi);
+exit_close_nsp:
+	nfp_nsp_close(nsp);
+exit:
+	return err;
+}
+
+static int nfp_test_fw(struct net_device *netdev)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	int err;
+
+	err = nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_GEN);
+	if (err)
+		netdev_info(netdev, "FW Test: update failed %d\n", err);
+
+	return err;
+}
+
+static int nfp_test_reg(struct net_device *netdev)
+{
+	struct nfp_app *app = nfp_app_from_netdev(netdev);
+	struct nfp_cpp *cpp = app->cpp;
+	u32 model = nfp_cpp_model(cpp);
+	u32 value;
+	int err;
+
+	err = nfp_cpp_model_autodetect(cpp, &value);
+	if (err < 0) {
+		netdev_info(netdev, "REG Test: NFP model detection failed %d\n", err);
+		return err;
+	}
+
+	return (value == model) ? 0 : 1;
+}
+
+static bool link_test_supported(struct net_device *netdev)
+{
+	return true;
+}
+
+static bool nsp_test_supported(struct net_device *netdev)
+{
+	if (nfp_app_from_netdev(netdev))
+		return true;
+
+	return false;
+}
+
+static bool fw_test_supported(struct net_device *netdev)
+{
+	if (nfp_netdev_is_nfp_net(netdev))
+		return true;
+
+	return false;
+}
+
+static bool reg_test_supported(struct net_device *netdev)
+{
+	if (nfp_app_from_netdev(netdev))
+		return true;
+
+	return false;
+}
+
+static struct nfp_self_test_item {
+	char name[ETH_GSTRING_LEN];
+	bool (*is_supported)(struct net_device *dev);
+	int (*func)(struct net_device *dev);
+} nfp_self_test[] = {
+	{"Link Test", link_test_supported, nfp_test_link},
+	{"NSP Test", nsp_test_supported, nfp_test_nsp},
+	{"Firmware Test", fw_test_supported, nfp_test_fw},
+	{"Register Test", reg_test_supported, nfp_test_reg}
+};
+
+#define NFP_TEST_TOTAL_NUM ARRAY_SIZE(nfp_self_test)
+
+static void nfp_get_self_test_strings(struct net_device *netdev, u8 *data)
+{
+	int i;
+
+	for (i = 0; i < NFP_TEST_TOTAL_NUM; i++)
+		if (nfp_self_test[i].is_supported(netdev))
+			ethtool_sprintf(&data, nfp_self_test[i].name);
+}
+
+static int nfp_get_self_test_count(struct net_device *netdev)
+{
+	int i, count = 0;
+
+	for (i = 0; i < NFP_TEST_TOTAL_NUM; i++)
+		if (nfp_self_test[i].is_supported(netdev))
+			count++;
+
+	return count;
+}
+
+static void nfp_net_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
+			      u64 *data)
+{
+	int i, ret, count = 0;
+
+	netdev_info(netdev, "Start self test\n");
+
+	for (i = 0; i < NFP_TEST_TOTAL_NUM; i++) {
+		if (nfp_self_test[i].is_supported(netdev)) {
+			ret = nfp_self_test[i].func(netdev);
+			if (ret)
+				eth_test->flags |= ETH_TEST_FL_FAILED;
+			data[count++] = ret;
+		}
+	}
+
+	netdev_info(netdev, "Test end\n");
+}
+
 static unsigned int nfp_vnic_get_sw_stats_count(struct net_device *netdev)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
@@ -705,6 +860,9 @@ static void nfp_net_get_strings(struct net_device *netdev,
 		data = nfp_mac_get_stats_strings(netdev, data);
 		data = nfp_app_port_get_stats_strings(nn->port, data);
 		break;
+	case ETH_SS_TEST:
+		nfp_get_self_test_strings(netdev, data);
+		break;
 	}
 }
 
@@ -739,6 +897,8 @@ static int nfp_net_get_sset_count(struct net_device *netdev, int sset)
 		cnt += nfp_mac_get_stats_count(netdev);
 		cnt += nfp_app_port_get_stats_count(nn->port);
 		return cnt;
+	case ETH_SS_TEST:
+		return nfp_get_self_test_count(netdev);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -757,6 +917,9 @@ static void nfp_port_get_strings(struct net_device *netdev,
 			data = nfp_mac_get_stats_strings(netdev, data);
 		data = nfp_app_port_get_stats_strings(port, data);
 		break;
+	case ETH_SS_TEST:
+		nfp_get_self_test_strings(netdev, data);
+		break;
 	}
 }
 
@@ -786,6 +949,8 @@ static int nfp_port_get_sset_count(struct net_device *netdev, int sset)
 			count = nfp_mac_get_stats_count(netdev);
 		count += nfp_app_port_get_stats_count(port);
 		return count;
+	case ETH_SS_TEST:
+		return nfp_get_self_test_count(netdev);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1517,6 +1682,7 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_ringparam		= nfp_net_get_ringparam,
 	.set_ringparam		= nfp_net_set_ringparam,
+	.self_test		= nfp_net_self_test,
 	.get_strings		= nfp_net_get_strings,
 	.get_ethtool_stats	= nfp_net_get_stats,
 	.get_sset_count		= nfp_net_get_sset_count,
@@ -1550,6 +1716,7 @@ const struct ethtool_ops nfp_port_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_strings		= nfp_port_get_strings,
 	.get_ethtool_stats	= nfp_port_get_stats,
+	.self_test		= nfp_net_self_test,
 	.get_sset_count		= nfp_port_get_sset_count,
 	.set_dump		= nfp_app_set_dump,
 	.get_dump_flag		= nfp_app_get_dump_flag,
-- 
2.30.2

