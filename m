Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B13674D8E
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 08:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjATHA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 02:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjATHAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 02:00:55 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32338A68;
        Thu, 19 Jan 2023 23:00:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKGy0d6JJjcN65CtG0xFdKdheOBiA00RyArUneMI8ry50RUWMyB68YEj52cGC+T9QvL1GW4G7ZuX8xGQbIq8xfjUpc7QPt7vv0+GFam0dNuNHkYqlbPTdman8ER56HoB+ciZZpWbVonMIUH8MrWf/e440940aw5m7I2b3upHsHu+QTPS9bCc1qM1R7AjeP4oGU4/oTJeeClGU1FxxlxHfPWjn/OICCD7qRkmJ9n1VYEwO9K3H/u9e6BHetL3ERm60n7+HcTJ20tArt6og9tRLgA66f4ZpowVVBd8o5/FLE7Gm3/y1EgBxaGa+YznBVCrqb8/p4Be/PkhX60rLMoDqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jmhg1jBwKuf2eA+0wGd6xWayE2KaUuFtXAOGh/R4hI8=;
 b=aqXNCRBSEqmEawFblUAXP7DW5t1pw/0rUlm7oELDJRryK3CQbMpsaOnO7l+baw4gMoGlz4HLFM740ldWdm4T7fOj9Pwm9n8EIL7b73PT8j/+HeoFhkf3qrkvl2WNYiwn9tqr+LjkZQg4km8YgIDp3A8fkAYAvZKAADYhyOFkZkVePHFoKgJcMUiP+ZzGwzKQyzoz4Vuxr9KcgeFifwAI+QKNNgV9PnlpENf+qIWy4HElah7xuzXtB8rZPfGGYKzeg0phd+ij8eXW4UTzXhUTudXPTu4H+gwPUlKAT/iQ5TRXhS57XTieWoAJb06dH8FLURtXEjRHH1OBT03m92Cp9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jmhg1jBwKuf2eA+0wGd6xWayE2KaUuFtXAOGh/R4hI8=;
 b=jGTEm1sXb/kbv4iVSkMybhScPRAy2ymKZqplYFhbH/hNdQJnxjhXc4Zuivwh8MOMKMr3xZTcOyMLxLQT2YJgO8klgydXxCMU5S71Xmz7MzRgkj4Fmc3RcH/3LRw3bYkB8j4TVL33/YFlrS+3HaZYAYORdorNJvLbjatedCREGdQQV637Pdu/b9UG8WnAT+2d79YZvX0csbC9KF4wmE9EI2D4R/iiEZToGuDSuq2Wraj8FQH9u8aV9kmWUe0NvxBs0iDY2jryDkTdKYKi+/cMlrvAJXoS1SE1YclmAGjs/fWE9apgW5zhT5SlOnxKROc0UZ3XCR9xb3rOwlxnvx7Izw==
Received: from DM5PR07CA0114.namprd07.prod.outlook.com (2603:10b6:4:ae::43) by
 BY5PR12MB4211.namprd12.prod.outlook.com (2603:10b6:a03:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 07:00:53 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::5) by DM5PR07CA0114.outlook.office365.com
 (2603:10b6:4:ae::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Fri, 20 Jan 2023 07:00:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Fri, 20 Jan 2023 07:00:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 23:00:40 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 23:00:36 -0800
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <Y8m4A7GchYdx21/h@t14s.localdomain> <87k01hbtbs.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <ozsh@nvidia.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 0/7] Allow offloading of UDP NEW connections
 via act_ct
