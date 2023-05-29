Return-Path: <netdev+bounces-6058-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F16A271490F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A219F280E4D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 12:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75286FC3;
	Mon, 29 May 2023 12:06:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C597B6FA1
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 12:06:10 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7D3F4
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 05:06:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aW3y0KACZN+E9Bisot5+KSPFBcNv9AWVInOt2cZx2GnMEcLTDgGW5qAZKtjuzGkL5uOiZKj9H614Mm+Pfs49r5k2/16W4WFsoQ2gNX8/mm5ACUKjQo22pPeAhsQYnGYTrk+5iz16PP+3i6yr55YfrDkM0tjmQFhmqndPnOybaD+31qPdEzaXrKJ4CZH8bQfAoLUua62u+Nwjo++snyPGJhRQsf79/hyVU0l7r2xNqwTNZxN5YnNAFueaCOBvNEjb4z2ujaIDoioki8NZMPaKkVJdaxKzEKTRLcCDfOob5s0tNbbT3zZSfvhhEjRpgp6sjWX1rtSaRlEoNkEa1iePnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBS2WHqlapJglO5pnC1VnkYysvV1DwkSFi28+J5nubg=;
 b=lOz9zGFK3G01G9MNjtHsEEP/qn5ASZuKvhZdFiURBGP9Rd0J0e/V3cXShjDL2IVYlfYA4eFpqj+FGDi14IlK5fd5+vYnXPAMvFsEYnZjRHJw3bocJRcQVRijOYOXb1pGxycjYoqEtnRWwmHnuwlJ72V7wnt98okw85/anmW2k0mUrdHbdErdSUsuTHO0AJ57vRtl5k8yX6h91B9kHiDNiU68b0RbpL6Gw7pT/WhZSm/cLAifRbKGwhI+R79wsH2atnaZ47mrMg0hAb0K1Aq3wSIq22EreMpENS5Pfno3L9Z6NPktVSs7yiSM1NJVRQ34KtsJe37z984TE4jNC9/v6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBS2WHqlapJglO5pnC1VnkYysvV1DwkSFi28+J5nubg=;
 b=hmBJP58bNZ1kgMKu47CppX/AiYG81sD+qV8QqH3ulkWp5xhgaPBPEiLUMuSps5MTiYK8vJOc+3mQRXReMKTKaMmAYa+8NzVtExTec0QwibA07tKQhJJrabWJRU6zkKjXFETaVGTaIg8pilrv8HZ697kgPFcgaeqMLyfXlKSy1aydJq7PS8jIuNFA7v1tFTZyovT/FOpuarASOtbRRzzSQ2B0PTV3VxalgDSGuC3Htfr7xrr4mS0eL8iK5oK9RgZAFnRHT557aC2N6SuPSKf8sSR5beW7YDtuXhWqVMUJ1J70mPkV8Msf3Mdhe4Uifln8JJi/ALCfFPfiI5fSTiYbbw==
