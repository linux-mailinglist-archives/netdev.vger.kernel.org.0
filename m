Return-Path: <netdev+bounces-8739-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF817257AA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB54C280F38
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3239E8BE7;
	Wed,  7 Jun 2023 08:31:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDD68C00
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:31:51 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934A283
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhD1QKukLlmcs/hk5BXoQdxXVtRaGvjqebysV0G0/6mPbrsU1XwMr1zdwLqdfBbDln1Qt+6dot24DfrSIlf6vbzlps+oQLmLEoaFspSS12MAePb9cRzOvPunFCOvSFKUcCoP4+iNSsYcWhcZ6jsMvPvPGB0FWQYvdXVR9x4f4hW3peG9HcLuWxtpviIxawHe6KtK+Q7BmVC0CstbDnDrBL3H3l1V1tbB+crgMwQ+CNWlAoKYYRwR4+ZpH/EG7q/scoSbObzCrYt50GX/0vebuHUeYmYXE0venDj9/qplB36LRRb+6InUjUkFY9Jyx/l+risQq1qUIfte2N4l5UqAig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykTC8ER8LHl5IGyK6rhJS7r0eLbWcSojVe2NKEll70s=;
 b=llJ5aSzUAVYJ1xxmlFgT+oweQtBMGAS7ekKxiKS/OstXZnrexOqBoR3vKF5VFObekYyiUPUH44di5zGhhYXi7VJnU/5Chj7VhGWZbMzFwjyckxWYkBQo2PMFOfPiBOELA4neQBXbGrcOYHVdpooEdlK0BbNNlDVkpulIH2L0sCtmWTwT7wCyt4/vJVL/fgiSbQGE/jhNyXtXu4WNhu6h7z5SuOza0FNx9seKpgMvBYlgWww/Xsdm6cUdJqZWQQfjVSNMxTvG/jge3ydwMDJPQzy66kBPDvP/GUXSWoedjmSCwPzBiBVWUk4XP1ubHQT82GLKQ/cu8kU38w3MPWdY6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykTC8ER8LHl5IGyK6rhJS7r0eLbWcSojVe2NKEll70s=;
 b=EW5Dt45U+WAfBJVhe/rsOGXM1/YN3SKStwKe2aRFEyU9lgoRXuOedmaBnQezf4Os9EHJdu1lbhVHShsRQvLjewvu0F1j75V4Exm/MoCUP8t1j+HzLuqcMxJ5snBqOGXJkgS4E5eWEOLmbLhvptA+UuAp9noQ39FG04TJlM9XZxroSMkrWfX7DGOrPUU+WEhvXlPMHwuoJcsr1JDB8hU2vxlnqweXKUAzsELyK1oA1d3f8w4Tn2ISZ0v4PK0XXYYogU4f8uj/ZebzoknLnAzniKz9Xa0sqRDs2fNPXIgAOSCeCVqqfS6AO+sYExBL9QUv5x/5hewFKgvsQusfZYeuGA==
