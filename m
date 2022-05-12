Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93259524B12
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352950AbiELLK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352931AbiELLK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:10:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DF7236747;
        Thu, 12 May 2022 04:10:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2F7ttlR+HxUXqb33hZ1/SReu/0D40+GRJc4FOMj2VdXQMvPofuOGzKWUfjAixT0Qt5N1GIO6l0d8Nyc8N+udOZuRJDCywkPg3xoTISLPrpGwsRTj+V5sYuiHLaEET+TTtaae5/aeKqJJthy9So40txYesjg7TLJ7feWO/K5qWBidl7XoM3RqKXHJVrDGdkj0xSRMMDwETi3o9CxiBNwbJW7l420BhrVIUUOL+vHv/ZJiXeuPe8cGL8KpFr6QQ/xU+iT21sd29w/+Yqub7KwbpmNXvqM7W0BdD0dL3OFd9mgRc3ylYrvGZGqJFZa7iyMvNezF1JOWvVMXddirNx8oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzfQFyYsTC9krrhPlLAQ5WKMpAY5HVgaBIJqVfEEBLc=;
 b=l7aVrMIYjGss4lzOlvMV2vNNUjSlf7VBGwlsoF8uP0K421D7QGkXJIRmnDawhJW2UZx7VqOyzFfhef9c5PTiqjgPdjiLa7DckxRTlOSgHSAJ+6mM98Jikfq6wXwj2rb07KyBGzY/BvLXP8ngJPw1kiE+8j2IkYuZS1kK8AuLMEMusgUIk5L3yWJwDAztxfhceLDIJ1nODYuw34G/EsIldJmKwRY5Ly+A13a8RLeriAMaPs5J89oWCvmTHE5Ruw9O7M0Z7lBa+45IzaT1EETBzH4OvAabt8qqwjMZDXQMZJ2EWS1h0cmg/cAYfGYTSUfz1bwjQwTIJEaEPe8m+eM7eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzfQFyYsTC9krrhPlLAQ5WKMpAY5HVgaBIJqVfEEBLc=;
 b=KjZZ9gh5zqJ+wXOI9MF8THqe1FAzrlCRSunB2jI8cV3XQIYugzQBpC708Q50xAWXLaJK9SM4x14dE744Tcx0CGFbSq8w18vfHv72DjbRYNlsRGSqCfNE3j6eNfbG2U/H+UneG/Y+gmU0r7437hWP3vdwBF6dKDeRnqVjn8TlmWpn0Scezb+vkXs1s5znrIZtd5Wo7qQfMPkHVMvkRiIBPkcjMhCYK/9tqaq/i7OhsXaqELUD3uAkWx1eiTRs5pYU6Vy3uJhEGI94AYjNvKAPNcKFbeZEhR4OFNOL7FT2TLildXWUOQODMjJlR4LijBHl53KYTvX8bRJls6c9hJmoTQ==
