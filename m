Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16271230FF1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgG1Qil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:38:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23100 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731367AbgG1Qik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:38:40 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06SGNQbU031527;
        Tue, 28 Jul 2020 09:38:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nbsVJlI0eiL3svUGO4RbYcytdcy+37zrFa11DslQzsI=;
 b=WcsSJOs1bZoKtlB3/v9upjq7A/NwKcTX++IzovwnlkCFZdh2FVKoL60KqXL/bSwvEOIu
 71uzQ7iL1VCRVYojkiv0cyfyuHrrCEBI65Ut9Bm4qXxPl35UhFAuTsm3g5aIB5/hFwu5
 RoiNY88qzbOXiilclbsmHt0kWQDNjMw+Ulc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32ggdmnb64-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jul 2020 09:38:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 09:38:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjwQWqF6mENTNbnhtGlqMYpqHtbViLmiWIFb8Ky+G2QxwecmqDGlFijZVLCu2EmWe6nMTuB6RGPORlv1QWo8hHuFBFqeQ8UrpVHhTDCmYX0u53yvUwJXAvorYxYFC6gRNwke33gZjmBsH++QpjOxFlmSV30DmDA3kCIqSNuJKchtTDPc0vxAg9LCF7V6ozPQMDgLjDyL+HvB26bWdOv4bv9Nd48qFkFhG0+10kaLS7n6YCBBAPVZkT62u/5gw690BbfOAdUInUpBMtnUQnHMNlgZggnf1mW0s+umAoAlr31Pb76zWKyWWIUTP4Vgixb4P0V4VYA3LreAUTmcMVHgdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbsVJlI0eiL3svUGO4RbYcytdcy+37zrFa11DslQzsI=;
 b=bYVhklWRp7YJnaTEsT9W8mp0AgdM9WjKlV/pUrAGBwlecEqPhQRIuOzW0A+sACGGvaiGMbtHtdxqqhJdeq72sdDKvjHH7bWu/8mrKL3oEXJgzVYFZWcARAJVKFv7A1q2jiz/vfxbnqKfdnrluudr7Wu/XHyUtHTjZ2Bqy/ooX8XT9J3sT0lEz6EoROJQoOl7Hvqzc9TuQUk+R0QIG5n1veC7KXwGmWV3HtgBb6wN5jMMPJhvzeygUw/LAPqSYRevfVTmtBRQ7T+W0Bpzh0K8ku0xeQo66yBtKvIFZpy6VA9dZJ7lRlkvyMYkrNFwv72SVpiDewszqPj0VQRn75MLqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbsVJlI0eiL3svUGO4RbYcytdcy+37zrFa11DslQzsI=;
 b=P7lnvlHe6P42wLec7L4MTjqzf3k2lroDvHHQq3cUAdgsjkCudEbJ70eAIItBRX5+VeEHUcbYuRfLB2GhE/bVrkAfmqicCXC+yb+EQuwlU2WzgAMOY5FUqLpEHw57M401kiU0duxQl0QU8NXNmzjRJDnWPh5OT84DbQaNyFu32XM=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3670.namprd15.prod.outlook.com (2603:10b6:610:a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26; Tue, 28 Jul
 2020 16:38:01 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 16:38:01 +0000
Date:   Tue, 28 Jul 2020 09:37:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] udp, bpf: Ignore connections in reuseport group
 after BPF sk lookup
