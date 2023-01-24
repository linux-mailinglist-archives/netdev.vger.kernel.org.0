Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA04679199
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjAXHIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjAXHIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:08:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830486194;
        Mon, 23 Jan 2023 23:08:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYTspU9a2xtuS6eWRqrVosE9V6VJgLHDDvj9f4aXzLLB3eD2iO4F9UD8oqVaapmr64to+SgdDtELrbrlpVnsk18b5+WBgbuFz+rz17uEh7+WsHaln3wWw9yOrkg5GtGzDzKEjw9O8aTDgbQ6Rx3kZbgJNgPRc5na8K2AA/gCL152HuwbdThjVh+4A6LdWOWQXbwjJELobgBb+zj5CTfS4s+HevJ6BsQEZ/GX+B2RE8dvpHQmg0TnKFdrCErzQB1KGEcO67WkQDgFOL/JUUcXzxUfswug53DJ7E3TJYMOXNeIfSQBjgvq6I5xmC5FyFsvdgtsutukJzc733S4OeWZgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHbvwMABGCasvTkmorglDgz0+wQrMEKAm9S5Sr+JZr4=;
 b=jUUgl2VFQqxBIdF5rJCKcPFxM6QsvrEN3JDpmOw1oz+M9KHb9nXM9KpEZE/hXqeFBIobOUSsu3EDlIf6qAFvMDAksRDWlFHhOxThcraTZpDyScgxiE/mY5yUv/YPmAiP1DNFXgnLWUbH1CXjfb+3G1JCGZ8vF/EA6bkaCby9v1YAGsQiQ32iT1el112xlajQqwePwgt4tEEdWyTF2dE3ODlAQUgSb+ShTVHBd7IlAiwPgyytio8CO9dA+YrqKsv+3yyX2f5aIbizqvx7K/9NdUadJWagnhHZcUVfw8A9q/3MSobsLQPeNTXVEO5AlY4X1kEMdkqIoN4LGD3zbnv4DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHbvwMABGCasvTkmorglDgz0+wQrMEKAm9S5Sr+JZr4=;
 b=X4W7d30mEr959XH0u5XSofkgE03QajTFjl/14Xa4ry2hNu0Z8HNiZYqk9QGnjyia+8Xx1Zesj0be7b35NWQ1TXB5PKzZBMRaogy9kE/fysG2XBx5jz2xjNuJ9qAhmLs02Tq5znFccD2My7nv6Rg9T6CA6MLnfSGhNOrwAZ4D3zxB3fQy9M44nJYqh2G45fcWnNLVEMLTWWbg1xun8alaFtGBizgtYAlh6h0YzNE7mvwOsnnVQCcYHnsQwjYiMLyBNlAKAgHU41QXJI9RYr0ys2e8+N27gScaM9RhtkiofxcCEs3lOkSFnPA+gNTpxXKbKGzJBBqYKc+hmMHGn/SH3A==
