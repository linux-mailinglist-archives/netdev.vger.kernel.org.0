Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3477D534516
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 22:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbiEYUkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 16:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345226AbiEYUkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 16:40:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDAC64BE8;
        Wed, 25 May 2022 13:39:58 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGtdEw008703;
        Wed, 25 May 2022 13:39:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KJC2Qnt4YyyQjCKB7rHhqjN9Qz52SH7AcJZKi9pDSBg=;
 b=OjsueYv/3QmJu/jzJyuqqv2+/y7hN5oGsnx/fYrLjpoqvGjPYMv1mPPNeGfrfzoo3V9X
 K6nFxNIAmGcHp0Fn5z1u6nP1vbO9iVVWVqA1iKNeKi0hGXYUTlTbruHF8kXP7E9/I0D+
 6ZswSl0FiLSRy+2qs1Jbf3fOw6pWttGMEcc= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93vursnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:39:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNV1eIZoYFuihzItxhEq1Fp9KXEtOWq6nDxM1HIx/hLFZYjEh44EC2Bb7zEX8V9kem5Lnk9/G4ULA5A3KdCBxE8mYSY9M25fjj3IKKqA/A+5nuLV6+L0tir7nOMaj/FxxQ5syDeYPOraJb0E4ZeKG3VvBXZIKxHgs5SbDZ0MoNtujPPwS83qkCmbm8jo68UB8d5TgF9nR0emmpfstSXQDsoNYvoakCd3somAbO6ed4yRcblubEimarMXxtPV/jL8CBXXHAgxmna181VhsDyCX8cuPxHeaAHTuxrj9Gnz8oYcNkVc2nirTHYhvpFMLPEeNA0Ynw6CGEtFTjQVmlQW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJC2Qnt4YyyQjCKB7rHhqjN9Qz52SH7AcJZKi9pDSBg=;
 b=jmKZC1uCh7a++IhsZPoRDRS83CBw8KfWUzpOvE8LOlxP1oApYn5oGPB5zDQvkm6LBZ2k6whkD6nPMCPq2D2GSEuXmnhlTdqvmrKb+4VyPFVlMM/kjBHiz26twclCL8N+8yhWgClZCl9zRXfQ5AvpT8MADLjY3hyW27ShFHtTb8qrzOi/VtUkucyoE+7bY8XBzEvvD7tLHdREP1LjChT34fbJqb6V5xMYt569HJffn6LMVZb7Kipcne2zJ13+tJ+MAsH2vHYx0fx8ImZebOrhgMmvkGb6XGGBa2r4X0GdFJREgTfWmj/CfaXop/K2ChzsRm6n+Cd/LfJt20B8JM6FmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BYAPR15MB2743.namprd15.prod.outlook.com (2603:10b6:a03:150::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 20:39:39 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419%6]) with mapi id 15.20.5293.013; Wed, 25 May 2022
 20:39:38 +0000
Date:   Wed, 25 May 2022 13:39:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220525203935.xkjeb7qkfltjsfqc@kafai-mbp>
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-6-sdf@google.com>
 <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp>
 <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
 <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp>
 <CAEf4BzYEXKQ-J8EQtTiYci1wdrRG7SPpuGhejJFY0cc5QQovEQ@mail.gmail.com>
 <CAKH8qBuRvnVoY-KEa6ofTjc2Jh2HUZYb1U2USSxgT=ozk0_JUA@mail.gmail.com>
 <CAEf4BzYdH9aayLvKAVTAeQ2XSLZPDX9N+fbP+yZnagcKd7ytNA@mail.gmail.com>
 <CAKH8qBvQHFcSQQiig6YGRdnjTHnu0T7-q-mPNjRb_nbY49N-Xw@mail.gmail.com>
 <CAKH8qBsjUgzEFQEzN9dwD4EQdJyno4TW2vDDp-cSejs1gFS4Ww@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBsjUgzEFQEzN9dwD4EQdJyno4TW2vDDp-cSejs1gFS4Ww@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::21) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fe8d822-e5b0-4876-9a1d-08da3e8eb008
