Return-Path: <netdev+bounces-12062-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5DB735D9A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFABA1C209DC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F4013AE9;
	Mon, 19 Jun 2023 18:56:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCA0D53B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 18:56:28 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378C7130
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:56:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hygg34iEEPPcaUdGh5DrNxDeoxNor4hc/kgq5qNyY9qAymEpsYWLJk8RzbGMk1oJUfoSjZEi7uyREXm3wam+F3Q1rIGN7o+rAe3WrrcGIJHlqs6ikgzO5syQ2EAJt33fckV1RY0gJUJHqFHSV3/Wc+lFA54rzaeJATY6SCBrF+VgqWHe/eZ42g9AcfW7pLwM2N/ANX5iQ4z+yNRFLv6svZBRvaJ8ZQ6yiY0vo9UotaXpq/fDrVTM0qfftXz74GLgDqqr13Hcys/Vu19WcoByvc8UOaQQyyVNsvRzdAv8opCOaEaNsDzwvPDdWT1s9HIpJJ6zfUA4O5qoBdZjjg5PaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2tM46YJajpZZWc1ZxI/w7AwvO1R1FBDcYIKgvMdCxkM=;
 b=R+QjSRN9xKJFIM7bhVGMsdTZrp1OKfc1Hff0OHd0X5rECSECR8ah8PbaXRGRJsOP4/fCvtDcz6/9/FHihHgHKadvTKSw7oeyZNmOt9qEcDuVuFBUZbHUIA5Vc5wbitMioNRGDcxBCvEPL7II7J7Y6q2Cumj6sePoghXPzsSUBjcoSS1mJgvDfk43kBLokdXTXmmP8PDzqDPVtRZM7L895LKGtj/by49RxHf7k6nU6Tei2Ny+djtOoO1DX05miYlGcsAY6urW70G9/h+N5g89gGZVdvbzcbfx0knGquUs/jP3M+8EX4ypEF8O11jtLIWw4yI5flwUY0FE4vHFct5EUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tM46YJajpZZWc1ZxI/w7AwvO1R1FBDcYIKgvMdCxkM=;
 b=QZWlqL9iKQdkuRICwJR/TxQbyX7p4yAZay9fcmfDID1bf5FyVNIZ6uVOgs56bIxRpLWCqKkZdYolt8gocW9l2h9B1i9sx9Cg0CZ7/DJfSf/fZoxmcYayGQ+MqY/Gv94yM6oXMdwCxnVLgxroruYsMrCZuP5j3PipfxDp0QR0QEHTvi/bT1RtaFtd/CZk3PN8oPqhrVN67/3Mh5A72KtiR7FuF1P3TbT2258Wp4pjdtDlOv+u7whUlklfQ92j9CjE57wTi+rDzipDRYzILyetMjp0p5moIW5IrQ7dzNNmAKcUEgYfAP8Q2ANjcCqCcep+3E+zu9zcjpk4BlEcHiFYuQ==
