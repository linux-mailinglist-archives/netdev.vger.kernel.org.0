Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BD8545917
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 02:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiFJASL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 20:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiFJASK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 20:18:10 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5CE4F1F6;
        Thu,  9 Jun 2022 17:18:08 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 259LPaJI013977;
        Thu, 9 Jun 2022 17:17:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=O4EMEJYUPaBSwBn2vHP5uUiASN5JoXY+2rJfE6OEm1o=;
 b=TLAoDBONbul/uXfRcn1Ja9RHwy8weWHktCQJixM0PUTB88M518X9JXr5lXaN4KiWF3wg
 cCZ+3YacmDIz+YDp4eXS/FUH7oCD/rm6qCoR4dA3PS1EPeDnFB6AWTInQPoHshQGHSNK
 bxx5wljob4jG9nklQQ3+VbG0ERegaC06r4c= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gkajge3e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 17:17:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa7lJw2iIAk3/YC3pAT/brB00++Li5w60XyqMay2t/d6slM0k2/5mSv4G8BxS0zYYBNH79pLFlbKxjq+fxXfYOiLSU524EZ+rLIM1IDaGueXJ3ujEjNVr1ELwGbeIU7i9EQYQBCMPB1WKikWQmKEhLS0tKR8IQXHmpT/fKCAA1zVFU57S1jnFFoHsIDxQ45niYRAWv06ekQ4HiTTAnfIGXC8OR+7HdieXysNMQGoVWZd5ERPf35Klhv0semsBwsaRaCr/jnTxj1UiqgNJSIW5mdzM1F4+YoWRoRsh0rze0xvPLx6uy5c5BkQf9ciA6vYMhlr6ujX/kB7hHawFclzow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4EMEJYUPaBSwBn2vHP5uUiASN5JoXY+2rJfE6OEm1o=;
 b=D9Y6f5dYzujnkAvE3ijd5ShvnlLzm0UpuNgBcFTul1l+ICcquPyI8HUo9GuTwwuKIbiAGKTeIPaZdPfX6yig0mmxFVhmhSpYn5lSe4DkfrarFfFvZDpcAcNIu0wvzGz1w/QfdqB6AsYCqYok18pyZ0+JciAPBfMjSazez9taxK6lr1cPPc58GApw6LZeU92VQajAfoL4LY7rceY1V3olYOjmck+ZKoIDlCEO9AsrbZHTqWym4lI9T6hilnQVnYOBXue1tTD2tRFI5vtwJ/DXB2e4I5BFuQrsdlBlB051gvQCoVtxtip9QozhwMNR5iy6m6GuHL0BNbO3gmZveI90iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by DS0PR15MB5421.namprd15.prod.outlook.com (2603:10b6:8:ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Fri, 10 Jun
 2022 00:17:47 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::31b7:473f:3995:c117]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::31b7:473f:3995:c117%7]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 00:17:47 +0000
Date:   Thu, 9 Jun 2022 17:17:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jon Maxwell <jmaxwell37@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, joe@cilium.io, i@lmb.io,
        bpf@vger.kernel.org
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
Message-ID: <20220610001743.z5nxapagwknlfjqi@kafai-mbp>
References: <20220609011844.404011-1-jmaxwell37@gmail.com>
 <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
