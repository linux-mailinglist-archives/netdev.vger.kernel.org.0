Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD9144D6BF
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhKKMq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 07:46:27 -0500
Received: from mail-dm6nam12on2076.outbound.protection.outlook.com ([40.107.243.76]:15200
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232126AbhKKMq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 07:46:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nu6ATCCHatuqt3IC1TNAYDRFc1aD4jPV8q6AXCnANfJTbF9LuglldW7M4/Vsjf1FkWRr/weCrOX913J2Pz5oSvcgFt3IlbjWPhOG/pwBG9V4J4aFy1mah8nhTOE72YnBDrTgd5E1vm0Sd4iUsapN7hv16OOM/y/by3dJXl8lSzR2wSXVRS3aVq9gupOs9bvS7bKgljawRx6i+B0GnYE2KwDheWcfDvXmW1j1Jek4Atl/Er4D7tGSkrLn+80kqooltj6wrLbQB7LhmR+u5ahxHuujd7ameEOhFJu6jQ+lNkEq05z13nXSw2fjtgTxs6EC2lvB0cRVyDuJSU/89IrQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARHcli0ZsZxAV+EMy3pwQHR4onRn7VEprcXUDDqJU/c=;
 b=CJV3juYalI1nMTNyLUs6Yrb7KdRRVEn8YnsTaxiW0qcd3rDktjw2ouDg7W7aqZY49cfYfeS9N5tpsmK2DtWuoZ+DId9injts9EFep3XUi3nDrrRatx/ugYi1tIVpkgX0CdeS7WHjMpBbbduNGfzPRjjWAW6FsoiJ4eToj3G/PR3FOomCyrMURceBGy6TAFScobW/N7LQtyqrFam43lbS0NAh/BYttZVDmOg7TOWq70vGfKyPpuYpyD/u7HIOPaDGustsGXpJuRGQKuexmrikXk0YeTX3hMavxq8KQYbl2mj7pjbhlFRGGSTr5S00FoN3kwvaYCO6Eo3mbEde5WgP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARHcli0ZsZxAV+EMy3pwQHR4onRn7VEprcXUDDqJU/c=;
 b=N1UYzoPaZ6SjwAKCcCn8wmR5aNBlIuvzTzdduCBq7ovpPW3SAaoWRkdDZ644VRw8nv4AgG1Ddj4aIOCdnj4RqJ1JqJThiC19lD30q4tWWq+muoXWYswkuBWjPqH4OBs4n9Afys+oNDNJ8ldr2ljWhoPVAYNP3MK6AqVOGnN9/7mCApzN7Hl5JEoWCbAHQe1JTDqWnUzt4iz5qWgm4TD/DDamKM98qPGjkrP6VUxRdLx85W7jTFmOEP2QxhL0Rs+ZDxTdq7PjU9eBl5lmNLIRf8rKi7cYnqLDACzV6FhvjxOAYQCe8oc1vh4Jdp4iHwI8V465y7qDfVTosNryAD+glg==
Received: from BN9P223CA0017.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::22)
 by BN8PR12MB2978.namprd12.prod.outlook.com (2603:10b6:408:42::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Thu, 11 Nov
 2021 12:43:29 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::d5) by BN9P223CA0017.outlook.office365.com
 (2603:10b6:408:10b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16 via Frontend
 Transport; Thu, 11 Nov 2021 12:43:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Thu, 11 Nov 2021 12:43:28 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 11 Nov 2021 12:43:23
 +0000
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-7-maciej.machnikowski@intel.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <richardcochran@gmail.com>, <abyagowi@fb.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <idosch@idosch.org>, <mkubecek@suse.cz>, <saeed@kernel.org>,
        <michael.chan@broadcom.com>, <petrm@nvidia.com>
Subject: Re: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
 interfaces
In-Reply-To: <20211110114448.2792314-7-maciej.machnikowski@intel.com>
Message-ID: <87tugic17a.fsf@nvidia.com>
Date:   Thu, 11 Nov 2021 13:43:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd35f662-592c-4e3e-8540-08d9a510dc9a
X-MS-TrafficTypeDiagnostic: BN8PR12MB2978:
X-Microsoft-Antispam-PRVS: <BN8PR12MB297869626834A13F2939AE61D6949@BN8PR12MB2978.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJOFNfHuN7RGXZgkRiijG2C7EpyuhE2hczaKxXdZS/dIUKKee/wsGDcSPtcK4YbG6MPrZDcQoGyg81ZXxbN857FIrTZd2Vw91xFL9ICJZdHXf7ZelKAF3PSTuYb7GKc719QZByKLSNZFQw/crzf9M8uq5nnLW/WN2agx5sD9vkx4RwpLbJcMctY59/Cwaky6XEW8zSGwynb1o5a7yy48bjf71iQlWmpqK8BaeWmr7SIBfQFp/RgnReX6sYN96hyXyjqY0/dmGaOW5E1EAmkTLbQnkVBa5Mi3vi45AQdB7b19opuVs8LAWxPkgS9Gd1rq8UVeHLxyxZyhrKANyzYFAUKnmL/1voGJThHnXd/qFQVx9s0pG6T7rNbV0a7+58Eo/j92pJlJKQOczDyyZBxttJW+Mhw83xFO1C78cV1SWTVf1FTtnJnyv/QSh5wPXYhxYhz0G8lu2li55XuOOjNdg7RP4zZVIabEnvwhqKWIUb2c774jVw10q7pMNnrjD/ZkRJNsZiNYEPw4D/W9WFQo+GJv43hH7tiJ+KTUQ5GJsSW7Z6iBix1QcwX8yegRaixW0ePzCXdsqw/yA+fvTzfjGWGMt4lVsA7qlAlQFShgxyDFvOQ+54UXBmBkKl+Wn3zBmQV5eHn8yrW7H+ryS1bEwN4YBjyrhH7waXEMZjJ8dHbV0vczSM4HptfccizDgshKMM4jpCm3Sg+/9EpOw03NFA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(54906003)(26005)(16526019)(83380400001)(4326008)(5660300002)(8676002)(336012)(426003)(2906002)(47076005)(8936002)(2616005)(316002)(86362001)(36860700001)(7416002)(70206006)(70586007)(36756003)(356005)(82310400003)(6916009)(107886003)(508600001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 12:43:28.6481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd35f662-592c-4e3e-8540-08d9a510dc9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2978
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Maciej Machnikowski <maciej.machnikowski@intel.com> writes:

> Add Documentation/networking/synce.rst describing new RTNL messages
> and respective NDO ops supporting SyncE (Synchronous Ethernet).
>
> Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
> ---
>  Documentation/networking/synce.rst | 124 +++++++++++++++++++++++++++++
>  1 file changed, 124 insertions(+)
>  create mode 100644 Documentation/networking/synce.rst
>
> diff --git a/Documentation/networking/synce.rst b/Documentation/networkin=
g/synce.rst
> new file mode 100644
> index 000000000000..a7bb75685c07
> --- /dev/null
> +++ b/Documentation/networking/synce.rst
> @@ -0,0 +1,124 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +Synchronous Equipment Clocks
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +Synchronous Equipment Clocks use a physical layer clock to syntonize
> +the frequency across different network elements.
> +
> +Basic Synchronous network node consist of a Synchronous Equipment
> +Clock (SEC) and and a PHY that has dedicated outputs of clocks recovered
> +from the Receive side and a dedicated TX clock input that is used as
> +a reference for the physical frequency of the transmit data to other nod=
es.
> +
> +The PHY is able to recover the physical signal frequency of the RX data
> +stream on RX ports and redirect it (sometimes dividing it) to recovered
> +clock outputs. Number of recovered clock output pins is usually lower th=
an
> +the number of RX portx. As a result the RX port to Recovered Clock output
> +mapping needs to be configured. the TX frequency is directly depends on =
the
> +input frequency - either on the PHY CLK input, or on a dedicated
> +TX clock input.
> +
> +      =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> +      =E2=94=82 RX       =E2=94=82 TX       =E2=94=82
> +  1   =E2=94=82 ports    =E2=94=82 ports    =E2=94=82 1
> +  =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=82          =E2=94=9C=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA
> +  2   =E2=94=82     =E2=94=82    =E2=94=82          =E2=94=82 2
> +  =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=94=80=E2=94=
=80=E2=94=90 =E2=94=82    =E2=94=82          =E2=94=9C=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=96=BA
> +  3   =E2=94=82   =E2=94=82 =E2=94=82    =E2=94=82          =E2=94=82 3
> +  =E2=94=80=E2=94=80=E2=94=80=E2=96=BA=E2=94=9C=E2=94=80=E2=94=90 =E2=94=
=82 =E2=94=82    =E2=94=82          =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=96=BA
> +      =E2=94=82 =E2=96=BC =E2=96=BC =E2=96=BC    =E2=94=82          =E2=
=94=82
> +      =E2=94=82 =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80  =
 =E2=94=82          =E2=94=82
> +      =E2=94=82 \____/   =E2=94=82          =E2=94=82
> +      =E2=94=94=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=BC=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> +        1=E2=94=82 2=E2=94=82        =E2=96=B2
> + RCLK out=E2=94=82  =E2=94=82        =E2=94=82 TX CLK in
> +         =E2=96=BC  =E2=96=BC        =E2=94=82
> +       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=
=94=80=E2=94=80=E2=94=80=E2=94=90
> +       =E2=94=82                 =E2=94=82
> +       =E2=94=82       SEC       =E2=94=82
> +       =E2=94=82                 =E2=94=82
> +       =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=98
> +
> +The SEC can synchronize its frequency to one of the synchronization inpu=
ts
> +either clocks recovered on traffic interfaces or (in advanced deployment=
s)
> +external frequency sources.
> +
> +Some SEC implementations can automatically select synchronization source
> +through priority tables and synchronization status messaging and provide
> +necessary filtering and holdover capabilities.
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
> +RTM_GETRCLKSTATE
> +-----------------
> +Read the state of recovered pins that output recovered clock from
> +a given port. The message will contain the number of assigned clocks
> +(IFLA_RCLK_STATE_COUNT) and an N pin indexes in IFLA_RCLK_STATE_OUT_STATE
> +To support multiple recovered clock outputs from the same port, this mes=
sage
> +will return the IFLA_RCLK_STATE_COUNT attribute containing the number of
> +recovered clock outputs (N) and N IFLA_RCLK_STATE_OUT_STATE attributes
> +listing the output indexes with the respective GET_RCLK_FLAGS_ENA flag.
> +This message will call the ndo_get_rclk_range to determine the allowed
> +recovered clock indexes and then will loop through them, calling
> +the ndo_get_rclk_state for each of them.
> +
> +
> +Attributes:
> +IFLA_RCLK_STATE_COUNT - Returns the number of recovered clock outputs
> +IFLA_RCLK_STATE_OUT_STATE - Returns the current state of a single recove=
red
> +			    clock output in the struct if_get_rclk_msg.
> +struct if_get_rclk_msg {
> +	__u32 out_idx; /* output index (from a valid range) */
> +	__u32 flags;   /* configuration flags */
> +};
> +
> +Currently supported flags:
> +#define GET_RCLK_FLAGS_ENA	(1U << 0)
> +
> +
> +RTM_SETRCLKSTATE
> +-----------------
> +Sets the redirection of the recovered clock for a given pin. This message
> +expects one attribute:
> +struct if_set_rclk_msg {
> +	__u32 ifindex; /* interface index */
> +	__u32 out_idx; /* output index (from a valid range) */
> +	__u32 flags;   /* configuration flags */
> +};
> +
> +Supported flags are:
> +SET_RCLK_FLAGS_ENA - if set in flags - the given output will be enabled,
> +		     if clear - the output will be disabled.
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
ce
> +		   that is used for the current IFLA_EEC_STATE, i.e.,
> +		   the index of the pin that the EEC is locked to.
> +
> +Will be returned only if the ndo_get_eec_src is implemented.
> \ No newline at end of file

Just to be clear, I have much the same objections to this UAPI as I had
to v2:

- RTM_GETEECSTATE will become obsolete as soon as DPLL object is added.

- Reporting pins through the netdevices that use them allows for
  configurations that are likely invalid, like disjoint "frequency
  bridges".

- It's not clear what enabling several pins means, and it's not clear
  whether this genericity is not going to be an issue in the future when
  we know what enabling more pins means.

- No way as a user to tell whether two interfaces that report the same
  pins are actually connected to the same EEC. How many EEC's are there,
  in the system, anyway?

In particular, I think that the proposed UAPIs should belong to a DPLL
object. That object must know about the pins, so have it enumerate them.
That object needs to know about which pin/s to track, so configure it
there. That object has the state, so have it report it. Really, it looks
basically 1:1 vs. the proposed API, except the object over which the
UAPIs should be defined is a DPLL, not a netdev.
