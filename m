Return-Path: <netdev+bounces-12067-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7955E735DDE
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83DE8280FDC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946DC1429A;
	Mon, 19 Jun 2023 19:34:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FFCD53B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 19:34:07 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E9E106
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7ur7mC66E5svFzsIymfV3C1XmobkomdlAr68xRXkNvRL1/VgMRlMDzGjHBO1Xgmyb4CALrwzTJyphiwySvDuCWls7aQEQ9Ph7jMNBVdMUx7zzF6v8szTpnGYXyd12oWzoeHb8V+eDu3QWWyv1FcxIHa8iE2vsz/vfwXwdN9AgmJzxkVeUpDPjRWMo4r4MricW0JfJDujuJzedgDe4DGgjH1ipTm6HySzHC3cjac+g3bAXhvfUY8n1Alf+wFpLzunce6MHTRlJyQoyj/1u6UlIZ43vJkwmbH2wwSV6d+VYmTnihw5KKRYV1BoempLB65fkueNp6tC64Miq3ImOBq4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5RzW3uTm5SwOTk+a6isvuOTVM3GFeKsjNKIx1jFVpB0=;
 b=cZHFqBo+0HDDyoMG1JItpzxe+jIXdOJnH9fGK9s5akhaSa/Nl02mafQWyxcODfc2QCp6a/Y2ZWr0JInhRpAp0jknDaZjD9Os7oImShzMNmB4OSDitgj/kz7ztwokENRG6rCDU5ulDdXpX7qBVcetlMblCnAWt4cL3dTWzirksx7Jne97Gpz1Gf+/010uVf59t5xu5ILkRlAnGdYkQne36wjmiXUdsOsSMIyz60amkJHUHuxN8GkbMa8kuTZYM29Uvxp+Kdq5tQ/uU3f/zgcvgkA4Zngm5CZQ397R+QqcLubF9quSjw620t87k8L62n9b/guTsuovlvg0Nhc0b0WS7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RzW3uTm5SwOTk+a6isvuOTVM3GFeKsjNKIx1jFVpB0=;
 b=FtE1e/TWhaNhJMnuxoOKyoDTYfkAhI0b6FPpDXDsf1Z/u2eZ4lI9YBqfeHNlzPN0kjEpupWmiX/u17KUvjy/xDOolBkm4ls+xfjEfhk3JgidtSbDXsru0toUN2Dk065N/C62hBRVH9y468nAcTRmW/zh04I+y6mGs5AMO5XwuSL2WuACI5s36VPPHCnH6cfQj4EY+jk7UKsxYes+nmIRW/pj7wP7YomFWLdgqOvXRz4VJNE4/thHinIXANC9hrheJijod+lVt6XpzixfB0QHjdqWrZ6cdNftO9rrdGFYPSEKjns51zk8rC131lIpfBbPtAfhKjwgZbFREu4ok0yu9A==
