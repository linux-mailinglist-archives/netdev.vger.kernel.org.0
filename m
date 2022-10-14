Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069D35FF066
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJNOdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJNOda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:33:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C011D73EB;
        Fri, 14 Oct 2022 07:33:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29EC7BTj016706;
        Fri, 14 Oct 2022 14:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=+StR5ooLyJqma74ohXm5ZnCh55ZOCicqBUsN91IIB5Y=;
 b=kh//4EmHweeiefsBJaBjQ+xCQ50+mXoONoWRTB9LeDs6ztcWbhm0ufsXapZkUttRIHBy
 Gu93UXtIjOkJo8KTQ/wNlstwXwifvWVJQf7eSZD2Iz47QWvjvdGnXB8mxabCQFBdVd5z
 HbmJ//X4Y4QNw0r72kyhYQctnGkPMZB+pJe26iRLtvkF0IDBiVdiIhX3zpUnnsbiipEV
 YLVZUUH+Ozr4zclEiGk1Ur2yrMn4+g0QiAwv5V2V+Ufiy67WbSAZ5xAVDtkJnAnuQMoQ
 yVoOzw+dG6Wvxz7wfrxX5eAjyJBXBbwMbvry8+qyDTwG8BCSJIWX2CKpTgBJCvL6k8Gj Ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k6qw7jatu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 14:33:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29EDFK0i025040;
        Fri, 14 Oct 2022 14:33:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn7knwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 14:33:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8sf3oAbidIMqu9swLcrpouon1cKf1r4sN2PcQWCBfmpuCbFvgqs2febmWNI3kVqP7fb6RQK5J3sqofm8oNdtJoj3ySweVkQlfEVWWUe/wV6R4rQQlD6XFzp72cNKh8rKF3swBtNGt4eDWq8Y+FNFmZY9Gyjg8eBzyyHN8mRZxCDNnunW2emOjuYgyu/pUJynzQymdft7gD1g9VJtJyXSLNQENJMO0eowjhlqd/hWBir+LFH5m9tC2b52wl52SiWhqww+d5XvJeza1Ng4yYvVUTn5XKx7dUW44vU0V/BaSHP8jn5jAM8Jhd7MsXAgmAImBCLtqX4icH3au3zg8eoWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+StR5ooLyJqma74ohXm5ZnCh55ZOCicqBUsN91IIB5Y=;
 b=a1hE8i86iivKCTB0xT6Xkg0IzSzutXh8VLggUMynS1omwGfHO4YNDlWUqPSPP/M26y4PwkUzsNc5m7vq1f4FkIBIbz5wrneJV+6t/+Biy9eru6LJ1dbfginuynVbZapMlf7Yqep4aVxAfSYXsoTWslwfeO019NJpsU9zhfLm3bhA6r+nxilpRfTsYlks8G6YWWjNOordJwhf80WLnQfnp+rKRxAa5z2u5yb8bKTvo+Zepa2a7Nt1XCq140YvREpTu8/JQWe8rqJYjKEdjn7tfcgmueYS7Hwlvoy8l7S0X7nr+/zwpZzTNYxPesMv1iIuM0NOXqUCYUa64sFkUVnYtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+StR5ooLyJqma74ohXm5ZnCh55ZOCicqBUsN91IIB5Y=;
 b=oUYcxZbkH/dCoFrJ3h06b4PmxluZFLPl4DpibavSC+rFqW9U0lhIutuCXwWpCEjA+pLb5wtg7hWy2bmWcHfCxt1rQTTNrD0gSEw6Ql8wUSEmgaqSAt9DSd80RLMDSKjpeWLbwtsLruQQ2+56EgkdU56c+RScFPk/jCwJ1ctAeKU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ1PR10MB5906.namprd10.prod.outlook.com
 (2603:10b6:a03:48b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 14:33:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Fri, 14 Oct 2022
 14:33:10 +0000
Date:   Fri, 14 Oct 2022 17:33:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net v2] sunhme: Uninitialized variable in happy_meal_init()
Message-ID: <Y0lzHssyY3VkxuAz@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0187.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|SJ1PR10MB5906:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e695937-6434-43ad-d480-08daadf10471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uAcVzeaeJKX2ya3q0iiy9mQ9BvaZO9pHEy1paj9wcFCBiWRPNMJ1bivRfEKhke0nJDSM8zTwyJEwgmSFGDBvgCTt/66HQTl7jyndlBT+ee0lSsx5mIaDqLOQcjVd9J7yK0W8YxUELPZA3kF7vlc7l9ZIAWCPeciOEANStCcI5uzaSNhyUjw0i3pCmzYcvwwQsOCZ2t4ZCzBOWwgEicEKBYExzT0XuwCrQJeAv1SVwNEPt9w6ljtuBDypKuBddAGQXTTQHVLgaiubsI63OCdJa6w+p61WRtt1XiY7N1i92IktyF2gL31/Z5yugKf3NEw/Oj2Ix8oI9bZE3+faZDYNcA1SvIMJLG0OO7c/kGF4X00ljsPUTOU2wYGOUJFfVM6+iDBL5M7uza7/Oqtg9TDk+kRYc4R8BfexmZpU8Z2d8DAWfpaCaBq4aYgCJzAueuPxMr1caQtSJmTDkOkk63OTn/ElZMe+mSUnBP1Rf6Vi7dRL2SAz5RWVXovuTPz8qyKLuu5O5pS3yrXKKSCkMohsSjiNXITuonIsUUMTsW8OO6QUlSIVbFYaIpX3YPnutue4gRmvtK2rDzWtjHyJ7D98A1EBTbKsqGvLo7KgiCO3S2mH7g2Wf1GZvKEaRE78XEXX9PSXKyDAsBgvqrJh6ZTdAO1TjYF3mAZqCIV5yqfTHulxMI/yRl03tmX8XQgwBovL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(66556008)(2906002)(66946007)(8936002)(44832011)(8676002)(41300700001)(4326008)(316002)(54906003)(6916009)(66476007)(83380400001)(6486002)(33716001)(9686003)(6512007)(6666004)(4744005)(6506007)(26005)(478600001)(38100700002)(5660300002)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BjgwCg159K4F3YvTFky6BEgGtP7ZqLUhDZyXvWpDUZK1os1xMjtJiSeCEyc/?=
 =?us-ascii?Q?UwJPevwCIAe5OaoSaKrzb7HZ/UnARYEGULlN1WaldJ3c/xHHVnDr5HocXlOD?=
 =?us-ascii?Q?r9kvlAqmckzALgMdfQMpzixMRYkxpDCJNRADVPCM8d/h4BDLODd5GvaW7GlV?=
 =?us-ascii?Q?GGdlZi6nkMvKsu2XuXbfh14G05teMTsh4cI2shqeVeW/i57VmsCOvViw2lSY?=
 =?us-ascii?Q?30swt5gnrAqURifNH95SelFpKCA4Tb+FDpurtOVCLRplns/KokIz8etSHO1y?=
 =?us-ascii?Q?ynZSAAmpGZx9FvCQjY0x+EemYp/ssP09f7LlB0PkfLwzhxmzUiZr3Lthtk73?=
 =?us-ascii?Q?qM1Tl2tmJBbZNSlIV65CPFgz+3RZl7F9+Ihbq4raQf2xaoaVqxgI3FuVc9Os?=
 =?us-ascii?Q?MHkaGpcEYkI4seqdl8PfUy9OsncYziJhDB88mM57kpyr4yGYwmJ52/IXm6z9?=
 =?us-ascii?Q?G3vLux5NJAZ9mFIPUGAMmPf9bslediuJ7CZ57oBXnWW5AvaQLkulTUArP4K9?=
 =?us-ascii?Q?meKSg6NK6E0ZoDylh0vHJJx3Ol30YfsQBdoa7UA6XIwNr80kUyzh9vnP9H/x?=
 =?us-ascii?Q?xTY9WMlInMASYWVvMVzGbFeMYKW2omDAcBH71YbUc9Ni64Nu1TQW23oEkdOP?=
 =?us-ascii?Q?5FKDbkPDEWj+e5zO0tiYlqwmVnNUeOeKB4edxvUdzXRi/PUVddf4/IufS4df?=
 =?us-ascii?Q?sywf3hUmBaW9+s14gRvQfIlyefVSRLn4fQTms+pzPWcusGKDpamsm4q3muXd?=
 =?us-ascii?Q?7O5KdRNoBb5BWdb3tTDdjTmIlGjCE3lMGJDzZI5Q948gpCWc0apKOg/CyBfp?=
 =?us-ascii?Q?z9QZLv4BZT9C5+4Od7Fukoe48DIWyPOsBU9qN3deEdCLqCmFM8KjyiGF501K?=
 =?us-ascii?Q?iNijadlWq8tRhSsQjfyD00UyhIF1BzkNl4V9OD3ywC84yx5gk+V29KBiBAZL?=
 =?us-ascii?Q?gt4H6HIvJII6voGxpNy64Y2Getg+18X0sK8j/OfHQ7xBGnCX48rYf/mTwWam?=
 =?us-ascii?Q?XgUvHZ96pBUqKhOAWgnhdiWudgSR0crVuwRjwgvSGJa3HUu9DejnMn2FLbmV?=
 =?us-ascii?Q?6Gj+/YvJEBzTKPds6uul55mLbZQPiZLeev1WBCVe034sB3H2mgcFS4YdpPYC?=
 =?us-ascii?Q?YWHY1+AIdy2+TLdVAjxXua1wkynTnkBopd1MXr2sFR+pMRU9gvX5mfnRlluu?=
 =?us-ascii?Q?hNpoc7p/+4gKMAB/pYy9QhuNQbdrKyjmZotrCGmDOsJcm9Q53DH1Ccrsmrby?=
 =?us-ascii?Q?3tGz7y8VjMRzg/ZRBOtUBgpOpWYmB8z/XNB5UZkW5ixRRzYwDeQObiv98QJ/?=
 =?us-ascii?Q?KEBS4UFSDuLtnWdPP87t/jXqlK27/QJU1oE2aiJj4uB5LoGeX17S4Pdm4JXO?=
 =?us-ascii?Q?Q2mMMoUJp1Cv8VGxR7V+bGt2eNCfCiLK6L10NR1oV/auAO0bRbrmLypF1971?=
 =?us-ascii?Q?0pTpeGFHiBUW/RTZUe2V52u3CBec6Sx7dG4SUkBCvMhYZN2D3rF6OWaamrZF?=
 =?us-ascii?Q?SpVfG/v71671wwTfuvAZbVQY5S5UPZ3xhJetZBKhXUHcztGwwuLf7KIHFaX7?=
 =?us-ascii?Q?E3NXqXCgwwvSvGy92KD7sTV7hkDz/osGiy1mlR1ctatBKCfzndx1V+KypUr7?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e695937-6434-43ad-d480-08daadf10471
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 14:33:10.3544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxxpfTrlc5TIvCpTz2yEXsJHnZ8qmOLDWHgmrSsJrJwtnCTUOPA3DFGSySUxAsmVmNw7t4jMEC/YwbfTOdAegX7ij3Wj2LDuwkKqJU7TLMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_08,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140081
X-Proofpoint-ORIG-GUID: ZAmGxzcLukvxcCMJ56tfysitbEQZFHEt
X-Proofpoint-GUID: ZAmGxzcLukvxcCMJ56tfysitbEQZFHEt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "burst" string is only initialized for CONFIG_SPARC.  It should be
set to "64" because that's what is used by PCI.

Fixes: 24cddbc3ef11 ("sunhme: Combine continued messages")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Use "64" instead of ""

 drivers/net/ethernet/sun/sunhme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 62deed210a95..55f7ec836744 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -1328,7 +1328,7 @@ static int happy_meal_init(struct happy_meal *hp)
 	void __iomem *erxregs      = hp->erxregs;
 	void __iomem *bregs        = hp->bigmacregs;
 	void __iomem *tregs        = hp->tcvregs;
-	const char *bursts;
+	const char *bursts = "64";
 	u32 regtmp, rxcfg;
 
 	/* If auto-negotiation timer is running, kill it. */
-- 
2.35.1

