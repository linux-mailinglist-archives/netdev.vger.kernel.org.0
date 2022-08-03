Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F155894BB
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiHCXTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiHCXTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:19:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C1820BD8;
        Wed,  3 Aug 2022 16:19:42 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273HuJFY013133;
        Wed, 3 Aug 2022 16:19:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Exu4nTxJneAJG3784J1wry9bfN/KFV2agCfjLokT/7k=;
 b=hUQSRqylZ7BU5KT7QXxpnP6OIAi2YvAx2MIryDhTrJ0CsvIsmOfrUdtNpSI6bVIFpMe+
 SXF9yOKDZDtr+befle8i8M2HJ2siywt1yIx9X591SQ8vBKgqrl6rU8UrmWLx9s7OEvRe
 ANWEhdErDL5vZFSwhB3zo4MIuGDFGun79f0= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hq2bq4ggc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 16:19:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQmw4NlMuV1Eiftalr4kEPYF5tvguvXL8nE1NjRqWFOOylhCKMF2/le+XV84C2vL7THL8SN6pjWimrsP7PMmqAxXZOlzGTjpXwQnGFvhRyYGMEjBDEFTlfvOJREh2snLrztuFBz8I12tG3lTfcP45+C/9ziPm/+MnBBtCROeCFZ70oslfusesocTTnif164UJushKH7sBi/lhGoZk0UUCjSAHNQMvXKeI/Kp9jFKlDM0joDNCawyVIT12LgHhkpNMG+k8nlbiKfStIT1UYHknwchNUMdHzecP6duOVfOsAyecICG6WTAUighJzRzsL82VcTQNagF312Jhm3TktvHuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Exu4nTxJneAJG3784J1wry9bfN/KFV2agCfjLokT/7k=;
 b=Cc3hweGO+brhwhxc9Zi/zvak+09Nqslw25Xbkl73DSEq5bzgEt8+rPPDyRRZRjy0xdUfURLfsOs4hGYRWqUJbVXwuli+56azNtwNOEWdMpKa850uLYHuqFNPW3t+J384J7OBNJ5uJAiQOTUL21Xk6wuXu5f4U6xfPM27ERvRyJCCAD5g1tHXx8voumvJ39YAOk5MCurNw+WwMwMdBHeQ9UOHmZikJSAyxm+WkVEtpH4aVfe90RsW0q+wW7nOXOYqRp2BfweLFHxnff88q0MPJQZQh8T81M2bwGUpSp/A6Kp0t2jC3ntSqCKfxUA9h6MO2ZhgC8L55Tle/2moDtqLog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by CO1PR15MB4891.namprd15.prod.outlook.com (2603:10b6:303:e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Wed, 3 Aug
 2022 23:19:23 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 23:19:22 +0000
Date:   Wed, 3 Aug 2022 16:19:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     sdf@google.com
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
Message-ID: <20220803231921.nb623atry4qdrp5r@kafai-mbp.dhcp.thefacebook.com>
References: <20220803204601.3075863-1-kafai@fb.com>
 <20220803204614.3077284-1-kafai@fb.com>
 <Yur9zosqo4zpVBx5@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yur9zosqo4zpVBx5@google.com>
X-ClientProxiedBy: BY5PR16CA0011.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::24) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d47b73da-0e1a-43db-38d6-08da75a6996f
X-MS-TrafficTypeDiagnostic: CO1PR15MB4891:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NCOX9ghjoyP0bpfExvzv6FowPkuJez6UeYf0D2jcBV3Nyxzsg7j5w6BBSKq6zxf60XvhgS23GVsM7Ro5v+eJHWuxw8z13AvhrMmzp6RW95A7h379mJMfBwzF+XhmTHc+LggmjXvVdTaBFknIqOulmSlrsP5rlutRw7iT17SDpUpOJUJ6UE1LF/49HkaHzbtgeFHrTA4YbwKbi5Niqqyw/s9ytPL+xOjWapK1mcfdpm697o5eQh+NuGVIwKPWMPutFLCTtINWvBHkXRMJzthPFsT8hEjrFFC1P98JiS4gzozIYBKBlDsTkeqk322K0ziEXeBpd8zKRJky4OjrRfCmknBWMCLl3vlPn7dYEY9Jo/Z0bqDjGoF0Z+PfhdtmoFKOy+udO84PMqfjJEcE+J2De2V9oKRKIcDBuk1sj+i+tfBjV2ZRF6Z6n/T+QhuOmE1sPGcz+1TscALGdbL3VyPOYons4loTYUYhCk9KSBPOl+PUrU7+fpvlfl+N3G9PLKDu4qMu2CCjwV+r0PdWe0OGt5SdKZX4DX/aIO2TsR3zGaPQ6Q+UIgjBVRvdJjxN6LJr6vdLxMmcqa8mF45VlBI0H225WFCuS1tNRhDk4zJKECYQjt6hgQZ8onKmGvwgLUojGV/KCFp5+3js8+prDxfzJO/U/eIVK9oJKF/3KXmJNMcccNz7gSeQ52jpfzNhTbKok0rq4CQQCfyyJex1Kw6RnAFbMyEOR2PFkoZSuvvkjUj+HalEKM2fFtBkl6ioxyD4cXWTYQ8+3O65nATpiHX3FnwBtJ0I8oXfnkskga8PtVI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(5660300002)(478600001)(86362001)(7416002)(2906002)(8936002)(66476007)(4326008)(66556008)(8676002)(38100700002)(66946007)(1076003)(83380400001)(6506007)(52116002)(6486002)(41300700001)(9686003)(6512007)(54906003)(316002)(6916009)(186003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PTLcFPCLndk/DwP/R9XM/BEroSHXCMsFqKncpGkHh8v1GkOBh0Y94c1wk4ii?=
 =?us-ascii?Q?T6Uid/uoVHnCLVBsEoM6DLMiik24Mr9TEJrgspeJyX7EangpGAtAgl8w4/YS?=
 =?us-ascii?Q?UtAP2HRQHgm5fZnYwJDSpqKAO1Mcyrax8s+Shak8wWaH40dAIfvhQdL53N0G?=
 =?us-ascii?Q?ZI3PI6o4/GHWS5407eLqGODseRITQGAOVR3OMGpEYtGu/xT4UkwGprtX51YQ?=
 =?us-ascii?Q?S1RzajtDNirUoxi4DEHf7vHjI9t1FDZO97vN2IlCH7YsISyYJin2tBfy4IfR?=
 =?us-ascii?Q?Lt+b8mw++yo7R2DHM3XkPmK+2iWUlepBi/b8emSeSK/jlWyp394lHvRLMNtd?=
 =?us-ascii?Q?HrN9accDMsEM2O6xsZ8Fi1iPFKnoHRaGJgfT+mK0PpypeWFfHUnAm3HybL7m?=
 =?us-ascii?Q?XTnn5kJDiTIqc2W6aGBSTdERbTUb48OGPsJQAeAc3tVWBCiM5Xe9lYYvR6H/?=
 =?us-ascii?Q?I4NblbtkSDFByts/tXOKnotM6FaZeP83N5VRRsq9fzmTU1+zTO/yWbFzYb3f?=
 =?us-ascii?Q?Vfcm3IcLvYhkfb1VHlTKxwF2NqsHLmb914lkPkQ/uOUAUnbaM6REEtsMPDcK?=
 =?us-ascii?Q?fhnWL3+9FEjIGHluUp7t+FI/py5Rb7rOTf169/B9Ize2NxiNKnReh575pGf7?=
 =?us-ascii?Q?X14kKQGXPPyebh0Bcb5mHVgNve4fhq6l+KCMNy83nhL0cMG9nb9XH2ssfahQ?=
 =?us-ascii?Q?LQdVW46/4j3c0Khi10nI2nOco7dZ2mqOtf7HMhIq1lk4FkIgEySauVNo0QYB?=
 =?us-ascii?Q?5CMESmKRqtdM0rS+EAcEkkZOjHbpRc55uwylyK8c3cb2lyNH8ftZYbb4px3u?=
 =?us-ascii?Q?/zV7Poznfr2Js3A7TCuRC6w30iQiZXWALFv5kPsDWg42erNSIhZtWyXHro5R?=
 =?us-ascii?Q?NMKHnNfQTpNvbB2Ep6ZsnBCqqptwQhcD9tRM4g5q7tPpsH0QogBy20/PFjYv?=
 =?us-ascii?Q?jkulQa2QSfOSiNAhn86PE2NQSHxqfq15oUABP4TQqSUPbBQCBjckGGvu1+nJ?=
 =?us-ascii?Q?EtKZKng/1u/+Z6ifSrYpBgsh+NarztA3HQ2StC4dRwRB4Ok3L9o2pfIg1GZH?=
 =?us-ascii?Q?7dm874IHdtyMKkmdPMEwsVC3Qj6zHoDI15ebuO1j8PsXOpWQiW834zE4hJzK?=
 =?us-ascii?Q?1TNv2JqAogc87LLgMkkVZn5g6yHyf/G30SheCZAwhSex0IHgZ8bCv/uOCMdz?=
 =?us-ascii?Q?5xURyLXRtpeT9YIyj5Jgs3QBu21skMUZ62L5atAHkYAWIFyhD/DpMEYP7cui?=
 =?us-ascii?Q?4LaZCk3iKYTOT18KtEMif124U4ANmb/255wwiXwteZhjwwBuHdM7rANr8sJt?=
 =?us-ascii?Q?eqdEembRTv/S6H2uk3TNTYa9rFBcfo9h7amFNXsBfs1eqwAiU/3nfCFRpUbz?=
 =?us-ascii?Q?Ha/8dnUbsF0/JF9XzqvGGFhcTeWYOp/cBwHDfCXsibMBHiVdHXKMUs3UF4rt?=
 =?us-ascii?Q?r0znXM5makyATdWU0KQXRrsneIjDfhdftUwTING8S9d3iLbjsAqTjGh3uGN2?=
 =?us-ascii?Q?O9UyXhlRsUGWy0ss9M1rkIWVU+LThBVk7n8L8VQ42IaScmRQZ4NtHK+dDdbv?=
 =?us-ascii?Q?/gyfvhy3ycV+4IABL5I6KK7mZkBqBJw8B0qTBtljQ6I29SfUkzqwFy0YNubN?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d47b73da-0e1a-43db-38d6-08da75a6996f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 23:19:22.8694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DhQ+zTWe+mR/aC+xIEY3iEyhIXWOyNMWBBv+bJNfFPVQLAiNO4+ibIeqljIDOfef
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4891
X-Proofpoint-ORIG-GUID: YD6u75osLsJh3sDiU8CPG_Gpu1AMALeJ
X-Proofpoint-GUID: YD6u75osLsJh3sDiU8CPG_Gpu1AMALeJ
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

On Wed, Aug 03, 2022 at 03:59:26PM -0700, sdf@google.com wrote:
> On 08/03, Martin KaFai Lau wrote:
> > Most of the code in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > the sk_setsockopt().  The number of supported optnames are
> > increasing ever and so as the duplicated code.
> 
> > One issue in reusing sk_setsockopt() is that the bpf prog
> > has already acquired the sk lock.  This patch adds a in_bpf()
> > to tell if the sk_setsockopt() is called from a bpf prog.
> > The bpf prog calling bpf_setsockopt() is either running in_task()
> > or in_serving_softirq().  Both cases have the current->bpf_ctx
> > initialized.  Thus, the in_bpf() only needs to test !!current->bpf_ctx.
> 
> > This patch also adds sockopt_{lock,release}_sock() helpers
> > for sk_setsockopt() to use.  These helpers will test in_bpf()
> > before acquiring/releasing the lock.  They are in EXPORT_SYMBOL
> > for the ipv6 module to use in a latter patch.
> 
> > Note on the change in sock_setbindtodevice().  sockopt_lock_sock()
> > is done in sock_setbindtodevice() instead of doing the lock_sock
> > in sock_bindtoindex(..., lock_sk = true).
> 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >   include/linux/bpf.h |  8 ++++++++
> >   include/net/sock.h  |  3 +++
> >   net/core/sock.c     | 26 +++++++++++++++++++++++---
> >   3 files changed, 34 insertions(+), 3 deletions(-)
> 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 20c26aed7896..b905b1b34fe4 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1966,6 +1966,10 @@ static inline bool unprivileged_ebpf_enabled(void)
> >   	return !sysctl_unprivileged_bpf_disabled;
> >   }
> 
> > +static inline bool in_bpf(void)
> > +{
> > +	return !!current->bpf_ctx;
> > +}
> 
> Good point on not needing to care about softirq!
> That actually turned even nicer :-)
> 
> QQ: do we need to add a comment here about potential false-negatives?
> I see you're adding ctx to the iter, but there is still a bunch of places
> that don't use it.
Make sense.  I will add a comment on the requirement that the bpf prog type
needs to setup the bpf_run_ctx.