X-MS-TrafficTypeDiagnostic: BYAPR15MB2743:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB27436D0847C3088CBBB863FFD5D69@BYAPR15MB2743.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xnDZ3U9/JCOpyS+eLfhADRcPPCGK7zrbJyOqFubfflTfXKDW3z+3Qv+9Dhfefqe7ud/uO3nDkYqWrR1ppYXRPaXdieW/rrNl12Cw427jPTW++g5HheQPVUiP5DkkbyFV6IcFu+6snOjSj7MKl2y5R45+2f5ue1XX23SMqrtjyS+Yo3XjKxtCuS4bd5q7+fph7JhdPTGnGpg+Ru0me9i7cVwdaznvTFpGX8gtoPzKyv6H0mN8i06EOEOjfqFHRKmDGrl7bkbyZO2p9osW2wYpAna39xEMKieHXjCb7NMgfZN+X68qKmuvO4fFv+9Nxzyl/UcPcZKWraYmtIh4xD6cxobuzNJkWcJUW3N/cy792HasP3+VyWhdRXeSO2cH3Jso2KVNTx37MvKpaCeBROk9atod9oARsywXVEgNopQq9+r617Poa4DmiESvGNBQ/81RoDA4dQzkIX5EF/U9kwsjPnMcLYuEje/g8isXyEEEHeY/zQlFWQuOw/gqAE7z5ISMuVG+PlWGTxsG0s6M57JzKJRVggU/Er1dGbUCvwYrqZzB62h69yz9OZ+LiTNEtGoD4cg7bwhdGUltIIoKJw/s6k1f1HedhGHlX4bCWDhZhSUOLyqltxtlXDGUf8ZXF8YW6pyR5kaetqp3/mFy7CZsclovhQoSAENsjVOEi0W+V2S8gBXh8tvmcaj2tw5LFVwb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(52116002)(8676002)(53546011)(86362001)(6666004)(6916009)(316002)(33716001)(30864003)(54906003)(6506007)(38100700002)(508600001)(66556008)(66946007)(66476007)(4326008)(8936002)(5660300002)(83380400001)(1076003)(2906002)(6486002)(186003)(9686003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bpJLDbiRTFnTCD05EqsWkkJbrdOb1DpJbvvPV4XHtNw3V2O8rFb2ArBmB9FQ?=
 =?us-ascii?Q?nIR0VqsQAjeZyFiACTYny+nITV+lR208c9Z+hd4NavqhWgUadb/trOuuTvFO?=
 =?us-ascii?Q?h+XakCgNdB88/A2cL4PqHL5gVh2wWzxfLZTLFhKRfKTuw+E8pCB/XxTraM4V?=
 =?us-ascii?Q?NxcaRQcfGZh3aJcnDPrhIubB+nRJwrZmnKTHI/oAbdT7cspLtUW2cMVZeC3S?=
 =?us-ascii?Q?RGHVNAhXxiXooza7e+7cXJwP88jSaFr01yz9PDSwpaA6ynnG01j6ItSqHB5q?=
 =?us-ascii?Q?voyzugHDQ4QzuN1Oa4eA5iSwiF5RN15bVDEFOiNvAC7OUldCiPNXXINKnHLe?=
 =?us-ascii?Q?j/HZ+/6/Z3VP60YfpQsWXH7VAMWtFOl7n/VB3A2NAXjjXGk9ZCpOWSGqIBgb?=
 =?us-ascii?Q?7Jz7D7L6dSsw5q1xscmji2LHGH8ssS5tzjeicweRsloAZxzQhWugs+DwUqRE?=
 =?us-ascii?Q?JrYe07n7pTdSoZFvOrKqINp6VF10yA5cLbr8kyEci3vfN602ce2zY6cwNgku?=
 =?us-ascii?Q?AzddbvLdE0JFWrul6Q4L6PeyVy20LRItXyZqu9Peqfj4U23PBmeQtO092E/C?=
 =?us-ascii?Q?ElWcrJnHG2YOXDnKkcTv1kLhBxm55HijvItOc3p6S8oujqQ2yCa6MkswhEkM?=
 =?us-ascii?Q?kOn2J1yaYutusDIAkv1ZjXFER4PDmvBYzHSZr8zKI2o5cODCM9+mw1JmYJAE?=
 =?us-ascii?Q?WYDNGHRc+vewmhLhnt/cRP/jfaZt4qGgWHWgUubBF6I3szxmp3v02vACOSmp?=
 =?us-ascii?Q?jdvDm2l0ng/i8Kc7HXt4q7hOgTABtt/wJKB/iSWEarRYFP04WsfgkIOQvkTp?=
 =?us-ascii?Q?h/Hxhw1C8bPCiB/ecBvATfCxqYNOzJZMmbB8hL+wMta2VS9bcCYlEyulKd69?=
 =?us-ascii?Q?nLVVM5TBs1cjU9SdDYT0JA9XI42CZ4RdLa/B638p65AT7uBGPosu57huMk3q?=
 =?us-ascii?Q?jSdECP56hqadbafSDnKYKBCLXuqT9SkqUDwXUurIsZCe+vy6+GC4AjLcMb9O?=
 =?us-ascii?Q?1PT43r054hZdKbPJGod+SauNFb63ZS9yPtAhtzZ2P7eSu371LSmkA9EhOuIW?=
 =?us-ascii?Q?cwZ/aR5lF14txNAckswyEe8ZjoFN3vtT4xUPBvcQtW32BLh8vsyFeU54lb5F?=
 =?us-ascii?Q?4hY/r6oL1pu7QLjGlo5546zssbS1LLVgC8nV+YeMfJx6i+7kcbx7rugFLugG?=
 =?us-ascii?Q?8YS6SzhR7EQ+bu8/3UPFDgNNgl1xk32dtp4pjcPjMW4I1SfjGBejKW7cH4AV?=
 =?us-ascii?Q?/9eMrSn2+HZWTf1mDf9f2fHeC4Bwa8JxOWkeWMc6giUmdvC3RE4jmBzf65W2?=
 =?us-ascii?Q?rB8+HwG4qHvubBzitBACcYKcxfwmSl8pIC40Yt+OkrDAZZHPTaK/oa7Eyhcv?=
 =?us-ascii?Q?jJQauaZLRn1xi7IUsfuUMJgZib2QO6gS+YzW6JKam6fJ40pbW7fI1CDwQya3?=
 =?us-ascii?Q?k9z+1Nf9brE+qjZjr3MQzJASzevxiLvfR8I27nEiDLGJNzGHu7NoQ9RuEmfy?=
 =?us-ascii?Q?sABRwd1EIspic79MybO0LwDRkAC8+rAZw3yejmlTMnmT6cvfnpnpDtN1dJgL?=
 =?us-ascii?Q?TuZQZ6fm5z11Md9d/92E+W5IuhYnD1J+5Qw9UaX9BILnRJimFKJj+S2ms2ib?=
 =?us-ascii?Q?8gwhTV+sGb10ScJYJjEiFVqQ4qnZ2f7BPRx6PyuKaPYRna+4cmDoBQm0zfSO?=
 =?us-ascii?Q?wAJJRn68H1CnECc3gX9WWRzkHOhOrK/zstl8pCH8gemKuSD8shPPNj0db3nS?=
 =?us-ascii?Q?bSPfnM5uiyB2g29ARGZ16E37MbLfeMI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe8d822-e5b0-4876-9a1d-08da3e8eb008
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 20:39:38.8477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Hbl/aOBeH/fgQJUvp53sgBvXFdZ/TdX4yyxbo+j8VZZUroRzizOJCQSS6eiBIDQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2743
X-Proofpoint-GUID: hRM5a1Kohup3b2_UQ0u6XTS5ZyNs_B2i
X-Proofpoint-ORIG-GUID: hRM5a1Kohup3b2_UQ0u6XTS5ZyNs_B2i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_06,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 10:02:07AM -0700, Stanislav Fomichev wrote:
> On Wed, May 25, 2022 at 9:01 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Tue, May 24, 2022 at 9:39 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, May 24, 2022 at 9:03 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > On Tue, May 24, 2022 at 4:45 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Tue, May 24, 2022 at 10:50 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Tue, May 24, 2022 at 08:55:04AM -0700, Stanislav Fomichev wrote:
> > > > > > > On Mon, May 23, 2022 at 8:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, May 18, 2022 at 03:55:25PM -0700, Stanislav Fomichev wrote:
> > > > > > > > > We have two options:
> > > > > > > > > 1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
> > > > > > > > > 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
> > > > > > > > >
> > > > > > > > > I was doing (2) in the original patch, but switching to (1) here:
> > > > > > > > >
> > > > > > > > > * bpf_prog_query returns all attached BPF_LSM_CGROUP programs
> > > > > > > > > regardless of attach_btf_id
> > > > > > > > > * attach_btf_id is exported via bpf_prog_info
> > > > > > > > >
> > > > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > > > ---
> > > > > > > > >  include/uapi/linux/bpf.h |   5 ++
> > > > > > > > >  kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
> > > > > > > > >  kernel/bpf/syscall.c     |   4 +-
> > > > > > > > >  3 files changed, 81 insertions(+), 31 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > > > > > index b9d2d6de63a7..432fc5f49567 100644
> > > > > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > > > > @@ -1432,6 +1432,7 @@ union bpf_attr {
> > > > > > > > >               __u32           attach_flags;
> > > > > > > > >               __aligned_u64   prog_ids;
> > > > > > > > >               __u32           prog_cnt;
> > > > > > > > > +             __aligned_u64   prog_attach_flags; /* output: per-program attach_flags */
> > > > > > > > >       } query;
> > > > > > > > >
> > > > > > > > >       struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> > > > > > > > > @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
> > > > > > > > >       __u64 run_cnt;
> > > > > > > > >       __u64 recursion_misses;
> > > > > > > > >       __u32 verified_insns;
> > > > > > > > > +     /* BTF ID of the function to attach to within BTF object identified
> > > > > > > > > +      * by btf_id.
> > > > > > > > > +      */
> > > > > > > > > +     __u32 attach_btf_func_id;
> > > > > > > > >  } __attribute__((aligned(8)));
> > > > > > > > >
> > > > > > > > >  struct bpf_map_info {
> > > > > > > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > > > > > > index a959cdd22870..08a1015ee09e 100644
> > > > > > > > > --- a/kernel/bpf/cgroup.c
> > > > > > > > > +++ b/kernel/bpf/cgroup.c
> > > > > > > > > @@ -1074,6 +1074,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > > > > > > > >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > > > > > > > >                             union bpf_attr __user *uattr)
> > > > > > > > >  {
> > > > > > > > > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> > > > > > > > >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> > > > > > > > >       enum bpf_attach_type type = attr->query.attach_type;
> > > > > > > > >       enum cgroup_bpf_attach_type atype;
> > > > > > > > > @@ -1081,50 +1082,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > > > > > > > >       struct hlist_head *progs;
> > > > > > > > >       struct bpf_prog *prog;
> > > > > > > > >       int cnt, ret = 0, i;
> > > > > > > > > +     int total_cnt = 0;
> > > > > > > > >       u32 flags;
> > > > > > > > >
> > > > > > > > > -     atype = to_cgroup_bpf_attach_type(type);
> > > > > > > > > -     if (atype < 0)
> > > > > > > > > -             return -EINVAL;
> > > > > > > > > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> > > > > > > > >
> > > > > > > > > -     progs = &cgrp->bpf.progs[atype];
> > > > > > > > > -     flags = cgrp->bpf.flags[atype];
> > > > > > > > > +     if (type == BPF_LSM_CGROUP) {
> > > > > > > > > +             from_atype = CGROUP_LSM_START;
> > > > > > > > > +             to_atype = CGROUP_LSM_END;
> > > > > > > > > +     } else {
> > > > > > > > > +             from_atype = to_cgroup_bpf_attach_type(type);
> > > > > > > > > +             if (from_atype < 0)
> > > > > > > > > +                     return -EINVAL;
> > > > > > > > > +             to_atype = from_atype;
> > > > > > > > > +     }
> > > > > > > > >
> > > > > > > > > -     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > -                                           lockdep_is_held(&cgroup_mutex));
> > > > > > > > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > > > > > > > +             progs = &cgrp->bpf.progs[atype];
> > > > > > > > > +             flags = cgrp->bpf.flags[atype];
> > > > > > > > >
> > > > > > > > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > -             cnt = bpf_prog_array_length(effective);
> > > > > > > > > -     else
> > > > > > > > > -             cnt = prog_list_length(progs);
> > > > > > > > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > +                                                   lockdep_is_held(&cgroup_mutex));
> > > > > > > > >
> > > > > > > > > -     if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > > > > > > > -             return -EFAULT;
> > > > > > > > > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> > > > > > > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > +                     total_cnt += bpf_prog_array_length(effective);
> > > > > > > > > +             else
> > > > > > > > > +                     total_cnt += prog_list_length(progs);
> > > > > > > > > +     }
> > > > > > > > > +
> > > > > > > > > +     if (type != BPF_LSM_CGROUP)
> > > > > > > > > +             if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > > > > > > > +                     return -EFAULT;
> > > > > > > > > +     if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
> > > > > > > > >               return -EFAULT;
> > > > > > > > > -     if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> > > > > > > > > +     if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
> > > > > > > > >               /* return early if user requested only program count + flags */
> > > > > > > > >               return 0;
> > > > > > > > > -     if (attr->query.prog_cnt < cnt) {
> > > > > > > > > -             cnt = attr->query.prog_cnt;
> > > > > > > > > +
> > > > > > > > > +     if (attr->query.prog_cnt < total_cnt) {
> > > > > > > > > +             total_cnt = attr->query.prog_cnt;
> > > > > > > > >               ret = -ENOSPC;
> > > > > > > > >       }
> > > > > > > > >
> > > > > > > > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > > > > > > > -             return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > > > > > > -     } else {
> > > > > > > > > -             struct bpf_prog_list *pl;
> > > > > > > > > -             u32 id;
> > > > > > > > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > > > > > > > +             if (total_cnt <= 0)
> > > > > > > > > +                     break;
> > > > > > > > >
> > > > > > > > > -             i = 0;
> > > > > > > > > -             hlist_for_each_entry(pl, progs, node) {
> > > > > > > > > -                     prog = prog_list_prog(pl);
> > > > > > > > > -                     id = prog->aux->id;
> > > > > > > > > -                     if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > > > > > > > -                             return -EFAULT;
> > > > > > > > > -                     if (++i == cnt)
> > > > > > > > > -                             break;
> > > > > > > > > +             progs = &cgrp->bpf.progs[atype];
> > > > > > > > > +             flags = cgrp->bpf.flags[atype];
> > > > > > > > > +
> > > > > > > > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > +                                                   lockdep_is_held(&cgroup_mutex));
> > > > > > > > > +
> > > > > > > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > +                     cnt = bpf_prog_array_length(effective);
> > > > > > > > > +             else
> > > > > > > > > +                     cnt = prog_list_length(progs);
> > > > > > > > > +
> > > > > > > > > +             if (cnt >= total_cnt)
> > > > > > > > > +                     cnt = total_cnt;
> > > > > > > > > +
> > > > > > > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > > > > > > > +                     ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > > > > > > +             } else {
> > > > > > > > > +                     struct bpf_prog_list *pl;
> > > > > > > > > +                     u32 id;
> > > > > > > > > +
> > > > > > > > > +                     i = 0;
> > > > > > > > > +                     hlist_for_each_entry(pl, progs, node) {
> > > > > > > > > +                             prog = prog_list_prog(pl);
> > > > > > > > > +                             id = prog->aux->id;
> > > > > > > > > +                             if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > > > > > > > +                                     return -EFAULT;
> > > > > > > > > +                             if (++i == cnt)
> > > > > > > > > +                                     break;
> > > > > > > > > +                     }
> > > > > > > > >               }
> > > > > > > > > +
> > > > > > > > > +             if (prog_attach_flags)
> > > > > > > > > +                     for (i = 0; i < cnt; i++)
> > > > > > > > > +                             if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> > > > > > > > > +                                     return -EFAULT;
> > > > > > > > > +
> > > > > > > > > +             prog_ids += cnt;
> > > > > > > > > +             total_cnt -= cnt;
> > > > > > > > > +             if (prog_attach_flags)
> > > > > > > > > +                     prog_attach_flags += cnt;
> > > > > > > > >       }
> > > > > > > > >       return ret;
> > > > > > > > >  }
> > > > > > > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > > > > > > index 5ed2093e51cc..4137583c04a2 100644
> > > > > > > > > --- a/kernel/bpf/syscall.c
> > > > > > > > > +++ b/kernel/bpf/syscall.c
> > > > > > > > > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> > > > > > > > >       }
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > > > > > > > > +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
> > > > > > > > >
> > > > > > > > >  static int bpf_prog_query(const union bpf_attr *attr,
> > > > > > > > >                         union bpf_attr __user *uattr)
> > > > > > > > > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
> > > > > > > > >       case BPF_CGROUP_SYSCTL:
> > > > > > > > >       case BPF_CGROUP_GETSOCKOPT:
> > > > > > > > >       case BPF_CGROUP_SETSOCKOPT:
> > > > > > > > > +     case BPF_LSM_CGROUP:
> > > > > > > > >               return cgroup_bpf_prog_query(attr, uattr);
> > > > > > > > >       case BPF_LIRC_MODE2:
> > > > > > > > >               return lirc_prog_query(attr, uattr);
> > > > > > > > > @@ -4066,6 +4067,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
> > > > > > > > >
> > > > > > > > >       if (prog->aux->btf)
> > > > > > > > >               info.btf_id = btf_obj_id(prog->aux->btf);
> > > > > > > > > +     info.attach_btf_func_id = prog->aux->attach_btf_id;
> > > > > > > > Note that exposing prog->aux->attach_btf_id only may not be enough
> > > > > > > > unless it can assume info.attach_btf_id is always referring to btf_vmlinux
> > > > > > > > for all bpf prog types.
> > > > > > >
> > > > > > > We also export btf_id two lines above, right? Btw, I left a comment in
> > > > > > > the bpftool about those btf_ids, I'm not sure how resolve them and
> > > > > > > always assume vmlinux for now.
> > > > > > yeah, that btf_id above is the cgroup-lsm prog's btf_id which has its
> > > > > > func info, line info...etc.   It is not the one the attach_btf_id correspond
> > > > > > to.  attach_btf_id refers to either aux->attach_btf or aux->dst_prog's btf (or
> > > > > > target btf id here).
> > > > > >
> > > > > > It needs a consensus on where this attach_btf_id, target btf id, and
> > > > > > prog_attach_flags should be.  If I read the patch 7 thread correctly,
> > > > > > I think Andrii is suggesting to expose them to userspace through link, so
> > > > > > potentially putting them in bpf_link_info.  The bpf_prog_query will
> > > > > > output a list of link ids.  The same probably applies to
> > > > >
> > > > > Yep and I think it makes sense because link is representing one
> > > > > specific attachment (and I presume flags can be stored inside the link
> > > > > itself as well, right?).
> > > > >
> > > > > But if legacy non-link BPF_PROG_ATTACH is supported then using
> > > > > bpf_link_info won't cover legacy prog-only attachments.
> > > >
> > > > I don't have any attachment to the legacy apis, I'm supporting them
> > > > only because it takes two lines of code; we can go link-only if there
> > > > is an agreement that it's inherently better.
> > > >
> > > > How about I keep sys_bpf(BPF_PROG_QUERY) as is and I do a loop in the
> > > > userspace (for BPF_LSM_CGROUP only) over all links
> > > > (BPF_LINK_GET_NEXT_ID) and will find the the ones with matching prog
> > > > ids (BPF_LINK_GET_FD_BY_ID+BPF_OBJ_GET_INFO_BY_FD)?
> > > >
> > > > That way we keep new fields in bpf_link_info, but we don't have to
> > > > extend sys_bpf(BPF_PROG_QUERY) because there doesn't seem to be a good
> > > > way to do it. Exporting links via new link_fds would mean we'd have to
> > > > support BPF_F_QUERY_EFFECTIVE, but getting an effective array of links
> > > > seems to be messy. If, in the future, we figure out a better way to
I don't see a clean way to get effective array from one individual
link[_info] through link iteration.  effective array is the progs that
will be run at a cgroup and in such order.  The prog running at a
cgroup doesn't necessarily linked to that cgroup.

