Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B9C31A928
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhBMA6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:58:53 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:41659 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232484AbhBMA5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:57:18 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0N4ET009695;
        Fri, 12 Feb 2021 19:24:27 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92s6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:24:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOHyZsmEhUK/E4Onhw13hoFUK8UVF5eyzPesskOzJaOp57CemiKj4s5wP1JF0e5R0FW1tKGl81jMPy8/Vzxskm7i6Hv6xmCvr0CkbKcNVbeSWj4IbzQpjhfIZ5DgSXKWBLUIuGSqWQkhg+PRjudcrkKrVFw+7ol3B40Q0al80EWR7k+Kskvi0y/p9w2s7DAOzq+ZlIN5u1YyOyQGq69kr3JMrhs7zQ0rtCR42CiSl84gwTgVFargB5BJQ5rEy5p3W3HDUiR6x2e65P7PWSmUxegNPYgxamOFmzI0nYT7EvMohlbRzEO6B0xZgGrrPFMDSi45idSZbpzZmP4XSFvHxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaEFyEAA73fo/1yw/J4O5l67fpHNBkMwCWr+jzgu+cg=;
 b=ghEYPhpItf65XKlTu/yThu7OPiBYYlcJ4bvw8Qa13OqC4X++s47fLq4Fno3OSh6bGpcyK8XmwoxagJ8CTpKFI2J7/E/5atw7u4gir8/leXzDhRDjh/hcAWrpL9xTn4/btKbqqWtb9cFgUdAMnsHb2+kDmpEYGMlXzp4Yq2cIUcaXyGzh7YzMWr67XP5wguqDEBowYV8SRij2Xy/Wrhick3LB1PIVxQzv+nst/1NsE7Lt2GL1xJP9a8xdcCOJ8qhX88Tt9JQcLAcBOWYjxI7j3vyQJsBuXdAoVxD2srURglQXOJp7j8prOEdKW++DrulggPhDp2Gffuma1TBxW7KQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaEFyEAA73fo/1yw/J4O5l67fpHNBkMwCWr+jzgu+cg=;
 b=ZUhLS/lwA4COW6ET6ef4ey/tBIFL4c1+09jTC24sr5lmHng34MoMldrPZ0w91mE6Zmy1q978zEbcZpXqNT2Vvi22tWBFuUtrXIqZtJth338OJufqT+kkhtYbusz2a3InisUuRv2xw3sVvXqk11QDNsMfIrCxXFPWAo02dMrYfSA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 00:24:16 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:24:16 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/3] net: axienet: hook up nway_reset ethtool operation
