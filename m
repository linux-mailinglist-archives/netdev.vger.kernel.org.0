Return-Path: <netdev+bounces-2648-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F25DB702D3C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98C122812F5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFF6C8D6;
	Mon, 15 May 2023 12:57:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577F7C2D6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:57:58 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215D91716;
	Mon, 15 May 2023 05:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQN38kTLDYiq73N8ZTRl3LkIMEdIDzr6Gw58qXK7eLgEhfC7WAocwv4NM/VOBObDEDryvdSAj3W0dcgauGh5hhcuwLLDns3E9cZLx+sj/gyNGBSr/5PMkYSwvbXEzBv91rbemIQyrCj8LXpyuirUJPpZ3iB8BK0LK0o3JgEjUGQ6Uc5Qoavw4KWvbasAehIe5mlHesqCAgwewj2j21s4ZGzQYf070/vq9vF3kKI2nclyrYlzvjRr8MgG2bNfIzBcRdJo46DxDOupJVChcgbY+g5QUprFNprqVs90uE8AZRw4di/S4dTZRtJEF++xoOOUHW2TqoN49Bv9Mx8ywXGLPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIWgkfNGksa0mhslJ9JG2FAb/+3WVQPHaacJMVcTKgU=;
 b=lZUY7SSA50ty4JKZ2bZXYr9CT1rfgLmhcxD+y9iI6WXb5uTrZfie2Rvnx3UyD5sy4dl4orkjyIaXSsGuW4CCIM/0yLpX+6vc1wAgoXcLTXZ/EsAlzjABDjL05+Px/Cp+GEaX9MZR8LCdsT0YVVZpYz25a8jHf2VfbfgjTSWMpQniFqtaUDsS2+IIRGnI6nHic9MTigEyFCuVO/wK0mQKjnVzLAq2UwT6s01tG8J1yBg3zjIxV81tuCKeXrVuC5pmb9WL7bud/4ARnWemZaj5h2oeCNmpbV8CPL+7UOrCCAtpP8B40CBvrs2B3DRWe/ZhmKzxSWWsHlSak7iAvlmHdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIWgkfNGksa0mhslJ9JG2FAb/+3WVQPHaacJMVcTKgU=;
 b=ZslMd147DGlik7wvG2M0WdjFo1ZGgkrFICm3Q/TkhLBAiDYPaCVGlqXM9Az6YwXF8b0DtiB3OnPRLsnhp7Cx/7CdtvYDlEsdPi6MbbDd+BtP0/9Me+6J+mKb2w6I4UySmJZUgFqqhSFe0gLgVbWQD28bmo2V5CwoneY/G+qFSFmWyKfutVO50gTc3OM3G2agMdtr9+OejVgOc6z9O6XusHMxyoEkvvB1sNKq8Vbz3Tgl9wIdR9at8DUqM4MfmXmhB+CcIEWjkCq4vv8+6UNvNdcu7Vx+oEs+hHmhvcfTY0Irht0FIxxp4EBuSivvBeJLk1G6raFSzR6XNVfeJWHHUw==