X-ClientProxiedBy: CO2PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:102:1::20) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c0aebde-c365-4cba-0f25-08da4a76a551
X-MS-TrafficTypeDiagnostic: DS0PR15MB5421:EE_
X-Microsoft-Antispam-PRVS: <DS0PR15MB5421BAA04C673DF5C5F6E1EFD5A69@DS0PR15MB5421.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ustKEL4MoRyN3oCAWIfbbwyMCceLSHJ5tKr3rZT6H+l6QsblY674GmGXkKNc3GVAd71RbV61vDAGGOnJOOYflVWW1s+EWBStV0SJtUzTk+AXBmWsdln9KLLCG43cQjIJ4olNqMQY3OccIhS3h7mLzmUDa/SnnSIWetlNi27doEGjcSQ4rQfa94HP1fb3Jlm/B+6oCKERiws/P1tRixagM3sUv/1xsvksZqLx1QiVUlw/xkpF3uEr1MPPP2yhBOU7uAviCEg8ssUhOu6eNqkmQuo5SUxa+WApIOnuriwQOCcjPB40hJUqb3BTNn3aMWLSZCmAUYbxWdla9itm3zETjS4snzz3OG/8PDD1fK9mR73yQWH7tyPSu9Pi7JJVPrZ/B0/g3vEUqwXrnxDD+IokmDtlZSAbPQFmgCGKoJW0V1o3PkkfvV1LejIY/hq1Pj9GYEC+NU+okXcZjXopPWviS1nh+nWy0VIAaUQfnVqwtAj7RE2dGg2xgjUx7MnwfThhfC183wa+Y0743mEsqR5Vcx2JJGH3zAnGfyWRk1fCCBgqY/WxsYcFsAk+VY4wkcIxSKKVQaA7c5J98fVsCT/aZBxuqjlHIJL+YhjFk0zvOFdn53/J7ow+X+Yn//N4mJKlVmZT39Maenxv2VJdmKgo3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6916009)(6666004)(38100700002)(83380400001)(8676002)(5660300002)(86362001)(6486002)(66476007)(6506007)(8936002)(6512007)(53546011)(4326008)(52116002)(2906002)(508600001)(9686003)(7416002)(186003)(33716001)(1076003)(66556008)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sqNEkkDw29Zy65Z0nySZ0M/L8Q5JZjRnmHAeSUvtBzEQVVIQlwxRPhEeq/N3?=
 =?us-ascii?Q?azKllLtQJ+lk/uLb6qRxqaZ5KaiRXnHxCIpLqgzWE3gULQYBga5KSVlFu7r9?=
 =?us-ascii?Q?GZZXYMregGnDiwa6FjP6eg2I22pxqsTAUF9kg4RnzRBE3pqUzig21wrvyH26?=
 =?us-ascii?Q?YRsIcLOWjpzxacF8JXxzQ+wyKbraSmOJDYwxAQu/8RcHNrNu2roaJDTxxUPX?=
 =?us-ascii?Q?2tWko8khP+9++tU9CUsldce9/Kcuw6pdkarJar6tQvCuWxA4aXt5mRB3mf9s?=
 =?us-ascii?Q?UvEbOqr38uygm9KjGjcNSm67aDYLHWMoGCFCnSZD4NOKWQKM40qvMOfb86gr?=
 =?us-ascii?Q?Ch06q5Vakhh+8cHOh+odklq9ykLas4Oy4fWYhk/gFDRncWj5HPNvIr6wKnl7?=
 =?us-ascii?Q?/VWwie3gB8BZIxRbqpQBNpylnza288xw4jaqHlLRWHEqOpwshpcdOwTnKgf2?=
 =?us-ascii?Q?cJVQp/LIcqyLCK1vAapSERzn46HCscvUNZcFm53E48LNIVbNMTZ1SgM3Ba6J?=
 =?us-ascii?Q?XlA9KJHsUHqQajJVa8k1QIO+Dqh/N9stV53Gx1spEI2IYzF+C7l06/tPZbCZ?=
 =?us-ascii?Q?emkEaMeXa7NeYTGgr/opbNFTjEUgqjIjoTMvYqdSDf/ZeBgDNbOfw65pLafI?=
 =?us-ascii?Q?0cHDz2AwUsXyYZ4GRr5kqZP4fCghqUZUEo0Y1sSBHFVvZzx7fHDfXJmPeiDX?=
 =?us-ascii?Q?dB+GeWNpidGTY/TDYZBEL9qLzgtOeQydVTlIiksCDVSzJPFzbfsEcCGLXv+I?=
 =?us-ascii?Q?ShA0b6PMhmOJNh4YNsUUHSlgr/RxAoqV8yRy9Qmzq4zLU3xYggxmjCOeTI8o?=
 =?us-ascii?Q?1t9HoDoUUm/RUfLG9pZ4YrzkTKMAL/bTxtEGNkmiyL5+EPCCG59DG2sPmzHk?=
 =?us-ascii?Q?A+dgttXN9E9a9h2x7BVb2fv6LQuGWs6gAPR1xJ9qHLr1iMx2SA5yeiuBQ+aG?=
 =?us-ascii?Q?R/lKSqK9L03DCIRZGOCAsKWyySZNigDO1rGcdOluEVnyU1ZyxVQQDFtBwer3?=
 =?us-ascii?Q?ZRl4T7UcU6oAIG4PtcE5qwCKa4ermdaUo3RVqTVvqbaIMJO7w5atrHpnCkPV?=
 =?us-ascii?Q?JoCW/zPHHsCRnq9i/3XxLMlfv2MqIMsQaxwzdKGlaBf0FBlIqwXwU+ymaKpg?=
 =?us-ascii?Q?SM88e6BCUmye9L173fvOraZOIXqq1HP09tN1KPEctGpVIE/kIH5FJj33YfP9?=
 =?us-ascii?Q?keHpW+4F4+P5zj+ARuiMlRqxfY1aT6KIUvyiokdQdSQaJ/SDycuYf48QGJAz?=
 =?us-ascii?Q?Ch5sF62YlY8IcPX8LvGdcvOGR/r7qcTSNbi1jjw5BK7NgZjy9DhW2i/VMwg4?=
 =?us-ascii?Q?cKd4DUVL1sdYNoZoe0uqltz7nvqhIaH6YhKsU8j4eL3M+7n7SqqmLiGZmjbr?=
 =?us-ascii?Q?p4JC8FPgrKxKlkgRAMLiDgaFhaols9vXeSTLlQNjQJAXp91e1Ts22uPuecO5?=
 =?us-ascii?Q?c9/IMKrMYYv1t+eR5juNv0pAkXWGDzDfKXTcez5rh8an/VJKLk8zs6RS4PpS?=
 =?us-ascii?Q?aC0WJLHgDdOM3xapBMjR0vZpJLR4zg4R4tPhe8UiDS9Wgx7fp/+LcZbRx3UW?=
 =?us-ascii?Q?IXVEGH/0ffCX2ltC8mOzklMsfqQHsHobBYNCbJ1wqvGW0eaX+1cDapGXiBNQ?=
 =?us-ascii?Q?8MGXdV3zWnv0JnywWQvAqoDUb8RvvV0KqbXC9+xEU5GzKIBfP8s/OvYmmEfz?=
 =?us-ascii?Q?pdYy8WT0gd+KF56T2KnwL6VoVkg5kIv2mSDMIlId/C+K2jLJymYoXBlW5ST/?=
 =?us-ascii?Q?JnsGFTs6YWoIK0kJfgMcMkvolcaQGZo=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0aebde-c365-4cba-0f25-08da4a76a551
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 00:17:46.9140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQoV31nguQkE4wJC7UuNfIbHN4vEhaamxeFf4Kxa6E7KGoE0P2wC9+ERqn2ZY6j0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB5421
X-Proofpoint-GUID: nokUl5H8J3kgRx9_k0WPVW4vhrx2t0EW
X-Proofpoint-ORIG-GUID: nokUl5H8J3kgRx9_k0WPVW4vhrx2t0EW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-09_16,2022-06-09_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 10:29:15PM +0200, Daniel Borkmann wrote:
> On 6/9/22 3:18 AM, Jon Maxwell wrote:
> > A customer reported a request_socket leak in a Calico cloud environment. We
> > found that a BPF program was doing a socket lookup with takes a refcnt on
> > the socket and that it was finding the request_socket but returning the parent
> > LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> > 1st, resulting in request_sock slab object leak. This patch retains the
Great catch and debug indeed!

