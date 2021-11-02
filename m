Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587204431C7
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhKBPf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:35:59 -0400
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:5536
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231725AbhKBPf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 11:35:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyKuSdlwWQi1jiryGSs0svQ4v0+BGfyuoDGA5toxkuDp+pVY2TZHACmKb2tWgOL0n0KX/QurZp0RvN64Yg3sOKND9UD0AlL5QlWgrlHtWBZiB8W5x/rg5WCY4CZiaK16Gl0BHFTw1pZoERx0AYnxfnbI4CYthL4lQdxTAwGxQmsqOhowMteEx8uygIAEnfsGQgyonEXh4573PhXBqV1k0w+xowWAcQZL4JQvExPjBtX1QwHFAQX+NE2Jh5PNKRHS3HJUZZ+wBCXaA2Z/a/C9+r2Kq+AGdUL5Iu1ys12F99I+xSDo5JpHAYpWFZiQADNxtNEWwzC26BCNqiKHWC5bKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MhwWJ6nb31moTOdTfjdiHkfPLbyvx3r4/4XwyizUqk=;
 b=UtXsbo9P+BFtGDo4rNSsvphNZPdALyjc+1MdiQQnCmdvXoqlEnuVZeTAb56Tb3TuGDrjagM6lfMwpIPbhtIiToE9x7mVmNKx/TpkjoExPc60xzfVXUjfN+ZnhLc3cfKPdkgD2G5ilCxCbXPB8/ZCHWx/X6jdpdOxmPoIHzqFnmCp57Shf5rBMc1qpBg7fCIv7OLt0A5n32DaoqjG9Vmo/Jd0bllPrGTfdCoYCT0sGy7AnkY3OjBooHc9Hbni5cTbIXNdK2ejJYOopmrK8nAubd1n7C/3wNut7FHmMTWSC6fTLyq9rtg0YNHP4bYewgoTugEvwN0dyFp7w7qfysVcSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MhwWJ6nb31moTOdTfjdiHkfPLbyvx3r4/4XwyizUqk=;
 b=sKUb4DKEbw8MgvEH7jMaW9pXq7cek4EZC+AhyBYk4hX7LqDYTgAqzSqV83mqF722u9i+SvIUJBh/m53SszrMUMSlpWraLyO1p73RsS25CpRC4kaUOUY7TF+jMFNpMmx6HhbfQao/4rXk33ppxL5iEL/9Hq0ob180Eu36AHYwA5xDV3Xdw3S9CKKDkq9rYhqLckRqJAqnQrxaWt5FtRczU2JIP0sLHW/xLZRPHysKc5Me5G0tXtel3jZ5K82SL6AKbs1S/wqTJ3lEiUSCZ3v5EuABFDSgie9wOYle0PwUsKLYduNXwLk8dNWPYgbdwxJMqG5OyxYIU8ARq1i35K/XKQ==
