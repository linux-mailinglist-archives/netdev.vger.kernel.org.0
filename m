Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B67846F4A2
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhLIUKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:10:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3236 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbhLIUKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:10:32 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9HkiTw021168;
        Thu, 9 Dec 2021 12:06:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Ras/Sn2LsqgGyQNRgSp4M9DxBkTvVLP7nNz9qlmQ4eQ=;
 b=Q12gPV/+iQFVwuWeTwCkTtRTf/Xx728ItE5S7tQUxEtRwaD1Z4FnuPptuWV85vUluDv9
 R1rgILXudfWEuvJ8qSKl+qedEBEcaVBSRRLFLcKrEeeG46RyC5JPvgLi+M9015aag0Fn
 C5dzRtrBBxEHMg3PUWft/+WB6twLV/Ch9dM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cujg03346-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Dec 2021 12:06:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 9 Dec 2021 12:06:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzoQw/B32fDLmEd4fIhOix1PIzahV23DsFLjhKCjicza65yAx9j1Q/LztFHn6W1ign9v8tho3R+XQT8YxkuTt/KsWu5V9IffnGo5uIQtCd6O/vRE1QquABUQXupaUFoUQkrK88uqQlYh0JMNlQ7XQnJhnMZX60b7XMLNnvr9Cja5nCAMZvr0rdeoe1wsSvhlmLxtbRtf+rhIumRRrqIz6aivmQWQOKKV2rOAo0KsRGWhYQtaPu3kqfeRqmIjXUdwnAX/OaXz0XoHQlwDkmEKAmdoTy5JQZGcrJo2mdTz0A+2D7yM2F7kuNCrkvw/ASW4yLwUZ35BqID2TZDrMsfyqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ras/Sn2LsqgGyQNRgSp4M9DxBkTvVLP7nNz9qlmQ4eQ=;
 b=UPnf/Jn1zkx5ViwH+LLtJbxeF/8yZv4fWqZEqauv0Nm9qzNczTf/sfG9ii4gKkur1NZG47dxRwZ0SxqBFwqyaEQYFwAvlfJU1cW4GsHfK2VGvqG+f+iuLsGGmkSvC+PMa4vOKSsP1Y784cI4LBTkMTX3Z834qlIGYi8tyK6SpSMi8/OZc+vX7Eh66UHabayOdkotq7y/II8yhgxX6h/8SE27IVyWyP5Cq1+sJxM8tmDXggYgU43zyUOoR4LMM/bS60zx66WYpOB2t4Q4H6CnTsEblZfJjaXruGvB9+NbatUqtQ4OXnlmD+9biXUY0Bir+Ygpb5QIqeacrJNS0suMsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2510.namprd15.prod.outlook.com (2603:10b6:805:25::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.25; Thu, 9 Dec
 2021 20:06:36 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 20:06:36 +0000
Date:   Thu, 9 Dec 2021 12:06:32 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        <eric.dumazet@gmail.com>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <efault@gmx.de>, <netdev@vger.kernel.org>,
        <tglx@linutronix.de>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net v2] tcp: Don't acquire inet_listen_hashbucket::lock
 with disabled BH.
