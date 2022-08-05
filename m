Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3700658A42E
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 02:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiHEA3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 20:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbiHEA3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 20:29:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A371D0FE;
        Thu,  4 Aug 2022 17:29:41 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274MOBDv011105;
        Thu, 4 Aug 2022 17:29:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=j7/On0FV51ueUczMDgcDRGKJC5jJuOL4URhH+Ev3UHE=;
 b=BipvFy42nzuqDOWKASUaMjwvjBCVy9w1lNWOIWRYSZ+MPBAWQ7Xau1eZt9/Z4JDOsP3k
 yttyJt558xlw/S/19dBZ1sgPq59eRRGAB9lP9f08hFWG6q0V9Rs/592t7NmAU19iop2h
 7M7sYFjSWpxf31N2Ddj9DiK9Vi5awPJfBw0= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hrfvf3y1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 17:29:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWT4Z3sgwOGoIfaBxQKNQoVqqtM7OtnIdrOcL1aTwwpC3UBOAU3Ge6rXWYyQWxejxVw0lW+VQ0aHyWbkwtYrje1ybL8xBv7G+8IUG8LLH9uPbwgEqL37h3QwovNaMe+zujCle6jv+711mYfbxqpygr8jaKbO9nxbPltd1/pRfY39Og62rFfl2sS9TRAsdvtVTkQmCqRV/c4NVV3KjAYopK+e/McPWKSpJpW/DQXZPS3qTEW3feuu7iQoPdBaTDYyqE+vivAq4w2FhBjj0wkql1UfryVol0H3yOxIjG1R7EC0mTGd5OWd/LOyZZWd9h1gBbMtZ3BK5mxjNgJHhthezw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7/On0FV51ueUczMDgcDRGKJC5jJuOL4URhH+Ev3UHE=;
 b=d7DPXCaNb5va5TJzK0G7DOKHor75IN0hhdrzGpATYJ6+yaUrN1Xd2uFvX2VUexiZ3pAg+vkuNNJrv/5F51w2wpnxaaD2dMGbUOU7jllvahuZNeQd5J9hwa824v7FfMeEnQY5Ju4a+9+CTrw6dO5NzNbrGU2tOq/lXHq/i3UoF0tLsViW1G0nDyOSZ81OXphG9givTx6bGF2Ty/29+qjuDF8kqrj6s0Ak92qYx4nsewjm4dE062HAPODTZLKxNr3vyFY9MXmedaUNNUhIrAt0kJp09W5R722mtLtM/wYjXdAejmL559Or5SOrmzlIFn4I6z8h6vrmDv2rjpz38U1Ynw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB3831.namprd15.prod.outlook.com (2603:10b6:5:2b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 00:29:21 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 00:29:21 +0000
Date:   Thu, 4 Aug 2022 17:29:18 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: Universally available bpf_ctx WAS: Re: [PATCH v2 bpf-next 02/15]
 bpf: net: Avoid sk_setsockopt() taking sk lock when called from bpf
Message-ID: <20220805002918.l23wcmezgtmpcjxf@kafai-mbp.dhcp.thefacebook.com>
References: <20220803204601.3075863-1-kafai@fb.com>
 <20220803204614.3077284-1-kafai@fb.com>
 <CAEf4Bzb9js_4UFChVWOjw52ik5TmNJroF5bXSicJtxyNZH8k3A@mail.gmail.com>
 <20220804192924.xmj6k556prcqncvk@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZiuguQcV4qj_P7AA16O8e9QrvLRgvBbvWeMqnXdJfxoA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZiuguQcV4qj_P7AA16O8e9QrvLRgvBbvWeMqnXdJfxoA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0267.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::32) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11f67c1d-c76a-410d-2e40-08da76798a22
