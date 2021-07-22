Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513E53D2381
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhGVMFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:05:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54698 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231738AbhGVMFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:05:33 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MCfaNO010339;
        Thu, 22 Jul 2021 12:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xUeKHGetoRu815Zw3b2lp6PAAQ/RvUKnO082ED0VeNA=;
 b=Hy4t3NNuwVAi1qM9xlZYMmxj5t8VK2XwRntw8v+xrFhSz6CjbE75ZBgjpU6/wwgNvMp6
 Nu7naKfe9iaaBIa3HvpYM672t6Jad1a4xkwmcjHixAFkLosjvoGtM+h1aweBXdm+rbCj
 Pz4ln6JPwlQffxHGYEmv+dHCQLBwpwPd2fmf4QpBb0laCcrk0iI3afhcueHUuwPhJdAU
 bAyZQWkZBZbC0IS26YHRy/YT7+BF4U2q66Dm5yaV+R3faXpdHqUeAzi6OJaRffE9KENH
 yQ1ChkN4vbtJlEddmm7hO6/SDuqqFqn+fM8OmTXaGuRUiXgic1IW2oOM4k/EpdqrtlZT bw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xUeKHGetoRu815Zw3b2lp6PAAQ/RvUKnO082ED0VeNA=;
 b=NpxcnfYwmw2cyS+moPOGrIFxG6+LzhucFsynUlGJgZ2cp/4HGY4KK5BuTO7k8zEa8nHx
 uYI/bAyMccZyLI5J4rtPFvUmVMGpXkt/l4IaP+sE3uGn3KpJRbh9mWlMA4SNfSjIv/ra
 8RxEfI2kKOEPpcKO370Vro9zOZdZU67t1NQzjIdAA1sxUCUYfqEGSDm+Yg6LnLI+lwSQ
 5HXxvQfjf7j+2XDdvksanASyGUFF6AnMeAJfeTvmDkYRWqOhYvAFQHt49Mr2HpqbZSje
 YgNq2lHJq927DNkacl3U4YtwTix5NBzn4hfspaykRZc1Civ2v73ZY6saogqI0IuuVayE wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39xc6bug9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 12:45:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MCeVe2163392;
        Thu, 22 Jul 2021 12:45:41 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by userp3020.oracle.com with ESMTP id 39v900ghxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 12:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+kPm4TAgsA/jtkk9Yvq0rz2DLGXMwRVhwk+27+D/PI1Mz8xKCQI5/rraW3AZOk+CadGn26HUJaYg8jgOR7bqhmkKOWSYXAy9D67ytY78CRET4kOOLanHT3CUk1xIde0/NgmKQmMT/kdrb+zRsZpsR7yjwQG72pOqoG8EIvg9IXWxbhhatJ7OMFWtA5nNW+XvjODfeMCyFlnMy644eaItJD6JaY5lZZ7CpnTzxqV7fesOvlSPINQp3EB8YZ1711jUfay96Kgzgd1+wmhnXr1f6hXBWPiuEgLivBR/+vlf76PXdUEZLzk1BCVztDXsVm4RgO5B7vz8rBmI7hJY+QXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUeKHGetoRu815Zw3b2lp6PAAQ/RvUKnO082ED0VeNA=;
 b=Ktfh253GzAVnnSQjjo5UvyYn8klr08Jo4Yh7vI7btphBb2cVcjO3Lj6H7vc7NgsIIpNKJW1Br2r36Kc1B6IUEPPpvy2kTALr0UuAiidc6Kty3aAU32zW5d998ADquJTpoQ7ns9Bj24pz1rsKS7OSmLMBs3+06Z179t87NWhrzsRqnFnlrXbjoiUC89IfZYJDqcyE4s6yG7ugqzxbekh6Mowd3+qu48SYl7D0yxcpzM5c4sOZfTlbg2pXbLTnaO6tsjWYqMqPpw7eY37GeK+G0fD/HqcbaFGOm0qflkTs922gi6szXN3te89iiT+MLIRAWInuTyhzs4AdzBnpDZwTyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUeKHGetoRu815Zw3b2lp6PAAQ/RvUKnO082ED0VeNA=;
 b=a+rly16K41Z+tPq6Lh1XxD8Yc0JvAk2xgbXopr2P/AEBSCj8tg+xQA+OIsK2LEDOj9o3s/w1HfUZqvETcMFbxH6Aitmmu/7fS2N9KYQiP5xm4ZVLxmSS+Vw1VLt/8YZo2qaegHKXDajD6FPryQ47VHID7HpIPbmWr0+op8ECe5k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3278.namprd10.prod.outlook.com (2603:10b6:208:12a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 22 Jul
 2021 12:45:38 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 12:45:38 +0000
Date:   Thu, 22 Jul 2021 13:45:28 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Jiri Olsa <jolsa@redhat.com>
cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf-next 0/3] libbpf: Export bpf_program__attach_kprobe_opts
 function
