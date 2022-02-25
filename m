Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC754C4F5A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 21:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiBYUOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 15:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbiBYUOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 15:14:51 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8B21B84EC;
        Fri, 25 Feb 2022 12:14:18 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21PJLM6Q031817;
        Fri, 25 Feb 2022 12:14:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Mkxp6YHpjaTvN3+3i9nCTAWtmbGds2KtZYV7h3M+pTc=;
 b=K0gkZ3jF2REcdh6NDGPNvivdR40n/BeJ0+SYrfnAzgeL/z77GZrANHsapxz8wd0m31p8
 6Zl6Ar0MgczvFVFruk1ZShUK2gLZ5Jl8uDV1AfbSjdZPj01s4JzsLczmeEdmNSWnn/gj
 DaC8uvpB1uKSzyR57/EF5OeqC+C3vF4cOoE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ef4mngp2a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Feb 2022 12:14:03 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 12:14:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDdcppec+G7r6C971U5U4+Y2cxxCenmUWcvaHJipQDiYjraY67kCQpN58MdhITVkn8FqLlCEF8QNH0pGC2IRbX05Hj2hbMoJkDAE5N7ZtbYweDRLvk7FwYQgsFTMUGFjSX2Th6x+b0RkWXq/PQpYeO4+yfP21+zpj0QF2oUC46mP8Yg71HqtolQLafiJqD1d+yU0vDFp0k0jxEPKNsXGPQ46qg4SKhKXDLpdmsH1IvLeW4XxJP0pP75KdQ7Y2UMAVav7NeLg+Sd5Yu+qbOCxfdSjIV2a6QxlR+fSaVPOT7+cCdqQ4jKRTW2pw+O/QB2WzWQa6V9OznlRybGA3Ko8mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mkxp6YHpjaTvN3+3i9nCTAWtmbGds2KtZYV7h3M+pTc=;
 b=dtSdJ5X5OxJIXHtePvNAxt1tv/Pkk1/4v2GARIJLucvTCeMhiDj/gkFoA+Mdh+YSrqs7oyYwliOdmjVClvLmJcDAajyQFkI46iPN6Lik2g1kGCHuIlZndqxgQeZwKbUn01DITnPbT56L/bRsuqC0oPs/pQCN0nWO2z907zcn9h2GXdxschKd6R4eiFwGZ5hgEXohBhyxh4euYwu3Bbn7E3YPUX2J0PmZlAXWHu44JI3dgvXirteFaKTKdo6722pITpMORO4a/VL/Rfzo/qQfM8OXdgLDD6SBkd7LXauaGfUaxfEVL9c+8x/x2jKovKwIyUmpb/mfrSKeoS3CUtlE+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CY4PR15MB1701.namprd15.prod.outlook.com (2603:10b6:910:1d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Fri, 25 Feb
 2022 20:14:01 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%8]) with mapi id 15.20.5017.025; Fri, 25 Feb 2022
 20:14:01 +0000
Date:   Fri, 25 Feb 2022 12:13:57 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix error reporting from
 sock_fields programs
