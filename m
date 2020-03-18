Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B30B18A298
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 19:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCRStO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 14:49:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbgCRStO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 14:49:14 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IIb40P018507;
        Wed, 18 Mar 2020 11:48:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=73T5B5k0bki4g0W/EAMH4tu0M02evZiS1Ed6O+rMInc=;
 b=VFte6w/5tQSV86Nd5THareK7B5zT9SrFxm/PbNX9cLnAeGQdjOCEX/4sJ1qCO7qE6+bk
 nz4Z5lvGICkT1h8W5t2fx+msbQpJV+d0i2u78I1CfwWejkuRXODKVRIGj0npwKpxWdRm
 /2dQAnfTqOUJ6QmOgifMQ7Fl7pBH6jsNevQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu7j24hr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Mar 2020 11:48:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 18 Mar 2020 11:48:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMwB9aYJ4aVCyIBGtQfOsh4lqbUESHRWRynrub/o2+l6k3kM7B3MbnJ9LImHqzm6e/p8NRLb96CNsVQ/2C+Nspb68OTyGM0BFds6Fb5rYmT0BQYP+wj4CKBxF/5JpL7pihvwCP1a1vDigeFaQ8RbhVSXdIgerFYmkiQ6dgKlLNH/Qo7SAKpVyPqUnk9njRr2H6om7cX99B/e9p6YI+za6hCZsyWh+WmeJnzFfVb1iNxxrLPFSCVIfAqBLH7BttLFWCAXW6DWlYboZualFYNuLF61xnQOQuwYHU74aaBhj4XaU2v5zsmVkrmlBF0zEXpTP4apKl6hHAdTHW/9STtyjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73T5B5k0bki4g0W/EAMH4tu0M02evZiS1Ed6O+rMInc=;
 b=I1kY8zD4Azo6l+8K1hxFYy4Q9bla9q5PAJcES5t9s8ypgkLqUc5gjCIULdvGRHWnO+dDjxM8fhmrkOQj08X59gGucqAmvqaDpQ3cG8T4i4bii8KYxHDhKvNAiT1Dw9hdJDeA1hcw3qX6iR5GTIHaLKEnA+YuoRMlkkuzGEFMmGqH5lUThL5cNI7uJmOfBvjbT7Oi8+6sE29pEwx+HKf9BXi9WwJrWZH7ZDZ+xvVum1MPcriSoFFavrfvxKgnsNBfe2GHzQekA5E5amMO8tdnlNPFoccBrRnVrUi9q61M6eNfEprWzZU7P+tiHzgT05fOtTUzU0O38cgTTaGgSAMQGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73T5B5k0bki4g0W/EAMH4tu0M02evZiS1Ed6O+rMInc=;
 b=KnDZHKPZmV7oN4/UKqYlVUoDRLfY1eCLRquEUWt/Bq4pK/EWO0fjzmNxvBH6jvwMO7JxUVYH57eeZIa3CgJGqtJ7r63g0jJGdTcPhzMN/9pNNct+Zq/2n1fK4GfBywP3yHZTBwF3Ay/srDmab3DqHOKLIY12JhnXk83N2hvcV2Q=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2933.namprd15.prod.outlook.com (2603:10b6:a03:f6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 18 Mar
 2020 18:48:55 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 18:48:55 +0000
Date:   Wed, 18 Mar 2020 11:48:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
Message-ID: <20200318184852.vwzuc4esqemsn7gx@kafai-mbp>
References: <20200312233648.1767-1-joe@wand.net.nz>
 <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp>
 <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
 <20200317062623.y5v2hejgtdbvexnz@kafai-mbp>
 <CAOftzPjXexvng-+77b-4Yw0pEBHXchsNVwrx+h9vV+5XBQzy-g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOftzPjXexvng-+77b-4Yw0pEBHXchsNVwrx+h9vV+5XBQzy-g@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:104:1::29) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:9ce5) by CO2PR05CA0103.namprd05.prod.outlook.com (2603:10b6:104:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.11 via Frontend Transport; Wed, 18 Mar 2020 18:48:54 +0000
X-Originating-IP: [2620:10d:c090:400::5:9ce5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b86cdc06-e3d6-4446-afb9-08d7cb6d0280
X-MS-TrafficTypeDiagnostic: BYAPR15MB2933:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2933BDDC55DBC143BD3ED9C0D5F70@BYAPR15MB2933.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(39860400002)(396003)(199004)(66556008)(66476007)(4326008)(81166006)(966005)(33716001)(5660300002)(81156014)(66946007)(86362001)(8676002)(1076003)(8936002)(54906003)(55016002)(53546011)(9686003)(6496006)(316002)(2906002)(6916009)(186003)(16526019)(478600001)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2933;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uq72oJoGHm0/cKv4TNEl+/WKsiUEEwdrgCZ4Y3gvbHO3yXVXrxTNZSlFnZlsFbeSMEkcimWuYvg2rLR6JGD2hWVY2a4HIw4W1mWYim3dy9mFI3Tk/PBjTfedruEJ+P24qeEK5+/9W2kbTnR0zzQ7CD6/nErtI2bmlbh+LTW5KXWFmybKYOo4PbCZ7AmV1uz62+GjsOi8kdF98hetX4iPSsCJLn2Y8GA5bueoOhLEIlJq99mGg5KMv/xHcIyUyVKPjxJUgWhFZ5OL+8lEHdkJAprQ1wMCGArpDN47VdUHQfR45++dYmlLEy4ob4vqaacy5GUm54Or76VLFhwGSPcmzNjNovbkdNrUhQOpiW2G8gz2zC2idgmvb0hc96INwC1ej/GB66ruHSxOJEVlSfqHI7EXx1kj3ItfiF2zpDY8POmUl1BNLx37LH33TBXhg+xVMFWSPE1P4DjHleSnL55M7lAYvJrpksc8cusv9bpQQBo7+c5V04NZPUpnK/2FJbXC0SOZDoihBZE7ZrDu4g7DAA==
X-MS-Exchange-AntiSpam-MessageData: 3Ohz4Ej0cPVP8GrB1R+XO80Fq+0ufuVLfy3m0H7YIOGKzTnqi4Nz8WbCJf6ZN2BQO8tWApuOM4VbQ8FvvgUv3Y+j89rVVaIlo5N709dfD7pwIeNfAeXd7eUgMoZjQz07V86Gklt/yzeDhN45ixHfbWj+wMfoRrK+w9YhhDXLrpFvgpTsuW+7HriuH16ciX+2
X-MS-Exchange-CrossTenant-Network-Message-Id: b86cdc06-e3d6-4446-afb9-08d7cb6d0280
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 18:48:55.1785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKRbC9l+ffRo64Ht6/yYxxHfd4Ym5wIZ2pxnYbcqjqLoFu0OuZkdzsXY4s0BPjB+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2933
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180083
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 05:46:58PM -0700, Joe Stringer wrote:
> On Mon, Mar 16, 2020 at 11:27 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Mon, Mar 16, 2020 at 08:06:38PM -0700, Joe Stringer wrote:
> > > On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > > > >
> > > > > This helper requires the BPF program to discover the socket via a call
> > > > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > > > helper takes its own reference to the socket in addition to any existing
> > > > > reference that may or may not currently be obtained for the duration of
> > > > > BPF processing. For the destination socket to receive the traffic, the
> > > > > traffic must be routed towards that socket via local route, the socket
> > > > I also missed where is the local route check in the patch.
> > > > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
> > >
> > > This is a requirement for traffic redirection, it's not enforced by
> > > the patch. If the operator does not configure routing for the relevant
> > > traffic to ensure that the traffic is delivered locally, then after
> > > the eBPF program terminates, it will pass up through ip_rcv() and
> > > friends and be subject to the whims of the routing table. (or
> > > alternatively if the BPF program redirects somewhere else then this
> > > reference will be dropped).
> > >
> > > Maybe there's a path to simplifying this configuration path in future
> > > to loosen this requirement, but for now I've kept the series as
> > > minimal as possible on that front.
> > >
> > > > [ ... ]
> > > >
> > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > index cd0a532db4e7..bae0874289d8 100644
> > > > > --- a/net/core/filter.c
> > > > > +++ b/net/core/filter.c
> > > > > @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> > > > >       .arg5_type      = ARG_CONST_SIZE,
> > > > >  };
> > > > >
> > > > > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > > > > +{
> > > > > +     if (flags != 0)
> > > > > +             return -EINVAL;
> > > > > +     if (!skb_at_tc_ingress(skb))
> > > > > +             return -EOPNOTSUPP;
> > > > > +     if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > > > > +             return -ENOENT;
> > > > > +
> > > > > +     skb_orphan(skb);
> > > > > +     skb->sk = sk;
> > > > sk is from the bpf_sk*_lookup_*() which does not consider
> > > > the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
> > > > However, the use-case is currently limited to sk inspection.
> > > >
> > > > It now supports selecting a particular sk to receive traffic.
> > > > Any plan in supporting that?
> > >
> > > I think this is a general bpf_sk*_lookup_*() question, previous
> > > discussion[0] settled on avoiding that complexity before a use case
> > > arises, for both TC and XDP versions of these helpers; I still don't
> > > have a specific use case in mind for such functionality. If we were to
> > > do it, I would presume that the socket lookup caller would need to
> > > pass a dedicated flag (supported at TC and likely not at XDP) to
> > > communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
> > > and used to select the reuseport socket.
> > It is more about the expectation on the existing SO_ATTACH_REUSEPORT_EBPF
> > usecase.  It has been fine because SO_ATTACH_REUSEPORT_EBPF's bpf prog
> > will still be run later (e.g. from tcp_v4_rcv) to decide which sk to
> > recieve the skb.
> >
> > If the bpf@tc assigns a TCP_LISTEN sk in bpf_sk_assign(),
> > will the SO_ATTACH_REUSEPORT_EBPF's bpf still be run later
> > to make the final sk decision?
> 
> I don't believe so, no:
> 
> ip_local_deliver()
> -> ...
> -> ip_protocol_deliver_rcu()
> -> tcp_v4_rcv()
> -> __inet_lookup_skb()
> -> skb_steal_sock(skb)
> 
> But this will only affect you if you are running both the bpf@tc
> program with sk_assign() and the reuseport BPF sock programs at the
> same time.
I don't think it is the right answer to ask the user to be careful and
only use either bpf_sk_assign()@tc or bpf_prog@so_reuseport.

> This is why I link it back to the bpf_sk*_lookup_*()
> functions: If the socket lookup in the initial step respects reuseport
> BPF prog logic and returns the socket using the same logic, then the
> packet will be directed to the socket you expect. Just like how
> non-BPF reuseport would work with this series today.
Changing bpf_sk*_lookup_*() is a way to solve it but I don't know what it
may run into when recurring bpf_prog, i.e. running bpf@so-reuseport inside
bpf@tc. That may need a closer look.

> 
> > >
> > > > > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > > > > index 7b089d0ac8cd..f7b42adca9d0 100644
> > > > > --- a/net/ipv6/ip6_input.c
> > > > > +++ b/net/ipv6/ip6_input.c
> > > > > @@ -285,7 +285,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> > > > >       rcu_read_unlock();
> > > > >
> > > > >       /* Must drop socket now because of tproxy. */
> > > > > -     skb_orphan(skb);
> > > > > +     if (skb_dst_is_sk_prefetch(skb))
> > > > > +             dst_sk_prefetch_fetch(skb);
> > > > > +     else
> > > > > +             skb_orphan(skb);
> > > > If I understand it correctly, this new test is to skip
> > > > the skb_orphan() call for locally routed skb.
> > > > Others cases (forward?) still depend on skb_orphan() to be called here?
> > >
> > > Roughly yes. 'locally routed skb' is a bit loose wording though, at
> > > this point the BPF program only prefetched the socket to let the stack
> > > know that it should deliver the skb to that socket, assuming that it
> > > passes the upcoming routing check.
> > Which upcoming routing check?  I think it is the part I am missing.
> >
> > In patch 4, let say the dst_check() returns NULL (may be due to a route
> > change).  Later in the upper stack, it does a route lookup
> > (ip_route_input_noref() or ip6_route_input()).  Could it return
> > a forward route? and I assume missing a skb_orphan() call
> > here will still be fine?
> 
> Yes it could return a forward route, in that case:
> 
> ip_forward()
> -> if (unlikely(skb->sk)) goto drop;
> 
> Note that you'd have to get a socket reference to get to this point in
It is another question that I have.  The TCP_LISTEN sk will suffer
from this extra refcnt, e.g. SYNFLOOD.  Can something smarter
be done in skb->destructor?

In general, it took me a while to wrap my head around thinking
how a skb->_skb_refdst is related to assigning a sk to skb->sk.
My understanding is it is a way to tell when not to call
skb_orphan() here.  Have you considered other options (e.g.
using a bit in skb->sk)?   It will be useful to explain
them in the commit message.

> the first place. I see two options:
> * BPF program operator didn't set up the routes correctly for local
> socket destination
> * BPF program looks up socket in another netns and tries to assign it.
> 
> For the latter case I could introduce a netns validation check to
> ensure it matches the netns of the device.
> 
> > >
> > > For more discussion on the other cases, there is the previous
> > > thread[1] and in particular the child thread discussion with Florian,
> > > Eric and Daniel.
> > >
> > > [0] https://urldefense.proofpoint.com/v2/url?u=https-3A__www.mail-2Darchive.com_netdev-40vger.kernel.org_msg253250.html&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=mX45GxyUJ_HfsBIJTVMZY9ztD5rVViDuOIQ0pXtyJcM&s=z5lZSVTonmhT5OeyxsefzUC2fMqDEwFvlEV1qkyrULg&e=
> > > [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_netdev_msg580058.html&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=mX45GxyUJ_HfsBIJTVMZY9ztD5rVViDuOIQ0pXtyJcM&s=oFYt8cTKQEc-wEfY5YSsjfVN3QqBlFGfrrT7DTKw1rc&e=
