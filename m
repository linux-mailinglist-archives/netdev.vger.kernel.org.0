Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63761534747
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 02:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346583AbiEZAEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 20:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346557AbiEZAED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 20:04:03 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014B83E0DD;
        Wed, 25 May 2022 17:04:00 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGtbJR009759;
        Wed, 25 May 2022 17:03:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=++f0v0SLTAtnqSFCY74tb3g7LQNYxN6t/jQKP3uNfqA=;
 b=qj2nmHTM9GPVGeu4Yv2pOvPQXMwdzLmROuJBx17qftz/PapSdqIhSxiAy9b8ye6HMccU
 cMFGz9+UaEeMZVvnp4LkXKu8mSHqGj+s+uLyFJaim5B5ZT+YOTKnwIq7zBaxWSfnTyyV
 FofBVcZsZks52CZPX2d+hW4+F3lbNcbutGc= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93tvsuge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 17:03:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=di4RDUw2BNGj6BG2EXc+O2i91t6UmsxMw4gMHVZx6pMu+WsAErwpFeGsTY9oB3tO1A1vEuBAecAclGKeJE5TR1Db2OOOxDMHClmvFK9w1aQlbjKwujIVEsFMexVOxehoC0GNcwvEx0aHNV0M/0BeP0Xebk/lFqI0a+36L38IdKZ74naWtwbcCMFArjngTYvOis6f4Jl83ygl9IUN0MEH8z0F1T1FqjzcVBQNNQVGlrAMWGDxdGT+B5FJD4Ss5DKoJq59bRFRas466XMMY1B9lfevzSBNiLYg2Ae6vnC15pUAZlmcs4MVpYS1uyXOA/KmZRzHwd50zBSYcNqOeNAC6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++f0v0SLTAtnqSFCY74tb3g7LQNYxN6t/jQKP3uNfqA=;
 b=UXBcHiql1eU0DiBGitXxCo9IxQkGDIDkbCpjPiDjC4D4DLQRxDTDYbDqMAzj/B2zqG8j8bKofmgm2gZt4BBv3iLgjhBlxsynfok+4TYDG4I33ZKAswhepOHdqgMsCwJVOiANZpWGr4iVYOifZMvU3ypkW8vRZ5evxDMe/ucO2ZAf1uogc/2C0OnNiorPLslvpGzFJsmc2QBZS4g/f9cpNDYDdN04cga/U3hUZgo1HFRr7FSXK9X4bctG6mpb6wgaLA2GDEM3DyavPHDnZqd2HFHlxrOfLH7omH1PvYKSZM1/Yc/85nb/0wqW2YvP/iBdbePGTGfRgtgQ4tnj7BnBaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN8PR15MB3299.namprd15.prod.outlook.com (2603:10b6:408:a2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 00:03:40 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419%6]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 00:03:40 +0000
Date:   Wed, 25 May 2022 17:03:32 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     sdf@google.com
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220526000332.soaacn3n7bic3fq5@kafai-mbp>
References: <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp>
 <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
 <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp>
 <CAEf4BzYEXKQ-J8EQtTiYci1wdrRG7SPpuGhejJFY0cc5QQovEQ@mail.gmail.com>
 <CAKH8qBuRvnVoY-KEa6ofTjc2Jh2HUZYb1U2USSxgT=ozk0_JUA@mail.gmail.com>
 <CAEf4BzYdH9aayLvKAVTAeQ2XSLZPDX9N+fbP+yZnagcKd7ytNA@mail.gmail.com>
 <CAKH8qBvQHFcSQQiig6YGRdnjTHnu0T7-q-mPNjRb_nbY49N-Xw@mail.gmail.com>
 <CAKH8qBsjUgzEFQEzN9dwD4EQdJyno4TW2vDDp-cSejs1gFS4Ww@mail.gmail.com>
 <20220525203935.xkjeb7qkfltjsfqc@kafai-mbp>
 <Yo6e4sNHnnazM+Cx@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo6e4sNHnnazM+Cx@google.com>
