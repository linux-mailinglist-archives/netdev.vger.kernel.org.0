Return-Path: <netdev+bounces-10136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 394FF72C7DF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:15:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABECD281139
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06AA91B8F0;
	Mon, 12 Jun 2023 14:15:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75C11C740
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:15:45 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA1A3AB5
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdMXmnAArh0DzB0r8p7mc+GU6umEQxq26eMEWGFJRWK4Khe92CS8JMQpHPPHd8e5qZPzg4mBWGi1U7aiH84tSnx9vdNtOS9ehNnpph/kdfw9l/1Ao9ydzglkTCQZkaCec0p1ijl8WDRzSgEb73tk3JyNpU46zjq5Mqy0/9xngQQsJNWbQSoLmB4B5n1l5AN+OjePG+L+P8btX1ew95rsTDQcwlJj7g0tMhk5xaAbG7wMnN94O5mR3HnEeU0yBr5xO0F5pZudHbb/Kj5pT22PsN174batLpYQz4rlQyBzwG0daKgPRtueHLgGftbPiYL3fq9YVRRP6p2oAxlZS9G5Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ejuXaxyi+854zZloeEKk5k39px7oNeU72oiaX2dxas=;
 b=fvaZlZ74VzpOdZeMsT6irvoTMQ15ROIUvbWtFRTxupRh2VS7z0ctmVaIpKRGHJOPDvj0mwHE9wXQUbewNpUkNVQenc7G+erPwfDHz1Ln3pvBfB+1fBA7OPaMeVa18Z71tmcF788ECZjQLgoBoLlwzE2konbrzvb7mr/HBuInQ8/gonsN1+woZYhE1CPPrAlzjGUHAviKyFGKTrtqTOH7MZhGrjnf2eJCL5X6+2yt8ECIKoMyU0jPPjdq9qxChR3Tgsv3XwBPNFH9apqlSy7UjwIiH1+C+ku7QvYctXFg2H11sN07Gq3q5ulHtVD1IApxjjYOdZ3oaTALWzp9glrUBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ejuXaxyi+854zZloeEKk5k39px7oNeU72oiaX2dxas=;
 b=Gybs7FUgl1UI52Ahel1DuREzH11+ckleLGzNR/cvd/cqs3jY4dJ44quLNjUIAsRwaDGajAxRZfT6XNauCtZnsy+OemSmQlTVXjDz+4NfNhMcRBvkqP2R/UjBllhYek92lwf16eO3gmRPLZta6N9lXSligY62fDdxRPRj14mk0UNgEJ02dZkzW8dk5qOaibxegaG7hVMHaZdZaAczAY5fsMIPID9hHD6y3YNl1M18FVhOWm3Hk9Sauhh6R/kFcUaNE8/6N/Ot+m5GCElhBrOtgcNA1B1hL3bEApLNBTWdjToY0qJKMoo6OTNtge9st6QKVgMX3k4ry0DokSOBZw4Jrg==
