Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7B667940F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 10:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjAXJXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 04:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjAXJXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 04:23:11 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E77844AF;
        Tue, 24 Jan 2023 01:22:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdGwtVHSPKVvi2Ntg88yGV+CHINk/VN3/Jb6pEZ35+GMVz/enSNy/zZkqM4T/Ox8kSqouzfDL8TPIq0Hlzb78HpT/tLJV/1erd+zy8pbTr3aZUlYjaNEwr4vlL+wtXX5Z+beR9wzKd5B5c3tj3iLlXHbsd1vCWZnW5Pm5omPlDHiEUUULFfa8Ktywd4ca77NgaJt8MYL9WACqrDevUeu2d/ZPEv2XiFsFmVNnvP62K2eEbAc2Eil9+vntendgkhkCnxEzp8EuuB9nLbRg+in9t5ze+TPaV55o3K3jW6qdinMAU64LG/XSbr2AIvzLrsyJuHglUoQybWrm0YTpSpOaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpUslIl3J660NWV2GFfdLpOcEEl0xOVjiLdet37EvBs=;
 b=QgFNqGyHhHSwhvld6FIttC0OrNpbu3wFRaoFw/BLbZIxGfXOD9joOFPpjW3PP5n1Hay5augT8RV9//hk4DEv6TlM7TN0mZIl9LKil4+g8JICWFvcQyLGJPCHl4+s0eYa9yuKSND4OQDSyR8MaU2TPh/L3SJSSlerJCfm3Ns8vYZ+7EAeOuf67hODXdwp4QNiQEM86lUY37N3jp33HkJzlEhM4K9+kpBFZYdEjJ8RKIWeR9ZXyriIaPYjvIsNIQFPXViBH+xH87LQxSrcZfUa7ufdK6xYyXFFRpllSTDIUAkBNvlk5V5Wzp2Sfbw/Vo74i5Tfu4x7NQ3Qrf7EsA04ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpUslIl3J660NWV2GFfdLpOcEEl0xOVjiLdet37EvBs=;
 b=J6c8MgR6QYDa+FqsYaxeoWgh3GCYzxZImzkI3ENBweyixJllkrHvC9/u2d79SVSegPvMD6DPSuMSbi7GwlhJRziAR9tVejOZ1pUDhRC5kaKxZH44H+WzQAGjYyD4EUldM/G1jW/9RrBa72Cdv4LHObm8EuFtGJME1mSNCw4LTtuiKHURLT1bo52uUhOfUEmMTLoBWkN2iXQuJK2+cz9qCUu3Fglb1V/+OMffagkOklIQ/QZo+41em6IB5DVNU1A6akBeoK1VspwLxYYopTzqTZcRD7sRWzu9yeK8gx0xM1WEEarWy3YYm/w9Ov12A8jHPtvCSZv7/G/blYC/Jf/J1A==
