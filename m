Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB81879A7
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 07:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgCQG05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 02:26:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49970 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbgCQG05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 02:26:57 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02H6Ludj002676;
        Mon, 16 Mar 2020 23:26:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ImjqMKvASBB1uCbp+MClOpzWot9YiYFkJp8XzwczfMY=;
 b=eX/e9Q3OwdXXBp6nqlhvD0Vq+diJNWv8bTvskUKz1PBjz0NpwzINhhlftd8+3k2ww2a2
 3GrsL2NJQTstdhHOYOQhq15hEfj4i2HmqA+e+tY70maEpqbYoBaCjyIM8xK3C8iqp72M
 vrNG0Toeen1+dtimX6SaWV5lXMBYJTOZZzQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yts6vg0m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 23:26:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 23:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d28YAz/Ow7HpOC/qEqFMVLnjfFXIzFxbVG/24rjVmewlUFF6Eb7QL+JxVHhTWnGPXPijmCPl+RDpW02YdNOhpqeK6AeVnMAJI7IznvEjYpvNkDu+i8k35vkB4Bgv/vIXixRdMH0MS4KQ9+HnodG4TEKbQFQA+5UDpxAZG/yDKJpHTDE+/unJ42yiIE1+WFpVRB4Op5NusszMCZOYg9D+4cYl7HJdtuCUjmHECxG12H/7hvciuymzP0dl7ZQDgmYXgffhFelWLhNyi7FV7dzxjX1B8B279lPXrwimDC+ThcFBn/AS5f7HgFBm5abF7pxUP20jFatIlR8Q/vwtvN6Qqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImjqMKvASBB1uCbp+MClOpzWot9YiYFkJp8XzwczfMY=;
 b=ITQp8hUkdqKDfCaNwm4Y1nmXeqh7tUHe+QUIG7XpmHGYsxnpcnr4qBPSSpKCNDE4ZlWpoNmEj9bleaKohqS0hzuWHuG41J1uXysjZQSZyovm1tJZ8VSbgMRcQ8fXMMkEWhthhUvTRJQvHbnILwhG4jT7qLfwi/Ha4sbR5/1xVbTii5pf/dJbYX4sEIAPgD9SouQMB9zbk9dMJUmNvEUHoYEdfui19xX+UXZR8+a+Y9ruOuvAPtszwG8IXn+OpZOcaXX7tCCxH/7w/UgXglzUp1ha5IYGRmTK3lWod5a8hFF+tbPURONJDrH2P6G1fAHDcGqDPX5bvhSgRmJ8uTvIxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImjqMKvASBB1uCbp+MClOpzWot9YiYFkJp8XzwczfMY=;
 b=eIRrknMuMGr2vrDwKivGuoLZSURc4E2lC1NWquKAJy4Fs4c1AiwyTSBRRF9V/aE4iCzbnhcoOIKsMS6Hvea0R2YRo2CI3jG3db7cGewkdi+olAAAAQWNZ1DreHXcZyACFTFDPpwVJSZPoseM8i6Yv883FfZbZwoYAcAngZFLD3U=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2853.namprd15.prod.outlook.com (2603:10b6:a03:fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Tue, 17 Mar
 2020 06:26:26 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 06:26:26 +0000
Date:   Mon, 16 Mar 2020 23:26:23 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
Message-ID: <20200317062623.y5v2hejgtdbvexnz@kafai-mbp>
References: <20200312233648.1767-1-joe@wand.net.nz>
 <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp>
 <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR22CA0033.namprd22.prod.outlook.com
 (2603:10b6:300:69::19) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by MWHPR22CA0033.namprd22.prod.outlook.com (2603:10b6:300:69::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Tue, 17 Mar 2020 06:26:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fd6aaae-32ac-4c4b-af2e-08d7ca3c1eff
X-MS-TrafficTypeDiagnostic: BYAPR15MB2853:
X-Microsoft-Antispam-PRVS: <BYAPR15MB28531A9AB424B0A04F231B2FD5F60@BYAPR15MB2853.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(136003)(366004)(376002)(199004)(6496006)(1076003)(8936002)(52116002)(81166006)(9686003)(81156014)(55016002)(966005)(8676002)(5660300002)(478600001)(54906003)(16526019)(33716001)(186003)(6916009)(86362001)(4326008)(2906002)(66476007)(53546011)(66946007)(316002)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2853;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0oc78924eqyZ/gPfsg79kVW5y0nmp/LaVvjGzoRYiQdHSti5Q7V/0nwtSSU5u2NP/HLmQ9ZonVIZsWXg2c+WAfZlZh1pZvGPfHlRxgYTQKdQhOV5SVX1FkBe3oJlgrqt0VaF08qwsE7dIAvX9p9FHjf28q3QnbetYR6jl1YuxrjEFDAH5+Vtl4KYSZzSZDI1DfXSZJgYbKCifvkPKTtGYOmL1yug2zJrZffhEcvCz9w5AJ8ET9uRob0L7jCotnqo6TDaBhU5IY3VXcFT+gF6WC/HJUyy5cvA6iCmr00jdQaHxlKPrY9wLjROqdBdrsW18fUrqAmHQ2fPVzuKXdfAjWLyZUT0pS5yIYQjAwogOXY0zHK+MiiS3ITudgXdEBJ0tbRvoxMjcevmemdwfcwyB4b/+1izNfphyYPzRiqw7EGmyZReX6lrBK9fW1owLLXRuFMymy5RgbHn3HmuR5/yh+fc8GkWgxMUVVivK5Th4QTt113sJZdqdKj1aR1buwWbQq1HsAKNvmoR2hDryN5lw==
X-MS-Exchange-AntiSpam-MessageData: YmRIb4oXQ2IFVZPaqz0bVmG2FvDfDfIrhIKZRFVcBpZhPeGypdBuRDz2wv3g/tbfpmbWjpsb8oydQ8AunYR1O96M4aAF/0kUQq7Uisoh5Q8IqV9+3UVXTWQ31N+Nm6jboj3qR3OMZkNlyxN/8yt+K3PT2igiZakGByZK+6bCTJ6Em5LmlppfcvkY6zSrK+qx
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd6aaae-32ac-4c4b-af2e-08d7ca3c1eff
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 06:26:26.4994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ym7r9111jlJxWdGk3pWxCZH7s1V12a5d2bRosZZGJkczkCUBp7m86OjSYsRrTBiR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2853
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_01:2020-03-12,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 08:06:38PM -0700, Joe Stringer wrote:
> On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > >
> > > This helper requires the BPF program to discover the socket via a call
> > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > helper takes its own reference to the socket in addition to any existing
> > > reference that may or may not currently be obtained for the duration of
> > > BPF processing. For the destination socket to receive the traffic, the
> > > traffic must be routed towards that socket via local route, the socket
> > I also missed where is the local route check in the patch.
> > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
> 
> This is a requirement for traffic redirection, it's not enforced by
> the patch. If the operator does not configure routing for the relevant
> traffic to ensure that the traffic is delivered locally, then after
> the eBPF program terminates, it will pass up through ip_rcv() and
> friends and be subject to the whims of the routing table. (or
> alternatively if the BPF program redirects somewhere else then this
> reference will be dropped).
> 
> Maybe there's a path to simplifying this configuration path in future
> to loosen this requirement, but for now I've kept the series as
> minimal as possible on that front.
> 
> > [ ... ]
> >
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index cd0a532db4e7..bae0874289d8 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> > >       .arg5_type      = ARG_CONST_SIZE,
> > >  };
> > >
> > > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > > +{
> > > +     if (flags != 0)
> > > +             return -EINVAL;
> > > +     if (!skb_at_tc_ingress(skb))
> > > +             return -EOPNOTSUPP;
> > > +     if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > > +             return -ENOENT;
> > > +
> > > +     skb_orphan(skb);
> > > +     skb->sk = sk;
> > sk is from the bpf_sk*_lookup_*() which does not consider
> > the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
> > However, the use-case is currently limited to sk inspection.
> >
> > It now supports selecting a particular sk to receive traffic.
> > Any plan in supporting that?
> 
> I think this is a general bpf_sk*_lookup_*() question, previous
> discussion[0] settled on avoiding that complexity before a use case
> arises, for both TC and XDP versions of these helpers; I still don't
> have a specific use case in mind for such functionality. If we were to
> do it, I would presume that the socket lookup caller would need to
> pass a dedicated flag (supported at TC and likely not at XDP) to
> communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
> and used to select the reuseport socket.
It is more about the expectation on the existing SO_ATTACH_REUSEPORT_EBPF
usecase.  It has been fine because SO_ATTACH_REUSEPORT_EBPF's bpf prog
will still be run later (e.g. from tcp_v4_rcv) to decide which sk to
recieve the skb.

If the bpf@tc assigns a TCP_LISTEN sk in bpf_sk_assign(),
will the SO_ATTACH_REUSEPORT_EBPF's bpf still be run later
to make the final sk decision?

> 
> > > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > > index 7b089d0ac8cd..f7b42adca9d0 100644
> > > --- a/net/ipv6/ip6_input.c
> > > +++ b/net/ipv6/ip6_input.c
> > > @@ -285,7 +285,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> > >       rcu_read_unlock();
> > >
> > >       /* Must drop socket now because of tproxy. */
> > > -     skb_orphan(skb);
> > > +     if (skb_dst_is_sk_prefetch(skb))
> > > +             dst_sk_prefetch_fetch(skb);
> > > +     else
> > > +             skb_orphan(skb);
> > If I understand it correctly, this new test is to skip
> > the skb_orphan() call for locally routed skb.
> > Others cases (forward?) still depend on skb_orphan() to be called here?
> 
> Roughly yes. 'locally routed skb' is a bit loose wording though, at
> this point the BPF program only prefetched the socket to let the stack
> know that it should deliver the skb to that socket, assuming that it
> passes the upcoming routing check.
Which upcoming routing check?  I think it is the part I am missing.

In patch 4, let say the dst_check() returns NULL (may be due to a route
change).  Later in the upper stack, it does a route lookup
(ip_route_input_noref() or ip6_route_input()).  Could it return
a forward route? and I assume missing a skb_orphan() call
here will still be fine?

> 
> For more discussion on the other cases, there is the previous
> thread[1] and in particular the child thread discussion with Florian,
> Eric and Daniel.
> 
> [0] https://urldefense.proofpoint.com/v2/url?u=https-3A__www.mail-2Darchive.com_netdev-40vger.kernel.org_msg253250.html&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=mX45GxyUJ_HfsBIJTVMZY9ztD5rVViDuOIQ0pXtyJcM&s=z5lZSVTonmhT5OeyxsefzUC2fMqDEwFvlEV1qkyrULg&e= 
> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_netdev_msg580058.html&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=mX45GxyUJ_HfsBIJTVMZY9ztD5rVViDuOIQ0pXtyJcM&s=oFYt8cTKQEc-wEfY5YSsjfVN3QqBlFGfrrT7DTKw1rc&e= 