Received: from SJ0PR05CA0084.namprd05.prod.outlook.com (2603:10b6:a03:332::29)
 by IA1PR12MB6601.namprd12.prod.outlook.com (2603:10b6:208:3a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 14:14:51 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:332:cafe::66) by SJ0PR05CA0084.outlook.office365.com
 (2603:10b6:a03:332::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.22 via Frontend
 Transport; Mon, 12 Jun 2023 14:14:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 14:14:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 07:14:37 -0700
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 12 Jun
 2023 07:14:33 -0700
References: <20230612093426.2867183-1-vladbu@nvidia.com>
 <bf500fa8-b835-b697-7fa6-d9087219fa35@mojatatu.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Pedro Tammela <pctammela@mojatatu.com>
CC: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<renmingshuai@huawei.com>, <netdev@vger.kernel.org>, <liaichun@huawei.com>,
	<caowangbao@huawei.com>, <yanan@huawei.com>, <liubo335@huawei.com>,
	<simon.horman@corigine.com>
Subject: Re: [PATCH net] net/sched: cls_api: Fix lockup on flushing
 explicitly created chain
Date: Mon, 12 Jun 2023 17:07:47 +0300
In-Reply-To: <bf500fa8-b835-b697-7fa6-d9087219fa35@mojatatu.com>
Message-ID: <87cz20wywo.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|IA1PR12MB6601:EE_
X-MS-Office365-Filtering-Correlation-Id: e68f112f-91b7-4673-fa71-08db6b4f61cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ztSIz26rjeJrbq/HBbRsokZZV6rnhMziHltbJ6S5RKMterJnrIjARKVPSrOWO/tNIYNkdDY0T8X+Wmtt110FnKpbQJkU1YSBoX4ZuPLZUEFv+ulAiD9ksSfMcwtS3aSSGN03EKkWLG19uQmtdrcUFHofBSpDvnIYN8bLYb1Nuk5f4OPQQDwolB+k5HBkf/jMvlFxS53NUuUfi8CIFUJbrRn6TWSBZbMMEeWpbLHKzvc6IjblQP0/0cwkB7hfKy1Jqzq/G8ZT7kFzGsgNPuC1nOc0YONoXZ3kSVor6LdudOd8t5RqjqPfBpcmn+rDV1yu3qIzknfi2zzx80NF5yp0AtqZYKnHlrDoNMu76jvtdIHm7o9vUhB1g+E1UPnCaaZyMmdFCgR0tOX9wYdQrS0f3IgudGNcDNw+Q7oNJD8PvCopq77E06OPAgIp8xYAHIiNAE9fRS4yo9Bq6uD+e1B9bnK5ZrJXbcgXQtzJx+SoN7v5JucQZ7uwVl0AQFLwLvyTH/Z5uxzC8ct2uIS66jf7Id3K0Od4cdq3KFm3QoP41TXTNFjtz2Abc2XUpUVrcseErZSTOV2gSPeBpiZkhK3tPiZU8O08HlMcIRxtWq9BLp7VOLDpefPy0EBWH/JNG5dTI7JUgFTNb045fbhAjCUSj8yj3MMwRrJr36BohvnScTAZBkBr9hSNzDHV0ZSsON7ztwjLafDfD7dd5g7nj6UdEVQVoKN22nc5IY1Ocp9a9QA0Ekj/tiV/gwRHWoDzdg1sTYWDYZK9YuYQnSt3PuHrs2agDMpA6hlEK5ngiuPqs70=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199021)(36840700001)(46966006)(40470700004)(54906003)(5660300002)(6916009)(4326008)(7416002)(8936002)(8676002)(41300700001)(316002)(2906002)(186003)(16526019)(478600001)(70206006)(70586007)(6666004)(966005)(7696005)(40460700003)(53546011)(82740400003)(356005)(7636003)(40480700001)(26005)(83380400001)(336012)(426003)(47076005)(36756003)(36860700001)(86362001)(82310400005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 14:14:48.9465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e68f112f-91b7-4673-fa71-08db6b4f61cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6601
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Mon 12 Jun 2023 at 10:59, Pedro Tammela <pctammela@mojatatu.com> wrote:
> On 12/06/2023 06:34, Vlad Buslov wrote:
>> Mingshuai Ren reports:
>> When a new chain is added by using tc, one soft lockup alarm will be
>>   generated after delete the prio 0 filter of the chain. To reproduce
>>   the problem, perform the following steps:
>> (1) tc qdisc add dev eth0 root handle 1: htb default 1
>> (2) tc chain add dev eth0
>> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
>> (4) tc filter add dev eth0 chain 0 parent 1:
>> Fix the issue by accounting for additional reference to chains that are
>> explicitly created by RTM_NEWCHAIN message as opposed to implicitly by
>> RTM_NEWTFILTER message.
>> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during
>> chain flush")
>> Reported-by: Mingshuai Ren <renmingshuai@huawei.com>
>> Closes: https://lore.kernel.org/lkml/87legswvi3.fsf@nvidia.com/T/
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>>   net/sched/cls_api.c | 12 +++++++-----
>>   1 file changed, 7 insertions(+), 5 deletions(-)
>
>
> Hi Vlad,
>
> Thanks for taking a look.
> Could you also carry over the tdc test or ask Ren to post in a separate patch?

Sure. I was planning to ask Mingshuai Ren to submit the new test as
standalone patch after my fix has been accepted since including his code
with my fix would require explicit approval of the whole patch and his
Signed-off-by clause AFAIK.

>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 2621550bfddc..e4df96e133cd 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -659,8 +659,8 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
>>   {
>>   	struct tcf_block *block = chain->block;
>>   	const struct tcf_proto_ops *tmplt_ops;
>> +	unsigned int refcnt, non_act_refcnt;
>>   	bool free_block = false;
>> -	unsigned int refcnt;
>>   	void *tmplt_priv;
>>     	mutex_lock(&block->lock);
>> @@ -680,13 +680,15 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
>>   	 * save these to temporary variables.
>>   	 */
>>   	refcnt = --chain->refcnt;
>> +	non_act_refcnt = refcnt - chain->action_refcnt;
>>   	tmplt_ops = chain->tmplt_ops;
>>   	tmplt_priv = chain->tmplt_priv;
>>   -	/* The last dropped non-action reference will trigger notification. */
>> -	if (refcnt - chain->action_refcnt == 0 && !by_act) {
>> -		tc_chain_notify_delete(tmplt_ops, tmplt_priv, chain->index,
>> -				       block, NULL, 0, 0, false);
>> +	if (non_act_refcnt == chain->explicitly_created && !by_act) {
>> +		if (non_act_refcnt == 0)
>> +			tc_chain_notify_delete(tmplt_ops, tmplt_priv,
>> +					       chain->index, block, NULL, 0, 0,
>> +					       false);
>>   		/* Last reference to chain, no need to lock. */
>>   		chain->flushing = false;
>>   	}