Message-ID: <20220225201357.anwrlqkzlztprujr@kafai-mbp>
References: <20220225184130.483208-1-jakub@cloudflare.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220225184130.483208-1-jakub@cloudflare.com>
X-ClientProxiedBy: MW4PR04CA0186.namprd04.prod.outlook.com
 (2603:10b6:303:86::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 753e43c2-7d97-417a-9fb6-08d9f89b5cc0
X-MS-TrafficTypeDiagnostic: CY4PR15MB1701:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB17019E64D83E26A36300040DD53E9@CY4PR15MB1701.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ka+ngoAg+v/OrCNqAkY+kNY8nPw3NQJacKJVwYdMiNJgEro0anlxyVsckaTo/tTOi7eCqGeFnn/h76lLvUeYxIHXhugkl1x/s9hmRabgKNPil/pi9o+K9mDIYTo0JnedRR7DQsH0HbRgXr6V7h/40RFjmY52z6ohg9rY3NPiX9QEwqTQKLbLLkcL197a9foTpxJXH8ItbheV/tEeOrnqY+7OOQlOMt/KruXRMEE8RuoznGDVjV5wfQFuClc+FPlGFIXgG/f+PIdaBbniTEeFKXQTajB9Nq9NtgwECzxtPHQMnMGpDtSNwbNo+FfRKeapvWIPTUuWQgbiopLGLiBn2MzZrlZLyF5NoZY9vFLx2tpdD9hNnsysqUXaMpvg44dqRt6INEEJASKQAGnyR7oej4BgjeK7yJ4lm0Sbmi4qq4tq91rwF2K70CjO788ZcDSfFj7j3HkY5m9Hn4lRBtB5RTrV/DrJ8+s+9NtVkOzwjBbkIOM/+WG/X5QaZKqZZ2iBXgd7OLHquO9EmUIi2ydYOvfLtlBMsL4JOZNFTKElgLnfwX54Zyo4NxSD6BR11Npve4UVXAbJz3npkjgvisYgRONRTK2D5ZC+F3N2vLOz7F8BOsOcMla5GP0UH2qdAnCHRek7sBBeMdOIIwIWLjXuJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(52116002)(508600001)(54906003)(4326008)(38100700002)(33716001)(6666004)(8676002)(6506007)(6512007)(6486002)(83380400001)(9686003)(1076003)(186003)(66476007)(66946007)(66556008)(86362001)(2906002)(316002)(3716004)(6916009)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZSm6dZMAiOBjS9vsQKRpGFl/pB6jIojJoe4iqJIQ5onGNgAjjduuo8Q9e5UH?=
 =?us-ascii?Q?LMK0gIuAOvAgTUBhGdaxpZAM8K2iCvOPBMls971KdBteXYiEP6bH1Q2EYHi+?=
 =?us-ascii?Q?kx/9/yh7X5lrWdonxamSQsII9wyotp4z4c/2+Y0AhLFsRnMFlrUE2mLF/c7t?=
 =?us-ascii?Q?4STKKJgT1MUxy5tnZTOH9DMKHe9gDnUavFHP6WLhrjlPnpq3J7g8p3TzliFR?=
 =?us-ascii?Q?VN9MGiZgyKkVmdorhHSe1JwrlV6ieJW6uJrL7QOB9TJ31egPrKS/32wtWIbl?=
 =?us-ascii?Q?n21fn3Vfo3HeN1cAFoTiwRsCt1rUAyuTWdAC85is+lTO/axJwRA/pgAGx+o7?=
 =?us-ascii?Q?WMDWkYqm3WvWSNbEBpYJFHlS6tMNnkj9OADNhKSClqn0iuLljVvo7Le+IYyE?=
 =?us-ascii?Q?5WN0MMfEDh83iJ4gDuEIzPnEzxT2qh83ee3HuLijHsurLoXXli3BXG+ycloJ?=
 =?us-ascii?Q?C+JItlfasb144oUN9Z+Q9ifnXBymi0iWJpIKCzdf7x5dIWoVMhHD2KyIQK6h?=
 =?us-ascii?Q?4phqrQmrN40icydCWl9Su8esqtiHgkFeyBzBxZtgTNIqJtevl1RfMPqy3DoD?=
 =?us-ascii?Q?mcKioE+yGNUqEwD8SMhemCODiWICbC9vTWMykyUTiYjlPNUAimcmbazaCyLc?=
 =?us-ascii?Q?ZWpbrzdJQOLMmWr0OAOlBX4ezavAMatn1MUhypcpwGMatmV/sAOPAbLzbXpt?=
 =?us-ascii?Q?qUkyhxuh8ldukReS53W3YOdAviJIPqcF1XL7zZb/TPkwBfUKqk4d2zwliQM7?=
 =?us-ascii?Q?zhcRT7y657eLhFTECAY2YQBmq97e8hORWNXhoQhWv48s5QEgnwq+lu6yVAUh?=
 =?us-ascii?Q?it8Rge3Co3175ZmyeiS3fKhQ2v8kgXvmWbO1JJLvEiLeTsv6WHRvXUeo/NaU?=
 =?us-ascii?Q?Gl9B64M3FVNCx2Ygnwn6Pwd4Fnj4WSH7dmvExRjomNkVVDIO8bxCrDlr3d6U?=
 =?us-ascii?Q?dxPquYiJH3RXGHr+0MvsBTY8nYz7q47T0McHrZwlqKPYepZgoVHt22bm7fBS?=
 =?us-ascii?Q?9H1XP2m4xQtWsVuTYn624FTPuze4NMscKUq4+wvhSvR6sVq+19TNyZw45vK+?=
 =?us-ascii?Q?JMC/ADNHmvXkCq/FUyMf0X2Up0m59oY44PBNv/PLCo2gQuQz7JWn4oSnk54H?=
 =?us-ascii?Q?p81cs9fZTiF7o3FS3N47vnnvvsvKgO5zcxCJpENhj1MAouNeG2Hvp+olzJr8?=
 =?us-ascii?Q?jZWUQ9qSfFXkbScqfVr7e8rkqjUkE+a71IQcZseDHzDManTdumTkGM4VegiS?=
 =?us-ascii?Q?Uz+dgihYOshT0HH69avwbOJkASdv3zCR1f4nJEWqc130z1bUIHff61rpxIYp?=
 =?us-ascii?Q?mJcikwvlUSqTmr9lRpxU4Tk1Xdcrb46Oo/MLJxYK2kgsgCvn7nduGzfx9oNx?=
 =?us-ascii?Q?imQeyii27iI4G1F0e/B3uDaw5PZXATf2ovcYMFqA1XA/E8CkLmsyggjsaOyI?=
 =?us-ascii?Q?mV3+kw8Cw9Y/KrYxIlE08BspwFoQKnqAtgw2oMhkvqucEmg3+SQkVmf8Haxz?=
 =?us-ascii?Q?eIbTjkoAA347K4gtat5mslei9vnmqwJE2eYAd7MUK0kLKreYHllpv9/dl5wK?=
 =?us-ascii?Q?ivGX/JOIDjYSwtjW3I55QrJRbhMsJ6LtVb2LaDlw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 753e43c2-7d97-417a-9fb6-08d9f89b5cc0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 20:14:01.1894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: inCm2JqaFpaiuu3JD8ESqZQ1CxiU9vZat2lIL8FWEzD3sPIt7zNweG6sWtOcrEUq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1701
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: MXoSd-t0pLl9L2vOaGALmiv2a43_zdvr
X-Proofpoint-ORIG-GUID: MXoSd-t0pLl9L2vOaGALmiv2a43_zdvr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_10,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1011 mlxscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxlogscore=970 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250112
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 07:41:30PM +0100, Jakub Sitnicki wrote:
> The helper macro that records an error in BPF programs that exercise sock
> fields access has been indavertedly broken by adaptation work that happened
> in commit b18c1f0aa477 ("bpf: selftest: Adapt sock_fields test to use skel
> and global variables").
> 
> BPF_NOEXIST flag cannot be used to update BPF_MAP_TYPE_ARRAY. The operation
> always fails with -EEXIST, which in turn means the error never gets
> recorded, and the checks for errors always pass.
> 
> Revert the change in update flags.
> 
> Fixes: b18c1f0aa477 ("bpf: selftest: Adapt sock_fields test to use skel and global variables")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/testing/selftests/bpf/progs/test_sock_fields.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
> index 246f1f001813..3e2e3ee51cc9 100644
> --- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
> +++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
> @@ -114,7 +114,7 @@ static void tpcpy(struct bpf_tcp_sock *dst,
>  
>  #define RET_LOG() ({						\
>  	linum = __LINE__;					\
> -	bpf_map_update_elem(&linum_map, &linum_idx, &linum, BPF_NOEXIST);	\
> +	bpf_map_update_elem(&linum_map, &linum_idx, &linum, BPF_ANY);	\
Acked-by: Martin KaFai Lau <kafai@fb.com>
