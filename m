Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357A5391675
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhEZLsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:48:13 -0400
Received: from mail-bn1nam07on2076.outbound.protection.outlook.com ([40.107.212.76]:36355
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230419AbhEZLsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 07:48:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lvk/jUg+nGWMQKqYwxLSkkMab8eJpMOqWkole8mHwqpecNI5Nbfob8RZTMh9Wj+78Zl0il4Gx9d8GMznHLuAHW3hh+zuErv3+wdJiE9YhXVxP5NvcsjD0+G/X+SvRq/icv0Akd2Lh0GXAZ/78s8Nh+QggX750YPwC1QXdg/SSu0tRYEN8ttkKY+6j/Ri81poqWqPz9F6SNV9fKia0P9+sYErO7GRdVHxXRiByVWVBtbeGzePWua8fmmYhLyS8NDMH7sVpNZRBbzcKe+I3ir+I8xrjFds1pZfP561UQ75qWI6tR9YO8df88Ekrv4A7Znee517ET6MCcUzKjyLB0c1lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4AFYcICEbFv3m6D/NirHrpqic1U666P3k07c+nHe/I=;
 b=H+m/k7xmFNxjUb8DWXO6DNGwaCcL98DwmTpkQxnB0fCnTBiXClLChTmaW7w0PUVYOPg4FtjxTQekZAAv7h9ti8zmoHvdGbFBk+3Z4MdJQvNWbmBk3/7I/KphAAPQfGK/fQXrgyUbUucPmsROR9JTJnT1YQxOO2FjdIYGtkdJvjiaqxWehcPpSZWs8OT7lakvAolw4P1V7598Jbwkb5BV81Q3mE7uI+pd6uthDSXrJIHzwX1KUDG1RJdqMv4Y1Gznc8ourPPSMuDtkPXBjog27epQb+v8JNlKVSCEv/n2yImdblToqsVOJsjbFHqVu72ZO4Y79HkiK/rTR/lIU2sR1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4AFYcICEbFv3m6D/NirHrpqic1U666P3k07c+nHe/I=;
 b=pv0vZD+wPrUBoZau+QHW5vuXhsxaA0KC/UC3FAz4FsWXskq7mPfH8RdUGltD1iH92dB3JL1DFGVOMoVAL7x4Vy0jGo2DCQhTnXMcOWe4KoD+dex+Fy+iu6izqBv+ts61FQPK8Nu3aUpwpn71cBmVkjDouTS8KYu665HAqoqOMPQMVY3uUpWbc/NvcP/8E7IOVcjurbVh4hgy02bxxN5nnsdxYKaPYo5TMksy+fPFxr0xo3trcCQqxqeQk5r9eXB2u1uQ6tuUSGPk3C/FE8/kfOekIKrdIltoJdvw4qcvdr1NPNDotpq2N0Rlx6iY2l1eEvKl+GqwLR2nr9nbuAhmqQ==
Received: from BN9PR03CA0893.namprd03.prod.outlook.com (2603:10b6:408:13c::28)
 by PH0PR12MB5498.namprd12.prod.outlook.com (2603:10b6:510:d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 11:46:39 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::6d) by BN9PR03CA0893.outlook.office365.com
 (2603:10b6:408:13c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 11:46:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 11:46:39 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 26 May 2021 11:46:36 +0000
Date:   Wed, 26 May 2021 14:46:24 +0300
From:   Paul Blakey <paulb@nvidia.com>
To:     <mleitner@redhat.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next] net/sched: act_ct: Offload connections with
 commit action
In-Reply-To: <CALnP8ZZVfAFFZctpSayzH2yTUZD3obAxCT4Z2r+WDY=RcacM_Q@mail.gmail.com>
Message-ID: <8a27f6c-fef0-c46-ed60-d9762b9248@nvidia.com>
References: <1620212166-29031-1-git-send-email-paulb@nvidia.com> <CALnP8ZZVfAFFZctpSayzH2yTUZD3obAxCT4Z2r+WDY=RcacM_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a39c82ca-0b9c-499d-abd8-08d9203becce
X-MS-TrafficTypeDiagnostic: PH0PR12MB5498:
X-Microsoft-Antispam-PRVS: <PH0PR12MB5498937343BBB26AD5618315C2249@PH0PR12MB5498.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HRo0APfmk+X1gOEOJDpBLOlqq9F6Wp6N2C4XYQBEUdTRHQLjKIygQPLqm+I00IPw9XyIyPJzAgbyKGuWJPQg7FQi4d2ckRGqN2FvdglUnm8udAPfkqAV9CAr07XvTBJJMHdMczLg4IyAJsUql0xxJ84DNrqXK/glX6dqxywY1seApPR2Xv02z5sEPX2V2oQ62cefPtDFsldniJWmpm4z0HBuvAuo0jIWsBcaAnsOFo1H4DrBm2i9dRUu55BcGd9FDf4T4gFvLqmYaWV06X5LYEgfBxpSA0fiR5iufqkpVKP0jWh/7ZwcvyT5LRr3BFZaF2akAN26pfselKSJgT1lbcUEUJ3tMpLlyRWSnmbUBJvx4R+sDwTFBDsJcrtX3K3yoWedvsfs7UJCqzgq0dAE24BcQY4LXTOkbM6X8cnsQgX15qlS6d0NyvJ1Tbi9p9dbnkMnDS37SDyx5REQ14GDOfy7hK43rarNaoZNev6BUcPWxu829C02LhdLMkX/xvMeul7n0l8Cdb4AAWb+a1VZ/E3ptRBMNTsnonC+axfdGQVnabCdtnoJqtIxgzvhmojJkq5Pagu8jZ3RbGzrSKo1RLp7XbS/t50cxNsO92sl9UO+cZ77rac7b0IWZDwtvv+RnE5xKA+LcWTTrbHGPX7oNA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(36840700001)(6916009)(5660300002)(36860700001)(8936002)(8676002)(6666004)(83380400001)(356005)(54906003)(36756003)(47076005)(70206006)(2906002)(2616005)(4326008)(70586007)(82310400003)(82740400003)(86362001)(26005)(478600001)(186003)(36906005)(316002)(107886003)(16526019)(426003)(336012)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 11:46:39.5923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a39c82ca-0b9c-499d-abd8-08d9203becce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5498
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 5 May 2021, mleitner@redhat.com wrote:

> On Wed, May 05, 2021 at 01:56:06PM +0300, Paul Blakey wrote:
> > Currently established connections are not offloaded if the filter has a
> > "ct commit" action. This behavior will not offload connections of the
> > following scenario:
> >
> > $ tc_filter add dev $DEV ingress protocol ip prio 1 flower \
> >   ct_state -trk \
> >   action ct commit action goto chain 1
> >
> > $ tc_filter add dev $DEV ingress protocol ip chain 1 prio 1 flower \
> >   action mirred egress redirect dev $DEV2
> >
> > $ tc_filter add dev $DEV2 ingress protocol ip prio 1 flower \
> >   action ct commit action goto chain 1
> >
> > $ tc_filter add dev $DEV2 ingress protocol ip prio 1 chain 1 flower \
> >   ct_state +trk+est \
> >   action mirred egress redirect dev $DEV
> >
> > Offload established connections, regardless of the commit flag.
> >
> > Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > Signed-off-by: Paul Blakey <paulb@nvidia.com>
> > ---
> >  net/sched/act_ct.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> > index ec7a1c438df9..b1473a1aecdd 100644
> > --- a/net/sched/act_ct.c
> > +++ b/net/sched/act_ct.c
> > @@ -984,7 +984,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
> >  	 */
> >  	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
> >  	if (!cached) {
> > -		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
> > +		if (tcf_ct_flow_table_lookup(p, skb, family)) {
> 
> Took me a while to realize that a zone check is not needed here
> because when committing to a different zone it will check the new
> flowtable here already. Otherwise, for commits, the zone update was
> enforced in the few lines below.
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 

Thanks,
Sent to net as a fix.

Paul.

> >  			skip_add = true;
> >  			goto do_nat;
> >  		}
> > @@ -1022,10 +1022,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
> >  		 * even if the connection is already confirmed.
> >  		 */
> >  		nf_conntrack_confirm(skb);
> > -	} else if (!skip_add) {
> > -		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
> >  	}
> >
> > +	if (!skip_add)
> > +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
> > +
> >  out_push:
> >  	skb_push_rcsum(skb, nh_ofs);
> >
> > --
> > 2.30.1
> >
> 
> 
