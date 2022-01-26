Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B83049CA2D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiAZM6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:58:04 -0500
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:25441
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234510AbiAZM6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:58:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GS4oYzNkAqGPaz8waxPVjdQ4tnFqKnFNa5cRVM3OUB/7CCVpLf1ySGvZGe4CSASmi6KvrDCTLhJDp8K/S9oGqMFWarbSMbftdoOoV2SVU/zy7J1v/01Io+nMxkS1vpyFIqnlz9+q3i5DQ60/ATi209AGkPq52VsguOW5czrpfknMb+vGo3A9Orj0psD3Vb3IZbSRF6vDVo0VRISd9nmrydIb/eprASXls42IVKATDVUB+e28nnVjrsPUmKyC37SkjPk3Iirx/goYyjbzDT3e5NQ6jIYTtwPetHt/eYc3LfvhnXEnH6Tw1+W4xFzfn15bgvdMkxBUFiLEmKdvgUQwoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5Nz+weztsxqNtseGvuqcM3uggXGy7JfxOmg5p4YAIY=;
 b=TO/GPgY7FKhpgli70XSlYElwPdr5jGa0LuUF3cqz/Vu4DjfK2ySN5c5/gWhCzZ8Vya7ZLn93JjUPeOkikVwpcx4yCLXf7vCJOeVa6LPnx4CoS9bBeCeamC2jMacvV2wdHS4YSEkcQeHxNfVmZ3zj5GWm7E+fCwq75zAltPUw2xD8+3yOyAkUtBjwyfeoBSuaiFceZGLZxNBR567FhVS2iPMOlLj6sYs7gO4i55IrFcc3CWmUWQLHFTSsGhyMZfcK7c7lL5oqy2BafXEFCdSdvTW4DI/i08Hqx5wq+5eEJv05Bf7+4SEMGRFwwQyqnokJTm9+qsacWsm2MvoAsAz8vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5Nz+weztsxqNtseGvuqcM3uggXGy7JfxOmg5p4YAIY=;
 b=izrZUBQpP5x/2BXBuxSepXwBwSl7dAzu2isRczfTdZbHQqcMj5y652aI56TJSDozS4JNtACdhcF5tWWJftoVYiHVoGb40qv28tTYoiKw6NN2Uu9JvnAYXTJzU+s9B9/okFMU9JlpfaY6kJySGVkGokZSatyfSv2CkbUDTm+HzEWS0YshvoChL5eUhfPMhIbrk7+ceBVgQgp6YU9e8T/E9fqmvG5Pe6/Y3gAYiEhIkUacrcIazKCPcqq25dohT1cF1FSdx1R+GMVsfZrsFSR5KKMzDf1cvDoNu30VOoRSmXqBeQcCUGz8xrx7tGc9LuPqtxKxDt7DsHQYGTXI29uW8w==
