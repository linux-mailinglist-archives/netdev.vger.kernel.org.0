Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93763BBB81
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhGEKvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:51:01 -0400
Received: from mail-sn1anam02on2084.outbound.protection.outlook.com ([40.107.96.84]:6090
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230511AbhGEKvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 06:51:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnxsYetn2L5T4P9OrQdTxNu5ei9HM85Qn+nWv+qDxaWuB8It6U2IMtiw5zGq6TkIaWz6677AKhrA4qEqf0bhZqgx4relUOeg90au5FJlubCDWtIvAYpEfVETSW8hUQGr7r+TGVFdUDzSmg9gNgo4aMhaNnPwNVFfxGxubhcg1cjrOh+ztb2ZTuAwuYh6Mo+6JgpC7yH6ZfOTGV6fXKmP4eYBP08/BjAs7iYzkSoGEdrhqryAlNz8RxLTOOSXSiZx86li9kTnNgbF0fzqdUpBNtbSkhRlmVvd88Lps/V1JxZrt1U4u8dhhNK02SnEybka6P5fVjsM86I3uuebdMZXqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igQZN5JyzEIfoRbzuapK8qUmEudFJA/rHdkN61kdhuA=;
 b=Q8n0OxjNqRwLD2U4a21ky71UDHELtrYi6zx6bUgjtLyHrCmufRlj/alOmrGanv0lT3HUQcbkLvbxtnqsolNHffLm1+v0/UFAjKpAluJrja+/UPoLTB6VfBmwmQVHg6KEUiq5xXSsfRLJBp3Lo2sbUrlQrCgNbu8r7rQZ5f5KNZgCNbOKp6ZIWwwvbuOgR2UdeGZiQH+eqDyaK9uejSGwd8VePmBvTTGEPhKF+Wk1YRbHxJD6iPzw1Nd1qRMHvxCDRrxvB4YlU4R/iK8LnTWMD5gdNNL3JcXgteIhRaHbNGj2pAVgoZFm5qsTeeX9zXSGSbu1xS+Exeee56PZ5QVdug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igQZN5JyzEIfoRbzuapK8qUmEudFJA/rHdkN61kdhuA=;
 b=UK/vhmbmcWeDWLthf0npc2fNxcYp4PYrlgfG6OfFGiaCrWqFcdDxngIfTGZluGqyAuSVbffGKIK60nzZsojbhN/jBKsz9jD4UcGt+z/aZWBK1QwPEHWfBZztSi7uxXraopuWTP/2IqYrKrpCrNwpjbg5fCBrT0kmIvnIAvNB4CwstahD9PHSxYa89xxs0DdwRXFj7flx+7BFfS5m/7SG2yPzKMcugiqijO1JbMHdOUdgTSWOCE/RFFEsmuDjoKmbBvHsC7W+Cg8pXplJwnKXLQF8Lfq5k+yKWP8c+tnSP2yZApbigusSngRHxVkYcWcdsHqqyH8r3v8st+2Yd4T+Kg==
Received: from BN0PR04CA0002.namprd04.prod.outlook.com (2603:10b6:408:ee::7)
 by BY5PR12MB4049.namprd12.prod.outlook.com (2603:10b6:a03:201::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Mon, 5 Jul
 2021 10:48:22 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::f5) by BN0PR04CA0002.outlook.office365.com
 (2603:10b6:408:ee::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Mon, 5 Jul 2021 10:48:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Mon, 5 Jul 2021 10:48:22 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 5 Jul 2021 10:48:18 +0000
Date:   Mon, 5 Jul 2021 13:48:10 +0300
From:   Paul Blakey <paulb@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>
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
In-Reply-To: <cba3fd4b530e05c8262713e32bad54d87c5a151a.camel@redhat.com>
Message-ID: <d0b4ca2e-d58e-f611-219b-a8aff6c5fc75@nvidia.com>
References: <1625471347-21730-1-git-send-email-paulb@nvidia.com> <cba3fd4b530e05c8262713e32bad54d87c5a151a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e72f537-bd79-4fdd-44f8-08d93fa268b0
X-MS-TrafficTypeDiagnostic: BY5PR12MB4049:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4049353B511C2242A6EA3277C21C9@BY5PR12MB4049.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mxOhxgT5Ax+aQlbO05fIjzFwlJIHSrS/VwoxiFwoKyxdTi4RwhiFpe+HfOB5qZKj8W3PHdPkueW0yTUSgpm012qpgGcYBqil9wi/VT6FjOg206hb+WxyL5icDE3xv1a0vmxNZS+hLAS4oGSffLAkeAQgeoegolB4uJB45h5BM2qvOdXIhZ0F3XQNXS3dkx/XYmj08Bcs8WTc5I2ZM0VPrKUwaCL55+DnZFoqXw7H4flG62JUBXDgERHQcTpuIiEH1IhTvp00odqzg0RNIXdLFQFQp2G14DFGKUhvGF93WJCvi19vUH1Xw3siVl4JwQL9I9r3R4UhqRLdT4JxpIC35nQ9BlWZf4io3uXCPKQdZnYa8WE0WHzrBohm4MH2PyBqrKIH3eM8hgxOyJ9Kur55veTnZcR5Tr5fYkUV0+ONnGxlbU47nDDd162OwqXsAscVCJE4c0aNV5c2xCvJURX0l3ma95LLgI1YhaX/k86yasZQfRHmy6UDhwbr3RKrlMU7FY3jaKQdtqAlzswmXBRySO6DaMG9eDEJm4KFGPtYJbIMpdf9NpxIxCofeDBeZDcUFG/w8FkQ7EZQy7LuRGN+TI98LmcisN+T6ldVi3KYB2uuFVB8WVA9IM5utmh7CejrWpPz9TsCIXnDM2bYI+BXbrAv0qHgQsccF5W+Q5Tpn+BQT8MR4b5NGZrwbp/NjH2Mv0dD3/QUm6tRbaikd1+fYg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(36840700001)(46966006)(31696002)(426003)(6916009)(336012)(8936002)(2616005)(86362001)(7636003)(31686004)(16526019)(356005)(36756003)(47076005)(8676002)(26005)(186003)(82310400003)(36860700001)(2906002)(36906005)(5660300002)(316002)(4326008)(70586007)(54906003)(82740400003)(107886003)(6666004)(478600001)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 10:48:22.0851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e72f537-bd79-4fdd-44f8-08d93fa268b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4049
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Mon, 5 Jul 2021, Paolo Abeni wrote:

> On Mon, 2021-07-05 at 10:49 +0300, Paul Blakey wrote:
> > When multiple SKBs are merged to a new skb under napi GRO,
> > or SKB is re-used by napi, if nfct was set for them in the
> > driver, it will not be released while freeing their stolen
> > head state or on re-use.
> > 
> > Release nfct on napi's stolen or re-used SKBs, and
> > in gro_list_prepare, check conntrack metadata diff.
> > 
> > Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
> > Reviewed-by: Roi Dayan <roid@nvidia.com>
> > Signed-off-by: Paul Blakey <paulb@nvidia.com>
> > ---
> > Changelog:
> > 	v1->v2:
> > 	 Check for different flows based on CT and chain metadata in gro_list_prepare
> > 
> >  net/core/dev.c    | 13 +++++++++++++
> >  net/core/skbuff.c |  1 +
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 439faadab0c2..bf62cb2ec6da 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5981,6 +5981,18 @@ static void gro_list_prepare(const struct list_head *head,
> >  			diffs = memcmp(skb_mac_header(p),
> >  				       skb_mac_header(skb),
> >  				       maclen);
> > +
> > +		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
> > +
> > +		if (!diffs) {
> > +			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> > +			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
> > +
> > +			diffs |= (!!p_ext) ^ (!!skb_ext);
> > +			if (!diffs && unlikely(skb_ext))
> > +				diffs |= p_ext->chain ^ skb_ext->chain;
> > +		}
> 
> I'm wondering... if 2 skbs are merged, and have the same L2/L3/L4
> headers - except len and csum - can they have different dst/TC_EXT?

Yes and same tunnel header metadata... so even tunnels are the same.

So probably not, I had trouble thinking of when it can happen as well.
But user might have some weird tc policy where it will happen, especially
with header rewrite.

To test this, I ran two tcp streams that do some hops in hardware (tc 
goto chain), and for one stream of the two, I used tc pedit rules to 
rewrite an ip/mac so the two stream will be the same 5 tuple (macs, 
ips, ports) just on different chains and on different connection tracking 
zones.

For the last hop where both streams where the same, I used tc flower
skip_hw flag so it will miss to software and we get here with same
same_flow = false.



This might be too much for email (so I won't bother formatting it :)) but 
here is the setup I used:


    echo "add arp rules"
    tc_filter add dev $REP ingress protocol arp prio 888 flower skip_hw 
$tc_verbose \
        action mirred egress mirror dev $VETH_REP1 pipe \
        action mirred egress redirect dev $VETH_REP2
    tc_filter add dev $VETH_REP2 ingress protocol arp prio 888 flower 
skip_hw $tc_verbose \
        action mirred egress redirect dev $REP
    tc_filter add dev $VETH_REP1 ingress protocol arp prio 888 flower 
skip_hw $tc_verbose \
        action mirred egress redirect dev $REP


    echo "add ct rules"

    flag=""

    #ORIG:
    #chain 0, REP->VETH[12], send to diff chains based on mac,
    #for zone 4 first do hw rewrite of fake ip so we have same tuple
    tc_filter add dev $REP ingress protocol ip chain 0 prio 1 flower 
ip_proto $proto dst_ip $ip_remote1 $tc_verbose $flag \
        dst_mac $remote_mac ct_state -trk \
        action ct zone 3 action goto chain 3
    #chain 2, continuation of header rewrite, send to chain 4 & zone 4
    tc_filter add dev $REP ingress protocol ip chain 2 prio 1 flower 
ip_proto $proto $tc_verbose \
        action ct zone 4 action goto chain 4

    #chain 3, REP->VETH, zone 3
    tc_filter add dev $REP ingress protocol ip chain 3 prio 1 flower 
ip_proto $proto $tc_verbose \
        ct_state +trk+new ct_zone 3 \
        action ct zone 3 commit \
        action mirred egress redirect dev $VETH_REP1
    tc_filter add dev $REP ingress protocol ip chain 3 prio 1 flower 
ip_proto $proto $tc_verbose \
        ct_state +trk+est ct_zone 3 \
        action mirred egress redirect dev $VETH_REP1

    #others...
    tc_filter add dev $REP ingress protocol ip chain 3 prio 5 flower 
ip_proto $proto skip_hw $tc_verbose \
        ct_zone 3 \
        action drop
    tc_filter add dev $REP ingress protocol ip chain 3 prio 6 flower 
ip_proto $proto skip_hw $tc_verbose \
        action drop

    #chain 4, REP->VETH2, zone 4, +new/+est, rewrite back mac/ip and fwd
    tc_filter add dev $REP ingress protocol ip chain 4 prio 5 flower 
ip_proto $proto skip_hw $tc_verbose \
        ct_zone 4 \
        action drop
    tc_filter add dev $REP ingress protocol ip chain 4 prio 6 flower 
ip_proto $proto skip_hw $tc_verbose \
        action drop

    #catch wrong packets
    tc_filter add dev $REP ingress protocol ip chain 4 prio 2 flower 
ip_proto $proto $tc_verbose skip_hw \
        ct_zone 3 \
        action drop
    tc_filter add dev $REP ingress protocol ip chain 3 prio 2 flower 
ip_proto $proto $tc_verbose skip_hw \
        ct_zone 4 \
        action drop


    #REPLY:
    #chain 0, VETH->REP, send to zone 3, then chain 6 for fwd
    tc_filter add dev $VETH_REP1 ingress protocol ip chain 0 prio 1 flower 
ip_proto $proto $tc_verbose $flag \
        ct_state -trk \
        action ct zone 3 action goto chain 6

    #chain 6, VETH->REP, zone 3, +est, fwd
    tc_filter add dev $VETH_REP1 ingress protocol ip chain 6 prio 1 flower 
ip_proto $proto $tc_verbose \
        ct_state +trk+est \
        action mirred egress redirect dev $REP

    #chain 0, VETH->REP, send to zone 4, fake ip for ct, then chain 6 for 
fwd


    #chain 6, VETH2->REP, zone 3, +est, revert fake ip and fwd to dev



    port1=6000
    port2=7000

    echo port1 $port1 port2 $port2

    tc_filter add dev $REP ingress protocol ip chain 0 prio 1 flower 
ip_proto $proto dst_ip $ip_remote2 $tc_verbose $flag \
        dst_mac $remote_mac2 ct_state -trk src_port $port2 \
        action pedit ex \
           munge eth dst set $remote_mac \
           munge ip dst set $ip_remote1 \
           munge $proto sport set $port1 \
           pipe \
        action csum $proto ip pipe \
        action action goto chain 2
    tc_filter add dev $REP ingress protocol ip chain 0 prio 2 flower 
ip_proto $proto dst_ip $ip_remote2 $tc_verbose $flag \
        dst_mac $remote_mac2 \
        action mirred egress redirect dev $VETH_REP2
    tc_filter add dev $REP ingress protocol ip chain 4 prio 1 flower 
ip_proto $proto $tc_verbose \
        ct_state +trk+new ct_zone 4 src_port $port1 \
        action ct zone 4 commit pipe \
        action pedit ex \
           munge eth dst set $remote_mac2 \
           munge ip dst set $ip_remote2 \
           munge $proto sport set $port2 \
           pipe \
        action csum $proto ip pipe \
        action mirred egress redirect dev $VETH_REP2
    tc_filter add dev $REP ingress protocol ip chain 4 prio 1 flower 
ip_proto $proto $tc_verbose \
        ct_state +trk+est ct_zone 4 src_port $port1 \
        action pedit ex \
           munge eth dst set $remote_mac2 \
           munge ip dst set $ip_remote2 \
           munge $proto sport set $port2 \
           pipe \
        action csum $proto ip pipe \
        action mirred egress redirect dev $VETH_REP2

    tc_filter add dev $VETH_REP2 ingress protocol ip chain 0 prio 1 flower 
ip_proto $proto $tc_verbose $flag \
        ct_state -trk dst_port $port2 \
        action pedit ex \
           munge ip src set $ip_remote1 \
           munge $proto dport set $port1 \
           pipe \
        action csum $proto ip pipe \
        action ct zone 4 action goto chain 6
    tc_filter add dev $VETH_REP2 ingress protocol ip chain 0 prio 2 flower 
ip_proto $proto $tc_verbose $flag \
        action mirred egress redirect dev $REP
    tc_filter add dev $VETH_REP2 ingress protocol ip chain 6 prio 1 flower 
ip_proto $proto $tc_verbose \
        ct_state +trk+est dst_port $port1 \
        action pedit ex \
           munge ip src set $ip_remote2 \
           munge $proto dport set $port2 \
           pipe \
        action csum $proto ip pipe \
        action mirred egress redirect dev $REP







> 
> @Eric: I'm sorry for the very dumb and late question. You reported v1
> of this patch would make "GRO slow as hell", could you please elaborate
> a bit more? I thought most skbs (with no ct attached) would see little
> difference???
> 
> Cheers,
> 
> Paolo
> 
> 
> 
