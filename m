Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3253D7C52
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhG0Rhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:37:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37606 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229529AbhG0Rha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:37:30 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RHP8Ls027435;
        Tue, 27 Jul 2021 10:37:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fCOzlK6gUONyiYZRryjNvEe/YOZfSNdJ11YwjbQDskg=;
 b=MSOWJfskxjGCfwfB/zr2f/T69et0lr1drO3+HRifwIdPhfJInPtv4CXNrXnuQp4TetFL
 ZaIyc6r71f9uYs8e21Hk3NLxyxCMlgMu1zyNzaPgrBdkD/gOoewrWXqpP67Jx3dz+Y7b
 tWamxwus0aIzGiyM6r4LoMrBG1dvT2jiVcg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a235heqxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Jul 2021 10:37:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 10:37:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5KRRREhGG0tLEMznXUAGCWx7kIp10hHbJ5iIGCJ2C1ShdT5edx/5gqu9OCGVMlVS+0cDCXP1OulHIzlN+0F319HbPq5ho9Rer8rOpsUM36U4rs0EbNm0AkWoEVZMM4oPWvFxhHJir7Z1Fr9bjLWkh7sLnOzIX32bUjVw6/maAa86AQYbm5TBwrO/2tvU1ZzO0QNssybhjvTjmzSwiKv2OynaWhnF6F5FCutsYCTK/+PPfv6REBFgfGjsfYn/BB+pn+GBA02vC+Jo79IbbSiBFWN9oPeOsDZcRJf3DkIGwq+eV+fcy9HC/wV0styAwyhtfZ/oBm6rRYUjBb4LU7NOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCOzlK6gUONyiYZRryjNvEe/YOZfSNdJ11YwjbQDskg=;
 b=huJHRnRZhgFeORHxe0db55ynpX+ID3lmTPkTzMNZN7b5yTIfpUcBBLrRw4zRweMBfasg9exc7ACLVTWvc43kzT8F0wEt/RPJR3IXMuKYzLAbv8jjU6FEeQtFSxvRCSGqxSq1RAj+/ydmtVtSeSrzX8dWTDotSPCRM8T2R8p4A+ZM/+yIb6N3H/dz/eeROGakMzf2G2a2sh5QZwdDKIas/Uf6QXfLUMwXk7i+XjgKjbCfs2nPE1v8eYHKOv3fM78YjgPxEI3NmGa+HUQ2iI9xjG8wFlzamgqxUsEtCmZn5B6nZbIy4PKxle7kPm0mzG1J34/O80tmj8TTpkg+md2Dgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB2016.namprd15.prod.outlook.com (2603:10b6:805:8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 17:37:15 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 17:37:15 +0000
Date:   Tue, 27 Jul 2021 10:37:13 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>,
        <xiyou.wangcong@gmail.com>, <alexei.starovoitov@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v3 0/3] sockmap fixes picked up by stress tests
