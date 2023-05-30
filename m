Return-Path: <netdev+bounces-6359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ADA7715F13
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F56B281135
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7A419911;
	Tue, 30 May 2023 12:23:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B7A17FE6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:23:55 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D439126
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:23:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+3z9bHO9FomiS35pe8+L/EaZeoA4ZbxXpmLr3c0RbF81u9jxuVwLZ+PXpdjGDk8CiadiFMZ4D0Xq4EtqzdQrN3xpa5HNJK6i3N6O0ZrMorAgX/el7Y+sQJsISxt+6/3dJo0dP6uF9V3nX9H/5MxHzNUr4B5mJNUYKSo0ZoS5HwRsKcqU5mfTsDl1wxeWE5y4Iki61z1wY6hT79LzljopxHVEqn4djCS8aZU+NpxSHgHEDxpoLgz14j/RUVwUGJ55irBQas/PzV3T6l2y46ArvXit4rN3mjJfHEtj+AJnEBDvA/Xc0pNGxCIQ4Zt105xNPm6lS2aNWtcUbszXdWbSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rWMInJQYFO5N1j4Te4DejzinQl8u8OrNdghAE1YTCY=;
 b=m4B0p6nEM04UewxI0cNYu8JV3dAP00fWAUz5QHIuhxZ/89iXW7E3KscHk0Fg7R/J45ymG3zpxGtFIzVuySCPEaPz4vb5BYxa3p8cUFTdovIYzfQSBciD5KQA4i9kGp7onT5NP1BdMVLimX9Jw8otrlVbr+gIMxLMv0o34KK/JgByTRID5dTHHaS0STsjnNp68bBbjOedWxM4iny0FHC1gqTxrpO4wolDaXVal86CXSJ4PtmV79H66YXe533jlkEURMpQjr7SLkl/7BweDRAwDmmmHj4o1lCwdG6XA2MvPMjH56Mrtd2bCx8SVr1B9lRf5b8qLxm8O2D4Pgy5i5KMUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rWMInJQYFO5N1j4Te4DejzinQl8u8OrNdghAE1YTCY=;
 b=o6nYvauvdoQAWSYHYF/l/RlalVgf0R7M0LZ0DR4xQ8esZ+qt+cZtStlPhistFK66inQLGh3h4WjyvinOSnCIlt+UK7BTt1PLVXKz/SuhDa4+OliBv786Rqi2oXGVDmZdvTs9fsWTP0FmtaIW7y8jgGamj9KYjaKow3N6Mu6QUr2COoBkIMxMXGnynhHW6dIqG/Z6qCUPAd6YQ5pIA1xSTbEsExadGrZcVB0wsr2NZm0p3FElsw5jLDlJYvfP/R94vEbK3QmrjU45unf6eCc9s97FOLOQn7auIeQjaOUvek/2bL6ggGdD5J4wpmGhrbvUp3C1Of/lZGlA13kh1ztdXw==
