Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B5C57F3DD
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiGXIEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiGXIEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:04:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C98115813
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:04:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbWAkf4DBvmopBi6gFgHjxR8lz0vcBebTmDacPppDBf/tiybSBdx3ihN/HfYptn/U2GZZLFlOeAAQTVc4CGpyh0r7ISuQ8YRKKOhGue7E/15IPWIdoAZ0oB1BqR3OlfW7XCoVm00X9Ui8rGAI3Ze07OSBxwu8gpwIH0Iu/KCRBPBUVUHaLXx5WRt8Ngwg/LHV/4KaZsgXjAMrkuf1xQOPjnfnPrBZlNjrNgzOJTzCJtABQE3if2XCQMmZS6pKDwKhjIzce0LYj5tB8lCNDV1mbpMLRV+RYDM1OxxU2C6M80RaPNWtRlpizrUf1S7YjVIvmDgAKRmS1foWh3Vdew42g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHQbZogeQ8c/KhHcKnYNKSDtVmV2njgoTHZQvz0H/zU=;
 b=DmUTVmvC8MafLbwK2YgBVQ3kVEUs701Y+cHqFYTGmdIsQb/C+R9M3PxtYz22CZAF/rDRnWCxZVBLs3IDa+kNS28HpUNEZHnCu1nvSpI7d4jgDGyy6NGZlA0qgvyHwDDsZNaP3EXcHzX96Yxh3sOqncTxIn5HvqXshzlBTNCAmBl7HkVXmr30K1/7XY6aHFI97MnlK5ZjxlBGLBiA1D73fB5I4qUiVHmYw0xo9rYcr0lHPOF0NQqG0mpchbKtNKgTBsMuA+WZu8M6iMrT6tdUxQeaGJXeag+0ecgjOgWAhCLsk/W2l7W4P4ZXfc0W9bbVr5JqAm3ZRZu53caWeowwzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHQbZogeQ8c/KhHcKnYNKSDtVmV2njgoTHZQvz0H/zU=;
 b=ur4pbk5eyhJuclQDLKpmsZM3dPPWcf6BMW1f57vKn8Ghgv6xaEYJVYHp2JpRoULIM3zJWcSqDjou1l209J/TBmVE5179rqd70Eg1h1dKxix5aPe5MOpOF5MsMhipiOHgqnsxNC68OAVQ5C4Y1RA3l7JbKaoOa85Iq0SK+4cRhIE0XcFDMhxP/+eZYb/4R1tr/hxqHiqh2kuCnFLNP/YJmIFbxVnFzfV1W29z/KhBfoyFVbWYhSRlUpeJ0K/toTVsoOEStXc6b+jMvVeVfSUFhfdmeqgwskGbGPSIDxrBbeNdF10LflecqbZhH9y1Ub+/LKF2pHTkqVjLrm+eyCXWrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:04:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:04:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/15] mlxsw: Spectrum-2 PTP preparations