Received: from MWHPR22CA0012.namprd22.prod.outlook.com (2603:10b6:300:ef::22)
 by MWHPR12MB1151.namprd12.prod.outlook.com (2603:10b6:300:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Tue, 2 Nov
 2021 15:33:20 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::5f) by MWHPR22CA0012.outlook.office365.com
 (2603:10b6:300:ef::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Tue, 2 Nov 2021 15:33:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Tue, 2 Nov 2021 15:33:19 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 2 Nov 2021 15:33:16 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
 <cf86b2ab-ec3a-b249-b380-968c0a3ef67d@mojatatu.com>
 <ygnha6io9uef.fsf@nvidia.com> <20211102125119.GB7266@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Oz Shlomo <ozsh@nvidia.com>,
        <netdev@vger.kernel.org>, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
In-Reply-To: <20211102125119.GB7266@corigine.com>
Message-ID: <ygnhzgqm8tdx.fsf@nvidia.com>
Date:   Tue, 2 Nov 2021 17:33:14 +0200
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21a7ebc4-9399-48f6-2aeb-08d99e16190c
X-MS-TrafficTypeDiagnostic: MWHPR12MB1151:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1151F3B924FBD0BCE1008434A08B9@MWHPR12MB1151.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ugUxFZyVddYRN64wtHrX2MIZV8RIdl4ZSGLTLvLuxQYGujaEVJ8LyBE/Av4yp4qbZ8BCyfY8JLvWFLObwc1JP3pNs8ww9IdtnAgm347IDTPgBok3jeA3EzPm4OKOYFcKPx83Dfx5bed/9m7bn9Dr3aa1HQHuz10o3RCo4muY6gGYx73dom8dv9Ea049I3hbw1bgjgMdl/t9TVPpIh6z26PQMGrjOqKO0ZwVbua2Kvopr88KN4kgVGvtwWIWvIv6q/NE0QlNFEXBaBS4vNSM9PaBCSM1V1mSwcc5Jx/PrSJ9GNfoV+YmqbOVdtHbJyY/W0NP7Gy1UwidA0kGrTX6cNQya8fkC6c8aBydqVWxF6LtFL9j9SxhfMRMbF1oclTkV90VCo/DkPZFA94NA5xC4vw1utwd0JLX6DipbLYgGWH/jQ5RFAyIobQn5+y8X/MzUsxJidQyyr8JrGyHHmJeM3Q88ZpHVhN3iB8SANZikb+XKEPuq8C8J/pVA289rx/b56VRZJzUJFpOE09pKBMkBw7QrFzDQrySMqzcogV+aqq9K9qD0oTM9mm2DtvM8UcnXuSo5A7JoXFv9vI9pRrxHfmVCy/nm6ebW3hDAdLJ3vkXeIsltIWKHEutcBSQeZU5EF6nFHQIp3OPBKELMjksMiIJjpCDCVPmehFTeMzupE5o90q3x8jZ7iWwDt3INzZIAMHyZ+vYm3kTzhojd/8DCw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(426003)(8676002)(36756003)(2906002)(70586007)(2616005)(83380400001)(82310400003)(36860700001)(54906003)(8936002)(4001150100001)(508600001)(53546011)(16526019)(6916009)(186003)(356005)(5660300002)(336012)(47076005)(26005)(7696005)(4326008)(86362001)(7636003)(316002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 15:33:19.5173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a7ebc4-9399-48f6-2aeb-08d99e16190c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 02 Nov 2021 at 14:51, Simon Horman <simon.horman@corigine.com> wrote:
> On Mon, Nov 01, 2021 at 10:01:28AM +0200, Vlad Buslov wrote:
>> On Sun 31 Oct 2021 at 15:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> > On 2021-10-31 05:50, Oz Shlomo wrote:
>> >> 
>> >> On 10/28/2021 2:06 PM, Simon Horman wrote:
>
> ...
>
>> >> Actions are also (implicitly) instantiated when filters are created.
>> >> In the following example the mirred action instance (created by the first
>> >> filter) is shared by the second filter:
>> >> tc filter add dev $DEV1 proto ip parent ffff: flower \
>> >>      ip_proto tcp action mirred egress redirect dev $DEV3
>> >> tc filter add dev $DEV2 proto ip parent ffff: flower \
>> >>      ip_proto tcp action mirred index 1
>> >> 
>> >
>> > I sure hope this is supported. At least the discussions so far
>> > are a nod in that direction...
>> > I know there is hardware that is not capable of achieving this
>> > (little CPE type devices) but lets not make that the common case.
>> 
>> Looks like it isn't supported in this change since
>> tcf_action_offload_add() is only called by tcf_action_init() when BIND
>> flag is not set (the flag is always set when called from cls code).
>> Moreover, I don't think it is good idea to support such use-case because
>> that would require to increase number of calls to driver offload
>> infrastructure from 1 per filter to 1+number_of_actions, which would
>> significantly impact insertion rate.
>
> Hi,
>
> I feel that I am missing some very obvious point here.
>
> But from my perspective the use case described by Oz is supported
> by existing offload of the flower classifier (since ~4.13 IIRC).

Mlx5 driver can't support such case without infrastructure change in
kernel for following reasons:

- Action index is not provided by flow_action offload infrastructure for
  most of the actions, so there is no way for driver to determine
  whether the action is shared.

- If we extend the infrastructure to always provide tcfa_index (a
  trivial change), there would be not much use for it because there is
  no way to properly update shared action counters without
  infrastructure code similar to what you implemented as part of this
  series.

How do you support shared actions created through cls_api in your
driver, considering described limitations?

