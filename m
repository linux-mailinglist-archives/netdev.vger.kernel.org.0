Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CA058442C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiG1Qb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiG1Qbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:31:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802FD743FA;
        Thu, 28 Jul 2022 09:31:27 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26SCwDCu020264;
        Thu, 28 Jul 2022 09:31:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=I9F1sAIBPEMI3fgxUl1RMgNKDpPUL/tiQwkcuE/2NpU=;
 b=OpPWxE0VxUeX2pjcRTHHuufbsnU5hTseJPr/sR1cdQdfZzqfu+KRqR6Bc9XX39maaC1r
 DUdIYOz33yHChCguNU7+ztXsz2qq8q3858iwAkhkEfMKY98+Z60OzK+/6rdk9z5ASeyc
 E5vHkQnM1e4Ck9x7AnzIEuMEoIFLEzJ980k= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hkjkmuxe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 09:31:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/0f1l/nkjL8F+tZMeBK9PTu+JWMi9fMVSHUzc01SoZS29PiZbfJxnJaaEvZHjSMVB1S3FOtHVpxkXQHR00JA7UEDNTHnFRRXtnOlI5Z+rry02NuilDB5u1/w8qLctq+ynSF4rlHuMnoaG/4pqHYX1VjAzV2c6C5E0aWdC6Uj/rSubTN4Wz2lvZqx2KKJTZCVF54jnn+C9MMZjDbudwrEOBj2xzoCb/XoJKDgJLthZfo2ZA1Ae6QZ+Hz10iu9LQGAhgDwmAPOTqkQMc74dtjeGYyy7yS4npSEc/xoDqgIO2nch2Xw8MAwzgrd3Mbq/VKylEZEHPdl6D9LKyYfist9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9F1sAIBPEMI3fgxUl1RMgNKDpPUL/tiQwkcuE/2NpU=;
 b=amydejLsafu0B1XDU+ZZKfBrakCCoOchPQqxnARIEBXOO5bxpezIrhka8MtgmL5QR9mS9mU8LO15wt5XLbVeXrTLajW0MDie9Ro3kMpHdzw+IkyJUfjNwQTa2l6KSq1SKIksdjAA8/pJZaOT+60BqmYtyynwqaCeV0Y3zy0z+SKgkP/wkpcyDVuF5kOOPJVm/YuJb8L6iHq/jz8ole5sDG/aa7MgmKatddS/AXVqRd2PMg8dbkSloeLRiN5BPe08tLOfz63bx/EdBz59Z6Zla8c7KimCv8OESbMylbD7wQ+8TGmviKo5Wt7drxJHolgl1divCl4Blg2x60f0yvX74Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by MW3PR15MB3961.namprd15.prod.outlook.com (2603:10b6:303:44::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 16:31:07 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Thu, 28 Jul 2022
 16:31:07 +0000
Date:   Thu, 28 Jul 2022 09:31:04 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220728163104.usdkmsxjyqwaitxu@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060909.2371812-1-kafai@fb.com>
 <YuFsHaTIu7dTzotG@google.com>
 <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
 <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
 <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
 <20220727184903.4d24a00a@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727184903.4d24a00a@kernel.org>
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4a510e4-5c96-4ebf-a569-08da70b6927e
X-MS-TrafficTypeDiagnostic: MW3PR15MB3961:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9uJ84U7UuATkTpqmd0hoUTjWDgsLps5ZXx3U38tFJDptvfrwQ2CF1Nw5K4E9xr6yvFsp/UQgHRZBSLv3SRnCMKugnfKIc8mHwl2GvFi9ODzOgPpnDx0wJwqTjJobiSVWKbTJjuU6QD+LeMZ781qPumXKdiwJBdJuTsd1EvWuwJtSrpAqyoASmz34wGnblZxzYXXWnypBS3qXUp7ByUhY0V8x++VMMQGI9MTxqgly5OX4tIgYTEDI/kPvXj0mdw069VdjBTAB7zseQ3qLaWyc3OVAk5BxSwJCpiWHlzQcKtlpY9z6tWuHWSzuCPBi7W3WOPmBX6JA3MuD6LoKvwOJGJ2MZ6hhyMlDOInH0pN8WDVO3aKT6mg3uRogw/WDnoeZHeH+FiHOjHelJ1nhTb0U7htYKHoURM+OT4a+p87Dkt4Qoqi+dt71893muqaxgAiYf+A/Bz8D/gDQiHU7dFTK7hHVFEtqxxROEysH59ba9wzH+B7MqUaNXVbohyGNaInX7Rck/w3ymMcKemVjHZ+I71cMLcNWfiNsqP3b2UJEgLupT1ECPJ84K15JBcCwA5tiJvgcO+55wrmbs3707QE8jaw5KJKatG3IVYGJstwVTkf9gUScvN1NJWU+k1dA4Uqhgqgk0aM9acC1YMKum8qMA/BrK+7tilp6Z3X4cWpL4MIivudxdOh2W4x/e80EwmhbNPQyQH4SpU88ykVHRpePRUo/+417Q0sI8V+wPS6QlVvHYyS9RCQ96ma4e78Mrljq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(316002)(54906003)(6916009)(66476007)(38100700002)(66556008)(52116002)(86362001)(478600001)(8676002)(4326008)(6486002)(6506007)(83380400001)(8936002)(5660300002)(1076003)(6512007)(186003)(2906002)(66946007)(6666004)(41300700001)(7416002)(3716004)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sjB+q+uYZZBDZ6S0OWxlLGf8HCXOBlSLWAIA/NqaUAnEUeyXawF072jl/by/?=
 =?us-ascii?Q?IuIAFyJRfsZTPUY2q+TCThkrU2AutAgqJcbHJQwm1JlNw3nJQX2lnrgmfEG5?=
 =?us-ascii?Q?0c9FF5oOrfEwkeIUT1G2ynOz+Rv5tars4xn0QZZ8Zxfv5xYcTDZYiAXWTGGn?=
 =?us-ascii?Q?Qu3XvoBovSDYF9vXVMPY/Kg3qtqry7/S7+RMpQKbtnfmGMZC7KzIMbNKVj6h?=
 =?us-ascii?Q?+IlnFqDyJLE8SxrNhlWOkvrdGl5OMr8wEATMV3GxYGiD5rHgXLXJgLp22mi7?=
 =?us-ascii?Q?KA1qDIFiSeSi3uUht7ma2demldsKx6koQ87a/kr7xIU+ZdlNXxkW4SbfLJlU?=
 =?us-ascii?Q?xFTMeZgok+P1/C33jxAs9LAinCAC+cyEFoJSyVyjSbNU6E4EbQidotgdnOL6?=
 =?us-ascii?Q?71stlNnyQA+vvPJCCozKMDpECnlgpZ3t9A0EusvmH7xf6M7wLWOlDrMgTjyj?=
 =?us-ascii?Q?SnJUOhshbluaSVLZMZmVJdH13HuGboR9OZuih5kHhUvxpY3D+3pwpCcZ/Ru4?=
 =?us-ascii?Q?wEH2TTqcp6EciMa5mw1T45yqstclngeGLiEkW5apKvxDdybOC1RIua5CJrJD?=
 =?us-ascii?Q?VqKOpw28iDnaqSWNchnShJYtQZ5o4RTYa1IkuL6Q4jmON7bNQtDwP77szAMD?=
 =?us-ascii?Q?WZRwSr7H8R4F9WU4V7R34RLeAfCPOEcWI9Pyxu64y192i8a0qp/pyZwGFqES?=
 =?us-ascii?Q?/Vqi4BkEWYlm4SjlUHDVPB3huvDIP2P2qyAXwtzkiCGQx2wPnT5pDlggLgzn?=
 =?us-ascii?Q?Yv2OctoCxs7OWKjlzQ/XxziBdE2OHvLkX3JbksiLnWD2ezbKcDB3L2ktldIp?=
 =?us-ascii?Q?9ATi6bb/AtanwOHmjVXuDE0I79KM9m7BBPhEp+ZfssOokkZ8jwEoPqJofp8/?=
 =?us-ascii?Q?KVMC7nvQdFTBRM5sLuSwaIQlywM6e9stFwxfsNnBD0Z1oMM9BNxEv3zfebhQ?=
 =?us-ascii?Q?XUfOjamUHs5h1V1GUmAzDdu+doBa7+QbUsCo6FBRlGGHFEFluxjYHRjTK6lG?=
 =?us-ascii?Q?ADMM1mPBPdHYyPDazHXtRCjSr/QjdUSvcvbhXf1t9xFfM+7krZ4Wp0GSGtFd?=
 =?us-ascii?Q?fo3IapHFnTieZg3Zmp/K54GSjhDRGb2e2h/Ncv0KZwtk9apbCBA1QXR+DN0i?=
 =?us-ascii?Q?FnvBaEUpUKrXWjb9sjHNq5qiA6dUmnF2l/xuKBuc11LEYVnJkXWErAcPJ/SE?=
 =?us-ascii?Q?ht0uBZsp8dKjzQ+i3bCwsnEm7SC1vE7svW/7bGNcr8CXP3Oe6N2mPWe3fjGl?=
 =?us-ascii?Q?9nfnTwQtHOr4Xc+TmB2pLfgwgy+nYkR1WjlT6a/HFS1B3bCzy4zzU6Fvr7dg?=
 =?us-ascii?Q?wj0jA8Vbe4zQrzj/7A4/cXo+W8LahVI1kqMiCK5A0Nad3CgtuBY6jfr6TYsf?=
 =?us-ascii?Q?S4nldBbvrFbJzOG21bYrcVAfJi9oTbKxoIEoWGpunNwJBPgpkizlaEqZLWjk?=
 =?us-ascii?Q?GDDkwcg/86tOkp9aPjxKihULmwANHzrR9hUOB3NwTGznU3F/wqNYWX/AYUVB?=
 =?us-ascii?Q?gA1UcDJkr569ESOA3R8UuvhkDZl8EqEWSlwecKXtfuvzyyf/NpgPUWaWrGLJ?=
 =?us-ascii?Q?UN6M5Q5JBW4Ai6WpJIx+3SpXip1PZFvzrizdxZpPGFFRJAZiEqp45lY70lLv?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a510e4-5c96-4ebf-a569-08da70b6927e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 16:31:07.2353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MDO2EfGTZLhuIlLu5qjpC/6PZYvoPuwXYeKKbnYhTlB7h62RuR77VR0sJAwE1r6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3961
X-Proofpoint-GUID: dxtqd-6SLhWt97Fu3hBXIV3KPgUywkCc
X-Proofpoint-ORIG-GUID: dxtqd-6SLhWt97Fu3hBXIV3KPgUywkCc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 06:49:03PM -0700, Jakub Kicinski wrote:
> On Wed, 27 Jul 2022 17:45:46 -0700 Martin KaFai Lau wrote:
> > > bool setsockopt_capable(struct user_namespace *ns, int cap)
> > > {
> > >        if (!in_task()) {
> > >              /* Running in irq/softirq -> setsockopt invoked by bpf program.
> > >               * [not sure, is it safe to assume no regular path leads
> > > to setsockopt from sirq?]
> > >               */
> > >              return true;
> > >        }
> > > 
> > >        /* Running in process context, task has bpf_ctx set -> invoked
> > > by bpf program. */
> > >        if (current->bpf_ctx != NULL)
> > >              return true;
> > > 
> > >        return ns_capable(ns, cap);
> > > }
> > > 
> > > And then do /ns_capable/setsockopt_capable/ in net/core/sock.c
> > > 
> > > But that might be more fragile than passing the flag, idk.  
> > I think it should work.  From a quick look, all bpf_setsockopt usage has
> > bpf_ctx.  The one from bpf_tcp_ca (struct_ops) and bpf_iter is trampoline
> > which also has bpf_ctx.  Not sure about the future use cases.
> > 
> > To be honest, I am not sure if I have missed cases and also have similar questions
> > your have in the above sample code.  This may deserve a separate patch
> > set for discussion.  Using a bit in sockptr is mostly free now.
> > WDYT ?
> 
> Sorry to chime in but I vote against @in_bpf. I had to search the git
> history recently to figure out what SK_USER_DATA_BPF means. It's not
> going to be obvious to a networking person what semantics to attribute
> to "in bpf".
If I understand the concern correctly, it may not be straight forward to
grip the reason behind the testings at in_bpf() [ the in_task() and
the current->bpf_ctx test ] ?  Yes, it is a valid point.

The optval.is_bpf bit can be directly traced back to the bpf_setsockopt
helper and should be easier to reason about.
