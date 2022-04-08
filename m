Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE9B4F9AE0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiDHQom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiDHQol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:44:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F02E30;
        Fri,  8 Apr 2022 09:42:36 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 238D3oWR002324;
        Fri, 8 Apr 2022 09:42:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=SKnNBKNC4Tvj8zNeUMYFTESg/IWcjWOQlOV6RVnUf/0=;
 b=oP/jypxIRuhiwO5knLBPS6w7pE1LeTnTaldB/xoMQoycpiVzP961AIeOhYyqMRt2dQux
 IXGxG7H+4OM6O3q5j75OqG8W6j8/rMD0CPOceeo4xyFxRuKDdOjGF6GA7mQyLU3uRx0Z
 ulXabBmyInkcIaQvUvRto0i+6H1XRNv3Ha4= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fankk9ghd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 09:42:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3+YEZcsFMq+1l2hQPdQkvBnFfxT4nMGQmk9kTV6Fon+yfb/F1Wew12ew3PnWFT0utuas4XOUVaNLHVPe3VeFA+yfTvD2xR2lmluoHDWL0GXto+DeQ0eX3vFSlRgdUmnaAWkNR++BMrZfpJ9CC+Xck0j9xlTo7i5liD0z2M26Sa3TEZgYWElDG85YmRS3D4XAMq+z1yhYeL8Vo5OCOeII4ntunqkx0YC/kCIEIubAWIIrBOMMDiMaUv9tF3tR5rebN2cIpPDpo16dbqOoz7h8XpNjVyXF0p9QzKe6gZYzXwbMArgRdccCdJ2puAl/PEg3fCz/aZFyDT8My1RITzZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKnNBKNC4Tvj8zNeUMYFTESg/IWcjWOQlOV6RVnUf/0=;
 b=PlXvw5FD7TTvs3SA/l+0gVQwkJj3L89rGOagbhUgZUPxQsj2D65oHkXAQhJw5paJE5uoUir3OAugbhs5cSTztwJG8+E9GxJ77ziOGQ6XuPE4bgZEwGitlQeil42W3UYJlEpYAWjqPl15ZbwJaRVVlgyof+dwLi557RBjusg1Jcr2MJ2IZYp8gef7NJtoi6+QH4GcdMR5ewfDC77Q6eJrdVbA9wzNJpdjzCigbrpxW8HqJxmimCsi2QLNj3b3uhf53D4f29lv6jRvd0FCDmsHQjuWz40a7h0q0GzfgOliGA1Ij0OfUau2Q86E1rLjaBM3kGutsMyiYqGp688D+hYSJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CY4PR15MB1157.namprd15.prod.outlook.com (2603:10b6:903:110::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Fri, 8 Apr
 2022 16:42:07 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::bda3:5584:c982:9d44]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::bda3:5584:c982:9d44%3]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 16:42:07 +0000
Date:   Fri, 8 Apr 2022 09:42:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        bpf@vger.kernel.org, llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 2/7] bpf: per-cgroup lsm flavor
Message-ID: <20220408164205.kvccyzkvsc3oef65@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-3-sdf@google.com>
 <202204082305.Qs2g5Dzf-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202204082305.Qs2g5Dzf-lkp@intel.com>
