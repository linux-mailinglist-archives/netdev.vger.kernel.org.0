Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE6C449B51
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhKHSEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:04:06 -0500
Received: from mail-dm6nam11on2043.outbound.protection.outlook.com ([40.107.223.43]:15456
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234353AbhKHSEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 13:04:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwVlu/FKUbz4jFcwf3GBSDrwdc1MZjXSFB9PjrCrFi9oeAx707kSFGiYfo5oIEU01CbuoPdkvtxJWBJo5OzcyFyqitw+LHmNQDTRw0SUDR6sYyOZsErmfbfsqt3r7YElvwYFl1QwDEsuTW1hpXIa3qkfNDEU7bDcB9QyYRX3WXJ3DrqxA+X9n+R6fAqJyGmarVN/8ZkAjjv2CsXITu7r4XRuUQdb9/s855Sdp/3/OXscQUDOHGAEJt88Yf2eej+bo4iikwfsSi6T5Moz4GVfb2OfIImYdPRUa1NrBw28GB7kHmP21Uy80TshO5aXM+2SBlO534iowxEJpt/Xzlwy8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASNxz1B54h66Ugm1xIAUiM253rD9IT3qyFa0b2zgC2Q=;
 b=D5Pdm9H5iwZUNJeBFyOTH215JcI/18v4C9GGlvEEYj4L7wFj4Yj6XgkpT1Xz3An7pJEldWfTs/99Pfp+fmyAUS7RDWx3p/6c0kqR5SpVRmiFl87dhfeWHWTPcD1oLuWnybELNDMeJ0L2fmMnh/iTMcar0C+17xdNyYam1xBTgxdVGHQuCLq4jCoCqqMdYUYgYVjYFe7K+AwhltyLb/0Bmn/caIz9DLB1cLCYuekLZ6FIV0H/Ul41/l7Y3D53h8l02tu07fmWINZIyjRlSONG85JwrFQOe0p8j2ojGKk2gvHXT2WEuc+Rl5p/qqDMROxWT/5164ziIfyA0FvrB/cpQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASNxz1B54h66Ugm1xIAUiM253rD9IT3qyFa0b2zgC2Q=;
 b=P39QdYA/9IguLvmb0l5P9+Fug/0xqcxIMLyQulpimcnJ8B6xoY+wLkLKRT8raPl27qHly8p/u4zbTSyBnEYOhF76XRXZ9qr7vLQoAbQ1hThKyqVf9nq5GllLY5MEtDMH4Z+HpjUcpq38XOXH1Fh/L9gF7mlq181U+IAE3B8o7K+2wPPkIoMK2vQuQyMFi6clWaYNwOn3wiKbzrQ+PyUxA5hxGlouPqWybsGVY9qAk3Ma7+YxEKlEA8qtT7DNPNy8EtODddvpwzbGC8Wf6puYZeITYwhZVE04JrCPC4rE35EH/tB5mCgS2xhERjVRSUdx3BPSaQMb6iixOhI3IIyiDw==
Received: from BN6PR11CA0066.namprd11.prod.outlook.com (2603:10b6:404:f7::28)
 by SA0PR12MB4589.namprd12.prod.outlook.com (2603:10b6:806:92::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Mon, 8 Nov
 2021 18:01:18 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::ce) by BN6PR11CA0066.outlook.office365.com
 (2603:10b6:404:f7::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Mon, 8 Nov 2021 18:01:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Mon, 8 Nov 2021 18:01:18 +0000
Received: from yaviefel (172.20.187.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 8 Nov 2021 18:00:22
 +0000
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <richardcochran@gmail.com>, <abyagowi@fb.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <idosch@idosch.org>, <mkubecek@suse.cz>, <saeed@kernel.org>,
        <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
In-Reply-To: <20211105205331.2024623-7-maciej.machnikowski@intel.com>
Date:   Mon, 8 Nov 2021 19:00:19 +0100
Message-ID: <87r1bqcyto.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2aed0e7-f0ea-4e3b-49e0-08d9a2e1c3b8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4589:
X-Microsoft-Antispam-PRVS: <SA0PR12MB458944C4DB91829970DACE40D6919@SA0PR12MB4589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LFvYvUS7/LVEWKJQC8KEp842jp1TEHNtSPr3xvtuf5IfUJNeEmI437kRuf8xFg0JIjuw7zXgEgbbtf1Fwm7B8YKOytmjm+agbQECSgJ7UhTOEFfgSTkIHV5ez2HItJcASENTCBVLq/XwGbFaRn5PdsI+7S9tNu/48XM1CCe3tjynmR95+GWoQeZvqwRrk373lO8+ZS3fDjjVz0MQKuLFHKg+7W6Fs0whoDvIuSg5ltuT1CaRNN3SZIDqzHtuFurJ1KZv90mU7YK6gYM/aFIRXAKYQYqxgrQT7hTARXqy14o0tELb+WYJHcVL8B32HMCa0QVe5w6GmEVjFFOIXetU/I8Hp7LQCN3VEmbw4UjUAk/NRyJ4Fq0KmeGedKOVZxEXnKn8LjLO9GsDf0Fjn4c+HapronLml7Jxv3wYWNpelaK5wPiMh+ZOFVknwyvZEcEvfmdmW4kSkojw/tOhgpzjn/XDfZdNJNhB4IZU1zHfD3ckDPlxAQU5PuyowrwfBXVnJPvOxKKZ9uWlzxHfLzvMssKUp8EFr2wtBV+b6jFR+T3qs8EZXvMqFZlACBriOk60wzYStkHTuYtTyLop61IG3aCijjUbT9G3DlJ2kEcfFX1BWuQebLwBWVsJK9nqMDO2cRpK44Ne7ypYY7hf6lOZJeEf34hLyF0fPGW6D70hMbFF+mtB4wprd2U+ORI3PDuoc1W/uTLNxaw53mPru1WAmA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7416002)(36756003)(26005)(8676002)(70206006)(336012)(5660300002)(7636003)(70586007)(316002)(16526019)(186003)(82310400003)(4326008)(54906003)(83380400001)(508600001)(86362001)(2906002)(6916009)(36860700001)(356005)(426003)(47076005)(6666004)(2616005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 18:01:18.2602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2aed0e7-f0ea-4e3b-49e0-08d9a2e1c3b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Maciej Machnikowski <maciej.machnikowski@intel.com> writes:

> Add Documentation/networking/synce.rst describing new RTNL messages
> and respective NDO ops supporting SyncE (Synchronous Ethernet).
>
> Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
> ---
>  Documentation/networking/synce.rst | 117 +++++++++++++++++++++++++++++
>  1 file changed, 117 insertions(+)
>  create mode 100644 Documentation/networking/synce.rst
>
> diff --git a/Documentation/networking/synce.rst b/Documentation/networkin=
g/synce.rst
> new file mode 100644
> index 000000000000..4ca41fb9a481
> --- /dev/null
> +++ b/Documentation/networking/synce.rst
> @@ -0,0 +1,117 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Synchronous Ethernet
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Synchronous Ethernet networks use a physical layer clock to syntonize
> +the frequency across different network elements.
> +
> +Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> +Equipment Clock (EEC) and a PHY that has dedicated outputs of recovered =
clocks
> +and a dedicated TX clock input that is used as to transmit data to other=
 nodes.
> +
> +The SyncE capable PHY is able to recover the incomning frequency of the =
data
> +stream on RX lanes and redirect it (sometimes dividing it) to recovered
> +clock outputs. In SyncE PHY the TX frequency is directly dependent on the
> +input frequency - either on the PHY CLK input, or on a dedicated
> +TX clock input.
> +
> +      =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> +      =E2=94=82 RX        =E2=94=82 TX       =E2=94=82
> +  1   =E2=94=82 lanes     =E2=94=82 lanes    =E2=94=82 1
> +  =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=82          =E2=94=9C=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA
> +  2   =E2=94=82      =E2=94=82    =E2=94=82          =E2=94=82 2
> +  =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=94=80=E2=94=
=90   =E2=94=82    =E2=94=82          =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=96=BA
> +  3   =E2=94=82  =E2=94=82   =E2=94=82    =E2=94=82          =E2=94=82 3
> +  =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=96=BC=E2=96=
=BC   =E2=96=BC    =E2=94=82          =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=96=BA
> +      =E2=94=82 =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80  =
  =E2=94=82          =E2=94=82
> +      =E2=94=82 \____/    =E2=94=82          =E2=94=82
> +      =E2=94=94=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=BC=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> +        1=E2=94=82 2=E2=94=82        =E2=96=B2
> + RCLK out=E2=94=82  =E2=94=82        =E2=94=82 TX CLK in
> +         =E2=96=BC  =E2=96=BC        =E2=94=82
> +       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=
=94=80=E2=94=80=E2=94=80=E2=94=90
> +       =E2=94=82                 =E2=94=82
> +       =E2=94=82       EEC       =E2=94=82
> +       =E2=94=82                 =E2=94=82
> +       =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=98
> +
> +The EEC can synchronize its frequency to one of the synchronization inpu=
ts
> +either clocks recovered on traffic interfaces or (in advanced deployment=
s)
> +external frequency sources.
> +
> +Some EEC implementations can select synchronization source through
> +priority tables and synchronization status messaging and provide necessa=
ry
> +filtering and holdover capabilities.
> +
> +The following interface can be applicable to diffferent packet network t=
ypes
> +following ITU-T G.8261/G.8262 recommendations.
> +
> +Interface
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The following RTNL messages are used to read/configure SyncE recovered
> +clocks.
> +
> +RTM_GETRCLKRANGE
> +-----------------
> +Reads the allowed pin index range for the recovered clock outputs.
> +This can be aligned to PHY outputs or to EEC inputs, whichever is
> +better for a given application.
> +Will call the ndo_get_rclk_range function to read the allowed range
> +of output pin indexes.
> +Will call ndo_get_rclk_range to determine the allowed recovered clock
> +range and return them in the IFLA_RCLK_RANGE_MIN_PIN and the
> +IFLA_RCLK_RANGE_MAX_PIN attributes
> +
> +RTM_GETRCLKSTATE
> +-----------------
> +Read the state of recovered pins that output recovered clock from
> +a given port. The message will contain the number of assigned clocks
> +(IFLA_RCLK_STATE_COUNT) and an N pin indexes in IFLA_RCLK_STATE_OUT_IDX
> +To support multiple recovered clock outputs from the same port, this mes=
sage
> +will return the IFLA_RCLK_STATE_COUNT attribute containing the number of
> +active recovered clock outputs (N) and N IFLA_RCLK_STATE_OUT_IDX attribu=
tes
> +listing the active output indexes.
> +This message will call the ndo_get_rclk_range to determine the allowed
> +recovered clock indexes and then will loop through them, calling
> +the ndo_get_rclk_state for each of them.

Let me make sure I understand the model that you propose. Specifically
from the point of view of a multi-port device, because that's my
immediate use case.

RTM_GETRCLKRANGE would report number of "pins" that matches the number
of lanes in the system. So e.g. a 32-port switch, where each port has 4
lanes, would give a range of [1; 128], inclusive. (Or maybe [0; 128) or
whatever.)

RTM_GETRCLKSTATE would then return some subset of those pins, depending
on which lanes actually managed to establish a connection and carry a
valid clock signal. So, say, [1, 2, 3, 4] if the first port has e.g. a
100Gbps established.

> +
> +RTM_SETRCLKSTATE
> +-----------------
> +Sets the redirection of the recovered clock for a given pin. This message
> +expects one attribute:
> +struct if_set_rclk_msg {
> +	__u32 ifindex; /* interface index */
> +	__u32 out_idx; /* output index (from a valid range)
> +	__u32 flags; /* configuration flags */
> +};
> +
> +Supported flags are:
> +SET_RCLK_FLAGS_ENA - if set in flags - the given output will be enabled,
> +		     if clear - the output will be disabled.

OK, so here I set up the tracking. ifindex tells me which EEC to
configure, out_idx is the pin to track, flags tell me whether to set up
the tracking or tear it down. Thus e.g. on port 2, track pin 2, because
I somehow know that lane 2 has the best clock.


If the above is broadly correct, I've got some questions.

First, what if more than one out_idx is set? What are drivers / HW meant
to do with this? What is the expected behavior?

Also GETRCLKSTATE and SETRCLKSTATE have a somewhat different scope: one
reports which pins carry a clock signal, the other influences tracking.
That seems wrong. There also does not seems to be an UAPI to retrieve
the tracking settings.

Second, as a user-space client, how do I know that if ports 1 and 2 both
report pin range [A; B], that they both actually share the same
underlying EEC? Is there some sort of coordination among the drivers,
such that each pin in the system has a unique ID?

Further, how do I actually know the mapping from ports to pins? E.g. as
a user, I might know my master is behind swp1. How do I know what pins
correspond to that port? As a user-space tool author, how do I help
users to do something like "eec set clock eec0 track swp1"?

Additionally, how would things like external GPSs or 1pps be modeled? I
guess the driver would know about such interface, and would expose it as
a "pin". When the GPS signal locks, the driver starts reporting the pin
in the RCLK set. Then it is possible to set up tracking of that pin.


It seems to me it would be easier to understand, and to write user-space
tools and drivers for, a model that has EEC as an explicit first-class
object. That's where the EEC state naturally belongs, that's where the
pin range naturally belongs. Netdevs should have a reference to EEC and
pins, not present this information as if they own it. A first-class EEC
would also allow to later figure out how to hook up PHC and EEC.

> +
> +RTM_GETEECSTATE
> +----------------
> +Reads the state of the EEC or equivalent physical clock synchronizer.
> +This message returns the following attributes:
> +IFLA_EEC_STATE - current state of the EEC or equivalent clock generator.
> +		 The states returned in this attribute are aligned to the
> +		 ITU-T G.781 and are:
> +		  IF_EEC_STATE_INVALID - state is not valid
> +		  IF_EEC_STATE_FREERUN - clock is free-running
> +		  IF_EEC_STATE_LOCKED - clock is locked to the reference,
> +		                        but the holdover memory is not valid
> +		  IF_EEC_STATE_LOCKED_HO_ACQ - clock is locked to the reference
> +		                               and holdover memory is valid
> +		  IF_EEC_STATE_HOLDOVER - clock is in holdover mode
> +State is read from the netdev calling the:
> +int (*ndo_get_eec_state)(struct net_device *dev, enum if_eec_state *stat=
e,
> +			 u32 *src_idx, struct netlink_ext_ack *extack);
> +
> +IFLA_EEC_SRC_IDX - optional attribute returning the index of the referen=
ce that
> +		   is used for the current IFLA_EEC_STATE, i.e., the index of
> +		   the pin that the EEC is locked to.
> +
> +Will be returned only if the ndo_get_eec_src is implemented.
