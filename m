Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48F041B132
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbhI1Nyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:54:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23886 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240908AbhI1Nyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 09:54:37 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SDmxTb032251;
        Tue, 28 Sep 2021 13:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=8AqHnQBPHT6y7gW9LSrV5m2xRW1/aE8MJsj7YcWlHVc=;
 b=N5jWMwmvURwQyyHFBLRrxW4KiaJQBc6UupRdYOBtGM7JvVocE+G3PEyAVAMT26PjfFW+
 Kt4tFKbAqYRwjt0mx0gFmGNowsICodfObFj53OfKSXqLHEwX9+TAJ1x/9mcgjDzmxene
 GDhHfbAgUjTyYsXgIcSdCBzje+CX6F4q4KWyxGcY5ElW0yfVOd2i0E56a5QwXRWI4CPC
 rhvLguqvstx8+KHcXPQea6T6pKo32PnvtNZZhM038v5oXHV/DDkyR8AyoF+/6qsoNcmo
 +49BLiFEpyH/l2AhdUuO2F9ZvWny5S10Ne0SHd07rz2PnBsbNGWERmCG8+qv1E8qwpOG sQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbexd0hn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 13:52:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SDop6H002468;
        Tue, 28 Sep 2021 13:52:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 3bc3ahavmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 13:52:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpoQs1dRdwZAZzqcYdlCTgr7DpLkQttEcLoYMW4tZi5mub8Y7+LVk5kCWBa7tZcjtwm1sffMH/HMtiSC2xdZfXVzorA9PbskANOjcDncSVEWiEd30nK+7dCfLeiw7LTYEMMPU84NWTLoZxQalcXzCLlRSQuLomFtjD5CWBHKRKFSCZPRUc3IkGXmVwMIafuCU1Qfun9BPfbo/qm65nVMIas8Io/ZWfvzUdKx1hJ1zlvnc1hX3JZwv59wR2D4Sy2RZHQs9bN5WMW0oIps2HXiLtLnV9an0Hnetb7uY3EzYPZTpr6G3nJKScbSYPqsaGAXCKlQ7hFa5x1ybMYcW42mNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8AqHnQBPHT6y7gW9LSrV5m2xRW1/aE8MJsj7YcWlHVc=;
 b=TQjbfQiGAtTCBVsRMDmql/nJ9QXp5p6QZiUOJBDUX7KjgytXStePeVJhhdFloL0u+8mfGT9vPreaWakMhTZ1ZdUKF/NaLyZVnTmwe9pCLni+TWok0R3TwdvdEAC0evc0enamfmS7ThVyUpZ4emEkdpKJgvxelNFBecB0cG5dzMDHVD2RBkLA0ockX5omGilKUvSjGd7tt6Fg6tvvEAgnWTb7EgYQ7oUI+FBXFjCZ3qiSyJ3enZR2cn7K0pNv7solQiXI7SLpbZLmfMHwshVcieuozdVPzeS+Dc2m/PQ+YAnqR/jVTeVSEwTP1l/XYWo9lfWY/hzMEGCT8SOe0pRp2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AqHnQBPHT6y7gW9LSrV5m2xRW1/aE8MJsj7YcWlHVc=;
 b=0TNfXPmgi9MehJoBUHMpvdc6N+Y5wrxV3Z4Smz9uxlZqNYYgljlmO9INCK2vtJrO0WL3z2a3++iff6vzA7S6IKj8aO5dB3EWPDTFrI1EIUgkJJDBCtw2FHVoAmRxDhOdDoxxZi512QG4pT9S6XN6NtnHtEWWUhtPkYXP5+WKXiE=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5459.namprd10.prod.outlook.com
 (2603:10b6:5:359::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 13:52:26 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 13:52:25 +0000
Date:   Tue, 28 Sep 2021 16:52:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <20210928135207.GP2083@kadam>
References: <20210928085549.GA6559@kili>
 <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam>
 <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
 <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
 <20210928113055.GN2083@kadam>
 <YVMRWNDZDUOvQjHL@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVMRWNDZDUOvQjHL@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0047.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0047.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 28 Sep 2021 13:52:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0db8dce2-8ecc-41b2-5ff6-08d9828733f1
X-MS-TrafficTypeDiagnostic: CO6PR10MB5459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5459A16B2E16E24A1D7F5F6E8EA89@CO6PR10MB5459.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SxlpAq7CSyIe7tECUo7i0t9zMzmRVFdQgD8kQY4rOybFfvey3eGu7hgMTa3qtD9PWKbbUY3SAPX7AWWDIm76EdGce0lD3vg7G4jbTHJSuxfjBWS9SlcUwrbTLngYgmwk4XAO8RhVEgp/HIqJ/K5UJHCIxawMpF4M5DrOqDrE/OWvpbx0GyOdGJJn84uCx4/OPQPiVW4Q5khdLRm2QHYGkmMgLcqmoGtObXzxFdsW4eYMxDpvPCdYTBpj4AiIl8fv+2VXFaN9L7nunjmqFCrWKqj7ltHS/SsX7XaNgDWjlhXxdsPK9pjizqhzF0ZpGTXxHgu0RHlzd4Ii7NYVPQZpOV7gXj+88NA23ZNviGS+hbWbVkA7rp7HhVwUtEvfc+hOVmIOIB/6jaOZxPth6AGqCrynO4DpVKri+CWJUegz+zj+5J5M9xzazT3/ncAgM9woEUjWJ0ss98Mou1f3KteyYdfDHzrrPNyCsddzQ0V35VyQqVK0JiYSoXc+p9c2376Sj+1Ese4rm30q1Wabf+P9JlyNWooJJPGCKCTsl5ND0IkpuEhJ8QdJTtOOzRVrd+K49WWTMobxXMsP7d+ZD5+afS2/5mtMNWaYnes8zluWe/h9SP8f60ruGoo/pSIaysSSW7P4lG0lzwEDrXBaW5Aln/UfkXIbdUieKtP0TWKthNWkkbpXMsUv754rXy7yPqi0PccFnDMX3ywmKKv9vytiBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(4744005)(9576002)(956004)(55016002)(33716001)(5660300002)(86362001)(508600001)(83380400001)(38350700002)(1076003)(44832011)(9686003)(4326008)(66946007)(66476007)(66556008)(8936002)(26005)(7416002)(52116002)(2906002)(6666004)(6496006)(54906003)(8676002)(186003)(33656002)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IxAWPbf8ef8u2rNNVK7Zr7mdzWEqWtbKV+uotij3bCl3ZdKGJWJcbgjhtyxp?=
 =?us-ascii?Q?oiVrWWgNtY63y+ERvf8keDZcmUowg6ytEv3gKcOM4QVKt+QWfiDjqElrVbYE?=
 =?us-ascii?Q?w0+vOrXhyESMwEuKaM6eYGHRFEECPx8sVNy3RneEcl8oN8QH56d4ZStJQCcL?=
 =?us-ascii?Q?Owh4Xi4V1d+Kf1brDW1VORJ/iwfI6NhqXKXWM1UVBIj6zpT1qHdQYaQqr373?=
 =?us-ascii?Q?4apoi0FiWRVCtYKyOq5AGN4a6mnZfNsNSLpZGN3Z9L9WD1bnlgS0p4Zoc27k?=
 =?us-ascii?Q?L6Lqyd9h6V/duDPgrwZ8B6ra3B356EN6ME6HrKRAAyZyqk06eZLzMw8Tw3p3?=
 =?us-ascii?Q?yYD0hBt5FCMGVb4I8vUXPaqsHDMki8kJOAmnVNfYDxNSzDJmRI5RIgFdVvJh?=
 =?us-ascii?Q?lIAuNyfD+bc46AnBN8xMRXgikcAPa+NxGXs2M83xdXaG4dbIFwuyWimaZmYf?=
 =?us-ascii?Q?uQHyCI3/NHYs0Rweb6YITL9PPX0attNLIVvQxHGMmCAVPu5FuPuMRLwvBhKb?=
 =?us-ascii?Q?KQU7gpGusssoiXJsYoaRq/1f0Jal3M1EOcdUb4Cey+do1UMF0MvmOU5JtjsY?=
 =?us-ascii?Q?hza+HZ0sYo7N+aALz4vcDeXxi/bslu25QwUwWW2HpnlJOOu/LNOFIrcIv2jW?=
 =?us-ascii?Q?xiiOU78yFPD5dxbdCeQTlFZ7WNyK2GZrMDrV590n0dC9obDqzCmARKUwHjGO?=
 =?us-ascii?Q?KfK0sIdlpmn9uaVJh1J1WoM7EJSOYUgmlDpERWiJ7TKzrw3YAdIoI6ASLnN4?=
 =?us-ascii?Q?Ww9KntsfHFTcJ3un0cHRiyK8LyjQfO2loLhY2ZD/pV3LIIzw86I+DF8pAxhc?=
 =?us-ascii?Q?sxLV547FTD3Bq4Zr1MZDdovahtC0JAO9aDU45ZJd2p5KQiXx6X1cuLcMp0xO?=
 =?us-ascii?Q?KH3Jx2IZ2XVajUcybR36MjM8xH4Wfblsp95IXKFtLjjrvnt4UTm//TtNs7XA?=
 =?us-ascii?Q?PsXpm1PpT49J5Itl4yNlQ3XgEj4NziIe6H/J556UPeDsklW8y8bLfq8Mbu2f?=
 =?us-ascii?Q?Ai2pvo5KxCgE/4RjtE2JKDcPZw2To1Sb44geu7mkT2KPDx5Vex7TEXGu6Eq7?=
 =?us-ascii?Q?qGU5gpyBEBuam+d0H90Sn1jweJZEJP2CFCxQ78T9WMg7tYt5s8RW2//UyuF+?=
 =?us-ascii?Q?x43vOLJoUkDf0paLiT/g3HkdL0GT4bs2Rn6Fn30L9+K9Tawt+3a1TARa3MvX?=
 =?us-ascii?Q?Mvuz9/ckNgGvsHbEi4G53aBStcz212tW+sp8F7S5m5SUZlQjPQVtWXp281qQ?=
 =?us-ascii?Q?nF3LMNhOligPqtrpPUI3nOfZAqAejytO4zldFb5H+4bS7rTvSKOYWDpSNuGE?=
 =?us-ascii?Q?AdH4+0xH5pEVhbNcLRP4Gd5O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db8dce2-8ecc-41b2-5ff6-08d9828733f1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 13:52:25.8445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51/lgCg1ZPc7CZcQQf454Z7pBS8XTqCmr2Ykkw/x9BqBCV9sEoyFMUgAkvl+7njzxxDIP18OFRgsWgFyJ+Sz2ZSAxxFFg8XkWRCTi6qH4ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5459
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280079
X-Proofpoint-ORIG-GUID: 4u97H2vTXNqZhccK5AN1zwEvjwc3A1vC
X-Proofpoint-GUID: 4u97H2vTXNqZhccK5AN1zwEvjwc3A1vC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 01:58:00PM +0100, Russell King (Oracle) wrote:
>
> This thread seems to be getting out of hand.

The thread was closed.  We need to revert Yanfei's patch and apply
Pavel's patch.  He's going to resend.

> So, I would suggest a simple fix is to set bus->state to
> MDIOBUS_UNREGISTERED immediately _after_ the successful
> device_register().

Not after.  It has to be set to MDIOBUS_UNREGISTERED if device_register()
fails, otherwise there will still be a leak.

Adding a comment is a good idea.

regards,
dan carpenter

