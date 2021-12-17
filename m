Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E38B479337
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 18:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbhLQR5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 12:57:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239969AbhLQR5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 12:57:30 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BHHjXkG021812;
        Fri, 17 Dec 2021 09:57:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=j4SAwhXZciAVt6SYYfd5EmgAb5vHl8CjRiIfg6iWrKY=;
 b=JbavV4xI+Eco4oNWg7hyrw2XW/EOYySttQQV5DHcniZty91Bs0fN8j3i+LFY/V6FgGZD
 +2q9tReWFFMkthKVesX2DWI8yh4A4pnoKEh3lZPB4yazjeqr4aH/vsZi1DGPjN1GcEFj
 vKQjDfstnjPF9/ShNhDtBQxujq7kz6ARoeA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d0ryyapnv-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Dec 2021 09:57:13 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 09:57:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGT2MtjhkqYUrISJcPhJOeo/Fmdo7Pszu9zvs9RVCRctffY/pYo8lyM8Qr5FK+Bt2ArnjfV8okQqCZwbm7NKb30wYANJY0UBhM2OyH4vC6Ka3pd/BBNZ5+mNKzrdBVhPtTYRbvZDaA8z61by4hNEK43qxlOmWlcxRoprYfF0hfRmnodMs8KiKh147qFqiDpCGLQSRgy5duG+qLItdrTXsaXLeo4qOjq22ERDNkBh/m8QuZQuZt8rkYY2CCSJrh/yLIDecgqs9Z97XSq7FRGlwWhiOwi55STG6yLDtQ3TfTR0nF0coP8vnwcoH6N3tX/8xMxeLeaafWuLChHgtf7R1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4SAwhXZciAVt6SYYfd5EmgAb5vHl8CjRiIfg6iWrKY=;
 b=QK7is+IYvFYAfwENJwMC2spqrIdLwCjUEYOBZK0P/bs0YV60Ajfg39Xs+tThPLbK2lM4gojdAcwGyU4knhlOBnZtpfnR5yJKoUWuIDni90xaivIFOGHr8g+tf6tigBk+Bk6lcVoAKptZuw6j7PwD59PtaGOS6BWUZpPe8bZgdKkFSfNtlvhYeKziGZ09yjwc7lFb+cGJ2+gWierGOsVT//LSKNyKSshWNsr377Ps8M0OHXpuyg61xLMcoTNvkbHnYwCQNUGzla/2Qt4EWIdbe3S822nqt7wWcafyUOFueCA++qQySyYg2/YlNcHsNk3UcNF8AWH6ndZZ3SKWwltpMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB4142.namprd15.prod.outlook.com (2603:10b6:805:e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 17:57:09 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 17:57:09 +0000
Date:   Fri, 17 Dec 2021 09:57:05 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during
 forward
Message-ID: <20211217175705.fpbsjoqeuaul3ydp@kafai-mbp.dhcp.thefacebook.com>
References: <20211215201158.271976-1-kafai@fb.com>
 <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
 <20211216222332.fltkclu4x3udpomr@kafai-mbp.dhcp.thefacebook.com>
 <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
 <ca11f6f6-86f9-52c9-4251-90bf0b6f588a@iogearbox.net>
 <20211217073351.k4thkro443m3fnme@kafai-mbp.dhcp.thefacebook.com>
 <32c53d3c-8393-c5ba-4a43-6e40bd2ed258@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <32c53d3c-8393-c5ba-4a43-6e40bd2ed258@iogearbox.net>
