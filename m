Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F3844ACD8
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343581AbhKILux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:50:53 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25818 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343579AbhKILuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:50:52 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9AAiC4023912;
        Tue, 9 Nov 2021 11:48:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=SYRTb3ye06ZsV35lwOgJYm6CEU6MOlY+k81Ln/nq+TY=;
 b=AMQSlwJjcSc7QYS7UkgmAZsfXUyXqQkTsk2FpxIafvYnZjIaeg/BMOdBDjdyzu315Vb3
 Fl6F9ztARhkCY6xmgzMLTb7fj5E4Sp3SyVAve4gFnW9oVhLi913HdJWrcvAxKRi9C9AO
 dsj0SIzRkw+GoTktuQmaH+0x8VXc40weptk9UQSOtQ4f+Zzu0kGOovWlg9VLmO/30mI/
 UFWwOzFCtTEcxcqQh6JtywNb5jZx54h02cSziVGxjd7LiKhi4vCpAPsDqamAQq9HsYp0
 rHPx+nX7ZoEro8c9Pc1J2GYKJ5SFCDGGbhvwtNq/XOXOqZcTSz8U1MEWlaFQ6cS5UB5Z xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6t709r1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 11:48:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A9BkdZw141241;
        Tue, 9 Nov 2021 11:47:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3020.oracle.com with ESMTP id 3c63fst8n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 11:47:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmOJ578gmf/iEkJkYBe6zlIkdZCOS+o3H8uuqkTHkeSt35yhj5GGVZ5+e7zxEbGPndRabNuyEVM7XIJH1EKXtm2/+ErwSiWBDqjIQvm5usMwQpSc+h8AdL4S8BUfsShSeKoy+m9HpsyjelHYEpvxLGRKL8GYzAUmudxV+kjug9rBMLA5N1IfkfRVeFc3F7i/vMIFYmC/xoQRNOTk66X+p0B0Q6DOYRh5lquCKVDFY3BaqzygXZweAxOWtoJzo1I9+vmQv02iGnU5bcB2LPIE+YspeBfFq+Tth9xumbP+EnrjbpbWT8BBDBap4c76CRIDKzRZCsdceFLK5EDqz9SoOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYRTb3ye06ZsV35lwOgJYm6CEU6MOlY+k81Ln/nq+TY=;
 b=dS0xwJOTGzdPkBGL5aLARH98kkhzdjFMZDYhwbTJP2VEndKWvzbF/aNvP4iGrrDHTKLavdNkMEmbPCHwLT4YG+3M1w5se+mcd3ST03syQ5C4pyK9oQo/L8+eoBoEcul1ubGEvG5zoErdszH1kS/4smRDMrU4imjEFVF7FvjIeyP20yEFTIF2q1jucFLPdXeAnHfMdVxyVIJtCLSxcOEadhchI0fXf46wySgIP5R3yiEtP5cCfBrxMe24/sG/HUhG+MTYwK58cm5tPwHiCEmXfdcm/Ai4EO2rVhaCy3jz1J/KGaVsYjeHtUcQDS/6cHDxEJrZL5dRvyi+BqLd8CKd2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYRTb3ye06ZsV35lwOgJYm6CEU6MOlY+k81Ln/nq+TY=;
 b=cMi1iivHI1G6Xms3UOY1gAZtWlPMEcTuOz+YPCVkOsy8tgZheGjxr/H16jV7lA8ExZchcOZTHiyXLovvpIZEVhhDdub9cWmUL3wkLeT4p70CZ5yOFLHmctb3v4YZFSYDtDi8gIZRLd165kCcMCET7iqPorW63S+/VPDjnwSGTzs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1999.namprd10.prod.outlook.com
 (2603:10b6:300:10a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Tue, 9 Nov
 2021 11:47:56 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.015; Tue, 9 Nov 2021
 11:47:56 +0000
Date:   Tue, 9 Nov 2021 14:47:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeroen de Borst <jeroendb@google.com>,
        John Fraker <jfraker@google.com>
Cc:     Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Tao Liu <xliutaox@google.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] gve: Fix off by one in gve_tx_timeout()
Message-ID: <20211109114736.GA16587@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 11:47:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 370d2598-35d4-4f18-8964-08d9a376c572
X-MS-TrafficTypeDiagnostic: MWHPR10MB1999:
X-Microsoft-Antispam-PRVS: <MWHPR10MB19992D9649382CB9A7A55F138E929@MWHPR10MB1999.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PHr5C2ARfNi2zJ7/w5sUcF1tMstRqE8YNJydXh26vSvp6kuYGntJ+Xk7zFbgfP9iVIFb0d1MOqZ5z5l1q0mF4m0zEVymt0TjC4cGuyUvdAIThv1Dc0UyxYpMckQpCVGB1QPcugVQkp1vl0LGJMwxMemDJs0Z8G4oRlcnEMkHuyEbVe0a/U8hxpoFQN0ao4iWky5oS1EC8orpoVCZH/MRaWugSaGMd54Smjkrka4PQ19frE03Uzp1z3p8XiuHtFjZBrSjGsaGFDgwWkUcTrEoi7g0zmGVDjo89VzzuSX9lnsLaR8X6ruxK+HNoovGipZF1BMxBwqpq5v6TneAO64Jh62Sbhk8pYSLJtH7/RTnjRiLgEYctRZaH/e9Yr52VuK8aLuioXH2y44VIdfcpgxjOyFjx2aJgLaeiVjpdYp96/nxTIfjtg1AaYFa7NeDxKLSNDQN5bxuk/tiNU7w+W3cfhPkq0h3FrZLkATD3OQk2QVXbWpEPWX/pjnRFLQNK/es4Rk+/Pif94bjjwNWUS7k9Tu8puV5d0qhDJ36YmD3NRxr+FMGrfKdjVEDoiQ7bAD6rQJnwJ8rK0/5g3/3egSWLMyTV+bujjWC1xoYrAhA/Hmr5fUdKozZ+7wHqwfsn8c3FkjEvROdm4m2jxulVXy8XY/fE1f9+O+mLGq8NHI0Gyz7VNtFmiHHC4Rw+QGuAAMSDg8ePKJxl3M/7bxtYOJBdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(33656002)(508600001)(7416002)(55016002)(110136005)(6496006)(26005)(186003)(9576002)(33716001)(54906003)(52116002)(86362001)(4326008)(4744005)(316002)(44832011)(9686003)(66946007)(38350700002)(38100700002)(6666004)(1076003)(83380400001)(956004)(5660300002)(2906002)(66556008)(66476007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q9VS9k6AdYpULxbPwdm7sAVMs3+jUvG7ZcdgPWkm+0NZLDpMCUZOngcj8nh8?=
 =?us-ascii?Q?xcOvvN2rgWsRZmboWLqj+5Z7uvjSdPZMUdiEJrbM/e6sC8wNGT7C3oPILtuq?=
 =?us-ascii?Q?YVkyVyvvr4LhAFPWqvKe0swTvgHihwvPQLUwP+U5KE9V5mMMBDkx4TW12gNr?=
 =?us-ascii?Q?2zgh3Kdts79ODlQMXanaya0TMHCxtZ7fS8H2tmdyYogVu9r2SAqzmPg9FftL?=
 =?us-ascii?Q?4WuFOR2gwre8Hx4S3A8RNAM2EY1IiSL3ZRfjVRDSVw1+jsTWzDVoUGXtm2XN?=
 =?us-ascii?Q?+NI2rxAl7xEcjyke3M0PZ3Vhs7TwazdVZ1W+L8/kjLafXTCVNMJUGOxECX1M?=
 =?us-ascii?Q?rx/LDwpagP9zuEG8ua7BR3Nd6PxgbZ3C32VomWQIFouAGBVejxFgo6xsCXW+?=
 =?us-ascii?Q?WbZJPN13Q9gEHS40J10PKDLrhX5v0sDLQ2GIpSo1MoBZ4Okjzo3YcQNHqjXo?=
 =?us-ascii?Q?c9eGLSYbcy3FNBk7Vq5J5yRiS1RoVWLrd82PEVhZd7QPc2u8Jo+zHmPJcAtk?=
 =?us-ascii?Q?BT99LzxewEArw5PPhaw6XFhrtAFN6JIAeIodxjSLzrqspZ/z3w5K1X+41SRQ?=
 =?us-ascii?Q?LMmmHJT5EkpzAzinj01Elj9IoN30MsqU2Q2gHlP16PnNffiV6Lftn21dnRrc?=
 =?us-ascii?Q?EyAOXqQf14Ot0IpPmf392KK5MF6J8SDm/TFY1o4tF/cNMH2Psm/jjPWkyTU1?=
 =?us-ascii?Q?/KZTcX4/UzBlj9k/6RsK6z2HVYkm4oVFoqLTji/zle5YSEPl3tdS6I0x9PBK?=
 =?us-ascii?Q?U7jp7p/WeMditn+7nX9+LujNVNJmw/FodHZ4yfbSdcLJdaVFVZ6ldRrhfvAs?=
 =?us-ascii?Q?P2GeGQk8iFvwrrr4dlrlSnKn2rGasHaEzo3k9MMy4iyHXDN2cNBs9uzzEV+n?=
 =?us-ascii?Q?DbKD6Ux4Kh63O0P7OIHAjbX1tmDF2C/3r1msgAG4VUln590tN+1SEN1jimK6?=
 =?us-ascii?Q?fHDVpEBf7wcNWthdXLKNBlXg3rCHy5/JdZPtoFGna2QlRwyfE1uXTMIdDW97?=
 =?us-ascii?Q?+Sn0p18ZR3nw/DssyLQoe3SzfdtjjomGqwhB15yc0QLsLgOGya7tAV8AC5Go?=
 =?us-ascii?Q?vbOC1ox++dV5dk9oIxL4XR62hlwpJHZmK9BujlnpGQzsgcfsdMYdgnXTccmz?=
 =?us-ascii?Q?ySWiUdd/LKJxM4hQExjcHiWR4BG8xWVOc1b/k6aJ2SiE3LXW+d2V2Xlj7wX6?=
 =?us-ascii?Q?o1HJAWPXEHjYtqzkh+SdAcNKrwzDvd9srIFWN7b5IIiehEBYNOCX2DdZ/0Fz?=
 =?us-ascii?Q?YwR59fKrSgLtUeOR/lAwcDy3WExqax2NiovLE+I6DnfJw0XQ/0DbjE/dTYZG?=
 =?us-ascii?Q?NqzMU+bxlPKL4l/4yFHr9D+EV3aMsqdSTl44SrjhLtbdSL/FeQsPRxnEHJvr?=
 =?us-ascii?Q?AZtnewVsjcj0Wbn0N982HFeX9qNK/LhPR0pWDvYzCbOV1PwoQHIVxxmzO4dM?=
 =?us-ascii?Q?08P2cS/3PdxpOo4SwuZx3b4x2ML0BJuqxt3Vs8HK3e0IEjt65YboPqU6A7yn?=
 =?us-ascii?Q?N494UfABPFViUJx/bs4hm7mBlAmDegcvN5AFqam0wlhRq4letPZgwGM2+IpQ?=
 =?us-ascii?Q?3FUHW1OSo10LatV/HZK83duoh9HlIbB63606VhhRGn8N0hNatfBMts1MpxXp?=
 =?us-ascii?Q?ud+AZhkHiXF8Bj64iDEBUqzI5aL0h/2VyRhIKNvmncmblorJRdOZc8QnaYhF?=
 =?us-ascii?Q?VuQchP0OLWzcygUofXJ7U10IvRk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 370d2598-35d4-4f18-8964-08d9a376c572
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 11:47:56.4951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82vEDVP3A01RS9HZ6gHQeDwVgVKuh9FgHnw8CiK53TpLtUMSzNZ9h88GBssGHdUT0n/3zsiguJNd/H9g0hoJrqH2s32IL4Bque+KaSixhSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1999
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090071
X-Proofpoint-GUID: hCNniOXsnIclpJ0F3HXnHZ-f0iwbx73L
X-Proofpoint-ORIG-GUID: hCNniOXsnIclpJ0F3HXnHZ-f0iwbx73L
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The priv->ntfy_blocks[] has "priv->num_ntfy_blks" elements so this >
needs to be >= to prevent an off by one bug.  The priv->ntfy_blocks[]
array is allocated in gve_alloc_notify_blocks().

Fixes: 87a7f321bb6a ("gve: Recover from queue stall due to missed IRQ")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 7647cd05b1d2..2c091c99b81b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1137,7 +1137,7 @@ static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 		goto reset;
 
 	ntfy_idx = gve_tx_idx_to_ntfy(priv, txqueue);
-	if (ntfy_idx > priv->num_ntfy_blks)
+	if (ntfy_idx >= priv->num_ntfy_blks)
 		goto reset;
 
 	block = &priv->ntfy_blocks[ntfy_idx];
-- 
2.20.1