Received: from CYZPR05CA0043.namprd05.prod.outlook.com (2603:10b6:930:a3::25)
 by SA3PR12MB8811.namprd12.prod.outlook.com (2603:10b6:806:312::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 12:06:05 +0000
Received: from CY4PEPF0000E9D8.namprd05.prod.outlook.com
 (2603:10b6:930:a3:cafe::7f) by CYZPR05CA0043.outlook.office365.com
 (2603:10b6:930:a3::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21 via Frontend
 Transport; Mon, 29 May 2023 12:06:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D8.mail.protection.outlook.com (10.167.241.83) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.18 via Frontend Transport; Mon, 29 May 2023 12:06:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 05:05:54 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 29 May
 2023 05:05:50 -0700
References: <cover.1684887977.git.peilin.ye@bytedance.com>
 <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
 <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
 <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
 <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Peilin Ye <yepeilin.cs@gmail.com>, Jamal Hadi Salim <jhs@mojatatu.com>
CC: Jakub Kicinski <kuba@kernel.org>, Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri
 Pirko <jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>, Daniel
 Borkmann <daniel@iogearbox.net>, "John Fastabend" <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, <netdev@vger.kernel.org>, Cong Wang
	<cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Date: Mon, 29 May 2023 14:50:26 +0300
In-Reply-To: <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
Message-ID: <87jzwrxrz8.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D8:EE_|SA3PR12MB8811:EE_
X-MS-Office365-Filtering-Correlation-Id: 87405f6e-45b7-4ef9-bb60-08db603d13f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b4IHTNzQmZehvxs3BJzOto7aO7oo4sQdM4IbpqcAlyTkl6wFT07jSEfrrsjhC6fslRGHAJ+zHtLDEqFqoFqshKvkN0MkVNU16r2RNtjalhneupBBovGmjezVnhc82wDeWqOqkrZMsNoHzVU3kIXoFJH6oBmBuF5e5mWmhojaI4lhRqDHU8MTTjAGqs5NCaN4rKL17fyFxBLKh70PCJAIbV1sohvrSYOgzef1rIfWZcCZCN4zQXSF5qa34ov46dQNcWty5fVa191lcOcv8BRqM2pT3AVVvWNJovv6JNuhzQ0eX5kxBl/JgCxcZtHtP4P58JH9q9uTKEgf7Qt9qpxjkfreApRzRh2ubTcRjaGnSS3N4tsanS1jcVZ2/jUSHP/10zQ0xe1HSiiniD0R7m0vijeeu9u0noZ2t4zZsdhSP7oySCxtCoIDEFK7wWttCZWYcVHzUdvCK8byZDa0JebpOPebh4HoD7RQ2nTJuxiLSS36LnR0/8ie/FmAlYdPQIYPOsJYhkL2EQ8rmq+zSst0KFBuoLdmWplhY3kLlH1MreJ4KvZ9nIZHH/W8PPhIOV2xhxu6ofAFZJJkaJjOOD2EJjSUUYAOUkC2tS7tEu1bYrmLMuccMWvjjeLfnVN5Be/acJCv6AuVgGAgH15CJFnq5NlI3xpGFQrmZMD04zXmU91Q9Sonycf5mqOemw+4+0CLKVol2UUKyw2URTnzxe/aLQIa2o+kz4WiLWccnyZMdR0el3rJBQiptR1pWErvdVJ5
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(86362001)(41300700001)(7696005)(40480700001)(40460700003)(4326008)(6666004)(316002)(36756003)(70206006)(70586007)(7416002)(36860700001)(5660300002)(186003)(16526019)(2906002)(478600001)(53546011)(26005)(2616005)(47076005)(83380400001)(426003)(336012)(54906003)(8676002)(8936002)(82740400003)(356005)(7636003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 12:06:04.5662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87405f6e-45b7-4ef9-bb60-08db603d13f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8811
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun 28 May 2023 at 14:54, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On Sat, May 27, 2023 at 4:23=E2=80=AFAM Peilin Ye <yepeilin.cs@gmail.com>=
 wrote:
>>
>> Hi Jakub and all,
>>
>> On Fri, May 26, 2023 at 07:33:24PM -0700, Jakub Kicinski wrote:
>> > On Fri, 26 May 2023 16:09:51 -0700 Peilin Ye wrote:
>> > > Thanks a lot, I'll get right on it.
>> >
>> > Any insights? Is it just a live-lock inherent to the retry scheme
>> > or we actually forget to release the lock/refcnt?
>>
>> I think it's just a thread holding the RTNL mutex for too long (replaying
>> too many times).  We could replay for arbitrary times in
>> tc_{modify,get}_qdisc() if the user keeps sending RTNL-unlocked filter
>> requests for the old Qdisc.

After looking very carefully at the code I think I know what the issue
might be:

   Task 1 graft Qdisc   Task 2 new filter
           +                    +
           |                    |
           v                    v
        rtnl_lock()       take  q->refcnt
           +                    +
           |                    |
           v                    v
Spin while q->refcnt!=3D1   Block on rtnl_lock() indefinitely due to -EAGAIN

This will cause a real deadlock with the proposed patch. I'll try to
come up with a better approach. Sorry for not seeing it earlier.

>>
>> I tested the new reproducer Pedro posted, on:
>>
>> 1. All 6 v5 patches, FWIW, which caused a similar hang as Pedro reported
>>
>> 2. First 5 v5 patches, plus patch 6 in v1 (no replaying), did not trigger
>>    any issues (in about 30 minutes).
>>
>> 3. All 6 v5 patches, plus this diff:
>>
>> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
>> index 286b7c58f5b9..988718ba5abe 100644
>> --- a/net/sched/sch_api.c
>> +++ b/net/sched/sch_api.c
>> @@ -1090,8 +1090,11 @@ static int qdisc_graft(struct net_device *dev, st=
ruct Qdisc *parent,
>>                          * RTNL-unlocked filter request(s).  This is the=
 counterpart of that
>>                          * qdisc_refcount_inc_nz() call in __tcf_qdisc_f=
ind().
>>                          */
>> -                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_=
sleeping))
>> +                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_=
sleeping)) {
>> +                               rtnl_unlock();
>> +                               rtnl_lock();
>>                                 return -EAGAIN;
>> +                       }
>>                 }
>>
>>                 if (dev->flags & IFF_UP)
>>
>>    Did not trigger any issues (in about 30 mintues) either.
>>
>> What would you suggest?
>
>
> I am more worried it is a wackamole situation. We fixed the first
> reproducer with essentially patches 1-4 but we opened a new one which
> the second reproducer catches. One thing the current reproducer does
> is create a lot rtnl contention in the beggining by creating all those
> devices and then after it is just creating/deleting qdisc and doing
> update with flower where such contention is reduced. i.e it may just
> take longer for the mole to pop up.
>
> Why dont we push the V1 patch in and then worry about getting clever
> with EAGAIN after? Can you test the V1 version with the repro Pedro
> posted? It shouldnt have these issues. Also it would be interesting to
> see how performance of the parallel updates to flower is affected.

This or at least push first 4 patches of this series. They target other
older commits and fix straightforward issues with the API.


