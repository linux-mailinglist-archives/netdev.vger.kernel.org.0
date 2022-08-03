Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2195894E0
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238394AbiHCXff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiHCXfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:35:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06ED15FFF;
        Wed,  3 Aug 2022 16:35:30 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273M1cA5015108;
        Wed, 3 Aug 2022 16:35:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=iEPZS03HAMyMGaW3tu+nLCWFja8CUm3U8gxlkeR/SVQ=;
 b=hdUXF58Gt88hcOvifqoe0OV7d1NqIiKiv8HRTDCfbqq7RrPqU3uy3fye6RFQcuvguidY
 CqlRGmwSZnonXjNWXIc++A4PF1IPqymn5GN4FZjp5dPQvKfAXgwSyxJnYJsBunFsCQkX
 dxPWlQ1AdWNZjviHljWTpA45bpdHe60cQCM= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hqty7kj6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 16:35:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6T5mk7NYqjUy5poCJoRfBILvBZNXafqCUT7V7p5dE5JEa/KpApyL9y/HvzpRwxzZta71EA2F/9BB307uLewsQ78b1etXp7mz9amF1KsOrb+JLmErxKmIk4ogpTOJGIvGXKzLgk9bUthUoU1P5ka17S3FVnwbKipd2/oHKI1sxtI+FisueROpYmbsebLzlppI0Y4ieXTbYIL7fDV8C4s4ZqWNE4TIaG0UbuQXYxB0TitmYli+30B8h2dIRwrGdUM7yTArM1kcyiaDzt/7Tfpbw8fD5dxKXuv+IeU3ltFWL5zKIYbAqhFXmOHM5oxaQYrWVVoUGCygJA4HUgB1N/tRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iEPZS03HAMyMGaW3tu+nLCWFja8CUm3U8gxlkeR/SVQ=;
 b=i80yMccKkavJGStlFmd6ETxXRpUiR40F/j3JY6cIuBM692UfEtZiywhpVi1nY9qJaE3YKvVIJnzt9i7Gj3SFiatwO8JnAjNPgG03J3xw71Lr5R6PLzHTYJLRrJXBbAmBycwh8yGrFA4hnfxdbIQB1VFlIHbqcGaEnL7Bgu0tArL4ktyr/mrlGiw1QcOXG/k0H4Uaxx26Gcm61y7hV3m9sAKXs2jbnBJjIHhA57NDo/QDk9kY1HLPFEUiJUj4vsUP7eTZPpWhjcPjmNVjlGa1e1e/FF3/vakFQF9r1OiDsslnPlrhm33Wi26BSGvTWAALuhwq7g+45qGVdNITzkmNoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB2362.namprd15.prod.outlook.com (2603:10b6:5:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 23:35:05 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 23:35:05 +0000
Date:   Wed, 3 Aug 2022 16:35:03 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 bpf-next 02/15] bpf: net: Avoid sk_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220803233503.3y5ophfqwng25vkr@kafai-mbp.dhcp.thefacebook.com>
References: <20220803204601.3075863-1-kafai@fb.com>
 <20220803204614.3077284-1-kafai@fb.com>
 <Yur9zosqo4zpVBx5@google.com>
 <20220803231921.nb623atry4qdrp5r@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBumw+-goDendFpcpzaq5u1ziJ97SUEQ5OwJKjbdtLDurA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBumw+-goDendFpcpzaq5u1ziJ97SUEQ5OwJKjbdtLDurA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::16) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5400328-3fc3-44f1-9922-08da75a8cb6e
