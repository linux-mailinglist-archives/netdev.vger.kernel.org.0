Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD8451EF3F
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbiEHTGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238805AbiEHRm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 13:42:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF35E024
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 10:38:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IffG3jYlh70R67EjjQGX5CJbgTh2UhbgRJWzl9xwwlwqw0lS3dKASL4/tDAX8QzuiXseQRPJ6+OOsixn+gPFoBVJOzNZesQ5enjyk9AvgULIOWZn/yK88dfdnnniLWaQWwuVp3Hngj+w/hWlMdhLK5XpF4raFlJG3cKAfXIkN4HjX7IfCvcrlI5fbmlCav98nS7J+NttLCkgzrq5NBCtsPAE8+NW638PH88F7PEbTjKsGrMx8nBim9WRPab3UUUov1dgF4nFb9i+G0nlIXmBqZBrC75NvwECMmLe1N9exx/loIGFs42tYeXIKotJG9Y3gX2XjxFoldcQP+e2Q8PxKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEUWLlqnoVRhkLdQkSHH6MHQ736ods2iQiAQsnbdLy0=;
 b=QMDGiSxqkvkG2H7q71YhfpyPhKygtKV3yxti6Tdl7hkGSlQWbAdwRxlnEKpK7/MtI3Ssvu9lEkkHmZ+DRgJlfQht0GBOxvfZjadHh02qxYqf7Bubhzw5+1ha427Xys7sQ59zdzm3YP4NR4i3tmtuiHEp6MXPJJJrkjsR153p5b2sDtTM0n7KGKOlS5BzaoGOkoCVTmRMt9pUGugyv0TZm5/2WgFk17VMWCF0popgaJxzUmqUnzqEyKW5No9gegsDBNcc9nlGiotDp2e3hDk2SJBu/0a5knYD8oXoK/VMbJfvMJKEdooLdHhJ70s7kiAGvD/1BEtzP+9yvgdgFXi5eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEUWLlqnoVRhkLdQkSHH6MHQ736ods2iQiAQsnbdLy0=;
 b=DGHaINNoqI6GoE4H5V938fJ9E+I6MWWSQc5uUFhu06WHYNX7/pjwqbazDSi984UaacwKhaF4Jn8eDX9uZwNADLpKW8Xyr9no9cPWQ4eaxybM54MqMfsGu4b4RyftVJ2vPCxt/a4/Nf5/jJ/cAVAuaII/xRjbQJNIg/5p533f/wk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1200.namprd13.prod.outlook.com (2603:10b6:300:12::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Sun, 8 May
 2022 17:38:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5250.012; Sun, 8 May 2022
 17:38:34 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>
Subject: [PATCH net-next 1/2] nfp: vendor neutral strings for chip and Corigne in strings for driver
Date:   Sun,  8 May 2022 19:38:15 +0200
Message-Id: <20220508173816.476357-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220508173816.476357-1-simon.horman@corigine.com>
References: <20220508173816.476357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a700305-d00d-4eb9-a236-08da311992ed
X-MS-TrafficTypeDiagnostic: MWHPR13MB1200:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB120081BCC9B28017990A32FBE8C79@MWHPR13MB1200.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcvVoWAU+C9iE53yuqqNOkQh2+erigrJ7XZzz1eN56zGfCWVncOIiUZTbXP39NkZYccFRIF1GuOa+V6qVe0JWQaUlxyGR2Klmx6eYH+2EBbO7GnZSQ00qbtQivRqLxEtLdpkFWJJDMlkKV3bFqvSEZcTbkUhxUnch+gdr9PqV4Aml7rJhLPP0vMCoUGar6HJmdnyB90B2DB8BsXn/Hp4KQ/iktn4W8KfP00V8nAeRg7TXs39/31zpBQmHTubelGPgIfu/pSTmGM9vBvXOaJ9SRe6dCbr+bGzbh+8ajMYZI/213j4W9d1WeAMhupnd8+XUrXWxvysIJVuiS+2ce9IjlxisUrzA6AT1WIvs8hKPl1rrAc+kPlO9f82GE2ZmU2oYsxOpYLqNay70EByyzepg6cBK8WlNOqeQz04466sui+lfUJ89YzTPChRdzpe4uOnTuQm+P5nHx2V8+//7Mkdl4tYnuQS343M0XRUIyzYahV0kkZZvC5ta3rX9Q8HujtNZeSfAQ5bazbWTkmc4ECcP8JoQgKbeS8jYDxmQYCLu8BHq0jozlYFz/uJ65YvTLamlbxjTj9jtpxrfANxlWpPl0qh3gObOV20yG00Q88fg2paQ2msEAKv353uVuU+8tcYJkVTg1OMaiZKszWkVqQX3nowMl0NMbAbAY/53b/qvZQZGkWbRxw5Sx9IcboRWpRs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(346002)(376002)(396003)(39830400003)(2906002)(36756003)(8936002)(5660300002)(44832011)(8676002)(66476007)(66946007)(66556008)(4326008)(107886003)(86362001)(110136005)(83380400001)(1076003)(38100700002)(6486002)(186003)(2616005)(6506007)(52116002)(6666004)(316002)(6512007)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wtgs3Y5FYkpzKejitgjJTpjk/PcMiZ11+nXuLkSLB2sy6QuFFFZWUqQyvP61?=
 =?us-ascii?Q?IN0qMh3XTS5iWv87tsy7NO2McJ2/k/VTF1XBzKUxnUn9F45lG8RwYlvrfWUR?=
 =?us-ascii?Q?WgWl2PhZUg7RuSGd/CIfRJUNDYrYPCi5HymJ7tiIJa4S7HnAM+5lyvVQM+ms?=
 =?us-ascii?Q?+SNIsXwIpaPAySUpsFz+u/Hsk7JCQMVTeLWGxzs4Iedehzj3597ddSaoPjPI?=
 =?us-ascii?Q?ANanFuF+aCYQy6z5bxS4cTm0MvpiDoy02LSh9DbWm2zsAqqjgTMJBQNaOBWg?=
 =?us-ascii?Q?nY8DtnbqDaPajGinGUe1cYLIqe8KkRmioUIlWXU9sHmRIjFFeODlAnMRfcSk?=
 =?us-ascii?Q?aOI0WoXpxrMS4ZEx06PfY0S6B9kQCdzgggJlhdYmS1xycPrz812nvs1n4fvo?=
 =?us-ascii?Q?oEqR7aPeaoWz3mF92rXCRvS7UMBTh12rSP7x1Q0MnzDCtINnSVtm2TwMKs0H?=
 =?us-ascii?Q?OMrY9wM5BGnWafz/dKtuljmjuaKm+aTpOpF7JrZ1arXxMtIp9P2Tumog5vUy?=
 =?us-ascii?Q?DpJUki8kEK7t3oBpyX9yS6mRMCkuvpZQV1JgKitE/0vWTDNUObtvmasHHsf8?=
 =?us-ascii?Q?8At0iBQG73nTqEYZyYZDFnVhY0j/dDz8uOpJl1emtpCFlham4RMac6y80OA3?=
 =?us-ascii?Q?aQPOJVNnDGDEnXmDFlPLr26wQuGERH/ohtL1DMEWBoHnSPHo/B8FNE/xDM2t?=
 =?us-ascii?Q?DR11AZsUxmhNNb2y//sVh+nikV9I/h6vP2S0midWBsKUUL0C9mXpjspPGz4L?=
 =?us-ascii?Q?Dbt71+JMeGyV60nURqlXAC6jvGPD/INO/TqHXgxrH9NG9tdUAqs7mjKmfV3l?=
 =?us-ascii?Q?YSauRJ5co/JoAF/esiSJ9vYsYQbOp1XD9ILVZVhooOPKyjp40JCUhmph97w2?=
 =?us-ascii?Q?hFJ2l6H1TVwDVbLvwFfE3sGAA8X2VFGmG+idPvIlXmEQHykwOKXWXFKQB7d4?=
 =?us-ascii?Q?qHir8Q0KnzfLHJFuxR2DVheE4sQ8s7JcOhtls89utQEytjgAp2LlJF78guvA?=
 =?us-ascii?Q?LLXMQwUM4dY7cXfTB7I9cRK+6bUZVUL0jxqg1B58PeMOljbBFFZxUggvzr3o?=
 =?us-ascii?Q?rH7vardZ0WwmEkGp68hlAEaAhfzLxQnQpjsOHorG5mECn1ZnGgS+5onCc39U?=
 =?us-ascii?Q?C5MwSzstzUMcpMxiHgojLBa4/yiNVIb+3Ra7yIiqfdb8xkfvyf3UDia9N/MJ?=
 =?us-ascii?Q?8w5xG3UUCbcDmCO0kg5BGsvqnYvHeSX0Mh19WI/EOrFcaPacQOt7m0tzwN8h?=
 =?us-ascii?Q?HW78EUgIos6CRlURJhjauHqBlA4bIJyza+gPhvftab/CbTxYPa1tjMnvyYTg?=
 =?us-ascii?Q?dZl9mQrdWvrv5yYgpk+Yv1SD5GDbPDlAWz8OXuHNMJleqs5PBCcN9rEm/WPH?=
 =?us-ascii?Q?Hzwb3K4Zit4QMZW1Bu1FCZW+g30xECyjhqvXoiLEtogkKcSDf13E6BD6qqeX?=
 =?us-ascii?Q?Wx7K528K3geGVtgbGr0yf3vB+erhekL25cBkRZBpqEnjgmmyUgQAxlGaAML3?=
 =?us-ascii?Q?dyqztJf2WCNwzGZmJ2iXLreGK5zh1dC0MeaSPR+T3c2oMhvJD9uo2DHP9hsC?=
 =?us-ascii?Q?XKCswKmaA4rnuocJbqzqETIDZDDDyJBX/T4Sc/T8MwfHHs1T/lhpC89GJwD3?=
 =?us-ascii?Q?/CAQkmTPu/bhjizuw0fWhaoLwFn9EN2yx5AtsdSYkAgZhtGoUtFtTucwr8uW?=
 =?us-ascii?Q?ScJkYOWjt5QlqSgbvRn/JUH3phuf2HxLB4FbbfTo8b4ZH+hlS26eS+GkT+db?=
 =?us-ascii?Q?s9BKDmDfpYOJnBNkP4sWNtehSqorxf78eKVsE3WeramUMsCdPok77SeZrRfp?=
X-MS-Exchange-AntiSpam-MessageData-1: iGuTH8rlxd0a7RSUPydNjFvMIbS8Kmko3X4=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a700305-d00d-4eb9-a236-08da311992ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 17:38:33.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dcWJDyzbOnYxEBKv2FEB+9/P8HQ+hHKxP51n2togi0AhVcR7laT/vyz/YUJavyUxlZq2tT840/4ipyOc+fjT0+6aZKOnW2a/AUxVLTqQJxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1200
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Historically the nfp driver has supported NFP chips with Netronome's
PCIE vendor ID. In preparation for extending the to also support NFP
chips that have Corigine's PCIE vendor ID (0x1da8) make printk statements
relating to the chip vendor neutral.

An alternate approach is to set the string based on the PCI vendor ID.
In our judgement this proved to cumbersome so we have taken this simpler
approach.

Update strings relating to the driver to use Corigine, who have taken
over maintenance of the driver.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c             | 8 +++++---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c       | 2 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index eeda39e34f84..08757cd6c7c5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -865,7 +865,9 @@ static int __init nfp_main_init(void)
 {
 	int err;
 
-	pr_info("%s: NFP PCIe Driver, Copyright (C) 2014-2017 Netronome Systems\n",
+	pr_info("%s: NFP PCIe Driver, Copyright (C) 2014-2020 Netronome Systems\n",
+		nfp_driver_name);
+	pr_info("%s: NFP PCIe Driver, Copyright (C) 2021-2022 Corigine Inc.\n",
 		nfp_driver_name);
 
 	nfp_net_debugfs_create();
@@ -909,6 +911,6 @@ MODULE_FIRMWARE("netronome/nic_AMDA0099-0001_2x10.nffw");
 MODULE_FIRMWARE("netronome/nic_AMDA0099-0001_2x25.nffw");
 MODULE_FIRMWARE("netronome/nic_AMDA0099-0001_1x10_1x25.nffw");
 
-MODULE_AUTHOR("Netronome Systems <oss-drivers@netronome.com>");
+MODULE_AUTHOR("Corigine, Inc. <oss-drivers@corigine.com>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("The Netronome Flow Processor (NFP) driver.");
+MODULE_DESCRIPTION("The Network Flow Processor (NFP) driver.");
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index c60ead337d06..e3594a5c2a85 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1984,7 +1984,7 @@ static const struct udp_tunnel_nic_info nfp_udp_tunnels = {
  */
 void nfp_net_info(struct nfp_net *nn)
 {
-	nn_info(nn, "Netronome NFP-6xxx %sNetdev: TxQs=%d/%d RxQs=%d/%d\n",
+	nn_info(nn, "NFP-6xxx %sNetdev: TxQs=%d/%d RxQs=%d/%d\n",
 		nn->dp.is_vf ? "VF " : "",
 		nn->dp.num_tx_rings, nn->max_tx_rings,
 		nn->dp.num_rx_rings, nn->max_rx_rings);
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index 0d1d39edbbae..bd47a5717d37 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -1314,7 +1314,7 @@ nfp_cpp_from_nfp6000_pcie(struct pci_dev *pdev, const struct nfp_dev_info *dev_i
 	int err;
 
 	/*  Finished with card initialization. */
-	dev_info(&pdev->dev, "Netronome Flow Processor %s PCIe Card Probe\n",
+	dev_info(&pdev->dev, "Network Flow Processor %s PCIe Card Probe\n",
 		 dev_info->chip_names);
 	pcie_print_link_status(pdev);
 
-- 
2.30.2

