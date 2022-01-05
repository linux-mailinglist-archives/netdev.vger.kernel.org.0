Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71C1484F57
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbiAEI3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:29:49 -0500
Received: from mail-bn1nam07on2041.outbound.protection.outlook.com ([40.107.212.41]:51929
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229962AbiAEI3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 03:29:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffwjNxYwWKyl+MERJkDjpf6v/aimAufGG2cZdpv2MsyctpkZRtaoc2cyaHr4bJ32ai3sCtG7YVB6dkCjhjXkuO6veFijIlhhSFMFO4/yyIuXxjYLUAgkjMN33FXjoQ2ii/Z9EMuSKfbie6spJDL9lFDyPrOUNfP/G692/HsYPqpMBNRHawGjBNVoPWfsus938POLRuYy2p+bzapoyFdNnKeR1dzndFvFLUU2H3d0/FDWAIFssbDXOm8QjOozSxwuUqxg+YDxGxymkGdCCbYoO1yzWP1suLAIN9YTE5gcFMk/bg/LFEDJ4S6GtTgs3L4bdgyak82bwPtvzzL02Dr7xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmSa+5isvJTgo+IPnfbjMEjR4+ZMZnRAqJKfSCoRUec=;
 b=ER7psvypcZrnz0lfkMhp479cAOKXqz/r11v+7vu+WcPtmHQO3HJjzq1cWvEGWC+IjDiGQSr3oeZ0vejo6VPxtbAeDuk/sy9hr/5KwzeE/bdQfy7cgcXdOTUHlXbErZ3Q/EB2e3/eSc3ae9hm9OZcE8oszYx0LqPFxJN4XdOHlewzvUYjF2z/fRqdRkVv1S+LNjdrJjBpHoUmSCCTkVkghwMgGwKtEnx9uaZiCtZ7rNsri8fe+gf2iyX4ISmHFqjir+CfwKSfFSNyAFmuShvUFUxPrRNAQ61ye7L3i5eSYHFlO0v5L2CZmPLxo2FFzyDVwZOMMdVcIgBjClKmvRDLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmSa+5isvJTgo+IPnfbjMEjR4+ZMZnRAqJKfSCoRUec=;
 b=S9JwET6W+4mh5ESGlsosNdPKPCvGsZ9kg2lbzn2sNDbzWZ3uq5W/OuSe5sdSP1CPNJ+ykg0Q9L1QQd5gwe+xK0xFiNI1Vo21KeC8oqvxjfLffaV/b77nzKajs0TWPPULuLcWFmP/EROB499V5F4KGGue2kO15y7y6XPkdrTevVGCfK9xcrlRLkCd0+JD9+lDi3o+nSHLo8GO/2IUajJRwnTjORfw9uckjI2Mx0cGqqS7d846P4hUD/veCatzC5svg9sI+DtvUdMIAOTMdmE/DO99nyOpWmmNCNzEY1rKOQ1W5MsXzYBY5fHJo12xX0DhyLTDA/ZGnp1l0BhzsfGJkg==
Received: from MWHPR13CA0018.namprd13.prod.outlook.com (2603:10b6:300:16::28)
 by BN6PR1201MB0148.namprd12.prod.outlook.com (2603:10b6:405:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 08:29:46 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::1) by MWHPR13CA0018.outlook.office365.com
 (2603:10b6:300:16::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.4 via Frontend
 Transport; Wed, 5 Jan 2022 08:29:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.7 via Frontend Transport; Wed, 5 Jan 2022 08:29:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 5 Jan
 2022 08:29:45 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 5 Jan 2022 00:29:42 -0800
Date:   Wed, 5 Jan 2022 10:29:32 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net 1/1] net: openvswitch: Fix ct_state nat flags for
 conns arriving from tc
In-Reply-To: <20220104100835.57e51cb0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <3fd43dfd-f44b-5afc-83c6-d3c9ae7d1a30@nvidia.com>
References: <20220104082821.22487-1-paulb@nvidia.com> <20220104100835.57e51cb0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d93bc760-0c83-4344-342f-08d9d02587cb
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0148:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB014846873113FD64F2CB295DC24B9@BN6PR1201MB0148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K58FJTRmWzwavAl9WGxVykUDPxGaqwrv9UzKYVP0ZvCHy5RyehTMsevLzyUn243CrS876XgPkxlrzP7nUVKtW6zcR/b4FigtRXLXdDjNgzZ3T67MIPtR0FQyuHwjzXH37OklZRJVCLnRnSirv+/gXFVR+dnsJ99fdQ4gfpG0YCFV8kyQ30PqqUWKXk1LBLmdc62NEbhYrS5YcDw0hCmykNNtbTXL4gpl5w3L7H8z/h9eQbuSTZAk/1u6aL25tJiCEFVsP7Qxmlhx5iSZ1zvPicEK263wjzmjhC0kRBNu4A0aepALRmM6aFbBdbRsU0d9BdaKWHPpT5gXPNOKj+GIGEgEEk2BHMDO13QDZ5LH8JxOIJoyv0eathBufT5lcfLBtT8LoKBzeqGU3of8TzdDi0CZfYq0cmndNIt8jAsJiIpPClyglcDGskJ94mzJ82YLurZ4c0LoLm1BCnAzxsEbHMWpzhl4Uzq6a0fZM5n/jlbd8WlX1q/O1aAY8fwQ9+/GYNIKPozufgR9TWlwL0trl3TimPkBinrWgzzN+m5hYPcGr5eSSCiP0p+ZUTWJ1iUO4DagyfaDaURbGy2NpodKFzmbomnF7mJMKK9xqPI9GfpxqV6H7Ou2O+dFBVriqLZidsrLpoOUiq9K8/nELDMd844Z3MJV+GYPxzCVPcBnMuXe0jdh0PHN89lotUaf/ZojR4a9rJ34MaU6qBpE5UJWz7P9BpA/plF9vxmvt2bK0uh+BVY9nYeoGjO3MpyFib2fdLtZL9s9xuFyTZGPBIXTLeqC2Y85Hj/tq77ZAVhjcjs=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(70206006)(70586007)(508600001)(336012)(26005)(6666004)(54906003)(36860700001)(8936002)(31686004)(4326008)(5660300002)(36756003)(426003)(47076005)(186003)(16526019)(31696002)(6916009)(82310400004)(316002)(86362001)(40460700001)(356005)(81166007)(8676002)(2616005)(107886003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 08:29:45.8994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d93bc760-0c83-4344-342f-08d9d02587cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0148
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On Tue, 4 Jan 2022, Jakub Kicinski wrote:

> On Tue, 4 Jan 2022 10:28:21 +0200 Paul Blakey wrote:
> > Netfilter conntrack maintains NAT flags per connection indicating
> > whether NAT was configured for the connection. Openvswitch maintains
> > NAT flags on the per packet flow key ct_state field, indicating
> > whether NAT was actually executed on the packet.
> > 
> > When a packet misses from tc to ovs the conntrack NAT flags are set.
> > However, NAT was not necessarily executed on the packet because the
> > connection's state might still be in NEW state. As such, openvswitch wrongly
> > assumes that NAT was executed and sets an incorrect flow key NAT flags.
> > 
> > Fix this, by flagging to openvswitch which NAT was actually done in
> > act_ct via tc_skb_ext and tc_skb_cb to the openvswitch module, so
> > the packet flow key NAT flags will be correctly set.
> 
> Fixes ?

I wasn't sure which patches to blame, I guess the bug was there from the
introduction of action ct in tc, so I'll blame that. 

> 
> > Signed-off-by: Paul Blakey <paulb@nvidia.com>
> 
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 4507d77d6941..bab45a009310 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -287,7 +287,9 @@ struct tc_skb_ext {
> >  	__u32 chain;
> >  	__u16 mru;
> >  	__u16 zone;
> > -	bool post_ct;
> > +	bool post_ct:1;
> > +	bool post_ct_snat:1;
> > +	bool post_ct_dnat:1;
> 
> single bit bool variables seem weird, use a unsigned int type, like u8.
> 
> >  };
> >  #endif
> >  
> > diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> > index 9e71691c491b..a171dfa91910 100644
> > --- a/include/net/pkt_sched.h
> > +++ b/include/net/pkt_sched.h
> > @@ -197,7 +197,9 @@ struct tc_skb_cb {
> >  	struct qdisc_skb_cb qdisc_cb;
> >  
> >  	u16 mru;
> > -	bool post_ct;
> > +	bool post_ct: 1;
> 
> extra space

Will remove, and send v2.

> 
> > +	bool post_ct_snat:1;
> > +	bool post_ct_dnat:1;
> >  	u16 zone; /* Only valid if post_ct = true */
> >  };
> 