Received: from BN9PR03CA0447.namprd03.prod.outlook.com (2603:10b6:408:113::32)
 by MN2PR12MB4359.namprd12.prod.outlook.com (2603:10b6:208:265::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 09:22:34 +0000
Received: from BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::7b) by BN9PR03CA0447.outlook.office365.com
 (2603:10b6:408:113::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 09:22:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT090.mail.protection.outlook.com (10.13.177.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 09:22:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 01:22:16 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 01:22:13 -0800
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <20230119195104.3371966-5-vladbu@nvidia.com> <Y8p96knLDtxnRtjz@salvia>
 <871qnke7ga.fsf@nvidia.com> <Y8+Zny8S9BQm7asq@salvia>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 4/7] netfilter: flowtable: allow updating
 offloaded rules asynchronously
Date:   Tue, 24 Jan 2023 11:19:31 +0200
In-Reply-To: <Y8+Zny8S9BQm7asq@salvia>
Message-ID: <87sfg0cmnw.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT090:EE_|MN2PR12MB4359:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b920856-0f02-46c8-5adb-08dafdec86a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cx5/OX78RuAZQTUNlPm7cQNcLp8YPAjy9aDhTHnmKfbu0uiNr6UAK30Gn2jcZJGJl4k/PCHgqo9zDxnD9BNqTytoodwXmoR2QkgFseYVUgNW0usB+hiks5NfSrO0ZXCpc6eV4I+ELmvoMTbdDnTjxHWN/HrhMhhyvZpiHDCOn02KNbIeCCfc4kkdSa1MnnkNcqNaKkhByx71GFZVR4jIkyYqEPzFZ6YNcUNp2NYvd9RGKTTGW4t6kB+9ISm3DsRBQxNadZNxOe7eU5EEyFhaHg6HVsJw3lWhW8YQrOsI1cw3/+EBMcRXvpoQF9mWKRv7AoQn+1+S8kq4sM28Wth8zXQF5zdRgM5RbimnMTDHPnCsRDFJkfVXxWtlTn8anbWDFDSV+brBes9yZ8+s/vyIYW+0AE33aQs43jgVDw7DecH7hV2+aMm8ExDaGncGchYoMZjddQqd7v1JF/yeXDMkDn1RtCkXA7KXiSOdkSNBHtJN/sbklinPSxqrMA5wAAqgGs2Fg5jVh9IYqDO7yXfVQq6sz8pwpw4FONxRveyW2rztBpKVM2pXhIXxjNkilgj6GhosPP13OxUHAi0ToMA24Uk7ZMwlLkLPG934fIhcGznmGxPq1chegKg7SqVwhATgUh+WHsjljAicZuOch0Apf16xEfNvUpNleQDNrWn9N4ZWKjau5jQqMkFj+WvipV0VKXu7ebP51r54k3K8rvSAwA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(83380400001)(82740400003)(86362001)(356005)(7636003)(2906002)(5660300002)(8936002)(41300700001)(4326008)(7416002)(82310400005)(186003)(40460700003)(40480700001)(16526019)(6916009)(8676002)(26005)(316002)(47076005)(336012)(6666004)(426003)(70586007)(70206006)(2616005)(54906003)(478600001)(7696005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 09:22:33.7080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b920856-0f02-46c8-5adb-08dafdec86a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4359
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 24 Jan 2023 at 09:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Vlad,
>
> On Tue, Jan 24, 2023 at 09:06:13AM +0200, Vlad Buslov wrote:
>> 
>> On Fri 20 Jan 2023 at 12:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > Hi Vlad,
>> >
>> > On Thu, Jan 19, 2023 at 08:51:01PM +0100, Vlad Buslov wrote:
>> >> Following patches in series need to update flowtable rule several times
>> >> during its lifetime in order to synchronize hardware offload with actual ct
>> >> status. However, reusing existing 'refresh' logic in act_ct would cause
>> >> data path to potentially schedule significant amount of spurious tasks in
>> >> 'add' workqueue since it is executed per-packet. Instead, introduce a new
>> >> flow 'update' flag and use it to schedule async flow refresh in flowtable
>> >> gc which will only be executed once per gc iteration.
>> >
>> > So the idea is to use a NF_FLOW_HW_UPDATE which triggers the update
>> > from the garbage collector. I understand the motivation here is to
>> > avoid adding more work to the workqueue, by simply letting the gc
>> > thread pick up for the update.
>> >
>> > I already proposed in the last year alternative approaches to improve
>> > the workqueue logic, including cancelation of useless work. For
>> > example, cancel a flying "add" work if "delete" just arrive and the
>> > work is still sitting in the queue. Same approach could be use for
>> > this update logic, ie. cancel an add UDP unidirectional or upgrade it
>> > to bidirectional if, by the time we see traffic in both directions,
>> > then work is still sitting in the queue.
>> 
>> Thanks for the suggestion. I'll try to make this work over regular
>> workqueues without further extending the flow flags and/or putting more
>> stuff into gc.
>
> Let me make a second pass to sort out thoughts on this.
>
> Either we use regular workqueues (without new flags) or we explore
> fully consolidating this hardware offload workqueue infrastructure
> around flags, ie. use flags not only for update events, but also for
> new and delete.
>
> This would go more in the direction of your _UPDATE flag idea:
>
> - Update the hardware offload workqueue to iterate over the
>   flowtable. The hardware offload workqueue would be "scanning" for
>   entries in the flowtable that require some sort of update in the
>   hardware. The flags would tell what kind of action is needed.
>
> - Add these flags:
>
> NF_FLOW_HW_NEW
> NF_FLOW_HW_UPDATE
> NF_FLOW_HW_DELETE
>
> and remove the work object (flow_offload_work) and the existing list.
> If the workqueue finds an entry with:
>
> NEW|DELETE, this means this is short lived flow, not worth to waste
> cycles to offload it.
> NEW|UPDATE, this means this is an UDP flow that is bidirectional.
>
> Then, there will be no more work allocation + "flying" work objects to
> the hardware offload workqueue. Instead, the hardware offload
> workqueue will be iterating.
>
> This approach would need _DONE flags to annotate if the offload
> updates have been applied to hardware already (similar to the
> conntrack _DONE flags).
>
> (Oh well, this proposal is adding even more flags. But I think flags
> are not the issue, but the mixture of the existing flow_offload_work
> approach with this new _UPDATE flag and the gc changes).
>
> If flow_offload_work is removed, we would also need to add a:
>
>  struct nf_flowtable *flowtable;
>
> field to the flow_offload entry, which is an entry field that is
> passed via flow_offload_work. So it is one extra field for the each
> flow_offload entry.
>
> The other alternative is to use the existing nf_flow_offload_add_wq
> with UPDATE command, which might result in more flying objects in
> turn. I think this is what you are trying to avoid with the _UPDATE
> flag approach.

This looks interesting, but is very ambitious and will probably be a
bigger change than this whole series. I have an idea how we can leverage
existing 'refresh' mechanism for updating flow state that doesn't
involve large-scale refactoring of existing offload infrastructure,
which I would prefer to try first. WDYT?