> > existing behaviour of returning full socks to the caller but it also decrements
> > the child request_socket if one is present before doing so to prevent the leak.
> > 
> > Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> > thanks to Antoine Tenart for the reproducer and patch input.
> > 
> > Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> > Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
Instead of the above commits, I think this dated back to
6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")

> > Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> > Co-developed-by: Antoine Tenart <atenart@kernel.org>
> > Signed-off-by:: Antoine Tenart <atenart@kernel.org>
> > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > ---
> >   net/core/filter.c | 20 ++++++++++++++------
> >   1 file changed, 14 insertions(+), 6 deletions(-)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 2e32cee2c469..e3c04ae7381f 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> >   {
> >   	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> >   					   ifindex, proto, netns_id, flags);
> > +	struct sock *sk1 = sk;
> >   	if (sk) {
> >   		sk = sk_to_full_sk(sk);
> > -		if (!sk_fullsock(sk)) {
> > -			sock_gen_put(sk);
> > +		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> > +		 * sock refcnt is decremented to prevent a request_sock leak.
> > +		 */
> > +		if (!sk_fullsock(sk1))
> > +			sock_gen_put(sk1);
> > +		if (!sk_fullsock(sk))
In this case, sk1 == sk (timewait).  It is a bit worrying to pass
sk to sk_fullsock(sk) after the above sock_gen_put().
I think Daniel's 'if (sk2 != sk) { sock_gen_put(sk); }' check is better.

> 
> [ +Martin/Joe/Lorenz ]
> 
> I wonder, should we also add some asserts in here to ensure we don't get an unbalance for the
> bpf_sk_release() case later on? Rough pseudocode could be something like below:
> 
> static struct sock *
> __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>                 struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
>                 u64 flags)
> {
>         struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
>                                            ifindex, proto, netns_id, flags);
>         if (sk) {
>                 struct sock *sk2 = sk_to_full_sk(sk);
> 
>                 if (!sk_fullsock(sk2))
>                         sk2 = NULL;
>                 if (sk2 != sk) {
>                         sock_gen_put(sk);
>                         if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
I don't think it matters if the helper-returned sk2 is refcounted or not (SOCK_RCU_FREE).
The verifier has ensured the bpf_sk_lookup() and bpf_sk_release() are
always balanced regardless of the type of sk2.

bpf_sk_release() will do the right thing to check the sk2 is refcounted or not
before calling sock_gen_put().

The bug here is the helper forgot to call sock_gen_put(sk) while
the verifier only tracks the sk2, so I think the 'if (unlikely...) { WARN_ONCE(...); }'
can be saved.

>                                 WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
>                                 sk2 = NULL;
>                         }
>                 }
>                 sk = sk2;
>         }
>         return sk;
> }
