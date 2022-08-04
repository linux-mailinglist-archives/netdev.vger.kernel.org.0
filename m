Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244F458A141
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240146AbiHDT3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240142AbiHDT3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:29:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AE26D9F5;
        Thu,  4 Aug 2022 12:29:48 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274IJ1VH001632;
        Thu, 4 Aug 2022 12:29:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Y7khCP4SBGO/wNbl5/VvfQHFiFhUlu6kXXUv0W0h31w=;
 b=MxYcGNZJkpvcysPE6N8mh6bUR401VWx5D5ViGWMbQh9LQpVdbMhIOkPhqsr1Ez4T+kQv
 X4KRo+E+TSjG0plPiOsJQDoO4ksRAs1abDprAPJBhN0qLVtbCUk3hdsRgsuC/0Cy4yjS
 Ykt1Qvwr38kukBKTYSXoqOhiHHVczZc7rH8= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hre6k3327-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 12:29:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBLVifhJ2Q9mtWW7w2/qAOFDG/rhQddcPDS0lQogJE6Tk5HqjGL9u8yYVEf1DSdvXKH4/kiGFRecaRNmXChhfwOQ5T1yQxWkuuLOFDFn/XWh1uV+wh4j8fFPR9osY5lkwVfr4qDyYkTWir2L1gcZs4QZzUH9j6RMq/+URVA/kZZGMGY0AbXkcw2QAmJ/d2QBBm34QtgzWFyQLBzHQCoiIg+qzJoDoL+RVL6mOqBp4AzCU85XIOZQV/mTRQMQJJXfvPJ7C+x+sM9OO9AsANTP4RxiT0gcrKo/Eqz7JrN3icVJiUs8JMZSnNNuC9P5lv+eBoO81o0GrCqTEfHzM94SkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7khCP4SBGO/wNbl5/VvfQHFiFhUlu6kXXUv0W0h31w=;
 b=lA7dO6IThl1wmmhk62zwAARxeMpV9XMbrGhRY6C2SmXmfn5UvcYYvlF1ZETAxmWpAG6LchsaHieOsa3rkbd88YRoJzfDLS28lsJLEpiGbH9SBHiFGSdH5O89c9ke9kpz2qihu8oPUMq+oh1aK4g+N55afyqB6ka4J9lNwoL0CYrQ/QzGJkVjew8X2Id6B1/R2lkIt0kH/kvX2lbtEEbdpFHZCH1wl1WUTTsHXzb0fGKFeA2sgyJO0lOP7Us2jkqc+ZbcBZGAv8iQ8zfLZTuZ0Ic0m20jKVBTnM4nu5vpCPesPrjESsR9rjnzbTjD/2EZL3hLiSIhJc+6Bz6OewvxDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by MN2PR15MB3453.namprd15.prod.outlook.com (2603:10b6:208:a4::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:29:26 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:29:25 +0000
Date:   Thu, 4 Aug 2022 12:29:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH v2 bpf-next 02/15] bpf: net: Avoid sk_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220804192924.xmj6k556prcqncvk@kafai-mbp.dhcp.thefacebook.com>
References: <20220803204601.3075863-1-kafai@fb.com>
 <20220803204614.3077284-1-kafai@fb.com>
 <CAEf4Bzb9js_4UFChVWOjw52ik5TmNJroF5bXSicJtxyNZH8k3A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb9js_4UFChVWOjw52ik5TmNJroF5bXSicJtxyNZH8k3A@mail.gmail.com>
X-ClientProxiedBy: BYAPR01CA0049.prod.exchangelabs.com (2603:10b6:a03:94::26)
 To MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 350ca2f6-478b-4f40-1f86-08da764fa44d
