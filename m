Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F494CBBF3
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiCCK6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 05:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiCCK6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:58:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B96C148653;
        Thu,  3 Mar 2022 02:57:56 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2238S8IL028932;
        Thu, 3 Mar 2022 10:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=O9xmX1MuirLAIzWDtk0fX2a4LtzMX0loCx+1U2GDoNg=;
 b=htZNNRHGADKbHk52PyCvxQNg5OpqGIiBdTA/p81fpZilFG3uKkyAxDWCoSdZL4a5Htrd
 4vk4LBw0gt192P6BUlVjlNWWB8jn6GcLi65+2xIbK5Ngv0NMqPj9Z1NBnxqmuzI5U84Y
 clINevk2F3YpxrVp3+CFGhTp/LVoxccg9QDewMC4jfMgcA9PE5f7O2uSR0Az+DQxni6Z
 mxs0PQF4Jr663qc8fbdJoEBA9Gc6KTDxqAoGPdC5dMr/h+/K9zS53Pii1xPQfPe/xvD2
 6r/CF8dDBr+jxCJK7iSe0+m3qOP+tN0ZfG0oFG7VqzMO2sTYnDWNVL6nL6dCXB7jTPr8 uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14c0geu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Mar 2022 10:56:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223AuBZT116378;
        Thu, 3 Mar 2022 10:56:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3030.oracle.com with ESMTP id 3ef9b32y20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Mar 2022 10:56:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6SNCZIjtrGwzKDNuhMGJ14geFd4Rj0FhRWYy2NjDFdCSi0BsBAn38rayqceBK0OVc+pFfCO21VC7V/gnflm6asblxA7UlF/megmABxay4ppMddT5Td0pSO+sSq93PLntd+IuG4YqeEN+1m+Gw+FzbPjwtpFIX/7UEIT2EcwDAsBtRsf2LjYmG7np7NSLp10UPUVaoX/P1RWzEv7G65OLSenxbCHP7xuI14TJl36l1e83K7Fly2bYiNXVR7tgR0BxXmVeJQiCerbGWacCfymQawENSncs86oazB3zx3BlO+g0atqQgriXG9khWM3pRhf684q5K9eXDdjEn9Rzxv3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9xmX1MuirLAIzWDtk0fX2a4LtzMX0loCx+1U2GDoNg=;
 b=gOHaLCLZp2lB6kE3NHmkYkzLAj4aua3oODwBPCuXTtb1G1UEysTdO6b6m6NjvQHDek8Irpnlu46KWMbPqUMoqonvknyWRdMxxTQv0DHuzlv2eNaKuKq5O37jhxeN8GOXXY9vy5A7ZPUzj7Fy39G7tuNTZ6XavsJghtBeWHPV1oH4f8FIwFOEZucqfoKy/IY86GwhOQSZzjCdIpm7880YOAAHxHth9T+Kja2aLB5/ID21zjvCXb263j25fXLwWevj6q6RTp1xuqgzDUpoMSNKatYliFagjqX5AH7lH3vHzVlaQjL0csGsjZBlOHiQGVjUIDxnYWHyHx7BILjRlmmfRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9xmX1MuirLAIzWDtk0fX2a4LtzMX0loCx+1U2GDoNg=;
 b=HpSZ3WpTtJpqoARVQH5hdJzHChJhvz5hHEXL90blf3wc7CLiFTR5KPdJBuP4Fb+lgJLwV2WyXn7C5PJDirfZ+LB4Wp6+s8Rv81GAFznRo1s0s8p4c/3BDUQEVmFP/d+x6Qi8ZcCc0pQAjvuQ6Hsrg1OUb5n8Rz1JyiA3i48Xdes=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3961.namprd10.prod.outlook.com
 (2603:10b6:5:1f6::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 10:56:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 10:56:42 +0000
Date:   Thu, 3 Mar 2022 13:56:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
        Kees Cook <keescook@chromium.org>,
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
Message-ID: <20220303105602.GE2794@kadam>
References: <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com>
 <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
 <7D0C2A5D-500E-4F38-AD0C-A76E132A390E@kernel.org>
 <73fa82a20910c06784be2352a655acc59e9942ea.camel@HansenPartnership.com>
 <CAHk-=wiT5HX6Kp0Qv4ZYK_rkq9t5fZ5zZ7vzvi6pub9kgp=72g@mail.gmail.com>
 <7dc860874d434d2288f36730d8ea3312@AcuMS.aculab.com>
 <CAHk-=whKqg89zu4T95+ctY-hocR6kDArpo2qO14-kV40Ga7ufw@mail.gmail.com>
 <0ced2b155b984882b39e895f0211037c@AcuMS.aculab.com>
 <CAHk-=wix0HLCBs5sxAeW3uckg0YncXbTjMsE-Tv8WzmkOgLAXQ@mail.gmail.com>
 <78ccb184-405e-da93-1e02-078f90d2b9bc@rasmusvillemoes.dk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78ccb184-405e-da93-1e02-078f90d2b9bc@rasmusvillemoes.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: CT2P275CA0004.ZAFP275.PROD.OUTLOOK.COM
 (2603:1086:100:b::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d04b1c4-80ed-4317-daaa-08d9fd047fc1
X-MS-TrafficTypeDiagnostic: DM6PR10MB3961:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3961B7F49CE90B06C665A4688E049@DM6PR10MB3961.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y6KIoE7fkbhiu5qMc+dXd4thp++48DDF8VsL+PfAjuGJB4JftI0jDwCvSoQShkY+wLhPkZeYqJNnHL2/jB17bxItFUbqPbt01080mfeDw50U4anv8ZXhcwo1t3K51XA4uMG1KtbhMYvqCb/yHLOlGgqNRrJgIqJjIzbFAH0+nm4bhodQWXLtojJwtMqRlNXvrOaJVtrKtroTaRESZYcQrf8mP9jb2w3xP/yP7j5MtBTVIC0a43cp1/2v0BSXpTfSfivh3vBYG5Lt5hMO802DaPr7+06U/in/ecpU9AKMHVEac6cyQ+tltjmKjf2/HX+5/U+lJjVfHafT7Eg7Ri5+3xRf0S8X6QOSeYtcHWlqJFdwal+dC85X5yZGCvkGXYi37ReK6+WV2BGICSzget3PvwGSuAro2kJSWPzB0RXsU2XpZiC+f5x8sUEfzkqlWZRG2w9GH7th8CpBNcvNH5IBjo1FsZ09DsU8oVs+v3C+xkvEluStf9Vce4VCMOzX8Ib3DLbbaNfINHQkQqX9w0WdMUbOJBn6dYXlsHJZ5wuyEfij29/lrYP+OI4SyPDNiiFg9hbHDxKj2V+mizDR7zHXGAdgBk8ZbuS9aLaI48moVdCUwlWtHQi5JXxK4WxYPUNmXvZogvRVVwsSvv/e2FBNxJs1InxTNXVXXXZL8i2r/F0F0OkhAYUyWbr8lBbY7WCI+cgSLbl2daIF1E7C9MJZVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(54906003)(110136005)(52116002)(38350700002)(38100700002)(6506007)(5660300002)(7406005)(7416002)(7366002)(44832011)(8936002)(4326008)(8676002)(66946007)(66556008)(6666004)(66476007)(1076003)(186003)(316002)(26005)(33656002)(9686003)(6512007)(33716001)(86362001)(508600001)(6486002)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gVOkTTR6xpGrdGlyWITM5oCu8kBDxsu9KLRdsRN3/c/9FAw8dFrjfNC+NTeZ?=
 =?us-ascii?Q?ElNqDTz1UsJlN1CVPP3oWcz4lRK/ZV9ugq9o4Fg8Mp3gsyza3R3knyPMsJTN?=
 =?us-ascii?Q?wYopk/TqJSTSx3DPCwUjTlVr20eVjDXCV3fkCFzkefV/RtmdCEmUoBab2EmC?=
 =?us-ascii?Q?SNKxm6yr0d1j/ZhP/KmGbrHv4rqt8Hufz6vOYJqsEguYWiM8RBVBEts5LGJ5?=
 =?us-ascii?Q?4LLcMyuCIvb4FP/xY1s1nKs58qHir3yNKyIZ7ZA2mRmNLGdf7/kS+YFXldhQ?=
 =?us-ascii?Q?oMNOp83kiDVQ6XJHM0kru+qoiPJdpyxabCItHzxMGrtSewIolnlmArNXMFQk?=
 =?us-ascii?Q?wXojxF5LTwqM/Gd7D2GfdyjdGmxPUhiy3bySb0q4s95d96YJrEvVJPqdOq5C?=
 =?us-ascii?Q?xYyCL2LeiUYyjA8aFbbB54q7ba8ENliBFpRDEzeV5nL4OSDc1/yXzxIbdgOW?=
 =?us-ascii?Q?nbKRsVW05Q7ilLGgEt91Vw0+gyhQFxl37npLgcG5/Idp4mkTX9RYv1rc31Il?=
 =?us-ascii?Q?GdUcAuwhTgpWUTmVVKQuBJ3exnZuMbLknLvWt8bVXu/E7T1eVnrMWz+7p69o?=
 =?us-ascii?Q?Nupnh6/a7OJTzhXTh0zc+b+LO1618B86q3IFatmjORHmVSSYcTQX+BaHgkz6?=
 =?us-ascii?Q?Z4ePcfRx0BBUlBKD6NnLMfZBVfEADQxGVlGNL9oBWkmjnpaEVgVyrBL+4LvR?=
 =?us-ascii?Q?29U7Q6SElqlBiEYuq9W5FMIPAchwcdb1BDbpMzX+2sCEfy7ipV85kUynp6Q5?=
 =?us-ascii?Q?rvyYk1hizQpM41ba5G4OvUz18n6gWIQih+iHAlNj4KDXKuRE9bFMk+ECwnsf?=
 =?us-ascii?Q?w5DO76VH3NBH2BxD2ghUXiWvDLu1QikMYUD3OE02FqCSThc0Q0uW/nJwKPGp?=
 =?us-ascii?Q?O475hNIrLjWFDCqf0mk0yeWdsUpwqFaLxg2g4rvDiMIWB/pKsckGBWi2O4qY?=
 =?us-ascii?Q?fN7DdSAqpQJNHEyvUhhvwXWKR/WyKWlKnZsUWy4yy/I80WHJbxWG8mOKug3C?=
 =?us-ascii?Q?83La+pDVy9CTz8SY4h3A+4/WFN9giEtFHnrZ9Cf69di/34UIGV6eCN6TjpHl?=
 =?us-ascii?Q?PHSbJNdWiPIRAb6fuLehs3KCsu5QTxh53PyL8itFzaXwekOBj2KUsDg4FkaS?=
 =?us-ascii?Q?kH7AruCroWMawD45uQpfJn8O60DW9LOW/BacRdMq0d5EMV+097O1L/DdnrJS?=
 =?us-ascii?Q?N2ZSko7cNuk3h3MCZ3UXaLkRYojb2b48ulAs4LdAJT4XU4hGlwXa01gZuWe7?=
 =?us-ascii?Q?PlBlXKcWUunyKP9usBpsDhXLzHHGHk/Cda99qPs2Gf/jGmVUJwUDyZf8kOTy?=
 =?us-ascii?Q?R49t0QNY/f4iZOVBdx6wjrbelXoT5azu3TqnBZEbOe1AQyaURnZjY3ycZlPT?=
 =?us-ascii?Q?1nJxamfcQsJrSzl5cqleNix8EG/r7yvj6TJGba9lsiAsQ0AaglC43jUoceH2?=
 =?us-ascii?Q?yUOTfcn+MiwPC3U4CZXo+W1MrFyjWg4xSa5wCWdJLRU9Cqbr4xZetFBB6MFi?=
 =?us-ascii?Q?w2Wu25dgFpB3ZY7m5JIJcOFVP8E1FYS7cbvZDHUdaSRgRk8rDtcXf3vI03hL?=
 =?us-ascii?Q?W8QkK+S0noSv+bEZTkhHxs5d5ivtGLwRHq+2NJzkUXjJ94aAVAYTdx1gAo7L?=
 =?us-ascii?Q?JPi9Drg/LCFzp26G20BXWiu/lQvmjIShGU6QOiwpU43aUI6R+DQfAOIhzK+8?=
 =?us-ascii?Q?k/ISWw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d04b1c4-80ed-4317-daaa-08d9fd047fc1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 10:56:41.9430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPDi8DvjeNmVG5VrNmrgZObtinCjgAlYAcblfQD7gsHfzrr+ELLr5NvI+TzVTqGKnpedht3O1TZtY5lwfa8bVVbyF2s18KDdH71oBwb2src=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3961
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203030052
X-Proofpoint-GUID: E_w17a3Sulx6s3qCnsIjoi2s4f-f83nv
X-Proofpoint-ORIG-GUID: E_w17a3Sulx6s3qCnsIjoi2s4f-f83nv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:29:31AM +0100, Rasmus Villemoes wrote:
> This won't help the current issue (because it doesn't exist and might
> never), but just in case some compiler people are listening, I'd like to
> have some sort of way to tell the compiler "treat this variable as
> uninitialized from here on". So one could do
> 
> #define kfree(p) do { __kfree(p); __magic_uninit(p); } while (0)
> 

I think this is a good idea.

Smatch can already find all the iterator used outside the loop bugs that
Jakob did with a manageably small number of false positives.  The
problems are that:
1) It would be better to find it in the compile stage instead of later.
2) I hadn't published that check.  Will do shortly.
3) A couple weeks back I noticed that the list_for_each_entry() check
   was no longer working.  Fixed now.
