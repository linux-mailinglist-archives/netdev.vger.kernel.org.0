Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BBB41B669
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 20:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbhI1Sfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 14:35:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3932 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242262AbhI1SfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 14:35:13 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SINM3I013912;
        Tue, 28 Sep 2021 11:33:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=182SUEXqGKaKMStkfEzVnnutjNtFtpsNWkhgccse+6s=;
 b=Ov3meO2GV503XmRpgZM04ATbaeVeETxc8QlL39h4dA6Tl7erkk7wwrgr5JhMiv2Cx+xm
 FwMMqLZJXrLQAsNdQ41lPZFyztu+QhwOFJPyaIC96noiiJxbPl832k9oZt3SjZgfiTln
 JVv6pUuqua8BcAiGcY3jMV72ifNaOw3r4ws= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bbq81y2c5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Sep 2021 11:33:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 28 Sep 2021 11:33:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrkmaFcRNxEYNzvk99F7f+TCraYqJsR+MnYGWZvDoS0TCMvySfz7tiO6RIBrJuD6PnZFmJasJxlwFbFFh6i9vht/xOVVABDc/92e2Cw4grHLGwRg3ugHTCxzQPizk/3/qbOhO3+Xst8EEa7KKvd7R8d1Hn1lkHVdAsfOGiwrgBjteo6v7rOtwgNSyMbY+1WPF58D1XwSxYWyvYAtCWe+7RnKbzsdvKVtbqHKcvyClpdfQH/9o0rM6q74cpZlkblyEx7zQNXDU9an4E1/MPxZJfyV4W7dTzEtSF9inVl28GBKFaEuSe13FBHFFi5thDuCcfpQ7l4endlRDaEFXPS/XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=182SUEXqGKaKMStkfEzVnnutjNtFtpsNWkhgccse+6s=;
 b=kpN6ibyxdhe5oSXnOgiKhMDQybxgZZDt7uHHzkk4DED1/A+X5nArTIiXkLc+vXs0eRo54dxaSripzfBg0whExfC8oX6ilPHRoeHLAdTilZvizjFCWYRf5bdFs19bCJ3azLgBHlucDmNKyBhwAbXfOent7Gcv62HQThJP2gcckW0WRj3b38S4ZAV/TPDSFiHKfXM+KK2fQFq2iwEW1zuEO/FsmdZWKHCAHEncHIMrQmYzFqjXZxb691lU3jfXoZwMv9L6ujCHLsoGcYnYTcdQ7J7qtZ4d/jQecmRGPwgmIrcs4Xv9w/7ZGKQO6zjmMHmbIkVCevND5ius+4hcqeu6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3854.namprd15.prod.outlook.com (2603:10b6:806:80::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 18:33:22 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 18:33:22 +0000
Date:   Tue, 28 Sep 2021 11:33:19 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: Question about the release of BPF_MAP_TYPE_STRUCT_OPS fd
Message-ID: <20210928183319.vd4q5ydqg6twasqj@kafai-mbp>
References: <a6ba3289-accd-051a-b27c-d90df0eb7cd2@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a6ba3289-accd-051a-b27c-d90df0eb7cd2@huawei.com>
X-ClientProxiedBy: SJ0PR13CA0109.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp (2620:10d:c090:400::5:711e) by SJ0PR13CA0109.namprd13.prod.outlook.com (2603:10b6:a03:2c5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Tue, 28 Sep 2021 18:33:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf9f1598-ede7-42c8-b46a-08d982ae734f
X-MS-TrafficTypeDiagnostic: SA0PR15MB3854:
X-Microsoft-Antispam-PRVS: <SA0PR15MB38545EB22148939AF236A91BD5A89@SA0PR15MB3854.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rx+BZZ49IlK24TfoOObs+Rp1f4ahDADpeMAsmN89ddSqMKP8VuRmVJ+PbyGpO2HgLVQj/9Qyydbtqtd2rU68dck7lkiviFtL5KB3+Qa68viVQEv4Ec8WMzXYhg358YlbPp8nac6xg6Zghb/QffTc4CGEckHy1dRVBweLll7luv2kFR1nopy+Svc1h6Se66SHTcbQUt3GD67b88zq+V3iytmVMT476SpPNApMb4KDwIzAJRbpAgEKtjPbl2eBei/2ZfFQJh3cah0/Mz76PfE3HCu/hnSsQ+Drak3wSoK8pvF47QddcklZISfAOFkl1jYqaEDMVavG5Qz/4lq9YCwL/bX+LFBDOCnL+f3xpWhNQDFAT6HViR27XclkXdFdDanITPH9Vk2abVeRHmbdWO1bKq83IVxRR0vS0ZEBdrfWw0xEsOgQD9xJPa2ztNyTWty5XvJc399YmoO84Bs/lAb4oSiVH6gm7JaN0ulGT16tAKVA/mq4F1VgSn+oi/dEuIsXnAUWAGqB5b9bH7lhJ2drCgG1zI32jZp6EbP6h8SpyI8o+TFmUFIXbGpVJohw9tXnitzzVR9Bcn3CYGf0D26j5khxKhCv7KZR+k4VNtsQyQq01Yjroz1YL7CXLCXK/Lb58a7hnmiwBLodk02qBIilTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(508600001)(55016002)(9686003)(38100700002)(186003)(52116002)(4326008)(1076003)(66556008)(2906002)(8676002)(6496006)(316002)(5660300002)(33716001)(66476007)(86362001)(6916009)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BNOMtC9g259ek+Nxoa52CTBHjiBIN134MRirrMy77ibszHL3pv4W9EfwhzRE?=
 =?us-ascii?Q?0CtB7NdkaPCtajiNF9xhmSxU02vco1LTjqR8aL4UioGvDXPFfZ7oYpTx+Kob?=
 =?us-ascii?Q?ecc+sy0NQ+Ey01bzWjVBEjub9+64+2kmXOn5YdahjZfeKYopidgHrTmObAP7?=
 =?us-ascii?Q?jYfjsPGhPccDzwCxxluHc7Yc1vwqeYoJJDk/+X2xKBEKShzSPag0fMBxkjrV?=
 =?us-ascii?Q?a1bp23A81n0Su2bXMEro9PWfT9rp8e8gPI9wg6urZB9jXDJttIQIu5hRUfxD?=
 =?us-ascii?Q?SZJG4S7I42dI2XWng3cXynH0H6pRk6PVpDw/G3Czu6HvIF7Bvt4UAyV3OE4u?=
 =?us-ascii?Q?9geVYwQlptslIE/mEvvhyjEwJeeSS26OrH22ZaAk3oprzC8z7S247UmDdOJD?=
 =?us-ascii?Q?k5jcwbtNEqFVo3kMmXlOBz54ax5YGCUbdsPPRjWh+/nkUlk8Czx2p9yC9b1G?=
 =?us-ascii?Q?Svog9n8LALX1Jnrc4LphVwaxA9AFp3VWy9SqfJFG7Ty5TBS/47szqYvViZIR?=
 =?us-ascii?Q?ct34ubQYnSmg4PBu0kMesKppVqBdK7Cl9ZSKsEn7tczcNim72+Xxj0NoKR9N?=
 =?us-ascii?Q?iDS2somBZdmsOFg8qWpHnU+bQ9InfpEl3TDdNbYDZp+mG2g8TCc9No5+EEsW?=
 =?us-ascii?Q?q+TcnnnHQiqB68EXvB1blNX5oWQGCaDvqnulEwWmmPgQyHxSJOnidyF02g3K?=
 =?us-ascii?Q?O9uMDWiGv1N8F3dG7TOGHIbqyJ6ri5kVWRPVbaejiIMGuy/vCiGmY4EBLRII?=
 =?us-ascii?Q?ytZw5qrJX3DfAyF6paXqfGsshngbZC4TgEKgDoW95j/mrjTBvzrH0G/kArdL?=
 =?us-ascii?Q?3XyrTYjkpsHIFULVWmhmmiw/8lwUYMrhd2IiNyNosYUMoU4r6Y5uBi5YNsHb?=
 =?us-ascii?Q?eCCzCzbXmqAy8W5NsS47rogNTUbjqHX+8105OMOLeZlc5y2FJ68EB7Bcj08D?=
 =?us-ascii?Q?e3zyhNQVxluPeLhFKueie+SQt5xaB8Trh2d59mEVNfuV6YZXyyWRLx0fQi1K?=
 =?us-ascii?Q?euGXVP6SNBUi1tLzSeldR22mKgU0hEcaGX5ntWgjHXqq8wNsApOprcKVq4GK?=
 =?us-ascii?Q?IxrmmkTMUKN+1HXvKjK6mSctHu+qrw/e2FUPS+BfZkGK+f54lNSUV36jKodC?=
 =?us-ascii?Q?rJ6KRwhr79tXNsMv1nDvahAwjU2Zxr2qramEeGTYxTaKzVc4fjK4+GoGsiwq?=
 =?us-ascii?Q?QL+J2/pEJEVbb6pv2BytDR8gDZtmMWJYMqZiVwoacnbB4NO8NDnYNB1t6cKW?=
 =?us-ascii?Q?Wc3lfO4Vna7OogH5j1038qkNy4kF/2vnOF8BIt3DV+VzhJ2ydsrEaCLbfEl9?=
 =?us-ascii?Q?qjinZkenIZqXx60Wx09gOl+FixFF2Z7j5VsU6fpgx5kqJw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9f1598-ede7-42c8-b46a-08d982ae734f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 18:33:22.1603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RhSaKlYk7JYFJnSslxj34pv5f0ja64KXftwg9YiqfuYJ3ajyGyBvxWK7ax+cx+qS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3854
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: tGZUMBWqDJNDETfpREOKGEY-TeN9PEPF
X-Proofpoint-GUID: tGZUMBWqDJNDETfpREOKGEY-TeN9PEPF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 adultscore=0
 malwarescore=0 mlxlogscore=713 spamscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 10:13:45PM +0800, Hou Tao wrote:
> Hi Martin,
> 
> During the testing of bpf_tcp_ca, I found that if the test program
> aborts before calling bpf_link__detach_struct_ops(), the registered
> bpf_dctcp will not be unregistered, and running bpf_tcp_ca test again
> will fail with -EEXIST error as shown below:
> 
> test_dctcp:PASS:bpf_dctcp__open_and_load 0 nsec
> test_dctcp:FAIL:bpf_map__attach_struct_ops unexpected error: -17
> 
> The root cause is that the release of BPF_MAP_TYPE_STRUCT_OPS fd
> neither put struct_ops programs in maps nor unregister the struct_ops
> from kernel. Was the implementation intentional, or was it an oversight ?
> If it is an oversight, I will post a patch to fix it.
The original use case for the struct_ops is to register and unregister
by command like "bpftool struct_ops (un)register" and then
the kernel sub-system (tcp here) owns it, instead of finding where the maps
may be pinned (could be in multiple locations).  More like the insmod/rmmod.

I think you meant to unregister it in ".map_release_uref"? but it will break
the existing contract above.  I believe a better way to do the auto-unreg
is to create a real bpf_link for struct_ops.  bpf_link has been added to
the xdp and cgroup attachments since then.  I did not give too much
thoughts on this yet.

What bpf-tcp-cc are you implementing
or it is for running the test_progs purpose only ?