Received: from SA1P222CA0184.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::29)
 by DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.36; Mon, 19 Jun 2023 19:34:02 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:806:3c4:cafe::ce) by SA1P222CA0184.outlook.office365.com
 (2603:10b6:806:3c4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.44 via Frontend
 Transport; Mon, 19 Jun 2023 19:33:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.27 via Frontend Transport; Mon, 19 Jun 2023 19:34:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 19 Jun 2023
 12:34:01 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 19 Jun
 2023 12:33:59 -0700
References: <20230616201113.45510-1-saeed@kernel.org>
 <20230616201113.45510-8-saeed@kernel.org>
 <20230617004811.46a432a4@kernel.org> <87v8fjvnhq.fsf@nvidia.com>
 <20230619112849.06252444@kernel.org> <87r0q7uvqz.fsf@nvidia.com>
 <20230619120515.5045132a@kernel.org>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
	<edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
	<netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Gal Pressman
	<gal@nvidia.com>
Subject: Re: [net-next 07/15] net/mlx5: Bridge, expose FDB state via debugfs
Date: Mon, 19 Jun 2023 22:13:07 +0300
In-Reply-To: <20230619120515.5045132a@kernel.org>
Message-ID: <87mt0vutzv.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|DM8PR12MB5445:EE_
X-MS-Office365-Filtering-Correlation-Id: cc9805c6-a9da-4cec-08d1-08db70fc22f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LMcDhKiNnftj+WXk6UlZPMVe4kxUtPM8uXpnyaOeN+gMCEXIeF68C0VadZ0Gvfvxu0htWsm6+LMpGvRDUwDLfv1s4KQktt+bjiPT6J51RhTMv90shxZ7WFLzvr4mSzkPzuOerO1hHPic2x+ORaaa2qYYA2STOpwuvH8oT2MOUXAIAr5q0zIe3OTerTetd2bY2xYLN1rq9FQwNsw/aZc+SrER5b+AZoWsYEMK2HGWTnzxaO3ZCCk7W9ZkesIyrGT5rMSwG4sOcrfdE7FG+ow6jHeNxCzfuawBsrxkxJvJguQCqewS+bMn3d6ZFEVOcWV/82x4hZnHOpn5X28Owmpyc50YmC71lqKaiNS9cxn5tKs9/qgLSJ11fpmf1GLqtRJKs/SzOR2X1q6giez0PDR5WF+yoNSRzqFE79v/Fr7DVszT0Qkphm96bh83/6YofkpqS/Z5YTSM+HZxrpS7KHue6BbY8+J2KL+OG6QNCS6YAzYtK8OVcZYtOSPwr7h48K5dsb4Ux3I3ParLRBTITaVzhHO47ZrACa60Thu9OGcrWFVo8Sm+MRTV5Syrn29ZR+R6BrfbsD6MynSDeE63RpgLxbhEb/PHNQaafqdB7eL0rXNyInCgIRK5y+xR8EUKjEFHkh9v0KTy4X7YKFgIBDUtwSFyku4Co/QfhTlEyhaHDHIgoUPUXgsMEn1icm+pc6g7GJ0pCLKQ0hG6h2r9uH67aORc8EhgDUBUg+a1GaWdAelSAr8qgPErVLQndedwAe1s
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199021)(40470700004)(36840700001)(46966006)(478600001)(70206006)(70586007)(6916009)(36756003)(8676002)(4326008)(41300700001)(7636003)(47076005)(356005)(40480700001)(2616005)(426003)(83380400001)(336012)(82310400005)(86362001)(7696005)(5660300002)(2906002)(54906003)(316002)(8936002)(6666004)(40460700003)(26005)(186003)(16526019)(107886003)(82740400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 19:34:02.2269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9805c6-a9da-4cec-08d1-08db70fc22f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5445
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Mon 19 Jun 2023 at 12:05, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 19 Jun 2023 21:34:02 +0300 Vlad Buslov wrote:
>> > Looks like my pw-bot shenanigans backfired / crashed, patches didn't
>> > get marked as Changes Requested and Dave applied the series :S
>> >
>> > I understand the motivation but the information is easy enough to
>> > understand to potentially tempt a user to start depending on it for
>> > production needs. Then another vendor may get asked to implement
>> > similar but not exactly the same set of stats etc. etc.  
>> 
>> That could happen (although consider that bridge offload functionality
>> significantly predates mlx5 implementation and apparently no one really
>> needed that until now), but such API would supplement, not replace the
>> debugfs since we would like to have per-eswitch FDB state exposed
>> together with our internal flags and everything as explained in my
>> previous email.
>
> Because crossing between eswitches incurs additional cost?

It is not about performance. I install multiple steering rules (one per
eswitch), I would like to understand which one is processing the packets
when something goes wrong (main or peer). User/field engineer complains
that some FDB is (not) aged out according to the expectations, I would
like them to dump the file several times while running traffic to see
how the lastused and counters changed during that. Just the basic
debugging stuff because, again, ConnectX doesn't implement 802.1D in
hardware so all the FDB management is done purely in software and we
need a way to expose the state.

>
>> > Do you have customer who will need this?  
>> 
>> Yes. But strictly for debugging (by human), not for building some
>> proprietary weird user-space switch-controller application that would
>> query this in normal mode of operation, if I understand your concern
>> correctly.
>> 
>> > At the very least please follow up to make the files readable to only
>> > root. Normal users should never look at debugfs IMO.  
>> 
>> Hmm, all other debugfs' in mlx5 that I tend to use for switching-related
>> functionality debugging seems to be 0444 (lag, steering, tc hairpin).
>> Why would this one be any different?
>
> Querying the stats seems generally useful, so I'd like to narrow down
> the access as much as possible. This way if the usage spreads we'll hear
> complaints and can go back to creating a more appropriate API.

Ack.


