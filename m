Return-Path: <netdev+bounces-6064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 801897149EF
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1573D280E5E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D876FD2;
	Mon, 29 May 2023 13:13:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703303D60
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:13:20 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88FC91
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:13:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aa+GPyMEuUG6YGK6liz2cmuDO4lGpEOiYXDjvO+5+wDzXHsTFzxJ0zklZyuxv5hzxkJczkUInDfMVBfC0JhD3QPTFuwX9NZK3f7ydiaaix5/hS8Q/y3GodedQRRqQvbC1Xt96QYBGX6Ptzja+zVFiN5LWQ18CN/YU8xeqNOfXCbbrvxXw4N+cHmL8gmg00qsrnWe2o/Q6SyWbnF/BLVPNyty6JrTrAoHyLMevkrPYNXJJ1l0YloaxjwR4RZLJyIK7flO/9W5yQvJE7faO+YARSCZ+gOha0W+8q7mMSR9kmN2mNkVKJbyZxowC3r7gVvsWxKppQgZ6FLcwWZ9qn3QcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gstLwWgdO5JaAkgfQMIYINgtkGq8g6rf4w6osmUFBr8=;
 b=TT1oQyggkMVzcAgOMLtrhM7Gx798MqlAONEhTKuNx+vZgSbc3y5EpLrja2K6+e9UOEAbuuitgPciCiZwebl1wnMXSJrjHpY5zvHa3YJWbJzbcScU8M9ZgsSTPP9CLMDiO+VCH9gvtTT1gScdbTcGbg8atiJuV5R2JxgOFQgUi3XbzcZnOGpzi6ikWjHzMmS4F2Rf7EUCefyubsCsJLtTRa3vaRipsb93/9ic9YVaSbDbmWZp/pAfnP+Lu70ihOsQql0au3r0dEHwFsLBKzh8z2iX5WeovHx001DDNll13Iigs8crw9k3hdN6fPebBMXrYvOLFtM9M2t6/X88SagOUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gstLwWgdO5JaAkgfQMIYINgtkGq8g6rf4w6osmUFBr8=;
 b=iOQQY2zn5eeLa+kxZKThxa4xZq1FU5Nxp5eFVtWv8iKYjhCKKiNLxyEIJiLB0pzQk0UJi2fp3j88JRrXr76IC+zGe1mWeDurRMeUHjzBhZSabS8v2dALDz0UuzdoUyY+rFKfGPQvqQ802KybUaVHj593eVUDxQnRmhLnT6Tib/hIszlu6nX87Oh4RgtP81wliOt4RAmaWnyqx2F2yOVkxK6zQCrtjADFw9MBBnaT3ZG6JAH45obdgYskxFjTeqKnd8pD75e0dNy6XHocnPY75zsxZVs5eJUpOhzpBiAqQPQYduAL3g7KGdE+5AkkuI6wOl9mqwmOydNP5xBtAnKjzA==
Received: from BN9PR03CA0354.namprd03.prod.outlook.com (2603:10b6:408:f6::29)
 by SA3PR12MB9200.namprd12.prod.outlook.com (2603:10b6:806:39c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 13:13:16 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::bd) by BN9PR03CA0354.outlook.office365.com
 (2603:10b6:408:f6::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22 via Frontend
 Transport; Mon, 29 May 2023 13:13:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.20 via Frontend Transport; Mon, 29 May 2023 13:13:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 06:13:07 -0700
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 29 May
 2023 06:13:03 -0700
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
 <87jzwrxrz8.fsf@nvidia.com>
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
Date: Mon, 29 May 2023 15:58:50 +0300
In-Reply-To: <87jzwrxrz8.fsf@nvidia.com>
Message-ID: <87fs7fxov6.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT060:EE_|SA3PR12MB9200:EE_
X-MS-Office365-Filtering-Correlation-Id: b5703b0d-09a1-4bdb-5acf-08db60467725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8rvUcE7ugdwYxMfRQolV8AYS7MQxWUFRgjwSR9g9efye8XAD+mnMjx964b2DF31wZBxD5iakBs8CD4YtWK+Hgt5OKWVyNp2XxxLDbwOB5/YNlLKpE7fpmeF791exJZMK8BbUQdsTiFa8XQHqOhxTBG8eETA5LGoxzia0uB6ggefSm98zOEKnqN+im1sZ6l1sOqXxDCIyI1G8DfaVCjM6wxuUDcU+LRZH/P5rMuNGnju1TrQYviw8V0cH/vB8Zx8a/PEaKB0qpkZ6vzvygdhVtS69AeMPsgtda8HWJ9A9ECC2jPaTnn6w3wvDx+upxv7xZg1OMsoyxj7E7d8VhC1VuQU8sTZ7dXh72F2MKp63ZSYgw8tkwV/FwlJYXq7uBa+zQFAIns4SvRHm5qGQKwix6kw15FGBeOBv8K2AuZGUqw7uek3umTLY+/d7MvRoUtnJSmaWwPvAXHg2kipnmW8SXFxxrZCpYTuDxoA00saPTZZfI8Al4oAInHIwCsdKoEZBEo5owbprBR3TB1oAk/b4zA0VyIn3N+W9D2nG6xv0CbcFejECeq/RCmy4ht836iIrMqYLbTEOPIm6cK36PHRFCUv9luo2WIhPv0iTIvy54KNz4g4PTA+9T/VryRx+T/LAKj+CICXOOW2Fpe4n3WazUhntDpnTR7xMLjFhQM1mP41DpDl/VO4SxqVVPhI+oUyhdDoAwQ/fuCEzoldSg6Key8GKigmDeGHavIJyQ/Xi3Uxh0YXQGUfzILj40X6IlA9Y
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(136003)(346002)(376002)(451199021)(36840700001)(40470700004)(46966006)(478600001)(7696005)(6666004)(110136005)(54906003)(53546011)(16526019)(186003)(26005)(2906002)(82310400005)(4326008)(316002)(70586007)(70206006)(8936002)(8676002)(7416002)(41300700001)(5660300002)(82740400003)(356005)(7636003)(86362001)(36756003)(40460700003)(36860700001)(83380400001)(40480700001)(336012)(426003)(47076005)(2616005)(66899021);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 13:13:16.4096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5703b0d-09a1-4bdb-5acf-08db60467725
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9200
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon 29 May 2023 at 14:50, Vlad Buslov <vladbu@nvidia.com> wrote:
> On Sun 28 May 2023 at 14:54, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On Sat, May 27, 2023 at 4:23=E2=80=AFAM Peilin Ye <yepeilin.cs@gmail.com=
> wrote:
>>>
>>> Hi Jakub and all,
>>>
>>> On Fri, May 26, 2023 at 07:33:24PM -0700, Jakub Kicinski wrote:
>>> > On Fri, 26 May 2023 16:09:51 -0700 Peilin Ye wrote:
>>> > > Thanks a lot, I'll get right on it.
>>> >
>>> > Any insights? Is it just a live-lock inherent to the retry scheme
>>> > or we actually forget to release the lock/refcnt?
>>>
>>> I think it's just a thread holding the RTNL mutex for too long (replayi=
ng
>>> too many times).  We could replay for arbitrary times in
>>> tc_{modify,get}_qdisc() if the user keeps sending RTNL-unlocked filter
>>> requests for the old Qdisc.
>
> After looking very carefully at the code I think I know what the issue
> might be:
>
>    Task 1 graft Qdisc   Task 2 new filter
>            +                    +
>            |                    |
>            v                    v
>         rtnl_lock()       take  q->refcnt
>            +                    +
>            |                    |
>            v                    v
> Spin while q->refcnt!=3D1   Block on rtnl_lock() indefinitely due to -EAG=
AIN
>
> This will cause a real deadlock with the proposed patch. I'll try to
> come up with a better approach. Sorry for not seeing it earlier.
>

