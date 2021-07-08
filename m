Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942B13C189C
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhGHRt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:49:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229866AbhGHRtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:49:25 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 168HTWCL030226;
        Thu, 8 Jul 2021 10:46:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UZLUdrHR1JrA1s8QYHRSi+bGNA9GoxBwKbBAx6QO5Ss=;
 b=NbrZtuHhnlI/UQCm505g4BGecKC9IWT1Xe4UC67iWmzVu6dReuY+tlasDNuUNn5+Z0lW
 /Be2KjNsylYbn8uTxgKZGojQp9k0clFfd87WoaHVr/+A6qanRD9sl6nPLEjJp7C1eA73
 ZW4BzqsctQ+m0Iy9GBjNmRQEgVQe2DRLng0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39nhrm71tq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Jul 2021 10:46:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 10:46:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0HODLER0haCkcHykFDyoW8R7dqdHihNYSEb/oE3tYIxYK5H50eUz9QPLQZ9Xc4bMbqj54POrr8heLrO/Q+8PQYzasjpb0QqJLTFQ7OoBfwXdhdpJ9sWSSJjoSpWXYkEOtE3VpDgadN4+x31j2M9OoUVASggUr7TWFM34aFvPx9tn60ZXG2t8htbgFdWzHtizm6eP1wyKSYdA/J+ZkiRN50ue+sqjF4qPRJUVbvhlRc2Q3Mr3SIxk76173A3mArltMqGD0e3En/T7UV1v8QhLmt/XIBYbBh0ptIoJjYJOfGnINz9Ynpnx6Y+bKgVvX1DEIDDKPe/MwMfwQCveefu3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZLUdrHR1JrA1s8QYHRSi+bGNA9GoxBwKbBAx6QO5Ss=;
 b=WLmtx1TL4fTm3+fulfFda8gbhschGTq8GgJV4to8dOPdE+HnahYbZs7avrMF/lC5Wea62J4W1R4MHi9oraFGbWBg31wfqJFtG4lk3Yt7nvmqbKrP1+y59SVKgl7r++lbfCkLdGjIPnPOEgWePD4VS84MjIeJx8NXact77Ve98qZMTFEF1A2qtT4dMAclmvqE8yVRZGahvU4ZlwztSWce4M/yfi2C8TQBTjQx4IFSkyBow33CVc4k60NXogfnbPM5ecjKSFI4n4VCMdX6NigD6NFCKa3quUywAfFjfrFypVRE4MCAWcLY5fz1ZtdK8A4SBYyVANgdfFgLN4UFI1LyrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3839.namprd15.prod.outlook.com (2603:10b6:806:83::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Thu, 8 Jul
 2021 17:46:34 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%7]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 17:46:34 +0000
Date:   Thu, 8 Jul 2021 10:46:32 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [PATCH v3 net] ipv6: tcp: drop silly ICMPv6 packet too big
 messages