Message-ID: <20200728163758.2thfltlhsn2nse57@kafai-mbp>
References: <20200726120228.1414348-1-jakub@cloudflare.com>
 <20200728012042.r3gkkeg6ib3r2diy@kafai-mbp>
 <87pn8fwskq.fsf@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn8fwskq.fsf@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:217::18) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:bbc) by BY3PR04CA0013.namprd04.prod.outlook.com (2603:10b6:a03:217::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 16:38:00 +0000
X-Originating-IP: [2620:10d:c090:400::5:bbc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab676770-5214-4bb7-9f59-08d8331497e2
X-MS-TrafficTypeDiagnostic: CH2PR15MB3670:
X-Microsoft-Antispam-PRVS: <CH2PR15MB3670A0609A16CE81A36DD7B2D5730@CH2PR15MB3670.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XYynJ7SxN8aQXT3ZBXP9u0M/NTxz8ZjfHzlM6dCSU4RyhgGExvvFM9qvtwSRWuLfsoTIEQAQmWdv8SKz+zugBQ4h9E6MyQAE2YvMf6j97HkU5arwG7XbvdeQnwwV+ZGrekcIGHPrTi58Yw5u4XIYofwiVvYV9KANCk/IwOpC6LyRTGoI0NotC6gXAf0dZoMRJh62lCrZRHPWSGt8CEUlcG2+BdtKJ46sbYZiOThzytBYSHWsNqeCMHUYNKiqn4dilV8+YlyeEozO5o9FhcogH144PBXqWISFZxLoRmwuZTxhdrCJ2hFa9+7mRnAmb6pi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(366004)(136003)(376002)(39860400002)(66946007)(83380400001)(316002)(2906002)(66476007)(66556008)(186003)(52116002)(9686003)(5660300002)(4326008)(8676002)(478600001)(33716001)(16526019)(6496006)(53546011)(1076003)(6916009)(8936002)(54906003)(55016002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dHIHRTuvVZEOj2mzm5ke43XnxV/ArZqZAJ+7lb4QGcusAX5rmcyTUaYPZNnPOwhcQvDbkHh9MDKrof+lLF1oUsumHhVHSvcfTxSln7OBoZ9ACYcNIeUjddKNSg3m/B4wMTZi6nIn3/oSqqOBiOq1mJ35K9/ohd4oFmVm1mS898IYlUzyaDUDgeLRyN2urUEHrRpVvgUm6LPrc8Ud4IRZ50oIz6K45t1/DoW2xCB0aeufRKy8+QCEH/YHlmL9TaXLp0Pr6a341Dgbn63HIxQFpUZ7iU3LPTP1d3rFOUHMNSkDQIdQUwmDpF6dMvbbVzvKyN6mB9QuCNi5qJlXIhWMRvWDXVhDZKld9ZviU0d8y2RGh5/ByVMZvOY0yVeDONP9lcajhKkJOi2f9egMwEgPjeKP5MHJKUuO1esgOyOyQ3XV47tgS/mzDkwS96KB6aLl6A6wlLWjqYkSEKczHQlj7OEuhE5QNlvMLrdA3fh114Bx5CG8ct5WfjUWbxBvUL5mDcutzCruXVmyVqYwdm26KQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ab676770-5214-4bb7-9f59-08d8331497e2
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 16:38:01.5687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0NZQ0XWk4muyoIORh5D2QfG4+QeqYk5wtL/wDj4aZKGfa6K2DOmpiixi/Tzrtea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3670
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_14:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007280124
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 05:46:29PM +0200, Jakub Sitnicki wrote:
> On Tue, Jul 28, 2020 at 03:20 AM CEST, Martin KaFai Lau wrote:
> > On Sun, Jul 26, 2020 at 02:02:28PM +0200, Jakub Sitnicki wrote:
> >> When BPF sk lookup invokes reuseport handling for the selected socket, it
> >> should ignore the fact that reuseport group can contain connected UDP
> >> sockets. With BPF sk lookup this is not relevant as we are not scoring
> >> sockets to find the best match, which might be a connected UDP socket.
> >>
> >> Fix it by unconditionally accepting the socket selected by reuseport.
> >>
> >> This fixes the following two failures reported by test_progs.
> >>
> >>   # ./test_progs -t sk_lookup
> >>   ...
> >>   #73/14 UDP IPv4 redir and reuseport with conns:FAIL
> >>   ...
> >>   #73/20 UDP IPv6 redir and reuseport with conns:FAIL
> >>   ...
> >>
> >> Fixes: a57066b1a019 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> >> Cc: David S. Miller <davem@davemloft.net>
> >> Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>  net/ipv4/udp.c | 2 +-
> >>  net/ipv6/udp.c | 2 +-
> >>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> >> index 7ce31beccfc2..e88efba07551 100644
> >> --- a/net/ipv4/udp.c
> >> +++ b/net/ipv4/udp.c
> >> @@ -473,7 +473,7 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
> >>  		return sk;
> >>
> >>  	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
> >> -	if (reuse_sk && !reuseport_has_conns(sk, false))
> >> +	if (reuse_sk)
> >>  		sk = reuse_sk;
> >>  	return sk;
> >>  }
> >> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> >> index c394e674f486..29d9691359b9 100644
> >> --- a/net/ipv6/udp.c
> >> +++ b/net/ipv6/udp.c
> >> @@ -208,7 +208,7 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
> >>  		return sk;
> >>
> >>  	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
> >> -	if (reuse_sk && !reuseport_has_conns(sk, false))
> >> +	if (reuse_sk)
> > From __udp[46]_lib_lookup,
> > 1. The connected udp is picked by the kernel first.
> >    If a 4-tuple-matched connected udp is found.  It should have already
> >    been returned there.
> >
> > 2. If kernel cannot find a connected udp, the sk-lookup bpf prog can
> >    get a chance to pick another socket (likely bound to a different
> >    IP/PORT that the packet is destinated to) by bpf_sk_lookup_assign().
> >    However, bpf_sk_lookup_assign() does not allow TCP_ESTABLISHED.
> >
> >    With the change in this patch, it then allows the reuseport-bpf-prog
> >    to pick a connected udp which cannot be found in step (1).  Can you
> >    explain a use case for this?
> 
> It is not intentional. It should not allow reuseport to pick a connected
> udp socket to be consistent with what sk-lookup prog can select. Thanks
> for pointing it out.
> 
> I've incorrectly assumed that after acdcecc61285 ("udp: correct
> reuseport selection with connected sockets") reuseport returns only
> unconnected udp sockets, but thats not true for bpf reuseport.
> 
> So this patch fixes one corner base, but breaks another one.
> 
> I'll change the check to the below and respin:
> 
> -	if (reuse_sk && !reuseport_has_conns(sk, false))
> +	if (reuse_sk && reuse_sk->sk_state != TCP_ESTABLISHED)
May be disallow TCP_ESTABLISHED in bpf_sk_select_reuseport() instead
so that the bpf reuseport prog can have a more consistent
behavior among sk-lookup and the regular sk-reuseport-select case.
Thought?

From reuseport_select_sock(), it seems the kernel's select_by_hash
also avoids returning established sk.

In the mid term, we may consider to remove the connected udp
from the sockmap and reuseport_array.

I am a bit confused in the current situation on bpf@reuseport returning
connected sk and I also can't think of a use case in the
sk-reuseport-prog-type side.  It was why I was curious on
the sk-lookup use case.