Received: from MWHPR22CA0064.namprd22.prod.outlook.com (2603:10b6:300:12a::26)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 26 Jan
 2022 12:58:02 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::70) by MWHPR22CA0064.outlook.office365.com
 (2603:10b6:300:12a::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Wed, 26 Jan 2022 12:58:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Wed, 26 Jan 2022 12:58:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 26 Jan
 2022 12:58:00 +0000
Received: from [172.27.15.168] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 26 Jan 2022
 04:57:52 -0800
Message-ID: <499142da-2b16-4d94-48b0-8141506e79e3@nvidia.com>
Date:   Wed, 26 Jan 2022 14:57:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <lorenzo.bianconi@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <dsahern@kernel.org>, <komachi.yoshiki@gmail.com>,
        <brouer@redhat.com>, <memxor@gmail.com>,
        <andrii.nakryiko@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "Ido Schimmel" <idosch@idosch.org>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
 <YfEwLrB6JqNpdUc0@lore-desk>
 <113d070a-6df1-66c2-1586-94591bc5aada@nvidia.com> <878rv23bkk.fsf@toke.dk>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <878rv23bkk.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail202.nvidia.com (10.126.190.181) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9860e02f-277a-4312-c974-08d9e0cb7c02
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB536225230EB65B1F36143033DF209@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wy00DgqEotIYCREZ40xQ6VVC4VML36FdMmWFrlOONcohuXh27V15SG0awZiiniSw9GKfIaHhR1tgNeKQnv9O9C5yEzvGvhfNPzqAmJTOt9wzSwB9314yH3WKsOJRahkYDK19pSD6z5jklKn4StXCOGeR215BfBkvS5kndsNnTYU69yxXuYqpHaB6+Tlzv6dKOKbUa3zeVc/+YRiF0AYvvKK/sZ5WYF7TJ7ha0ZGvZlHgqFiHhU6WfhJKzZgKA4ZAS6XIv8Qo8YGvgJrJBLXjSsKNo/ixaA95/yGh5ND9Hghqq+jULlM6g+YEylQCSVhhr0o3mLkIIyu9F7fxw1jRmr8dfrZEJlE5/GsmCEWHslqwg0Tiyw15L11zDEUTt1+2egQ5On1F1dL2l9Wm4j2QbC4bwexnTcqegTDWJJJo/g/ZrDM7YJpw1UL3RdDPGNAtRUQL5eOhAtWjxvnkOHYKEpyDDJD5Nz7cIUSh79QHqyJP1VGblIoJI5aztCdsf9c/a39F1Do1l7EwOm4jdUJ9nJjzhZfbxs+yaamg/vrXnJ+zZOTToblpPwdp2BNQCjXJnas/h9iPXL7yXmIA4YlN/jtcs3DlPLJEZfCUhX0ysa7axLkCa5Ymxcyw5Y6AazUtQ0SAdErBt8BFN07zxptIEYT45o9t5J4+3BYaAC2KlYwZK6XKy4uVp8ENQBZXFspb6wcSRSGogTYg5KH+wrE4PTjjFF5Yx68WgcqSNAzXUj5vlfHgDPMe1FrhK6cisiRn9ainF/HYs7mv4BTBT95K0+oM4IIB9yIG/61hOCaQKnH8zw/WHGrr2JoevmfQzPe0WAcaIvQb2EU0ad5egPtyEA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700004)(36840700001)(508600001)(2906002)(8936002)(8676002)(6666004)(36756003)(316002)(7416002)(53546011)(5660300002)(36860700001)(70206006)(186003)(31696002)(110136005)(2616005)(336012)(86362001)(356005)(66574015)(26005)(54906003)(70586007)(31686004)(16576012)(40460700003)(16526019)(81166007)(82310400004)(47076005)(83380400001)(4326008)(426003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 12:58:01.1769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9860e02f-277a-4312-c974-08d9e0cb7c02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2022 14:50, Toke Høiland-Jørgensen wrote:
> Nikolay Aleksandrov <nikolay@nvidia.com> writes:
> 
>> On 26/01/2022 13:27, Lorenzo Bianconi wrote:
>>>> On 24/01/2022 19:20, Lorenzo Bianconi wrote:
>>>>> Similar to bpf_xdp_ct_lookup routine, introduce
>>>>> br_fdb_find_port_from_ifindex unstable helper in order to accelerate
>>>>> linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
>>>>> lookup in the associated bridge fdb table and it will return the
>>>>> output ifindex if the destination address is associated to a bridge
>>>>> port or -ENODEV for BOM traffic or if lookup fails.
>>>>>
>>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>>> ---
>>>>>  net/bridge/br.c         | 21 +++++++++++++
>>>>>  net/bridge/br_fdb.c     | 67 +++++++++++++++++++++++++++++++++++------
>>>>>  net/bridge/br_private.h | 12 ++++++++
>>>>>  3 files changed, 91 insertions(+), 9 deletions(-)
>>>>>
>>>>
>>>> Hi Lorenzo,
>>>
>>> Hi Nikolay,
>>>
>>> thx for the review.
>>>
>>>> Please CC bridge maintainers for bridge-related patches, I've added Roopa and the
>>>> bridge mailing list as well. Aside from that, the change is certainly interesting, I've been
>>>> thinking about a similar helper for some time now, few comments below.
>>>
>>> yes, sorry for that. I figured it out after sending the series out.
>>>
>>>>
>>>> Have you thought about the egress path and if by the current bridge state the packet would
>>>> be allowed to egress through the found port from the lookup? I'd guess you have to keep updating
>>>> the active ports list based on netlink events, but there's a lot of egress bridge logic that
>>>> either have to be duplicated or somehow synced. Check should_deliver() (br_forward.c) and later
>>>> egress stages, but I see how this is a good first step and perhaps we can build upon it.
>>>> There are a few possible solutions, but I haven't tried anything yet, most obvious being
>>>> yet another helper. :)
>>>
>>> ack, right but I am bit worried about adding too much logic and slow down xdp
>>> performances. I guess we can investigate first the approach proposed by Alexei
>>> and then revaluate. Agree?
>>>
>>
>> Sure, that approach sounds very interesting, but my point was that
>> bypassing the ingress and egress logic defeats most of the bridge
>> features. You just get an fdb hash table which you can build today
>> with ebpf without any changes to the kernel. :) You have multiple
>> states, flags and options for each port and each vlan which can change
>> dynamically based on external events (e.g. STP, config changes etc)
>> and they can affect forwarding even if the fdbs remain in the table.
> 
> To me, leveraging all this is precisely the reason to have BPF helpers
> instead of just replicating state in BPF maps: it's very easy to do that
> and show a nice speedup, and then once you get all the corner cases
> covered that the in-kernel code already deals with, you've chipped away
> at that speedup and spent a lot of time essentially re-writing the
> battle-tested code already in the kernel.
> 
> So I think figuring out how to do the state sync is the right thing to
> do; a second helper would be fine for this, IMO, but I'm not really
> familiar enough with the bridge code to really have a qualified opinion.
> 
> -Toke
> 

Right, sounds good to me. IMO it should be required in order to get a meaningful bridge
speedup, otherwise the solution is incomplete and you just do simple lookups that ignore
all of the state that could impact the forwarding decision.

Cheers,
 Nik