In-Reply-To: <20210721215810.889975-1-jolsa@kernel.org>
Message-ID: <alpine.LRH.2.23.451.2107221343330.13227@localhost>
References: <20210721215810.889975-1-jolsa@kernel.org>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LNXP123CA0002.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::14) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a02:6900:8208:1848::16ae) by LNXP123CA0002.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 12:45:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62e1567f-1f32-4981-29f1-08d94d0e9b3d
X-MS-TrafficTypeDiagnostic: MN2PR10MB3278:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB327861DFA9B4D9F3C0848556EFE49@MN2PR10MB3278.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eAMEMq51TtM7Df903EOXUZ4cKmQCXIgWMxPgd3U1D+A9b3it3Lv0zgcckAG4H0QfZnt92S1tQbtZOMti5jYwTOaDsN5Cp3i0XmDMv2cKhs1o0YdChRksa+btoDacXld4RDQZxO582FI0j1tPiHuNMhxGleQKHT6o2OIlf7x6qyHjrLQa+OaITDmBltLcSGquWKyhQB+DE/jrcIiWgayov0szKD7b/IOhqiJPza7Ribli3W22eUeS2dHbRyWg1L6AHfYj7zZMfwzO46pXlC1g0RjzxIdf4n2e0CCxO/3VFRv29nJ09yM+vKW1FUrBjUVPFpB8pD5Zs4vpRtzJsEZkEMSTcJrMF3o1igZANnGyndoahScVLg0W4KcKumyrIPqdmeLxJn/sZiBEwpWXtehG1fUDMC4ifTMRgfH9045piItbT0c4AUL7RyNd5TvnZCJkT0+VtRzwIeNyW8aRsDJDbMc/fcpGqM14pV/5ZidgcRd4vWEcDgT1yZrJgxzWKdF9iN6YrQ7Cmc4mMlyQAxIlWhe1zq04XlVuXTZht6jVH41IqLWKCGK3vzkxtKyTi13gMFRzno9me0mmVLUicuVJeOzj6HaY6dBktCuB92t6YjYatvjUg7xg+NH9GeijrjLvj/MB/w7aKidX8s5oPf5h4Vfc9ZDc0WdhxXZdui9KtlEoBUAPk4HFY4ZGvZNQjf8f4f1wIh7ktzOSJneyUNIB7mkIFKf4EB+mUx+rPCerk6Kssn1dmsuRfrNQ7AM41TJ/+JA7WHlKvoTifIyX3uCPedKS3ysLi4Tf9rOV5uD6JdmzuFqjSSmDwUKcTamET+uAEoKE9DOmZwYfbYUJvTFVfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(83380400001)(86362001)(6506007)(54906003)(66946007)(7416002)(2906002)(316002)(508600001)(9686003)(966005)(6512007)(5660300002)(66476007)(52116002)(6666004)(66556008)(6916009)(107886003)(9576002)(4326008)(38100700002)(6486002)(44832011)(8936002)(33716001)(8676002)(101420200003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GWQFca2ajsxUliBk84G0YOkvSE6Rnw2oCcbC/PMgoEd5JgvU0epBLs/QnIbT?=
 =?us-ascii?Q?pHG23dFH1+ixsnrZ3t9iyXAUbM00bib2gYd0MVdRP8hxWDpUX2lp4llknRV0?=
 =?us-ascii?Q?gUGbioXajwyiyMGZLwHOc0szJlA00KG65TX11UOYJvVtQUJR9pcifgYXVJwi?=
 =?us-ascii?Q?dkzs8Nb4YB7OOnnbuPbKgWxosc9u4VxTjq0OK5Q6eniab1L5E2yPJ9ijryJL?=
 =?us-ascii?Q?NIYEOP5Ef8mEYmlxQzWVynpAoT486JgEukDwoDgUuNIp0d4BcMb4Cq5TH2Df?=
 =?us-ascii?Q?x/W4ifhnvOGEiRpUjVsLtdkxIlZfEYxM3XoRCvimFuSiIY9+yY5wEV3iqAt5?=
 =?us-ascii?Q?UDz7ItvEefsTnpNlCYDY9j5eXYQyjjtd0J1pEwcgrbwUP4VtZFQJhxFho11A?=
 =?us-ascii?Q?PJMKR1dIgAiN7JTCwMT+Lhra4/KTH5stG3qer8XuZ8AjnKyQCIj/BlZp1afn?=
 =?us-ascii?Q?W4o+NZ3+XaKvcpx45sc2JO6IGwvK44UKwvz6R0kBIsJuLzK5Eb+nAYnWAC0J?=
 =?us-ascii?Q?P3LWRqn33kID6RzJvh5Sc7Y3agRepl7Sb3jqk4E9sUaC1jWXA3IPY31QutVe?=
 =?us-ascii?Q?D8s8ygQFxm9GkWGTUBDVsp4+dyqVN7ABrAn+FrAr9dGaY6qrz/GKTz/hzn1e?=
 =?us-ascii?Q?KuKbHGRUJWhsO4RfNLUfbyEto5R368iRZOlaed143xiYkyOfylLZ0zjfukdo?=
 =?us-ascii?Q?fRApXa82uPfPwCOWzA5Cj8lpjrQkYi01os3ttxpg4tGMF/eEgw5zwogizopS?=
 =?us-ascii?Q?p3AYc7BMH/AtNcIfeUZHFq55tR8DOeKBmfcpIPf/2GGUS1g5FCxIg5ib7NMR?=
 =?us-ascii?Q?L+XJkbcS0anm9z5JZc+wD5iwdpbNRFByG4jn10HWRO/DyLZ/gOyofpoFWX4J?=
 =?us-ascii?Q?UZE1w3e3m1U5okXe66jfon3YI8vbvuMtZwp/hbqMvzgt0/AmDgSve/8hrDgb?=
 =?us-ascii?Q?S4ixI+0TqjnYMltLsu/2gLryFbRCRIw1MijJxdNEZRStlLutLJaNXcIGRBEb?=
 =?us-ascii?Q?01xc3Z6kMZaRuu6GC9iaeUuwB7VfjNTRDAUpLi05FqjsvIRRBFFsWo8+pLSg?=
 =?us-ascii?Q?N1P6cc9sRKszblGK2mZJBPfJYOuFza5xB4WtP+rxnRdCuOrjyfGMoUFpP22G?=
 =?us-ascii?Q?2gCN6LkHq/jJLBVyiVNZ9t4tt8nhpBk3q7bhBNeRfW8Dqo0FX+F9bbH1LYL7?=
 =?us-ascii?Q?48+DLJmsyYh/levzjqzB2rodqYa0M5w1f/aKd3wNvfntvJINBm+DiprjRTvm?=
 =?us-ascii?Q?J3QT3EJ82gOHeg46vkOYAa/Gpp/M2u3RbpoLBclXq7Xx7aUQzobTskrGN4LH?=
 =?us-ascii?Q?FCLZNq2Nt0/roGKuyPkjcVA5u33yz7sJr3KS/mwJQdVTcg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e1567f-1f32-4981-29f1-08d94d0e9b3d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 12:45:38.2309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxq2jBq4hWnh8EnWw7hPvvr4EzCoV0q2xbMYAA1YNOMpbikd4mhlGvWPQuJXFZwV2/ZmxZ2tT+Wp8ygjcwV1LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3278
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220084
X-Proofpoint-GUID: gPaOBGBrw-MMrzHNXgEpThAKpLopdrZM
X-Proofpoint-ORIG-GUID: gPaOBGBrw-MMrzHNXgEpThAKpLopdrZM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 21 Jul 2021, Jiri Olsa wrote:

> hi,
> making bpf_program__attach_kprobe_opts function exported,
> and other fixes suggested by Andrii in recent review [1][2].
>

Looks great! Feel free to add 

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Tested-by: Alan Maguire <alan.maguire@oracle.com>

> thanks,
> jirka
> 
> 
> [1] https://lore.kernel.org/bpf/CAEf4BzYELMgTv_RhW7qWNgOYc_mCyh8-VX0FUYabi_TU3OiGKw@mail.gmail.com/
> [2] https://lore.kernel.org/bpf/CAEf4Bzbk-nyenpc86jtEShset_ZSkapvpy3fG2gYKZEOY7uAQg@mail.gmail.com/
> 
> ---
> Jiri Olsa (3):
>       libbpf: Fix func leak in attach_kprobe
>       libbpf: Allow decimal offset for kprobes
>       libbpf: Export bpf_program__attach_kprobe_opts function
> 
>  tools/lib/bpf/libbpf.c                                    | 34 +++++++++++++++++++---------------
>  tools/lib/bpf/libbpf.h                                    | 14 ++++++++++++++
>  tools/lib/bpf/libbpf.map                                  |  1 +
>  tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c |  2 ++
>  tools/testing/selftests/bpf/progs/get_func_ip_test.c      | 11 +++++++++++
>  5 files changed, 47 insertions(+), 15 deletions(-)
> 
> 
