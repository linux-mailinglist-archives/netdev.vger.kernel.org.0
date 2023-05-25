Return-Path: <netdev+bounces-5404-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7687111DD
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 690742815B8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61A81D2CA;
	Thu, 25 May 2023 17:18:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41851D2A4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 17:18:23 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2076.outbound.protection.outlook.com [40.107.101.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2361B4;
	Thu, 25 May 2023 10:18:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhpvgJ5ZjIH6JBsOe4eOqgtvIXyYh+3gGuSSTdQgXG/UEFOg5wC/OUQ2S0fZT3885HqNknlo1Y/8jDXbGeLqvoKupbxp4KDmsrzzG1ZErXvonh2QqEtq1bVEenMA56lr87zksV0ZtlbtdNHGNCgH5C4cCHzbw2LLIR6aHbF4tTrQN9QZp524JWQZ07bId3QvXx4238HOek8W4EIk0Ea5mFz3sDpw7jMxTVZ6WdF88JK+yF2ApZtOOYM1+/3K8RObxXI7/8knItPuQ/LP8gy5/AhrMvmELFimHRVY7pSZsKaZ1VlRkh0hx/kE9K8jwgJ14c/QvMEstQVAFF1/crvnQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Za0EUGcE4eC9u3b63UZX2xurGmnTSg7AdeMWiDe5Q/0=;
 b=OqJEvk609u5+xrOEuA2Q3KtmnSXhB4eSWnS2sFtuKk+0Bpm8/XW2o557gc7nWs19FYHjnFSRqV1egVqa4rBTNI1SAmyIbGJQRcvM8fjzhlj7ev8pIYHd13AB0eR3Leb88qRImzWoYCmi+6CMuoX2EigcpFqSKBJ5lxIpE75KcvGtiI0a9SoryEbQ5FF9Cix2XbsCnrV/oXaM4VKYkkYv4H6OAtILcw+tVuiZePju1rvpmZgJMTluWqTai/xwnyJeRy+N/F1MCX5SM8JRLa9GmaPGjhzahYhNxFupYfG/jGr9lMPKVemA1Ut1IDlegnNlVSetdnvnp/e7PyziAygv4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za0EUGcE4eC9u3b63UZX2xurGmnTSg7AdeMWiDe5Q/0=;
 b=MWYiohnj4i1fiRt63Gf4vieRxxQHx1URtNA4Hl38u88uDJxnyLcL9VvozEzk/ikQsAC/cP5FhA9Cmd8+/pwxSC+ZNb8A3DUMr0Xkz0EXr7mSwi6SskjK3DF1YsNfnDN5i6nkSCc20ZJwAK7o5pkLZmPlAm7YBWU8sUctTu/BAHS3iEup+7DYhKGy5w4NyLi6RlABcaKZWFSo433D1EDN0NIsWW47CCJHz/dELuHj417JHlBPzl/c0+nVVEds6Va/7STq61l6k2fLoYSmJJz4YRB/KQdtZf2kgsajFa0+c/DDpg+YM92leixwkOAiqmUpvv1Rzz1QPyq6ZLTUex8eUg==
Received: from DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) by
 SA1PR12MB7441.namprd12.prod.outlook.com (2603:10b6:806:2b3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.17; Thu, 25 May 2023 17:18:16 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::23) by DS7PR03CA0212.outlook.office365.com
 (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15 via Frontend
 Transport; Thu, 25 May 2023 17:18:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16 via Frontend Transport; Thu, 25 May 2023 17:18:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 25 May 2023
 10:18:03 -0700
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 25 May
 2023 10:17:59 -0700
References: <cover.1684887977.git.peilin.ye@bytedance.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Peilin Ye <yepeilin.cs@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
	<xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, Peilin Ye
	<peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, "John
 Fastabend" <john.fastabend@gmail.com>, Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Cong Wang
	<cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 0/6] net/sched: Fixes for sch_ingress and sch_clsact
Date: Thu, 25 May 2023 20:16:51 +0300
In-Reply-To: <cover.1684887977.git.peilin.ye@bytedance.com>
Message-ID: <87o7m8xrcq.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT011:EE_|SA1PR12MB7441:EE_
X-MS-Office365-Filtering-Correlation-Id: ad683c4e-ef97-47c8-e7e0-08db5d440626
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jE8aVBsWLXEGwC3XbuVP7kSmrcWAhfqkIh2WpTQYvInOcVeFTbkM8+7zBr8xgHy+9YMKv8vxSL8fpMImeTus80kgxOTbE5RtniV+8NGuMvKW+tETpZeIHtT5fBiZbwd7Q4xwy1QKd6tMHH/zLrK3ST341pyegMPZe24eoxw9c/3Y5qWroa+JuXHYtP91Q+0pHHzRt817ZK4ZDV77Y8B/xuU0qByaHszmEQJAxPQAd6zHgsLUHVWjBDpLXpuMR56fqJjGKn1kHFyeKqbeIe8ol2lgTk+9EwZX9MWEAb4PaFPaUZqAXb7Xg5WQKQgf0sgLXCp1QWIfZoyYPuAHhgJJwEVkrm7I5eXdX5n0Gym+YZjb6nB8/EByoRx1sRu0Uf84BwO2UuBGaGUkqQnr9ucX26n7Z6S2s8DmTfb4jMSXdA/QZoVzYHGlBImCcI5NVTaQwEt0mIOb2F417h/ZONWaFkZl9mPGCp7/1NQac89YMXl37ltT0w2OMtjUH2ioa4+BCuJ6Y10WXGFEBmOM7NBkt2UAo+HF/D+xKEaUnSx4ZKop/4F0ipit4DgH/Qxvf2WwgKTqhp7BHXFbj5My77699yzgO1j+O5Viy5nAVT4OCGYaQMtWYmDojzJ4F3pCmVnPuhEyYcuJoJURBN7NKd6B6a3ZipEYOPzXD/C3IOfBr2EJdipW+qICi8jfR3OHhRc9PuG/qKXlB45ljahXbiJOERiyLl909Qk0du15aCoVJMxG8Yk92BHJv3rcY/MfaP+hu9szQKxQjlKegewBoxogWUh9roBXkIbmZdFPgodSaFgXenHfE3KxgHqLfqie3b5Q
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199021)(36840700001)(40470700004)(46966006)(5660300002)(7416002)(54906003)(478600001)(966005)(41300700001)(8676002)(7696005)(6916009)(6666004)(316002)(70586007)(4326008)(26005)(70206006)(8936002)(16526019)(186003)(47076005)(40460700003)(2616005)(4744005)(336012)(426003)(2906002)(36860700001)(82740400003)(7636003)(356005)(40480700001)(82310400005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 17:18:14.3867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad683c4e-ef97-47c8-e7e0-08db5d440626
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7441
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue 23 May 2023 at 18:16, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> Link to v4: https://lore.kernel.org/r/cover.1684825171.git.peilin.ye@bytedance.com/
> Link to v3 (incomplete): https://lore.kernel.org/r/cover.1684821877.git.peilin.ye@bytedance.com/
> Link to v2: https://lore.kernel.org/r/cover.1684796705.git.peilin.ye@bytedance.com/
> Link to v1: https://lore.kernel.org/r/cover.1683326865.git.peilin.ye@bytedance.com/
>
> Hi all,
>
> These are v5 fixes for ingress and clsact Qdiscs.  Please take another
> look at patch 1, 2 and 6, thanks!
>

Thanks again!

Reviewed-by: Vlad Buslov <vladbu@nvidia.com>

