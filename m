Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6513D895E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 10:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhG1IF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 04:05:58 -0400
Received: from mail-bn1nam07on2047.outbound.protection.outlook.com ([40.107.212.47]:25856
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234315AbhG1IF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 04:05:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJTZzUhDRzKgMlEez45B2+pjHMn0vnk8GZVQhZz9RMobQ5aX0BO5SFscczO2tutyhyakvnFhSYKm8nEn0LuDEupn5wr8+90CHUg0cmFW5dDvr19Aa4ccD6sM11MgkYntDRAvoYKhXGuTr445h3LiSOh6pq2MujlvqjLAiWKK/CWjlSzpKDaWHYwgFLjXMzjehfYDbdrmno+Pt3/jLnx7NkitSFzN0a97W1XGVlAXUKVJcLvCBP7QNADRNhB5olp1b8KnNtsDYAFA20wDz32KFy+af1ZxHSArg3itEkzqShF4LnY/oTROrOvrr7b/Cvs49CYfxefG3d+tiinQbdzK/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I37bd/mtKsowWwLDw5eKlUa3bnKCynE7bVbi6e8d9LY=;
 b=TAhmzBafu9O9cfrB1zKJSQhS5kbsH6UN+22pMHTJ5zAdkddss9wgozXYNPv2hHvSzs8mf1OmpNkkOcDHhG0KPmiurbJu5KSmyG/QU9VnQLEpiOgl2XEiahgI8+emQaWMT3rqdLbEUmAso+N96dlTeX1VTS3yWfnCWGEF2uH7JT3GmWR/kM5DjMl7clc7y6+q+OUeXJ3sfkZO12VD0KOYSNQd0I4zkIJ3z5qw0BxXilul2/QtPAqceDF0dppNbzWKeV5ACF9YZ25ZpXJLhCwxqtKykz/XmFe+8LuMzn1BeF9GbkQk8urTW6YZKVNC9kDyvuho01H+AqSn6DkqUPGeqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I37bd/mtKsowWwLDw5eKlUa3bnKCynE7bVbi6e8d9LY=;
 b=Kf4X2Obq7QjHLyIwVX33h0KLNlMMPgDMSxrGNowIoE+aC66TPNDcCSu9NrbREfyObWP3G0jEHUjLTLd98zFElOzw15TUmH3Ned385/4EV9pkxnkXx1ddMoJADEdvuitMcT5ms5QBWwvcUPU93kbQTudPNQuyUIZYwjpOwwUYebuHwnUWzkZzvwHNBKmbK8chJMC3OTXhJGNHV7C6LbOvBwGd7bgEJ0wnPT6uN8jpQYvlKhsjoQiPNU5tTKvCKg22yQwV8MC4/YmewoE5usldfYJMlBXm6VgEkJv7aOAehxknAdFRyaabyIul/ZQHDGkBmoO3shQMMmdlfcnOJdvzzw==
Received: from DM6PR03CA0064.namprd03.prod.outlook.com (2603:10b6:5:100::41)
 by DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Wed, 28 Jul
 2021 08:05:54 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::ce) by DM6PR03CA0064.outlook.office365.com
 (2603:10b6:5:100::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Wed, 28 Jul 2021 08:05:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 08:05:54 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 28 Jul 2021 08:05:51 +0000
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Louis Peens" <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
In-Reply-To: <20210728074616.GB18065@corigine.com>
Date:   Wed, 28 Jul 2021 11:05:48 +0300
Message-ID: <ygnh1r7irhgj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e02b8c6-1f70-4c2d-2593-08d9519e85e2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4403:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4403C5E3083726D2EBA8596AA0EA9@DM6PR12MB4403.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vilNipHBD6YQOz5pJ+0kmjUeo9uMqc7UaitCCGtrxFLq+xUbsIUGy1L5kqpGPYoyid4ZN5niobo9/8TUdcGnyZImakCdl3UE0k+8Lmt1ZqBlsV/0vukKe8D6SpexpWQz98ZlN8aJkjeAwadHqWeO1UX8Wtj5Y6gPhL9PDKC8YKdt4mfs+5cxbPyhyB7kkT+btS/wdfjRNh+7cPJWrWpWdDM6u4pqnDmoWmGOpJquN/B6L2xlh2PytFYL9Rl/Rj71GbyMVgU4tG5vXjdEmM2mjuLZ39Gz13mezc5WS/XYaMxmFyOyskU0qm5kg3D/RVArtZZfVWWbR+37o9JU5no1nFMu8he1PngUOTBVYZtdzrpADndlPMbsJExQShFwZkEiB6ln6MidVFiIvLQBsEwrIcCwd8kVyfZtvJuhq7k8tBjj9j3jFuOa5xbxcz+VDPM2//83AAecSBECYNzzvYAq7Mo9cktdnlvXA9qA+nyujZqLJpktKtBo7SrnilikNs8iI80BeO4uB8xHeI+LI8Ej7Q28q3/+BvAoIB371P3+XJCee5A4H/Ikj23GGctGCGqBgANpw6/57JNQqc7SSlAoUMty0dCvtpAW2DEt8Czv2NuaIla9hcPeCgiHH6ePDkU+NF7VbHZpln8Dj+Ax8aL3oW8idR0p2tAKNSn4TpkKkg2ruhBv0QyXuD9Lo2Avo4imNJiamv+GSHT+PZOooJ0ziA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(53546011)(508600001)(8936002)(70206006)(70586007)(426003)(16526019)(86362001)(7636003)(7696005)(36860700001)(26005)(186003)(2616005)(8676002)(83380400001)(356005)(2906002)(54906003)(47076005)(5660300002)(36906005)(316002)(6916009)(82310400003)(36756003)(336012)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 08:05:54.1369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e02b8c6-1f70-4c2d-2593-08d9519e85e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 28 Jul 2021 at 10:46, Simon Horman <simon.horman@corigine.com> wrote:
> On Tue, Jul 27, 2021 at 07:47:43PM +0300, Vlad Buslov wrote:
>> On Tue 27 Jul 2021 at 19:13, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> > On 2021-07-27 10:38 a.m., Vlad Buslov wrote:
>> >> On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:
>> >
>> >>>>
>> >>>> Also showing a tc command line in the cover letter on how one would
>> >>>> ask for a specific action to be offloaded.
>> >>>
>> >>> In practice actions are offloaded when a flow using them is offloaded.
>> >>> So I think we need to consider what the meaning of IN_HW is.
>> >>>
>> >>> Is it that:
>> >>>
>> >>> * The driver (and potentially hardware, though not in our current
>> >>>    implementation) has accepted the action for offload;
>> >>> * That a classifier that uses the action has bee offloaded;
>> >>> * Or something else?
>> >> I think we have the same issue with filters - they might not be in
>> >> hardware after driver callback returned "success" (due to neigh state
>> >> being invalid for tunnel_key encap, for example).
>> >> 
>> >
>> > Sounds like we need another state for this. Otherwise, how do you debug
>> > that something is sitting in the driver and not in hardware after you
>> > issued a command to offload it? How do i tell today?
>> > Also knowing reason why something is sitting in the driver would be
>> > helpful.
>> 
>> It is not about just adding another state. The issue is that there is no
>> way for drivers to change the state of software filter dynamically.
>
> I think it might be worth considering enhancing things at some point.
> But I agree that its more than a matter of adding an extra flag. And
> I think it's reasonable to implement something similar to the classifier
> current offload handling of IN_HW now and consider enhancements separately.
>
>> >>> With regards to a counter, I'm not quite sure what this would be:
>> >>>
>> >>> * The number of devices where the action has been offloaded (which ties
>> >>>    into the question of what we mean by IN_HW)
>> >>> * The number of offloaded classifier instances using the action
>> >>> * Something else
>> >> I would prefer to have semantics similar to filters:
>> >> 1. Count number of driver callbacks that returned "success".
>> >> 2. If count > 0, then set in_hw flag.
>> >> 3. Set in_hw_count to success count.
>> >> This would allow user to immediately determine whether action passed
>> >> driver validation.
>
> Thanks, that makes sense to me.
>
>> > I didnt follow this:
>> > Are we refering to the the "block" semantics (where a filter for
>> > example applies to multiple devices)?
>> 
>> This uses indirect offload infrastructure, which means all drivers
>> in flow_block_indr_dev_list will receive action offload requests.
>> 
>> >>> Regarding a flag to control offload:
>> >>>
>> >>> * For classifiers (at least the flower classifier) there is the skip_sw and
>> >>>    skip_hw flags, which allow control of placement of a classifier in SW and
>> >>>    HW.
>> >>> * We could add similar flags for actions, which at least in my
>> >>>    world view would have the net-effect of controlling which classifiers can
>> >>>    be added to sw and hw - f.e. a classifier that uses an action marked
>> >>>    skip_hw could not be added to HW.
>> >
>> > I guess it depends on the hardware implementation.
>> > In S/W we have two modes:
>> > Approach A: create an action and then 2) bind it to a filter.
>> > Approach B: Create a filter and then bind it to an action.
>> >
>> > And #2A can be repeated multiple times for the same action
>> > (would require some index as a reference for the action)
>> > To Simon's comment above that would mean allowing
>> > "a classifier that uses an action marked skip_hw to be added to HW"
>> > i.e
>> > Some hardware is capable of doing both option #A and #B.
>> >
>> > Todays offload assumes #B - in which both filter and action are assumed
>> > offloaded.
>> >
>> > I am hoping whatever approach we end up agreeing on doesnt limit
>> > either mode.
>> >
>> >>> * Doing so would add some extra complexity and its not immediately apparent
>> >>>    to me what the use-case would be given that there are already flags for
>> >>>    classifiers.
>> >> Yeah, adding such flag for action offload seems to complicate things.
>> >> Also, "skip_sw" flag doesn't even make much sense for actions. I thought
>> >> that "skip_hw" flag would be nice to have for users that would like to
>> >> avoid "spamming" their NIC drivers (potentially causing higher latency
>> >> and resource consumption) for filters/actions they have no intention to
>> >> offload to hardware, but I'm not sure how useful is that option really
>> >> is.
>> >
>> > Hold on Vlad.
>> > So you are looking at this mostly as an optimization to speed up h/w
>> > control updates? ;->
>> 
>> No. How would adding more flags improve h/w update rate? I was just
>> thinking that it is strange that users that are not interested in
>> offloads would suddenly have higher memory usage for their actions just
>> because they happen to have offload-capable driver loaded. But it is not
>> a major concern for me.
>
> In that case can we rely on the global tc-offload on/off flag
> provided by ethtool? (I understand its not the same, but perhaps
> it is sufficient in practice.)

Yes, the ethtool should be sufficient. Didn't think about it initially.
Thanks!

>
>> > I was looking at it more as a (currently missing) feature improvement.
>> > We already have a use case that is implemented by s/w today. The feature
>> > mimics it in h/w.
>> >
>> > At minimal all existing NICs should be able to support the counters
>> > as mapped to simple actions like drop. I understand for example if some
>> > cant support adding separately offloading of tunnels for example.
>> > So the syntax is something along the lines of:
>> >
>> > tc actions add action drop index 15 skip_sw
>> > tc filter add dev ...parent ... protocol ip prio X ..\
>> > u32/flower skip_sw match ... flowid 1:10 action gact index 15
>> >
>> > You get an error if counter index 15 is not offloaded or
>> > if skip_sw was left out..
>> >
>> > And then later on, if you support sharing of actions:
>> > tc filter add dev ...parent ... protocol ip prio X2 ..\
>> > u32/flower skip_sw match ... flowid 1:10 action gact index 15
>
> Right, I understand that makes sense and is internally consistent.
> But I think that in practice it only makes a difference "Approach B"
> implementations, none of which currently exist.
>
> I would suggest we can add this when the need arises, rather than
> speculatively without hw/driver support. Its not precluded by the current
> model AFAIK.