Received: from MW4P223CA0020.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::25)
 by BL3PR12MB6547.namprd12.prod.outlook.com (2603:10b6:208:38e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 11:10:22 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::a1) by MW4P223CA0020.outlook.office365.com
 (2603:10b6:303:80::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Thu, 12 May 2022 11:10:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Thu, 12 May 2022 11:10:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 12 May
 2022 11:10:21 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 12 May
 2022 04:10:17 -0700
References: <20220309222033.3018976-1-i.maximets@ovn.org>
 <f7ty21hir5v.fsf@redhat.com>
 <44eeb550-3310-d579-91cc-ec18b59966d2@nvidia.com>
 <1a185332-3693-2750-fef2-f6938bbc8500@ovn.org> <87k0c171ml.fsf@nvidia.com>
 <9cc34fbc-3fd6-b529-7a05-554224510452@ovn.org>
 <4778B505-DBF5-4F57-90AF-87F12C1E0311@redhat.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Eelco Chaudron <echaudro@redhat.com>
CC:     Toms Atteka <cpp.code.lv@gmail.com>, Roi Dayan <roid@nvidia.com>,
        "Ilya Maximets" <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Pravin B Shelar" <pshelar@ovn.org>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility
 with existing user space
Date:   Thu, 12 May 2022 13:08:14 +0300
In-Reply-To: <4778B505-DBF5-4F57-90AF-87F12C1E0311@redhat.com>
Message-ID: <87lev783k8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3304a42f-b778-43eb-77ba-08da340801a5
X-MS-TrafficTypeDiagnostic: BL3PR12MB6547:EE_
X-Microsoft-Antispam-PRVS: <BL3PR12MB654753A911D0B68A7964D56CA0CB9@BL3PR12MB6547.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJJ4k8Pko3ikkwMjy9MFN00FBTstnrl5MZiNMCU92zgURY8aXDG+NPPllCJege5lioWZGk4eXhMzpPhfkMXbxr/NV5zVE3ej4t32ZEj5kkzdGcWslxEpPp/u3dqh1GCPfqCwo5PuuByPzHMVXiwCa1akfyPFcCS0RnsJXyhJJXWxWRFExC+Vs5blpaNTcN24zulnsMYcps8GQlP54uLimG4n0ZAYh0/vBTpTZ6SgnKvQNuGRiKmUvGREUJocL4ifemPwJ3HnCV7jxrNMJSVR3yXuJhuQGDG2/mZKERjhn3COa+SvYORKnjlq6eq7PUUVxJov7UPmrVWSbvMoKRBXALuof/Zy+K59U8D81V4dVE3Scj0zKSsXWNePfuJaEzPf7nvsp3nWIe09X6ilJHpI9Cdm5MMWSNjsnq1stQevDr+aMhq84zlnVw1ufibknWh8kP636cafYJ0uKqGta1FSgWEFqGdyOh5LqgU2hGW369V+gtqVlukB5iIWOzzNz2DFA2rwSmFg68xFoUff1VKKnMerhjFpJJeKdHnzFhTye/mLvPDHAaU6sytCzc1T63CGACxtrJsna5nlkscxBQIeHllloJL+xRWi7Kgq8saS8K7m9r3h5ikqmlN5T/G3RTYAT2qunEpF9Peifas/J9WHC8t1SqCuqXMz5HQxWGEsE1z/oEeUUPgUyZ1Pz+WNXcjUdUQIt+F6eQC+Qcus+r1McIZhlNFTaw/iF/JDqJqhZn7iKFaJdnBA/LCQWprmJjHlKAoKtO/As6Fjpq+ihkg2fzKYSRIbkI0t2dlQXxOV75O45cMd4cs8YOLpRg89SL2OjatVdRsPj3i64wpxwM5fAg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(81166007)(7416002)(426003)(356005)(40460700003)(70586007)(8676002)(336012)(47076005)(6916009)(70206006)(36860700001)(4326008)(53546011)(8936002)(6666004)(86362001)(966005)(7696005)(316002)(83380400001)(26005)(82310400005)(5660300002)(36756003)(186003)(2616005)(16526019)(508600001)(107886003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 11:10:21.7256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3304a42f-b778-43eb-77ba-08da340801a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6547
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 12 May 2022 at 12:19, Eelco Chaudron <echaudro@redhat.com> wrote:
> On 7 Apr 2022, at 12:22, Ilya Maximets wrote:
>
>> On 4/7/22 10:02, Vlad Buslov wrote:
>>> On Mon 14 Mar 2022 at 20:40, Ilya Maximets <i.maximets@ovn.org> wrote:
>>>> On 3/14/22 19:33, Roi Dayan wrote:
>>>>>
>>>>>
>>>>> On 2022-03-10 8:44 PM, Aaron Conole wrote:
>>>>>> Ilya Maximets <i.maximets@ovn.org> writes:
>>>>>>
>>>>>>> Few years ago OVS user space made a strange choice in the commit [1]
>>>>>>> to define types only valid for the user space inside the copy of a
>>>>>>> kernel uAPI header.=C2=A0 '#ifndef __KERNEL__' and another attribut=
e was
>>>>>>> added later.
>>>>>>>
>>>>>>> This leads to the inevitable clash between user space and kernel ty=
pes
>>>>>>> when the kernel uAPI is extended.=C2=A0 The issue was unveiled with=
 the
>>>>>>> addition of a new type for IPv6 extension header in kernel uAPI.
>>>>>>>
>>>>>>> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to the
>>>>>>> older user space application, application tries to parse it as
>>>>>>> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as
>>>>>>> malformed.=C2=A0 Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along =
with
>>>>>>> every IPv6 packet that goes to the user space, IPv6 support is fully
>>>>>>> broken.
>>>>>>>
>>>>>>> Fixing that by bringing these user space attributes to the kernel
>>>>>>> uAPI to avoid the clash.=C2=A0 Strictly speaking this is not the pr=
oblem
>>>>>>> of the kernel uAPI, but changing it is the only way to avoid breaka=
ge
>>>>>>> of the older user space applications at this point.
>>>>>>>
>>>>>>> These 2 types are explicitly rejected now since they should not be
>>>>>>> passed to the kernel.=C2=A0 Additionally, OVS_KEY_ATTR_TUNNEL_INFO =
moved
>>>>>>> out from the '#ifdef __KERNEL__' as there is no good reason to hide
>>>>>>> it from the userspace.=C2=A0 And it's also explicitly rejected now,=
 because
>>>>>>> it's for in-kernel use only.
>>>>>>>
>>>>>>> Comments with warnings were added to avoid the problem coming back.
>>>>>>>
>>>>>>> (1 << type) converted to (1ULL << type) to avoid integer overflow on
>>>>>>> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
>>>>>>>
>>>>>>> =C2=A0 [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2 =
pipeline")
>>>>>>>
>>>>>>> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension he=
ader support")
>>>>>>> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0c=
ad8a5f@nvidia.com
>>>>>>> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd65=
21b0068b4cd12f6de507c
>>>>>>> Reported-by: Roi Dayan <roid@nvidia.com>
>>>>>>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>>>>>>> ---
>>>>>>
>>>>>> Acked-by: Aaron Conole <aconole@redhat.com>
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>> I got to check traffic with the fix and I do get some traffic
>>>>> but something is broken. I didn't investigate much but the quick
>>>>> test shows me rules are not offloaded and dumping ovs rules gives
>>>>> error like this
>>>>>
>>>>> recirc_id(0),in_port(enp8s0f0_1),ct_state(-trk),eth(),eth_type(0x86dd=
),ipv6(frag=3Dno)(bad
>>>>> key length 2, expected -1)(00 00/(bad mask length 2, expected -1)(00 =
00),
>>>>> packets:2453, bytes:211594, used:0.004s, flags:S., actions:ct,recirc(=
0x2)
>>>>
>>>> Such a dump is expected, because kernel parses fields that current
>>>> userspace doesn't understand, and at the same time OVS by design is
>>>> using kernel provided key/mask while installing datapath rules, IIRC.
>>>> It should be possible to make these dumps a bit more friendly though.
>>>>
>>>> For the offloading not working, see my comment in the v2 patch email
>>>> I sent (top email of this thread).  In short, it's a problem in user
>>>> space and it can not be fixed from the kernel side, unless we revert
>>>> IPv6 extension header support and never add any new types, which is
>>>> unreasonable.  I didn't test any actual offloading, but I had a
>>>> successful run of 'make check-offloads' with my quick'n'dirty fix from
>>>> the top email.
>>>
>>> Hi Ilya,
>>>
>>> I can confirm that with latest OvS master IPv6 rules offload still fails
>>> without your pastebin code applied.
>>>
>>>>
>>>> Since we're here:
>>>>
>>>> Toms, do you plan to submit user space patches for this feature?
>>>
>>> I see there is a patch from you that is supposed to fix compatibility
>>> issues caused by this change in OvS d96d14b14733 ("openvswitch.h: Align
>>> uAPI definition with the kernel."), but it doesn't fix offload for me
>>> without pastebin patch.
>>
>> Yes.  OVS commit d96d14b14733 is intended to only fix the uAPI.
>> Issue with offload is an OVS bug that should be fixed separately.
>> The fix will also need to be backported to OVS stable branches.
>>
>>> Do you plan to merge that code into OvS or you
>>> require some help from our side?
>>
>> I could do that, but I don't really have enough time.  So, if you
>> can work on that fix, it would be great.  Note that comments inside
>> the OVS's lib/odp-util.c:parse_key_and_mask_to_match() was blindly
>> copied from the userspace datapath and are incorrect for the general
>> case, so has to be fixed alongside the logic of that function.
>
> Tom or Vlad, are you working on this? Asking, as the release of a kernel =
with
> Tom=E2=80=99s =E2=80=9Cnet: openvswitch: IPv6: Add IPv6 extension header =
support=E2=80=9D patch will
> break OVS.
>
> //Eelco

Hi Eelco,

My simple fix for OvS was rejected and I don't have time to rework it at
the moment.

Regards,
Vlad