4) Smatch was only looking at cases which dereferenced the iterator and
   not checks for NULL.  I will test the fix for that tonight.
5) Smatch is broken on PowerPC.

Coccinelle also has checks for iterator used outside the loop.
Coccinelle had these checks before Smatch did.  I copied Julia's idea.

If your annotation was added to GCC it would solve all those problems.

But it's kind of awkward that we can't annotate kfree() directly
instead of creating the kfree() macro.  And there are lots of other
functions which free things so you'd have to create a ton of macros
like:

#define gr_free_dma_desc(a, b) do { __gr_free_dma_desc(a, b); __magic_uninit(b); } while (0)

And then there are functions which free a struct member:

void free_bar(struct foo *p) { kfree(p->bar); }

Or functions which free a container_of().

Smatch is more evolved than designed but what I do these days is use $0,
$1, $2 to represent the parameters.  So you can say a function frees
$0->bar.  For container_of() then is "(168<~$0)->bar" which means 168
bytes from $0.  Returns are parameter -1 so I guess it would be $(-1),
but as I said Smatch evolved so right now places that talk about
returned values use a different format.

What you could do is just make a parseable table next to the function
definition with all the information.  Then you would use a Perl script
to automatically generate a Coccinelle check to warn about use after
frees.

diff --git a/mm/slab.c b/mm/slab.c
index ddf5737c63d9..c9dffa5c40a2 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3771,6 +3771,9 @@ EXPORT_SYMBOL(kmem_cache_free_bulk);
  *
  * Don't free memory not originally allocated by kmalloc()
  * or you will run into trouble.
+ *
+ * CHECKER information
+ * frees: $0
  */
 void kfree(const void *objp)
 {

regards,
dan carpenter