Date:   Sun, 24 Jul 2022 11:03:14 +0300
Message-Id: <20220724080329.2613617-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0318.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d73bef63-adb3-4347-dc52-08da6d4b1c97
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPAT0KFLryZS4I8W8g93wX2NbDs08uaSsh1Kkq93ELYvpj7FLaqEvHvw8ObHNNQ7GJpfVcCSTEF+aTiPfma9FzYezFA5VUTuWiqgIGj9XRYE+wt9XMpSIp6d7P/NP7eL7LPy+4KPD4r2YT2Q+3y+Q8jx8c64mdQ1dCYU4AeodOG2SRheK0InmfdFSNbFm30dd7T1QfCyyEuamD5nfV5teWiKoyn7Dgcba68N+Crm0q0PC3g8X50gajYtj+Kgso5YVLaWN9uh52m6KGuLo0jwopHuz7oZp/kXkPCwv1R1S/3+XE+3eoSkpYE7YnSvZDs5q6IE2gNiXg5mDhnUij2YkmmgWL8ZysoROQ0RgFfTQiq+5db39a0pmWRSXc/NbZxwbkm2d0zJKFOSyecNGL5I8zTzkKdCPBHzNZDgimeEMHx9ZkURE4grPfqFK7z2LTPQwTKVO1j0pXJFKf0XviaOsBe46n0zlqq+VfeAvFQKoiSKmd/jsSVt5ibSlBS3HTMfucjzRORr0aUa5RfzrnnMZmV5c2IaPgdEyUxeir9vEK0tcG4e3yxn26oBbGu/+CooGvOyqk0tB0d8lRNekfLNwBgkzWFca1aQrIPqEO9EzJbaHcF9EAFvJm7ukMUt5EnaVqeH0DY2zTZ4ss56AT7jI0j9bSSHh0iy+jdUyWnwoXe00C3hV5AIKfVJ2CcOk68SiiQ5tjwvlK/6etG5fWrlLneup75Q6tLSxeRE6wNPjCc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kHgFCz8WmNhGiBdmzAlcjDifYvZyAsW0JL6lHRonT3gaSyoGuVhDj4aJqt4h?=
 =?us-ascii?Q?cGkZl43JUEMutLIZXbE7qoHuYCJJiLaN95oBPJkF80490PZgE1vWyZT3GeYF?=
 =?us-ascii?Q?fWWWBMNhk6fEPYWqKcL2Ckbrz6LtJkmEUMrz5VWJ8LLS1GJUiDvQYIwmDYVp?=
 =?us-ascii?Q?bfn2dD63PNRjUQ/lNir2xIPPw1o1WkIcKtUXO/aLgA6hj2JRP9PBOZFvh0yH?=
 =?us-ascii?Q?fBCYXYU1qJh3u0cv+vrFOV6XeiqrSS02bzGjvr1r/2B2EowuL/NMc13yzmBO?=
 =?us-ascii?Q?6raROsL0XVSDOrUROo2Pr39I8H3cStzJlSqAmD0S1orVZE0eC5NjAVvWlBvn?=
 =?us-ascii?Q?DBFdw3M/UbcGE2IkFNZ9Wj13pHSCRMkVPwIKTAw37BAotrMRkHvKlzTbqFc6?=
 =?us-ascii?Q?GHVIP7WD4DoZAGQALvg2c++dthA7mnHacMzcbeJfS2lW+Y7nN7kb2la4DCWc?=
 =?us-ascii?Q?hvdXMvv3491P/krDzrr+pqTnmMe5XlBDBOSqHbab9aKsgJ03bManK0U5BLGU?=
 =?us-ascii?Q?uA5/hfxOPR2qFOuN4WJFNiRew5JH4yqIewkw6BrKLzz+uVfgKKfP+uGfIk+4?=
 =?us-ascii?Q?cTb4N/Za2zCbTTwF/fqkNmJHjfuMCknu8KRptDayBOcTKTE1b0tlepRwMjZR?=
 =?us-ascii?Q?fcP0Ah8ol/FTbQOFlzLECHzpppBxZHolyL3E4i47Ha0IgMgnKH+QhdDt31gd?=
 =?us-ascii?Q?w6UM3CxECJHZVgOYQJjhlMuw5rGK+QvDe8NiaTxDYyJbFfxchV3WBK0/T62L?=
 =?us-ascii?Q?MBc7+ZSyLndbuSyfpwxVOwIXUcWuQjCBV1zZ0d1En+W0SAJsdDMh9XELepna?=
 =?us-ascii?Q?ND88Blw8Bv1rNgZLMuMjko2R6D0QCm6uW3G6ow15vk5Oi43Snzugfz2djepG?=
 =?us-ascii?Q?JYmGxDFHJDEO3IpYfSP/vNGGfqEErB/Pawff0tiHhx+ZRCsn6DPMuBPPj1/7?=
 =?us-ascii?Q?iCuungzm1D/hpeD+0XyHTNmAjpRk2ADfQkjvg7gvMcZraCzwwGFZtzFrQU1V?=
 =?us-ascii?Q?Mt/yDs2iTDoShICHCcjgZy8FMJgDjmAyhto5h37xVutam2X2XNAgbU9vuvbZ?=
 =?us-ascii?Q?nZM1ZvvvbQ3lrkynDJ2c4BANU1G4/i3E8JtXglAcsECnwDAcyaBuzHknEbgj?=
 =?us-ascii?Q?jBBsIJGRtIzvA3LXeewRMQW+RqwAq93NFMTNAPaKeOhrbW5OMlRqpz6jo1Li?=
 =?us-ascii?Q?PWf1eAe04MNAVqg2jMnpE8GDJj3PwPxgTjUAKl8vkKdqHpvWq2IffZu/yTA/?=
 =?us-ascii?Q?B+trs7OFTKZLkgA5f9P+fZkza0fHpE9L5eZ/FlxAx95SMUa0JByVe9GvPVfJ?=
 =?us-ascii?Q?efp/mgh4ooMbWMLBjALkRiyiF4Zmh6l+vonE5Jy/jZFWH/Sg3FqrqUGdZ+SO?=
 =?us-ascii?Q?+CqGKZtX/teI3DwBc8zG6aXkFf24YAPozNYa5taw4M9HDQ7/Qw4qZsG0bjCe?=
 =?us-ascii?Q?OmsQo/HFshILgMjP0/44OSOuINo9OsMWscEvV/eJJTOCmXAYEUNXaBGVrVFd?=
 =?us-ascii?Q?xJRL5pzkc5sysaVCeN03Oh5gmNgdK/cw4i/3/ch/uPaUBvaRSBgx48rXn2JP?=
 =?us-ascii?Q?coJmfb5RGPe+rKasuvtJhBvDQU5zKJnTQ2O4kAqd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d73bef63-adb3-4347-dc52-08da6d4b1c97
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:04:19.7285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwqZ/czUWK5R4qG6hSAPmp6oNfKOVnHHx6ZSsJP/u+hMphcDiQPZnj8V7rcRSBf+nYf6gC+hPQ21UakmfdaWJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes various preparations required for Spectrum-2 PTP
support.

