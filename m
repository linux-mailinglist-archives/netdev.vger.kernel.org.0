Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD8D3E362E
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 17:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhHGPmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 11:42:22 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:62204 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229828AbhHGPmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 11:42:21 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 177Fftj5029387;
        Sat, 7 Aug 2021 15:41:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=r5uE3zBNin+LWBMggH0Li9HSOY/V/l5W1sQqcInhxf0=;
 b=QzGv2QJAWHp4HXa5RzjsMYM4rLsMdr0gZwEqPCMxn0R1TMLyWe/rxwfAyS4khY0MFdFw
 vM8/6uGRSY82Y1ELqo3hDPaYuoHccqeFZDxewdhdKsWDJg/uqYQ6PxK451pai51GILxY
 41lHGZ4RG1LMOCSBw3fGjsd1bw0qHdWNo17hr2CpQ+aRP/gQz5vZGV+QLow4N2ssJirD
 aMz1wNkWUdOkXJz57aB8l1/Osn3aBc17yrtSs+5koRpyDMb3MxXdspoJqVdyzzlZgBti
 jjUcY7/FgIMRYpCVBIA8XWZyUDQI8lswx44s8x7Shb/SbjF25yg+XuoAqGEA5g418MJD EQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a9fd2rbkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Aug 2021 15:41:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAUFTVCBzX/tZd0r035dVSHSvXRmYMuwruHPW8+hDdP3lll1UMT5h5Q/HQAsvuqFb3CSmfeQY4WI1DBKskIQTyhWLXQFysZqxPL64rJv7YElqFARa4wQfrWFuqd7u4DC6SIkCyW254bkffUilWw/PyAtcKy8rfdMGl7J0NOg89lqGdwgsTV0HP0NE8NBLAAxGhwI91+u7mIvbYGfJ2cn5e6y5yOwnDE3YqVwoFfaFlM9HhtCcKDgg3u2wmzfMU0OsGRC1upLtIKHVAzhVLUeR6i9kQIrv0n01wyUpmOgWuLUCAA+ULDLCOGtJJmkY/CW6mFwoQbusx8Ufpb0crVpRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5uE3zBNin+LWBMggH0Li9HSOY/V/l5W1sQqcInhxf0=;
 b=aHGf678DFfl7/6lKz2EiOndJz5FfT+mM2HO7ZlCK4zrQl9UxF7dvOLRK5tYmYuc06ZmPaYBNzwZ9bvXOvlTdz9wvf2BcKQAgflj6MsFA3VCRTfc1I47Jx1/+ZSnKBa/p343Ecwv0iYPoWu57RV2nchFETuGc+yLKQkgJf17KBC8j3FUzvO7Nnh7/ZjsSedxCtG+SL5wbkXr33aecf6FX1BxdVnY4YObWGr4BPAuOTlNV5p7zZ8sSZJeafFxc1GlRhlQxf6jk7+/kIY8SP95B4Y41E9jH8NFr3IjVQ7ChLeZrndePtBG476JwY+4EUfl7N8mvQmRIr5/bD5ftNBKLPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB2587.namprd11.prod.outlook.com (2603:10b6:5:c3::16) by
 DM6PR11MB3035.namprd11.prod.outlook.com (2603:10b6:5:69::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.26; Sat, 7 Aug 2021 15:41:53 +0000
Received: from DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d]) by DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d%5]) with mapi id 15.20.4394.019; Sat, 7 Aug 2021
 15:41:53 +0000
