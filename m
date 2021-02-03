Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1B30E072
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhBCRCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:02:50 -0500
Received: from mail-eopbgr00096.outbound.protection.outlook.com ([40.107.0.96]:21157
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231638AbhBCQ5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:57:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmtRBqGS9PH0eg8RuA+gfETCVa8VO68AAZcN2PnO0bQjDhW7am3RUQO9mUtjF3CDD6lTahv/Xu6aw+VX0V/8jWpfrkZg84Uib0u5OE8sk19VQd/z4v2bITZmjsigjE7sBjGjWO5Bet4jxs63O/wkhgw8oWpLdecTPp4Tb/uQGxOkz1hYs41fEuY1OHeoh3fhDrtLN2DMEFGgPyUXyBZoyBQFqnzgwvUdoejlAJWuod9MyCbqh3JFAu7FbgMOK178iPuk9HGg1DlbjdouAmLtVJBI3evyFLDy9E8ouqbt3S46BQL/TGpf7JtHEQCPVnNj+0nqC3gVKA3XLS7WycQdIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qt4Fr/mDQpsiAzypSom9NNyGeswcc1Ph2rQk17+krZw=;
 b=cH2FrCmNosRZi36ikODXDCFF/CCTMB2RaM9/vbwbm6it8AGfqA51H54pHs1oXiSWopCxs3nQGutKt4qlXBY11jyERFCn2JKKwufaOQhgpN4AAokzCIGsV9yTBIRz9zhuJ7V2juB4RONl8nnlQsGcVThzVk3NYnHDDxVvlQWt8LWPE5DKzQaLklEykdT4ZN6J6o/Z39opG7EQBoHFxFyHB+eC8MBBWTmLLTJPjOR4IfyYqZM57dVLSA+8Z+lBfJ/WYaXEZxlz4S8iqS1l1P7VWmjH2LBXhP1NbayhJO0MTmQ5fWaguh1UZFG6iOIRI2CJ/CNZunOn67SzpisSJ0sT2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qt4Fr/mDQpsiAzypSom9NNyGeswcc1Ph2rQk17+krZw=;
 b=mWNNwZcrSc42nIEmLVMFU/qCeRY/gw2MngNkypsKkrQmJCmCAIJKkUU75lKxByiqsV3MO27ksoZuE/hCL8EqE+bDXhAmTd6mwlRRKMW25nealyxJh0UYvZzd36RtZMsLYYvdOZRc0dEbNmngBABfyNlclQNEevh38BHPwFOJ/Eg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Wed, 3 Feb 2021 16:55:56 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 16:55:56 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: marvell: prestera: add support for AC3X 98DX3265 device
Date:   Wed,  3 Feb 2021 18:54:54 +0200
Message-Id: <20210203165458.28717-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210203165458.28717-1-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0145.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::30) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:20b:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 16:55:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f5e14c1-d549-4a74-32e1-08d8c86492ba
X-MS-TrafficTypeDiagnostic: HE1P190MB0539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB05390BB005EC3557FF9A80E295B49@HE1P190MB0539.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: arRaOu19TmOSAkXw8HPBryU6KIJ0FRcG66shKWTf0kNj4CDYoEE0dfzVhzplosEtvtBhMsy3Ns48kWrn78pWHDEhME6dG9hOaMdLGeItbcjDBPdCLv0ENT1Cd/7aVi1zC2XF+jU580CKLgWJT1EoGf6oNSlmONDZ59zHZWRG98RMilYTUUbF9IDA2rUf+H4vpuaBaSndwq2KSCupeX81Q+65DV847gLkhlNumLutfORnDT47BqQrw3AGMLmsmxsb0K95DOrMPPmUykrAbC5y7UX0GQhq4OGDLlUjOOss1N2rlycmQqTxYgzUd/xJdrqvIwXkE/8FwF/xPh/fGkBrO2Pezb8+zbNHgpXTiwIMzj1x/5raLWY1V1bpkQfXhPIc0kU0U7kpCxBsjT+mZxfDIoS1MtKdkzDIs+1DDZNXknAOJA3OBXkvxFqTsEDtLIaXgWh3e/fduaLXLkUPgvT4WKu5Sx+IQjfaNVn6bRRYUga8HEXClXVhHOXy5rPCvI+gEtNFkup96RpKAMRKaGjMM5mjSQkERUIcNGP/l4yWQSH/P0YopiAyOk4YZNeQ3vZ3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(478600001)(6486002)(110136005)(54906003)(8676002)(66556008)(44832011)(5660300002)(956004)(4326008)(6506007)(16526019)(36756003)(86362001)(186003)(26005)(6512007)(52116002)(2906002)(316002)(2616005)(66946007)(8936002)(4744005)(1076003)(66476007)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2Usf4O6smNVKM1qeYFJcg7p89D47XjQwqgVx6kCrtP0MkEz4I3JXZfSVcvvA?=
 =?us-ascii?Q?OtpFYqv3sxunNH0oX5yU8xtqNIJk7MRB35nEmTbd8wprGAezKmc4riNtySbe?=
 =?us-ascii?Q?f317gRulIj/MLYnmNI9U7qsjylp90w8zfnAaMcc5nnjsEbe7NeCGxnUlqjqJ?=
 =?us-ascii?Q?nQrg80sRiydMRICwgVPWfL7/6Fff/7EA2Ih9MYNkAa5EDAiy/Fpi+0TY4Qy9?=
 =?us-ascii?Q?9AHd0Pl2wixIoqdFnVmc8Fzf21DHlGVEKz3qHllKyggzKESwWpy9VKyLC+Sb?=
 =?us-ascii?Q?IuGKvbqGmGOQlS+2Wfre937rJ0LA3to09xZ/7foQlfkI6w002uoAvjROK3bf?=
 =?us-ascii?Q?GjIqmu2sEJc8qh9FuHtqb07p/mJctEQOYB5d6CTuDsuzjqnRDPn3FHpODMU2?=
 =?us-ascii?Q?AOiszI97MBDf/JgMDTslewluDEL/a6LCiz3AVZfBcH2QtSpvlHLvR1WGQeyR?=
 =?us-ascii?Q?NGhS4EWaRBsrB9hmPsor5RdjwLiPT9viNrDzrWpV4K/axFRj5mCu58d9CAin?=
 =?us-ascii?Q?Yf10rUDatCGRNMYFb9CDkveqRbIv9vEZWDl9ZILoTEX1n2zOJvUe4vyfm8wW?=
 =?us-ascii?Q?QHI2wQChMHks4oIlUZ9NsJN098bifA81nLMnS2WlIo0CNL9WJ+r+YUStGtX7?=
 =?us-ascii?Q?w/WYyrWNMfAudCQI07ZJgw802l6fV6jYr9A4YszDpG8xHCHwaX+ujZqfQxb0?=
 =?us-ascii?Q?O7ezXIBowyvmDEMiqxpH8GUhwReH5Zskj3X399LTSj6iAq9YcAZAWNZW1Peq?=
 =?us-ascii?Q?DnNR/nLTgGJbI/byu5WDnKSOEVS1PBpwyEeYV2wGULONqW9rV27elME5PBXi?=
 =?us-ascii?Q?6yvJNKwasUSdVh9lNhvUWC5teL4TXRsImbGkj7Lm7F864FOHSIauS8rDA2JI?=
 =?us-ascii?Q?ySmnxTSLc412+h5Yz8gKPeR/kU/OQrjCGzBBmB/zjuC1RXmfM5g1PcwoR+Ym?=
 =?us-ascii?Q?7LfVWJpROrkWoqPO7okfSG+aLehVQWE28tahmpwJoK19kHFjWnzdyDsONKuv?=
 =?us-ascii?Q?DlgaW7LDEmxYnRoqwCEVRyphVFAiZus+tlvwGBhiSRaChLiGckgKBRA4KDn9?=
 =?us-ascii?Q?9GysIFQt1qcbMTJ+925KYyyK0u+2Agm/z1GgOEtqMx6gd4V2s75qykMrF85q?=
 =?us-ascii?Q?yo3uiiQ+p3Hmj5KQPtfq+cv/TurOaqNcUzA3kC+P8mk0OtEIegSZd7QvHuBn?=
 =?us-ascii?Q?E7QRzonBASguaJZAnZaujssw26uRYCdHjxavircLX8Nv/+dP2Ouia6b7DZ9J?=
 =?us-ascii?Q?w3gDy/qyUcgqfso+4pAeQBUB59rQMmcVs040G35mbEf+WOwtHBHctYgPP1WR?=
 =?us-ascii?Q?+mYEYVACb2kQUfukM3Gbxoxk?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5e14c1-d549-4a74-32e1-08d8c86492ba
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 16:55:55.9074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hqi2QemnSAtuWHBammvSWyHhi37s0IdIOfenGGJIoyJeS89b7yUKUyShJ1YgRuBt/YxjpbySq+v+BXRMouQiZXrokhjVrgjwqtD79kw+ILg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PCI match for AC3X 98DX3265 device which is supported by the current
driver and firmware.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index f7b27ef02624..b698a6b4a985 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -775,6 +775,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.17.1

