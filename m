Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D44485695
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241893AbiAEQSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:18:23 -0500
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:12256
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241888AbiAEQSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 11:18:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V979Eu+I0W82f1xgPH7OItrx7fJS7IdlX/xRmv7bLrLY/sx30FVRmkfM/4cbCN8FIAHnVy0C157eY2Ihhx251h3POuBIMuWrY4Gw2PdPEjZMb4dRSaWP43ar0AfPFyGTfkCD1wl7Xt2L8Usx3SjAhV7wT+zdU839vklUPX2n6O5UZXF7/tahtxsw0LhWImu9vwJ1xnpRMdlWaHqc61/C0KaPXLFnh9jwiyHQ4SrrWclx5VzJ1JjV0MbN7RIH1Sfo5ZvicW6guBC8PFMYIy4yTlO9R0uU/MaF+fjkkVcp8l+WjodScRWaK94eH6Sq42vc57Y2aMVz4/Jrn2H8e3wQiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tuNPg4aAtYEDt6FecY/FkofGpB/3+1fptnv/AwCz/s=;
 b=VnjgaNxQ7gL465ZjGZ1uoKS0i8KGFh0x8vwmne8RW+7tPpp46l5jq9X2h7aiODbufylHNPOiMykpXid6PDfUEk4iK5qQgkU4FRBZJkfrbwjDSwo+s5kQOJGO9TEdZH/WlPVrFdnxm/YVSKejb8FaSQLPK3amHl2N8heC5WTe3fc1oXSsoyWGgqhHJ8tePiCO39FsazF5ep0OWdrDKdXgDdj9IfjmGN1f5hdjYyUKQoydeq4JWbwm1wA3PPe4buYF3D90IEpsvinZlmdVlcTT5CVI6zFKEXURObM5cq570Abulh3hlQIejsnI+L4/RCxnDazIczytKdARUTrLFHfOGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tuNPg4aAtYEDt6FecY/FkofGpB/3+1fptnv/AwCz/s=;
 b=kjZPDJJIkUJFXoMta0kKKaBd7jng+6v3au69hDwFNUQH4K624HRXYx+3xxy3nui6H3MfnvM4YtzKoPkCK+ELkhEJc0ZIyZjdRCpikaM0qCXSgndNsMTLBa84bpl5TvNNSfILLjlSKB4+p4GWnsVs8cGC+1t3WdSX0d7OmdZjh6qnnqDJRatlbQ+1kadFgr1bBP99FFHhWPDDsgocqSdyOLyFmMUNi4cFEXNpSoX68cpAVIHE4/LbTzs+JuSFZi9nlc0RaEZ3YcOL96w5blspm2wytLgfTjUChVR0264aF7SL6lnzosAw0Kco/1H0a/wtrK4rBYoWVhO2eHg3zCvjPQ==