Message-ID: <20211209200632.wpusjdlad5hyaal6@kafai-mbp.dhcp.thefacebook.com>
References: <20211206120216.mgo6qibl5fmzdcrp@linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211206120216.mgo6qibl5fmzdcrp@linutronix.de>
X-ClientProxiedBy: MWHPR15CA0046.namprd15.prod.outlook.com
 (2603:10b6:300:ad::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8c7) by MWHPR15CA0046.namprd15.prod.outlook.com (2603:10b6:300:ad::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 20:06:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca3cf8cc-dbdf-4ed3-3b78-08d9bb4f671e
X-MS-TrafficTypeDiagnostic: SN6PR15MB2510:EE_
X-Microsoft-Antispam-PRVS: <SN6PR15MB25106B7533199B366C4EA98AD5709@SN6PR15MB2510.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8S0MdX0hTOPEz4hzafQF0Lgp8Luaa6XRcNG0d2mYlZiQ2yjRI+RffvzIhHjABl9InODMMfVNnb+zCMJS4wiPMgjd92lZA/DVpr3CfypQJlUHPOz9m7LYBLlnuW+t3PnQoaV6m/GxVb5fpUjgOQJQ+674Wzc46IShY7hYlbVVKOdxEDzExt2jVMom2ClKMfD8wgJuGfZkATQJRn0hl06od0Sp9os5EFGYkxrUG2e5GizTK9SSUnPKbZaWQCuGsjB84le4ZB1V/Ach9wWilz6Cmbdb4XmNQlHwCi/If02uHQRnC7JcklRmFBVuB8CRvETVGBMyFaldUgLmm5Sbj/R6HBDB5hk7qluv4OYVtF3shsGNIgKmdQ/hNrp+v0UIEj4+XxnEW6P8rMfo9g3mWCvEK3y23OwcNvfIRN+OLZUcC8bw0QX8o2j0VpGxxDA3nB/B37mJrUTAdSnlpEiLFYYJx/oOOzQ+9zxXIRGGYQ6ouYiKtqCcYcSeV+EyYxrNCQg/VR/GwinbyuDyd7gTlYqT6nNi4KEZ8XTmOpQHBWEzpwHvvTYGK2pDuS5JB9a98L7/RvxJHoKkSXgG3uaWOb8IzRl+1zYhlmYuWRSd1By2nx/fH4lgGCXZLOXIH0l/TjvvHpwxRJ5jfwYzf87BnesSTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(54906003)(9686003)(7416002)(38100700002)(316002)(1076003)(83380400001)(55016003)(5660300002)(66556008)(66476007)(86362001)(66946007)(6916009)(6506007)(2906002)(4326008)(508600001)(186003)(52116002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u2er6YN3+a1vS5DUo9reo/HElvc+lJUqfIfZGFp8H9J/NYt1CoLmTILQ/RFx?=
 =?us-ascii?Q?87UYqlRgV6VDzVtFSHIEzDNEEfvqCVP/vqbZn/6MIdpTD3FM++j0nlIHax5x?=
 =?us-ascii?Q?U7EtxkvdT2HChLsE9ue6CkOOu7PFCjgAjwt4npwdr9he8yjIwA4MXaoB1G3A?=
 =?us-ascii?Q?2bB1pM8i/jblr9uNP4/2gY88MKIqbpl7z0sNzItc0tmZiLv9/fIBDrfYeJU+?=
 =?us-ascii?Q?vuirUmF29sSqtFDLHxRga8EIumnQM7S6c2VwaXbp7/f4aFHCbcgLSQvdzM5K?=
 =?us-ascii?Q?Q4sWWl7g/9YpsGVa0cUDt+o0TL3+NtMJ4fHTz1mf3BRQQLCU6KFMSYir87O0?=
 =?us-ascii?Q?LITZA6iR9Da5caXdiBJtWT5Veuloz01lr7o+DwWoHPo4jzOjl8atYT/UcJd2?=
 =?us-ascii?Q?5muzEPvPAV3wfoLI5KsoDiw0DkhVgfpIgTYzpXA95OF+xqH0FES3zylTQAfe?=
 =?us-ascii?Q?GY0E0h4yTHNrHQNyu1AMqSojiDHKrzR8SuO5OPtHpxndY3Hw9i/Rqoa9CzEC?=
 =?us-ascii?Q?Ck4qpv+gOdWVIRsfWfqZtWcKc44C/cBGguNTNiqh0/QoBi2HYuQYJ7UUGet4?=
 =?us-ascii?Q?+czBkAJxkEF4GrZ7yAb/1FfwZXN95+amLmpqT18bHwLDvPzx5EyJphlavao2?=
 =?us-ascii?Q?VFytaRIuXwwNAS/G/OVQryIKeiHQXsFf+tv67IKnZRPlqX1Wz9bJPMm4b2ul?=
 =?us-ascii?Q?pp5BNsCdHA2X7Bn+fLZm2jV2RUWJM2tWyncwRv1lY4COK7WlWhgE1gGpPXgB?=
 =?us-ascii?Q?fyoCLU+S8uSvdgOY6Mpx6RiH20F0biVdr8alu7leJLGJNFg7ojMixmSchTTI?=
 =?us-ascii?Q?SoEVrMOySKML8pBwtTOxE3laW081AeB7JeQ6N6ah/UM2BU4NXrnJKwkAF8uN?=
 =?us-ascii?Q?888QIEsr5/bm/Os81pSNh0VZIdrmKTZP6SWGTjHxRszYcD39hUTw5E8KrVvL?=
 =?us-ascii?Q?7Czu1LstG/A+8VENX2EwteUxKdDyFdVLUpzAIdUjHlijX3K/2q/mR7LrPAQ0?=
 =?us-ascii?Q?LJpZLL9+9zWZE05CZJindDtYy+vScue8mz9vQU1A9LEiH8ZwWQXwoje5DLN4?=
 =?us-ascii?Q?RIy764VK8rg45V+67yLqm+jYYmIrwogLAx5NTUton783iAbMAHut0z8fxX/Z?=
 =?us-ascii?Q?gFif2FuszROodfpMNcxPMbS2fm/gb8binCks8Uc5LBNHnl7xuMnkHBgMlczL?=
 =?us-ascii?Q?aNrfi6svfVtNePrXrpkve5BNL50gqHL01SN0rtKja8mGTmGTAFUNp3ioWcB8?=
 =?us-ascii?Q?f582AF0G9xEnieXjSF44TDJwRTOypY6eiCKUKQbaeIRS34pr6XcfMuYbpfyl?=
 =?us-ascii?Q?ref5znNfL8ScA/b3CTl+mA7yIsSUIHWAy+/C3i7fApezMA7e96G8gp2ljOCV?=
 =?us-ascii?Q?+XgGDF5zNq0jpB4LhLBo5AEwsIDZW4xw8N2hr79OmeqTnTr/W9twn8OzpGPm?=
 =?us-ascii?Q?hX0LYewJreEq64ezCClGshKf4E7v7ZPtGHAChnKV4CBIjnqXMG5DqurtNCBR?=
 =?us-ascii?Q?BxVrHeKvJwQMMbHJuB7FBEJJGLRbc05hI4uZZAQnY5Kc3tlm5U2RADB7moJX?=
 =?us-ascii?Q?q6ZsWtLEdlAXKf+sAq4Uh1b3YMTKQ/43XO/5ssqd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3cf8cc-dbdf-4ed3-3b78-08d9bb4f671e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 20:06:35.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnJo9w3j1aYDKMmQo/Ou/n5NT3k3/SFVn/YdvYw4BarptpLUn4k3TYj//zKebO3r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2510
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: L22iwKCdVAuS1z1O_qmUrH5ag8l9NF-r
X-Proofpoint-GUID: L22iwKCdVAuS1z1O_qmUrH5ag8l9NF-r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_09,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=9 clxscore=1011
 phishscore=0 priorityscore=1501 adultscore=0 spamscore=9 impostorscore=0
 mlxscore=9 bulkscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=103 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090104
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 01:02:16PM +0100, Sebastian Andrzej Siewior wrote:
> Commit
>    9652dc2eb9e40 ("tcp: relax listening_hash operations")
> 
> removed the need to disable bottom half while acquiring
> listening_hash.lock. There are still two callers left which disable
> bottom half before the lock is acquired.
> 
> On PREEMPT_RT the softirqs are preemptible and local_bh_disable() acts
> as a lock to ensure that resources, that are protected by disabling
> bottom halves, remain protected.
> This leads to a circular locking dependency if the lock acquired with
> disabled bottom halves is also acquired with enabled bottom halves
> followed by disabling bottom halves. This is the reverse locking order.
> It has been observed with inet_listen_hashbucket::lock:
> 
> local_bh_disable() + spin_lock(&ilb->lock):
>   inet_listen()
>     inet_csk_listen_start()
>       sk->sk_prot->hash() := inet_hash()
> 	local_bh_disable()
> 	__inet_hash()
> 	  spin_lock(&ilb->lock);
> 	    acquire(&ilb->lock);
> 
> Reverse order: spin_lock(&ilb->lock) + local_bh_disable():
>   tcp_seq_next()
>     listening_get_next()
>       spin_lock(&ilb->lock);
The net tree has already been using ilb2 instead of ilb.
It does not change the problem though but updating
the commit log will be useful to avoid future confusion.

iiuc, established_get_next() does not hit this because
it calls spin_lock_bh() which then keeps the
local_bh_disable() => spin_lock() ordering?

The patch lgtm.
Acked-by: Martin KaFai Lau <kafai@fb.com>

> 	acquire(&ilb->lock);
> 
>   tcp4_seq_show()
>     get_tcp4_sock()
>       sock_i_ino()
> 	read_lock_bh(&sk->sk_callback_lock);
> 	  acquire(softirq_ctrl)	// <---- whoops
> 	  acquire(&sk->sk_callback_lock)
> 
> Drop local_bh_disable() around __inet_hash() which acquires
> listening_hash->lock. Split inet_unhash() and acquire the
> listen_hashbucket lock without disabling bottom halves; the inet_ehash
> lock with disabled bottom halves.