X-ClientProxiedBy: SJ0PR05CA0194.namprd05.prod.outlook.com
 (2603:10b6:a03:330::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c50edaa-a235-4571-762b-08da3eab309d
X-MS-TrafficTypeDiagnostic: BN8PR15MB3299:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB3299D4C860F7EF61F7885A11D5D99@BN8PR15MB3299.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FYpD7RoNQon7uyscczSwMRlRyWTXhTN34fzvn3Iq/m6Nj6/bJ1W1N6MMpMdN9uX93g0Dt08etqZ9XnAcwmugEBG6YDKqdraIbDn3JSbHpAxYhOg17F5VYACAzVjuwN1qzWWCqJm8+lLTB5fu2XxLhe9/zsPwwIjGd8VX/4ikN+XuJrI46Ole4Dd9o0FUon287dmEJfr8S5Ig0VyCjOHVm+iqlNTJQKvmShJgJSM6gvPi275Kr/AZxAl9jYEySFFJnB63BefA6zjipszwvjD/wmASk5xZITl5fUfXnKjcH+AK/BZmMH6f7+zx788NkfcOgAiYhuK8mfcu1ZupqiYRv3Su0ypO4Fh5YM1lKlsU2CQRPxGqWruXWOsy4H3D5081azARiqBtvZkNW+Ozr3FNMemtEJqOylZipUATHl8zT24AOuMkPeD40XR9o0T1ts2eQt3QzzJIXjWXwjR757iS7VFypgtqs1ERPv2RNloNNGC5L9fcNAZFG5JjmlEbJnb2DCh8XNjGegaIMdYeHKL64cHavLGp3gXNtDvAO8hfrh/Hn6n6G5ftdBFWquhmwW4tkePFXbrUqUmXV+Mz3/2NJgIApOOWb65FhnwilB6jrTEKgKpLKahvnjaqfUyEOivxlivh0Yo0z1a1mFyAsyKctA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(83380400001)(6512007)(6506007)(9686003)(52116002)(6666004)(2906002)(53546011)(508600001)(6486002)(8936002)(1076003)(30864003)(186003)(86362001)(38100700002)(33716001)(54906003)(6916009)(316002)(66946007)(66476007)(66556008)(4326008)(8676002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZZB3G8rSEsc5CHwxF+7KYAUP4AxV7/J2JAb7/pCu0UnSlJIVe6U/5Y75mCyu?=
 =?us-ascii?Q?pJGlcmWg8eMYHVuEICZMxHqyijQFaZO/fut/cmM2+bQktAnQMilMv97rPYfE?=
 =?us-ascii?Q?sVP+X2+MsYe9ND1805k1mylj4F+6vxGNjJtiFD71jMegFX++3P+SgLFbd2Sw?=
 =?us-ascii?Q?Aetbd/1CjxYeIwaKfddhqQcBYlMF8Jbo9r4jTx7w8iK83dm+MEBfxr8N0aeW?=
 =?us-ascii?Q?fhph0AaACvdB41nVXv1ACQcwi1ORLynsCKHPYKcJl+nAuG4kJal0JLZnHk+P?=
 =?us-ascii?Q?PhRhEFKVhQlJaM83Xoukwr++DgDf/yrdH5lPwTtR3RP3bxN01Odh8wH7xvMy?=
 =?us-ascii?Q?aNvo28odX8yr4sYVxauWtOW6pOyMBPqudfPzmuYBjRuq4bb5gKWCxZAOXKnB?=
 =?us-ascii?Q?LTyd/aA+lZvunzjN4qJjSi0qNVJnlttngoVKkCRS0sWadXEpKIAzwnQUh626?=
 =?us-ascii?Q?US/ByAR4Z6RUJghk/aQ6GNkAgq8naSspp7n4QMZt9SfofKjShKCNEAPzbNBe?=
 =?us-ascii?Q?y3g/JWPRT1ftnhnRfNs/R4H1X/wYITGoD6PFX5nUZrxomOHJwtNTJ5aj0P7u?=
 =?us-ascii?Q?WJAb3pPV2yHiiZr8lx1MeszJHNPCpuTkhJot1eTU2K2u91qMiNxNccBOEkI6?=
 =?us-ascii?Q?jeq9W6oPeHiuCXjHQlF78UyTxOelNzqKVMwnhbmfPVfZ+zFsU0xffmYpEIMF?=
 =?us-ascii?Q?te6baOhv9V/nNvuPZVRISCI4Jw1BkaMGoPAKinssyMDgVceLvuCHzLZgb08c?=
 =?us-ascii?Q?APsCBhTAnKuPPemikPBD81Dt1zu8rxgdD03aDbsZRx1ds0bAhWkTJOMxNhBe?=
 =?us-ascii?Q?GTNum0i31rY4HXdOAMHfLDOGYOQkQp85MOjZ0VOmKkiCmj8sPMPIQ48lxj3b?=
 =?us-ascii?Q?p+1hD5piVzm/robzcsaPU7aGr4ujR9yHA4lA+JQ2O+aa83WditUnnuVqxFLh?=
 =?us-ascii?Q?F2Vpz1JLdA06q1CohwigUSALPwewFUI6vmWqy+p1/htmgYoKVKQc1sLfSir4?=
 =?us-ascii?Q?75WvgxYJQc/g696KYhniWJ/NNg0jTCFN2IZRnGu+YqMDzch+VEPKOcdeBuXb?=
 =?us-ascii?Q?RfJXKwdtOxDQZTz/6YVxRSsd0MKbt0KwvcgSl9u0ahgM4qyqOZiR582RJoSv?=
 =?us-ascii?Q?DHHGsDkBeLZndoyAHIPSjeuCQBmpFdUMjYMcvuDqhZg4XpPBka34bYDhigzi?=
 =?us-ascii?Q?yGxbEC6gmXYhKUoPa/k4L1UyBtI/5tICta/VoceMuP9XO6QrE/CmIMpEJuPC?=
 =?us-ascii?Q?l53WCP8GEzgYfr+kWDIaCmE+MCeNTtvwT8AmZm9/2i1mkeu+rAlelzNgdD6l?=
 =?us-ascii?Q?OhM0Kn4J3bKwz+rSs3rxzJJ2rrGQdbHhc1PF8QbJTrhBHEhGzZWcCIFTuEP6?=
 =?us-ascii?Q?jvI/xkCW4P/GEHeIZiqNVTAyJ+ziuiQFdchpRVcCOUuiWNMWThyXkeMrA6+6?=
 =?us-ascii?Q?tgikqW64xhue/LLh+xU57uHUWuGVEYplzPdDWRH5DtJ0ObL0tC165fCXl/Wd?=
 =?us-ascii?Q?gwsOuIVWKLOyJIxUAPgTIM6/QJDcvQ+yBxq04ZrEBH1EaenXSkvXxb6FaO5F?=
 =?us-ascii?Q?46DPktldUdgbF/FRveolckbrbx2goFpfMEo/CmYlTUD5NsNVb5W+n6eUI9sc?=
 =?us-ascii?Q?Uxqkcl9almP6wZunzZaSfBAcwbO4KgEpycBy6Z5jibvHIHb7GM5Qfo5jhzOh?=
 =?us-ascii?Q?NGmL/aTumOlIVXwJNukAA4c66c5MSXc1SO4nboOeyEaUeHEIT25joMANFr3s?=
 =?us-ascii?Q?K65xYqfgXu2+qanl0e5SNqbu84zHqsI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c50edaa-a235-4571-762b-08da3eab309d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 00:03:40.4176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOe2fL6kFYN+Gaa7KMJ+b8zqK8pQExsUHw8jh6bCy4BRRn1qMvN+sMhK1IAO9Ew+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3299
X-Proofpoint-GUID: _zLURnQsW1s5Oi4LrdWaU2tdJB6WLFMb
X-Proofpoint-ORIG-GUID: _zLURnQsW1s5Oi4LrdWaU2tdJB6WLFMb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_07,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 02:25:54PM -0700, sdf@google.com wrote:
> On 05/25, Martin KaFai Lau wrote:
> > On Wed, May 25, 2022 at 10:02:07AM -0700, Stanislav Fomichev wrote:
> > > On Wed, May 25, 2022 at 9:01 AM Stanislav Fomichev <sdf@google.com>
> > wrote:
> > > >
> > > > On Tue, May 24, 2022 at 9:39 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Tue, May 24, 2022 at 9:03 PM Stanislav Fomichev
> > <sdf@google.com> wrote:
> > > > > >
> > > > > > On Tue, May 24, 2022 at 4:45 PM Andrii Nakryiko
> > > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > > >
> > > > > > > On Tue, May 24, 2022 at 10:50 AM Martin KaFai Lau
> > <kafai@fb.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, May 24, 2022 at 08:55:04AM -0700, Stanislav Fomichev
> > wrote:
> > > > > > > > > On Mon, May 23, 2022 at 8:49 PM Martin KaFai Lau
> > <kafai@fb.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Wed, May 18, 2022 at 03:55:25PM -0700, Stanislav
> > Fomichev wrote:
> > > > > > > > > > > We have two options:
> > > > > > > > > > > 1. Treat all BPF_LSM_CGROUP the same, regardless of
> > attach_btf_id
> > > > > > > > > > > 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate
> > hook point
> > > > > > > > > > >
> > > > > > > > > > > I was doing (2) in the original patch, but switching
> > to (1) here:
> > > > > > > > > > >
> > > > > > > > > > > * bpf_prog_query returns all attached BPF_LSM_CGROUP
> > programs
> > > > > > > > > > > regardless of attach_btf_id
> > > > > > > > > > > * attach_btf_id is exported via bpf_prog_info
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > > > > > ---
> > > > > > > > > > >  include/uapi/linux/bpf.h |   5 ++
> > > > > > > > > > >  kernel/bpf/cgroup.c      | 103
> > +++++++++++++++++++++++++++------------
> > > > > > > > > > >  kernel/bpf/syscall.c     |   4 +-
> > > > > > > > > > >  3 files changed, 81 insertions(+), 31 deletions(-)
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/include/uapi/linux/bpf.h
> > b/include/uapi/linux/bpf.h
> > > > > > > > > > > index b9d2d6de63a7..432fc5f49567 100644
> > > > > > > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > > > > > > @@ -1432,6 +1432,7 @@ union bpf_attr {
> > > > > > > > > > >               __u32           attach_flags;
> > > > > > > > > > >               __aligned_u64   prog_ids;
> > > > > > > > > > >               __u32           prog_cnt;
> > > > > > > > > > > +             __aligned_u64   prog_attach_flags; /*
> > output: per-program attach_flags */
> > > > > > > > > > >       } query;
> > > > > > > > > > >
> > > > > > > > > > >       struct { /* anonymous struct used by
> > BPF_RAW_TRACEPOINT_OPEN command */
> > > > > > > > > > > @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
> > > > > > > > > > >       __u64 run_cnt;
> > > > > > > > > > >       __u64 recursion_misses;
> > > > > > > > > > >       __u32 verified_insns;
> > > > > > > > > > > +     /* BTF ID of the function to attach to within
> > BTF object identified
> > > > > > > > > > > +      * by btf_id.
> > > > > > > > > > > +      */
> > > > > > > > > > > +     __u32 attach_btf_func_id;
> > > > > > > > > > >  } __attribute__((aligned(8)));
> > > > > > > > > > >
> > > > > > > > > > >  struct bpf_map_info {
> > > > > > > > > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > > > > > > > > index a959cdd22870..08a1015ee09e 100644
> > > > > > > > > > > --- a/kernel/bpf/cgroup.c
> > > > > > > > > > > +++ b/kernel/bpf/cgroup.c
> > > > > > > > > > > @@ -1074,6 +1074,7 @@ static int
> > cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > > > > > > > > > >  static int __cgroup_bpf_query(struct cgroup *cgrp,
> > const union bpf_attr *attr,
> > > > > > > > > > >                             union bpf_attr __user
> > *uattr)
> > > > > > > > > > >  {
> > > > > > > > > > > +     __u32 __user *prog_attach_flags =
> > u64_to_user_ptr(attr->query.prog_attach_flags);
> > > > > > > > > > >       __u32 __user *prog_ids =
> > u64_to_user_ptr(attr->query.prog_ids);
> > > > > > > > > > >       enum bpf_attach_type type =
> > attr->query.attach_type;
> > > > > > > > > > >       enum cgroup_bpf_attach_type atype;
> > > > > > > > > > > @@ -1081,50 +1082,92 @@ static int
> > __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > > > > > > > > > >       struct hlist_head *progs;
> > > > > > > > > > >       struct bpf_prog *prog;
> > > > > > > > > > >       int cnt, ret = 0, i;
> > > > > > > > > > > +     int total_cnt = 0;
> > > > > > > > > > >       u32 flags;
> > > > > > > > > > >
> > > > > > > > > > > -     atype = to_cgroup_bpf_attach_type(type);
> > > > > > > > > > > -     if (atype < 0)
> > > > > > > > > > > -             return -EINVAL;
> > > > > > > > > > > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> > > > > > > > > > >
> > > > > > > > > > > -     progs = &cgrp->bpf.progs[atype];
> > > > > > > > > > > -     flags = cgrp->bpf.flags[atype];
> > > > > > > > > > > +     if (type == BPF_LSM_CGROUP) {
> > > > > > > > > > > +             from_atype = CGROUP_LSM_START;
> > > > > > > > > > > +             to_atype = CGROUP_LSM_END;
> > > > > > > > > > > +     } else {
> > > > > > > > > > > +             from_atype =
> > to_cgroup_bpf_attach_type(type);
> > > > > > > > > > > +             if (from_atype < 0)
> > > > > > > > > > > +                     return -EINVAL;
> > > > > > > > > > > +             to_atype = from_atype;
> > > > > > > > > > > +     }
> > > > > > > > > > >
> > > > > > > > > > > -     effective =
> > rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > > > -
> > lockdep_is_held(&cgroup_mutex));
> > > > > > > > > > > +     for (atype = from_atype; atype <= to_atype;
> > atype++) {
> > > > > > > > > > > +             progs = &cgrp->bpf.progs[atype];
> > > > > > > > > > > +             flags = cgrp->bpf.flags[atype];
> > > > > > > > > > >
> > > > > > > > > > > -     if (attr->query.query_flags &
> > BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > > > -             cnt = bpf_prog_array_length(effective);
> > > > > > > > > > > -     else
> > > > > > > > > > > -             cnt = prog_list_length(progs);
> > > > > > > > > > > +             effective =
> > rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > > > +
> > lockdep_is_held(&cgroup_mutex));
> > > > > > > > > > >
> > > > > > > > > > > -     if (copy_to_user(&uattr->query.attach_flags,
> > &flags, sizeof(flags)))
> > > > > > > > > > > -             return -EFAULT;
> > > > > > > > > > > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt,
> > sizeof(cnt)))
> > > > > > > > > > > +             if (attr->query.query_flags &
> > BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > > > +                     total_cnt +=
> > bpf_prog_array_length(effective);
> > > > > > > > > > > +             else
> > > > > > > > > > > +                     total_cnt +=
> > prog_list_length(progs);
> > > > > > > > > > > +     }
> > > > > > > > > > > +
> > > > > > > > > > > +     if (type != BPF_LSM_CGROUP)
> > > > > > > > > > > +             if
> > (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > > > > > > > > > +                     return -EFAULT;
> > > > > > > > > > > +     if (copy_to_user(&uattr->query.prog_cnt,
> > &total_cnt, sizeof(total_cnt)))
> > > > > > > > > > >               return -EFAULT;
> > > > > > > > > > > -     if (attr->query.prog_cnt == 0 || !prog_ids ||
> > !cnt)
> > > > > > > > > > > +     if (attr->query.prog_cnt == 0 || !prog_ids ||
> > !total_cnt)
> > > > > > > > > > >               /* return early if user requested only
> > program count + flags */
> > > > > > > > > > >               return 0;
> > > > > > > > > > > -     if (attr->query.prog_cnt < cnt) {
> > > > > > > > > > > -             cnt = attr->query.prog_cnt;
> > > > > > > > > > > +
> > > > > > > > > > > +     if (attr->query.prog_cnt < total_cnt) {
> > > > > > > > > > > +             total_cnt = attr->query.prog_cnt;
> > > > > > > > > > >               ret = -ENOSPC;
> > > > > > > > > > >       }
> > > > > > > > > > >
> > > > > > > > > > > -     if (attr->query.query_flags &
> > BPF_F_QUERY_EFFECTIVE) {
> > > > > > > > > > > -             return
> > bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > > > > > > > > -     } else {
> > > > > > > > > > > -             struct bpf_prog_list *pl;
> > > > > > > > > > > -             u32 id;
> > > > > > > > > > > +     for (atype = from_atype; atype <= to_atype;
> > atype++) {
> > > > > > > > > > > +             if (total_cnt <= 0)
> > > > > > > > > > > +                     break;
> > > > > > > > > > >
> > > > > > > > > > > -             i = 0;
> > > > > > > > > > > -             hlist_for_each_entry(pl, progs, node) {
> > > > > > > > > > > -                     prog = prog_list_prog(pl);
> > > > > > > > > > > -                     id = prog->aux->id;
> > > > > > > > > > > -                     if (copy_to_user(prog_ids + i,
> > &id, sizeof(id)))
> > > > > > > > > > > -                             return -EFAULT;
> > > > > > > > > > > -                     if (++i == cnt)
> > > > > > > > > > > -                             break;
> > > > > > > > > > > +             progs = &cgrp->bpf.progs[atype];
> > > > > > > > > > > +             flags = cgrp->bpf.flags[atype];
> > > > > > > > > > > +
> > > > > > > > > > > +             effective =
> > rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > > > +
> > lockdep_is_held(&cgroup_mutex));
> > > > > > > > > > > +
> > > > > > > > > > > +             if (attr->query.query_flags &
> > BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > > > +                     cnt =
> > bpf_prog_array_length(effective);
> > > > > > > > > > > +             else
> > > > > > > > > > > +                     cnt = prog_list_length(progs);
> > > > > > > > > > > +
> > > > > > > > > > > +             if (cnt >= total_cnt)
> > > > > > > > > > > +                     cnt = total_cnt;
> > > > > > > > > > > +
> > > > > > > > > > > +             if (attr->query.query_flags &
> > BPF_F_QUERY_EFFECTIVE) {
> > > > > > > > > > > +                     ret =
> > bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > > > > > > > > +             } else {
> > > > > > > > > > > +                     struct bpf_prog_list *pl;
> > > > > > > > > > > +                     u32 id;
> > > > > > > > > > > +
> > > > > > > > > > > +                     i = 0;
> > > > > > > > > > > +                     hlist_for_each_entry(pl, progs,
> > node) {
> > > > > > > > > > > +                             prog = prog_list_prog(pl);
> > > > > > > > > > > +                             id = prog->aux->id;
> > > > > > > > > > > +                             if
> > (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > > > > > > > > > +                                     return -EFAULT;
> > > > > > > > > > > +                             if (++i == cnt)
> > > > > > > > > > > +                                     break;
> > > > > > > > > > > +                     }
> > > > > > > > > > >               }
> > > > > > > > > > > +
> > > > > > > > > > > +             if (prog_attach_flags)
> > > > > > > > > > > +                     for (i = 0; i < cnt; i++)
> > > > > > > > > > > +                             if
> > (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> > > > > > > > > > > +                                     return -EFAULT;
> > > > > > > > > > > +
> > > > > > > > > > > +             prog_ids += cnt;
> > > > > > > > > > > +             total_cnt -= cnt;
> > > > > > > > > > > +             if (prog_attach_flags)
> > > > > > > > > > > +                     prog_attach_flags += cnt;
> > > > > > > > > > >       }
> > > > > > > > > > >       return ret;
> > > > > > > > > > >  }
> > > > > > > > > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > > > > > > > > index 5ed2093e51cc..4137583c04a2 100644
> > > > > > > > > > > --- a/kernel/bpf/syscall.c
> > > > > > > > > > > +++ b/kernel/bpf/syscall.c
> > > > > > > > > > > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const
> > union bpf_attr *attr)
> > > > > > > > > > >       }
> > > > > > > > > > >  }
> > > > > > > > > > >
> > > > > > > > > > > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > > > > > > > > > > +#define BPF_PROG_QUERY_LAST_FIELD
> > query.prog_attach_flags
> > > > > > > > > > >
> > > > > > > > > > >  static int bpf_prog_query(const union bpf_attr *attr,
> > > > > > > > > > >                         union bpf_attr __user *uattr)
> > > > > > > > > > > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const
> > union bpf_attr *attr,
> > > > > > > > > > >       case BPF_CGROUP_SYSCTL:
> > > > > > > > > > >       case BPF_CGROUP_GETSOCKOPT:
> > > > > > > > > > >       case BPF_CGROUP_SETSOCKOPT:
> > > > > > > > > > > +     case BPF_LSM_CGROUP:
> > > > > > > > > > >               return cgroup_bpf_prog_query(attr, uattr);
> > > > > > > > > > >       case BPF_LIRC_MODE2:
> > > > > > > > > > >               return lirc_prog_query(attr, uattr);
> > > > > > > > > > > @@ -4066,6 +4067,7 @@ static int
> > bpf_prog_get_info_by_fd(struct file *file,
> > > > > > > > > > >
> > > > > > > > > > >       if (prog->aux->btf)
> > > > > > > > > > >               info.btf_id = btf_obj_id(prog->aux->btf);
> > > > > > > > > > > +     info.attach_btf_func_id =
> > prog->aux->attach_btf_id;
> > > > > > > > > > Note that exposing prog->aux->attach_btf_id only may not
> > be enough
> > > > > > > > > > unless it can assume info.attach_btf_id is always
> > referring to btf_vmlinux
> > > > > > > > > > for all bpf prog types.
> > > > > > > > >
> > > > > > > > > We also export btf_id two lines above, right? Btw, I left
> > a comment in
> > > > > > > > > the bpftool about those btf_ids, I'm not sure how resolve
> > them and
> > > > > > > > > always assume vmlinux for now.
> > > > > > > > yeah, that btf_id above is the cgroup-lsm prog's btf_id
> > which has its
> > > > > > > > func info, line info...etc.   It is not the one the
> > attach_btf_id correspond
> > > > > > > > to.  attach_btf_id refers to either aux->attach_btf or
> > aux->dst_prog's btf (or
> > > > > > > > target btf id here).
> > > > > > > >
> > > > > > > > It needs a consensus on where this attach_btf_id, target btf
> > id, and
> > > > > > > > prog_attach_flags should be.  If I read the patch 7 thread
> > correctly,
> > > > > > > > I think Andrii is suggesting to expose them to userspace
> > through link, so
> > > > > > > > potentially putting them in bpf_link_info.  The
> > bpf_prog_query will
> > > > > > > > output a list of link ids.  The same probably applies to
> > > > > > >
> > > > > > > Yep and I think it makes sense because link is representing one
> > > > > > > specific attachment (and I presume flags can be stored inside
> > the link
> > > > > > > itself as well, right?).
> > > > > > >
> > > > > > > But if legacy non-link BPF_PROG_ATTACH is supported then using
> > > > > > > bpf_link_info won't cover legacy prog-only attachments.
> > > > > >
> > > > > > I don't have any attachment to the legacy apis, I'm supporting
> > them
> > > > > > only because it takes two lines of code; we can go link-only if
> > there
> > > > > > is an agreement that it's inherently better.
> > > > > >
> > > > > > How about I keep sys_bpf(BPF_PROG_QUERY) as is and I do a loop
> > in the
> > > > > > userspace (for BPF_LSM_CGROUP only) over all links
> > > > > > (BPF_LINK_GET_NEXT_ID) and will find the the ones with matching
> > prog
> > > > > > ids (BPF_LINK_GET_FD_BY_ID+BPF_OBJ_GET_INFO_BY_FD)?
> > > > > >
> > > > > > That way we keep new fields in bpf_link_info, but we don't have to
> > > > > > extend sys_bpf(BPF_PROG_QUERY) because there doesn't seem to be
> > a good
> > > > > > way to do it. Exporting links via new link_fds would mean we'd
> > have to
> > > > > > support BPF_F_QUERY_EFFECTIVE, but getting an effective array of
> > links
> > > > > > seems to be messy. If, in the future, we figure out a better way
> > to
> > I don't see a clean way to get effective array from one individual
> > link[_info] through link iteration.  effective array is the progs that
> > will be run at a cgroup and in such order.  The prog running at a
> > cgroup doesn't necessarily linked to that cgroup.
> 
> Yeah, that's the problem with exposing links via prog_info; getting an
> effective list is painful.
> 
> > If staying with BPF_PROG_QUERY+BPF_F_QUERY_EFFECTIVE to get effective
> > array
> > and if it is decided the addition should be done in bpf_link_info,
> > then a list of link ids needs to be output instead of the current list of
> > prog ids.  The old attach type will still have to stay with the list of
> > prog ids though :/
> 
> > It will be sad not to be able to get effective only for BPF_LSM_CGROUP.
> > I found it more useful to show what will be run at a cgroup and in such
> > order instead of what is linked to a cgroup.
> 
> See my hacky proof-of-concept below (on top of this series).
yeah. the PoC makes sense and I don't mind that considering
adding them to bpf_link_info (or bpf_prog_info) will be useful in
general even without this use case.

A quick thought is this is sort of partly going back to v6 but
just iterating different things instead of the bpf_lsm hooks.

> 
> I think if we keep prog_info as is (don't export anything new, don't
> export the list of links), iterating through all links on the host should
> work,
> right? We get prog_ids list (effective or not, doesn't matter), then we
> go through all the links and find the ones with with the same
> prog_id (we can ignore cgroup, it shouldn't matter). Then we can export
> attach_type/attach_btf_id/etc. If it happens to be slow in the future,
> we can improve with some tbd interface to get the list of links for cgroup
> (and then we'd have to care about effective list).
> 
> But the problem with going link-only is that I'd have to teach bpftool
> to use links for BPF_LSM_CGROUP and it brings a bunch of problems:
> * I'd have to pin those links somewhere to make them stick around
> * Those pin paths essentially become an API now because "detach" now
>   depends on them?
> * (right now it automatically works with the legacy apis without any
> changes)
It is already the current API for all links (tracing, cgroup...).  It goes
away (detach) with the process unless it is pinned.  but yeah, it will
be a new exception in the "bpftool cgroup" subcommand only for
BPF_LSM_CGROUP.

If it is an issue with your use case, may be going back to v6 that extends
the query bpf_attr with attach_btf_id and support both attach API ?
