Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05803D90E5
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhG1Oqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:46:39 -0400
Received: from mail-sn1anam02on2100.outbound.protection.outlook.com ([40.107.96.100]:51829
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235521AbhG1Oqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 10:46:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgWdnvy6VwYz6YchIOlsEvU30VPf80gW4nBvjpjUERrTK5tbw6aHc1r0D6eyDlZnt75xxlZ4xX4VgRJIybG0ICJTGf9sl80IQhtX2P2HhmuKK94DBlTscAmGY3jQV9KFDL40aCteeq5g5kpDjY4xEGXAqPYHFC1Na7bs8hge/kFW27cUHQZ6vlI3HeJi+tG6MmxZkumRoUsIqwWET3kRgeL1rbe95Xj5sTZtQlKAV5fIuekSKsGw3RyNIJWHm/D/omEvHWLBFZVPAyORLrX4Bui7EXExPsBW7ADE29MKgRtVvZT0RwTsHJyphEtBpaAhUH2LVcEDnM22i0x5Sp18TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHazgxY3qiGMuqmMyg7mu3G3FJhXZFRS3yykyp1oz6M=;
 b=Uxo+rsyy3Jpbq77iVUxIpRahbuugkLatu8Qh05NYESJMRySoO1iTXOOz5g99OkKXpNPGuVW5JqY3kCKo/QYDC/bYfnK9KlZzJY5ea8eORyRfQKAJ5qC6csDOm7vA3H5tqyE2LnDJACPsgniQiuh5gadIRw2FNTzddHiTEPjnrfKDQZLSRPjT68JSkJ76o0CSmn0L47l5RobVFoxJBnl6TeUVzTm25hW/abMsg+Fu8NSTtb292WN16fDjzQkzFUvt2eZO67oW/eENpI5Xh1dy5CZTme1F40SkT/oWsuQBNt5G/9jIjaPkRgzkALB6ufcm3+1TIyug9wZ//Ah0Y2VYuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHazgxY3qiGMuqmMyg7mu3G3FJhXZFRS3yykyp1oz6M=;
 b=stj0clsbYrVJ8wQigVXgHhr/QXmWnrYITuIbXRG0pjlKdHK8ugcC5L3DjnyJ6vyJpRRtuOC+lyuECRNpgY7uRU6i7UcWW3HFsiqRoz2pd45ZPphjrByaRohoF2q982CZVxjKaRlPIHzwlnKlDLhFJUvejKJVz4kcmzBBIoW84dg=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5051.namprd13.prod.outlook.com (2603:10b6:510:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.12; Wed, 28 Jul
 2021 14:46:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 14:46:32 +0000
Date:   Wed, 28 Jul 2021 16:46:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210728144622.GA5511@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com>
 <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com>
 <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM3PR05CA0122.eurprd05.prod.outlook.com
 (2603:10a6:207:2::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR05CA0122.eurprd05.prod.outlook.com (2603:10a6:207:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 14:46:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6506942c-7764-41a9-24b1-08d951d67dd9
X-MS-TrafficTypeDiagnostic: PH0PR13MB5051:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB5051445C7A3125502FCA761FE8EA9@PH0PR13MB5051.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TVp+RYFt7URLeBqFHYfvQ/Lj41NZ+R1eV2UYT90UWOcoPHvvaeV/8hN/7w22HPSYA2D7H4J4x99Qmg0u+qmybevcz9vdx6YR8iK8lwh5aEBxu/LkmWdDwHRCldOGa5zJf/KUbRxUwXmw3/a5gtLmy4Bfz1lbs4oEQY9y94twRu5BHfXGlmD/FE8YdaBfpkYw1zfR4YZpzZd09YedXEF+dzU/pnK7de/9A2grKRuCL1wXnrRFXbnn1Jto0AeOHYeCY7xUnRA5LrlWH1ES8likoICb0xIP0thqWVfRB4CnfUZcTJmVcW/bW0p76sMXi21UBNO60bKq8pa0kft1B04kGXJhCsuMQ2mMSLORGL7hvBnzT1q8AnpE33hhpaYAMda1UZNWK5Spa4l3adcABS0FqiFWA/POXvD+ACRHRdiBSIoz6KgeASEIXMkrjZYbYBiBtNqPi7laou746ReBhjEGs7MovyYFCuaWX0sdElmeBt5HoeamAzwzzb+CVbz1Q1s9fqzWJh7hpJ0x/nTNovU87Z1EbX2/6UYou9X9ekFjUm0/mT8FcAsv3OyBvJHq65ALjSGUjfyBT5lMa9FgJyxaeBy51BWciscTOuB3KgAs1eTxVRtc+HNvr8CKeDbuoq5oisRc86FrFaPdZfrDLNH2tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(136003)(396003)(366004)(376002)(346002)(36756003)(66476007)(38100700002)(316002)(8936002)(8886007)(52116002)(2906002)(7696005)(54906003)(1076003)(6916009)(44832011)(53546011)(83380400001)(66946007)(7416002)(186003)(33656002)(5660300002)(8676002)(2616005)(4326008)(6666004)(478600001)(55016002)(86362001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RACDEDz7Zpg3g/K5/kmjPCFiDXtQm0zjeIvEn+FJteyScu6FwFmBopPKCcUb?=
 =?us-ascii?Q?vRpOuqyZL2/P/wFK+2CmAiuw07FnUkyfSkawJnL1yDPGXb0cTBwE0a20fHic?=
 =?us-ascii?Q?+2wfrG/TURTvxIr+sMJ0MGv11EYH839PSJ4fi+K3LFpOlcPVBTwftDsprwKj?=
 =?us-ascii?Q?DdTqEu/Ge06ANf8CBWUuap/21Sn/xgHmXy1hnGdL/5PVvGMKBA/CjSbCqnbB?=
 =?us-ascii?Q?zbWmB/eJgHm6lEJ5dQcMNeiUDsWkcdl8PdXa4T0j+DvSIrrtZCzBzV7wxKS3?=
 =?us-ascii?Q?C8jQhh6SVPUrlM7WyDRO8woml0+g84xUeFJbRcZE4+sNqXBIqhlSse3riHhb?=
 =?us-ascii?Q?DAbARHCcL8UBpgL0hA8BR+4+36p0D3o1GsyTCA+K9VoVOCW59sS1FqaC/Lz1?=
 =?us-ascii?Q?mu0SuIj0Qmu7amULClg9f9cdBEF+NrUR5YSfdGBHhtDMfVTVFgRB0d3NQVsl?=
 =?us-ascii?Q?/jzigsv5g7sa0hDv6IwYVAqrATE/iBOj1f1icLnlkVeE5lABF2dNROj3LG5q?=
 =?us-ascii?Q?8XTTLFKSc5tJZc/1M36HHYxXCmXLyxBjEgLT13rvsE7NezgQ5vJPHlmP+Tbh?=
 =?us-ascii?Q?tIXNo5g4kXiQ0LCr/y4AipP5ByXNzCp/7PhzaO+HBqn7nMqSvoWcWQ1vnuKK?=
 =?us-ascii?Q?m66MwJAWCctUtQd2QcDGfRJLV0F0BolW3T+LeBxAK8Je76FYvjONX9HmzqE/?=
 =?us-ascii?Q?2ziZv7OVbvfszTs5bDhxq+6IaNKbfkP6Wy2/qxedxxrsvbnX/ltuIDyThVuJ?=
 =?us-ascii?Q?3qFApM1ls9oiC/a3zdUhj1fGor/kcQKljtS0gLyTRYqvMxYnv0GzAhREYBeN?=
 =?us-ascii?Q?iRuCJyXYf4SAD3nv4MimhJgDmil/w3QyJF/xw4RZv2SwL4QrcBbUCUr4JeKl?=
 =?us-ascii?Q?bfHN9Fsg0jQU7n1eojv0JEBCu+4UQTzkXPtHZg/Nozbm9ZsEisKgENwa1Ae8?=
 =?us-ascii?Q?zhKX3NYw/MDIqXua5ZWNYq5UOxU3SQATaiO/GxekodU0iPHntn/Pb51RVkwH?=
 =?us-ascii?Q?oCTF+n/TOkgKRRURW9Dm+CdvjoPPtxW8R06xfZqXkk9PVvBB1IqxTw80hRNH?=
 =?us-ascii?Q?Yj0AnT6mtjWdILoKpdfN4cf2PcJsAyCxXmyTP2+0NrIQ2xN6CnnhzQxN4rSy?=
 =?us-ascii?Q?4tHlQvg9rVZ7Gxm/V4lQz7FzKv+2q2czvSzU2n7Dzn/YJ/SHd+6qj468EHeJ?=
 =?us-ascii?Q?BRBQp5Zkhhc9ZAWKA93Qi6zlpdkveTPksJ9jlCQl/xf0GCGeKe4OUHvRXFXy?=
 =?us-ascii?Q?LHQLHSJX2VxXFpjvnmqPMqSK48PnZxhKQ5ih3EwTu1B6RubZrN6ws0x+EkPQ?=
 =?us-ascii?Q?3q8LubHshX0vTe3ERYjA5vt0aq6EmcXny6Ol8enNrrH0JGtKRQ2XE9ET3252?=
 =?us-ascii?Q?6IZcXo7Vgv0wmkYh0eEHPXFu9VsD?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6506942c-7764-41a9-24b1-08d951d67dd9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 14:46:32.7213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZya8iW/Ac3cxcH5ExBudMWxXVGghbajNoh8OVh2X++oAFI4RajWohOxJ9hSLi3FO09dNDkWrpDpuHhlUVEvJV+4LIewbk2/GE6B/eSdfLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 09:51:00AM -0400, Jamal Hadi Salim wrote:
> On 2021-07-28 3:46 a.m., Simon Horman wrote:
> > On Tue, Jul 27, 2021 at 07:47:43PM +0300, Vlad Buslov wrote:
> > > On Tue 27 Jul 2021 at 19:13, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > > > On 2021-07-27 10:38 a.m., Vlad Buslov wrote:
> > > > > On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:
> 
> [..]
> 
> > > > > I think we have the same issue with filters - they might not be in
> > > > > hardware after driver callback returned "success" (due to neigh state
> > > > > being invalid for tunnel_key encap, for example).
> > > > 
> > > > Sounds like we need another state for this. Otherwise, how do you debug
> > > > that something is sitting in the driver and not in hardware after you
> > > > issued a command to offload it? How do i tell today?
> > > > Also knowing reason why something is sitting in the driver would be
> > > > helpful.
> > > 
> > > It is not about just adding another state. The issue is that there is no
> > > way for drivers to change the state of software filter dynamically.
> > 
> > I think it might be worth considering enhancing things at some point.
> > But I agree that its more than a matter of adding an extra flag. And
> > I think it's reasonable to implement something similar to the classifier
> > current offload handling of IN_HW now and consider enhancements separately.
> 
> Debugability is very important. If we have such gotchas we need to have
> the admin at least be able to tell if the driver returns "success"
> and the request is still sitting in the driver for whatever reason
> At minimal there needs to be some indicator somewhere which say
> "inprogress" or "waiting for resolution" etc.
> If the control plane(user space app) starts making other decisions
> based on assumptions that filter was successfully installed i.e
> packets are being treated in the hardware then there could be
> consequences when this assumption is wrong.
> 
> So if i undestood the challenge correctly it is: how do you relay
> this info back so it is reflected in the filter details. Yes that
> would require some mechanism to exist and possibly mapping state
> between whats in the driver and in the cls layer.
> If i am not mistaken, the switchdev folks handle this asynchronicty?
> +Cc Ido, Jiri, Roopa
> 
> And it should be noted that: Yes, the filters have this
> pre-existing condition but doesnt mean given the opportunity
> to do actions we should replicate what they do.

I'd prefer symmetry between the use of IN_HW for filters and actions,
which I believe is what Vlad has suggested.

If we wish to enhance things - f.e. for debugging, which I
agree is important - then I think that is a separate topic.

> [..]
> 
> > 
> > > > I didnt follow this:
> > > > Are we refering to the the "block" semantics (where a filter for
> > > > example applies to multiple devices)?
> > > 
> > > This uses indirect offload infrastructure, which means all drivers
> > > in flow_block_indr_dev_list will receive action offload requests.
> > > 
> 
> Ok, understood.
> 
> [..]
> 
> > > 
> > > No. How would adding more flags improve h/w update rate? I was just
> > > thinking that it is strange that users that are not interested in
> > > offloads would suddenly have higher memory usage for their actions just
> > > because they happen to have offload-capable driver loaded. But it is not
> > > a major concern for me.
> > 
> > In that case can we rely on the global tc-offload on/off flag
> > provided by ethtool? (I understand its not the same, but perhaps
> > it is sufficient in practice.)
> > 
> 
> ok.
> So: I think i have seen this what is probably the spamming refered
> with the intel (800?) driver ;-> Basically driver was reacting to
> all filters regardless of need to offload or not.
> I thought it was an oversight on their part and the driver needed
> fixing. Are we invoking the offload regardless of whether h/w offload
> is requested? In my naive view - at least when i looked at the intel
> code - it didnt seem hard to avoid the spamming.

There is a per-netdev (not global as I wrote above) flag to enable and
disable offload. And there is per-classifier skip_hw flag. I can dig
through the code as easily as you can but I'd be surprised if the
driver is seeing offload requests if either of those settings
are in effect.

> > > > I was looking at it more as a (currently missing) feature improvement.
> > > > We already have a use case that is implemented by s/w today. The feature
> > > > mimics it in h/w.
> > > > 
> > > > At minimal all existing NICs should be able to support the counters
> > > > as mapped to simple actions like drop. I understand for example if some
> > > > cant support adding separately offloading of tunnels for example.
> > > > So the syntax is something along the lines of:
> > > > 
> > > > tc actions add action drop index 15 skip_sw
> > > > tc filter add dev ...parent ... protocol ip prio X ..\
> > > > u32/flower skip_sw match ... flowid 1:10 action gact index 15
> > > > 
> > > > You get an error if counter index 15 is not offloaded or
> > > > if skip_sw was left out..
> > > > 
> > > > And then later on, if you support sharing of actions:
> > > > tc filter add dev ...parent ... protocol ip prio X2 ..\
> > > > u32/flower skip_sw match ... flowid 1:10 action gact index 15
> > 
> > Right, I understand that makes sense and is internally consistent.
> > But I think that in practice it only makes a difference "Approach B"
> > implementations, none of which currently exist.
> > 
> 
> At minimal:
> Shouldnt counters (easily correlated to basic actions like drop or
> accept) fit the scenario of:
> tc actions add action drop index 15 skip_sw
> tc filter add dev ...parent ... protocol ip prio X .. \
> u32/flower skip_sw match ... flowid 1:10 action gact index 15
> 
> ?
> 
> > I would suggest we can add this when the need arises, rather than
> > speculatively without hw/driver support. Its not precluded by the current
> > model AFAIK.
> > 
> 
> We are going to work on a driver that would have the "B" approach.
> I am hoping - whatever the consensus here - it doesnt require a
> surgery afterwards to make that work.

You should be able to build on the work proposed here to add what you
suggest into the framework to meet these requirements for your driver work.