Message-ID: <20210727173713.qm24aiwli2bacrlm@kafai-mbp.dhcp.thefacebook.com>
References: <20210727160500.1713554-1-john.fastabend@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210727160500.1713554-1-john.fastabend@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0123.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::8) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75d7) by SJ0PR13CA0123.namprd13.prod.outlook.com (2603:10b6:a03:2c6::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.15 via Frontend Transport; Tue, 27 Jul 2021 17:37:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c680c43-ab99-48eb-f707-08d951252ca6
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2016:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB201681086F810614681B79A6D5E99@SN6PR1501MB2016.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4je6INrMbtIyaK1YTUgWZ84K2mgZiRCRpbIUYNyID3u6mBUw/5iEX11Ykq0xSOF9FP8auNEXH2CeZsZ0qjPlnJZY4blRdaVY/Y9O+zIPkcg23ej4K4RrDdH37DoYDqv1gR8EFicqe7ralfl6vgRy+I88ND1DfYqB5D7FnLlconyNHxJou+ZAd7I5XK7/Jcji4MWNztWtr6uNkYhctWWiyCSa6Z0dDksr6SPKeHCW2zFWC8aVNSsxjcP9XHUCTOqfsZYaZtj1hzAUwEA45QjD0aWsY1Kt31CqxwTOo812UUBn6sSwLeDB74NuLXFy6eTMI2/mfWBrt4kLnP78Q/VjleNLBTubtcaSVlfw0Sc6Xv9QoFvutqNyAwWnDOMhEd8oXrLyZBtfJ440niG35ZuqYqVy/8Nd60M2RJpsHnr8irOBIt436HzEAb74QhXfESvzjzALKZRV9lHQIqWRoxmXu/PO8GsyzZqeaelvGFd2H3RCZqXcFCiiokICc5k8Z7iqnW7xENrCtkRj7DrGbEdHpgARJhgqK18HRPJzXEjQbFCRF8JB8KEkktIPIZhr2CJApSCaMPY7K5e/T2KsbJ9i9izpbxje34HZvKZn+PD4A+IFbBQNrHd2bIhnOXrjFXK1M9wPpAMH1s9nD4elEzfZ45f/UoHvwvnZdjgrQqwOH5qMNgkoIQzASXLUUQo7BflM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(52116002)(7696005)(83380400001)(316002)(4326008)(55016002)(186003)(5660300002)(8676002)(9686003)(86362001)(38100700002)(6506007)(8936002)(6916009)(478600001)(66946007)(45080400002)(1076003)(66556008)(66476007)(2906002)(473944003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sHOmiQtjhGeajLBusIq/sagvCMNsGWZz2m+T3035H88IFWqkrkxh1O0hHM15?=
 =?us-ascii?Q?9hpqgfYhcS6S1ZBgkvQsjqlHxfg7fawS5jU2cSB71fSaxKcFQLjLw8R3mJqg?=
 =?us-ascii?Q?C+pIPTBOrcbD6wuP0UqzkYOcbtLSG9/wg2PFzo+6oMnKAZCceasWj0gwBFMb?=
 =?us-ascii?Q?r8nW7p/Ilb/9Pq8+np6tZToy4PbcCemT3DvA9PzfHOarAuswxR/32pduEz6m?=
 =?us-ascii?Q?6BwsrDRZ3J/Qk5+oWP4sPr3ll1yma2lIt2FyjSTImkMWualc2vPd0IMYFJez?=
 =?us-ascii?Q?b9nRzk0d0t9iPEb3woN+AkEA7SjFvgHNIQwaq4NCZiEuo7FAB+uqM2+Q5xRy?=
 =?us-ascii?Q?gzUbZQ45M132Iblp6mzC3oJ32WEUV+xA6K4d9NQRsMtlx7qzfK3hArJqfn/4?=
 =?us-ascii?Q?togv9aD5ymSc7W4PCS9B1DV4u0Me6dx9e2IyKnqGK9QViL1tHyC0LJQFBBxd?=
 =?us-ascii?Q?/Tq5QTwVAa7jif950NzlZqGEKA7NLbjRYYbQWEBEsowLJXPIiF1ii+tKNjp7?=
 =?us-ascii?Q?heKRS99cHcNeY1+77yUOaLW5Ie/k4Xh+SO7HIOaw1EbVZ8hl5XaI46TdAF5G?=
 =?us-ascii?Q?7G2tZXsO74+Y4QH1BOWNEUVnLq2SV7xzF5rx07aJDJ/MfCpscvvk2iHy53RP?=
 =?us-ascii?Q?mMA9Ci09JnCpbgKRtqFGd73RxcKga7CNHkMoInaMLeZrv3XohirC9CJWllbK?=
 =?us-ascii?Q?KR6bwNjN8fdLOorJLhMrgx+fd6Nx2afeiw6K0E7hmLE7JFkDhpplEe2KCP4Q?=
 =?us-ascii?Q?XfiFsIEUXpmcahAvHH+JLLM+BILMAOco/dgijdcMqGfsEFGM9Zy4U66U78zd?=
 =?us-ascii?Q?1LjcbZU755kIhwppLC+0XIMN6VGTPsHO8vkevhaCljyqooTaC7ovdFZeP0EN?=
 =?us-ascii?Q?haK9XQtlA5l3M+jK9vvxnBfRjkrAMjZJg8qEMSicVJqh/vTasWookrTJa9hn?=
 =?us-ascii?Q?Avmrk7LjesmTu9TGpK/eT828x9iZc6JOBwjQfScw8PvADP3wCpfDjOXgOrm8?=
 =?us-ascii?Q?UpJz2pT8cJyrL+D26THHywyo6VKK/5uCCOo5f8/TMZvl/y+e4PRRQKCd2nnw?=
 =?us-ascii?Q?rvhte1xnIdhzqGiqBdQ/uy4AucZdzjzJ8dQIRITavBJywBVv7zI9iHF1efxQ?=
 =?us-ascii?Q?ycqHo+3mVIN0GZVNRCtzpQtFK2UYNjMh1gYqBGE6RAV7m2GKrHhQYNKoR8ou?=
 =?us-ascii?Q?8aHut077BJxDjQl9/nDegzuO1OpmhBSYFRDfpHsJJagrvbp0mWuX1DxhRDjr?=
 =?us-ascii?Q?fqHGjJzNKRTIHeQRx98JOXXM+tcFLN9qVf22tKPSROmIz1pzNaK+w9DqsH5D?=
 =?us-ascii?Q?zQbRvDxO0ebqVE01OTb98rbfMRhAsGz39z95S2OfzVSMTQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c680c43-ab99-48eb-f707-08d951252ca6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 17:37:15.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGbhpuoBzXug9awT63V7ONS/+YAw84tN+G4QrplFUzuGPyygmsaYq2AbvKpoxY8U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2016
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: pXlIFiUkanfNe2YztHVYM5IqbQpzVTry
X-Proofpoint-ORIG-GUID: pXlIFiUkanfNe2YztHVYM5IqbQpzVTry
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_10:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 09:04:57AM -0700, John Fastabend wrote:
> Running stress tests with recent patch to remove an extra lock in sockmap
> resulted in a couple new issues popping up. It seems only one of them
> is actually related to the patch:
> 
> 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> 
> The other two issues had existed long before, but I guess the timing
> with the serialization we had before was too tight to get any of
> our tests or deployments to hit it.
> 
> With attached series stress testing sockmap+TCP with workloads that
> create lots of short-lived connections no more splats like below were
> seen on upstream bpf branch.
> 
> [224913.935822] WARNING: CPU: 3 PID: 32100 at net/core/stream.c:208 sk_stream_kill_queues+0x212/0x220
> [224913.935841] Modules linked in: fuse overlay bpf_preload x86_pkg_temp_thermal intel_uncore wmi_bmof squashfs sch_fq_codel efivarfs ip_tables x_tables uas xhci_pci ixgbe mdio xfrm_algo xhci_hcd wmi
> [224913.935897] CPU: 3 PID: 32100 Comm: fgs-bench Tainted: G          I       5.14.0-rc1alu+ #181
> [224913.935908] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
> [224913.935914] RIP: 0010:sk_stream_kill_queues+0x212/0x220
> [224913.935923] Code: 8b 83 20 02 00 00 85 c0 75 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 df e8 2b 11 fe ff eb c3 0f 0b e9 7c ff ff ff 0f 0b eb ce <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 90 0f 1f 44 00 00 41 57 41
> [224913.935932] RSP: 0018:ffff88816271fd38 EFLAGS: 00010206
> [224913.935941] RAX: 0000000000000ae8 RBX: ffff88815acd5240 RCX: dffffc0000000000
> [224913.935948] RDX: 0000000000000003 RSI: 0000000000000ae8 RDI: ffff88815acd5460
> [224913.935954] RBP: ffff88815acd5460 R08: ffffffff955c0ae8 R09: fffffbfff2e6f543
> [224913.935961] R10: ffffffff9737aa17 R11: fffffbfff2e6f542 R12: ffff88815acd5390
> [224913.935967] R13: ffff88815acd5480 R14: ffffffff98d0c080 R15: ffffffff96267500
> [224913.935974] FS:  00007f86e6bd1700(0000) GS:ffff888451cc0000(0000) knlGS:0000000000000000
> [224913.935981] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [224913.935988] CR2: 000000c0008eb000 CR3: 00000001020e0005 CR4: 00000000003706e0
> [224913.935994] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [224913.936000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [224913.936007] Call Trace:
> [224913.936016]  inet_csk_destroy_sock+0xba/0x1f0
> [224913.936033]  __tcp_close+0x620/0x790
> [224913.936047]  tcp_close+0x20/0x80
> [224913.936056]  inet_release+0x8f/0xf0
> [224913.936070]  __sock_release+0x72/0x120
> 
> v3: make sock_drop inline in skmsg.h
> v2: init skb to null and fix a space/tab issue. Added Jakub's acks.
Acked-by: Martin KaFai Lau <kafai@fb.com>