X-ClientProxiedBy: BYAPR01CA0052.prod.exchangelabs.com (2603:10b6:a03:94::29)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c537315d-6d4f-49f7-f848-08da197eb867
X-MS-TrafficTypeDiagnostic: CY4PR15MB1157:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB115780BD507F97E53EC5D162D5E99@CY4PR15MB1157.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCvBkx2Fwis03/g1C6Od5ECY1jq6yXg3Z9kf3LsC5qNhd6XT9YmxVaei8VE6b1jfJ617ngVFknD1VWXeScXtdrIGw+mM1WOvOolB/clIoOjTEY+s+8LWA5xUiePQDX6ioZS9b/6CVYX6xlE4s0HZZnFtEjMMPs0uTiiwnkHb/x27p7IsXwzv0/wdJhzYRR6ongFsXhabuSenBy0fcll1PHSpXYBn9qfLuJddsf92ChGo7OcbSZeEWAixIeAC4K9ygBy8hsQjpgr4dGExyqYVz/+uRie52+rIggblEeE4ZIkOAPXjB75tPOYYen2id+/QiNNmtWDginIvMQ/9ieZI+1iZD8s6c3C9ot4jnSRZ3XvYTnwQooESm6RAh7w29wWNUmTdF1kahzZkpV4y/cenT/aRQ/UZ4u9+2pJzzBgTQeBo4ESWHqfSt+G+wnkovvXRwwIxdYLYS97N8HF5x6gvROQ2JcciKW2/Cb8y4O7BXM3Ru/1vQnGoRmHO39YWrNTXZEOWWfqldgpLIk2Glqo4aaW9mbXbzCCwj3S4ecxQszwN8VgtlfzriMTz2QBnT5xMlG9pLh6IXdxubf1l53DbipP8CvcCuzOxV+AxAlYRaGfRT2qAmmPaL4OHVA1C57Kbi+CFIYFb2V4R+vajQqdoVOD+/bWU/T/D8WySiIwmjna4YEDksEfWKbwhVzCZDWY+5keSmK8hNS5Mrn52EiXrYqlkusbOrkPA1kvo4al8gtDHVIRR2+2RO1LFQKiLLNMopj1gvwAGh2FuTkv1LC1ozg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(66946007)(6486002)(6916009)(8676002)(66556008)(4326008)(66476007)(508600001)(86362001)(966005)(52116002)(6512007)(9686003)(6506007)(186003)(2906002)(5660300002)(8936002)(38100700002)(1076003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XSMbMJOyz5lOXfTIODpCGXpGuRuYu1l7D9ULl39n1b24V4cPfbb2Pofay3sc?=
 =?us-ascii?Q?BJinC+M6ajmNpQhD5HKjqEwDETRjg1i7bVdAqVeTxXJebPd+5So8AxLWn+NU?=
 =?us-ascii?Q?i52wNeyTSg3buqlxdTNyDZzc7OeGUiV9PvXaMBHiv5/9yQjIO0n3DYz/g2Ey?=
 =?us-ascii?Q?vL17mAsMpL1SfnjvbHevvTVPK70RbeRXb1XGFmbNUe5KOxdMrcn63rN4Dn3z?=
 =?us-ascii?Q?AjwyiyP+2PrUml/C0YpVEJJJvEkqh3DRkyfEmEJcQmxcEStJ+K60x1PfvZ0+?=
 =?us-ascii?Q?0qqEz0w2M3cucE6HdadmME+ccZn4mhwtKfvaHHsEsHmOy0MFF/1c9Df8q2TX?=
 =?us-ascii?Q?CF/+v4fE3XOABgalHtT9m+2KZhyZJTzNQrOTLS2magov64LIFBjuZcnsjik1?=
 =?us-ascii?Q?J0sLM2qyK2XOm3XcBEWMCba8Xh8qId/qeUoUXujag8sLe/AVGQ44ipOk8dI8?=
 =?us-ascii?Q?lfQy7McR7VibHW+yFCmtjLNEBgqUu8pFPvJBmfFIx/tRZhyAgCXs1yEM8hnT?=
 =?us-ascii?Q?MHNLCbvU1e4NNQOfdPuLbjovUQ1uIivkUlhCDTfVHWhAbvs65XPlOg28N0oN?=
 =?us-ascii?Q?urmAaQpmZBCIQHhXvO3f5AWFCGm7S/NYb/O7XODOaDUsUHhK8GBAjEmV+uxW?=
 =?us-ascii?Q?QbpO0NzeUNjCzZJgTOs6gGgoFY9mMNlrUXRgLCfwkfGxUnZCZkCYA5OItdWD?=
 =?us-ascii?Q?JiXzxY7G1K3hXroCr9ra0lBPZM8+ddttrsEjr/j/RRKGLDMYRm3ReNfWxdDf?=
 =?us-ascii?Q?kUG913gsDMJJySNrugUmCjYGHHs61AOqndTVBdzkeljAZKr/qATUoJ25GduY?=
 =?us-ascii?Q?ldu2LCT204/ipaGOtcHZt+r5vFx4i7tAPfFw+CmD5PvfGAAYCAOkLUzO33AT?=
 =?us-ascii?Q?psoapB/Ey6i9OPWQfNilP94B9TMYY+AaWgB4y0k5J6ddMA0zMd89fb8TGLlN?=
 =?us-ascii?Q?1B6kvrqJsialvV5i59+CcHYQyVl6XUnpybFzBItn26DbAhIglnRJqxeB7ggr?=
 =?us-ascii?Q?njrvvrlA/UzJ6DycR6q3KHr+AEve3ag0wa/HJIa+OJByrRKVDd4C5rsU/TMO?=
 =?us-ascii?Q?yAg++itLIPk/ugCqnq76oSHAQg730IBDaZ23sk9hVzD9qswZFxCXyUcQmnDI?=
 =?us-ascii?Q?CzTGZ1UOyXJmFQliuRaKkbl/RE2aMxRByrrmzCxoLUsaI1/fmtd48p8kmiid?=
 =?us-ascii?Q?2AY6ZDJsMvStjebrJ4hgjW8RL1yA5rJLpT5p+on+A+m2TU1xiIj0Q3Mf1tDD?=
 =?us-ascii?Q?gffG51muE2jdHlG5ghVuMNZY3fgON3jZmgJIQuL5k69xYEym2LMcx88yxHyX?=
 =?us-ascii?Q?OTqTd4beA0XO+8pI6iOiGisOkhwXh8mDq6glZY+SXmq8E1pZuidNGMsuFlTg?=
 =?us-ascii?Q?KaNAiwX/00/E/0rMPhQdHb8pkdMbBO7wyp81FlsXFRA6IKYnH2OglBmQuOUU?=
 =?us-ascii?Q?NkV7Cal+L8D2wf8x6QgDDV44aJKL3d5R3mGoWD/sQUOFSl1knDW8uv5IKwM9?=
 =?us-ascii?Q?Yxdd+kR1I4C6nAqPvcuF9VM3mYxQGlhYtWOHO7fYvqTy0WI4WiQAOCYUD0C8?=
 =?us-ascii?Q?Z+0vdJijjI/+eHHGWOKROvJV4KRWvTTPxSoccHAbujztq3Lp0Up2ZOAe7q2R?=
 =?us-ascii?Q?2WaI78V7nUJKpJG8QpYC/i2F0KbBuKUdf1j2or1flPL8Qeo8Lz7dzz2s9fn9?=
 =?us-ascii?Q?+1IfR+EaglASRUihF6WUSDNzAaZkKEJEK1AdXbv3MW+BWy4OQVtjzzNtZQDW?=
 =?us-ascii?Q?XubZk5SprlVcHTq83CAlFvo4qzQDs2g=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c537315d-6d4f-49f7-f848-08da197eb867
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 16:42:07.7991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4t5pu4VNc5ZSAgSlMUnuBw9fsdWMQy1TrkxoV2ADt+fhLcSLSk2eCXjdT0xor4Df
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1157
X-Proofpoint-ORIG-GUID: P0PbabvrEJROkwgmhXjJU9A5V5U_qi_3
X-Proofpoint-GUID: P0PbabvrEJROkwgmhXjJU9A5V5U_qi_3
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_05,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 11:53:47PM +0800, kernel test robot wrote:
> Hi Stanislav,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on bpf-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220408-063705
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220408/202204082305.Qs2g5Dzf-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c29a51b3a257908aebc01cd7c4655665db317d66)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/3c3f15b5422ca616e2585d699c47aa4e7b7dcf1d
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220408-063705
>         git checkout 3c3f15b5422ca616e2585d699c47aa4e7b7dcf1d
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> ld.lld: error: undefined symbol: btf_obj_id
>    >>> referenced by trampoline.c
>    >>>               bpf/trampoline.o:(bpf_trampoline_link_cgroup_shim) in archive kernel/built-in.a
>    >>> referenced by trampoline.c
>    >>>               bpf/trampoline.o:(bpf_trampoline_unlink_cgroup_shim) in archive kernel/built-in.a
It is probably because obj-$(CONFIG_BPF_JIT) += trampoline.o
while obj-$(CONFIG_BPF_SYSCALL) += btf.o.

Good catch but seems minor and should not affect the review.
Please hold off the respin a little first so that the review
can continue on this revision.
