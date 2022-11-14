Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0E1627531
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 05:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbiKNEMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 23:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbiKNEMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 23:12:39 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDC4DFC1;
        Sun, 13 Nov 2022 20:12:36 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AE4AK63028878;
        Mon, 14 Nov 2022 04:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=SCxcyWFbzB/2wQ6zlgGN6opckCswe8M57kXqh6M344g=;
 b=VvlZmBVID8q/6Mx6wlWeigNeTdg+VB/13fQ5Pjrh42Ya4w/kDitLZHTxHJWVvXKDQT4f
 wJt7Nf3jOWVW5KESW3N35g9nnO89eLOwxSZmfKHyUe2sJbqL/ZjOcjrRUpKQ07GajWjp
 zqcp9w8FesMtwjSEGY1aAXLcHsomL9oeShFiyEzrLvYudwUadSkWA1pysdTcFj1Gslz8
 XVOMjj4yuVef1AN2jMpkvIkOmxZgYid7UHaeFPyhSHAJZzysqc491BaTbzupKHKb9ql6
 n5uM4CLnnAcKLLTpuKFlckYURoZtOfX72tbNTUnDW6b7ArRuUunD7tw9ks38CPM1IJX4 mw== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kt2fa94xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 04:12:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mw2w4bcD1tA3ws1KyQrr35wkZuJR+8jy7V7T5RwSGezypzqycHhBNLPv0Kf9AuqQ/32v20T3yuSXBxMkMGIwGJTinXVMKm/xzQYoiMcLl6dVZc/AGtcikelcd9H8XIgdYfuBwk8qDzX4fhg5VvnWEff2ed9iug4e2aPMBKVIAyixrjJp6iBg7L4JxDhhiFakRQAFEps+PWzlFVuvb7gT3MmfB0Ftk2O9WOZnNWeR0rSqwCcnxoGgbqwBHlbe7Rdz6QuqAxgQ2ON5IY+31VNC3eJiTG0sT7tRjG95vbiCXyvS0LXdkUJtI3Rg83tRBGInbpyHaMjVFocc3SgIYPbQbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCxcyWFbzB/2wQ6zlgGN6opckCswe8M57kXqh6M344g=;
 b=YgImkOFw/FQlhcYA2EVpwjrvXXlTf6UKiPfqSETvcoaCAL8iEV+iKiRzRRaHS1K+jjdhaUfFwvTf1owMCvt7KvHy4FXoxBxAZUsfAXViEj4HviU6qR35ikKY2LLETsNnIsOrEYjwZzYsuDGesGho7aWpS5ifL5SB5UNWMvKJPua5By4YAenTyGlpFb1Un4NqlJVxtPkfDViM4CfuIlDm7r8ogaa3sCKtxGv4Z05BV5snyCiMAucDvOXFKB3JCdKJieRg/MV679vZOXNnDhBY1IalKOu/Hq0Fw4ciQ2rx44YD2uBPhe9o/gXHFGE70KARwIkhw9TutxgTYSIt0WPDYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by BL1PR11MB5541.namprd11.prod.outlook.com (2603:10b6:208:31f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 04:12:02 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2%5]) with mapi id 15.20.5813.016; Mon, 14 Nov 2022
 04:12:02 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: fec: Create device link between fec0 and fec1