Received: from BN0PR02CA0007.namprd02.prod.outlook.com (2603:10b6:408:e4::12)
 by PH7PR12MB7378.namprd12.prod.outlook.com (2603:10b6:510:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 08:31:46 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::6d) by BN0PR02CA0007.outlook.office365.com
 (2603:10b6:408:e4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Wed, 7 Jun 2023 08:31:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.24 via Frontend Transport; Wed, 7 Jun 2023 08:31:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 7 Jun 2023
 01:31:33 -0700
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 7 Jun 2023
 01:31:29 -0700
References: <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com> <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com> <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com> <877csny9rd.fsf@nvidia.com>
 <ZH/V5gf+YjKuC0bn@C02FL77VMD6R.googleapis.com>
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
Date: Wed, 7 Jun 2023 11:18:32 +0300
In-Reply-To: <ZH/V5gf+YjKuC0bn@C02FL77VMD6R.googleapis.com>
Message-ID: <87y1kvwu5c.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT050:EE_|PH7PR12MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: dc5708e5-c254-41b4-47a9-08db6731a1aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V9RNjk/0xYqvSvYf9BtKlLGwAwmwOcJG0MSENCK+xx1WvHDsu5rnKUz51FZKB9Ug2fEs1L2BWnyeWhyy5YfHEvIraiAYaJ3OXwnGz4YnajROr9X45JJ8F8Ji5BJU4eKyCIG3CtAqgxSvhAY0Idc3SFrBD5mvCBG2l6pTcWf14BT33Rco/WvKcjpb0nQoBh1s1wWwjtDF0ZBACOLdSUyvoZo0GizDSYaewfWR5v+kxZD5pyEgUcrM6XxNJl+XwFjn5ZyyOYt+F6VQIX4eUq5j4foG9zvzvAFKrGNLaw6XCH9gQpjp5QFwUnEsGN4wO9/TPqD/VUdwxpM+EMhjLcGhnYhi25mPYxiAW/2ZwMFRILI4bnwKqYZ04D1RUH8eAz8Il3w3rqbYzlijq0yThtywjS6zJCR29T6z9BJ8iD4hAiL8MyaGik5PBLB4IW+YleqY4Tre15xe/SSwVFvIPmmS5QbPqeLcjcm3iKdF9xWeGAnOm2GtlclhemeLl8YUF0FC9RrJbX4FYjrByMMjmguhT/sYyo1HDrNTNXuXda74mUieiLhKlaeoi9N2RU+BGD0lsi5Ay/eAOAjmJax0f5rGlwn28dOcoEelmigSdPBdXFMrTeAGYLfDjh5skKFVKlaIMq8hMy4kxBIpmnT5uoMKT7PUZS3eqYqdY+o/g2WxG0ryLxSiEicfknBdrR2y50xsZ90s3fKEI/Jy5UTOY+N8a7yey2uEdoo1gh6rzth5ro4HvFDQrcOBjfDOLHDkH9sf
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(82310400005)(36860700001)(41300700001)(5660300002)(40460700003)(8676002)(8936002)(478600001)(54906003)(6916009)(6666004)(70206006)(70586007)(4326008)(40480700001)(316002)(7696005)(82740400003)(356005)(7636003)(36756003)(86362001)(336012)(186003)(16526019)(426003)(83380400001)(2906002)(2616005)(7416002)(47076005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:31:46.4375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5708e5-c254-41b4-47a9-08db6731a1aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7378
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue 06 Jun 2023 at 17:57, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> On Thu, Jun 01, 2023 at 09:20:39AM +0300, Vlad Buslov wrote:
>> On Wed 31 May 2023 at 20:57, Peilin Ye <yepeilin.cs@gmail.com> wrote:
>> > +static inline bool qdisc_is_destroying(const struct Qdisc *qdisc)
>> > +{
>> > +       return qdisc->flags & TCQ_F_DESTROYING;
>> 
>> Hmm, do we need at least some kind of {READ|WRITE}_ONCE() for accessing
>> flags since they are now used in unlocked filter code path?
>
> Thanks, after taking another look at cls_api.c, I noticed this code in
> tc_new_tfilter():
>
> 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
> 			      flags, extack);
> 	if (err == 0) {
> 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
> 			       RTM_NEWTFILTER, false, rtnl_held, extack);
> 		tfilter_put(tp, fh);
> 		/* q pointer is NULL for shared blocks */
> 		if (q)
> 			q->flags &= ~TCQ_F_CAN_BYPASS;
> 	}               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> TCQ_F_CAN_BYPASS is cleared after e.g. adding a filter to the Qdisc, and it
> isn't atomic [1].

Yeah, I see we have already got such behavior in 3f05e6886a59
("net_sched: unset TCQ_F_CAN_BYPASS when adding filters").

>
> We also have this:
>
>   ->dequeue()
>     htb_dequeue()
>       htb_dequeue_tree()
>         qdisc_warn_nonwc():
>
>   void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
>   {
>           if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
>                   pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
>                           txt, qdisc->ops->id, qdisc->handle >> 16);
>                   qdisc->flags |= TCQ_F_WARN_NONWC;
>           }       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   }
>   EXPORT_SYMBOL(qdisc_warn_nonwc);
>
> Also non-atomic; isn't it possible for the above 2 underlined statements to
> race with each other?  If true, I think we need to change Qdisc::flags to
> use atomic bitops, just like what we're doing for Qdisc::state and
> ::state2.  It feels like a separate TODO, however.

It looks like even though 3f05e6886a59 ("net_sched: unset
TCQ_F_CAN_BYPASS when adding filters") was introduced after cls api
unlock by now we have these in exactly the same list of supported
kernels (5.4 LTS and newer). Considering this, the conversion to the
atomic bitops can be done as a standalone fix for cited commit and after
it will have been accepted and backported the qdisc fix can just assume
that qdisc->flags is an atomic bitops field in all target kernels and
use it as-is. WDYT?

>
> I also thought about adding the new DELETED-REJECT-NEW-FILTERS flag to
> ::state2, but not sure if it's okay to extend it for our purpose.

As you described above qdisc->flags is already used to interact with cls
api (including changing it dynamically), so I don't see why not.


