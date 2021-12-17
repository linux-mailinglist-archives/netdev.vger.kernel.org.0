Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E7547815B
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhLQAdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:33:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40866 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230354AbhLQAdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 19:33:32 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BGL7xGo031502;
        Thu, 16 Dec 2021 16:33:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Jh2/Xfo3OCTcWVeRPGuB958roEeIFwxvDN71539ylfU=;
 b=ZKSySgvVWzROeUrPGIdrKpHSfPxTzKpwY9TgLd6uXII9h1Wd7vD89GX2P7jYqgPNe4r0
 eHgBEG//TGRQ1yGdG3B34PqQSjzenXgBXI4e+psm96ZDfs+vRgch+2Ps8QcH2ODbk7kb
 Kr+cDQ7c1URuA/nQyCmSKXEm43P6Ig1PaI0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3d0d3hs6by-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Dec 2021 16:33:15 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 16:33:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIOx3+KEdvdWfw75+xDIMuyWj6jUFm/CFUz6H/JnphMk+LM3p/jXUl0IjAbCtuyyaL5KMmeqUl8TAV2xi10nz/TQxIImUfFQnqYXbCF4JIKj3H7d1VrY+XxcRRBB3kTTSVpdn4Hce1YyfE8noEzP0RiIQSXlg+sV9Zmvu+XBEMtOxnZJBS4uMjawoLt9Ekr33cpy7t9e0N9HSHoXs9IYpIp2z+hSoCVQhLZQMcUvUmtQ8vVY4UU71UsmEyRakm3v7R/8R4wJTvot9sp2d5dpn/+ZLBFjnFq+cSmbuEkMlhDAy4RTRNnabI32YKZFzaeC4jG8g7VPVD2gzLFfg9bJXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jh2/Xfo3OCTcWVeRPGuB958roEeIFwxvDN71539ylfU=;
 b=QbNYdz4v7l0Dj59VoYqCo+7AqGfAtCzYBodkMd/QeLJzOiUogJCiWaoAhS5nFhuNKRJef6Zy3Of/etL02HZneh5Vm5A9uYnQ8ocBJxVSoXMTSoownkP/cefzE+gQMAcGN1uTMpOKFXZ+/NBk0zvWhn3MXyNmA69i3+5fFfVMuUZVJlhm8Vu8KKyfFysXdFTVBhBcRrMzCVNhRE9hEXaI8r9AQYcRu56ybKtKX+BgLLuD2QI6N68+80V50F92hAGb+dko06Q7cCqxoddzx+bimBLTD69c62vuDF7F3+SDbcBISVS8x2cneZePmqSE74W/6dZ8WYSDlDIwIeToWiy8ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB2013.namprd15.prod.outlook.com (2603:10b6:805:5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 00:33:12 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 00:33:11 +0000
Date:   Thu, 16 Dec 2021 16:33:07 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during
 forward
Message-ID: <20211217003307.hm6yoznmpfu5jd26@kafai-mbp.dhcp.thefacebook.com>
References: <20211215201158.271976-1-kafai@fb.com>
 <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
 <20211216222332.fltkclu4x3udpomr@kafai-mbp.dhcp.thefacebook.com>
 <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0383.namprd04.prod.outlook.com
 (2603:10b6:303:81::28) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 202972a0-bd4d-4337-b5b2-08d9c0f4ce4b
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2013:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2013566617026EA6202AEC3ED5789@SN6PR1501MB2013.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: il3af0ZauHQBOrlT7YTg4l6HiVp7iBq3/q0IcJJt4/59ptGmtRIwQYxfDvDunqm1Hqb6R3x9D2sAdhHJNAfZW+amU9z1WBEanxP11besb+WhGSX4AUJ4w/luIpVsKMgUr03g5ebv7cn2zpIyvStg0RwwhY0JMlQdOhQZ/e98EeG/cJXp30e5bhKHMeWhmHS0YpfmCe3rRLTtdZyHGU6+hJ7w7T6VlGIj36b7k99rPkCM4gvJKWKTLsrpXhv7oIMW37lrqfPU5GSrglnQ4QnrxilBMVJ/AFnzHtQlZiiwjuLCV/0r4UvyugteqKKH6SzLkElqnlL3o5DnjPF4u+IYQv5zOXtf9eyANVPHLcKXnU4jSdnBYafbSFAlDA+E5OCxl8zujxS2MYLjYDtiXI4KmXecZvZvps2GKKoNVs3d6n5F0zMoGKampV2tK74do4ptZmqGiWpn+TazfLGlFfhcwUP+W172lfenlMF4gucUkE9LSfEzrxbBu+jsBsRtnqoFeE8vu1mA0nI3QuMUjfVaEPlRsAeVoUwDaF4p3yDULQ/tm4Z5y/5p9W0dIj/9P+cqjBjyd4LsSZB0MaDcRbgDHPTr0k/ahrDd2Ri/vJvXVIBtuKaqnhNmh5+40jCwsvkDOJy/53Bl1WhMRjx1mdRqMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(5660300002)(86362001)(4326008)(54906003)(316002)(9686003)(6486002)(508600001)(6666004)(186003)(1076003)(2906002)(6512007)(6506007)(52116002)(66476007)(66556008)(66946007)(8936002)(83380400001)(8676002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G3nJB7tuRibIQksuDnokavMuagiN+vjoMZvdryiWEnrzpFBjFaD+IAW1PeyE?=
 =?us-ascii?Q?rwvbdj5pFGCoF7VE6kM6Vh2BzDx9J50sYsLoPZtY5MU0guOqFcCqScBIFlsQ?=
 =?us-ascii?Q?WS700rJlyTppObZEklmyXoDQtgPqMXZe5cOeaNiRG9DDJmkin6t5CsC0D4sM?=
 =?us-ascii?Q?IPYxMUHHyNwermSRC2vgzMAPJq1MHWZtD7UjihuzWqvvy7BnyoutT27wgS5C?=
 =?us-ascii?Q?n2wKYKLeOEZe9Q2lqNmxFB2Fw9srXuKVbKsD8C2OCSDJtIQaK0+1Ucm/3yck?=
 =?us-ascii?Q?LcLJQXqzxoJO2vj/kWV8MfVK6Ioyl68B0d7unzOp39wjxyQo6V87PWVISFL5?=
 =?us-ascii?Q?FHShihhxsSr2t5gVJyS3zRyyM8lZxv8bQE7EEuhRLg50VZS/0AJY626fxom+?=
 =?us-ascii?Q?2Ke4ZLaZyjKKofkB7Djp+JZVOAShSBY7Ey+E6MlSooc6rNdbeEeJMexRsAnF?=
 =?us-ascii?Q?hLrQerhZfHH9PRqI6Tp+tEsfA5cDP5Phk8HmEY592KAjjHCg/Mm5eDk3YoA3?=
 =?us-ascii?Q?ZOnIUkpyc/iyi9kxaCLlJQQBEbM+96/kI73bh1A6KfjxuZNo0xgcQoEwzS8t?=
 =?us-ascii?Q?KKtlyho2cXxSiRi4d31PsheJHrdcGjXqzfMzHDXpWeL6AimGfIWNGN7A9Ahg?=
 =?us-ascii?Q?yer0E0vkZRnlRFvrMw3Q3HDHLqu6/byW85wE0RqQcKLNjBcJBU2C7DFDDS7K?=
 =?us-ascii?Q?VjazoLT9C2/+u7KjDr6+64u0msQ/0JRSCvMsb4u6OAvHH8wJ2RHKN2owHi3p?=
 =?us-ascii?Q?D0HecpJjtP2EdUZ1J37M17fH7NbjB1JWOf6kfOquqbHcB+2/1gj/vbZ05nN9?=
 =?us-ascii?Q?kdsOBcNekjYwAzQCsoOG5sZ0Dq2/NsTnumXQMbZDTNCmD9DAafirW8cPhli/?=
 =?us-ascii?Q?mKN+H/Sb6zOvoOF7LrKLUOrQ1nj4IW+AP4SGLMuT++iajQg80npeqNLoFLsg?=
 =?us-ascii?Q?nTejYo4uUlTLjA+8Shp4hY5qAvdWRtOGyZOtwP6IkqCEcKJtegu5IDk1L6eB?=
 =?us-ascii?Q?Z9R93vhFdtk1eKEjnSH31O8mQ9iD9IEt2SokRgloDAR8+64spy6R9Qmqx3/V?=
 =?us-ascii?Q?SPFevLdVztLHViAYqQ5BbCrd0+EB5wgaPED0iDe7YWRkM//qWvdfYPSRPx2Q?=
 =?us-ascii?Q?yWCgvfUhnK1ACKGoF1HCBPPAjIfYT+zFtShizWtoodIOZDdtFC4OUlufZ+ww?=
 =?us-ascii?Q?RsToFLfLvFfS5BlxMP73zSmqVKjA5Leqv5d1STBdEUGLBNnofFaTwepXYySA?=
 =?us-ascii?Q?g6OqviCE1L+ui5u1DSVkelSMu4VzHcHhOZwOvxNNWZ0t/IVsU84y4euULxAG?=
 =?us-ascii?Q?UsQ30+NJJ1hijKAgzpRZ16rVnWdeAkLHN2uU/VPJfLHdxu1Y5mIF7r51k+xu?=
 =?us-ascii?Q?RS0AbLq//o3GjKDs6AA7INbwZdyfx356LCGIwYHyItWoEDXlzGuW4pDqPzWG?=
 =?us-ascii?Q?/OYHu/lB0BalFCrBHvcMh+1nBSMwjVl5RWkl5au44s+npsmbAf69Hz+qnv7p?=
 =?us-ascii?Q?a2wA7hGCU4/lsQL2tdXAtE0GGTtvIUPWHinqud8asonYrpIvcQlGv8dx6Wx9?=
 =?us-ascii?Q?r90BeXRkSkfGqmL6MiJNgC3G0qnM90TeD76DjU6AZgQS9Byz9D1r48keGcGG?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 202972a0-bd4d-4337-b5b2-08d9c0f4ce4b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 00:33:11.8463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GY6RkgzgVBH3CBU4eJJpliswnoVZ/mP/p8RwY3LZbfN3pCWHnRF1ooGh62r6S9RD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2013
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: mYwPo3k4qBNVNVlB8a2vnOx5lNE2LuZQ
X-Proofpoint-ORIG-GUID: mYwPo3k4qBNVNVlB8a2vnOx5lNE2LuZQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_09,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 mlxscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 05:58:49PM -0500, Willem de Bruijn wrote:
> > > > @@ -530,7 +538,14 @@ struct skb_shared_info {
> > > >         /* Warning: this field is not always filled in (UFO)! */
> > > >         unsigned short  gso_segs;
> > > >         struct sk_buff  *frag_list;
> > > > -       struct skb_shared_hwtstamps hwtstamps;
> > > > +       union {
> > > > +               /* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
> > > > +                * tx_delivery_tstamp is stored instead of
> > > > +                * hwtstamps.
> > > > +                */
> > >
> > > Should we just encode the timebase and/or type { timestamp,
> > > delivery_time } in th lower bits of the timestamp field? Its
> > > resolution is higher than actual clock precision.
> > In skb->tstamp ?
> 
> Yes. Arguably a hack, but those bits are in the noise now, and it
> avoids the clone issue with skb_shinfo (and scarcity of flag bits
> there).
> 
> > >
> > > is non-zero skb->tstamp test not sufficient, instead of
> > > SKBTX_DELIVERY_TSTAMP_ALLOW_FWD.
> > >
> > > It is if only called on the egress path. Is bpf on ingress the only
> > > reason for this?
> > Ah. ic.  meaning testing non-zero skb->tstamp and then call
> > skb_save_delivery_time() only during the veth-egress-path:
> > somewhere in veth_xmit() => veth_forward_skb() but before
> > skb->tstamp was reset to 0 in __dev_forward_skb().
> 
> Right. If delivery_time is the only use of skb->tstamp on egress, and
> timestamp is the only use on ingress, then the only time the
> delivery_time needs to be cached if when looping from egress to
> ingress and this field is non-zero.
> 
> >
> > Keep *_forward() and bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)
> > because the skb->tstamp could be stamped by net_timestamp_check().
> >
> > Then SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is not needed.
> >
> > Did I understand your suggestion correctly?
> 
> I think so.
> 
> But the reality is complicated if something may be setting a delivery
> time on ingress (a BPF filter?)
If bpf@ingress needs to set a delivery_time, the only reasonable
usecase is to finally egress it out by calling bpf_redirect_neigh().
One option is to have a new bpf_redirect_*() helper to take the fifth
'delivery_time' argument and have the skb_do_redirect() to set
the delivery_time in skb.  An extra helper is not ideal but probably
acceptable considering other tricky constraints we are working with.

Another potential issue is,
after looping from egress to ingress, the skb->tstamp has the delivery_time.
If it is passing up to the stack, it needs to be reset back to
timestamp (skb->tstamp = ktime_get_real()) before it is used.
Not sure what is the best place to do it (?) ....hmm 

> >
> > However, we still need a bit to distinguish tx_delivery_tstamp
> > from hwtstamps.
> >
> > >
> > > > +{
> > > > +       if (skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP_ALLOW_FWD) {
> > > > +               skb_shinfo(skb)->tx_delivery_tstamp = skb->tstamp;
> > > > +               skb_shinfo(skb)->tx_flags |= SKBTX_DELIVERY_TSTAMP;
> > > > +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
> > > > +       }
> > >
> > > Is this only called when there are no clones/shares?
> > No, I don't think so.  TCP clone it.  I also started thinking about
> > this after noticing a mistake in the change in  __tcp_transmit_skb().
> >
> > There are other places that change tx_flags, e.g. tcp_offload.c.
> > It is not shared at those places or there is some specific points
> > in the stack that is safe to change ?
> 
> The packet probably is not yet shared. Until the TCP stack gives a
> packet to the IP layer, it can treat it as exclusive.
> 
> Though it does seem that these fields are accessed in a possibly racy
> manner. Drivers with hardware tx timestamp offload may set
> skb_shinfo(orig_skb)->tx_flags & SKBTX_IN_PROGRESS without checking
> whether the skb may be cloned.
