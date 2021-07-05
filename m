Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E103BBB47
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhGEKfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:35:48 -0400
Received: from mail-mw2nam10on2070.outbound.protection.outlook.com ([40.107.94.70]:34464
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230498AbhGEKfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 06:35:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlTck9Jnb+Sk+n8U5nxYnqXLOv1RlMt0+KzUYFv6cH2SBbzP/LXo/2oJfpP5YA7/iE1LUioivYLFPJ+OhbK8+XQfebHUpEt3J/EoMccL2pR4Xl0DBYUt+qMEx1tm/mnzbxv59imo/qhmgUxA8OWaMZkY8nG27NbxcOUBCg75BM9X2flhswYbcJILtSOMaGxlg/FI81daL6qj3dEk8u1soma1g9dCJOZKjCuS5FvSTy7IaYyv3YUoy5H9QDxlav8Efp9w3hs7+veFbwNRwrLEa2D05gkDbczk64m+JmEId5Gldb0c002y+8JekkEhiO7RsW2l8E+hE5jTMX0KqVNFrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/utl2FdFb1ye6+nkDtW2nAa9+DQe6+IGAyqlFyXivw=;
 b=U9eBzwcmJ1iWP4V6/dnE3bTZ/2nEqKZV0H2H27VCJYnuyZYRMS/5ZQw65BndDmPBdHRIlkpfcUTFGEIZb4/q0i4uhDzvyyHpJYQlXwwzdJvGCpF6xlgbRx92N4ic0DdPr4ae55RLRcNdl43hSqOITaH7n/GYwaHQuaXGGxsBfLc3dsWHCAGHwyagCAZJ8Syxl/xrEug3/hpir+E1XvUgka8om1QzrjmqL5l2g6KnXUyAzTlesdvfWPUG2Y5CAYqqM/pOwpu45NRFxUai+Khwp9S5sfu+EMbwDmOUq3JQSj96nWxD8Cax1pWNLolvDiI19/nHC3iTxqFzRK4WX0KB+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/utl2FdFb1ye6+nkDtW2nAa9+DQe6+IGAyqlFyXivw=;
 b=aWEN3Bes6DCzkHzmt5ucZFxDINNkH5FgD2h9DQHBbGMmTEAgUdKdOHnh+K7vprNP4Ao2opco8x4e5iGFx8ljoA7I1a6W/qPfnG6tug6AsU1z2rKNVHnmKYyLoSsxZyTc4e5nbWuFuLjjR7873IhZ9xqlxdNhBbGvDyDBfcbYIVfEu/1/PL9bSA38e+eOHP+Hn0L4yIp4gINRhB3Yo9r9kttDtXj7ponkHGe22uYIiHpCk3QwbLwq9VVr15ZC/DShJra0i4MOfmMpW4rmWYxASYvBQ0gcnYwTZlqzhrCzKhzO8qufNfU5vwdebq0LmWxIlrsr95iPxc0J+aovzkUeoA==
Received: from BN6PR19CA0068.namprd19.prod.outlook.com (2603:10b6:404:e3::30)
 by DM6PR12MB2811.namprd12.prod.outlook.com (2603:10b6:5:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Mon, 5 Jul
 2021 10:33:08 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::af) by BN6PR19CA0068.outlook.office365.com
 (2603:10b6:404:e3::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Mon, 5 Jul 2021 10:33:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Mon, 5 Jul 2021 10:33:07 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 5 Jul 2021 10:33:02 +0000
Date:   Mon, 5 Jul 2021 13:32:53 +0300
From:   Paul Blakey <paulb@nvidia.com>
To:     =?ISO-8859-15?Q?Mika_Penttil=E4?= <mika.penttila@nextfour.com>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "Oz Shlomo" <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net v2] skbuff: Release nfct refcount on napi stolen or
 re-used skbs
In-Reply-To: <ecceba2b-bbea-7341-19d0-d8007833ccc0@nextfour.com>
Message-ID: <a5978e5b-1d4c-7fed-4285-a77c866cacc8@nvidia.com>
References: <1625471347-21730-1-git-send-email-paulb@nvidia.com> <ecceba2b-bbea-7341-19d0-d8007833ccc0@nextfour.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="-720718829-1255726343-1625481185=:10440"
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7155267c-ceb2-4178-73ec-08d93fa047aa
X-MS-TrafficTypeDiagnostic: DM6PR12MB2811:
X-Microsoft-Antispam-PRVS: <DM6PR12MB28112E84EB142BE8E7CEC361C21C9@DM6PR12MB2811.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t2PtRVx6mcEZe+0lS9OVFH6Ndv5vRCD7NkLOxEQaR0o1L8ux2GhtHRcrbLVJ3OtecRRlUSHO4PoHN+tw3orLc1w1+jBp1XT+7n7iPWMYF2kpmCiUsAYSjnAaBe0nZCF6Gs2n/7fphnfH2K/N2kc6P1tX7SEuOg5rfZmeuxMrKw9UPWVUGAhZ1G9jgvo3vz1aSvmbOp23ugGbejroj8SKr77wx9iykEaodZ5ApX9n8Eto8mm/IWCsrukEjFpTXQx512IMBoT/2dShrcYmFKv3rfDP4QigV2mM8ghoPGwJkQnyzmep+TWD6YR2g3jyjMZPDEUn0ebwXgOfkKnczWnTF2vr/toi37pv6cuphjFvYua76wqRn3kz8OGC+5dKrJURF6TGBsV8LfzXZX3tM/IoaAngoZavonXcvlg/UN7dz2C/C74OZA2zxLB/mF8UVbbSMw3Gh/5FxfSVFsc4adgxFJBm9vM9krZMebHPmWB048zif0nJaBRNdbs5Fvry5/aOG4mrF3Oju0QNixQ9vrNl/RDkfk0Dxead2zae4FXljz4xeFBEfb7OmCstDZ45StQkDsUdrGDLOwsnUwk4huo/5096/7ipH+Ng0SD5CHquAS+HmLW+F3pEOHIwpok8+vo671MNqXm9mkAVs006iNeFPf9p/HmSiKpc8SEjrWUA8azWSx2KbgJVQgBpa55bzyoU3qiXWRduvmZz4KRwfN+JeQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(36840700001)(46966006)(16526019)(5660300002)(36860700001)(186003)(82310400003)(8676002)(82740400003)(47076005)(31686004)(31696002)(107886003)(26005)(478600001)(8936002)(36906005)(2906002)(316002)(336012)(2616005)(6666004)(36756003)(6916009)(54906003)(7636003)(86362001)(356005)(70586007)(426003)(70206006)(33964004)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 10:33:07.7467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7155267c-ceb2-4178-73ec-08d93fa047aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2811
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---720718829-1255726343-1625481185=:10440
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT



On Mon, 5 Jul 2021, Mika Penttilä wrote:

> Hi!
> 
> On 5.7.2021 10.49, Paul Blakey wrote:
> > When multiple SKBs are merged to a new skb under napi GRO,
> > or SKB is re-used by napi, if nfct was set for them in the
> > driver, it will not be released while freeing their stolen
> > head state or on re-use.
> >
> > Release nfct on napi's stolen or re-used SKBs, and
> > in gro_list_prepare, check conntrack metadata diff.
> >
> > Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT
> > action")
> > Reviewed-by: Roi Dayan <roid@nvidia.com>
> > Signed-off-by: Paul Blakey <paulb@nvidia.com>
> > ---
> > Changelog:
> >  v1->v2:
> >   Check for different flows based on CT and chain metadata in
> >   gro_list_prepare
> >
> >   net/core/dev.c    | 13 +++++++++++++
> >   net/core/skbuff.c |  1 +
> >   2 files changed, 14 insertions(+)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 439faadab0c2..bf62cb2ec6da 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5981,6 +5981,18 @@ static void gro_list_prepare(const struct list_head
> > *head,
> >      diffs = memcmp(skb_mac_header(p),
> >              skb_mac_header(skb),
> >              maclen);
> > +
> > +		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
> > +
> > +		if (!diffs) {
> > +			struct tc_skb_ext *skb_ext = skb_ext_find(skb,
> > TC_SKB_EXT);
> > +			struct tc_skb_ext *p_ext = skb_ext_find(p,
> > TC_SKB_EXT);
> > +
> > +			diffs |= (!!p_ext) ^ (!!skb_ext);
> > +			if (!diffs && unlikely(skb_ext))
> > +				diffs |= p_ext->chain ^ skb_ext->chain;
> > +		}
> > +
> >    	NAPI_GRO_CB(p)->same_flow = !diffs;
> >   	}
> >   }
> > @@ -6243,6 +6255,7 @@ static void napi_reuse_skb(struct napi_struct *napi,
> > struct sk_buff *skb)
> >    skb_shinfo(skb)->gso_type = 0;
> >    skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
> >    skb_ext_reset(skb);
> > +	nf_reset_ct(skb);
> >   
> >   	napi->skb = skb;
> >   }
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index bbc3b4b62032..239eb2fba255 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -939,6 +939,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
> >   
> >   void napi_skb_free_stolen_head(struct sk_buff *skb)
> >   {
> > +	nf_conntrack_put(skb_nfct(skb));
> 
> Should this be  nf_reset_ct() to clear the skb->_nfct and not leave a
> uncounted reference?

Yes it should, thanks! Sending revision.

> 
> >    skb_dst_drop(skb);
> >    skb_ext_put(skb);
> >    napi_skb_cache_put(skb);
> 
> 
---720718829-1255726343-1625481185=:10440--