From:   Jun Miao <jun.miao@windriver.com>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jun.miao@windriver.com
Subject: [V2][PATCH] atm: horizon: Fix spelling mistakes in TX comment
Date:   Sat,  7 Aug 2021 23:41:40 +0800
Message-Id: <20210807154140.1294779-1-jun.miao@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0006.apcprd04.prod.outlook.com
 (2603:1096:203:d0::16) To DM6PR11MB2587.namprd11.prod.outlook.com
 (2603:10b6:5:c3::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp7.wrs.com (60.247.85.82) by HKAPR04CA0006.apcprd04.prod.outlook.com (2603:1096:203:d0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Sat, 7 Aug 2021 15:41:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86f97a3d-7463-4d14-cbed-08d959b9e149
X-MS-TrafficTypeDiagnostic: DM6PR11MB3035:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB30350436F3CFA0B2BA80206C8EF49@DM6PR11MB3035.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nvwW6mkMc/wd7Oe95e/WlvQHDbSuRplmDrkvbNyQ7xxcN65NTTsSpvBUYVLOal9NyZOA3Bl0ZSR9994KWWWgrSSXUcZ90vDTTfICWshujnfeTk+Ebm3PJRDlIo2NXyBG7B+2ivMc64os7gQHt613GgmAdOMc+I1Zqceb9I/ZZS4AU9YnrrJcwxqyV61md0C0TsSAeNI1KaBH5wjWihRu4eMA5f4EjROOHCRffJ/rU+pE8IhPHT+A7ahtyCyMpVB3dgaPpwuEaQOHYQ+L99T3ihgK9LOpvuA17/rj316vSt5vcn00jju69/+d0TMT2WLd8v7KnSIe+Ohw2n1YWM0wbzXbEglCwXl9R3OwUhqfr9GeKzH/KUlRAeSXj2DJ7sKXn0LVOvxOlwEOcmIObAefca/9x4UUPOYPILOfm33/YfDbmvcu4IK1sMKpTzQyNdnuYrhLREZdkarADkDTuZ4YIiL7EgfqGLak6/otF8V/CXIi4zd/UwMisYhnD+Fq7cRJmMie/pUXSecXWO2NB9lGcroSXlrguuo/E6r8wJ9E/O2e0mTuESIvL6Kaq2DZ3pUOOAUJEnQi/SHEdwMqquzB8w6Evrveeaeu0SHHZKWtqz4UT0OKYLBzQWB7988ULaRJksfSsfgWjnAeCMNVf51g+mw8mc794IZC3r1dliVSXseBsM1KvU/2H3pV+KyLUS2r6n7+pzzyiPqbe6+nFbdzrpXXtJvv11s8bt0pztCtcXg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(316002)(66476007)(4326008)(5660300002)(508600001)(66946007)(1076003)(2906002)(83380400001)(86362001)(107886003)(186003)(38100700002)(6512007)(36756003)(8936002)(8676002)(38350700002)(26005)(6486002)(6666004)(956004)(52116002)(2616005)(44832011)(6506007)(6916009)(169013001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RUF5bdqKKB73fA/O15Eatg9dFoq0aWusiGzaB5YtkoEE2V0FvVPS1nHioMNv?=
 =?us-ascii?Q?HFW7UfMHZ1nG+xgylKsmvJKIEEKqz1Ebwf9HyvyBNPQ5ilqmrJTZTVamW3Xg?=
 =?us-ascii?Q?c9Rbe7oWQ99LJL4XVjNQ+uf2Ozu7EexUPK/6ePtRmOI9TYUbjeuHkVq5jSs8?=
 =?us-ascii?Q?7kIq7Ca9a8mOAL12BJDYoNXHqqxQZIKMbpH0vGjHl3krIQ8tSfufQqmya9Z9?=
 =?us-ascii?Q?PrYzYTLay2acrYBPGrl+3b1nm7PKmivr72EcJUo51Pv0d1slFBrX93YLpPVn?=
 =?us-ascii?Q?+b8zQWkMe7TyRu3pxhSG6K2MFNFdSh5h7q1iTciWheyQjNrA8aoQoijhraQF?=
 =?us-ascii?Q?D1Fw/LnYeJBhXoXIU0iE0cbBkpPEal+emYX86DlJHdXLbRrlg9K2siHa4uOm?=
 =?us-ascii?Q?rsAZzhnCaGfv897nJiHSs2Abz8hHzPO3wlpxX3UhxEY3f/iaMYxeRufyubYo?=
 =?us-ascii?Q?i0VpCHr9mZVE3JOgD3XD4d0KO/Ut312ymaJH0/ohyP3YS59LDNELDsPZkNIW?=
 =?us-ascii?Q?hu1zRcWUzAGuP3rEjqOZnDxxgAjcRalIJaPx7gv3ptn11b6XHkSjNVcYJg8D?=
 =?us-ascii?Q?uclF/N8gQc6YNFPE7NmegkyVfJnqONgjA8xsTJ/aVh3nNyJrdiKOmUOqX9UW?=
 =?us-ascii?Q?/71IzJcZsvaVNvGoD+Mu5UJ6vo8gSEWaYj9gk4J7qH6/Yl1BqCc+I3ZyRE2V?=
 =?us-ascii?Q?ZkD4OoVorcaKzFigZHzDIftARqmgH+78xQFWdKALUhxtG74c7rWKR23moWRt?=
 =?us-ascii?Q?TFijQDXbB+rh89dF5XoGcOpXz+CGPDmWe1gLDPl6AkONJng5OVRg6sVfbsUi?=
 =?us-ascii?Q?uBNZfsPwuvnb2rHsUswW782EXm3b6kM8shqZfH7IkeRhOsXy3Z+xV+E1AbTo?=
 =?us-ascii?Q?bS3M71VVEUehIM86EKeUeM2NEvVDn32mAJQKSU/G887CBoeEn8FD7KpV16wL?=
 =?us-ascii?Q?pnUj+FQ66E2lBvxqaqZ3q9IR5l6MZsW4wDkksejS73HtfMTcEyub7R7bQQCB?=
 =?us-ascii?Q?cDXhXs8cUNSuUYcNcFAWj/B0EGV76I1Mg3n7t2bdEcNRvdIgkKh2z6AfakjM?=
 =?us-ascii?Q?MBJdtXiJvXc56bP+Q4v32EnJp5BL2q5fgBX9nwMrT3cLUOxZsuUclKSgFxaz?=
 =?us-ascii?Q?6AbrvWVF577H6NqABCIMhjrq6PkV5+p+Nb4a6pPzLMUxql+KUb4HX/XXJ1aT?=
 =?us-ascii?Q?p93+64QrJa5i7RgC3G/e2wa4KxtrXWh5Te7J5MOnxa/w50H5HGNe4RC4/meJ?=
 =?us-ascii?Q?Dj0uyBZ44KXG7qoSjT7K3NmK5K0YsX9OCaSjKNw/9VB9h/v1MFjSPuRS3N2h?=
 =?us-ascii?Q?WOpkb2Hn5qoNqxUNwJWJ1vOW?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f97a3d-7463-4d14-cbed-08d959b9e149
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2021 15:41:53.6415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12XQs0lN13lD/mOdH977s/SFU1CaSoDeZxh+YQGOHvwk4xzwWysq2iOXLcaXw96mYSXJHV/S87S+Kr4m1zC30g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3035
X-Proofpoint-GUID: US669vzvCXpBQwPUs90hnj6trmyntJ_L
X-Proofpoint-ORIG-GUID: US669vzvCXpBQwPUs90hnj6trmyntJ_L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-07_05,2021-08-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=558 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108070113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's "must not", not "musn't", meaning "shall not".
Let's fix that.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Jun Miao <jun.miao@windriver.com>
---
 drivers/atm/horizon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 4f2951cbe69c..d0e67ec46216 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -2167,10 +2167,10 @@ static int hrz_open (struct atm_vcc *atm_vcc)
   
   // Part of the job is done by atm_pcr_goal which gives us a PCR
   // specification which says: EITHER grab the maximum available PCR
-  // (and perhaps a lower bound which we musn't pass), OR grab this
+  // (and perhaps a lower bound which we must not pass), OR grab this
   // amount, rounding down if you have to (and perhaps a lower bound
-  // which we musn't pass) OR grab this amount, rounding up if you
-  // have to (and perhaps an upper bound which we musn't pass). If any
+  // which we must not pass) OR grab this amount, rounding up if you
+  // have to (and perhaps an upper bound which we must not pass). If any
   // bounds ARE passed we fail. Note that rounding is only rounding to
   // match device limitations, we do not round down to satisfy
   // bandwidth availability even if this would not violate any given
-- 
2.32.0