Received: from DM5PR07CA0058.namprd07.prod.outlook.com (2603:10b6:4:ad::23) by
 PH7PR12MB7939.namprd12.prod.outlook.com (2603:10b6:510:278::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 07:08:12 +0000
Received: from DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::c4) by DM5PR07CA0058.outlook.office365.com
 (2603:10b6:4:ad::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 07:08:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT089.mail.protection.outlook.com (10.13.173.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 07:08:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 23:07:55 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 23:07:52 -0800
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <20230119195104.3371966-5-vladbu@nvidia.com> <Y8p96knLDtxnRtjz@salvia>
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
Date:   Tue, 24 Jan 2023 09:06:13 +0200
In-Reply-To: <Y8p96knLDtxnRtjz@salvia>
Message-ID: <871qnke7ga.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT089:EE_|PH7PR12MB7939:EE_
X-MS-Office365-Filtering-Correlation-Id: 30a3cb7f-13c2-4026-5686-08dafdd9c09e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZLFVRkjpBQvhGTHwQEHE1GW8xgsnnEdgiyfM281hxXwEIRvPiKYVxdGGtIYKdcSHenr7AsdQHwnppZCjh9ZglR+L/CrSgIivo/1OPkB6d1hOJ0eUbzY+s+aSTD2yizJ8bgLW8S1NlLcnbjBmTXss0m6QJ4iVd2bRZlI5YrIWmgrqctm06HtKfzAETPEyPGcODNCyYMYEtqsHCtmgAbM3HlnIMaXm2O+xFPcrPbBNYlfqfbQFJCM+QYENHHxexIQ/uLXt+mh0786+8/QWoAycEtPCIQUBjtpK+n+IKEluzi5W3SpZc6qBlPaNURuNePRtVUepgLK/DExXPrzOh2OBZbBq7PCalV+YeMTk4NYIav3C/BFz3RIHTaClI+r51S32gk2a0S9BEn2wW/GerHuZpXDXsE94OQQ1SQ/uD7SEzgMjuPoBr7nn2kYlh5q6weKGCWM9A/CtmHokljsHdQWGBGbkCu7+tBzSv4cFnVbPAnZA+IYlldXeuKKr0vlObagVhHsFxRs9k/BkuHgEPdmCmGmUUpsaCJp8I7ZIx3E9QSXE7QGfHWDSK+cLveHz3g/Ida+JO9gcGNIUaaxAh6bCuaIY/oBuhgmCVK/SJWBvzDRs5Ox2KhQNmdbWLJ4SwCRaFbhDUT9a8aMv4ZXjqc0XLJ7vec+vV4XR/00kCyDJ13ZuRL/R8+H8IdwFl3qsLRAX+ww7X4fT8jDUkkoafOuTg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(426003)(47076005)(36860700001)(83380400001)(2616005)(186003)(478600001)(8676002)(26005)(6666004)(336012)(82740400003)(16526019)(356005)(86362001)(7636003)(8936002)(40480700001)(5660300002)(2906002)(7416002)(82310400005)(70586007)(316002)(4326008)(41300700001)(70206006)(6916009)(7696005)(40460700003)(54906003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 07:08:10.5492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a3cb7f-13c2-4026-5686-08dafdd9c09e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7939
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 20 Jan 2023 at 12:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Vlad,
>
> On Thu, Jan 19, 2023 at 08:51:01PM +0100, Vlad Buslov wrote:
>> Following patches in series need to update flowtable rule several times
>> during its lifetime in order to synchronize hardware offload with actual ct
>> status. However, reusing existing 'refresh' logic in act_ct would cause
>> data path to potentially schedule significant amount of spurious tasks in
>> 'add' workqueue since it is executed per-packet. Instead, introduce a new
>> flow 'update' flag and use it to schedule async flow refresh in flowtable
>> gc which will only be executed once per gc iteration.
>
> So the idea is to use a NF_FLOW_HW_UPDATE which triggers the update
> from the garbage collector. I understand the motivation here is to
> avoid adding more work to the workqueue, by simply letting the gc
> thread pick up for the update.
>
> I already proposed in the last year alternative approaches to improve
> the workqueue logic, including cancelation of useless work. For
> example, cancel a flying "add" work if "delete" just arrive and the
> work is still sitting in the queue. Same approach could be use for
> this update logic, ie. cancel an add UDP unidirectional or upgrade it
> to bidirectional if, by the time we see traffic in both directions,
> then work is still sitting in the queue.

Thanks for the suggestion. I'll try to make this work over regular
workqueues without further extending the flow flags and/or putting more
stuff into gc.

>
> I am sorry to say but it seems to me this approach based on flags is
> pushing the existing design to the limit. The flag semantics is
> already overloaded that this just makes the state machine behind the
> flag logic more complicated. I really think we should explore for
> better strategies for the offload work to be processed.

Got it.

