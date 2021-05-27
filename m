Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1982E392FC4
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 15:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhE0Ncy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 09:32:54 -0400
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:59936
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236007AbhE0Nct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 09:32:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXhvBoscId2Sz513+euNRIE9QrnqjhnYecCQ8uXLEZ0CmbYGOnhGyUXxEl8dZFn9lpwDl159E3ie9bsA2+in43hB3OpQKtNi/Z/UubBYEjtoV6bIqBaCagcHFFe2bI1HwCE9XF8wxP0o/pN5Saw6MQPL36YJ+0P3pcGqA4T7vHFYGUv7Sm7LmFAps7eQXkmmKzxCyE5vxicHOGECv1JjuBLIfm81O1rnhM+UMVFmzb6B25Qb2aWUlV1WNqvL1BSmiNV9R1y1OXeg3VgejfnXgeJQQSoZPqyznKN7aQ6eeexNvTXrPFbLj1WqsTepR8RdOZcn52whiaO/ZaXh7Ixu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHtF5WXrqUQs4jeLzI0t7xJTWh6Om+3UX2eXPXNpx4A=;
 b=V+C5FA8W5+YWE4AKUygSbBH/IZin3JS2oa5L2+GQsmj7Bkb7dDUCRYokFQcxK0H+A3RQZwg5oOLzDVVqFehQNDoyoR3Haf/jtkxLGz7G2SDuD662651XtUJ8s/+akvMZ6Uovz2cunTfT2XK/3HR/+F5ma0al2lhQBcsS+wc0KJn8Dpmo3jjtjvXUQ0HHzLhxNrubZIRrAgW6y3ccSh69AE3TSRC3PAJkmvyNJQoPqpoklQtmMQqANNuVGzwpanNzm57NllgRDyA+B17a90WkIvJCN3P1NAecb0FWJI4b6KOnjzGCo4IkCO1CgcrQKxAoAszWf1LN8D7ETGwNmChSnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHtF5WXrqUQs4jeLzI0t7xJTWh6Om+3UX2eXPXNpx4A=;
 b=QNyjSrn4P2YQzifgCHVY9dCRX3Vb45VdQ6Pi4RPsTCK0WfECVD3OXDJgpauxjljgDssI0lAEmH8ijRyJeSNjYoxf2FyHvXBPno67YSpPqCuCWcv5MTTNYzSN+nIQ+78P5GcRMyNuelAZHogfiRLBiXCRsalfqdNxoub90bVJb24f8RGlV8mF8HgJw0Rdpcj6KKH5+mPSdnRK6MTY20H9u+uFvbtKVGwQYsbdI4MlHQgcxK/SjEa5Lw9NGtkE0s6c38Lv+4rASmtuAXY5k89y8ywYeN+e0FhX2rSSbY7i2UQMdIjlhxFzefDyQDvp/Aw8vbTHrhrvlbShNtio2Swx2g==
Received: from MW4PR03CA0032.namprd03.prod.outlook.com (2603:10b6:303:8e::7)
 by BN9PR12MB5306.namprd12.prod.outlook.com (2603:10b6:408:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 27 May
 2021 13:31:15 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::8e) by MW4PR03CA0032.outlook.office365.com
 (2603:10b6:303:8e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Thu, 27 May 2021 13:31:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 27 May 2021 13:31:14 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 27 May 2021 13:31:11 +0000
Date:   Thu, 27 May 2021 16:30:57 +0300
From:   Paul Blakey <paulb@nvidia.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net] skbuff: Release nfct refcount on napi stolen or
 re-used skbs
