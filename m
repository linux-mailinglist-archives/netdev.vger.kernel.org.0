Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1582541EE42
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhJANLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:11:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34274 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231311AbhJANLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:11:03 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191D8kpg012052;
        Fri, 1 Oct 2021 13:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=x3pXSGHhcRAPw4ylqj5PcvA5F5ciM2zLIPJH163TX7c=;
 b=eKAqFjNAu9gstHFRY9lFRm4g1VA6GauU486QPPtoVKzptRORPcv/kr2myFXooed3CP49
 ChNowrFF7OA6bmM+HyYF4tWA3YE6/XH7ePUa52gE28sUZZD1WKPVJbc+a0m3wtXlcWCM
 iczZ1FhaKXN12VdpUTJ0efYbjb0CAL5yuG2ueOvc+Y3o4CjPatCIE7HQ5qBCT0Ruwasr
 XPFaqaOFMXrEm/fYqtR93sBbYuOSD+MouSjaRIqTMyMkA6nZou90kwZy5olNmW4Q6WwD
 RKnGH6a0DJlLmUOTgusW78Tiq1nVYpDCCyvQ7mVm/l2rEkgw90WPAlnQOWr0gdD/NfwY Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdds872mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Oct 2021 13:09:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 191D6YB1116872;
        Fri, 1 Oct 2021 13:09:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 3bc3bp5t2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Oct 2021 13:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqB5eCzdYozeF3SJTap6DJqoXxQp2wyF/zPsTuS+zsWPW1JuM+bEeBgPUtqVv41JGkitddddcpVWze8nNvrRc2n7vATjYDd2iR3f9QNe5ioqXqZ2W4VEcznz2tCbJo11eNK7u+z5gKm8QnAZKaSSbva5CG6u1t1FsuAlQ/vu8suGX+vs29F7IFSaEKWruNyGS3Od6H4YXvv6SCLJqt3dUNfFmcwDdXauXTw/3M+tJwvaU1ao8kRccAzdkdQaBNBZgJr2X/inXO1O9fcwtTuxNER0HqEuKNJegkWJiocd1BZ5+W26QaFcx+o68HoR6WRB+LcFY1Hy3yZsc6kwktFXDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3pXSGHhcRAPw4ylqj5PcvA5F5ciM2zLIPJH163TX7c=;
 b=KEsDIAoPeSyAU7xS1oX6iffKJufQ/auiDVE/ezYwbfvbAIup45yLPztXhYdJo3HvhHhbn9Z5/KF3V7o23PIKfKzTRNPwVs0TV0dmYa4JINaK14YKpuM/p/E3PDORo+lCQwoBMdE0TNd/7FXMz87iLwGgUptCxBPmS6ZGF8VhCHTK+ai5BPxDZVbqF9M1w81eH5eHhZ7vaUuC08oIlQCHIz0yuOyjeUIB55WtZkfQtTgJqDlaiS5vHZwqJBB9nhte5rwMDZRtt0tc7NrvA0q2AEbRtEUcG73ybKOCGZct7v8I3Bh5Y+VbAdT3xy76E8hZYYuOjfniuivZhvw3d4VE1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3pXSGHhcRAPw4ylqj5PcvA5F5ciM2zLIPJH163TX7c=;
 b=V7+Nm5pOY5ftuovBjvcj4QkjbH/VFqfb9UilGBZljfJX0OBBLEvgfkhmBs3u2MOGCxycurVPv6OfR4Ju3YxK/e7IdGGns+wrvHiVAyIvSkQ17TauLbddHlwtlAYOiC2C1TkUBwyXgdnMw33He/f2vcFTr2+AllHN+P3aD57FqEY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4500.namprd10.prod.outlook.com
 (2603:10b6:303:98::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 1 Oct
 2021 13:09:14 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 13:09:14 +0000
Date:   Fri, 1 Oct 2021 16:09:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     shjy180909@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [bug report] net: ipv6: check return value of rhashtable_init
Message-ID: <20211001130901.GA6141@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0139.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0139.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Fri, 1 Oct 2021 13:09:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62076f18-a15d-4e52-c7b4-08d984dcaada
X-MS-TrafficTypeDiagnostic: CO1PR10MB4500:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB450025FCD085AFEB972CF0278EAB9@CO1PR10MB4500.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6q2qMzSuyDSSEXOavE8Kp82dwk4IDvJmiKUbC+R8sMp5NtlPtQJzIJt6J+3haOLOa0UVrxMjePm4Hoho2kioD4UTN2XW/UedzGnyQGKfj6tBvg8Tk1682xljbVn1NA2g0ZuVTgoKMd//A3Zah0xXRyReXcT8LsZSYbZDujLSFeOH/ZDtwyjqczt5dDn1tNa0hgG118b3WNfuEiUSdDMgO8ZTCykrYYpFz+101pGMqZHz1/JH6lTJMLljLsxll0vkVySCkk9mM7YsP8tKEV+XmRjm5vvqGdKCnvY5ozJsU+3MLvBwTnDPvJhyzUc9O2A/924HfxPVI6ERcbCjhD5N928vEd8HAgn0THbai2Nky/oxtqCMSV963sMoIGEClyPzPl5FXRZXoF0/FNVj04Yp7/Gp5k90kOQDLvtn+0j0z4uGNYDcv0bZU5Ba7wva9v1zVWghOpQFyLjEQLY8O616qyagSJM9AFTdol0v1H/YGtjYYB/eaYuYopMcy8qxL9ct3x1913KQMcqrNZ3j/+6NIlBf/xxJr9X1TF9cEJ4jT1iS6+lYQI5azro/Lo69or8sD7rRCcm5lj71/VVLMB6IGi8qHpKfWIgBoRr+qcwNjQE5reZkw8ND0fLhaMlFQMdPGBPcv9T3PhU5eBkXM+mgtx5VfbWjTSn5XXTQg7bFewtPlWTt+Aqw3mPIwb1bXUKL46fWUq/MSKbe5TAiU1b9Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6496006)(2906002)(66946007)(4326008)(8936002)(8676002)(83380400001)(316002)(9576002)(52116002)(86362001)(1076003)(5660300002)(33716001)(33656002)(6916009)(9686003)(186003)(6666004)(508600001)(38350700002)(38100700002)(44832011)(55016002)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y0VTxsQU/+QSBJRE4QqH8tPVk3L5yeX6m/qD14Cv6DFSuhcixShyzWmNJTEJ?=
 =?us-ascii?Q?PY337R27lH8mzO8gzQa5C9h5+WC5x904knbWJrsJ2DjR2sGdxYW+Xo4VaYyD?=
 =?us-ascii?Q?Dn87lV7pXWptHSZhq3vSfP+AG3EA/3tYI/+7Ug+vQ0YuJusHnG7JhpbBAtB6?=
 =?us-ascii?Q?mqa89hsD3OOThunLRkK/umLS4UCmEzkBtLj4DTzn9ziHL0g7QyFimvCCXXm+?=
 =?us-ascii?Q?i4bYVktA0zagB9d3mt/5Kx9gkS2DDAPt1by4InuI82ajdqsNAECPkjTOnyfa?=
 =?us-ascii?Q?zypPVgAPqzsdN0b2OuTbV2ggzk29F/ONRihoQ92KhHd33VU3EFz0K6Lhy/Ue?=
 =?us-ascii?Q?HIN4v+cgURJSqR93mq26TpdJ9nLJxu83gLLfQnorwX7kzZ8u4eCgL6FPSxww?=
 =?us-ascii?Q?1Byyc2aINwM4mM+5KM7pOIPhH5g7LYs3Xd4Ti1ANgMmKcFTCIWPrlp8ngxrs?=
 =?us-ascii?Q?jeH+lEh2YXj7sgHVMyl9jlqnpvToirF6OpYcu8s790fpQlo0Ge64q6mgPm+l?=
 =?us-ascii?Q?TWHOY+0VQtf4Zn5qAVCQL4knrejRxmgTrMK+HsmZbOFRu9DvCGFWaL//Kn9N?=
 =?us-ascii?Q?FBmdvJT9gQ3Z29kI4MFoIRxSjMKpKND1qTsPMpam7LNdqKgEiLQMe/awXynH?=
 =?us-ascii?Q?hyhbcQ+sTRo/sopUS4e0UkeaJmP41YgOhhaVTkvwMiUczI0DQGVIvnrYiu6B?=
 =?us-ascii?Q?dtR5k+m63TgteGcA0YUlqZi51WFD8f/30KhSCITQP7JVrm3AevBRC5GXMv6H?=
 =?us-ascii?Q?E9VBdO2NdpyhuuiRsfHnIyPK64M44PMo9kia/klL7fAIFHYCWW+aBomfa5+G?=
 =?us-ascii?Q?8mey/rvQq9gTBzAbPDnmI1INLc5CFfPVQv+CVViqlo4MDTL+ZOXlQGa9jIj0?=
 =?us-ascii?Q?lb8BKB9K1v+SvRRT54pzE0QONdCkA2SH0iElZDtghbsjjQ3GKWSSoS3kZnxM?=
 =?us-ascii?Q?Fgd9k3Ge34KaIL3ayqu6WaznRonVQYGp2yqTgcPhf2dGoi5Cwef8B31F55o3?=
 =?us-ascii?Q?K2teqXLDQ+En8NHBsyzRnMmgvQHZY+oQMnaGm5vgjaARLRBjbCHvoGngnuUr?=
 =?us-ascii?Q?fQbL7rqg0oHn5Z5Np4BLzkJtaRDHmapZSyh4fWsIS9Yxu19iDrGd/OAIK2ta?=
 =?us-ascii?Q?RX78AFp/GrlAXgnaeTSj/BDhvqh9J+PDhLQEQgImetviiOtfjrOd3FshJGtc?=
 =?us-ascii?Q?YpA9LfmknD06y7rpS1jvsF0BB/5h3mNRHSb11NzalqF8+b/W8ic2K8Jow9yv?=
 =?us-ascii?Q?3PlyZufgZjyiyvx3PBQr7cCyFipzFW8X4yIYy90a8OMDWi9d6fPnVHxn7aiC?=
 =?us-ascii?Q?4UrqUMBRGoCwI38KwVZ3Ahc1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62076f18-a15d-4e52-c7b4-08d984dcaada
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 13:09:14.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5hLMgPCn4yS7oJx89AVlJNplt6jNPWJEnEWJ3wMOkSOcJegoom+JjfyOU5DTjQHtFvp7Nb1Fk1AzUtCxz3K+JGh/+Hn4f+GOq8hzhtRMPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4500
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=925 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110010087
X-Proofpoint-GUID: Jw7zCdzAocJwjlUzhCMDTF1wb7ppzbf0
X-Proofpoint-ORIG-GUID: Jw7zCdzAocJwjlUzhCMDTF1wb7ppzbf0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello MichelleJin,

The patch f04ed7d277e8: "net: ipv6: check return value of
rhashtable_init" from Sep 27, 2021, leads to the following
Smatch static checker warning:

	net/ipv6/seg6.c:379 seg6_net_init()
	warn: 'sdata' was already freed.

net/ipv6/seg6.c
    358 static int __net_init seg6_net_init(struct net *net)
    359 {
    360         struct seg6_pernet_data *sdata;
    361 
    362         sdata = kzalloc(sizeof(*sdata), GFP_KERNEL);
    363         if (!sdata)
    364                 return -ENOMEM;
    365 
    366         mutex_init(&sdata->lock);
    367 
    368         sdata->tun_src = kzalloc(sizeof(*sdata->tun_src), GFP_KERNEL);
    369         if (!sdata->tun_src) {
    370                 kfree(sdata);
    371                 return -ENOMEM;
    372         }
    373 
    374         net->ipv6.seg6_data = sdata;
    375 
    376 #ifdef CONFIG_IPV6_SEG6_HMAC
    377         if (seg6_hmac_net_init(net)) {
    378                 kfree(sdata);
                              ^^^^^
--> 379                 kfree(rcu_dereference_raw(sdata->tun_src));
                                                  ^^^^^
Use after free.  The truth is that I don't understand RCU well enough
to say if just changing the order of this code is enough to fix it?

    380                 return -ENOMEM;
    381         };
    382 #endif
    383 
    384         return 0;
    385 }

regards,
dan carpenter