X-MS-TrafficTypeDiagnostic: DM6PR15MB2362:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +njfYyyYgKWhrfIqC5dgjeNisdOodk29MpsjfUOp6+Unz8ZVx58qjXfcnqIMy/z09j9u1RuGykYG/jW/dZxwjJjNHpyCm3mKdQOMtnmern7L6XImEUvCEfS9z16o8maxxBiashf378i2RQ/nkSLwDugWNr9Gs8k6OTKuS0TfbArCPgmAV40oCjUekO1FgWFF3yW7FoaHiv0aSbS+uHWd/nEQnTmaeCLaT09kNGeP1FXqJERhOspUui0dgQkMkHIfn+7hRECvtU6fnZI0/Znn+qeM4pBcqKAQOpUt54Jjn1L0XjOvNTBPheLN9n8v4NSKq8Ee1CjW/pl38oMUkQEwtddcJ0KRZE2Ac2GYblz3DP6x2g6zF7NBVDCoPMTIbSqmNmmhYtzmJiGBX78zN/uVw+coK1bajyvPCPYtbaTtGA40m/RGAHnmrBZrlKw4j4wRVRBkYifLorSpVHBOtfD1zy3N+IalQhaDvK3jtXgcqiVAOhTtI1IjJefWvUj31na53h5XOdAmLHW/OthOAzBDnDqA9DnMm0nqIHaUwWINReyy8DfLrqUQR3V925BB/Ea4IsXPfgKOgRHKiRVT4wRovHsn/1h6TFhk17lt0HqDs8IUi4UgJuGtz0k75vmtAmian0Vguy8DjBBXT2OQBBQuCeJNVWju7OUtpbjCB3BHxcQTwRnnGC26TMn9R7KEZ8VrpX6sSNV2ai3RkB328i0/nRmT9wcppPTxMGJtWuz/cHun8+Qx9CHdJcO1fdNcA5SW2IeQZgMiU0q9zD/h22iuBkcAP2F5VX3zQJVTcl7njeI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(83380400001)(186003)(1076003)(9686003)(6506007)(52116002)(38100700002)(53546011)(5660300002)(316002)(6916009)(41300700001)(6512007)(2906002)(8676002)(54906003)(7416002)(86362001)(8936002)(66476007)(66556008)(66946007)(4326008)(6486002)(478600001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FpJMXQOlz70WAYkDHxZQ/LJxY6TLEM2Oc7+ecD1KGxRcDShNw8SeOW2hha9x?=
 =?us-ascii?Q?VmOBNoa5eCw5LqPAm6Ks/mF2G5CYY3mHMfhU6j7wyWS3+kkfdGo9vjgUhQpe?=
 =?us-ascii?Q?yI8hOt6KT1LXY+QG3t8FIIl0huZ5leu8HGdBCqeM+Jh/SkwHKinprjJTZj3P?=
 =?us-ascii?Q?E2+WTGtHCD66B4RGUcar/X+UIQVvaW7oOH5foi+EaRUOpPndWCN55foFyEFR?=
 =?us-ascii?Q?rfdAtBb5npJd1mMXjkCBaj73RzNrGsbsgmQdcKR8P1D7OPh2dy0BjV2OBvaL?=
 =?us-ascii?Q?uJ5AZOSphfokcDxZJQI2iO0URkIhS+85JhNCvw7gifLLGLNVpXA9Wa+8936T?=
 =?us-ascii?Q?pknCVzC+CGgVFVxw+XkMGcTBR07fg36KJ3vr2Br2WgEkLbGXwekSxyzGJwHp?=
 =?us-ascii?Q?0oMJsA3PhVdTaAOV0kNh6kcBcrNGeTw6I+7AU9HbhvD1dNJrLF0yOvIn2bD8?=
 =?us-ascii?Q?p/S6hFgv3ISlmlHYhfnhNrLFaUB2KevE1b/8WtxUgeLXiVmA42Nu4wNFiE/Y?=
 =?us-ascii?Q?bvslFLdAr1GS9uffR8CraOp/cJZt3bwEA3QcBqZ5FgGrKm2XOHm7heYIPi6Z?=
 =?us-ascii?Q?gURkR3zMbkiWAap9p52fSwBtRWWWOuKSRshopwd/z2nVkDNufnwPGZFeluZ2?=
 =?us-ascii?Q?+NFaB4QiHZhQHoWjbP62SsqRGUD4sm8rhkHcMMxEUI9wMHg95f584/s6bNVc?=
 =?us-ascii?Q?AMKx2o+7DAZlH5RCp6U7uuKKRnDNacrEWN5vkAW9zTa+MTYIxjbTuuPGshKk?=
 =?us-ascii?Q?GUuhhxGDl5YaGiTbrJUR2A5zQVDQL1g2dz2eUqgMPD0h7J07N93VWPGvCNVt?=
 =?us-ascii?Q?4zxJtbuUuT2+pzjPMEmewstZ3esq4Vjyyjr0kOUKwI8clcbPY6asdJMDWKU1?=
 =?us-ascii?Q?Niipon8+HAAbPLTjVaRLcCfJjwM9jzvqOuQiMGKjuWJRvROBMZpp6jHaRMyT?=
 =?us-ascii?Q?8VyRAcZdmqjHT1blI55DfSEYKa3bhHWu7KJUeOtZ77GJztU7tz5f3b3m0GW2?=
 =?us-ascii?Q?zK86U1BqMA9bhS7LVcYypLrQAZvsur+c3tbpm518iF5VYhOpYDBa3ttrlEtt?=
 =?us-ascii?Q?a46xCiGJ8uMuiJn8RCSLuWo13JOjee1HpAbYrKooZAp4CBuyBcPmcl2Nv5yD?=
 =?us-ascii?Q?O2qylAeM8/CDx9t3xPOJ+LZ+Hm1+X8K59RSzDq3ZzDAZBR1V2cTfw7Fj7+x2?=
 =?us-ascii?Q?z8FDrTH6DRRg+eMMaSV52/+6xKDHYVHjlr08QX3pXxhEY85cYIQFvIHn9Rep?=
 =?us-ascii?Q?M/gA5u7opcdgBjqZvmpBtbI48oQ37xWSvLQaqYV9P4XEYG+WWnpwPU1zghfH?=
 =?us-ascii?Q?1hc7cHGzzCYWweMCz5PEgXOWJjgg85NLZn8I1egR8OVCWKr4iHYd8mrpfnDs?=
 =?us-ascii?Q?A8fFbQVqwyjHSk50OU6kEM4hwukACWVhHDJ7vYXi7xobb4KeFksyGlPdE9hp?=
 =?us-ascii?Q?NJDNCD/hAdGtwBipiDP/o4315zUFM4ib4dGc6Fz3ILPK65FlfRI9FFsCOuCo?=
 =?us-ascii?Q?NsZV/oBVoYfx3CGeUVASo1yqOUfwPDfo9Lb/s4aLCBmbuwVKtCdPvOaVS2p6?=
 =?us-ascii?Q?wHf6VWj3dMvGdjj0slbOHt1lP2u9RFSn3/TXe1apG3lo0iiRXBoRK+Rwkcs0?=
 =?us-ascii?Q?Ow=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5400328-3fc3-44f1-9922-08da75a8cb6e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 23:35:05.5262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2vF/frxDjJ9Pwj9EA6RkZzbUzsF4HI/Zy+76zebexMgRPwKwMHw3d9O/ETOvzWU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2362
X-Proofpoint-ORIG-GUID: ipOn7E-_ZDMnwN6CbMkQlo393QREnluD
X-Proofpoint-GUID: ipOn7E-_ZDMnwN6CbMkQlo393QREnluD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_06,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 04:24:49PM -0700, Stanislav Fomichev wrote:
> On Wed, Aug 3, 2022 at 4:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Aug 03, 2022 at 03:59:26PM -0700, sdf@google.com wrote:
> > > On 08/03, Martin KaFai Lau wrote:
> > > > Most of the code in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > > > the sk_setsockopt().  The number of supported optnames are
> > > > increasing ever and so as the duplicated code.
> > >
> > > > One issue in reusing sk_setsockopt() is that the bpf prog
> > > > has already acquired the sk lock.  This patch adds a in_bpf()
> > > > to tell if the sk_setsockopt() is called from a bpf prog.
> > > > The bpf prog calling bpf_setsockopt() is either running in_task()
> > > > or in_serving_softirq().  Both cases have the current->bpf_ctx
> > > > initialized.  Thus, the in_bpf() only needs to test !!current->bpf_ctx.
> > >
> > > > This patch also adds sockopt_{lock,release}_sock() helpers
> > > > for sk_setsockopt() to use.  These helpers will test in_bpf()
> > > > before acquiring/releasing the lock.  They are in EXPORT_SYMBOL
> > > > for the ipv6 module to use in a latter patch.
> > >
> > > > Note on the change in sock_setbindtodevice().  sockopt_lock_sock()
> > > > is done in sock_setbindtodevice() instead of doing the lock_sock
> > > > in sock_bindtoindex(..., lock_sk = true).
> > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >   include/linux/bpf.h |  8 ++++++++
> > > >   include/net/sock.h  |  3 +++
> > > >   net/core/sock.c     | 26 +++++++++++++++++++++++---
> > > >   3 files changed, 34 insertions(+), 3 deletions(-)
> > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 20c26aed7896..b905b1b34fe4 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -1966,6 +1966,10 @@ static inline bool unprivileged_ebpf_enabled(void)
> > > >     return !sysctl_unprivileged_bpf_disabled;
> > > >   }
> > >
> > > > +static inline bool in_bpf(void)
> > > > +{
> > > > +   return !!current->bpf_ctx;
> > > > +}
> > >
> > > Good point on not needing to care about softirq!
> > > That actually turned even nicer :-)
> > >
> > > QQ: do we need to add a comment here about potential false-negatives?
> > > I see you're adding ctx to the iter, but there is still a bunch of places
> > > that don't use it.
> > Make sense.  I will add a comment on the requirement that the bpf prog type
> > needs to setup the bpf_run_ctx.
> 
> Thanks! White at it, is it worth adding a short sentence to
> sockopt_lock_sock on why it's safe to skip locking in the bpf case as
> well?
Yep. will do.

> Feels like the current state where bpf always runs with the locked
> socket might change in the future.
That likely will be from the sleepable bpf prog.
It can probably either acquire the lock in __bpf_setsockopt() before
calling sk_setsockopt() or flag the bpf_run_ctx to say the lock is not acquired.
The former should be more straight forward.
