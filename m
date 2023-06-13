Return-Path: <netdev+bounces-10431-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C32172E6CF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 526202808BF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518593AE76;
	Tue, 13 Jun 2023 15:14:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EBB23DB;
	Tue, 13 Jun 2023 15:14:41 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2105.outbound.protection.outlook.com [40.107.220.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9503CA;
	Tue, 13 Jun 2023 08:14:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKfRRpIQYukwahTcoducdtb4xSa1oJmBP6svMagdctiFiMPD9PUa38RgfT5I8uh5mftYO5m4iYKpUZFJwLQOkHYg64q4dNC4d0aftjlc/3+sk242O1h6BCjo6gkv628FZPoXmdSjWZZ0OXYuNqLHgi7Eml3UCIB4OvipG00dIO1hB3PIqit6bnA2FJ3U6Xsoma4o3WcIIln8NuZOcy+aNIndVhPYICcRI91yzHypELlNTp55WX7e1C0q/I+qGIbuDq3eG6d8rbpQt4JosJDkYFhaR97Rkzqu5D50WSV8gBrohSbhX3uqmH9NgjjIkk5sCtb3zcPxrIA49DQfjbSXcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbO0Fx2hG1vdOFk4OfcHmdmL1oA16bqnuUnSgZ8+8rA=;
 b=jU3eWJPf7dfLJ4lqmdylOgtThMLGxqgdbCgq6UJSnbNxAlimZpMjZGbksh+8ZI5fEW/C9HbsTKUJiajoRzYyU1JkuHSq7JwdkXuGjugHb0uOPB8bU9T04Kbr2qA5u2If/gTvcrcP+nFVEU1ZkAmFZIHIGcDKOHad54BwgAs95VMG/Kqx1UjZ8eXzmJyGUXoaugsxzoORzauAv1oslWPsYZKwwONFRN+410sGNg88BShbRMhJ3vNAVtHoU/7uLzWbcXn8W1BSyAEDciSCOd09vRRLe35Hxi4Ye9U3YybZqHT9kk1MDO9XO3ba/5ZUmFrd8HjD1XQV6j01Wcx7MwLTWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbO0Fx2hG1vdOFk4OfcHmdmL1oA16bqnuUnSgZ8+8rA=;
 b=Qu7Pybo6I95VX2YcdppnBV3b+rwdP3RIpq+3xVftpo5EcCiJj+Q66hRAMhL94gBrRxwWD8l+BEXOpc4fx1ebLxiMv/qRRBq4dwaxEdwjhyo1gtVCbuRL4FMMrUKDkEHbXt11TT42N8o3KH2IL11Tprri30zIDfM8G3op6NU9Kek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4955.namprd13.prod.outlook.com (2603:10b6:510:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 15:14:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 15:14:37 +0000
Date: Tue, 13 Jun 2023 17:14:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
	yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
	haoluo@google.com, jolsa@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 4/7] bpf: implement devtx timestamp kfunc
Message-ID: <ZIiH1n1QeFFmHuux@corigine.com>
References: <20230612172307.3923165-1-sdf@google.com>
 <20230612172307.3923165-5-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612172307.3923165-5-sdf@google.com>
X-ClientProxiedBy: AS4P251CA0023.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4955:EE_
X-MS-Office365-Filtering-Correlation-Id: 51dd93cb-d9ef-450e-fcbf-08db6c20e6f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	p28FWF805ju32BMzSCKs58x/avYIPZZUXA0au/jZdTEpL79OE6Iuxsj2Rx5bw/xnQQBE3OYWgLTvBW4/28+PLva7qDs6fxTg/CpZMFu9k93daxVqbHLkuTE3qxcvocCM7JIDoVFgkcZLEa8uKGvA3AgcvbcTx6QPSnJvylcN+A2TjmZ8atRsppWdDy6+0ma/ZXGNA+zsYdPErG2B/s7czs6v++ngGyl4l9PwVkw5/k9/ZIlUt9tG34+Nw3o2aIyqz9AIfMnnJue93v4QVnhFt6QV2TZlvnqzdp2Exw9tEITeYXu2oigrrLeoeeeoXKOjX6yEcNUIFvhha1+Fr/Dnqvo0CECuLolPl+yp07831Gx2I38f+HGwH/UB11jrVGB5Pwq2+jHpRgSOxsVWT4aOP/jZwLfkr/HIEsYlSSjJHQR9EdQvmEyhUJqsRfm03rjNFV2k6v2GWFzx1pCuQPfpnaSN/DCOE5XYdujq8pFd159Aw4hHvVT/BJynEK1jQKXK6H+EG16qB0u8zPZLNqPUxwcoPPBASH5xb5KP1B0qNkbh4QNUaQqOXPgjaE/7s/gd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(136003)(346002)(376002)(451199021)(6916009)(66946007)(4326008)(66556008)(36756003)(186003)(478600001)(2616005)(2906002)(4744005)(66476007)(8676002)(316002)(41300700001)(86362001)(6486002)(7416002)(6666004)(6506007)(8936002)(44832011)(5660300002)(38100700002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WYfrBDAki9RkLRDeBNizLA/N2H4b1bIbBVG5ULZnz/pYMbtjs6nWWGOdwSGr?=
 =?us-ascii?Q?DrJOvjwCAUW+6MjqvsC3zVyFfpMgTLbj0+5qyIt4praStwSObcwfPBfTtyD+?=
 =?us-ascii?Q?69pAYaO/dwXlV+hylhLZMkgbLYeuy9m5sYezvDvPi+4mMVbCl7SakswJ+ngm?=
 =?us-ascii?Q?90Eaaz5rIhAd/ZNSAV6RuiFDN646JhxHLwIqH4ioxYR/UP8trMSTuGEVAZKi?=
 =?us-ascii?Q?v9hDVIIh8hLoZgViblo00AtcO6PyUdrXrrX0PhpgIPGbUDs7HHRkRpBCiGsz?=
 =?us-ascii?Q?3HqIayVzEAtuTA8a6zmoIX6zc2h2n5eyfBBrEinHRJZPMfuvooYGHBkVbU+d?=
 =?us-ascii?Q?MrImHD1U4MXCdjlWk4IpD8uTuQC94vSfYbWRiRBpILXq44FmVLgHpYgAWyYd?=
 =?us-ascii?Q?4fhHAuIVy/EicIktUTED1l+Mo1COiZYtG0baZXUBVEtZt9YLQYIolaKQoL2L?=
 =?us-ascii?Q?5wTGUVvo4hDAPi9IGBHj6K4RiuOPGOcrE5dNXVSMHWnQuTM5l1uzp0N2EnqQ?=
 =?us-ascii?Q?16Xzqx9iCFKSU+rQ1AOSdQn7w7YmhV9282h88xkQTZ4cmvoDe5M0iFF1DFL7?=
 =?us-ascii?Q?mR+Nps/YFB1tzuGmiCMLzR4VBHFgJEQN0KdvPpLM0cPxrj6t80RQuqlL2Noa?=
 =?us-ascii?Q?HPgJXBu8YqBaqOIxCMtl4xW1wsN+tWvGGG7ProxzGXSNA4yAbKWLQRwECodK?=
 =?us-ascii?Q?CPMXBkHRVI9j9IWrRG2a7oHySrDVJl+CazBdH1D3mv5MgLHyMN+X72Ogxrhv?=
 =?us-ascii?Q?TbsdLZGOIOUEtq/3QTm+dmm3mTH8BqVYn4bweOLyKZrXwHM3n7fRVxmD7Jps?=
 =?us-ascii?Q?NBsipt10yrL54wd/RDLNqAVDcfBqRr3RUs9QNQBtWCSxdElClR2HDh6AF7AA?=
 =?us-ascii?Q?iIVfH0jAY2QhNDpe9uJEK/0vZJIaBKr5INxL6DSImlMAnKTQWLEcTi7w36yO?=
 =?us-ascii?Q?8pS8DTfFEA85Z3TguM+zdVR4h44iQzT2hTxPDVM88ITI1vKujZnL7fFuRN7B?=
 =?us-ascii?Q?7+QNz9DU1GmIt6OWWeAu8ebXGmTfi8L/VLhq9c4MFsQZOlt8qN5RQ1ZNEfEr?=
 =?us-ascii?Q?rp0BBdkeyexexceK/MUU5vKL4Cb362Q0GNp4vS5T+vA7Buv8zA1DPwIs41Gh?=
 =?us-ascii?Q?InKrhdEqu4xKkXUREtpqtoQIHe5MNHg4+NlE/DPOghP7SeauZtXu/QmevPd1?=
 =?us-ascii?Q?THOO71WwR57A7dExWmqnCAEmbUKLn4ow3kSQth5vHyjnvQiCDMD55V40rbbv?=
 =?us-ascii?Q?TriNZV8naQVNZpeESNtrVeKKBSvy6aUeW/rpYY86/Ve6zLnj0qYTO2YLzAoX?=
 =?us-ascii?Q?ToX4ZMxQKznc1Quf5/xaKIzQMQ/kYUZ1htlyTOMJjm04bpUEgQIQDWeP9/mI?=
 =?us-ascii?Q?SpMxY+DyNp27fIz3oPXeeQqdg6WBRka+6HjK2JYkAw6tiNQBgyBv/fMEc3Hm?=
 =?us-ascii?Q?cTD4qi09iMb6pIaI19mLtbhcT2/KDZ3q8Df67mLZhfwYCWmeuKjEP7c87fBr?=
 =?us-ascii?Q?nRjA/ritPEHdu8TBzfb6o9o3k7cfnvZ9gFGg40O1gNfqZgjTBq6fphgaeE0U?=
 =?us-ascii?Q?+QK4v0EAGmof35CLwL9vNDE+U0LADLv9GcIXn3O/F1yLHTIuAkd/+H1loaC6?=
 =?us-ascii?Q?HWmh1IQmXnSWZLEFwjO8cJIf+ExtfOa1a0BfJIXRMiyGH8ePJIiFXGOzvfrk?=
 =?us-ascii?Q?Py03SQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51dd93cb-d9ef-450e-fcbf-08db6c20e6f3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:14:37.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zt77HambXEwCK/b1i3vH6jmLXTusvyAuovBWjtYiK6nPnye9i0pM7/yebthL9L5NHJ8Ne1q3DUhiRgrA2ThdAAM56rcaJ0rls4ajSSXucw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4955
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:23:04AM -0700, Stanislav Fomichev wrote:

...

> +/**
> + * bpf_devtx_cp_timestamp - Read TX timestamp of the packet. Callable
> + * only from the devtx-complete hook.
> + * @ctx: devtx context pointer.

Hi Stan,

one minor nit: documentation of the timestamp parameter should go here.

> + *
> + * Returns 0 on success or ``-errno`` on error.
> + */
> +__bpf_kfunc int bpf_devtx_cp_timestamp(const struct devtx_frame *ctx, __u64 *timestamp)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  __diag_pop();

...