Date:   Fri, 12 Feb 2021 18:23:54 -0600
Message-Id: <20210213002356.2557207-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210213002356.2557207-1-robert.hancock@calian.com>
References: <20210213002356.2557207-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM6PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:5:337::13) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM6PR07CA0080.namprd07.prod.outlook.com (2603:10b6:5:337::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sat, 13 Feb 2021 00:24:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 561bf8fa-9ed9-42fa-e9cd-08d8cfb5b2b1
X-MS-TrafficTypeDiagnostic: YT1PR01MB3564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB3564368B122DEC33A2BE3225EC8A9@YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(1076003)(6512007)(52116002)(4326008)(478600001)(66556008)(66476007)(66946007)(2906002)(8676002)(44832011)(2616005)(107886003)(6486002)(5660300002)(69590400012)(316002)(956004)(83380400001)(16526019)(8936002)(6666004)(6506007)(26005)(36756003)(86362001)(186003)(52103002)(158003001);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYhj0wGXLZ5TC6cBYqOLAQzEyacgWSpIdPv/+uQv9nC7OBUi+3jd1txcYvyCVQxdnDyP+PDw3vIKW6Ogj0omA+OCROUVXwt9fNOUOgcHWIDfpic6ww0IWRJZzTz0FidVa56rRW5281SPbTBX7FKScUn5oPLLeld4bU/wPrApP3TpZT0g4H+rOmjenjtC5zW1QNXwNifdP4EQIBhLalwmC/SSVWQtBPTiipcA6asgY0JVAXe37NpVT9s8HahbJgGptqDVBJ6M4f++a9rMdcbpVCRYotXxDXSDKCJG10bF3TaJqJrLwZnGlFuOYhLPs8SPdYKxIdS/70lrwCcRW3HchddrxOKqd+1K/jUq59Ma2kgJzGzaig7rPvaSUrhG1kynylw28C7XllWl+j6evynQkkvnGntYi+Q1h1lclpbir7mhN7mFu2OiofnfJ1jt2Wvn0QPL+uHMomTKBGrGkJTsYxSxu3CUzUFmpBS4I4sGhSvMx+FbbP98VnwRZ/ehGKQEX03NQXqX5IR3lwbmCzN8goiJbQiflSNpQsarwVmUISx//jNEbl3qUq1GdmbYprXyNN4d4Mc3iXB5JRBIxcPyQ0ipwPcoJXPCaqvudZbArEwSg1i49Ab2QA2zj5dvzgSYI/4A7gbTzReJr7UUAPz6yRY5B9hmeldIiYe2oQP/5rZYjYeZeGae782k6BzFORFU8UD1VJstpxtm0V+Z6cet/48gLzw4E4KUmnDzykzWykc7JVszQTahCOs85iTP8Os+KCqCYB6QBurumGjRduKGbWrq7gjtqH5x9tddYDVYHjOm41oOavS1kyyJ+azT6nf6vx5Jd8iR0Uzh4zXgxueW0x+RNaiyx+46q2pk61gKkHfWJtgPeq6gRxH6BCDpUWcsfW14qB39gIL+AnQjQxJmuaF/g7TIvcJUhVnWQ3QpsQXBmZJQUJ2avmwbWglvk4pf
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hlBpi/aBEHwVl2+mQCUOlOQceF3LyGy9a1oNZBJhnF6RnWWz3o8872fN/7cM?=
 =?us-ascii?Q?RzFwHG2Mq/dWpDnZaO2MP6YR+zguBYSvssJH3teJg6sMhrYeXF6o7TOwN3ap?=
 =?us-ascii?Q?23zNaI9bWpJlKeemIeggN66D1ShE7fuXMlT8et5GhfUdbACWkOKbEU/vMLLJ?=
 =?us-ascii?Q?A4Hw+QrLWPU0b8gpFpSypesyYGdmhP1xSL6G0CUDzq+cmMPRQSQ0pd6uN/Xy?=
 =?us-ascii?Q?u0jY+Uvm/tUieNch5pg5ufQrKLJak5Ty7bH+/Aizg21KilTyD3OquxwFiKID?=
 =?us-ascii?Q?PNSuVOp5wfUUgTNF57v5xxuHcub39OL5FoeJ0jfu9pkU4iHVTj2PBRjqKX8E?=
 =?us-ascii?Q?Su+8BqNWCmdOzmOW7j8aTxMKD265MXfSpc9o8Njdt99tkluUaBFUJRLPFvLo?=
 =?us-ascii?Q?mGzq37QA9N6DXy8dcQvsDRKiM7nLf3xl13Z2UkWPybAkIQofDFHS2R0aE5fD?=
 =?us-ascii?Q?fUdIy1ScmgBWhRkfRJ/NSyfRz3FYm4270VAbsMRs1q9luoIRvzevRnSUTrW9?=
 =?us-ascii?Q?gYb+8buiYujYDZUD+K08iBQVtS5AlTTvhkPP7aiXiJjAeUT9LSbCZR4wDr8j?=
 =?us-ascii?Q?Ff6IEDt7fFME8oRXJS1jnIWpEC2gJtvqwF4Cxuhfte6hR1iAZUWxhY3gEvcT?=
 =?us-ascii?Q?mOL1Zfcf8Lk+AOHKfSXIEEDJMVvi0cdMxfxxVSeY0dlVEYZ4zqdrRYRq9TsG?=
 =?us-ascii?Q?QCoyFsXga6YocTx0Qqygw/DOca2myY+7cCW7O3gVw3akYuLU/REenc9+a703?=
 =?us-ascii?Q?g4NMEtugkY7/pC2nrhkx4k/qlFlqcXNO3ZRZmSXlILW0r/LLVIXflyblvPle?=
 =?us-ascii?Q?5Me8vgzr4FkcpamZzS/Ogcv2A8ceHpkEU0vEPkP3x+oD1GA9rRbagxn9LSMW?=
 =?us-ascii?Q?hHPGNa3twi6J22K/fzvTSQx8xrI4SAFb40CBdmGtJnFOgeQIQ4hAMtvmYxO2?=
 =?us-ascii?Q?sDkRi1FwD4/QgZrGTMr/xjDhva2n6Bviw48B+gfJ5z/VJBLexD6SvgpLFhFV?=
 =?us-ascii?Q?VuiCjpRhTSJkXE+9adbfJT6kgRIBlKIz/WRWu5IWVoJKa+bWJy4M23XbJ4tC?=
 =?us-ascii?Q?1fxOBexYrbnJrom4UAnBuf926uy6XomMGZIqBno67QzfkJCgKOUY8B6SxNkf?=
 =?us-ascii?Q?unTdmOns1EZDfsXpe1xvVL/DNvdb1v28CdJKgTqyxonBfQb4I8k/BHl6LIAN?=
 =?us-ascii?Q?Ph52ImyBK6BdXMohJtRO3v9ML4T1vj/W+1h0QRYlQCqF8SZOqLkrr96fn3N3?=
 =?us-ascii?Q?2ZpRuoiJHF62ns26FiRKli9VDn3fstym6+tR10gdDtats8gNmObM7MWtVg5Q?=
 =?us-ascii?Q?Kx8d+1iCNBwl47DcDNqzBBJv?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 561bf8fa-9ed9-42fa-e9cd-08d8cfb5b2b1
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:24:16.8498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gLazkjFXF667/m+wQrdbkTBfLupWrymfyyYtsOYu2pgWOj0uZtNo3XWd82gCt6unwGIQW2Tix4rsxaScTy9Zr3nF7y8hG/NzIAax8goRz/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=948 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hook up the nway_reset ethtool operation to the corresponding phylink
function so that "ethtool -r" can be supported.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index b4a0bfce5b76..3ef31bae71fb 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1469,6 +1469,13 @@ axienet_ethtools_set_link_ksettings(struct net_device *ndev,
 	return phylink_ethtool_ksettings_set(lp->phylink, cmd);
 }
 
+static int axienet_ethtools_nway_reset(struct net_device *dev)
+{
+	struct axienet_local *lp = netdev_priv(dev);
+
+	return phylink_ethtool_nway_reset(lp->phylink);
+}
+
 static const struct ethtool_ops axienet_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo    = axienet_ethtools_get_drvinfo,
@@ -1483,6 +1490,7 @@ static const struct ethtool_ops axienet_ethtool_ops = {
 	.set_coalesce   = axienet_ethtools_set_coalesce,
 	.get_link_ksettings = axienet_ethtools_get_link_ksettings,
 	.set_link_ksettings = axienet_ethtools_set_link_ksettings,
+	.nway_reset	= axienet_ethtools_nway_reset,
 };
 
 static void axienet_validate(struct phylink_config *config,
-- 
2.27.0

