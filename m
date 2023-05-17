Return-Path: <netdev+bounces-3247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC19706357
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 016551C20E16
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D6B5253;
	Wed, 17 May 2023 08:52:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAFA3D62
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:52:18 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2087.outbound.protection.outlook.com [40.107.96.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979251FEC;
	Wed, 17 May 2023 01:52:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4SFenk+1V+m+W/H5Uap/LcX2WU3ciN/6eH2jYzEWZa23wS/DAgU9R1BNSwyRXZVE/VrNo/EbwYMHz7A9+dNiXsO7GP6a14e+jqLNJbYsw33qEdpkExrfHua9N+z9smjuJngZvpfiBMPWJCaNdPocHDohj8cb4H38IT40jApVmgrcwrcP5lSBJTRPHCB6JfFLCshDjK4QDBRIlPFkbwEchIzCDkPwjDKSpvMWex7zppXDW9iQ6EWOQmAql9XDOwkwxCy+EbK9PTh3ZHhBHNWq3T+SuJvvLnIKw5OG+XEa42pbBoa2z5jyx4zEwUBm6E+Fu0htEeIS1AkTOtm3/K49g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwcRntYmYbW3mAzt8iDXDUEcE4tF72xVmuNhGy5xH8E=;
 b=N+A5aaT7Wjr3ytcFiWRvBw+st+AXflMo5qKeNYhvasrnTXsItabvRz87/tjwcLsJ2EHODvEzpEkMn+uBzH9ypIGk87XR3tJLUSG1HF7hRKZSM/b48c9DQQszwXuQ5DtQOuCH3trr1MVBsWuPHpKTyvmqgAUUCfMlbimf5mxdY47HDmungHRPLl3lWQBuiFIV6uMJQunIdSwvYsxksbJ9esfkHzpyqfwqKF8TTROcyQ52vSpfPOn5U6/H5Es8m38fSUtT/sw1aIPa5WBfxLi8eSk2vWWYrmVP3m9Mr5NhTTYuJbREnrt/xRb7WERB68UpPgg8fFmqgi+QMe45x02G7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwcRntYmYbW3mAzt8iDXDUEcE4tF72xVmuNhGy5xH8E=;
 b=rlMqBB+20ST1iyxPYTb2kpcY9Tao5pINbEEBWeOSA36R7kWWyJBIwY4OccNx7kPL2K74jkNqbT0F+pr9AYv0692b1SsY+4MvQImvifdSQjbrp1xSzgGtV2djcj4t2dEO2RutOM/zwj4WBcIhDyajTEjWw0Pia9WUTCjSAbV4FOrNwXm1c//r7GvDqheLnaqs59pT1F4d3Mq2YrE3uQGQYCK7LpnUz8yhbexP7iTWW36Q0O9MyswGj3v8669KDUFREqUBX9gkScPDl7jSa4Kh7U/jf++HaP5jUAwOK4VNwCQzbwREXnkNAwhY3SgZi2GM+YTukloSVodwafIMsE1nQA==
Received: from DS7PR06CA0017.namprd06.prod.outlook.com (2603:10b6:8:2a::24) by
 PH7PR12MB5879.namprd12.prod.outlook.com (2603:10b6:510:1d7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.33; Wed, 17 May 2023 08:52:13 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::f4) by DS7PR06CA0017.outlook.office365.com
 (2603:10b6:8:2a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33 via Frontend
 Transport; Wed, 17 May 2023 08:52:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17 via Frontend Transport; Wed, 17 May 2023 08:52:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 17 May 2023
 01:51:56 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 17 May
 2023 01:51:52 -0700
References: <ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
 <20230510161559.2767b27a@kernel.org>
 <ZF1SqomxfPNfccrt@C02FL77VMD6R.googleapis.com>
 <20230511162023.3651970b@kernel.org>
 <ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
 <ZF2EK3I2GDB5rZsM@C02FL77VMD6R.googleapis.com>
 <ZGK1+3CJOQucl+Jw@C02FL77VMD6R.googleapis.com>
 <20230516122205.6f198c3e@kernel.org> <87y1lojbus.fsf@nvidia.com>
 <20230516145010.67a7fa67@kernel.org>
 <ZGQKpuRujwFTyzgJ@C02FL77VMD6R.googleapis.com>
 <20230516173902.17745bd2@kernel.org>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Peilin Ye <yepeilin.cs@gmail.com>, Jiri Pirko <jiri@resnulli.us>, "Daniel
 Borkmann" <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Jamal
 Hadi Salim" <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, "Peilin
 Ye" <peilin.ye@bytedance.com>, John Fastabend <john.fastabend@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Cong Wang
	<cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Date: Wed, 17 May 2023 11:49:10 +0300
In-Reply-To: <20230516173902.17745bd2@kernel.org>
Message-ID: <87ttwbjq6y.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT042:EE_|PH7PR12MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: 822c5512-2fd1-4afd-b6fd-08db56b401ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BWu59jL3eC+40AXEdu01MHidPF+JD7xeo7fLQPOfRxvShfAjsSYPpcGFjWrTJBBxx1u3mYv2eB+yoAIo8sCKj8K+bBrJpKbXjv56bdNiZZl1HHeUE7kRTCcjsmR2e7vEERtEYPywzpZYt7vWsn/Yz3YhNVaF5qykBceSK/GKEJ3px0Og8zwDvEFMPS0AlPENp1GWsjth35P9CL8mWGc4Y0qy9twptXjutdSgrybhEvZ5s4gVd2byVLob8MdGAh5bTIQc41hcMjuS+ev0urJ8JtsxEZDjGZvH7yPX6xWAvm2c68lzz3HhLHJlhQ1SVPSx7FmgJTq8/RJjgPAx1LGo+GyqEyYrci2i21gwdhJvI4RV0F0EpK/hBiRaFy4HKucGE4tZPZgcDKkTfNCWy6F0iZTS7rD9yRKLZMjl+iDEU8wNCRAywYFt4sGhBLsecRjvSnJBcZURL2xxXrjDCKIPMFlu0bOthtUznqq22IUo6Xe+YLsYAmB99ts7vQ2uAQK/Cxd1g1o0nKKZlQqgU4nzd43aYDf2uGKpDTNf05VrH3ZBZgmO62OUVOOkxy+wmwcXnZ8Dc4984RPhjIo++bW/0C6hxXQAofVS792Z0uvNU1pzh49NMDngJh4oVtjNpemmkq/cj95uI3ULQdZPJPJA0VSwbOfj2HFV9qUY5fLHyzjA9J7In5G84DCWuBXfMBCHoLDajLdDz+hWWvU3NN/cOvGx+EoLwh1/J0tpwrgxOpw1ZYw9EJJ39ZEaR1YzrRgr
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(70586007)(4326008)(478600001)(6916009)(70206006)(316002)(54906003)(86362001)(36756003)(7696005)(47076005)(83380400001)(36860700001)(426003)(336012)(2616005)(16526019)(26005)(186003)(5660300002)(41300700001)(8936002)(7416002)(4744005)(2906002)(8676002)(40480700001)(6666004)(82310400005)(7636003)(82740400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 08:52:12.9132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 822c5512-2fd1-4afd-b6fd-08db56b401ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5879
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue 16 May 2023 at 17:39, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 16 May 2023 15:58:46 -0700 Peilin Ye wrote:
>> > Given Peilin's investigation I think fix without changing core may
>> > indeed be hard. I'm not sure if returning -EBUSY when qdisc refcnt
>> > is elevated will be appreciated by the users, do we already have
>> > similar behavior in other parts of TC?  
>> 
>> Seems like trying to delete an "in-use" cls_u32 filter returns -EBUSY
>
> I meant -EBUSY due to a race (another operation being in flight).
> I think that's different.

I wonder if somehow leveraging existing tc_modify_qdisc() 'replay'
functionality instead of returning error to the user would be a better
approach? Currently the function is replayed when qdisc_create() returns
EAGAIN. It should be trivial to do the same for qdisc_graft() result.