If staying with BPF_PROG_QUERY+BPF_F_QUERY_EFFECTIVE to get effective array
and if it is decided the addition should be done in bpf_link_info,
then a list of link ids needs to be output instead of the current list of
prog ids.  The old attach type will still have to stay with the list of
prog ids though :/

It will be sad not to be able to get effective only for BPF_LSM_CGROUP.
I found it more useful to show what will be run at a cgroup and in such
order instead of what is linked to a cgroup.

> > > > expose a list of attached/effective links per cgroup, we can
> > > > convert/optimize bpftool.
> > >
> > > Why not use iter/bpf_link program (see progs/bpf_iter_bpf_link.c for
> > > an example) instead? Once you have struct bpf_link and you know it's
> > > cgroup link, you can cast it to struct bpf_cgroup_link and get access
> > > to prog and cgroup. From cgroup to cgroup_bpf you can even get access
> > > to effective array. Basically whatever kernel has access to you can
> > > have access to from bpftool without extending any UAPIs.
> >
> > Seems a bit too involved just to read back the fields? I might as well
> > use drgn? I'm also not sure about the implementation: will I be able
> > to upcast bpf_link to bpf_cgroup_link in the bpf prog? And getting
> > attach_type might be problematic from the iterator program as well: I
> > need to call kernel's bpf_lsm_attach_type_get to find atype for
> > attach_btf_id, I'd have to export it as kfunc?
> 
> I've prototyped whatever I've suggested above and there is another
> problem with going link-only: bpftool currently uses bpf_prog_attach
> unconditionally; we'd have to change that to use links for
> BPF_LSM_CGROUP (and pin them in some hard-coded locations?) :-(
> I'm leaning towards keeping those legacy apis around and exporting via
> prog_info; there doesn't seem to be a clear benefit :-(