X-MS-TrafficTypeDiagnostic: MN2PR15MB3453:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQPv2EWXIrh8KMwQpfEFFErxw+wV+Kw59IVrxBq3ixWx+5AvWe4oFzoBTeUJEtMQvL1kaUEQSAOO0Qfp9JN/GJd1mhTiWgqeorjqioE89ELV9IO0BYyaD//nTZ941/mMw8htgUHk4Lbg13ZBMQ048Jj+4rwkKYLef2YaAC5j1VToq3nPxG21KS9FFluZxw0ffttYChIvuePhJDHFUbMcyj46Mtxacy0wHePF46wVuoXZSKZTG1mrvdTxH3JNIlzwqg42EHVEgLe0IMSs6BLylAl+aMdwW7BzePphfiXus6lp8pKzkfJkyKohVgjI9TAh4yvVkNLFGK1FuJYH41Fhd3b84F1TkIxjmRcn+iETxvBNxaZArA5R1W4daHiPrbgXw0LOOQ9DfQu/VcxJ9BJ19w0PvsE34zXfSSNKi66tn84FYkP+feQPON9jjtKveXykOwwFiVC/9nM7d7Q7r5zrStSGPIkeK6pUv+v9OrrrsGxQDvG3TPK9dTpxiDe9u7jYtYaq4obdS6GN5nSDpKal2lro35I3cBWeJh2qNzdFGF6xxj3zCz8wxcALaZlZc5R1SeuA0wl/k5Xf6siEG0A0TrRmRfYPxaMwEHdelU4PAFve4bXd1J6cCyaphtnq7Ql/UXzU/QVhdWwJGCVnUWk3CEz/FkHrI2jbIpxbuN/oGz1oT4264haXCyXO+9FayuPOWqClig1HQ9MW1onEBEqpPPhgyjBcdarJI9/OyEqePYMs2wkFRifMP50b7ycYzFDap95QEVfgF5lam0ytSNst8G+qFrGRboWyMPWdofbH0w8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(6486002)(53546011)(5660300002)(6512007)(9686003)(6506007)(52116002)(6916009)(54906003)(316002)(38100700002)(86362001)(41300700001)(186003)(1076003)(66946007)(478600001)(66556008)(66476007)(83380400001)(4326008)(7416002)(2906002)(8936002)(8676002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eZQVVxSqcOsqpL2/0XCvWKyi5p702tfPn/Sv35qbiq3x2IlB3xDe0ckkO2Ms?=
 =?us-ascii?Q?praApY/xOUsL0m91I/zdNHBj+/SqfL5hGpzW37aLTdNinT/VLX0WjI8ep3NM?=
 =?us-ascii?Q?++kRlbm+rZl9XG1PHBrpBaemSe05QcdvV5pae+BQWtEQ1cpK7005huvlDbIB?=
 =?us-ascii?Q?wveouuUQzBDgjEO4f8sC+UDnxANwkNMrTMh57MdzZMAVey5XGPsMWMeSnvOT?=
 =?us-ascii?Q?flx/YPVwKgNE4xEN3jx5gcHoyJaQ676uuFMueJGkSgh9W5vuYS9HIYPeOaw6?=
 =?us-ascii?Q?wt5nDWEsdfcPjrFlcWrolzG2PA6wXY/0ES7mYNTTo0DfjengY7wXh0Esx8mQ?=
 =?us-ascii?Q?m3GYHR1g7nN/FeuN8ViriEJmQ6k7GCHF/2MZ5T7zKb/5d+EugcHg7m5Y52Kw?=
 =?us-ascii?Q?S4A7RinIe0fFwPxSiIwsMSnOKevjC5z1z0EnA6hvJXMuc2HNabAfdNlELK4D?=
 =?us-ascii?Q?wlvo0012DgY3OEC/M9K5UjPFaqKKXEnPLiv3K7Tdf5PDEFu07kVrLmva/vsr?=
 =?us-ascii?Q?npHCXk+9HZBOLPFaYkOMixtTC1jB0ilyUP62WMjCvu6JIYsbwvyamLoXyOS6?=
 =?us-ascii?Q?UMz7UefeUpkPhc5OgoDe4kP9WB/T75hJTq5Ts0HUtEYmO233JM5apYumvbHE?=
 =?us-ascii?Q?tPUkgVpDqgKq3apISfPtszHe3LitLvk5uTFpUzJCuOnuLRjS2zkeLydEwFyP?=
 =?us-ascii?Q?oCQU2idoG7CKSqkOWpY2Rl0a3bINfTPN/yg8ZQ3Kj4FXtkBs0zz/6cXcRV4U?=
 =?us-ascii?Q?RsX7ZdKzBgFnyzaYtSm6IJ4mJg17C01oB9bfk9WpP7i+QpN18EMmGfgTxYJW?=
 =?us-ascii?Q?j+BlHg8IMlMPsv6O/j2qSe+MJ5Z04Ve83zrbETdRCOkoTetvT2Bgza6oSlLu?=
 =?us-ascii?Q?1YxXAxl2nMdqxHubIzidf4efwfw9GXXoKihL5REz/KUCvvnv37KgqSwYUVpn?=
 =?us-ascii?Q?oSHpVuS/MNR9ZVdOmK2wvmParCYoZK+Zo3nvFYzjn9RtPyBPhybwWQmaep06?=
 =?us-ascii?Q?Tn0rUJm1enqpSB68RJb4Vhti1Rc7vj84wEYzRS6CGdCn24VucMm/3eO1Upct?=
 =?us-ascii?Q?TuDWW+x0o+kCu3mHVZdQdCiD04YBgsZlbhEGgzc12qZU2FJSASmyF7KxQd3p?=
 =?us-ascii?Q?WScbAvGFfipTCh0I6ccpwelDPD5JWYiiC5ygIOxgGANawUcLx6RiDorX5OdN?=
 =?us-ascii?Q?rHxh5rNQR4kznjrZbRQprrD6S2KJPuwO00lutpzi/AmaafCvx6S/Wd4GcYDd?=
 =?us-ascii?Q?R/Mv/XSMOsrrgu9XKGC0wTmUzBgLgRE2qMj8jfdssNfmrGyoxtjNXqtpLo3L?=
 =?us-ascii?Q?Llt0WmG69KxNIHYP6hSJOl/iOFAw3weMzub0wu3xxg8um9TCYYY08veZK43K?=
 =?us-ascii?Q?65SAuQ7wld7lDBhej9gOWx0oIjID+ladGZk+TWJA2zfwgqD4SuxoqWMsdeRa?=
 =?us-ascii?Q?G2ha9p4Zk8ey5LzqrHqB2fUSzQ6DgIU6JckHAw1icrsGYPz/d2Cj+KLZspkG?=
 =?us-ascii?Q?4xelZw6fQDb4/pQ34jcou271r/Tkmqo/b+NycbAeN36wPKUDIECwjpwdIgM1?=
 =?us-ascii?Q?2n7MMRxhaUq9DTuY12un6j1eeTXFmyyoalQAU+pAsZoz5JAGSLl6gD+wme/2?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350ca2f6-478b-4f40-1f86-08da764fa44d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:29:25.8451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vg51u5g6xRYEx4P9Etqk2JGwP8XTumLiPYKplC2KaHfZc+eD0zcZvmJHJiAjriir
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3453
X-Proofpoint-ORIG-GUID: LyNG-I3NMHOQz5ufh4oWTmyme7KYPkOd
X-Proofpoint-GUID: LyNG-I3NMHOQz5ufh4oWTmyme7KYPkOd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 12:03:04PM -0700, Andrii Nakryiko wrote:
> On Wed, Aug 3, 2022 at 1:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > Most of the code in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > the sk_setsockopt().  The number of supported optnames are
> > increasing ever and so as the duplicated code.
> >
> > One issue in reusing sk_setsockopt() is that the bpf prog
> > has already acquired the sk lock.  This patch adds a in_bpf()
> > to tell if the sk_setsockopt() is called from a bpf prog.
> > The bpf prog calling bpf_setsockopt() is either running in_task()
> > or in_serving_softirq().  Both cases have the current->bpf_ctx
> > initialized.  Thus, the in_bpf() only needs to test !!current->bpf_ctx.
> >
> > This patch also adds sockopt_{lock,release}_sock() helpers
> > for sk_setsockopt() to use.  These helpers will test in_bpf()
> > before acquiring/releasing the lock.  They are in EXPORT_SYMBOL
> > for the ipv6 module to use in a latter patch.
> >
> > Note on the change in sock_setbindtodevice().  sockopt_lock_sock()
> > is done in sock_setbindtodevice() instead of doing the lock_sock
> > in sock_bindtoindex(..., lock_sk = true).
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/bpf.h |  8 ++++++++
> >  include/net/sock.h  |  3 +++
> >  net/core/sock.c     | 26 +++++++++++++++++++++++---
> >  3 files changed, 34 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 20c26aed7896..b905b1b34fe4 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1966,6 +1966,10 @@ static inline bool unprivileged_ebpf_enabled(void)
> >         return !sysctl_unprivileged_bpf_disabled;
> >  }
> >
> > +static inline bool in_bpf(void)
> 
> I think this function deserves a big comment explaining that it's not
> 100% accurate, as not every BPF program type sets bpf_ctx. As it is
> named in_bpf() promises a lot more generality than it actually
> provides.
> 
> Should this be named either more specific has_current_bpf_ctx() maybe?
Stans also made a similar point on this to add comment.
Rename makes sense until all bpf prog has bpf_ctx.  in_bpf() was
just the name it was used in the v1 discussion for the setsockopt
context.

> Also, separately, should be make an effort to set bpf_ctx for all
> program types (instead or in addition to the above)?
I would prefer to separate this as a separate effort.  This set is
getting pretty long and the bpf_getsockopt() is still not posted.

If you prefer this must be done first, I can do that also.
