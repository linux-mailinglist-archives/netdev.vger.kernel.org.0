Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA7C5FEBC3
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 11:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJNJhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 05:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJNJhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 05:37:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902EA16086B;
        Fri, 14 Oct 2022 02:37:05 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29E9Kfgr020462;
        Fri, 14 Oct 2022 09:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=anRbRSEowWuSZbVw4Uzid4A6cAPA1bc7CrHtIMxOhLo=;
 b=BFiP8/BUdDyNvKwJdwLYMEOFIBeiTEAaHqbR3/XenlpwRid0O61NgeckTHuygGW+8CTc
 xy45MIMg53eSbDo40ifxe9Hx2WoQY9i8UR+oWZIMCgjF9B3A8LOZOBfMREuDsZ2MtfK2
 Q6rkpncmINl6ULhF4+fTDxJaNLYadL8r52AFyqS7GmsdzvRIgYLIDatxSZWebnFCU6Zk
 xSe7AiYiksp6cZ/pgeRzng8YA+I4I/348Up9YUYYp4f5hVsLjfyZkXkodNcRLgCskMry
 5+2GIxesRoTrHyDJiUUciMH0VPh8FFR42m5leZYpwafq1iWP9KKzY48eRQtkvu7erx1D /Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k6kgmtj68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 09:34:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29E6M4HP031278;
        Fri, 14 Oct 2022 09:34:45 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2ynddpug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 09:34:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOhB7EhSnVOtuhwH5VFCKC69S6kRC+yf9vOwXKzpiZM+6x9Jr3uJiz+GZXyNRHcZxYRHIHdYk/OL50/Z2l/ri1zOupwqdmfsXMLYAQj+k74U/mZEXyxNhAxjQnxI89RA+ZCiQny9Se7gSxioY0RnsJ8Xv/3SDGDP4pMKRIlDBUWfxCDX9IBusyYWMttW4yud1PURUYyyqEik3v/0uwKXXckGlBB6WoLxICd05j8Z5TSy2EaydI67wPm+d9z8IuhWOju/s2kmhYW7GDR95U4dngVlVtnR4fVlg0UsGFaQEH1iqrkU/bYBwjA86dojXOSXGhvNg4InpxJSR2Akmqcj1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anRbRSEowWuSZbVw4Uzid4A6cAPA1bc7CrHtIMxOhLo=;
 b=VkjT1hE4Fhc9llzZDXqatRxFIVgDWovJCLdg7MZrRA/jW6NOi/XPwKQlq3x09F3TAN8aBW7BDDzk/rfYbuUP5N/q44BnZ4E4O6UkuI1cjielt8wKe9LBxhHt0pSqVo9VpO1K1W1tVTS7jBF/Yh02dShlc+hM7bqtVay3AyyPKbaI2OXMeR8QAxNzo5Ny9JJ/0ZqBconXUHYDgMDBxWlqrnNYBaPP6V09DZL//StW3caqvp7iNMM++6eic03nKdBeZO5zxt8MlPwV22q+0Gizlc32wQzH3/Bkh0WX+CochYeh+aM8UuhFxLdN9FpFG9p1Suz8/SOBTp0tNZH8f2Na0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anRbRSEowWuSZbVw4Uzid4A6cAPA1bc7CrHtIMxOhLo=;
 b=oWi+5TBvdjNcaZSvyYvxzembeGNyefCaWlbf9seAMQth9oceEG5vnJfODuBXdSRR9vet2kzZ2MiFmz0rPotNt5hTE/HyFCx7/r503BjRepVhixH0yGFQfNj60JFGHKwmNvrSwte/OyC0tIThKEQorAeAWiB0puslOqlWKvVR6xY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4531.namprd10.prod.outlook.com
 (2603:10b6:303:6c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 09:34:43 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Fri, 14 Oct 2022
 09:34:43 +0000
Date:   Fri, 14 Oct 2022 12:34:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Wenjia Zhang <wenjia@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net/smc: Fix an error code in smc_lgr_create()
Message-ID: <Y0ktLDGg0CafxS3d@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR2P278CA0069.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:52::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CO1PR10MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a7747d9-3df1-427f-e073-08daadc7531e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNbGLxbQrbsPdT8Cdyr4gtNWVwhmWcCEUWB4iu7FYk0XRACSDF6H2CFClG2jGwpRuwFFfOm+uyJwwFi2ZDxklR72HU0Jo0Z43EHQVld2daPcS2ks2LVotbdaYWQFkbXt1ZDtE8edsT82Du0ZO1slVRkU4cgTxnpvuRDibxhCz57uIXApHzlubHFK0MpWEV6wsP8v3LHeiSp24jZgdK3fBvU3OVWilVmMfYoVLNEa5a/96+ywscH+KjmqsIjh1fkkn6vSNxtjLHTTgnifQDAKNNyL/fQzyGKhkUN+lMtt0MoyffsHNdi36w3NeCaxUHk2Ed5ASRmIMAAze9D9+AuLKq8FmKICc7r2qBHCrHyYsoejbAMN0+ql/UIqJn4+7PwFvGKW1b4KHkXe4V1VNRW8U2i20ej0lg2iZRK2+SJ2v9M+k+xU5JkTZtxbmZYItCdbwe+nqlnaKAwIV9ZKUlUNMYwrDX0rMuoG/LEftMxm+lqDD8GVacBxh+mkNVrhBleXPiK+4zDpn1Fh4/ixp2DZLOIJe6yTMPB6PCVImuLkHpC17+Izt5gY14excTEN49x+WIpfeEgIEy04uOmoARjqWWqEu9WvbbrjY1TMAM3r1H5P3+0FWEHouZKZfpoHeqSAvdqNzW+X8HKDWO8MblcAhCkHuKi3XrearuGEwXZGLxW2vLhtvoosPMoIYW2HmvteApaW4FN6oCrGd3whh8uBqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(86362001)(2906002)(4744005)(38100700002)(7416002)(5660300002)(186003)(9686003)(478600001)(66476007)(66946007)(33716001)(66556008)(316002)(26005)(6666004)(8676002)(8936002)(44832011)(6916009)(6512007)(41300700001)(4326008)(6486002)(54906003)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5xtqUSEiFpXAyLYeRy3TpJLTm3bX281IhG9C+8raidZWoTcHwL2u+rRyc8IA?=
 =?us-ascii?Q?cjAFwUD/J5zhy8XwyJYnjbt/mh4iv+tHVEtYkWdtBXpM3aNIYbjg9oIXH8Ph?=
 =?us-ascii?Q?gKrh0Z1xKddhOmVo6ViOekwGO6j4WEfi/4QHQbSyf4XCsNXKGO82g+g7wTKa?=
 =?us-ascii?Q?Q/mKy16Jkkdl8DQ6FajnTNiNuZZOXr2aRcRirH6OLo+qMz6rEfpg7EXUVku6?=
 =?us-ascii?Q?mA4pkziameIQgpC7AiBUa9rWXSAjG+hw3+urp70Be0dGiuzPdCgnBeYoioIR?=
 =?us-ascii?Q?C4AVsKlZSrhQDiUbgkdTqg0o5VUt2yPNqc/ASSAhvlZ1znb2uMnrFjhOWVjy?=
 =?us-ascii?Q?WIz6Gm/Kf6UJy4LG72vvgJuG9jquoVyzvwkCB4vXrlPWIUpwUma/A3l2zQ54?=
 =?us-ascii?Q?dQUPRAbSLs4nCZAn12trSjEDYAhLTsSFXJ78KLMndr6fcr1h7IXx+6lfY9s/?=
 =?us-ascii?Q?TkhrWwOL6ZZF79ccEYsNAz67SGFq3l0VM8bmU75H8AIJCZ3NHN7q6SXoV4uI?=
 =?us-ascii?Q?aeryYsCMgs5TmwXYvaivst6RwkvIvDZq/o/RuvXD9aM3rsCZV1TErHbil6+A?=
 =?us-ascii?Q?0y24U+awndICyGV8Kb3DR6E/uqTxlBwNS6Wv+Ql9289AXmUOa5Hr8f8+aYo+?=
 =?us-ascii?Q?ysmENriOdgXvCbf6FZovK5zjIYAJAJjdJN3/2Sf66XqUI8xXzSA1us/3MJ5J?=
 =?us-ascii?Q?7exu+BI5uDv6WF8imOQ64gq7lYJOq1GOi69TVcGuaYWd+/UVy430rwSUdf9Y?=
 =?us-ascii?Q?DSvQyceaRxpbOyV7kyssTJ27kHNKTnkJH1IKAfyJfKzkV+fK8N5hGLBETwL9?=
 =?us-ascii?Q?Torx0ioWpGHxW6ICRNyvN/z+X8kh7i31St188sjtxHARLeUDEHM2vu1PcVzZ?=
 =?us-ascii?Q?fx/eb4GPaw7t1mF4f/TZVoXjYnWaZN5tMdUX2LE9u0NuzdiEDRNzGnVF+Ix+?=
 =?us-ascii?Q?i9MWjx44UjVXL46J2RUk5o5s+kNg+XCURkYGZPJgmJ3YSZmimJIs/gz7dYLs?=
 =?us-ascii?Q?lnND67MKeZqQ0Ov2NhpR6UsWJ1BEBfieGglSrZculAOVioY3KQiaJCVcsUOX?=
 =?us-ascii?Q?jd6N8wzTzxsmaaCkc3eoc7oAFEvwL98pbISaES/UovfStpE52HXlmVAPrw2Z?=
 =?us-ascii?Q?+N0H8Pnqax6n2Mwgt6MLW9Fe0/CrWRYw4rZ13ugiN2W+NeMNMrgjzTcUCbrd?=
 =?us-ascii?Q?wTPvhTOjOUAE6WuDDCgSoXIIgIVhL1o8PCui3P9sYg+/Tqnv9DMsS7U4rThW?=
 =?us-ascii?Q?SsTdsIzjWPx5SYaBG+QO/uqN9CR6bs8Mi5ahB0tW5Ft0QH89i984GksuwFgz?=
 =?us-ascii?Q?ZRB5xMjoS/n/FHy1Xs58Zh4tylmlLnFzd9q2XZIUiRd1oqO/uYDklyUEzgCp?=
 =?us-ascii?Q?KRuce/kxLYqDnVa6SWMha7kJgq/JTubLp2Hib+4kdZwFZBGiKi5DEua3XR+2?=
 =?us-ascii?Q?P5P4KH43hMnUX9gmR8bTUIBASgycjeh8OqZJiVdG4GOTHSlYEcK/PC7eivd/?=
 =?us-ascii?Q?VNrigxa8/ZIE6nId9IbfveRsAo9VVDJ2qAoheSB6sUH/lYXLErGBAkXzRD/1?=
 =?us-ascii?Q?N4K58ptffZ4SBJMKsgeHfXd4tmEqOxcjS2oC2KKtPuWfdjqySNxU3vLuoTUZ?=
 =?us-ascii?Q?/Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7747d9-3df1-427f-e073-08daadc7531e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 09:34:43.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGiNuYnRbLC47lSdppuSM5CeyKSfZMLOrCFFqr5LBODuB3DyWppnO7I05AypjJH/YfvfV9vuXZq24B1BMpXx/xAornSvBOM5EVC5JDio2C8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_05,2022-10-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140054
X-Proofpoint-ORIG-GUID: f9wDiqoFh9kCiXHDfvheqywewrsqNIoN
X-Proofpoint-GUID: f9wDiqoFh9kCiXHDfvheqywewrsqNIoN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If smc_wr_alloc_lgr_mem() fails then return an error code.  Don't return
success.

Fixes: 8799e310fb3f ("net/smc: add v2 support to the work request layer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e6ee797640b4..c305d8dd23f8 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -896,7 +896,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		}
 		memcpy(lgr->pnet_id, ibdev->pnetid[ibport - 1],
 		       SMC_MAX_PNETID_LEN);
-		if (smc_wr_alloc_lgr_mem(lgr))
+		rc = smc_wr_alloc_lgr_mem(lgr);
+		if (rc)
 			goto free_wq;
 		smc_llc_lgr_init(lgr, smc);
 
-- 
2.35.1