Received: from DM6PR07CA0108.namprd07.prod.outlook.com (2603:10b6:5:330::14)
 by CH3PR12MB7521.namprd12.prod.outlook.com (2603:10b6:610:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:23:02 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::c9) by DM6PR07CA0108.outlook.office365.com
 (2603:10b6:5:330::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Tue, 30 May 2023 12:23:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.21 via Frontend Transport; Tue, 30 May 2023 12:23:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 30 May 2023
 05:22:52 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 30 May
 2023 05:22:48 -0700
References: <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
 <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
 <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com> <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Peilin Ye <yepeilin.cs@gmail.com>
CC: Jamal Hadi Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
	<jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann
	<daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, "Hillf
 Danton" <hdanton@sina.com>, <netdev@vger.kernel.org>, Cong Wang
	<cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Date: Tue, 30 May 2023 15:18:19 +0300
In-Reply-To: <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
Message-ID: <87bki2xb3d.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT026:EE_|CH3PR12MB7521:EE_
X-MS-Office365-Filtering-Correlation-Id: 14371413-8393-46a4-dbdc-08db61089c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iiBXO6cYekruUberkKvhYmAqteVAZ41U8V98AA0OFWm8ILEutGfigYc1T06urAiADe7urFqV5R+Bu3rhMFPCcq5zjeXu90ATlqubI0TTjaNgGUDGWPm1LVTZ+fftvMroETyRmm2jTh+B3rpLJvSD0MAuS7ikoZQDGEzRu/2nd5eNqpOg6QUaYyH9lvqH4Z4lzlmGJaOYrfs1hMRSOSYVS0R2kW9QsiO06d2koUG16zvM32q5N0Ghs7u13e8gTkPjDccF2cPqMptKVt5W1xxz/D/C/7JnS0piBjJ0vF5C33hKnH9RoRdEDgLj93WAK9yTy+vs1nWwXutfsT7rUpZFptH307Mp7Ng6a0MbUNfg+ygRu8fW69zadTYxa4bQ8Iu4iu3K+OluOtzERiicUd1mh1XlSH3vxj4eNs5h6w2fvfQU77BmTGbT+8xW2R6TPkf8JltuOWjOAgl0RVxSRoKZMYq3gpMp5QBUQPeJof+R8ZBnSmtuYN/q+Vy8ovlbAZA4ibQ3rTmjLpgBkco52bLybB2Aft23qqxn3h47fsv17RUo2Bgfn1RGF2XyAgho+/MzEtsiTbBNeqd1AUEyxRDc5bo6fWDH9i+7iA8pe1gZkNvHsNN+kMTdkpDvtkK2xOvAx+s7pCf83S0XEtv2QTGNXxFLUKr6snzpyuUiZ1p/jJjVqIc5iBadt7Gbf+k/9TmwrQOBL8LIkisxQakd5gx861kDA6o0yK+UaWIkVryMRKQkLhPhawNBAc92RlLAD67i
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(2616005)(41300700001)(47076005)(36860700001)(6666004)(7696005)(16526019)(26005)(83380400001)(186003)(426003)(336012)(478600001)(40460700003)(54906003)(70206006)(70586007)(82740400003)(6916009)(4326008)(82310400005)(40480700001)(7636003)(356005)(316002)(7416002)(5660300002)(8676002)(8936002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:23:01.6678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14371413-8393-46a4-dbdc-08db61089c9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7521
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue 30 May 2023 at 02:11, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> On Mon, May 29, 2023 at 02:50:26PM +0300, Vlad Buslov wrote:
>> After looking very carefully at the code I think I know what the issue
>> might be:
>>
>>    Task 1 graft Qdisc   Task 2 new filter
>>            +                    +
>>            |                    |
>>            v                    v
>>         rtnl_lock()       take  q->refcnt
>>            +                    +
>>            |                    |
>>            v                    v
>> Spin while q->refcnt!=1   Block on rtnl_lock() indefinitely due to -EAGAIN
>>
>> This will cause a real deadlock with the proposed patch. I'll try to
>> come up with a better approach. Sorry for not seeing it earlier.
>
> Thanks a lot for pointing this out!  The reproducers add flower filters to
> ingress Qdiscs so I didn't think of rtnl_lock()'ed filter requests...
>
> On Mon, May 29, 2023 at 03:58:50PM +0300, Vlad Buslov wrote:
>> - Account for such cls_api behavior in sch_api by dropping and
>>   re-tacking the lock before replaying. This actually seems to be quite
>>   straightforward since 'replay' functionality that we are reusing for
>>   this is designed for similar behavior - it releases rtnl lock before
>>   loading a sch module, takes the lock again and safely replays the
>>   function by re-obtaining all the necessary data.
>
> Yes, I've tested this using that reproducer Pedro posted.
>
> On Mon, May 29, 2023 at 03:58:50PM +0300, Vlad Buslov wrote:
>> If livelock with concurrent filters insertion is an issue, then it can
>> be remedied by setting a new Qdisc->flags bit
>> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
>> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
>> insertion coming after the flag is set to synchronize on rtnl lock.
>
> Thanks for the suggestion!  I'll try this approach.
>
> Currently QDISC_CLASS_OPS_DOIT_UNLOCKED is checked after taking a refcnt of
> the "being-deleted" Qdisc.  I'll try forcing "late" requests (that arrive
> later than Qdisc is flagged as being-deleted) sync on RTNL lock without
> (before) taking the Qdisc refcnt (otherwise I think Task 1 will replay for
> even longer?).

Yeah, I see what you mean. Looking at the code __tcf_qdisc_find()
already returns -EINVAL when q->refcnt is zero, so maybe returning
-EINVAL from that function when "DELETED-REJECT-NEW-FILTERS" flags is
set is also fine? Would be much easier to implement as opposed to moving
rtnl_lock there.


