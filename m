Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878D04CB96A
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 09:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiCCImR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 03:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiCCImK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 03:42:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F07175831;
        Thu,  3 Mar 2022 00:41:26 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2238a9YX003862;
        Thu, 3 Mar 2022 08:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=lls2oJlCde/5R4vs9dRM9IyPdTO59+WWaANIJcDvMog=;
 b=TwiaHjmLOoWruAgaTisRyaVgzpTJ18J16Luz/lBi8sBMc45clrc8w7FK+KvyonabKdt0
 iDBkAxKDOrNYtqlSO4sTzmRRwZMAg9/T86fLLVFdKa/ca2kTf1kuxBCZWwzMmf9WTMI3
 B68nQ9rflcrKhyvfN4R7WkOIrqL+ppWiFTi8SZi9t4kJhntS9Z4Oe490ig9+oD0yy73V
 /HWnoYxgAafN5F1aQsqxiM6u13y+eBH+WwYBMiJ0TJ/GbjQkm89DaZ7yEIVRnnpxuzxQ
 5PLApn5G/bnMD8h1v9Hh4YcuNHIyOOhPugV3A8CDL0cCe8mX4RAdvK7OJ+nMqNAnSeIn qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehh2ep1s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Mar 2022 08:38:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2238Lvg8087473;
        Thu, 3 Mar 2022 08:38:02 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by userp3020.oracle.com with ESMTP id 3efdns2d6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Mar 2022 08:38:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UV9Y8GSVmHICI0sKged5C6L9zYN/E1gtry/+lYCbPdWZCiIyFG86pLb8V1Jb94NknoVljPLkpml0ajmpg/LFM2H91thMGGmiL+Zw9pqvNCzavUxVuR/x9OLR0FXN+boWfnNtEaU3XacIvFyt2a58OvaAb7Zzwb3hDLRAf5s8kGMZkBmQFc/Iel9jcY0UaJaX3sewnONiwuqKcZ2QU+AoAgozK+oUmXAblm31YMnASIMbvihxWoHrQA2yktQe2CkY8O66DqEPlCHI3xFylq/lhhvjqpB7rx/L2DWT8fbJ0WU0IlUybbIvuW+w/ROqhPz4aeW3EYw8mWguU3dyfmroXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lls2oJlCde/5R4vs9dRM9IyPdTO59+WWaANIJcDvMog=;
 b=iM+uZL/jc+h/4yrQiGJaBq/nvYxq1A757w1WYfK786zC0e9835ePsdetp/7tI7r5JmuxpzI+h6ZimVpU3wJDmMA3ASvxzZ7u10jhqG3pbL4R1CrJRhT7jCl3cjcy47D/tMixzhb/3MmerswF5dLa+M9FPk0bnPl/rl+RE3oj6wA+TcvtE4excLOZ6Czf7L/HYFz5m8+grkJ/SmmH83g76p7ozt3ICq2ey3H/Q67ZyvUC5JmCHrW+aDOHbEJVdCWCUo5URMTkGWIsXJ1pYz/+3DGvOdFkn/iS26I4HuQW7/nJRVZP12RMnAprUGVsaehhhJuE3yBHO1KR1uY2RGqXcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lls2oJlCde/5R4vs9dRM9IyPdTO59+WWaANIJcDvMog=;
 b=qCXaoZ4pGtqG8WMQ2MyrGEKChh+1bId7B3xNrBBaNNSazfHD4PVEO2VShd4YgpSYXKQHJaUKATwyLDOoCiS1HwKsIU48WYuDwtISoMm7GNril0RaaMT/OKDkbWAFInyHJ5QY3IJjN9eZrmgECKCG2P1xZoLPAJsaJgxtEcugMuM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5626.namprd10.prod.outlook.com
 (2603:10b6:510:f9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 08:37:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 08:37:57 +0000
Date:   Thu, 3 Mar 2022 11:37:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        KVM list <kvm@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Message-ID: <20220303083716.GL2812@kadam>
References: <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
 <7D0C2A5D-500E-4F38-AD0C-A76E132A390E@kernel.org>
 <73fa82a20910c06784be2352a655acc59e9942ea.camel@HansenPartnership.com>
 <CAHk-=wiT5HX6Kp0Qv4ZYK_rkq9t5fZ5zZ7vzvi6pub9kgp=72g@mail.gmail.com>
 <7dc860874d434d2288f36730d8ea3312@AcuMS.aculab.com>
 <CAHk-=whKqg89zu4T95+ctY-hocR6kDArpo2qO14-kV40Ga7ufw@mail.gmail.com>
 <0ced2b155b984882b39e895f0211037c@AcuMS.aculab.com>
 <CAHk-=wix0HLCBs5sxAeW3uckg0YncXbTjMsE-Tv8WzmkOgLAXQ@mail.gmail.com>
 <78ccb184-405e-da93-1e02-078f90d2b9bc@rasmusvillemoes.dk>
 <202203021158.DB5204A0@keescook>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202203021158.DB5204A0@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0023.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::35)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18773b71-726f-4184-c06c-08d9fcf11e33