Followup: I considered two approaches for preventing the dealock:

- Refactor cls_api to always obtain the lock before taking a reference
  to Qdisc. I started implementing PoC moving the rtnl_lock() call in
  tc_new_tfilter() before __tcf_qdisc_find() and decided it is not
  feasible because cls_api will still try to obtain rtnl_lock when
  offloading a filter to a device with non-unlocked driver or after
  releasing the lock when loading a classifier module.

- Account for such cls_api behavior in sch_api by dropping and
  re-tacking the lock before replaying. This actually seems to be quite
  straightforward since 'replay' functionality that we are reusing for
  this is designed for similar behavior - it releases rtnl lock before
  loading a sch module, takes the lock again and safely replays the
  function by re-obtaining all the necessary data.

If livelock with concurrent filters insertion is an issue, then it can
be remedied by setting a new Qdisc->flags bit
"DELETED-REJECT-NEW-FILTERS" and checking for it together with
QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
insertion coming after the flag is set to synchronize on rtnl lock.

Thoughts?

>>>
>>> I tested the new reproducer Pedro posted, on:
>>>
>>> 1. All 6 v5 patches, FWIW, which caused a similar hang as Pedro reported
>>>
>>> 2. First 5 v5 patches, plus patch 6 in v1 (no replaying), did not trigg=
er
>>>    any issues (in about 30 minutes).
>>>
>>> 3. All 6 v5 patches, plus this diff:
>>>
>>> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
>>> index 286b7c58f5b9..988718ba5abe 100644
>>> --- a/net/sched/sch_api.c
>>> +++ b/net/sched/sch_api.c
>>> @@ -1090,8 +1090,11 @@ static int qdisc_graft(struct net_device *dev, s=
truct Qdisc *parent,
>>>                          * RTNL-unlocked filter request(s).  This is th=
e counterpart of that
>>>                          * qdisc_refcount_inc_nz() call in __tcf_qdisc_=
find().
>>>                          */
>>> -                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc=
_sleeping))
>>> +                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc=
_sleeping)) {
>>> +                               rtnl_unlock();
>>> +                               rtnl_lock();
>>>                                 return -EAGAIN;
>>> +                       }
>>>                 }
>>>
>>>                 if (dev->flags & IFF_UP)
>>>
>>>    Did not trigger any issues (in about 30 mintues) either.
>>>
>>> What would you suggest?
>>
>>
>> I am more worried it is a wackamole situation. We fixed the first
>> reproducer with essentially patches 1-4 but we opened a new one which
>> the second reproducer catches. One thing the current reproducer does
>> is create a lot rtnl contention in the beggining by creating all those
>> devices and then after it is just creating/deleting qdisc and doing
>> update with flower where such contention is reduced. i.e it may just
>> take longer for the mole to pop up.
>>
>> Why dont we push the V1 patch in and then worry about getting clever
>> with EAGAIN after? Can you test the V1 version with the repro Pedro
>> posted? It shouldnt have these issues. Also it would be interesting to
>> see how performance of the parallel updates to flower is affected.
>
> This or at least push first 4 patches of this series. They target other
> older commits and fix straightforward issues with the API.