Message-ID: <20210708174632.g5ctdhf4zgpqcpbh@kafai-mbp.dhcp.thefacebook.com>
References: <20210708072109.1241563-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210708072109.1241563-1-eric.dumazet@gmail.com>
X-ClientProxiedBy: BY5PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1ae) by BY5PR03CA0009.namprd03.prod.outlook.com (2603:10b6:a03:1e0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Thu, 8 Jul 2021 17:46:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01764ffb-d137-4434-0215-08d9423853fa
X-MS-TrafficTypeDiagnostic: SA0PR15MB3839:
X-Microsoft-Antispam-PRVS: <SA0PR15MB3839BD767BBCE21930F27F27D5199@SA0PR15MB3839.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yy3SAt/2SLznyBrpn8aYVEobIwSpgByagaGxUUyJCik4SDP7URe1OUW1x5OP7nJpC5sRZ9/Z+PHI6cewU+UgRlIE5Cg8Gg/S7EvvQWVUf2K3QPbcRL2Th/RPfFf9ex9BzFXDjWSeL//YC8Vs95ng22WL5d0fqNCSHtnhFr21+8aKly5DFErAAEK1a+YJy6jH6m5w9vWiEzYQ/4OlqCqzlbkByDVX+qk47murnUoAiJOCYoQrYmswi6UESyE5PZb2VEBs3rAvxsVaN1mxEBdX3/OPSfp5T9sl4LhgSusctFHh7JC3fiAt/AtQnc4bJpG2+v4jA/ZJblaZMFN/GyCALUiq8CI6+7zjJKtz/JOHqfQdmhCzngIOplRqsJunJhgWoq9L0THY2xOrHUmqUOW8G8wFbcYTSDYLkjmQnr/JShC9P6WEMLhq/BBz7yTYe2lFQM5gVQwX2y7SxHue/1pjDf+u49ni1fJgZ1X19Qiy+N25qNMrCggVw/Gd4jYD2sWlYZLSypcfFivlDXtWXlsv8TlxPqfQSQj+o+6pfiWxxi/6qkUvyUAIuGjiFRmKNETwqkbrnN/WxbiG94/i5uCrnRIYw82k/XF5t2dYMU15YU8cEZHKrOB9q1YENcFb8z1Rrq9v+dTKBLGzPTirisiTqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(15650500001)(6916009)(6506007)(2906002)(66476007)(66946007)(9686003)(498600001)(54906003)(66556008)(38100700002)(8936002)(55016002)(83380400001)(4326008)(1076003)(186003)(52116002)(7696005)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bvn6h1PlslFuWvW+gM4fnb4oWJ3hSIYQGzWjCN0aljpwQD+t/lgksCzx62j5?=
 =?us-ascii?Q?VFvIWCrSOuKV7REKgEF6zolQDkRdV6wBI6EFXCUHErfDZHRWThnxoa+NiyrR?=
 =?us-ascii?Q?14lTTV07wdcnlJPyfhIu/l2XC9n0u1LUGJnXvutqOtGpx4u2CnxwXePj1pya?=
 =?us-ascii?Q?djpY2BgAuAS6ds8cFXUW81tpvOz87oCLAkzGpU41wzMeLCZtKgEVaDg7GiMg?=
 =?us-ascii?Q?VC5meflZaienI9i96dSNTBK6P6gdsJ5WbOUWibF9iaR5qZn8Z3aoCJnLQExe?=
 =?us-ascii?Q?Mt/TCrqM2YQyvUsJJpYr/6bIWhMVCmpaE0Sreuwvjyu6kYKmFWAoo6zcH1mi?=
 =?us-ascii?Q?2lIh/B03Swy/S+WaI/4h2DZm01bVIluSbg45U+a1QHdmwAYpSe/5JwujjILh?=
 =?us-ascii?Q?a+Wr/U2GKUX3rN4XTth3zOLJ+xDAhLfcC7uGhu8Gvj0OCNhKQbYPYhEzVWen?=
 =?us-ascii?Q?1yNXYeJ4Gp0nUTSjvWJn/PuEkt/1ITIXXpZXvhbypGg2j5DTM0de3q6AEFt9?=
 =?us-ascii?Q?TTYbNh6Xt+9r/ROWpsr8iUaLU9Bk1LCos9wj9No290/dRFCRAM7N7xrmQmgD?=
 =?us-ascii?Q?deCruybPZCaBpuD9I+UKSIGFtLtHr3SKcxzlhd22DtxgdH86cEp3JIuk+jWx?=
 =?us-ascii?Q?nhuZ5k35jafgLUXLG9Axq2JT+Evj0GVCUGqBabfEozMrFuP/HWZmpBde706g?=
 =?us-ascii?Q?OkE2aXLkxc36FTrfH3+6fCWb1NJg2ChZHqfSVb3wzG6TagxBJrLrEUP0OeV8?=
 =?us-ascii?Q?dzD8QKdj1MsE+IDOsdxvpNuwGCwXEt81lg3lyJMevSelKyteqyxDNG1bGkkK?=
 =?us-ascii?Q?g/AIlTiEtkQA3NjLz3dmh9gQSr9dYW/Y1XgrcJ9hfjegQxXgZG7jjqSYbQZJ?=
 =?us-ascii?Q?A8RSJiL5oJKw9Jyr+15okhNH5gSVO38I6C/dwd8hdM4KRj2nrREA2150apiD?=
 =?us-ascii?Q?Hq2qMQkucXuJZM3ybPMQSzPnwfpabXhg9sTBS9gqzvS/Wr/1C+MIDnTjT/V6?=
 =?us-ascii?Q?ZatkzCymCiY6VFWKNqgGW0l+/gEheToSl26l/gFPg8g97szxYgyzp48jcTlJ?=
 =?us-ascii?Q?TdyY4YnsbzSLAEmoesOD1GldoWZPzQ18Bfu1rZSoOD6ndSs2lphTUeJ2TOVB?=
 =?us-ascii?Q?KSpIZ7QFicXaoHsGrZWwq252QLHt5lzMuDKJNogZel3JlCiaDjxEv4vEvVnV?=
 =?us-ascii?Q?+MC6aCTy8ncgtweEFDz5xZtF7Ei9OfeqMVfRydT6Xek/7IAN9HtYVlrRCUok?=
 =?us-ascii?Q?M0Zi96/JP8alS5PI+8eWTGveVOS20K2IFiT83qhi2EQEI7sb3WbHE4Ef6GYd?=
 =?us-ascii?Q?mLsh9JU1450LuWOuaOhNT9gQC8W6Vf4s9zSZ+hqqyOOLJw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01764ffb-d137-4434-0215-08d9423853fa
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 17:46:34.6122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwrksAvUVTziMneOhNTkRBa3Go6SOlOK0dT/CiwyipujSd+0gfl2IXsawlIokzMk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3839
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Ja2EoXYJHCVhNw-pebpul3Dv6P66sHdq
X-Proofpoint-ORIG-GUID: Ja2EoXYJHCVhNw-pebpul3Dv6P66sHdq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_10:2021-07-08,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=793 phishscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080093
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 12:21:09AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While TCP stack scales reasonably well, there is still one part that
> can be used to DDOS it.
> 
> IPv6 Packet too big messages have to lookup/insert a new route,
> and if abused by attackers, can easily put hosts under high stress,
> with many cpus contending on a spinlock while one is stuck in fib6_run_gc()
> 
> ip6_protocol_deliver_rcu()
>  icmpv6_rcv()
>   icmpv6_notify()
>    tcp_v6_err()
>     tcp_v6_mtu_reduced()
>      inet6_csk_update_pmtu()
>       ip6_rt_update_pmtu()
>        __ip6_rt_update_pmtu()
>         ip6_rt_cache_alloc()
>          ip6_dst_alloc()
>           dst_alloc()
>            ip6_dst_gc()
>             fib6_run_gc()
>              spin_lock_bh() ...
> 
> Some of our servers have been hit by malicious ICMPv6 packets
> trying to _increase_ the MTU/MSS of TCP flows.
> 
> We believe these ICMPv6 packets are a result of a bug in one ISP stack,
> since they were blindly sent back for _every_ (small) packet sent to them.
> 
> These packets are for one TCP flow:
> 09:24:36.266491 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
> 09:24:36.266509 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
> 09:24:36.316688 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
> 09:24:36.316704 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
> 09:24:36.608151 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
> 
> TCP stack can filter some silly requests :
> 
> 1) MTU below IPV6_MIN_MTU can be filtered early in tcp_v6_err()
> 2) tcp_v6_mtu_reduced() can drop requests trying to increase current MSS.
> 
> This tests happen before the IPv6 routing stack is entered, thus
> removing the potential contention and route exhaustion.
> 
> Note that IPv6 stack was performing these checks, but too late
> (ie : after the route has been added, and after the potential
> garbage collect war)
> 
> v2: fix typo caught by Martin, thanks !
> v3: exports tcp_mtu_to_mss(), caught by David, thanks !
Acked-by: Martin KaFai Lau <kafai@fb.com>