X-MS-TrafficTypeDiagnostic: PH0PR10MB5626:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5626D166F5452DEF0D0861088E049@PH0PR10MB5626.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2brEhtGABjpCwIWqj/IXRycHcKXzZGnFjNhAcpGsfszkZcHwMN6tj63L2OpiMuCXDr/vijUPpGbQxtr85QjodG/Ub1ztkkQLFxecO2u6Sc5dub89EqyYNFqbQ9zxI0bIRWh7xo4binfWSUsanHrX714ZK5VrHsdbMDKjwbLN+rAazS+obqXK275K8K8hhsrfXvlC1+/YAT9ChxH0YP1wapsTU+DtwbthIYWZu2Bkz3O1d0S0oPHbhNo7GHB7lCD5gDV+Mu3sJFDGdIhg/onUWz1J6cD+y7Y8vHVpQ0d9gD5qhYSZy73viYF9lqYYZDtimvrbn23EFNFXhByeh80HZHw87r7HmMPOdgZIZHokPhaRuk4mxsLbO9YtLM7W+Ip3GuS8Y6QhCegdJTExl+EJQN1oBxnsVoQL2U8mJKbz4W5OV5EAHGS6N+tXgbSoBQ/6WSpznBHR48Nn9iKsTB/qLmxsn0kMQ9oT1pC0LfqDSH+/P44RNj4lftjGLW55d4eMY4ezopZRvITnl80BkIBSCDOGcKhQ4+tHKFP9kyJE5lzTQkZCLIWvPkZErT85OpVY6XhmWjntQNwtFoP+VpAt2aZlKUeVWyWKyBA6bKiV7F4dZ+gK99hk3qgycT2BZdL3M3i8V+kvAhM3czn32zc7Wy7BY3fTDTZ1k+1A7/G1m+0qgrFI75UfsgHWyRNH6GvSkzyNqP292jpe+lItymvB61Tx6OMD6EmQr38gSmPvB17zwo+Fu3AgeDQn0Ijr4Y0ejjpA58yappp8fRbNb85Cjj/IaiWL7QD6xSFVUfeEAq8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(1076003)(6666004)(54906003)(186003)(38350700002)(86362001)(9686003)(38100700002)(33716001)(7406005)(6916009)(66556008)(7366002)(66946007)(44832011)(66476007)(4326008)(33656002)(8676002)(508600001)(5660300002)(2906002)(6486002)(7416002)(8936002)(6512007)(52116002)(6506007)(316002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AghzP5rPGKA+tL0gt3Ojr2pTlpDyjFT65pyg7K/z0s1+AQH5rpyEKvmh6lYq?=
 =?us-ascii?Q?fda6PBRGLyWGH+xQACLW+8Vuz11WBSt7Cmvkc9IvLRdI/kKeUo2zOQCqwji6?=
 =?us-ascii?Q?Ejypue0Qb1EDBbkNC6uwCdkonNmwo8Uvev6wdmtfgKnPE868zCnkwnhbQOXj?=
 =?us-ascii?Q?1Zu/0OKqrmh7XwTRDjh7ac70M4s27Gu2a9UjZSszmqxy2RO0PiuzPGpYsApY?=
 =?us-ascii?Q?I4hd/cK8hW3xPsD2zmadP10bM52A14CIiCfQA8s29iC5D4pqrIKkJkPJbBun?=
 =?us-ascii?Q?vCZlEqDHkvk8m/ccq+lSW7ApRHe9+G0yJo9mkJsXbz8OtFBGzpWO3JW7Uw+c?=
 =?us-ascii?Q?oYqHrHDNyZkMsZNp2S40S662CmnxOkgaAiRnpsIPCDs2nQ8uNkHRUpbXbCtF?=
 =?us-ascii?Q?amUMbZXSwuxys1Izs9/9Coy6/XNuoIf18ZM7a7CiVefQoqyYldSXb/p3dJ3q?=
 =?us-ascii?Q?wM0o3NUwVTaV5LArxwtyBYany6ip3IwQsTyrNMNOCyTKVHGtiTWxsnRle/4s?=
 =?us-ascii?Q?HT/UHL6E9GC8OOc+E1JKivqynq4mdb4KrPZngSTXvtM7i0B9dpNrr+jH3dsT?=
 =?us-ascii?Q?lRyrVXksl+a0sOQwe87sTAMTpuL+H5rkWzq33Ixj4pjLSHaXAGzmLMr4C5Di?=
 =?us-ascii?Q?CMsePBcN0a3ozMiDLrq42sqBV3U4gVLhbodh3EKn0i0dNJ9Waw4n1fRVOlvL?=
 =?us-ascii?Q?v86DCTIB1qnRs0fxKCEh3TnPSlTSMcw5twfMjbjC4o4Gvecz+6Qhf/avYMst?=
 =?us-ascii?Q?jVzO0V+U8fIQXaohH7gKl7NRiGFzxJvn2DyceMOTISckIs0VEGoA9S7E4JXO?=
 =?us-ascii?Q?7eNYSaU+aiszgpb1vWbsF1w1Sch70PSKl5GpXct+6hHovcHaqwfzpI8FmB6C?=
 =?us-ascii?Q?/8Zgt8KMYOSNg8TfjEWq5jxfCLjldMzjmdvBuymg/z2lDuHviO1Q+T3FkpYo?=
 =?us-ascii?Q?/Z+3W/1WolbXgYQChicmTGJLJGIJIP5an/O5ruF5Q1l96Yqq8poaPc5ZpMoi?=
 =?us-ascii?Q?LyZ81fNJ8y9C0c5sliFm+mKg5k5x1tTYlRsFGlJqhsqlkNlvkaGRB/xog9Gz?=
 =?us-ascii?Q?2PmZRjuteHSIEqyBCHM7bnvFTNg0ReCxzkWukua1w5djd+fBm6BwtN/3d7+G?=
 =?us-ascii?Q?JBvTRx3144svJI0DiOW0Pd9vZi4q6/Ou6DFxx5C8xBJZYiT3dLZ2c/sY74ub?=
 =?us-ascii?Q?wn5owCQJ9K+RaBMU1mn9pyEXi+IbQYOxDVQQG4/AZshuBBMFM9k42PMvueTY?=
 =?us-ascii?Q?mU0l/ADbD4dLXqliR3DJ6v2GKxYEZZCl5iUWBjhMgpsnKBp+/2VzImjLILIZ?=
 =?us-ascii?Q?EE7mM2lzPryAjQGS2uqc3n/8Fmd0siQPBX4eyf2r9O1QBrjxWVDUBDi28m7M?=
 =?us-ascii?Q?Qo4Qb8pOoUM/EZXZw3FoEomEmfDNwDOU+kG6H7R6T4Je0illNp8OY3s3DFOR?=
 =?us-ascii?Q?YBpnvj5l5diRt8E+iSvqR3BkNQT7DZXpqSuNhgJR0UspyZGN4T/pbWd1zvXr?=
 =?us-ascii?Q?oWeCe3k426wejAXadBAoyOWSv6gkfCDyqTib6Aarzz/nRXkuYgcK9KriFBk9?=
 =?us-ascii?Q?Vo1satNN6O3cLG/i8zQdPGfY5r68Oy2lEZSc9svR0YaJ/eke/mHId68OAIIU?=
 =?us-ascii?Q?X5XDIbT+1b/5Zp7BTJDdMZin2Vdp4BiZhcVH57Hp+Qtiibi4Kj+qA3mVwFWJ?=
 =?us-ascii?Q?VI2aWQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18773b71-726f-4184-c06c-08d9fcf11e33
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 08:37:57.7411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKxIp+p4F9hnnIo0dwYofCNEAdrz5Qf9O3g1iTQwxRGCCrzhHeG47yAaGAx6nCUGVywW0ackQXSWmml7dq1afFelKX+3HTk0rRw9KXUEbZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5626
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030040
X-Proofpoint-ORIG-GUID: SMy8JRWyupIzMH0PR4DEsi0KajL72nsZ
X-Proofpoint-GUID: SMy8JRWyupIzMH0PR4DEsi0KajL72nsZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 12:07:04PM -0800, Kees Cook wrote:
> On Wed, Mar 02, 2022 at 10:29:31AM +0100, Rasmus Villemoes wrote:
> > This won't help the current issue (because it doesn't exist and might
> > never), but just in case some compiler people are listening, I'd like to
> > have some sort of way to tell the compiler "treat this variable as
> > uninitialized from here on". So one could do
> > 
> > #define kfree(p) do { __kfree(p); __magic_uninit(p); } while (0)
> > 
> > with __magic_uninit being a magic no-op that doesn't affect the
> > semantics of the code, but could be used by the compiler's "[is/may be]
> > used uninitialized" machinery to flag e.g. double frees on some odd
> > error path etc. It would probably only work for local automatic
> > variables, but it should be possible to just ignore the hint if p is
> > some expression like foo->bar or has side effects. If we had that, the
> > end-of-loop test could include that to "uninitialize" the iterator.
> 
> I've long wanted to change kfree() to explicitly set pointers to NULL on
> free. https://github.com/KSPP/linux/issues/87 

You also need to be a bit careful with existing code because there are
places which do things like:

drivers/usb/host/r8a66597-hcd.c
   424          kfree(dev);
                      ^^^
   425  
   426          for (port = 0; port < r8a66597->max_root_hub; port++) {
   427                  if (r8a66597->root_hub[port].dev == dev) {
                                                            ^^^
   428                          r8a66597->root_hub[port].dev = NULL;
   429                          break;
   430                  }
   431          }

Printing the freed pointer in debug code is another thing people do.

regards,
dan carpenter