Date:   Fri, 20 Jan 2023 08:57:16 +0200
In-Reply-To: <87k01hbtbs.fsf@nvidia.com>
Message-ID: <87fsc5bsh9.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT014:EE_|BY5PR12MB4211:EE_
X-MS-Office365-Filtering-Correlation-Id: 06ababcd-f922-4318-efe2-08dafab411eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHl+PW8G+qS4zxNieF8EbZq6A7phrp2vmnQ8kAwhWJ9zm4fr/+8WrMnBImDwJ2PryPgw+zlfPihlbcqM6uqnv4n6SbOLL3TxhsoctdyD02cXebhbJjO9FkXpjhpYURUJSkSrGRosnquEz+hast4H0f6+DUkhVY08uOVAb5nPubBCt4b1DI67lNGYbSTUHVXvUUsOq2ruT6mnWdFI6fu+j0KeyO8GeszDcs4pU2Tcg1lCyChRIinN9wocCj8cp9W7w6ExtECUw2jx3WFN3RY3ZNTeRQTridv+GTh3sn6uFbQrELmEYbNCjTRGE6N9PwBpalAdxDzceUTeXPRLhn8eSIauJP4hEetW8G5zQohEa1sB6OKY/jZzI8KKQaaq71HM+SRCNKUokeUl24jiajdeD1cDNRZmhM3/ZuXxEw5HiLMCvjRmQIIjrJRROxV+z0wKwgw2n5eHWW1dsSYCOde7yWVvEDk/K8aprc579Z2eMdwdWyMWNn62lzy0//RGBqFUv2XcmjQOTEXMKk1F2p7PNFghNkw2XMjJl4SVgA5G4RGhIB9a54FAaVtYkJ4FYqYCk3ncgxYSIsjioZl31r9soTpCh9VAHjYf00ki1wGXIvFfI/qlIsJOQddRXn9QxoyXahoLqFF3pEHjZUVMO//BmM8VnD/iEjO5Gcgg8jvT54Y=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199015)(36840700001)(46966006)(26005)(478600001)(2616005)(16526019)(186003)(6666004)(4326008)(336012)(83380400001)(54906003)(70206006)(8676002)(70586007)(6916009)(426003)(47076005)(316002)(7416002)(8936002)(5660300002)(41300700001)(2906002)(36860700001)(356005)(40480700001)(7696005)(82740400003)(86362001)(36756003)(82310400005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 07:00:52.6516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ababcd-f922-4318-efe2-08dafab411eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4211
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 20 Jan 2023 at 08:38, Vlad Buslov <vladbu@nvidia.com> wrote:
> On Thu 19 Jan 2023 at 18:37, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
>> On Thu, Jan 19, 2023 at 08:50:57PM +0100, Vlad Buslov wrote:
>>> Currently only bidirectional established connections can be offloaded
>>> via act_ct. Such approach allows to hardcode a lot of assumptions into
>>> act_ct, flow_table and flow_offload intermediate layer codes. In order
>>> to enabled offloading of unidirectional UDP NEW connections start with
>>> incrementally changing the following assumptions:
>>> 
>>> - Drivers assume that only established connections are offloaded and
>>>   don't support updating existing connections. Extract ctinfo from meta
>>>   action cookie and refuse offloading of new connections in the drivers.
>>
>> Hi Vlad,
>>
>> Regarding ct_seq_show(). When dumping the CT entries today, it will do
>> things like:
>>
>>         if (!test_bit(IPS_OFFLOAD_BIT, &ct->status))
>>                 seq_printf(s, "%ld ", nf_ct_expires(ct)  / HZ);
>>
>> omit the timeout, which is okay with this new patchset, but then:
>>
>>         if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
>>                 seq_puts(s, "[HW_OFFLOAD] ");
>>         else if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
>>                 seq_puts(s, "[OFFLOAD] ");
>>         else if (test_bit(IPS_ASSURED_BIT, &ct->status))
>>                 seq_puts(s, "[ASSURED] ");
>>
>> Previously, in order to be offloaded, it had to be Assured. But not
>> anymore after this patchset. Thoughts?
>
> Hi Marcelo,
>
> I know that for some reason offloaded entries no longer display
> 'assured' flag in the dump. This could be changed, but I don't have a
> preference either way and this patch set doesn't modify the behavior.
> Up to you and maintainers I guess.

BTW after checking the log I don't think the assumption that all
offloaded connections are always assured is true. As far as I understand
act_ct originally offloaded established connections and change to
offload assured was made relatively recently in 43332cf97425
("net/sched: act_ct: Offload only ASSURED connections") without
modifying the prints you mentioned.

