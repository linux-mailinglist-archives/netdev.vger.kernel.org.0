Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EBF4748E1
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhLNRII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:08:08 -0500
Received: from mail-dm6nam10hn2247.outbound.protection.outlook.com ([52.100.156.247]:6113
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231544AbhLNRIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 12:08:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKjmG5fZqmriXrSJbMfxT+SzvCtHdgJPKXS3AHEc0d8vba3JYM3hEzMgr/UbK/mq1Mjxf5gV1IeCIEeCy+ElmjXFjlzdKxogx46+3B2li85HykCaXwCTEYD759ZH8KOuMoPTT2rjr2W+l4a8vxc/HUhVHfPmnY6d88MDZ2b1LPRVy/pgW5e/b0OiAiQUd8Mbog1qMdFcGFZHvwAHofyQ40m3K6mF3vnJ6QHruEX08kZNSq5A0HBr5UlrbVPELz2XDUQIWtrY7YfFSDyBoO1F/hyUF6TMxdrp9jjEh1zpOGVSO21Y2RqQAJtZ7Z5VNfnC5y10VKBqE/QOzsWFbnBS2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9kbyCoyMS4GoF+jSvKqCtymJAwNZ42zEfytry19DnI=;
 b=kTIXs3sgPo0nbUVU4JZZbgS+SJByQMpZqJ1mx8dXhibhgCQKcqLm64m4/GOUgN8Sj3GZPKrf6u1Wu/xnPwJ524cFYKMGaA0SkejsWIoCid6CVq+w+YP21OkrnzTot0/F/UCF5VjwFS8EeFe3oA0fYrpgyTX8X0G5XpdLJ8OnDw4pt6BhMfDWB71RlfkwTKV16t/WZOf2FCo0NOu1OInPe7tou8IzZ4xh1w7WVBaDZJ5caIaG4FPuLiBu4+1AOO+tgTjy2oLAN4+Fd8ut3spQZb5JuLMTMemYHnrt5gJS8IGUpU04ovvx4sBvm0NC172wVR8kCFVf6QR7TZV5z8oTQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9kbyCoyMS4GoF+jSvKqCtymJAwNZ42zEfytry19DnI=;
 b=smLsNee4mgrkWBjGJsxObAN1bSn8sjuyc+WsXnuIRPa+qT+DKXlpc8ViRFeAMpp4Vdg86o3H2VKpA0TUiQzE2lo8nECoMQ+qAhQAnT1brbbVkQl2zhDWrQT8Td4CKvs1nyzF78dANIuflznX9f2850Exc5GGvPJXVSC/SwSvkTMGzsaUWGmJIRzazPyyk0/ZpiGcZd6vdnESk8d3tvAxpTRvvlLed9H+Hudk7HJRc51/GxwkBnoo5sQgm24nS8fYv3F0OHNMDGNnpPisYKz/m14JBxQqIWDNdkOqJKLJ3/EKnFBXo7BNhmXnS5Qz53R+dJegqLUPCAxSoy3L15O9xg==
Received: from DM5PR2001CA0013.namprd20.prod.outlook.com (2603:10b6:4:16::23)
 by BY5PR12MB4952.namprd12.prod.outlook.com (2603:10b6:a03:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 17:08:05 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::db) by DM5PR2001CA0013.outlook.office365.com
 (2603:10b6:4:16::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Tue, 14 Dec 2021 17:08:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.16 via Frontend Transport; Tue, 14 Dec 2021 17:08:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:07:58 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 14 Dec 2021 09:07:53 -0800
Date:   Tue, 14 Dec 2021 19:07:31 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net v2 2/3] net/sched: flow_dissector: Fix matching on
 zone id for invalid conns
In-Reply-To: <20211210205216.1ec35b39@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <70464673-4ecf-169f-7b70-71f8d8c41cd@nvidia.com>
References: <20211209075734.10199-1-paulb@nvidia.com> <20211209075734.10199-3-paulb@nvidia.com> <20211210205216.1ec35b39@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 564eee8c-c5c6-4599-6be6-08d9bf244b4c
X-MS-TrafficTypeDiagnostic: BY5PR12MB4952:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB495282DD5E05EA5CBC887599C2759@BY5PR12MB4952.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jFQn6xpZblPMnpTej5DCgiII+5a3cUVcTP9GRf6leCpKOpppp3qR4Wvx59bN?=
 =?us-ascii?Q?lxFkLo6OHbpfj62RNYFS2wX+gHrV0KR9DtFFYikA6Y3HkcjSkgV5jvQNbcyk?=
 =?us-ascii?Q?XfiYDbY9W1xFrVBIOuoVld3TjbkU3vuxX3yzdxxWIicEaQ5d72b19zadCAq2?=
 =?us-ascii?Q?nXNUSyF5pMftJJgkhsMKljCaKzNHGh5mOQMc74Zesc7ph8PUUE4GPW/26gDd?=
 =?us-ascii?Q?h+qBhRCIL6bNie3io/qPtBOMc23knv2lgR98taYcxQFZ3UvL+emBZW8tjn15?=
 =?us-ascii?Q?C/8Jdv1aL/ZmYZJf15md3nAY4HQU3BpKnRogYuRixNw6P2WNwgyjvEO2Hhx6?=
 =?us-ascii?Q?1HgtC4CdtZp18T4+Lp5Dh8n+Cq+6RPb5tmbezXQ2XTDSHcDQGjS8Jc76fjjF?=
 =?us-ascii?Q?ZCUX1X04TmDRNvJAsAJTmGoE4b8D5k9R+Wv5jHPNe5Fb9AmTv5YKaJhypq7L?=
 =?us-ascii?Q?DRXuZKkXZE2FEMDIKs3opaAC3vd9ThcdUF6xjBLUFUWHp0cjyR1+mcN8DduU?=
 =?us-ascii?Q?6CoB9/0HqBNl1pMTi+r2ov7BMi3Mk7MhVJKe7Tjpmuaa7AUwG7nadGMuIZzx?=
 =?us-ascii?Q?Gw/gITHkHJSjD045IFepGWyxu70anDMubUEG6dCHC4Zw+ShgZDHQnPNnacN7?=
 =?us-ascii?Q?kxpn2ehYS5Rz93DiKVQOfKZbtv6F4ZBhihIIxh3pTAd8XwFtgYrxVbNviwMC?=
 =?us-ascii?Q?2/FzuwYvb4QCnHi+D4IzouDiU7gVJGxcsC5c2+f9P2yaYRPyuirTX/i9PYbI?=
 =?us-ascii?Q?1cD5ZQ9RIJtc1nKFEIoHPdEMmFEK7tJRCwXPoQD7agghPJ5Uc4uz+gkf6Oz3?=
 =?us-ascii?Q?NUScVdOpGxgKrfmXa8ZH3Ga5oQOy8GjBOHaIkPRybyQq5tmLMF7xk55oH0Cb?=
 =?us-ascii?Q?ndm42W+yvG/UmTqwiJL+LjtPp3Dghqmng/lKKAhzaVHfkBkk6e2DXRL7CL7F?=
 =?us-ascii?Q?ivV/YR4NKEwJuytP76uwCwvJBVa1B+U7TmwJ6YkjdT1pmuPAcvC3O3y1CeNz?=
 =?us-ascii?Q?Owxmd2eL8Ad2SyLgKWgwbj9Yk0Cw6soKhVLhNfXEzJg0uEVBse5RYvQbHtmM?=
 =?us-ascii?Q?qdpfp/WobP2Q8j75T90JD3bO7u2zclfFOcHKHdZf//YuuAR2fL/vNVOkzX1e?=
 =?us-ascii?Q?JQnn/LEzPOKY7MeA0529Wr73iist5CrklQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:OSPM;SFS:(4636009)(36840700001)(46966006)(40470700001)(186003)(47076005)(426003)(16526019)(36756003)(86362001)(2616005)(82310400004)(8676002)(54906003)(8936002)(4326008)(36860700001)(70206006)(34020700004)(5660300002)(356005)(70586007)(2906002)(26005)(6666004)(316002)(4744005)(508600001)(6916009)(7636003)(40460700001)(107886003)(336012)(58440200007);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 17:08:04.7976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 564eee8c-c5c6-4599-6be6-08d9bf244b4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4952
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Sat, 11 Dec 2021, Jakub Kicinski wrote:

> On Thu, 9 Dec 2021 09:57:33 +0200 Paul Blakey wrote:
> > @@ -238,10 +239,12 @@ void
> >  skb_flow_dissect_ct(const struct sk_buff *skb,
> >  		    struct flow_dissector *flow_dissector,
> >  		    void *target_container, u16 *ctinfo_map,
> > -		    size_t mapsize, bool post_ct)
> > +		    size_t mapsize)
> >  {
> >  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> > +	bool post_ct = tc_skb_cb(skb)->post_ct;
> >  	struct flow_dissector_key_ct *key;
> > +	u16 zone = tc_skb_cb(skb)->zone;
> >  	enum ip_conntrack_info ctinfo;
> >  	struct nf_conn_labels *cl;
> >  	struct nf_conn *ct;
> > @@ -260,6 +263,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
> >  	if (!ct) {
> >  		key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
> >  				TCA_FLOWER_KEY_CT_FLAGS_INVALID;
> > +		key->ct_zone = zone;
> >  		return;
> >  	}
> >  
> 
> Why is flow dissector expecting skb cb to be TC now?
> Please keep the appropriate abstractions intact.
> 

Will do. Sending v3.
