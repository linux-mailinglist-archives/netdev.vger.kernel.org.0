Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6734B112E
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243345AbiBJPFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:05:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiBJPFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:05:00 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2127.outbound.protection.outlook.com [40.107.223.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9392398;
        Thu, 10 Feb 2022 07:05:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jT56UznRYmFT4ToNc19tvLLTEIpYzkItIwcIBalGHW6NjMLzn7in+8cbel53JqRzoWOcJJ5NG5f5H968Cpg4QCr5tpd2qGKJ0d3Jy6p8mbFhK0Lx5mqD+j4V8+Rtz7NaWPz7n8t3ENZSyKl6X5RoBnkTHaVgV2N3zErlEm/dAfrpcA59AY0E7D3rB01HZ0Tz3hEzewA/Cb1bdfyEs6pfHUESB0JfHPJXmT/DzMnQY6+42oQVXk8gCZG/o22U/uy60p2CcnjPmBZvQIFb/SA93DU1MwJBM1wLjwIEDNhP7CF5Fpavti/FWg3x1w88BiYHys0yCiMdLH4V1e0qs+Q9/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxNMYoJjOhCf75nk5DUY3i6gpzuaQVWIOc3wo3Cw++g=;
 b=TPplxT9WATnoZU//FL/J0tQc7/BewLqFQHpvu2ecdEZCg2sIqA7RTt2JEGGgvT9yIJK6Kykipelz5Ue8UcANUboJqox5BCSyMl4fLbGXh5rCPfnC66x5wZAYFAs/nJ7c0knktuoKYKgqL4h/bJJEdhf9E2CYNDf5QlDAzOJlTKqCywGBIQR+Hf1DXU0s8KNtXn7K3XyCsoDVPrx3L3D79fBAA/qxIG+k3zbSJcWHlAPod+qYqbq9bzqGPfnpEh0bnELnrT1dogu6f+W4uhEE7sg5/+ZXl3vIMVTIsslWBZlI4ikyMD9d3i81L2TmFoXmbWA2aEq/h2XxpmZfznYLKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxNMYoJjOhCf75nk5DUY3i6gpzuaQVWIOc3wo3Cw++g=;
 b=zyCiF75boG8CKjM/as2sDIF00TATOFlCEj9FgG+PoXtfDYKFlkr4YpXT8stXvZUgi0mlXaEORpGpGXo7vjly2IWPVQIgxXSUv2qWppE2h/cykkGQW6iX0RUJ8poxcCMnpOpd9jUwwkTYmRa4IfzP8xw1G9vM8+7l7I/RfO/UOpM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3420.namprd10.prod.outlook.com
 (2603:10b6:5:1b1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 15:05:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Thu, 10 Feb 2022
 15:05:00 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net 0/1] ocelot stats mutex fix
Date:   Thu, 10 Feb 2022 07:04:50 -0800
Message-Id: <20220210150451.416845-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:300:16::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 585210af-091c-4803-ee24-08d9eca6b54c
X-MS-TrafficTypeDiagnostic: DM6PR10MB3420:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3420F0FBF8504C104F76E1C3A42F9@DM6PR10MB3420.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3yHkwo2fU7+x1w3Sq1vZKpSyN6nMtSerZBbvgsjiLb6D1JaKbchHqYwZ/OryJ8rPVBdwdzMVre8N0HAwMmwZvLuB3usnTvsE8OrH/kMa/EGdFvVnthnBaESIaUd/xlyo/3ir4RWao+PKnirAmxfhL5sThpwmkzwaS9+ndeiL/en5UFt3hNbGN/6PUuPsjEvYRibxSUV4ny8l/PwSA8Mzv0jOMPMTFnzw/j5NcAuHc2SjHfrBEzSC0bOylLDL+jv4rVKiTrE2sq6hE9EfrLaFORgcPPMwpc1e3LjT5JTAIMhLUdoFhRVuymLa352Ry9rFb/aJSyqUEnhqDRH3tyxFDmhu6ZoBrSiKJbMDwIKigsTbOWc/+cfe1Zg+YzTTxJc609w+oC4RN9zMGZWCRCzDN8wluwmmXq88LG7mA7FIZulo0l6vLe+rVZhnURnDeePeblT4w/J3+vlBu3Fz4iYsnjIAbi4b/LYEVgHIIkTdExGoJER+0AKvM/aHdaMZ9kKxeJNTHRjegSpcSbhKSAar4kRKuBOS29MyFqg+DoXqz9PaOrq8SdSZ0s2nZWZLmCCWrhMw2WyNmiyO96vpfRcGsfjFKRJ8+dr9q0H0dZVMuSoGBjgKI9gfprOduhZPENQ2wkjFdMTJEGRWB3eJdpWEu1EICmDZy1w4DAZ8T8reMjthuXG8d1bgdOm2vo9IQT2VKtJFdGmIC4+6Fmu2Y7V4JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(366004)(396003)(346002)(39830400003)(136003)(42606007)(4744005)(8676002)(66946007)(316002)(508600001)(5660300002)(52116002)(6506007)(6666004)(66556008)(2616005)(4326008)(66476007)(6512007)(8936002)(54906003)(86362001)(1076003)(83380400001)(44832011)(6486002)(38100700002)(26005)(186003)(36756003)(38350700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q5UysjolMKV6zX/W1u6UrMlDFC91TBFrVVveLq4vELz0HjRWxQk1p/AEIcso?=
 =?us-ascii?Q?AKLlwQraN7sBqAWaHNkbVN8RfVi0IbDuEmu0dBTGUVTcnhagEheUKWWFihnq?=
 =?us-ascii?Q?+eRwseKgGwguAaB8b+0djDJc8PQ+ISf8RKKDZNYhCRCzK9kLusPNY8fXwDh/?=
 =?us-ascii?Q?2iAYsGxXu4YYF+2fyfVlVwNLUvci862SImnjFiXeO6hhkxvf38LrwD7g0FyR?=
 =?us-ascii?Q?i9rvTtLqYJbkS/2bjw7XueHb+mBhVhuIXuMz9UoikN+Ob5AB/iECiZW18Ocu?=
 =?us-ascii?Q?ifM95PuPIOAUsYhwsfmzYH+vaeCfvuGPbELLg3uO3cckCjqKlb4DcIbBBYXb?=
 =?us-ascii?Q?RTOdJUWd4XMbbhISCnngEd2iYpglLc95aI/F8yGjKvDh/KkLNueYuOH7BrCJ?=
 =?us-ascii?Q?2GUY7ffCUsf+d8UA98OcCSX4ab6y9K5eQSF6fokV0EONBDsxghlEHv1QUPst?=
 =?us-ascii?Q?8GWBLQt+/LcvOvf3VDrs3Ze0ow7mjVMvKLi21PV0Xpuyo2V6tf0ylvkg//Cq?=
 =?us-ascii?Q?fsTABqK6HAEm7WNZc1tVI5E838tIE9oCjGUffSBjvsPeOKatdt0uUGuT5M+Y?=
 =?us-ascii?Q?NU6Fj5F7Pp6yaJIcTdO0tMVdnDVdX+zVDYbMEVg3FHSJiumiyDrFfzi2UThb?=
 =?us-ascii?Q?ukgVNcUmDC4nX4YKgIqaAOUQ6DfLB7WI7FgQ3Kt3uXMkNHFJWRv7piZAtSMJ?=
 =?us-ascii?Q?ivXDEPovvtU1DCJkFqZ6i+j8FlLf4z3i+4wLxkvlnroCX6buO0Gtai0D6wGl?=
 =?us-ascii?Q?uQUKX1Dn3HS/WA7/OEQsiOcagTzErkUSgNWmB72Joe7QYr3VD3KtG1w8fXO/?=
 =?us-ascii?Q?GWC4wxnMVQwasOQSmFT5nwJD0KTvR8WWBdUrUvTPaxAVwv/vc/Fdkt+LQ6HB?=
 =?us-ascii?Q?Kk7qoYhbmegMwsU3hG0qwhfLRduwWb9mwoPLyXGjlGVkri9rAggQnm2sneSB?=
 =?us-ascii?Q?Q2VsL2Qzs82IGY0G5rZoh8p9l69cy57mmmZkEtoYTfzQK9VdCyvQdzB1odYI?=
 =?us-ascii?Q?3rDMSIWxajWjEom3KgqUqb4quT4x/UuY3pHjOhF5OpFCcyKDGSjwmgCWM0Il?=
 =?us-ascii?Q?ZeF4SDFjzNIPjpgYtVbyjkMdRnYUts1xfkjt1XWUn9R4FHexq7cU2vccyqnn?=
 =?us-ascii?Q?U7h281J1Mf5ruAd5lgshnBBmLSeI9CDwzF8IFvj4XUfmwd3yKY9qgQKzBq/+?=
 =?us-ascii?Q?GgmVCRlMstPBmjWyVxsaKLSxPTz6sp33hiasFLzDxBFqAH+IA8cVgkwt2JBc?=
 =?us-ascii?Q?zaMQyKUFVrs6wkqY4Ug284vuhR16H3KxtCfVaU58gY+gqGan1qDMDcBOEJM4?=
 =?us-ascii?Q?oTIermE32tn4y5Zoce9SOmxGqCWOcyJUZUncMJ3c4zKyeWO+XYevHUUME5XM?=
 =?us-ascii?Q?lcExEIdjNWxY8lCaBvtyMRgWCh7fLG6hYFrx7ItSu9I3ZV22imYwgHhggu9C?=
 =?us-ascii?Q?pRDkKMKKRuV6BXUMb1reUvGZr5jNrMsHR/ccSsVTVIYp646omwTKIrwy2Glu?=
 =?us-ascii?Q?DZuipglsrDlfx/uG8a5owZZmyNheVWvRqYCrN91Xy8jgby9mgKMShc5xgUdg?=
 =?us-ascii?Q?TgegeR6Wa91aHhluHou+zn2GzWCiojxf6HleQoNkup54ZNV8v4wdDDLojsb5?=
 =?us-ascii?Q?peOi7YB2CrDPfdgW7fX2+pJ03jBPPGqXp9OCcMmcbifqbkLopsRFshAVXg08?=
 =?us-ascii?Q?eAtL8eB6w3G9ydM1jZ3avD5sH/8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585210af-091c-4803-ee24-08d9eca6b54c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:05:00.1954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kzuz6BTLCvYFFoIvu+PLr9ZZMcfAbh6yiIMYs7/g2tGkOYgYAoq27hf39ewde+7D8fTt1pN80j8F2hU1XZ2LtphYARE1GNHOAK+E0cbOzck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3420
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originally submitted to net-next as part of
20220210041345.321216-6-colin.foster@in-advantage.com, this patch
resolves a bug where a mutex was not guarding a buffer read that could
be concurrently written into.

Break this out as a separate patch to be applied to net.


Colin Foster (1):
  net: mscc: ocelot: fix mutex lock error during ethtool stats read

 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.25.1