Received: from MWHPR01CA0045.prod.exchangelabs.com (2603:10b6:300:101::31) by
 BY5PR12MB4803.namprd12.prod.outlook.com (2603:10b6:a03:1b0::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 5 Jan
 2022 16:18:20 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::dd) by MWHPR01CA0045.outlook.office365.com
 (2603:10b6:300:101::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 16:18:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.7 via Frontend Transport; Wed, 5 Jan 2022 16:18:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 5 Jan
 2022 16:18:19 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 5 Jan 2022 08:18:15 -0800
Date:   Wed, 5 Jan 2022 18:18:06 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <john.fastabend@gmail.com>
Subject: Re: [PATCH net 1/1] net: openvswitch: Fix ct_state nat flags for
 conns arriving from tc
In-Reply-To: <72368c25-83c5-565f-0512-ca5d58315685@iogearbox.net>
Message-ID: <5599f6-e02e-9ad5-3585-db252e946f43@nvidia.com>
References: <20220104082821.22487-1-paulb@nvidia.com> <776c2688-72db-4ad6-45e5-73bc08b78615@mojatatu.com> <72368c25-83c5-565f-0512-ca5d58315685@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="-720718829-476669518-1641399498=:29365"
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9940fefa-eed7-4110-a82a-08d9d066fd36
X-MS-TrafficTypeDiagnostic: BY5PR12MB4803:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4803E0AD404CC91C8CCEE702C24B9@BY5PR12MB4803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZW7XyM/ICvtOusA8gYkcNZGsimavxm41zXCaNxO+MZNtMhO3u57syWZd49QtExPPeNAsM95GmDgGOfx302QyEXOkmN/U2xNSOYgsqqxjQldOkGPTrkmt7Yv4b5zUv2OQpgFmd/S9AdmmhyyFRSJ/0rzLQsQz6BXmS2Lmb2oQPEQ4BetsmJTHXmq9VCheWIoy7luNpbGOuhPUEQtJUELGhQ5f+C/hVcmz6yTeNKtk3t6Rnp4pw1o74t0YkmsA7QQBj5Eel0vuy83tHypjkNs1SS+iymOgaJd39iOXWuhxYYzp+n4KBwNY8//Q6f5FJsdhrtlXoNF4T1XHy7srKQOyNHM+UHv6GRJQKqw1RnMmHyWqeyQrN8iPli7ytFgVKvZjj2VmGSYL50gLRcmevSOLEYdh7mDUfDB9XxHYynU+18StEgqUE5wsFZy479EF61EY5TktMzMqdabl4cxWR1W8PPpJqhkkbmrUQlIh8vFeahVMbx5gOr4sWoQHIUfYMQX/X6zJkuMhn8RdI9eZ61ChvX3zy0G1AT/Dx0nNyJYt6nV6HeXJGSuIW76jk+u4UuBd+NpyXETHVyB9S/ZU4iMr8ZVsLQ1ZAHKyMnLo2S2zyDSuCE3NZDbVPqtDD4bdCJAweU1Ox3weivnJaUz2bYoX1Zq5N+ZPRpQEdY9BZ4bEwRBR7DmDh7m9erb3CuGKclZsByFS8GhwWKKlRuR51Fag0YH0eWJtK9aQ8b7QYehFpqZDV9u1wUthUROh8RpH3LrepFZjDkGUny1wLQ6nhgvDa8cB8m+vlzDJY9cxblq3lA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(33964004)(54906003)(6916009)(6666004)(316002)(356005)(53546011)(36860700001)(82310400004)(426003)(26005)(8676002)(336012)(70586007)(2616005)(186003)(16526019)(8936002)(36756003)(70206006)(508600001)(86362001)(2906002)(47076005)(40460700001)(81166007)(5660300002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 16:18:20.2157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9940fefa-eed7-4110-a82a-08d9d066fd36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4803
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---720718829-476669518-1641399498=:29365
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT



On Wed, 5 Jan 2022, Daniel Borkmann wrote:

> On 1/5/22 3:57 PM, Jamal Hadi Salim wrote:
> > On 2022-01-04 03:28, Paul Blakey wrote:
> > [..]
> >> --- a/include/linux/skbuff.h
> >> +++ b/include/linux/skbuff.h
> >> @@ -287,7 +287,9 @@ struct tc_skb_ext {
> >>       __u32 chain;
> >>       __u16 mru;
> >>       __u16 zone;
> >> -    bool post_ct;
> >> +    bool post_ct:1;
> >> +    bool post_ct_snat:1;
> >> +    bool post_ct_dnat:1;
> >>   };
> > 
> > is skb_ext intended only for ovs? If yes, why does it belong
> > in the core code? Ex: Looking at tcf_classify() which is such
> > a core function in the fast path any packet going via tc, it
> > is now encumbered with with checking presence of skb_ext.
> > I know passing around metadata is a paramount requirement
> > for programmability but this is getting messier with speacial
> > use cases for ovs and/or offload...
> 
> Full ack on the bloat for corner cases like ovs offload, especially
> given distros just enable most stuff anyway and therefore no light
> fast path as with !CONFIG_NET_TC_SKB_EXT. :(
> 
> Could this somehow be hidden behind static key or such if offloads
> are not used, so we can shrink it back to just calling into plain
> __tcf_classify() for sw-only use cases (like BPF)?
> 
> 

It is used for both tc -> ovs and driver -> tc path.

I think I can do what you suggest adn will work on something like
that,  but this specific patch  doesn't really change the ext 
allocation/derefences count (and probably  not the size as well).
So can  we take  this (not yet posted v2 after fixing what already 
mentioned) and I'll do a patch of what you suggest in net-next?


---720718829-476669518-1641399498=:29365--
