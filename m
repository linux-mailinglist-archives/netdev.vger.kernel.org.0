Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6BF50A4B0
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377239AbiDUPwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390353AbiDUPwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:52:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85AE4706E;
        Thu, 21 Apr 2022 08:49:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LE13oP009567;
        Thu, 21 Apr 2022 15:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=dIRqQt7Lt0jkB1klSblkRHBPA1X3Z01c3YYbkfbcZdw=;
 b=lqsqmGnNOrYU1hJfuRua1mOfv2kJbAp3XuwljTxMbb45UdveJbpe2/iF1fcjEPOP9qoO
 ekhwIKwCgRQQzo/UnrhBuooHiHSI0FAsHTW7WKiEgwF+8pUE9dVPV9g3bOnvq3KuGn9O
 Xw4//QxS5on6BCwqtu9wJQ83AmcPcqtS2sikhi/R4bYy24ixicRkF6t4VNP8Etg26gyt
 ckD5FuuBCaGl4eaSTZY6KnVU0Uiuafa0NCnGUyuQP0VcDoiBr4ype5edh2mg7+AbYE7j
 mroyVaqrtWbt644OLqyzaxKiFRHZiouvZn+zucupqNeN55ARS18s04wfBh6DeeC8tQvj Ng== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffndtmf1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 15:49:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LFkjIh040746;
        Thu, 21 Apr 2022 15:49:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm88vna7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 15:49:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbffCeM9YQK0o1UoBKM+CrNTq0uB2beik++CVqXEGSpOHIxp+uHdTfFNZ0YpNGISv3T02cxWD0MVgbMJe2eeZm6C555rGrdXQbHikU3DS/TrG5MawPfwxFtpFU5UYll/0q2QP7r14XXwVq2NlEucpDEg6V43SXFY7oD5zoCVg5CGGuounz9eHGsytrM3CWKArj6hzge9S1TgTl+v6GDTGd+wOZYEOSqKfQnxpNoAySBrozIhJgYkCnYO3j0LrzYUxj5lfSZcDhcBqCQI6jqcWNTn4FMAzhxSYWF3YMnFz8u10lqhI0rDEnh76GNvPOw82HH35R8yCFcNF6n1K2HipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIRqQt7Lt0jkB1klSblkRHBPA1X3Z01c3YYbkfbcZdw=;
 b=fK4bO75LGmAk6vym71Kyjg0WGOYoBZco+PLnmt3kc9f3DyjUV5109sSvpYKrV5kmLLw4FBjxAuTLCDbIJnVqJNgm/xDAzmD7ob0WePyvIBSdU+xYrp/8V8zyng1p6G7wLtwF95OnHxH68Gl0PlhmHu+u3euT2NPhCjvq+nFRttesdepspjvL24crsA6tsQAou0PuZIHcp4GK4s0ZiyDW7nKb6gxx/veFVKscM6bJY05K0mtvGmfrZltotithYGhTkxoY3arCPt00QJcW5jgZUCJHisBWoBn1YF+qRgiED1sa5DOrnQeQGbCsBX3FlTg6MJzP+wwYIRW4ed9yDWCYvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIRqQt7Lt0jkB1klSblkRHBPA1X3Z01c3YYbkfbcZdw=;
 b=fK3hHvFIarSO+HlXTgUKlfA4Z4rbcUatmU0L2gfa2rIiJzRgceLKrJzDxN3Ss8U70Q3Yb1yU/zPPQRghix5DlUnzvjLyQc6XGIEItlx8d3Nkbs6dLxvT2ync57A1i/1paOaUpig1F/hsmDlHEdevABl/bljvsIliXjZlSJt4N5k=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1351.namprd10.prod.outlook.com
 (2603:10b6:903:2b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 15:49:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 15:49:15 +0000
Date:   Thu, 21 Apr 2022 18:49:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: add check for
 allocation failure
Message-ID: <YmF87nnzwiJC71k6@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32e58fdf-68e8-4864-66ee-08da23ae7d09
X-MS-TrafficTypeDiagnostic: CY4PR10MB1351:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1351AA0952DF131009DF519A8EF49@CY4PR10MB1351.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXFp1flKK+gKnFQ5XrxFYadGUs7mn9qqjeUEkrfbY1VsEygNB999K4sVoYQgtFninzQCv90RAyhDM9r3O2xWT6lABwsC5su0zGFPvFDrKLLcLBfxSLWYVNiZ9FUb94AE1dnkryw87L0746Ek2foHMKeB4jJ3rScDtaNEp1ix78QLkfthwSLZvrHN2P4IPr+2+qEz7J4XB1pOXoqleBDz/vekibZ9Ea3UiClCUtzTZTWFQtrhjP98BEkDJnf8O/nHXh3f3jFX6abol1ObrMyUD+Jz4Bu6f7eEbi5XZHD9BBGzhn2RTMpMo4JO+fMmrnq/CEo0xxKmyILpppmSgBIQbnU+yyH1/jDQ8s7SOU49/iKAz90ZI2XMhnR+UcNicIyBn+uLemj3lva+4f/7sNlAJE+mqPGRO9tHFVazCYyE3tISaft7QARPutdRxxsJsQn4Ny/eMlozJ46GFNsyoIftw0T++UTBjFHmc22UgS9zetGsFO+1Rm/ZCGiMmUcm28yKW/iR6rbI3xX8z7vhJfCunTlxVObUgbD8gPaCrizxcpNJBeEmW215cS0VqN1i4CN2cZbJDg4Ru5+NW6hrXNBIXe7NxqamAqxyvwjihBwAiJGwIczTKymhGUhW2ra8ep68N1X01a6MfFOMjgjfBxToakuARZ9gT4ytZ00Ci4PwNeSLFvudKIAwR2RZdD1OnnoUeclkxatg8r5fvdmt1NcP0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(6512007)(9686003)(26005)(38100700002)(52116002)(6486002)(7416002)(4744005)(38350700002)(8936002)(5660300002)(6666004)(2906002)(83380400001)(33716001)(86362001)(44832011)(508600001)(186003)(316002)(54906003)(66946007)(66476007)(6916009)(66556008)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e9Rpw7GmdJ0lRP0e/D+KBsiOX4sqt6CjKuVXYheP+2I55Q1CL45AJBvjQNtq?=
 =?us-ascii?Q?WHU5WBFmAFqrTH+z2BfZcT81i00rv0lQaD6aPvlraiKDyJyc5iXevagGChRh?=
 =?us-ascii?Q?ZLO21yuEo8JN16Q6RE32P0rUEMZrE7a4Dp48FrVIoq+LIZm5R2ByrhCi/WfG?=
 =?us-ascii?Q?3YT3Ees9Zi++NsTexc7L+vlYmmkDJeAn/8p7k+3AP70KZtyOqAGG8v00w54Z?=
 =?us-ascii?Q?9JDd1e1x63dUSminbQ5ncIF9+9Cc2xviTaDGYc3jKoaRMBg4d56DZ4amZ5fQ?=
 =?us-ascii?Q?HSYDrcbKvRZDplG4xeNH0pZMAg8P+r1m5bgt6uwQhlnbZmSGL+W9Wm6wCbLo?=
 =?us-ascii?Q?yfPFHCCd9HO5txaQ9OTRg8v+uQhKuMZ3ftKdbmoWefTJaCmoIDLek/+Z/I2p?=
 =?us-ascii?Q?t+aUId7Jm2O3NQvc/QBkqa2MWY/wH5hITF1/6Ae7ITTlYg+wIbu7yAvL88/F?=
 =?us-ascii?Q?rxy2ilhqwjGFTUf2ENUH1rftKEyN0t8wHx/b3PGFJAk3gxBP07kVYzVRsHUu?=
 =?us-ascii?Q?HNCamvyOz8KCGND5czcSE275H6p+ws+8svEJJjgPQO4VSi/Qj2RwrNBJpE40?=
 =?us-ascii?Q?F1V9AI+h4FSkpkKf61fCkDb2mCMqKg7W1UhXWgR31g7ALC48Pa9p40p1dspg?=
 =?us-ascii?Q?0mCYaCs/FKTmlDZNLDsQTQ9psM9TzhGiE0QG/9lAO1tBD4c1jxN0br2uPQ8V?=
 =?us-ascii?Q?/zeYn0ixsPRFDquUh41WOfPvIYVauqfdOPsdRrxeFsvH/FYDfKlgFmd/ncwP?=
 =?us-ascii?Q?kpl8h+8J+BPZKj04n43yj0oAMJ/pbD6VGUJCZXbaZp1q68h4YxZW7Nf5h39C?=
 =?us-ascii?Q?czuf0rxOrPqbEihoDie80epQR/TMKgn5+alxwyhkRU4mHIxPGbAaSREnOei2?=
 =?us-ascii?Q?ZDtWTYqOcWqejxUriedDRfIpUkephUtDHFSYos9NdmQpDnHk/yeeOkQ9uqol?=
 =?us-ascii?Q?CZN0hGM18UoAT1crS2X0/QKiG36t+DynGHwrHaBKFmzp3SKoOJSfguDqG7rv?=
 =?us-ascii?Q?zP2IlJRKIom5uMBkBAmBnKvxHgml5vKn/wNNWmrlOo90XC3AvN8qESjE9Bca?=
 =?us-ascii?Q?HDS0fXBnjs+fFeSdprdxuhpFlHD+WR+Jl3hL7NhiJq9cBKXyXSlTf3MWMr3C?=
 =?us-ascii?Q?lFwYDHyGDGjBMRsLl1JuOR89WRxTTWTCTx5TbPq0X93PW6yWzEDWOsoBTAeF?=
 =?us-ascii?Q?IDKydiWQYVLkGmrQZXWtdPREht+Mxk4Z9TTlAgaFUdDS1pJlJEFVAkAsQGUv?=
 =?us-ascii?Q?Hfe2MPw2PuIS0nJQZ5VB4xynvLaIifGijKcIgtJrSKXGh4rVV/9jS6QWSgr0?=
 =?us-ascii?Q?6zl8vdKLfPilXbS8/sdGIX/svskHWKTqhFCBDWbnD3KR79s1gSFxzxswc9bD?=
 =?us-ascii?Q?CQT2PljwaLAfUDw2PdC5r66Z9a71Q5sBPMytAE0bsCYsOUw7uTZCei5rVb2V?=
 =?us-ascii?Q?SnttgmI5abg7Xx5TRYwd+LDoSC8wbgI7a75M0cDJlBhHVm7pLt/xKrJi2iyI?=
 =?us-ascii?Q?MHOvklLYvLn3ein3gZWI0vrn+KbFsfxZVlsbihtt4L/LVXpQlcgFwmYgoMgW?=
 =?us-ascii?Q?SaTDfs9eYoczoVCfr4o/ThT6Fqyxu9jP9GwtmYoefooZxgfu9YLULjMxG1cH?=
 =?us-ascii?Q?yR800QYPeTXqssxBcw/e3oFKUhcuqTjitsP6Ms1z2W+ewrxerYmHTU37Amu4?=
 =?us-ascii?Q?YKu8PFwh2t5zq1lr+yDaYOdWCVvE3R9+pnizM1CQgihLAVRAHNOYnzMWcB7n?=
 =?us-ascii?Q?HCH3b08viWouSRGO0TKY7gVG2+ZN/yM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e58fdf-68e8-4864-66ee-08da23ae7d09
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 15:49:15.7583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAtJQ4Piw4L1bOCvE0hXbFfN4nTYX39/EQw2kwIZVHxgZwAAked6rP4c+SGGqdReWbEh7Gvd5KgifRYdK3GUk5tkRwG3viYOEUehdl++8+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1351
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_02:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204210085
X-Proofpoint-ORIG-GUID: HO3IZxmQuTPpfubunHitvtbyF6-vgasf
X-Proofpoint-GUID: HO3IZxmQuTPpfubunHitvtbyF6-vgasf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if the kzalloc() failed.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index f0eacf819cd9..a2793bbb8ce0 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -827,6 +827,8 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 		goto unlock;
 
 	hw = kzalloc(sizeof(*hw), GFP_KERNEL);
+	if (!hw)
+		goto unlock;
 	hw->node = np;
 	hw->regs = regs;
 	hw->eth = eth;
-- 
2.20.1