Received: from DM6PR12CA0013.namprd12.prod.outlook.com (2603:10b6:5:1c0::26)
 by DS7PR12MB8231.namprd12.prod.outlook.com (2603:10b6:8:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 18:56:25 +0000
Received: from DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::a5) by DM6PR12CA0013.outlook.office365.com
 (2603:10b6:5:1c0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Mon, 19 Jun 2023 18:56:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT087.mail.protection.outlook.com (10.13.172.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Mon, 19 Jun 2023 18:56:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 19 Jun 2023
 11:56:09 -0700
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 19 Jun
 2023 11:56:06 -0700
References: <20230616201113.45510-1-saeed@kernel.org>
 <20230616201113.45510-8-saeed@kernel.org>
 <20230617004811.46a432a4@kernel.org> <87v8fjvnhq.fsf@nvidia.com>
 <20230619112849.06252444@kernel.org>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
	<edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
	<netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Gal Pressman
	<gal@nvidia.com>
Subject: Re: [net-next 07/15] net/mlx5: Bridge, expose FDB state via debugfs
Date: Mon, 19 Jun 2023 21:34:02 +0300
In-Reply-To: <20230619112849.06252444@kernel.org>
Message-ID: <87r0q7uvqz.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT087:EE_|DS7PR12MB8231:EE_
X-MS-Office365-Filtering-Correlation-Id: c26c2434-aff8-4a46-a206-08db70f6e18b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l1zPCeeyrY/xrM+Ult49t83gDWwJ+rxIB/WcX1kFx4wRGw6qy4HbS41ft7/CZmYTeEzWHEOL+QXTY0++BCob8iKcMQtK5ETl4+wWDLtiOI/hdqvM6M+5FN88HzQZrkRfu8tJVfmWpwog/nx7etaR0JBdBDsMo7+4KuxWW+y6xnawTrVLMCfI2Ec4Bcg3WjZPGvuOVgPFfP9AQb7W2f+JU4vUi8+827FRl1WJHVpQ0eh3ujT7NgLze29qPJSSlCoht5hKJ4zEpR9K6L6bpGlLvWjorZsqTgBpm27fgVm5aS02hAgCw6+oTuZ4/ZHZzwCSG7nWo/INGlTJGqCXzFRWtBABYElIVciQjMkeT8w7TEHJD2MxRNXiQh205UwyzmTzwj+iRQomgvXoBDZs4mgiVmMdJEd6h+krvF7sK+bN9hC6X59WquwP/bHBSn8LVPFJq7ZCyFCbhc1xh5CJnEef7yxaj3BdPuSFPGzc7QmASmk+0xSewoWgjQVLhUSs0Mju5iedKh1s2GW2c3pLEqlr5AfZTGkJgs9sLqpn8fuypSJjY98hdN9GPqOzGMeCL9e990hbq79Vf3lU1URl9GSGYOhH5hWTp+F5HazquAJutOubbm6OfoMJnjPZtUerrUqguRihNwqUYj5u4tr4Xa0AKk1ThGssn+YnS0H7E/2u2g4y6otmHyPPBxGmHEE+KySemGgdCT3Yf6vSN5PLx2lHkITs7b8bQS4bZVGvLQiBYtSBjl4OrVi3dDJMmImZX6LK
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(36840700001)(40470700004)(46966006)(5660300002)(8936002)(8676002)(316002)(4326008)(70206006)(70586007)(82310400005)(6916009)(41300700001)(40480700001)(86362001)(40460700003)(2906002)(66899021)(36756003)(7696005)(16526019)(6666004)(336012)(426003)(2616005)(26005)(107886003)(186003)(356005)(36860700001)(7636003)(83380400001)(478600001)(82740400003)(54906003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 18:56:24.9785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c26c2434-aff8-4a46-a206-08db70f6e18b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8231
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Mon 19 Jun 2023 at 11:28, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 19 Jun 2023 11:37:30 +0300 Vlad Buslov wrote:
>> On Sat 17 Jun 2023 at 00:48, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Fri, 16 Jun 2023 13:11:05 -0700 Saeed Mahameed wrote:  
>> >> $ cat mlx5/0000\:08\:00.0/esw/bridge/bridge1/fdb
>> >> DEV              MAC               VLAN              PACKETS                BYTES              LASTUSE FLAGS
>> >> enp8s0f0_1       e4:0a:05:08:00:06    2                    2                  204           4295567112   0x0
>> >> enp8s0f0_0       e4:0a:05:08:00:03    2                    3                  278           4295567112   0x0  
>> >
>> > The flags here are the only thing that's mlx5 specific?  
>> 
>> Not exactly. This debugfs exposes the state of our bridge offload layer.
>> For example, when VF representors from different eswitches are added to
>> the same bridge every FDB entry on such bridge will have multiple
>> underlying offloaded steering rules (one per eswitch instance connected
>> to the bridge). User will observe the entries in all connected 'fdb'
>> debugfs' (all except the 'main' entry will have flag
>> MLX5_ESW_BRIDGE_FLAG_PEER set) and their corresponding counters will
>> increment only on the eswitch instance that is actually processing the
>> packets, which depends on the mode (when bonding device is added to the
>> bridge in single FDB LAG mode all traffic appears on eswitch 0, without
>> it the the traffic is on the eswitch of parent uplink of the VF). I
>> understand that this is rather convoluted but this is exactly why we are
>> going with debugfs.
>> 
>> > Why not add an API for dumping this kind of stats that other drivers
>> > can reuse?  
>> 
>> As explained in previous paragraph we would like to expose internal mlx5
>> bridge layer for debug purposes, not to design generic bridge FDB
>> counter interface. Also, the debugging needs of our implementation may
>> not correspond to other drivers because we don't have a 'hardware
>> switch' on our NIC, so we do things like learning and ageing in
>> software, and have to deal with multiple possible mode of operations
>> (single FDB vs merged eswitch from previous example, etc.).
>
> Looks like my pw-bot shenanigans backfired / crashed, patches didn't
> get marked as Changes Requested and Dave applied the series :S
>
> I understand the motivation but the information is easy enough to
> understand to potentially tempt a user to start depending on it for
> production needs. Then another vendor may get asked to implement
> similar but not exactly the same set of stats etc. etc.

That could happen (although consider that bridge offload functionality
significantly predates mlx5 implementation and apparently no one really
needed that until now), but such API would supplement, not replace the
debugfs since we would like to have per-eswitch FDB state exposed
together with our internal flags and everything as explained in my
previous email.

>
> Do you have customer who will need this?

Yes. But strictly for debugging (by human), not for building some
proprietary weird user-space switch-controller application that would
query this in normal mode of operation, if I understand your concern
correctly.

>
> At the very least please follow up to make the files readable to only
> root. Normal users should never look at debugfs IMO.

Hmm, all other debugfs' in mlx5 that I tend to use for switching-related
functionality debugging seems to be 0444 (lag, steering, tc hairpin).
Why would this one be any different?