Received: from MW4P222CA0027.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::32)
 by IA0PR12MB7723.namprd12.prod.outlook.com (2603:10b6:208:431::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 12:57:54 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::ae) by MW4P222CA0027.outlook.office365.com
 (2603:10b6:303:114::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Mon, 15 May 2023 12:57:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.14 via Frontend Transport; Mon, 15 May 2023 12:57:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 15 May 2023
 05:57:46 -0700
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 15 May
 2023 05:57:44 -0700
References: <20230512010152.1602-1-angus.chen@jaguarmicro.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Angus Chen <angus.chen@jaguarmicro.com>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: Remove low_thresh in ip defrag
Date: Mon, 15 May 2023 14:46:03 +0200
In-Reply-To: <20230512010152.1602-1-angus.chen@jaguarmicro.com>
Message-ID: <87ednhrbuh.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT021:EE_|IA0PR12MB7723:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ed7ce79-966f-4a6f-b0b1-08db5543ff30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VYt8bwv1aPDv2dc1TimeJ3y/k6vFcg1cSN35W2rcwTWl632BFdKCGNierTDR8+Y0/QRj6IGEJTYgNarPvHwcF+An6bm9z1CKg7KldrLcihSd3NOclNuG/cDwVh7hN6rptZByGxh7J7G0etb0Eb1MbkfCnXUqODtlnLUaEFRbeu3l5hMPcLmDlbyoyIm8GqTp1OTGlu0clO5lUVY7m61ordv4KpTV0ScCSuwUXG6mSkx+/oi2kWtRnow2bNvBT1aw7HYeb5Cb8QY2askk7UDxdd+IzHYt9cCyk5L3jPK+Wo6IeTBTthXfqNhKyrrFs2LrjS0dZGBs3Sv48IZ1XoLBkG8n516eB2D0TrIFWTXxhOu0Dck7gsXm6djsgg7s4z96vQpaIdawZGCtUTdFzRC5mgYsZuXydAUKQcBUZSzwe23t5OH/343q/kA9iy+isIj0dAW0DWD8+c4YKz04QhYYQGwnC66NnMznVeWXWFtlnT25PKj5tRozOyBCoNkT0VoJ9OKUPDzEEZehB0hHBNPthp+jfZRDWAsQWt1ct0Wj+1ncdIOtqof56w647Rgiyec9tmpDoDfupYC/G9mhEiNum/G3urNtm6vhytV7qdejBkg2chRbp8aH0ejoWNDWqTsGmeUlqmV1RvdEoE0AW6u38ven5Ddl3qE+pNVryVcfPl4ser+PdBZJLmY3UCYh4I1My7ZWXg40ifrUVagaUar4YypiS11hBzhAdOkU1w9m1fESGpbvRkxaNlxSxjUjr4iC
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(36860700001)(47076005)(186003)(16526019)(2616005)(41300700001)(6666004)(426003)(336012)(83380400001)(26005)(40460700003)(478600001)(54906003)(6916009)(70206006)(70586007)(4326008)(82740400003)(40480700001)(7636003)(316002)(356005)(5660300002)(8676002)(8936002)(86362001)(2906002)(36756003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 12:57:53.4514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed7ce79-966f-4a6f-b0b1-08db5543ff30
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7723
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Angus Chen <angus.chen@jaguarmicro.com> writes:

> As low_thresh has no work in fragment reassembles,del it.
> And Mark it deprecated in sysctl Document.
>
> Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>

When you spin a fix for the issue that Ido has reported, could you also
smuggle in the following fixlets?

> diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
> index a91283d1e5bf..3ba4c0f27af9 100644
> --- a/net/ieee802154/6lowpan/reassembly.c
> +++ b/net/ieee802154/6lowpan/reassembly.c
> @@ -318,7 +318,7 @@ int lowpan_frag_rcv(struct sk_buff *skb, u8 frag_type)
>  }
>  
>  #ifdef CONFIG_SYSCTL
> -
> +static unsigned long lowpanfrag_low_thresh_unuesd = IPV6_FRAG_LOW_THRESH;

s/unuesd/unused/

> @@ -674,12 +674,9 @@ static int __net_init ipv4_frags_init_net(struct net *net)
>  	 * A 64K fragment consumes 129736 bytes (44*2944)+200
>  	 * (1500 truesize == 2944, sizeof(struct ipq) == 200)
>  	 *
> -	 * We will commit 4MB at one time. Should we cross that limit
> -	 * we will prune down to 3MB, making room for approx 8 big 64K
> -	 * fragments 8x128k.
> +	 * We will commit 4MB at one time. Should we cross that limit.

"Should we cross that limit" means "when it happens that we cross that
limit". So on its own it conveys no information and can be dropped.

>  	 */
>  	net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;
> -	net->ipv4.fqdir->low_thresh  = 3 * 1024 * 1024;
>  	/*
>  	 * Important NOTE! Fragment queue must be destroyed before MSL expires.
>  	 * RFC791 is wrong proposing to prolongate timer each fragment arrival

Thanks!

