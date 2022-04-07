Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6B94F7B30
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 11:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbiDGJPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 05:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243722AbiDGJPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 05:15:31 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2078.outbound.protection.outlook.com [40.107.102.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB8B14F12B;
        Thu,  7 Apr 2022 02:13:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7TQkAq150ImOr5O5TUD9lAZMON8PbujaKSH/IcI/j99foPyRXpouym7dB+72misDcCFFQxepmqC92ygiej0la9fvI2I4jT/bv7/MYLeECkpRvAGDw1Ptg0I9Jkyj5Mh4p8D2rPFfvd0gdOvwZ9hV0Gx0AB/kfccoBZq+V9Yo5283AfJTSE/PP/3zOBAC3aQwQjOuB4rvtcqrdZwzn+WFIaaDeul1QymkZWYtH0cZG2cEzsxhI1VHohvT9w2s7+1CzsNeO2EXwPZu0FDAO4g+zjFU/JgOMGPp1KX8SpJQyne4hl/AjP2uNcbVyudXM/HD/DYfAPsCMPzJrEtRHdx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7O1diCQZVxsqBsfKwQea/ZlvPclhSuHVftPGnFC3OFY=;
 b=aRFJagD04yNzRE5anq3gS16qM0+UN7oSJ45+ZagIeX6UJaDneBLuNhPkcLFBXyugK9/dM+Bfu7gyBNb544RGEogXE/b8AXVXgIvfisQjgyz/bn3I994LC9oqcsWCbwZ5FzHrGhpPdhcmE14uVyijTkQOh4nut7hRLly2VbMhhtJ0eqF4T8dB4vIHeQFnqmdWdrmAGSS7mlMmWh9tWEFqJUsag4dxpSXRoD7B74OlOS8YMdpPrx7aqRkvp3AjN+hsanUctwLbIVRwVSU4OTQL6sNYrJKaBbWz6qvCX+1HfPVUGzh8BbLAe3s5/OAX/NYv47RdXRl7lFiGGt4jBfs/bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7O1diCQZVxsqBsfKwQea/ZlvPclhSuHVftPGnFC3OFY=;
 b=mds7kobdvxlyoDBmhMeJ11AKwzCpO8CrKC7ffQZRGrF5JDYwyPaGsJfpvXqni7pTc+oeiUUw5gGQ+kfaSPUrmmh1XLjhrnAdyzf3ZGXjTTEpmWFX5kl4na+Dwx/8khox3cNo5XQ/o/J6U4Zoc+JNUi6L9ugDrvumSsr3jfhk7gSQZpWLliotFhv55WKKBmGJJIChzER+pjQRlpFsYubCz3KdzpzTE7ERwIsMkwQdZs/gKMaJikGEaaLCnKMgtNeaYED22lsM3QRbORwkBuMH5T03/J5DwhZc0w6oW0CgR4pXWZF1D363Esr+aSlWQjqXZ79zmhAVvfa2ImvNTCyP4Q==
Received: from DM5PR2201CA0017.namprd22.prod.outlook.com (2603:10b6:4:14::27)
 by MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 09:13:09 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::d5) by DM5PR2201CA0017.outlook.office365.com
 (2603:10b6:4:14::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22 via Frontend
 Transport; Thu, 7 Apr 2022 09:13:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Thu, 7 Apr 2022 09:13:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 7 Apr
 2022 09:13:06 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 7 Apr 2022
 02:13:03 -0700
References: <20220309222033.3018976-1-i.maximets@ovn.org>
 <f7ty21hir5v.fsf@redhat.com>
 <44eeb550-3310-d579-91cc-ec18b59966d2@nvidia.com>
 <1a185332-3693-2750-fef2-f6938bbc8500@ovn.org>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Ilya Maximets <i.maximets@ovn.org>
CC:     Roi Dayan <roid@nvidia.com>, Aaron Conole <aconole@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Pravin B Shelar" <pshelar@ovn.org>,
        Toms Atteka <cpp.code.lv@gmail.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility
 with existing user space
Date:   Thu, 7 Apr 2022 11:02:03 +0300
In-Reply-To: <1a185332-3693-2750-fef2-f6938bbc8500@ovn.org>
Message-ID: <87k0c171ml.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20568d00-d41e-46b0-490b-08da1876d538
X-MS-TrafficTypeDiagnostic: MN2PR12MB4440:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4440F3D4ED2DB1388354449EA0E69@MN2PR12MB4440.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlgJh/MQswOJKkkLhvrXRjEqRdWCQq29HevOqfQYR6Gn+vY+2QAwRNSp4A5aNQzlUSWK7ofQtoIspi9YP1+xE1y2VrNahPFjiKk5UAE/iwiHGeUnPHQa4dzop6UMXy4LwZyKqrjqcIXRedQnNL3F4B3CeZ01zlWtaPrST4Y1zzOvb08TeZgKt8aI+ehWZHf1OjCzel1944GJhbS/EL5jGjxpyeCVt12wkaSOGjJHH3iC+rUetZMZZbCb6SSKhliczC7uskFHLcHNRKcE052oI8F8U4PXD0+7tfcStwiCLNgjNmf7tJgspcR0u3TIqlNf0jhpuwrtNS9aT2xAbZDqeIAYlx8VL5bCzv6zf9O8eZEBnPAFaCDBvt4E6fLDMXoGtqXf9a6rybZu2UN8UC9dDpKpCPoQK/fgbPI+ygXFKlfdMT+CSfoIQZXemlZHOo+m8SRiT4tus1n9lP43AZxn/kLhTugzmpZYBoDIFt8fhI5oRiKHtOrD09dT1PJcgphCXgzYvYqsvGfgsAS9ycP8l4fKe5KF+E3kmiQ6mQnXuSxH7d+zakppXIHBAkH8JlgyEmdiMPbK8k9wX9tlq4AOmwPsRm0lUtjsoSFHg38HLDSyqNkvBuLHFrMy0eRbnoNHD/WGnNpxPDvRAYCw09BuxrtPJVJ9Bt7eAtFZ1WCH5Bu0LfHydhm4hcGQEoEjjBxaUGwuE1Y5b0LeecvO2g5geb7seYM2ajPlANA6ufAWYnSojZVlaxEA6kr/YVUxVuUxf3wg5TAl31m6IDM5UIiMVypyvLA47PuQe/fnHZre94E5OSM5694Es+NpfEQZ9gRUsd9rhe10ebn365LqCDNe4Q==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(7696005)(107886003)(86362001)(26005)(36756003)(6916009)(54906003)(82310400005)(5660300002)(316002)(426003)(16526019)(2906002)(336012)(2616005)(53546011)(186003)(83380400001)(36860700001)(966005)(508600001)(8936002)(47076005)(7416002)(40460700003)(4326008)(8676002)(70206006)(356005)(81166007)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 09:13:08.7383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20568d00-d41e-46b0-490b-08da1876d538
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 14 Mar 2022 at 20:40, Ilya Maximets <i.maximets@ovn.org> wrote:
> On 3/14/22 19:33, Roi Dayan wrote:
>>=20
>>=20
>> On 2022-03-10 8:44 PM, Aaron Conole wrote:
>>> Ilya Maximets <i.maximets@ovn.org> writes:
>>>
>>>> Few years ago OVS user space made a strange choice in the commit [1]
>>>> to define types only valid for the user space inside the copy of a
>>>> kernel uAPI header.=C2=A0 '#ifndef __KERNEL__' and another attribute w=
as
>>>> added later.
>>>>
>>>> This leads to the inevitable clash between user space and kernel types
>>>> when the kernel uAPI is extended.=C2=A0 The issue was unveiled with the
>>>> addition of a new type for IPv6 extension header in kernel uAPI.
>>>>
>>>> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to the
>>>> older user space application, application tries to parse it as
>>>> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as
>>>> malformed.=C2=A0 Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along with
>>>> every IPv6 packet that goes to the user space, IPv6 support is fully
>>>> broken.
>>>>
>>>> Fixing that by bringing these user space attributes to the kernel
>>>> uAPI to avoid the clash.=C2=A0 Strictly speaking this is not the probl=
em
>>>> of the kernel uAPI, but changing it is the only way to avoid breakage
>>>> of the older user space applications at this point.
>>>>
>>>> These 2 types are explicitly rejected now since they should not be
>>>> passed to the kernel.=C2=A0 Additionally, OVS_KEY_ATTR_TUNNEL_INFO mov=
ed
>>>> out from the '#ifdef __KERNEL__' as there is no good reason to hide
>>>> it from the userspace.=C2=A0 And it's also explicitly rejected now, be=
cause
>>>> it's for in-kernel use only.
>>>>
>>>> Comments with warnings were added to avoid the problem coming back.
>>>>
>>>> (1 << type) converted to (1ULL << type) to avoid integer overflow on
>>>> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
>>>>
>>>> =C2=A0 [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2 pip=
eline")
>>>>
>>>> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension heade=
r support")
>>>> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0cad8=
a5f@nvidia.com
>>>> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b=
0068b4cd12f6de507c
>>>> Reported-by: Roi Dayan <roid@nvidia.com>
>>>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>>>> ---
>>>
>>> Acked-by: Aaron Conole <aconole@redhat.com>
>>>
>>=20
>>=20
>>=20
>> I got to check traffic with the fix and I do get some traffic
>> but something is broken. I didn't investigate much but the quick
>> test shows me rules are not offloaded and dumping ovs rules gives
>> error like this
>>=20
>> recirc_id(0),in_port(enp8s0f0_1),ct_state(-trk),eth(),eth_type(0x86dd),i=
pv6(frag=3Dno)(bad
>> key length 2, expected -1)(00 00/(bad mask length 2, expected -1)(00 00),
>> packets:2453, bytes:211594, used:0.004s, flags:S., actions:ct,recirc(0x2)
>
> Such a dump is expected, because kernel parses fields that current
> userspace doesn't understand, and at the same time OVS by design is
> using kernel provided key/mask while installing datapath rules, IIRC.
> It should be possible to make these dumps a bit more friendly though.
>
> For the offloading not working, see my comment in the v2 patch email
> I sent (top email of this thread).  In short, it's a problem in user
> space and it can not be fixed from the kernel side, unless we revert
> IPv6 extension header support and never add any new types, which is
> unreasonable.  I didn't test any actual offloading, but I had a
> successful run of 'make check-offloads' with my quick'n'dirty fix from
> the top email.

Hi Ilya,

I can confirm that with latest OvS master IPv6 rules offload still fails
without your pastebin code applied.

>
> Since we're here:
>
> Toms, do you plan to submit user space patches for this feature?

I see there is a patch from you that is supposed to fix compatibility
issues caused by this change in OvS d96d14b14733 ("openvswitch.h: Align
uAPI definition with the kernel."), but it doesn't fix offload for me
without pastebin patch. Do you plan to merge that code into OvS or you
require some help from our side?

Regards,
Vlad

[...]


