Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C0658360A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 02:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbiG1AqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 20:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiG1AqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 20:46:14 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C79F57271;
        Wed, 27 Jul 2022 17:46:13 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RMTIYv022110;
        Wed, 27 Jul 2022 17:45:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TIsT8y+Ok7JijmrT/qx6deXJtn0IF6Q7EeqEGKKERaw=;
 b=EPfKXvnnMZNu11k0rOyFqm8O2nmn57bLwrTLQfsB8udfbt9sAEkBbuUApQPkypFPf+2w
 Ur3Ka9115AasLExEempoctiqyPuDfN/vlRcGrFAHlUMOHsrjsGrTnRe5IcnYGLQlZU6R
 7QwjLNCvL+/d8tNloGSUKyXgamGpzzAX/cQ= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjw4f7t90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 17:45:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNFvzCgJIHl/SXVVhqlUyOeurRHBf/BPirTkYiR+99jomHnuX7ZBx4wevbaRoz3P4uV2u7OQH+4cpvEWOIzxvA6ZE4IzdnkJZJSUJ+FLdsYJdNnxkqnJnfnfnZorzUribYLJ1dvqtssOJ9J+YHrdbMIbH/cJiOIO/BlPGm92pCLL6MXKmXi2yfDbqu66+IVuqhnfcFFzU+fO0HW3f/IBL+nqwQLAR0eUbQiYmtitgqt48OlFemBoC+1egx5WcjqPL9sY15dkjBjJl/As8ltHVEELLT48+hIVayC8HHOAju7WiJTaXSyzUkX4E0zJXwj6zgY8VjW3cJOe9FoDqKKDNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIsT8y+Ok7JijmrT/qx6deXJtn0IF6Q7EeqEGKKERaw=;
 b=C6WqyxUH+/he9UZyrpRT114TRl1c8c3qQj9tKtdDuF81vlkhzd+J+HLRV05TDXHwJlm+tRLQYngWTYAum85xEOdR/3eTzpQYhBjc2XgpJtge4TSchQpOJ1rE2UOkzo0yVSNAycshaMrTGLVEif25Ec4N7/4IMhujP0bw+2vh7NdBTNKnZeo1peRuJ6IDEpYVCYfpbGz+xuGQmd7/5D3NL7ZDSy174rlpYL83Ti4hGXa2Kx8AluUO8stXFxH+FyQasNNDdhgSVDXns1+qwPP7a4upDNgXc7sVxjcGCkv2jZt2UZndECtnZpYhaJNviFGr98W4Xvq12UIBlLR45TSm1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BN6PR15MB1907.namprd15.prod.outlook.com (2603:10b6:405:52::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Thu, 28 Jul
 2022 00:45:48 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Thu, 28 Jul 2022
 00:45:48 +0000
Date:   Wed, 27 Jul 2022 17:45:46 -0700
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
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060909.2371812-1-kafai@fb.com>
 <YuFsHaTIu7dTzotG@google.com>
 <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
 <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
X-ClientProxiedBy: BYAPR02CA0047.namprd02.prod.outlook.com
 (2603:10b6:a03:54::24) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdda30c5-fa48-4ab5-0523-08da7032836e
X-MS-TrafficTypeDiagnostic: BN6PR15MB1907:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EWNZOQed+X4tzjTgZTqd1feNWXWfR9wLNQjL9SWLVSk8Nu3JJjzby6L0LGFkHuurUwvk09jc+FzhWwCjpin5zh9iwyxejtTfkr11YXHIAQhM5LwJiJ/9kXhMwYCZBLG6IshQayqIglb6TklPVp8XaoTlSIPue9CWReiYQ2uVspQDoqcPN9gzJk1kH8J4RKTsXM744Awi2a0CzlSSuxzk3PeCPQMoX+lBuHW1rtRIZ6V9PFaqTGGOvk11sWP9NiNlew9NH35b5qvCx7W3P7ifzdQbLN8gv98U4fHG/58oqwdXJsCAWQYfv4Foal0qMVjFm+5XvTdpS6tMWJXxtyPCuwIFSuCIFWQDBSOMpkah8s58DierjVRgmkITVXRGmOQ9Zl7uHADUYItdpwHcwfA2/8tbMaj/CgC6hGQbefQ3Jw3VNHIWuNuWotlapRs2WyvXuyxNEjQIQAxS/V3ZMNLjUpt5s1a5dRG0k3r6pjb2bKZXeFDmcgsPfxksy0cCLK7vElt3qSpQt6/ieX9YRA/ra0u2b9f2+2YSxAKRJ3mc4StmltNJ5shTvB/ZbUccYfktBtRVy+PIc1Tg+aidNelWpJoAxDmxjFlmFJs10gjKzHo5J1KLsvGdWJIIt35Ps5A+0aJjzQnzzpS4oQQ2MY6U5FckaJDrv6eeZPSYfXyicuq87NJtgkUPovsTeLixx1EdtwHTbF63OpBm6si/vd50Wy9qMtnYwxnFXnHYmyF0kDJ+VRdjh0NrAqh2NUuIGIPA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(66946007)(8676002)(66556008)(6486002)(86362001)(54906003)(66476007)(1076003)(4326008)(6512007)(6916009)(52116002)(478600001)(5660300002)(316002)(7416002)(2906002)(53546011)(38100700002)(41300700001)(8936002)(9686003)(83380400001)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WM015s1SRaSNlPWA1j4wEFMk7SMt5Zjmi4Ky3ymssJ0xjdnh42hHcWfAcU6K?=
 =?us-ascii?Q?j4um8WZ53SK3yzPdRLYwNbrmoE0Nc7iviZ9buB+GiPncLL+24YXDbGTovQuM?=
 =?us-ascii?Q?ytS3xENDlWhUrIAOgSzcsuH2Tk+V6Iw0+nYLVBGfZb5AiQ1J0zR1xpo9gvvR?=
 =?us-ascii?Q?NYg9Op7ubiY2DIiaxr57hbHni1KW2qhn+f4QrVpQj0a5coD9n9bTlRuoV0nA?=
 =?us-ascii?Q?8Kk82fykKCLUe4gVx3VSlWWDsE45uX+fSfhU8v4gdGNxFN8vnhqyQm6N5o+i?=
 =?us-ascii?Q?BmHiMvAGWo0puL3Oxd3ymKbma/8ihehr3kbSoviViXN8MvyrF9t8Al4uUEQT?=
 =?us-ascii?Q?OpVXnnOKOvcaYAF3FeDeUywkA+GrPSdGXvL/+mr7Snl7zXhofTjCErb5eJ/s?=
 =?us-ascii?Q?l4RCstsapxwkb7zrPQ3miTlYbcprU4i8fnVgyKfc6RIesB6O5foPgL7v/mLS?=
 =?us-ascii?Q?r/yiDR1eaA6CyqR8flsTTBiadxSxePYp/1df/PxYj8DPWonGmuSFpxgayTIS?=
 =?us-ascii?Q?wXoC/iaDS3T0g0KNGSZuFFSR+gWibfmFzoiV9XsV7Olj+ku3ToWmjQ38qD42?=
 =?us-ascii?Q?k0MFDQeAldrphuJINjdRZR09yDl9PXn0F2xBQGu8ALeFze5jw5KwWV9EJa1L?=
 =?us-ascii?Q?5Wg9OFp+GJsmK0Nq15G9KuYbqbIHU6zvu8QnosK6oXAx7qRkjzhX9xk7UUMV?=
 =?us-ascii?Q?L0TxX/ajUheDmNa0qh5nEnlQKR9325TaSS89hc3gB5fYrQenNzOdlAcaF/HM?=
 =?us-ascii?Q?fuFQZLn4gUj9ZlfOnjSDKYfJSMUbwu3ixuozZsJYgtgUHuS8ndlSEDz4IVni?=
 =?us-ascii?Q?S+C6oRm6QGAc/+PvA+14ZkofHQ+7gD3B6Ts2hNzVJERm3ekHGv6wKm68lXMt?=
 =?us-ascii?Q?AbPzr48Y7qQ6Ex75Kg5B0k151L+/hX1o8ipgUThwrz4nXlR8Jw2awa5/t/Pq?=
 =?us-ascii?Q?9LK1OoctPOjAi2dQm5xQCgtDoT3UUwdFMAme4RgNcGcKHBDqqZGa50sIkh6A?=
 =?us-ascii?Q?0Q4tD0UsTWYzbnFDlmHMQ6Da9RmdO50mtlcyn1VwhbjXCgJdViUFdSJTLnoE?=
 =?us-ascii?Q?toF6B1LaDXOpByszyBX8K+Kazt64+dftpscge6+f91JH+A7WLfKtEweU0l3q?=
 =?us-ascii?Q?lZ9cGqIrpLP3r+SrbnAmXomZKOEsbwpuAZ+KjySUDqk7lK/xSqatsG6VE8Mx?=
 =?us-ascii?Q?NlwJqWZ3HYc4wLprLAq5CYzIDl5fKq9ECmA3YvSA2ntW9HUwovWvI7rDIu3Q?=
 =?us-ascii?Q?FraPBMgcgjKZCGmBH7BopwRBEcjXJK0uczkJzzW+7J0soCpxqJYIpm6z13mQ?=
 =?us-ascii?Q?SGxaG1SZYzeq2WaTvaCxDHZqQDRjByKBmKKrx6GJh1P8xX1oCH+aek4wXBm2?=
 =?us-ascii?Q?LhJZn/YI4V+3eZgkADMo35XOMJGRKWY+T5eFdicSmu4f69krReMEBWZeZEUO?=
 =?us-ascii?Q?cgu4+moiafWP/7xX4saBYI3KYAsPN4a1ZrXuRNkOxQjOZY8LyG9cDK1wjuKL?=
 =?us-ascii?Q?LTV+Pw3SXQes3MT0wiUeQOC1ilA0Q49bZrsp12am/nolqHteeAJEXE7J0RY4?=
 =?us-ascii?Q?S2BDP6dLVtlzedz1Vo6i+QPzR0Igoe4DCAJu2mKGSCRyccZQss9s5hzSgvAe?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdda30c5-fa48-4ab5-0523-08da7032836e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 00:45:48.4703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wc4njaUDrGgKSyjzGR/b9VTPFqRpjp2mN94SVqOorP+W/lwN0LWTWvjO9+RTyD38
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1907
X-Proofpoint-ORIG-GUID: 5ssf_BzwwmLxil6wc-fmhtPf_I5NKIB-
X-Proofpoint-GUID: 5ssf_BzwwmLxil6wc-fmhtPf_I5NKIB-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 02:38:51PM -0700, Stanislav Fomichev wrote:
> On Wed, Jul 27, 2022 at 2:21 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Jul 27, 2022 at 01:39:08PM -0700, Stanislav Fomichev wrote:
> > > On Wed, Jul 27, 2022 at 11:37 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Wed, Jul 27, 2022 at 09:47:25AM -0700, sdf@google.com wrote:
> > > > > On 07/26, Martin KaFai Lau wrote:
> > > > > > Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > > > > > the sock_setsockopt().  The number of supported options are
> > > > > > increasing ever and so as the duplicated codes.
> > > > >
> > > > > > One issue in reusing sock_setsockopt() is that the bpf prog
> > > > > > has already acquired the sk lock.  sockptr_t is useful to handle this.
> > > > > > sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
> > > > > > memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
> > > > > > has already been ensured by the bpf prog.
> > > > >
> > > > > Why not explicitly call it is_locked/is_unlocked? I'm assuming, at some
> > > > > point,
> > > > is_locked was my initial attempt.  The bpf_setsockopt() also skips
> > > > the ns_capable() check, like in patch 3.  I ended up using
> > > > one is_bpf bit here to do both.
> > >
> > > Yeah, sorry, I haven't read the whole series before I sent my first
> > > reply. Let's discuss it here.
> > >
> > > This reminds me of ns_capable in __inet_bind where we also had to add
> > > special handling.
> > >
> > > In general, not specific to the series, I wonder if we want some new
> > > in_bpf() context indication and bypass ns_capable() from those
> > > contexts?
> > > Then we can do things like:
> > >
> > >   if (sk->sk_bound_dev_if && !in_bpf() && !ns_capable(net->user_ns,
> > > CAP_NET_RAW))
> > >     return ...;
> > Don't see a way to implement in_bpf() after some thoughts.
> > Do you have idea ?
> 
> I wonder if we can cheat a bit with the following:
> 
> bool setsockopt_capable(struct user_namespace *ns, int cap)
> {
>        if (!in_task()) {
>              /* Running in irq/softirq -> setsockopt invoked by bpf program.
>               * [not sure, is it safe to assume no regular path leads
> to setsockopt from sirq?]
>               */
>              return true;
>        }
> 
>        /* Running in process context, task has bpf_ctx set -> invoked
> by bpf program. */
>        if (current->bpf_ctx != NULL)
>              return true;
> 
>        return ns_capable(ns, cap);
> }
> 
> And then do /ns_capable/setsockopt_capable/ in net/core/sock.c
> 
> But that might be more fragile than passing the flag, idk.
I think it should work.  From a quick look, all bpf_setsockopt usage has
bpf_ctx.  The one from bpf_tcp_ca (struct_ops) and bpf_iter is trampoline
which also has bpf_ctx.  Not sure about the future use cases.

To be honest, I am not sure if I have missed cases and also have similar questions
your have in the above sample code.  This may deserve a separate patch
set for discussion.  Using a bit in sockptr is mostly free now.
WDYT ?

> 
> > > Or would it make things more confusing?
> > >
> > >
> > >
> > > > > we can have code paths in bpf where the socket has been already locked by
> > > > > the stack?
> > > > hmm... You meant the opposite, like the bpf hook does not have the
> > > > lock pre-acquired before the bpf prog gets run and sock_setsockopt()
> > > > should do lock_sock() as usual?
> > > >
> > > > I was thinking a likely situation is a bpf 'sleepable' hook does not
> > > > have the lock pre-acquired.  In that case, the bpf_setsockopt() could
> > > > always acquire the lock first but it may turn out to be too
> > > > pessmissitic for the future bpf_[G]etsockopt() refactoring.
> > > >
> > > > or we could do this 'bit' break up (into one is_locked bit
> > > > for locked and one is_bpf to skip-capable-check).  I was waiting until a real
> > > > need comes up instead of having both bits always true now.  I don't mind to
> > > > add is_locked now since the bpf_lsm_cgroup may come to sleepable soon.
> > > > I can do this in the next spin.