Most of the changes are non-functional (e.g., renaming, adding
registers). The only intentional user visible change is in patch #10
where the PHC time is initialized to zero in accordance with the
recommendation of the PTP maintainer.

Amit Cohen (7):
  mlxsw: resources: Add resource identifier for maximum number of FIDs
  mlxsw: spectrum_ptp: Initialize the clock to zero as part of
    initialization
  mlxsw: pci: Simplify FRC clock reading
  mlxsw: spectrum_ptp: Use 'struct mlxsw_sp_ptp_state' per ASIC
  mlxsw: spectrum_ptp: Use 'struct mlxsw_sp_ptp_clock' per ASIC
  mlxsw: spectrum_ptp: Rename mlxsw_sp_ptp_get_message_types()
  mlxsw: spectrum_ptp: Rename mlxsw_sp1_ptp_phc_adjfreq()

Danielle Ratson (8):
  mlxsw: Rename mlxsw_reg_mtptptp_pack() to mlxsw_reg_mtptpt_pack()
  mlxsw: reg: Add MTUTC register's fields for supporting PTP in
    Spectrum-2
  mlxsw: reg: Add Monitoring Time Precision Correction Port
    Configuration Register
  mlxsw: pci_hw: Add 'time_stamp' and 'time_stamp_type' fields to CQEv2
  mlxsw: cmd: Add UTC related fields to query firmware command
  mlxsw: Set time stamp type as part of config profile
  mlxsw: spectrum: Fix the shift of FID field in TX header
  mlxsw: Rename 'read_frc_capable' bit to 'read_clock_capable'

 drivers/net/ethernet/mellanox/mlxsw/cmd.h     |  52 ++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  27 +++-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h  |  81 +++++++++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  99 +++++++++++-
 .../net/ethernet/mellanox/mlxsw/resources.h   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 148 +++++++++++-------
 8 files changed, 344 insertions(+), 77 deletions(-)

-- 
2.36.1

