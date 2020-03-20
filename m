Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339A518C4F7
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 02:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgCTBzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 21:55:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19540 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgCTBzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 21:55:01 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K1nAqd001895;
        Thu, 19 Mar 2020 18:54:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8X4tbmxT1kLsw0NEKNwswv9W1D/sYtq9peJNpSiB0iU=;
 b=E71FdH6Z2QD1Rs60jhmVl2Js5Ou5aVksg1I27MsZhqoF4yWxLpVL9o3sMH2ia2XYvn53
 lLJhw7xDrwKNWsbGvaU3F8Ej/8v9B1QFl46xtaVHlk5Em8a4IgQcqDLAzgcf4jJfXOg3
 NCTyeBcn9bJxROZsOc+ZmmC2L3OnJh+mk7A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yvg259515-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Mar 2020 18:54:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 18:54:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDvZ+RCCvcl8LP4ODgCQfcfUKHV1mSNgDSEosndo6KW2AO9N9mq/XkdhQ9Y8is4liWLA/IuT7myp/dxKk7gA8Jv7RnEvUZ20fmcH4h7Nk+pUWPpxYoSNPIfKVyBScaeHaMgTiulKDkReGypdAvIEJbBxYvihU5eFDNs3vKXuCzWn3OhfhUPGnGachb+cJ5wqgN6NBcKRLxaxceVqmvTC6IwyqwTOT+Y317sCGBX5iPIcIG8gYCvUSBSLayZFXFSy7l23Iw7fQvlpO+Iy6kWYUntRDrAvrIUIINu3DDzafB2pSkmaZIlhMl534+lzB1q3jLu/QwHzbiBG2XDIEgP3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8X4tbmxT1kLsw0NEKNwswv9W1D/sYtq9peJNpSiB0iU=;
 b=Tigci+orv8f7WRLZ67ufLL5pn0u/i867vbKK3wc/Yc5abcd4YgVn+md6Ja7NJeLjlyEzcnjFoYaImI4XsNgBdEhn9uTpWuG64JsNGRRlr2gn4qAA6Bdahssq4grY/74iuYmQZZjKgDbAsaLp0LT5R1nF8eVCBa1D322v//moLO3IrTKXs2VbTmO8eXmgGwsCzBagQBNlcEmYwOqNeYm5ujsn+finoscBG8WeC/PLywzdq8NRZ4BHRgSyAYPc19cEkxl91OqekNPwpU70aLlIqwKmChe53ilURo3O3KKyb50kXrZazWdfFlUVMIPWtqiX+114c4BpIM2BMqnBCCXpKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8X4tbmxT1kLsw0NEKNwswv9W1D/sYtq9peJNpSiB0iU=;
 b=Eee/tA3cLBnJIF+2nX9yo7mA2aKtUotQFAtSjzEjz/21dBMqw1kw3EckeXn8hSM1VMLXc3XsywQ0cTwQ7VeZMnIyyyx77G/G3xt90zEgw7AG84aw2Z6KHtcb5y89ckn2uxe0DP3D/Vf8x1oyzL8AElNBT+5JE9EGZo31o6RrPEw=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3301.namprd15.prod.outlook.com (2603:10b6:a03:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.22; Fri, 20 Mar
 2020 01:54:42 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Fri, 20 Mar 2020
 01:54:42 +0000
Date:   Thu, 19 Mar 2020 18:54:38 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
Message-ID: <20200320015438.t4qguub2jd5lfqch@kafai-mbp>
References: <20200312233648.1767-1-joe@wand.net.nz>
 <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp>
 <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
 <20200317062623.y5v2hejgtdbvexnz@kafai-mbp>
 <CAOftzPjXexvng-+77b-4Yw0pEBHXchsNVwrx+h9vV+5XBQzy-g@mail.gmail.com>
 <20200318184852.vwzuc4esqemsn7gx@kafai-mbp>
 <CAOftzPivg9nxsvvcza7v8Q-pgqZb3wy5gT9U19eGoBtzVzPPmA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOftzPivg9nxsvvcza7v8Q-pgqZb3wy5gT9U19eGoBtzVzPPmA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:104:1::21) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:17c2) by CO2PR05CA0095.namprd05.prod.outlook.com (2603:10b6:104:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Fri, 20 Mar 2020 01:54:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:17c2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff153ebe-05bd-451d-c4d6-08d7cc71a7e2
X-MS-TrafficTypeDiagnostic: BYAPR15MB3301:
X-Microsoft-Antispam-PRVS: <BYAPR15MB33017A2FE644C3984A7DF099D5F50@BYAPR15MB3301.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(366004)(136003)(39860400002)(199004)(81156014)(8676002)(53546011)(16526019)(4326008)(5660300002)(186003)(66556008)(66476007)(66946007)(9686003)(55016002)(1076003)(33716001)(86362001)(8936002)(81166006)(478600001)(2906002)(54906003)(316002)(52116002)(6916009)(6496006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3301;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BKQhYx/HdlBpudLZNZburfAzl32Cn6oGNUoe5ImW2tYi03ETkx9FoHbDf9Ex39p1Mff+rIL4dIY6NHbXAeIGh7pKc0XSjvdu2USu0dCmX10eGVHqQNkmzE1BeBrPP/DWYEYvtqSg/EXbHgEDij9Kic13y0LAZEGpbrmVi5tQ7n1O3ASDv9NU51GOoAdc02zH8pyUM40jrGFj35VvGvoSy7rFRCu4F0OzQwe4F0ZtGNkZ9nz1SBO9nVHKLcT37i1czZoXl1Pa735RW8Dd3WykilVBN2xn5IyNdUKfwCw+0kBoQeaXZpuA2zCKS0qdogyI7JEeDLofAHLSiffe+BMPW6d6K9ImIzWbZlzuswJzgbsZmHOpdclDueJictQQ3D77GwKuiDdsVA9QRsZneJ8+uajYF3sWCRpxhSc3JnECjF1M18ddKRiLGyNJ95fuSqNI
X-MS-Exchange-AntiSpam-MessageData: Cad15oYkj/W7H9cUYYfhw2dMncZJ+CUTiEMdj3NpCLpmKGPV1YesuU72MvileawDdos/7LydSIePIn0GAcn/Bdkmg0b1RZzFJm9flxSUEGGvXsIagJKyx1l413Id6rlvUJHikGf+hOfoMZIh59CNbMgCrNDwj5gSn9hJVNrfMDd37cRQAqah7aSStjS2XOQ6
X-MS-Exchange-CrossTenant-Network-Message-Id: ff153ebe-05bd-451d-c4d6-08d7cc71a7e2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 01:54:42.3347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40SGzG60NuXdHmg3V1HfOGpBY4ih4CEXtLgAAGV+uLen/cHYB/cgjKRqCBiT5mAX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3301
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 suspectscore=2 adultscore=0 malwarescore=0 clxscore=1015
 spamscore=0 phishscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 11:24:11PM -0700, Joe Stringer wrote:
> On Wed, Mar 18, 2020 at 11:49 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Mar 17, 2020 at 05:46:58PM -0700, Joe Stringer wrote:
> > > On Mon, Mar 16, 2020 at 11:27 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Mon, Mar 16, 2020 at 08:06:38PM -0700, Joe Stringer wrote:
> > > > > On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > > > > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > > > > > >
> > > > > > > This helper requires the BPF program to discover the socket via a call
> > > > > > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > > > > > helper takes its own reference to the socket in addition to any existing
> > > > > > > reference that may or may not currently be obtained for the duration of
> > > > > > > BPF processing. For the destination socket to receive the traffic, the
> > > > > > > traffic must be routed towards that socket via local route, the socket
> > > > > > I also missed where is the local route check in the patch.
> > > > > > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
> > > > >
> > > > > This is a requirement for traffic redirection, it's not enforced by
> > > > > the patch. If the operator does not configure routing for the relevant
> > > > > traffic to ensure that the traffic is delivered locally, then after
> > > > > the eBPF program terminates, it will pass up through ip_rcv() and
> > > > > friends and be subject to the whims of the routing table. (or
> > > > > alternatively if the BPF program redirects somewhere else then this
> > > > > reference will be dropped).
> > > > >
> > > > > Maybe there's a path to simplifying this configuration path in future
> > > > > to loosen this requirement, but for now I've kept the series as
> > > > > minimal as possible on that front.
> > > > >
> > > > > > [ ... ]
> > > > > >
> > > > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > > > index cd0a532db4e7..bae0874289d8 100644
> > > > > > > --- a/net/core/filter.c
> > > > > > > +++ b/net/core/filter.c
> > > > > > > @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> > > > > > >       .arg5_type      = ARG_CONST_SIZE,
> > > > > > >  };
> > > > > > >
> > > > > > > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > > > > > > +{
> > > > > > > +     if (flags != 0)
> > > > > > > +             return -EINVAL;
> > > > > > > +     if (!skb_at_tc_ingress(skb))
> > > > > > > +             return -EOPNOTSUPP;
> > > > > > > +     if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > > > > > > +             return -ENOENT;
> > > > > > > +
> > > > > > > +     skb_orphan(skb);
> > > > > > > +     skb->sk = sk;
> > > > > > sk is from the bpf_sk*_lookup_*() which does not consider
> > > > > > the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
> > > > > > However, the use-case is currently limited to sk inspection.
> > > > > >
> > > > > > It now supports selecting a particular sk to receive traffic.
> > > > > > Any plan in supporting that?
> > > > >
> > > > > I think this is a general bpf_sk*_lookup_*() question, previous
> > > > > discussion[0] settled on avoiding that complexity before a use case
> > > > > arises, for both TC and XDP versions of these helpers; I still don't
> > > > > have a specific use case in mind for such functionality. If we were to
> > > > > do it, I would presume that the socket lookup caller would need to
> > > > > pass a dedicated flag (supported at TC and likely not at XDP) to
> > > > > communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
> > > > > and used to select the reuseport socket.
> > > > It is more about the expectation on the existing SO_ATTACH_REUSEPORT_EBPF
> > > > usecase.  It has been fine because SO_ATTACH_REUSEPORT_EBPF's bpf prog
> > > > will still be run later (e.g. from tcp_v4_rcv) to decide which sk to
> > > > recieve the skb.
> > > >
> > > > If the bpf@tc assigns a TCP_LISTEN sk in bpf_sk_assign(),
> > > > will the SO_ATTACH_REUSEPORT_EBPF's bpf still be run later
> > > > to make the final sk decision?
> > >
> > > I don't believe so, no:
> > >
> > > ip_local_deliver()
> > > -> ...
> > > -> ip_protocol_deliver_rcu()
> > > -> tcp_v4_rcv()
> > > -> __inet_lookup_skb()
> > > -> skb_steal_sock(skb)
> > >
> > > But this will only affect you if you are running both the bpf@tc
> > > program with sk_assign() and the reuseport BPF sock programs at the
> > > same time.
> > I don't think it is the right answer to ask the user to be careful and
> > only use either bpf_sk_assign()@tc or bpf_prog@so_reuseport.
> 
> Applying a restriction on reuseport sockets until we sort this out per
> my other email should resolve this concern.
> 
> > > This is why I link it back to the bpf_sk*_lookup_*()
> > > functions: If the socket lookup in the initial step respects reuseport
> > > BPF prog logic and returns the socket using the same logic, then the
> > > packet will be directed to the socket you expect. Just like how
> > > non-BPF reuseport would work with this series today.
> > Changing bpf_sk*_lookup_*() is a way to solve it but I don't know what it
> > may run into when recurring bpf_prog, i.e. running bpf@so-reuseport inside
> > bpf@tc. That may need a closer look.
> 
> Right, that's my initial concern as well.
> 
> One alternative might be something like: in the helper implementation,
> store some bit somewhere to say "we need to resolve the reuseport
> later" and then when the TC BPF program returns, check this bit and if
> reuseport is necessary, trigger the BPF program for it and fix up the
> socket after-the-fact.
skb_dst_is_sk_prefetch() could be that bit.  One major thing
is that bpf@so_reuseport is currently run at the transport layer
and expecting skb->data pointing to udp/tcp hdr.  The ideal
place is to run it there.  However, the skb_dst_is_sk_prefetch() bit
is currently lost at ip[6]_rcv_core.

> A bit uglier though, also not sure how socket
> refcounting would work there; maybe we can avoid the refcount in the
> socket lookup and then fix it up in the later execution.
That should not be an issue if refcnt is not taken for
SOCK_RCU_FREE (e.g. TCP_LISTEN) in the first place.

> 
> > [...]
> > It is another question that I have.  The TCP_LISTEN sk will suffer
> > from this extra refcnt, e.g. SYNFLOOD.  Can something smarter
> > be done in skb->destructor?
> 
> Can you elaborate a bit more on the idea you have here?
I am thinking can skb->destructor do something like bpf_sk_release()?
This patch reuses tcp sock_edemux which currently only lookups the
established sk.

> 
> Looking at the BPF API, it seems like the writer of the program can
> use bpf_tcp_gen_syncookie() / bpf_tcp_check_syncookie() to generate
> and check syn cookies to mitigate this kind of attack. This at least
> provides an option beyond what existing tproxy implementations
> provide.
When the SYNACK comes back, it will still be served by a TCP_LISTEN sk.
I know refcnt sucks on synflood test.  I don't know what the effect
may be on serving those valid synack since there is no need
to measure after SOCK_RCU_FREE is in ;)

UDP is also in SOCK_RCU_FREE.  I think only early_demux, which
seems to be for connected only,  takes a refnct.
btw, it may be a good idea to add a udp test.

I am fine to push them to optimize/support later bucket
It is still good to explore a little more such that we don't
regret later.

> 
> > In general, it took me a while to wrap my head around thinking
> > how a skb->_skb_refdst is related to assigning a sk to skb->sk.
> > My understanding is it is a way to tell when not to call
> > skb_orphan() here.  Have you considered other options (e.g.
> > using a bit in skb->sk)?   It will be useful to explain
> > them in the commit message.
> 
> Good point, I did briefly explore that initially and it looked a lot
> more invasive. With that approach, any time we do some kind of socket
> handling (assign, release, steal, etc.) we have this extra bit we have to
> deal with and decide whether we need to specially handle it.
> skb->_skb_refdst already has this ugliness (see skb_dst() and friends)
> so on a practical note it seemed less invasive to me to reuse that
> infrastructure.
> 
> Conceptually I was looking at this as a metadata destination similar
> to the referred patches in one of the earlier commit messages. We
> associate this special socket destination initially, to tell ip_rcv()
> that we really do need to retain this socket and not just orphan
> it/continue with the regular destination selection logic.
> 
> I can roll this explanation into the series header and/or commit
> messages as well.
