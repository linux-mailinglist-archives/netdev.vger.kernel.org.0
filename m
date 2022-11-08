Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D59620DF3
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiKHK7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiKHK7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:59:09 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73532D1F7
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:59:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwG+q/Ex3dRR1k+jvEBs9tBX6caxC7tBRmzZy/l+0/wO+D7S9y0Iw7OKfuR64vwBE1JKeDm0xoryjZKxm9U4+EgHqisC9UOe0d7BSvRvuV+wDo/qu6SEgmX07D3QiMO0GkwWfzKOo7lxdeQrjWrmWtl/NyJe6Wpz/+tC4YXOZ5tXXI/538mOaTkaQtKiUN3LHYPORQ1fFgGA/D9CsLzRxYJpsIqPQ6Z5PVyxqBsYN0KES6hnDdkpr4zwkuPcw9dOybjINVgXxXOxz3qzo/G3aUAZalSWhX4POH49SYBgKTyh5MzUM3AaFtZ06Jzats0dRR8TmR9/46QZ5a0jS3wnDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4AthPWbMfFaYPs4+NGIwulHWDc0XnUxiNJWN8M35SI=;
 b=DoT1PB1biSqrcuBnID/BBVUta6Nqkr2TdP4DsrrPD5UDA79bQs9/jvTpLrF+oFrRYPFsu+Ltyl0Mh7M5Dn4rDKsLcuOiVnO+mREkP+kx5IEPvjrKg/YPBEPbo4k7LNVDwEDieLn3BHbM6Vejund08EhJ6biTnYZiNfWJnWagZ1zkvWCfXvcHJRZILpub8uuL3Uph6vbcE9lGHyqjnvR0qQKnuoiFv9dHP5N2Y/0g7YWMMpwa+lkPnBNLOs4tsEnatkQHPwD/C/HL+TfhTmEIYdl5PcQhH53oz/jnP2Qj61wonKUpLe/InWh7DRL0chsKslv42VHV0EPdEDwmkMAq8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4AthPWbMfFaYPs4+NGIwulHWDc0XnUxiNJWN8M35SI=;
 b=nJiNsdruHppkZxMr48/fYsBe/Oeqr2xpoLaLQVbQM8uIoC+/Jcpx66/Jymr63O8BiXar2q2Xl2/zMGl3mm+DVMX4U0HAtEKDWwJT0z8ziTcB79pHV+88ureSK61717EptzEnYp/fohZ5Kl2V5yZmBF2cQte9OARBwolkwWSjZkL/JSOmP2K3tOTVh0DvSEaFnJRUb0Z0BkJpSKuRHosOYkSkeIZQKlQSeHwVVZ/KPel/4fibbigsMOKQssv70GJD0gmHzSQvvcrSrLKt32fP2HXdsdHCBmmoMsKDbowycYJ7Zv8l5qX1g2vPRLyDR7WMzYylsSjeLGAi/c9gtI2HIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB7419.namprd12.prod.outlook.com (2603:10b6:806:2a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 10:59:07 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 10:59:06 +0000
Date:   Tue, 8 Nov 2022 12:59:00 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>, vladimir.oltean@nxp.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/15] mlxsw: Add 802.1X and MAB offload support
Message-ID: <Y2o2dB+k+yDHRVtA@shredder>
References: <cover.1667902754.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
X-ClientProxiedBy: VI1PR07CA0228.eurprd07.prod.outlook.com
 (2603:10a6:802:58::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB7419:EE_
X-MS-Office365-Filtering-Correlation-Id: d39d0bd8-ecb3-4580-6fac-08dac178417c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5zj+89bkZfciWK8n7aiHjgF7n1gltMCpRzDT0mW4QliC8DpuvyLMTXf+ZMI0UeUIZ6WP9y/EUwSBZ4CJh5wNAhrg54eTymcbWYpfJMJk0eLiKGAXInrnRgrTP1ryLgg+jfSTl0ZVc3vQAQAlfrEW43zAci6g7b+QpYsXN+gD1Qc7zQTmUWr8CTUDIvSJN6bLHH2N3JuxX8fAFG5RkixEy5GT1jxEJlwquct8gECrpNop592fzTpnQySz/bsi2DDixz3pGDSfGE04hx4SzotMqwGx9UywDWkmdazVcoLeEEL0Ve2weCF5V+8ZAGhYVCATxr5kD1T1AtwRab/oZBj7RzcSvASCywlGlomL2NuiqJv58IE6xYeF5Tq2kz/26Jsu4IMy25bdN7a90ja2f1s12/YW40/yQbK6jyEHRFFHcIZ0u88AWDrgR8RgwidFUSi8aM1gKqlH06zAHcsx2k80PxNLH2PYqJU2Zv01f2b1MNRwBOBpNH8oBwHkMFahmHhkE3iBg2snvGaAvi/HXdAhCjN9eK9c54safnO0F3m09PTXbOAYCleILXvsFfuZZP01tKsrkrzTe88KTA0THT8UbIeNRfyM0wXSUG4xcV5R6MC+HnbTFKqlXUqeOBvGR8I5t/Y2K5dsO0lN1BopoAlaEqYsFg5bjYlM1van+DxL5qSs/D9j0qx56zMiNT+oBP4tdhBmEK71b2+B6/KWE1AfHN4OSkn1lFJGuII6Qjo2tJQL092yAYFWD/X8Rju1D8xmk6h3vbL57C5z60PV3WOCR4EOvAdg9e9jSRqpODkmU7s6GhX53rpalLbAToHKBWn7fmAeKaJJEyQ/RxFqGkiIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199015)(478600001)(8936002)(9686003)(966005)(6486002)(5660300002)(4326008)(2906002)(316002)(7416002)(66556008)(8676002)(66946007)(54906003)(83380400001)(41300700001)(38100700002)(107886003)(6506007)(6666004)(86362001)(186003)(26005)(6512007)(33716001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DcIdkmgxe9kknkqmmNFvsBkDBxZBZ+ujpxCWlH9O7ge/T66EoIHKlkbGhmU7?=
 =?us-ascii?Q?3T45hnsfghrBpvx/esaj7jp4PzMU0Wg6LdvqxPhV8Uir5HX4bHcZv/p0jb/G?=
 =?us-ascii?Q?2MVH+EElyxVPUJ9BgyoGqYjyXfpfovmlgFQMo2Nw4T+R6C1v8D3p4IB7Qh1i?=
 =?us-ascii?Q?CpV6TXe4ux65KCBN9Ww9zD2t+dQg+Mqx6QrWbUE/t+TwaZ5fgse9PMffHsf9?=
 =?us-ascii?Q?C/Z3sujwmb3wfk7Q1VTPFkxM8peJNhU5LORjliUD72L6U3X6+SOTsOsQTmVU?=
 =?us-ascii?Q?4WQIq66Axh0GxKN0j7PX7wHKtQ6nifMhHRPCqBmLG5S/0gSiBkS4OxOp9EHi?=
 =?us-ascii?Q?y3fuy+F2MhsUBr4v2Gtf0yC62W4d63b8pTuhp8mMofS7uDVarLojQR4EDGth?=
 =?us-ascii?Q?tzdaak0QqWiJNLQGCF6CgrhxbTtbMODfHqdJPVAS2Sxm7u6MoA0Vc0+aTizF?=
 =?us-ascii?Q?P7Cz/b7WpdtkJounzKpntcDgGgEjPYcgq/CUb/ggH9Ngtu4fM4fGTUDUbVLc?=
 =?us-ascii?Q?DXwe941+Ow45hxHah5Oui0Fg8ZZKKvc1avSVoktlbH16Pj11+RmfmfcQuZru?=
 =?us-ascii?Q?ysyLiiHxJA3M2YXzUN9dWY0DhYc0KmaDg+FxWEWg9W2JYlwQCnef76tjBcRo?=
 =?us-ascii?Q?Uxsu84joASMG8rt0aMATLUtLCPo9RxT1N70jV2/O0JwWFC/uMzcUB+wkLOUO?=
 =?us-ascii?Q?JI91nqmzAC2cc47aX86sdDxz1vWfzZswRn9fxVW6mAgwu1/ujNoWBaKWJMbu?=
 =?us-ascii?Q?s+P8Xva9SkFLWn7loogBh9MtPVcSJlRRX4dGPhuDgNNTzdK1WM1lsCwaigwT?=
 =?us-ascii?Q?2h3mX4pB9ZOGtwj5Fuwe+6fd+X9whzC7DFeFotsZ4OO3BFo+JGo3s3NJBzLU?=
 =?us-ascii?Q?+yYO6GPA9DMGBmZc58fd/jGN3wHxXLZrKGcZZHw16fp5q+076Zxrndoouhgf?=
 =?us-ascii?Q?X4IPKaf6kAQa9xZlCUBvkJa882UpHolcKYtNmKIALlhEwWjXuFmAOGNVnMW9?=
 =?us-ascii?Q?y5OTG8v9faNEvktRqipw5SBdpf27Syo0HxL6nBbkKIky1ri5uwJlgKZYMjOU?=
 =?us-ascii?Q?ctzWdGFOl55z3UYqgGBHCQzJGmzLKgq0lKplZbkbPisXT2Thucsmts0GFvKg?=
 =?us-ascii?Q?1X3hmehn4KK3waCRFvSMSAwFXzwcmlTH4ZxkpwX5akD3YJJ3IgyUziY0ZP4F?=
 =?us-ascii?Q?ovX8iWLpwpRqU+sUtnBO1P1uxkODFZhdxMlS98RWVA/a2/XLCWVB81qycjZm?=
 =?us-ascii?Q?l3Qtp7uwLdjcdXG4mu4R8q0CyHqj5Q7rBdUUdpfEbb6BojSJm9WlwxHFJJa2?=
 =?us-ascii?Q?eSwB9D+7DBGIEQ/Ov47YvvNOSknCIvjFZPV7hewP+ddwJBtf+HcFo0NbycL/?=
 =?us-ascii?Q?1ALQOobDwpawTTYse7tApX7Gqcgl1Zb1YcWzSSV7x3G+zAoCfnoAusMUqUdu?=
 =?us-ascii?Q?UZzVFfriv6yr7TDOrdReIrxGoEwWyrOjw4o+IOrMlBMy5nRQ9sWBUivG78MT?=
 =?us-ascii?Q?47L0TtdkTYhXHhDViuTcg/OQtKoCM3t3z5QLuRVjciKh5byyYbwywVi05WmB?=
 =?us-ascii?Q?mhe4Y1v67KITwGKEVmPGhn6vBKF9+z2H6c1JohNz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d39d0bd8-ecb3-4580-6fac-08dac178417c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:59:06.7756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UiuIhkJEfEjwS84NVpn+Xr/7+Yiqe2CdBlJLpjstHxN7ikaIv3k/P5xbahAjzNn74YgulAOG7odzJT5g+V9cNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7419
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Vladimir

You weren't copied on the patches by mistake. They are available here:
https://lore.kernel.org/netdev/cover.1667902754.git.petrm@nvidia.com/

On Tue, Nov 08, 2022 at 11:47:06AM +0100, Petr Machata wrote:
> Ido Schimmel <idosch@nvidia.com> writes:
> 
> This patchset adds 802.1X [1] and MAB [2] offload support in mlxsw.
> 
> Patches #1-#3 add the required switchdev interfaces.
> 
> Patches #4-#5 add the required packet traps for 802.1X.
> 
> Patches #6-#10 are small preparations in mlxsw.
> 
> Patch #11 adds locked bridge port support in mlxsw.
> 
> Patches #12-#15 add mlxsw selftests. The patchset was also tested with
> the generic forwarding selftest ('bridge_locked_port.sh').
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a21d9a670d81103db7f788de1a4a4a6e4b891a0b
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a35ec8e38cdd1766f29924ca391a01de20163931
> 
> Hans J. Schultz (1):
>   bridge: switchdev: Allow device drivers to install locked FDB entries
> 
> Ido Schimmel (14):
>   bridge: switchdev: Let device drivers determine FDB offload indication
>   bridge: switchdev: Reflect MAB bridge port flag to device drivers
>   devlink: Add packet traps for 802.1X operation
>   mlxsw: spectrum_trap: Register 802.1X packet traps with devlink
>   mlxsw: reg: Add Switch Port FDB Security Register
>   mlxsw: spectrum: Add an API to configure security checks
>   mlxsw: spectrum_switchdev: Prepare for locked FDB notifications
>   mlxsw: spectrum_switchdev: Add support for locked FDB notifications
>   mlxsw: spectrum_switchdev: Use extack in bridge port flag validation
>   mlxsw: spectrum_switchdev: Add locked bridge port support
>   selftests: devlink_lib: Split out helper
>   selftests: mlxsw: Add a test for EAPOL trap
>   selftests: mlxsw: Add a test for locked port trap
>   selftests: mlxsw: Add a test for invalid locked bridge port
>     configurations
> 
>  .../networking/devlink/devlink-trap.rst       |  13 +++
>  drivers/net/ethernet/mellanox/mlxsw/reg.h     |  35 ++++++
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  22 ++++
>  .../net/ethernet/mellanox/mlxsw/spectrum.h    |   5 +-
>  .../mellanox/mlxsw/spectrum_switchdev.c       |  64 +++++++++--
>  .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  25 +++++
>  drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
>  include/net/devlink.h                         |   9 ++
>  include/net/switchdev.h                       |   1 +
>  net/bridge/br.c                               |   5 +-
>  net/bridge/br_fdb.c                           |  22 +++-
>  net/bridge/br_private.h                       |   2 +-
>  net/bridge/br_switchdev.c                     |   6 +-
>  net/core/devlink.c                            |   3 +
>  .../drivers/net/mlxsw/devlink_trap_control.sh |  22 ++++
>  .../net/mlxsw/devlink_trap_l2_drops.sh        | 105 ++++++++++++++++++
>  .../selftests/drivers/net/mlxsw/rtnetlink.sh  |  31 ++++++
>  .../selftests/net/forwarding/devlink_lib.sh   |  19 ++--
>  18 files changed, 366 insertions(+), 25 deletions(-)
> 
> -- 
> 2.35.3
> 