Date:   Mon, 14 Nov 2022 12:11:43 +0800
Message-Id: <20221114041143.2189624-1-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0152.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::11) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|BL1PR11MB5541:EE_
X-MS-Office365-Filtering-Correlation-Id: 85a41121-e613-491e-dc72-08dac5f66217
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QEl01o9IPpvOkexE4VIWmFbShUqsygo1yPa3VteE6U1lv6SOuOHFE1bPYcxieS+PnjfMAAqGP3S1txxervo2gdYWgyKc+B9EoYsP91BsiU0iPu+YWWdBxh+gkqYMKFw6tQ+xinRlk91ice7ku381K6H5QrfhzM1KUjYPMpmcYDEXngClwGoh8Gyga4XrQ09KczZ4w3okHHlpvQjHpBnWJYwhgzYhTPX08qxB6lic+t7x1a4FQ2+HQTBlOIYoFFoLekO/84l20KxFbFfCqlrz+rTk3zSjWnRorloPE3fzkPjenkSX7/3t0i/X3M7EeyY363ErQ9EiI3n+1RqUwML6klnSukxaf9qe1vGhAn/SoJezRHImbTeBy10R4lobjLMGrj1xgzaFS1XHi+xubiPOAK15N/MV3ZMip08bbbsNUYqqe+PAGsKPvwd9Aww1QLbjl+exW1UVKWBr8z8GJxn7aZHf/dhEp+m7b7l52gDKUg/EYp182iI8kU44Oka1u96QZu01nKLMTTGzCO1UixK/HXTk6U5VusDvppMU+nOtSHjy363B9tC6rIa9qujABd/VbMXmBxirE/Ci3aAu/aGdnIxVJcPvS0mMUjGF2vuv+Ewi3tTQT62guA83AxDzKuC28UFLLh+uDh9ooRVNTAt1q10/h4GCCr3+Zd4lQ4JUf8+/x2r8DP2bvUct92mXYRC2ju5wibxgXR9DYyRthUY+jDYi6K/gA59LEJdpqXB7F7Ym3J2sI05N0BEbWrbC6cD/2gumr1RuWFZbg7BOUDQFJchjNvFSbUivIrfaJa5CdkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(39850400004)(346002)(376002)(451199015)(83380400001)(2616005)(1076003)(316002)(186003)(6486002)(41300700001)(36756003)(45080400002)(8676002)(4326008)(66556008)(66476007)(66946007)(86362001)(2906002)(38350700002)(5660300002)(921005)(7416002)(44832011)(8936002)(38100700002)(52116002)(478600001)(6506007)(6512007)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZznSTtVcHkd+KQLNQyOXHRzCvkLhZaAGZxGSOelSfX9cQEb/JdfJ6NGQN/ir?=
 =?us-ascii?Q?dSdYHXF+PeZZLXak0KXvoIiPrt+bXOoIXaDS6kwtfw+8BuP0Z8QW+MwZJq4u?=
 =?us-ascii?Q?GFxI2zKOs5SaOrf0hpqg4bQCEc7R6bR+kE8tYuudsDIKLVqE1U9Gwsbw2/oR?=
 =?us-ascii?Q?OC/dvJKNAeQjJSnnCXsONdvKs+wGfRFzQK0aVCbvQXD4G2MpBaR0e5NkHyMm?=
 =?us-ascii?Q?jLMHnVFlU8Jv28uq3UKxB26o8sluu3u55KStv9jq3uGSoTa4x67i3tjHOfyy?=
 =?us-ascii?Q?UEHKiQ1lraUQ/5WA3oa49OIJYPpyykNEWPeDSKpMcGgx2BlmggLSVCPwEHmL?=
 =?us-ascii?Q?MegdJG2VgXBItJvh1keb7LqULPaUwjWRqX5zoIiI2KvnxtKK60Fkmib0R69+?=
 =?us-ascii?Q?xNSE6MIlawB048KxhwCVuRQ4FjxC6kYAyLW3LyCeY6IXCCpe09x6DlKeOPhB?=
 =?us-ascii?Q?RV4JfQyQC5MqEZl+W0SNIsYTFI/XQmhvnA277focGJ3L+HYxb5Vl3PM7F11B?=
 =?us-ascii?Q?TMpeS7pckraphBLuXLkZyf/qc0+yXxIcwFfMKNLzKSvWcK+QrZgLUALSIVqj?=
 =?us-ascii?Q?XaLrnGsUmrs8CkiegIcq2u0BF60PXgYRyEXT2wYRSsjGJi2ZbVQfzhNGCdUD?=
 =?us-ascii?Q?lqRE5nga6+UtuK2YiCKRcXFgZJl5437rawBe5SDuG4OLrcZyd1xAwb7PWgG2?=
 =?us-ascii?Q?5cnhwTUACcNvu8GAw5Hj6IqynD/tVz8UO/u/c+u4haTBFEKIjR+T+x7cTLOu?=
 =?us-ascii?Q?3se3+lqBAdRt+pGo/fSEDqVLoF4/cuwCHl/q5n0uubgDy9nN2S68ykVsB6U+?=
 =?us-ascii?Q?Aij8yOq0Y4MJtg4QgodoxoGJL4k8dFG3ZUDQWFKKnBW3J12rialSpN/R0Lir?=
 =?us-ascii?Q?VUJit9fPObeO/+j2hhBC1FaZGuc4DZFz4ZWptcn7nDhZYNpixyYXEPy0HBYR?=
 =?us-ascii?Q?wLQEqnxtLTFUuEzwhBWc9/3ES62w7VG55O87ZR/YgyyvceBXAd/JMtBqVFRh?=
 =?us-ascii?Q?cM8Z0r76Rnv9TqJwVtWOGhxC4kCzyu2gm0hvBTDy/ZrY98wbosK7+hD482fx?=
 =?us-ascii?Q?Lx3uBSLuIFeK2X1tFSoEeon8nSvfkK5hnfULQKHBL9T7T3VuRswgDZh7QrrV?=
 =?us-ascii?Q?jBXPJTX5yHjdABRGnePwO5tIoXRna0KbtHg7B67DW9TsLHLoQHKEtTwg/0ZM?=
 =?us-ascii?Q?bVMcC9/KKCt3KC5rTcaS4pNV0gKw1CkcUYzOOo6qcEqnYOG8iSId4OZfjveF?=
 =?us-ascii?Q?HUfzMxLBWV2rPBHxdP7IUlxUS6dYRtn/X/7ytsR1jARf/HWoRspLnUJDTFen?=
 =?us-ascii?Q?kg5R9SqK9fTXsBpgBIYkMmSKTgdUKBfkHvrmqZcFmRTkM9TLw/oxXZrteVZu?=
 =?us-ascii?Q?RjQEQEn1xtgELQJyNvRWP8mqT2qDwBX0YYq7NY89uPwUaXicdzWLDmxMSTuP?=
 =?us-ascii?Q?tFN1+nnFt5nXWynCbQAWlfT/igs2K8+K7FSZ8Htn2YaSw35hs6kqQB3alkx/?=
 =?us-ascii?Q?BzHH5ey4TmZedYoaHDuNd2SFBRgyY8knJpQMYTpXBef0Jq1yZsgngdKwWtD3?=
 =?us-ascii?Q?4swjurIxIS9kooosySfwvhhNc5KWa4Fwbb9eiolPb1f34k09mB9s2FC1W8B2?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a41121-e613-491e-dc72-08dac5f66217
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 04:12:02.6891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AKHXKaRlkeydUvxgAcuHirhbn6Dy7IvIhWM4WHM61/d2C3j866cb1seiev6lQ0KHZ2DO9tW8ABL3fHet0IJSMGxtQYNDuhzNxyDKj5+maqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5541
X-Proofpoint-ORIG-GUID: eMRIsdbefSF7IPDcdG-0JcagMVS7aT3R
X-Proofpoint-GUID: eMRIsdbefSF7IPDcdG-0JcagMVS7aT3R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_03,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=587 mlxscore=0 bulkscore=0
 spamscore=0 clxscore=1011 suspectscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211140029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On imx6sx, there are two fec interfaces, but the external