X-MS-TrafficTypeDiagnostic: DM6PR15MB3831:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0U5WUZV89pLWkGxDuGF4pis4k4EukYkXug1IwakfLPYX9dkqxFThhKf3Ps+er/G3acbRzfFShB2LoKCnZWa+oYuYvRct8YKWAEVoDe59QNjUnBmNvNG7GGc/Z7yPEbiQFgxy6rFLiF7SXYWKCKKVr/8JE3hSURovhbvOwluyrPMebKYM3D4v8S8qP+euTJpmyIRIAcDYRAVB0c8iKb9Xs2cPSbwnhAihMtcJ0cDpI5D55AKe/MgAuW581LdA4dCvybBIUcDf/yMAVTUOdUlgWFMNinSqRPAAIrWCpycOf9SYg7f6DRejm47pSrikql1+pmrftAp8k+r/6qwkqCIE/ASmuXz6uEB0CELh4zK/LltSco9K0ZpZ6/6D0wJUYg2THcIIqaQprpP5Itr/bIs0Yz0mpu3iyrVfjIgZQd3X8IN1ZcrtwI4BOOyIj/q9XQDpReeTsKH8spYlMd7K33GFbcscIBCLm5G5qfWNmXgFqW4R0z73UvpXakmt0uM/Z7kjG4MrugSSJG0ZG/drVTBUIRb1EwpmefXXwYoOF1g3kAef77MvjymefrjFEZeyUWo9aPUr6zvQL8eb3vD2l9fBniGO7DcZm3xeM3JlTwkAj7YbvV0yWtYWK31G3kEkSl10ZA9g1pHfUmuPUBf8uh6AMA9ZBSNOwLPx8lgzmAf9l0pGQdT3WqFBuAsJ626xkrp3o+8Bcp+UPOOlZiHBdpLZejeNbIULwnOP1D39WV2kHahzWdQr4bRVSeGaFlD053i1AH1WVTy9SiXHTerUfjMsfQ1AZAmfB64DpN7tfGbAWs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(4326008)(8676002)(66556008)(5660300002)(8936002)(66476007)(66946007)(54906003)(6916009)(7416002)(478600001)(41300700001)(6486002)(316002)(2906002)(6666004)(9686003)(1076003)(6512007)(83380400001)(53546011)(186003)(52116002)(6506007)(38100700002)(86362001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MPX+cR8EPg0EjYS6lNSKo6au3InLBlgN4GjS2l5rmgtCGorEvdZcrSu+18AI?=
 =?us-ascii?Q?pN35ybLQ6wE0+nEBT12AdUiBRpHeu88J/GYYDQiufMdW9i6T7Bad4F7TVa46?=
 =?us-ascii?Q?OypFmhTFdaKzQBEwh8bxzjJAd7f63hnK0XDdBgrN/pjUUTMoMG1OuRxRXk6t?=
 =?us-ascii?Q?nn4D1ZpWiQ6da7CXGkKrpFYAoUkiHkY4Ke6lRliWP3GbDLGmHtJjErNpYDjt?=
 =?us-ascii?Q?lQ8ysdf6MeyDxYHky40lnh+iSRw6B7PfEi58OB8w0z0/JthwlQJuLoy8jWnl?=
 =?us-ascii?Q?7Hk4P16OwG0YiQQiJnoSMeBAFKq63gLRC/q9SHoR+lwDhf6b6VRgFiY6NYUG?=
 =?us-ascii?Q?Lo6xDoAvQ0Oh83cCuEksyQgXD5doPGCeJuQP4S9kL0NngcTQ7v1Hf1XSRdMP?=
 =?us-ascii?Q?UlwTZX7ybVAw0EOb/FPgtzz0aoBY759agGaQW9WhB/gijyU5yrpo3vTyun5q?=
 =?us-ascii?Q?JYxGVzA5m7S+Jg7qUl54XRcS0OzJBjTbiHHWekDH6n+8F59cjJBp7ZuHgF1X?=
 =?us-ascii?Q?Mq+aO4ChV/QlaBbnaMWo8HWkJNi2lWkVEWGhrEaqnVbXhri0rIc1l0K3U0+r?=
 =?us-ascii?Q?kLsdl/s5y0GOR4qRtNGOh/7xd8BUXK6MYHtwEKYlXDTs99S2lJR4iDCmjUpR?=
 =?us-ascii?Q?u3McuhrNS1eg7gzVBYyhs171nwCuGBUEkP/9UHKLB4mF1+/Jdezkf1DEmN/R?=
 =?us-ascii?Q?FuyfT+Nc/W4PXuozxCGGbJB7elKILJ6WouowvPQAGp6KpeT4XwuJoHKe8XIt?=
 =?us-ascii?Q?8sNh02k/qSehec0iwf96kr077bJN6mhQAG3lIqgWHWFxUqV0H7cqjJ1e6vqO?=
 =?us-ascii?Q?jWyuQz/xYPnz/SPvHAHssaCJFA/X5okfLT0Nc4BBu82A63eTj4IsA58OmrlR?=
 =?us-ascii?Q?dn0102yHtpWCiAGFMOgHL9/G30YY4FOyDFTupwTKHzsxy6pSQtsdGy25SfEx?=
 =?us-ascii?Q?uLv0owA3KHTdIFzHfJw8SxnulPKSgYEfg1bD/tFS361mPrW+UaM3hOzE6J5V?=
 =?us-ascii?Q?7dDp2cfDL6EmjsEIQGPMuI0K1wKnRKORvXBnYzAtsvlhV3Cx+slFmZFH/o+Y?=
 =?us-ascii?Q?RivDgbrsZ25l7G1pZgD2hFTOxfZMCzSBW2LgwYXDs3wruGN0WDb2GHj0RXn7?=
 =?us-ascii?Q?m2qqnw/Vs/peHar7XefTFDaGDHKSZScaMu5nDoUApMzCUOFUlnyKHauIBlff?=
 =?us-ascii?Q?dHc9rPnkVjhk3RX4cGzsTB2WDjFms367aAQN+eBkJqB2I4cPgv+WPgWePksQ?=
 =?us-ascii?Q?3VR3pXYYbIZQPHyOHpel9V6kZQOL50GbvlsbYCmRUeCnHeOsSU3gKjKks0SI?=
 =?us-ascii?Q?WAfDSjdDDZhTxxLDI8wmUYTnYpjhfw9ygPGTHUIx9TG2ommGNIkhZBPoC+BR?=
 =?us-ascii?Q?JXninW73ioucqL8WWeCpwv7UDE1TQN3umGCD15f+t4jMLEm4jmGg0Ehwbdrp?=
 =?us-ascii?Q?epGR1FYrHiBWsIwD/sPGUC8zjkDLftZyNjfKYQ27D6YBDumdOMFoJos/SOR6?=
 =?us-ascii?Q?paLrEKtf45duzbPrnu5aAZOJGUhpiFGH6lticblh8ABYBPhXGEQdIuqRKsVm?=
 =?us-ascii?Q?42nt0uCD7VBpUUnBtsnFRF3BmuHbonJmxQu+vTCdM7J8lIfLgFtm1mYcrqJA?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f67c1d-c76a-410d-2e40-08da76798a22
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 00:29:20.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bT590BQzumFtb87tzb7E3lWn62qdTVVnO/dQi6zVBS2L2W9bBsmMIYjJLFtvhMiX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3831
X-Proofpoint-GUID: vtS6RNFw4rWs_3KQJo0UvXWgbPIZCKK-
X-Proofpoint-ORIG-GUID: vtS6RNFw4rWs_3KQJo0UvXWgbPIZCKK-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_06,2022-08-04_02,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 01:51:12PM -0700, Andrii Nakryiko wrote:
> On Thu, Aug 4, 2022 at 12:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Aug 04, 2022 at 12:03:04PM -0700, Andrii Nakryiko wrote:
> > > On Wed, Aug 3, 2022 at 1:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > Most of the code in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > > > the sk_setsockopt().  The number of supported optnames are
> > > > increasing ever and so as the duplicated code.
> > > >
> > > > One issue in reusing sk_setsockopt() is that the bpf prog
> > > > has already acquired the sk lock.  This patch adds a in_bpf()
> > > > to tell if the sk_setsockopt() is called from a bpf prog.
> > > > The bpf prog calling bpf_setsockopt() is either running in_task()
> > > > or in_serving_softirq().  Both cases have the current->bpf_ctx
> > > > initialized.  Thus, the in_bpf() only needs to test !!current->bpf_ctx.
> > > >
> > > > This patch also adds sockopt_{lock,release}_sock() helpers
> > > > for sk_setsockopt() to use.  These helpers will test in_bpf()
> > > > before acquiring/releasing the lock.  They are in EXPORT_SYMBOL
> > > > for the ipv6 module to use in a latter patch.
> > > >
> > > > Note on the change in sock_setbindtodevice().  sockopt_lock_sock()
> > > > is done in sock_setbindtodevice() instead of doing the lock_sock
> > > > in sock_bindtoindex(..., lock_sk = true).
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >  include/linux/bpf.h |  8 ++++++++
> > > >  include/net/sock.h  |  3 +++
> > > >  net/core/sock.c     | 26 +++++++++++++++++++++++---
> > > >  3 files changed, 34 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 20c26aed7896..b905b1b34fe4 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -1966,6 +1966,10 @@ static inline bool unprivileged_ebpf_enabled(void)
> > > >         return !sysctl_unprivileged_bpf_disabled;
> > > >  }
> > > >
> > > > +static inline bool in_bpf(void)
> > >
> > > I think this function deserves a big comment explaining that it's not
> > > 100% accurate, as not every BPF program type sets bpf_ctx. As it is
> > > named in_bpf() promises a lot more generality than it actually
> > > provides.
> > >
> > > Should this be named either more specific has_current_bpf_ctx() maybe?
> > Stans also made a similar point on this to add comment.
> > Rename makes sense until all bpf prog has bpf_ctx.  in_bpf() was
> > just the name it was used in the v1 discussion for the setsockopt
> > context.
> >
> > > Also, separately, should be make an effort to set bpf_ctx for all
> > > program types (instead or in addition to the above)?
> > I would prefer to separate this as a separate effort.  This set is
> > getting pretty long and the bpf_getsockopt() is still not posted.
> 
> Yeah, sure, I don't think you should be blocked on that.
> 
> >
> > If you prefer this must be done first, I can do that also.
> 
> I wanted to bring this up for discussion. I find bpf_ctx a very useful
> construct, if we had it available universally we could use it
> (reliably) for this in_bpf() check, we could also have a sleepable vs
> non-sleepable flag stored in such context and thus avoid all the
> special handling we have for providing different gfp flags, etc.
> 
> But it's not just up for me to decide if we want to add it for all
> program types (e.g., I wouldn't be surprised if I got push back adding
> this to XDP). Most program types I normally use already have bpf_ctx
> (and bpf_cookie built on top), but I was wondering what others feel
> regarding making this (bpf_ctx in general, bpf_cookie in particular)
> universally available.
It may be easier to reason to add bpf_ctx with a use case.
Like networking prog, the cgroup-bpf (for storage and retval) and the
struct_ops (came automatically from the trampoline but finally become
useful in setsockopt here).

I don't think other network prog types have it now.  For sleepable or not,
I am not sure if those other network programs will ever be sleepable.
tc-bpf cannot call setsockopt also.

> 
> So please proceed with your changes, I just used your patch as an
> anchor for this discussion :)
+1