X-ClientProxiedBy: MWHPR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:300:ae::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6b12c9b-05e7-47e5-83d6-08d9c186a53e
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4142:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB4142B4003F4413A4B42792B1D5789@SN6PR1501MB4142.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9dAM47CS9gGfusHuzkE5Jmx1q4vEcpxxtlg068taxzifsz3Cbr/6/ia0HLJ1qqLlqkyB5jy6m5PMQizlb7euUDeeGqZs1njsvrIWmJHP8uff9QHxI764kDZf6bCogzK3WU29Nf6Na+pXwGUJdRXiU/zPDCZhPv65r9whgjktjl822dfXutIYZgdaEQQXuZ14MIxmIAFlMvcAqW07qiccB0wjwPh0qQLhn3DATuu9NjKjhaVpSiuTnYO+EXoR3U3Z/s0UJ87i7TKczdJoZWsaClt0UoOSnv4hIeviLvZaf7m69vugjRFtlRUN2/d5JjuiudiJ632iNWLfzvJz8KbsG8AceZDnQ4tmLwj2iIxMxaFkadr4dj0bU9u64xu19xKwnlLKwkNO0NjmEkly3K94QKxBDis5AKA8YLLOGmKEdZ0/6iWGi1P8LURjrlmgT8iu0EPSXIR64PGyslGpWcn9MjNqv3kQ8C525ErUfSrza4sQz478beVI0TDxLWpCXNX0FIoz0Ny+fjMfpdUcdqA9I3mhLA17dEvtM7b3uYSxHva7Rp40v4FX35Ck6vdF0ihmc2JRbmeDlXiAm4qVoqGvtt9jNp1604dZnZgk1lxgQ94RtztJdCK8MzBXDSr7B8SVpM6iWOTx6Vi1i+Y6QW3qIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(6916009)(53546011)(6506007)(186003)(8936002)(8676002)(6486002)(6512007)(9686003)(508600001)(52116002)(1076003)(54906003)(2906002)(5660300002)(316002)(66476007)(66556008)(86362001)(6666004)(66946007)(38100700002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEp2cXFGsF9QZ4HbulkKLA0CpP4pXB2m0FkDMeg+UVFOW7EC0R2qtCkmn1FG?=
 =?us-ascii?Q?CCcFZ6s8Gu1dExKBJXLEFHLiD0KdPL4WLbqPqP9hZNZZV0y1Gx1KnC//JucX?=
 =?us-ascii?Q?wlM54R9KUePzF2mxEMgfwdwNASW+CnjYnD/wITrwdNrJSQJ+g4HouWMSeIBE?=
 =?us-ascii?Q?IZPRKx+x9XtnHwazeBEluLvWAhWMDLEKYpIbhQBhsyXSrfdRtXuTYr8IDjnN?=
 =?us-ascii?Q?0jESEnxqNLjIhskNtGsbyQ3zUgCiNGWebUWjPQD6KXRo2HNRLHipI6xRcZNt?=
 =?us-ascii?Q?HYYpLiklPYwqLhUCsRKbi5v4fXndUAIJW2diHv++tYoI4KrD8zmdshLOWtJ3?=
 =?us-ascii?Q?OcQ6rjPymEhhxCixpKnVsq/kjvZwZ+nLnnQHunmpDOta8RO2zCgdd9gq+/PX?=
 =?us-ascii?Q?LJuA7cxa9ajjDniJEuOU2sb8pCWrwwBRp/pTAIlPck2q7hKhrkNm2cpXG6EQ?=
 =?us-ascii?Q?LjymHduZGrD33YaC8p7CuNGPF/SljvOGyKBdk0diVdWjygx6Y54I7NNQIAsx?=
 =?us-ascii?Q?hHq2RcfIjNWtNJRx3ElWlq8IEqutnlH3CTS3qtDhEJ6u6pAG8Z0JPef9OJ54?=
 =?us-ascii?Q?nFEbzYvqZZEjJ3r/qmmExm9J4zKCOVnYPLVub/RKPOCY13gKtzG1jlEKpyUI?=
 =?us-ascii?Q?9mqnvZpg5rw7kGlk3bcuyybq2zOtAKc8oL3xLP/NK7h/Z6AGvjzi2JLzVtO7?=
 =?us-ascii?Q?ORGJeOR2kWviWtSO5zE9TG/XapXhnNn+RM/bierZK7wMe/awJyezzSkozzpp?=
 =?us-ascii?Q?0Z0n4g7A2Fvx/cPOx1/rJ/xBHLckufOWlgtHVvWGnqf8TF95ujCpxvCfOzUt?=
 =?us-ascii?Q?nBxjw6UxW0SRqIL7T0OfMzROzE/8SwWCse/Smk72ovkU/16rzzewMQbor+Dt?=
 =?us-ascii?Q?ANPj94K04teZAeY2h+jDoVAnsLucy1/A0N8gWGfwcsZLCsDSINTJispNBEG9?=
 =?us-ascii?Q?InCWSVjeVjd2Qp/btQL3ng9Y/vTu6gW+Turil35DJ9uz6nUjw3FNh9frM0lE?=
 =?us-ascii?Q?ACha5qI9ywh2qx8KOXQskd0+hXZOGowMUqvpSTcgtho7VXyW/dECOJOyuYr5?=
 =?us-ascii?Q?ddITZTT1HM7eL7wPXEh3AqHxP9p71th7azS8g4pCchvujZ3lJPYchTo27+3O?=
 =?us-ascii?Q?ZZttzxNLuPfkJQvBKOLPuXBuyYIf60wd+IUl5n3z4BqRqCwx+jZq63yjxyk9?=
 =?us-ascii?Q?nTqwq0uwHBoGVOt8x4r41DgZ6ISMalBdLiT/3Emq/MriASnv/aCp57iBsfF0?=
 =?us-ascii?Q?SoskdMEJgbIElFKQBsD4KgIOrEm4HM9zDOPdMa6gT2z8M46po1ZKQmgr1KoO?=
 =?us-ascii?Q?hJfZwzWJe3KVsaw03V8uUEWFqfXL+BWwSm32ddwuImC7bz4KQVI9b6drrqwK?=
 =?us-ascii?Q?e0+i5mFOIwS1nJzU6soCzh+xDzaQ55gfxuzLYTYf7PMNW2EcJRtD1co9wtIE?=
 =?us-ascii?Q?roo0pryUPoaREcLuqnrBXeawjCzUL/G47gADvjnKk/wJAB19BS+cQOF+4LEM?=
 =?us-ascii?Q?fUyDQqFIUtDUNN/7nu8Q/qZ+FjjrYok7/fjZBIj0XEz/QeCFwtsNUVYrr+g2?=
 =?us-ascii?Q?W/L8UO8lDybAvyVQHOndo/Ts2uBvAoI9LtZmUlwM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b12c9b-05e7-47e5-83d6-08d9c186a53e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 17:57:09.4659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8/ywsWS/rkdIIJe7/eN4fshE06mVV3ay4RwoISY6c3tEjArf743IDBjy4EBuA79
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4142
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Mq16xbuJQJFb5OElHKKJJN9sdsAybpSm
X-Proofpoint-ORIG-GUID: Mq16xbuJQJFb5OElHKKJJN9sdsAybpSm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_07,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170101
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 12:13:14PM +0100, Daniel Borkmann wrote:
> On 12/17/21 8:33 AM, Martin KaFai Lau wrote:
> > On Fri, Dec 17, 2021 at 12:42:30AM +0100, Daniel Borkmann wrote:
> > > On 12/16/21 11:58 PM, Willem de Bruijn wrote:
> > > > > > > @@ -530,7 +538,14 @@ struct skb_shared_info {
> > > > > > >           /* Warning: this field is not always filled in (UFO)! */
> > > > > > >           unsigned short  gso_segs;
> > > > > > >           struct sk_buff  *frag_list;
> > > > > > > -       struct skb_shared_hwtstamps hwtstamps;
> > > > > > > +       union {
> > > > > > > +               /* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
> > > > > > > +                * tx_delivery_tstamp is stored instead of
> > > > > > > +                * hwtstamps.
> > > > > > > +                */
> > > > > > 
> > > > > > Should we just encode the timebase and/or type { timestamp,
> > > > > > delivery_time } in th lower bits of the timestamp field? Its
> > > > > > resolution is higher than actual clock precision.
> > > > > In skb->tstamp ?
> > > > 
> > > > Yes. Arguably a hack, but those bits are in the noise now, and it
> > > > avoids the clone issue with skb_shinfo (and scarcity of flag bits
> > > > there).
> > > > 
> > > > > > is non-zero skb->tstamp test not sufficient, instead of
> > > > > > SKBTX_DELIVERY_TSTAMP_ALLOW_FWD.
> > > > > > 
> > > > > > It is if only called on the egress path. Is bpf on ingress the only
> > > > > > reason for this?
> > > > > Ah. ic.  meaning testing non-zero skb->tstamp and then call
> > > > > skb_save_delivery_time() only during the veth-egress-path:
> > > > > somewhere in veth_xmit() => veth_forward_skb() but before
> > > > > skb->tstamp was reset to 0 in __dev_forward_skb().
> > > > 
> > > > Right. If delivery_time is the only use of skb->tstamp on egress, and
> > > > timestamp is the only use on ingress, then the only time the
> > > > delivery_time needs to be cached if when looping from egress to
> > > > ingress and this field is non-zero.
> > > > 
> > > > > Keep *_forward() and bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)
> > > > > because the skb->tstamp could be stamped by net_timestamp_check().
> > > > > 
> > > > > Then SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is not needed.
> > > > > 
> > > > > Did I understand your suggestion correctly?
> > > > 
> > > > I think so.
> > > > 
> > > > But the reality is complicated if something may be setting a delivery
> > > > time on ingress (a BPF filter?)
> > > 
> > > I'm not quite following the 'bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)'
> > > part yet; in our case we would need to preserve it as well, for example, we are
> > > redirecting via bpf from bpf@tc-ingress@host-veth to bpf@tc-egress@phys-dev in
> > > the egress path and fq sits on phys-dev.. (I mean if needed we could easily do
> > > that as shown in my prev diff with a flag for the helper).
> > Right, we have the same use case:
> >      redirecting from bpf@tc-ingress@host-veth to bpf@tc-egress@phys-dev in
> >      the egress path and fq sits on phys-dev
> > 
> > My earlier comment was on having the delivery_time preserved in
> > the skb_shared_hwtstamps.  The delivery_time (e.g. EDT) and
> > timestamp (timestamp as RX timestamp) are separately stored when
> > looping from veth-egress to veth-ingress:
> > 
> > 	delivery_time in skb_shared_hwtstamps
> > 	rx timestamp in skb->tstamp
> > 
> > Thus, when bpf_redirect_neigh(phys-dev) happens, bpf_out_*() can
> > continue to reset skb->tstamp as-is while delivery_time will
> > automatically be kept in skb_shared_hwtstamps.  When the skb
> > reaches the egress@phys-dev (__dev_queue_xmit), the delivery_time
> > in skb_shared_hwtstamps will be restored into skb->tstamp (done
> > in skb_restore_delivery_time in this patch).
> 
> I think that could probably work, also in particular if it's restored once
> on stacked devs e.g. when instead of phys-dev we're dealing with upper
> tunnel dev (e.g. vxlan/geneve + BPF with collect_md). Wouldn't we still
> need something like SKBTX_DELIVERY_TSTAMP_ALLOW_FWD, e.g. when the phys
> driver sets skb_hwtstamps(skb)->hwtstamp on RX, and this gets carried on
> the ingress path to the target namespaces' socket?
In the opposite direction phys-dev => host-veth => netns-veth,
the phys driver can set the hwtstamp but it won't set the
SKBTX_DELIVERY_TSTAMP.  This hwstamp gets carried onto the ingress
path of the target namesapce which I think is the current behavior
also ?

From phys-dev => host-veth, the skb is forwarded and its
skb->tstamp reset to 0.  veth_xmit() won't save zero
skb->tstamp into hwstamp and SKBTX_DELIVERY_TSTAMP won't
be set also.