phys can only be configured by fec0 mii_bus. That means
the fec1 can't work independently, it only work when the
fec0 is active. It is alright in the normal boot since the
fec0 will be probed first. But then the fec0 maybe moved
behind of fec1 in the dpm_list due to various device link.
So in system suspend and resume, we would get the following
warning when configuring the external phy of fec1 via the
fec0 mii_bus due to the inactive of fec0. In order to fix
this issue, we create a device link between fec0 and fec1.
This will make sure that fec0 is always active when fec1
is in active mode.

  WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
  Modules linked in:
  CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
  Hardware name: Freescale i.MX6 SoloX (Device Tree)
  Workqueue: events_power_efficient phy_state_machine
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x68/0x90
  dump_stack_lvl from __warn+0xb4/0x24c
  __warn from warn_slowpath_fmt+0x5c/0xd8
  warn_slowpath_fmt from phy_error+0x20/0x68
  phy_error from phy_state_machine+0x22c/0x23c
  phy_state_machine from process_one_work+0x288/0x744
  process_one_work from worker_thread+0x3c/0x500
  worker_thread from kthread+0xf0/0x114
  kthread from ret_from_fork+0x14/0x28
  Exception stack(0xf0951fb0 to 0xf0951ff8)

Fixes: 2f664823a470 ("net: phy: at803x: add device tree binding")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f623c12eaf95..aecbda9aca65 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3963,7 +3963,19 @@ fec_probe(struct platform_device *pdev)
 		goto failed_stop_mode;
 
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
-	if (!phy_node && of_phy_is_fixed_link(np)) {
+	if (phy_node) {
+		struct phy_device *phy_dev = of_phy_find_device(phy_node);
+		struct device *fec_dev = phy_dev ? phy_dev->mdio.bus->parent : NULL;
+		/* The external phy used by current fec interface is managed
+		 * by another fec interface, so we should create a device link
+		 * between them.
+		 */
+		if (fec_dev && &pdev->dev != fec_dev)
+			device_link_add(&pdev->dev, fec_dev,
+					DL_FLAG_PM_RUNTIME);
+		if (phy_dev)
+			put_device(&phy_dev->mdio.dev);
+	} else if (of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
 		if (ret < 0) {
 			dev_err(&pdev->dev,
-- 
2.25.1