In-Reply-To: <81587f89-df10-004e-6c79-34940fe04c16@gmail.com>
Message-ID: <9b9939-ce24-60ef-cb6d-61732ab21359@nvidia.com>
References: <1621934002-16711-1-git-send-email-paulb@nvidia.com> <81587f89-df10-004e-6c79-34940fe04c16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04d5cfb6-2c1b-4d8b-4307-08d92113b398
X-MS-TrafficTypeDiagnostic: BN9PR12MB5306:
X-Microsoft-Antispam-PRVS: <BN9PR12MB53065C9C6065D17D92DADFE5C2239@BN9PR12MB5306.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:370;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mj0BQA2GnFBWTakl1cso+mteGAoiQWfOstbCt5dTWC8wfliG3D33RLGkdQqVvJKvmwSHQYKgLYyE22GTokZt3/fzkYcBCYxkuzFTaM/c5LKxmLbqRyEd3dApqvHQRLlgc4k2AWR0W/946goNmGI3O2haxr9OmZh716l7X+A7adeVom18UKOP6yo4UGflwd0xLu1L1LcbCN+PbGBgp2XaSb5MgRr1+7S/2cnUZcXoPe8ZcSowC2KfQKmY8G/bh00NM74UodfkaAEn3NbCEFaNfaftIyiMgRjdccK0+Oqt+vI+IrnFz0E4fdutH6XDOT+4cErPiSFGDzru2yr9u9L3Sa+X9hUTh/9EHOegvwmYjEZEtyQFgi9qQ+17ojGEQI7t2SD7pd4v0sasZsM2dF/bLEVqQ7/X9frlQ+X9pDbTv3Pt9ri54AXGb4DRySRcibaT/DOv5WFBPkbMC5JskoHy3QhjZsMQFxKzvm7G6jr76Kv+burv3qpmfM0Z4UK5LQMIgaf9VnQdQFw5+5Gem+DBgbwU1ApP/GAap1oBEgKgs8UcHHsZut5baS+oZaLFC7w+kAX42QIw0Sn2fCU5E63mljR3O8Z3+IwqEku1c8FTYf9q9JL94IWzaHfqPEpB01cJQJalF8ICY4lT8f25LhYDigtgSyKtOqmn9IS+v0esH1E=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(36840700001)(46966006)(478600001)(426003)(336012)(356005)(36906005)(8936002)(47076005)(36860700001)(4326008)(107886003)(2616005)(5660300002)(186003)(316002)(6666004)(16526019)(86362001)(2906002)(8676002)(70206006)(6916009)(54906003)(26005)(7636003)(82740400003)(82310400003)(53546011)(36756003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 13:31:14.9672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d5cfb6-2c1b-4d8b-4307-08d92113b398
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5306
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On Tue, 25 May 2021, Eric Dumazet wrote:

> 
> 
> On 5/25/21 11:13 AM, Paul Blakey wrote:
> > When multiple SKBs are merged to a new skb under napi GRO,
> > or SKB is re-used by napi, if nfct was set for them in the
> > driver, it will not be released while freeing their stolen
> > head state or on re-use.
> > 
> > Release nfct on napi's stolen or re-used SKBs.
> > 
> > Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
> > Reviewed-by: Roi Dayan <roid@nvidia.com>
> > Signed-off-by: Paul Blakey <paulb@nvidia.com>
> > ---
> >  net/core/dev.c    | 1 +
> >  net/core/skbuff.c | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index ef8cf7619baf..a5324ca7dc65 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6243,6 +6243,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
> >  	skb_shinfo(skb)->gso_type = 0;
> >  	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
> >  	skb_ext_reset(skb);
> > +	nf_reset_ct(skb);
> >  
> >  	napi->skb = skb;
> >  }
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 3ad22870298c..6127bab2fe2f 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -939,6 +939,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
> >  
> >  void napi_skb_free_stolen_head(struct sk_buff *skb)
> >  {
> > +	nf_conntrack_put(skb_nfct(skb));
> >  	skb_dst_drop(skb);
> >  	skb_ext_put(skb);
> >  	napi_skb_cache_put(skb);
> > 
> 
> Sadly we are very consistently making GRO slow as hell.
> 
> Why merging SKB with different ct would be allowed ?
> 
> If we accept this patch, then you will likely add another check in gro_list_prepare() ?
> 
> 

Yes, good catch, I'll check if that's even possible in our case.
If so I'm going to add checking diff conntracks on the gro list,
and diff tc chains, both are metadata on the skb.

