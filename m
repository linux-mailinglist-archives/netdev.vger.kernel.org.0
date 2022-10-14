Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEDC5FEBD3
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 11:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiJNJj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 05:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiJNJj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 05:39:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECB41C2085;
        Fri, 14 Oct 2022 02:39:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29E9U21p009393;
        Fri, 14 Oct 2022 09:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=zts0+APnD33X+CRrhI6Imjgv+nOYbqh3AehP99wfR9M=;
 b=11PgW2QH7bLCirP0C7HqN9vGFFmlfvboiB2jL/q8Ulb6iLdtSleXTW3Ji0DFc93ybJ53
 9h5ntlARWcbzszPWD4GDW6B7hdQ/wEFrXjFlukPyzsn33VFpxwnHHq9sJY5kwRSqdbXU
 EF0LDWYtoDwItfdkBBohZDYymYZ2PNHAA+xX/c1h3Iua7+HiHiKtvE+n9MPXGEdlS9De
 bmfjxU0Dg0dfB429ZFEZlx/C286fM37C+KsIJK4yNOvow83rkqO+Xbg1ZJ8ZCbMWWZ5Q
 S+OQ2rp+t8QxQPIc2tEP0JSWfN2Lu+xzSxRYr8LnuSdhJnNv+hXQvtoAKwMsJ9uqBND/ xw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k6mswj9hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 09:39:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29E7nAf9006574;
        Fri, 14 Oct 2022 09:39:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn79474-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 09:39:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oq5DKrPKCygnBmkKbeuICqw0K4/4TOl3WkPq5yphhHaACXzzkw3rTX/udfU76nYMhDsOGX6co19x1VoQfe20LNf+W/P0vrP7QGls8MEmrH5iLU0FmPdY/WPekNU0XqYnXJOgmBYV6F91Gc7CjQggzVcZ6cfpzseanTDkMBAEffu+SajyXeWu+lSKRnFHvjAqPGN1QGlBFswaDwkolhOgRui//RXuAJ/p/WlAgQvhfH3P3E/tcHek6MR+/HLkW3r8q3Kv36swYdVFt+IeO6xR5Gxgk2EMvB/SKi609WWpQKN+dnL0A2EDa4oA2FrXPqqPtrBebmSCPR/eweFShEuq3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zts0+APnD33X+CRrhI6Imjgv+nOYbqh3AehP99wfR9M=;
 b=Vb2/yGro/pW+d5WH/LC0s+uY6+/PQOt1Lqe/zs3N3X3LzqDqrfe/4jzwpupWGRfAy+++Yb4eEmMp0A4TrUUzf3XlBB0JPDy+iRe4Lr3DG4KRnI1/weN5KCuesfDygrmK1HXRp5Pk++uLjaHWzSVq4KY+dJ8ASwa6owl0Y928QN8eyEHREkG5SaXymZ1jLdzBrsedQ8HMokg5j1nbbIJiWQDAlV2oUEh7KKZh3Kca+eZpoNSwmM52Dalys82bGT2s6m6D7KbAkX9XnMg5AozveoOVUWQBw6HNKwQiSiPy2ulMItXFzBWBzlqsyeiibzu7sfrFqHdDAP6z00pzZggL9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zts0+APnD33X+CRrhI6Imjgv+nOYbqh3AehP99wfR9M=;
 b=okPKpknH0WVR8cPBsur74fKFJ5NAIB7Of98gA5V+fJmfqz6DRC4FChWOAmT4rNq3/EwXfRhlTtGIPr82zQ8fvw8lLz8inJaTcxmFjtv9MdMSZZcyYpocgD9uPCEEXqg6zTDqHs4N2eD/G1VPWogO6BQ5w1Emz2aVVB1XfYDtynk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4531.namprd10.prod.outlook.com
 (2603:10b6:303:6c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 09:39:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Fri, 14 Oct 2022
 09:39:04 +0000
Date:   Fri, 14 Oct 2022 12:38:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] sunhme: Uninitialized variable in happy_meal_init()
Message-ID: <Y0kuLdMUdLCHF+fe@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: LO2P123CA0055.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CO1PR10MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: 448a4ef9-1f89-4b84-921c-08daadc7ee94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6EYhnGnflvfia1h8tOOaEvGciSgtAcqoj44zpgscVsvO6rT60ReHmbCd1OkcWnfTtUdv+q8Bmdqt/cmXOf0FOds8B6egOTAtDlcoNehHjXD+nd92Kr9eh/uELTAEvr/pEdzWNgYRPmzdEfSMAqA/L05zmTnNgtsdWEiEOvjOhvNj53SEd7dWxQbmqE8RD2ci8Z0vVM8bkjtN4v8XvQ2ldRhqoV+J71JJIHwHYDNP8rcrC5ff3ga6TRjihozJxONe/z7Lh7q72zDbqyaeR//1GzCv4l8e6TT5rq7irAnBt8EvGfFKjpQPUaGdn1rfnrLCzmRiC/j4PZTVu3IRfqwDv8wPFwLhZbUfLfqdzbeuNs/sSNsHSmUw9zTvBhVmSidOYCqsfhjgsdLkEuZETtIfbMRbKHPP4NPmYUyKO9Gm8HcUZrUIJQNpqZ71oE+Pzf7s5DpTSdZwSvtjwZkhEXvVoZfix28jjNJ7r/PTLRY4D5jO88n4bzYdt9I5uYhPr0pQCSdHihbdVgQDzMk2XRbMBJQa/5/TCVVMy08O3zqUN8Yz2dj9lI5QLkCYAZGX7V6aC5vOAj5T3Ub7lRwXLtAxkRRwfjirUY5HhWJDJfSLej+ZlFFswIAfYXzzEdC4BX5IQ1WqngQObFi5+ySrXQUhfzm0fhNiOLBaSZEuAX+d4nMutgehSAzPJQe//snFDIqNkaHfPGupGzHhA/r2Kt9dnQ384dRqlblAUH3BT43mlsnkKKe72DWN4EAOgyMFiaJK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(86362001)(2906002)(4744005)(38100700002)(5660300002)(186003)(9686003)(478600001)(66476007)(66946007)(33716001)(66556008)(316002)(26005)(6666004)(8676002)(8936002)(44832011)(6916009)(6512007)(41300700001)(4326008)(6486002)(54906003)(6506007)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pB/jpgDS2mXA74S6MfaUYU0rbJdGhrVYHMAUd+PUT45dvSu6bkmL9yu+ubmn?=
 =?us-ascii?Q?KrmGjXiPwvkHvz1GUqQPMcdH0dp8IA2LDS5wk3yMlz0oE2n+g8z0YljYIMow?=
 =?us-ascii?Q?/fnhbuV9GqO8xLdjtjZmpH555RXa8urcmLhXDtMIrOKcJYiJCJRacP6zK1IK?=
 =?us-ascii?Q?bbHbf36378gOGnxhzUKHSJlZruTLGxmUfJ1chGtisjA0c6EwB4/TIjKAGPD8?=
 =?us-ascii?Q?M2e1s/GjjCU/TihK44FRi1O/+KCqDUafmk1x+fMKkCmMmj5qWRf0UluEINW6?=
 =?us-ascii?Q?6pKeKE1PD+UGxY8o1OQ/Cbn/zniEFEbGytBFEhvNNO1SNNSF0+6rJlP2T7v+?=
 =?us-ascii?Q?6Yh9KXtatMDfZdUNqZXhueo1Qrr1bMboRFJZvr81LC8Q/IxiwtcKsWa2g1ox?=
 =?us-ascii?Q?XxW3zhaXn+7mjAaqpa2xzQWkUvh1BmVLCHDKgR41pnIw5tKXWkN6ujKl9TYe?=
 =?us-ascii?Q?O9X+i8duF3okbtHMNrzK10zusdob7gUXpmyZKUoUyu+J0CE9dYE6lszucAvv?=
 =?us-ascii?Q?a+SIyzgbwgOH/3vFajKd+SGtK+LChI7l7L3D+tKziMNcfC88rWtP3r7pyvGC?=
 =?us-ascii?Q?xI7SOXSdCjriojDryPCqYG2Ztqm9uPqykSKAlqAdwrHIh//8CgRCd1xnNuWF?=
 =?us-ascii?Q?Fs+6d06U9lAq0i+aEpnB0JXwq66JE9wAGXxoLsWJVByUxGp1Xgir5Cqr9jpC?=
 =?us-ascii?Q?awDiW/ga8FIhdMI2W5w34QeIBB+wBqrIyRUV5gSiWMTGzvFHl1Jv93ULX1pm?=
 =?us-ascii?Q?JIZKvTFcBFBsYzmdS2PUFTsVjIFup1BBcth2+efPivqQqTJj9i1Q6wLdbJ+g?=
 =?us-ascii?Q?P3ruk8h8nxgwQpc9PKfiZ3KK76gT/hd4xj9T3bwyTRStuE4XSWrUTU0AifiC?=
 =?us-ascii?Q?pPSncGbat9Hko8ZN3RFwTax5x4s1gLOiSHR/sJqf14iNaC/btBafWT+2MYOs?=
 =?us-ascii?Q?7HceeXP3dNSbqOIo8IXdjZv+voAqvcDA0kILtdLFi+/U9S08b+gpdPUySHh6?=
 =?us-ascii?Q?5IMw22u+innKrKaUWa+k5sASTZnMtwPbtsiSfJI7/gKOQfY7vLoE7aG8s9z8?=
 =?us-ascii?Q?U2oiDKXG4QtisTkmJJdlOofIwV2Rs8Fj0//qDHBJAq1sAUN5G0YUhIIeAxUt?=
 =?us-ascii?Q?jgH4Veo1xrHA2jYltcxuiZsIJDlN06qQ3pZnEe442F7/7TQVa22B4HArCyvT?=
 =?us-ascii?Q?XqqilAQ5K51cnveZjHm8RyOLqf9P19s5rq5GhM39lKUYSL56eba0xwPEpRbI?=
 =?us-ascii?Q?xHMfHkdx2xQdAF6gYWhvLly46lOwyR7GY2XCZhcRralJnatS1ZNHft6ZVJ4g?=
 =?us-ascii?Q?7kJ2BrGN8YZTxIQ/KAE4V4K3sFsh4jf26bGJdOdo+eNWtvgm/1qSKrjFPSm8?=
 =?us-ascii?Q?L+gNM2HOZEAUw1bhUs28gOlGu62nedCeu9rgMk7hr1X9ydEJHQs+dst5HQ/c?=
 =?us-ascii?Q?ODJEEIjPW50xI0OMZ/FaP6nEq66k9Qon6IiSu/7Rt104tT2EgVwPSurFsLZf?=
 =?us-ascii?Q?xPDi5A+dTLJZd2TIt8KG3DSnVlHG1iyPa6Uz0gGAzTN6DlP6gcXcA7tEc8er?=
 =?us-ascii?Q?2f2jUs8dn4Ya6MmJsqfItAKtMxpd7RQ1LFSMPtjHjv7IXVKIU1QdRoIyeiDz?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 448a4ef9-1f89-4b84-921c-08daadc7ee94
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 09:39:04.2282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HL8XSzrTiO2FAjpmnJUDvyBoDJitH206GbGyhzqlDq5s22iAZ5jTjst1sLrpwKIjM5lC5V8PNgOga1tcStoqfpfEyxZPeeZbpHzvvE8bnHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_05,2022-10-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140055
X-Proofpoint-ORIG-GUID: 7PODW2_F4SP-aA-N3HHq3NCM2tZjGHKV
X-Proofpoint-GUID: 7PODW2_F4SP-aA-N3HHq3NCM2tZjGHKV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "burst" string is only initialized for CONFIG_SPARC.

Fixes: 24cddbc3ef11 ("sunhme: Combine continued messages")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/sun/sunhme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 62deed210a95..efaa6a8eadec 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -1328,7 +1328,7 @@ static int happy_meal_init(struct happy_meal *hp)
 	void __iomem *erxregs      = hp->erxregs;
 	void __iomem *bregs        = hp->bigmacregs;
 	void __iomem *tregs        = hp->tcvregs;
-	const char *bursts;
+	const char *bursts = "";
 	u32 regtmp, rxcfg;
 
 	/* If auto-negotiation timer is running, kill it. */
-- 
2.35.1

