Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F0C4BB3F2
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiBRILs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:11:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiBRILr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:11:47 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290D96415;
        Fri, 18 Feb 2022 00:11:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBO2B6XkfG2bVAc6XXE7wK01GrrZaT9BrVWBKyB/St8PJY6g7n6PD4ScOD3zlmPUn1q7rip8Z4nSJcQe73aW4F8hyYf2YfsjTZWpyQ12mMwQOUPV/F5issKbltFAZbxHpm7Qz7CiVl155eMBSY93CMwv4WA1H9DPqtcln7TYc1JAtR8OHZOg+Lmu4OcSzHAnudSKNnlfBd0QnX2/P5wJwVVHza5yZ7Z1Hsf2YRrL+4WkQD0gKLlBuH7i2NunLMxsY/bkirxYsB2L4X+vEiwr+CJCHpJKVBbtXUhz/zkA4kcKcgR0OBcrfCDs+rfAody8dxx65E5XsfphtXEoRbB+SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3zT75E4HihKKumxrVI1Z4DFNUMQxXmPvNCoHm8L4pI=;
 b=YGIJbd9hlWuJQMWZAi4y/OyuJXbzjCaSX9JnrZHJKBr/dT7dd9QoQ+Tusmf4/5cN+BhzeLG2dP51FEIqEpAk+1v5yRNZa5B8WQNKhuh5QqfSG70B/A/xVGhwXUT5prabxw5qnzYw178xQmUdBjc8/JPgbsUZ6qNwJjj6qhr8nFs0aHxBlyRWGtX0cc6T77fyH42+HS6+QkgdpmzU1imXC7DUumPFS2GOa8fKmrwiT34Hfd37L7ZhEa6tecea9TtpgAKqu9Z2jegvQpUxl/k9CTuwFDc635EGp6TE7i4p1dt/v0nddursGVRpLw5+IPcFW5mTesf3wO3le5ylwYy61g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3zT75E4HihKKumxrVI1Z4DFNUMQxXmPvNCoHm8L4pI=;
 b=hkAiw7k56M2BvRQqZTUGFTICGa+zbZ0H/kXCMfiS3Ly3mMwmxTam0bX0p4z5Z8p1bvJyHzRnUEV8+E3OTB0w9n4yT/IZT8yhFXBnVFdTjkWt1P+f1NFgYOyNGhqKaoW+0No1m7wx9Syvu7r0PaFotoC6Y3AMAxOb36ERSJQYM0kXjyzH8OhQYSjzZgWeZ/5qOJEKtCdqJVG8a6yEUcPvWuoPvh/LmdDnYsQtObss36YrIOITKDj0ek1JkW+D/SZL4NPuhbqrS4iVT5Xa1yqRefTRV4S3g2qZj1ZBBd9gkM4JA6e39qddasx75b7FjOZsMWMFMmdtl24pVdz+HX0ZQQ==
Received: from BN9PR03CA0440.namprd03.prod.outlook.com (2603:10b6:408:113::25)
 by MWHPR12MB1134.namprd12.prod.outlook.com (2603:10b6:300:c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 08:11:26 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::d2) by BN9PR03CA0440.outlook.office365.com
 (2603:10b6:408:113::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Fri, 18 Feb 2022 08:11:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Fri, 18 Feb 2022 08:11:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 18 Feb
 2022 08:11:24 +0000
Received: from [10.25.73.192] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 18 Feb 2022
 00:11:19 -0800
Message-ID: <f3af83b5-4fbe-8107-300a-d902a57335b0@nvidia.com>
Date:   Fri, 18 Feb 2022 13:41:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH V7 mlx5-next 00/15] Add mlx5 live migration driver and v2
 migration protocol
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
From:   "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb443935-0230-4c57-6d14-08d9f2b64211
X-MS-TrafficTypeDiagnostic: MWHPR12MB1134:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1134409E0D9E9A2BE827CB92B8379@MWHPR12MB1134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x43PebiDe3A7GE4cHwPCGpEaR0d1ifDVoZHCZI6T1hHx3WO0HZofrY4cqXK/xxJJQJuEqekIxEnQxEIOmZjv9zCmsbLxhWXLPflEmjqyl5pvTb+rCCkESHQ3XR3Om1klmkLnRS0LzH4m0wFpJ04kaKKbVvunYmiPxlKPDeohw9Kle60HR70JhWJj6i7OVr5/1VL/Y1oDUg32zK3OH93H80PMIg907ED6Y8XCHim7ENw/S9PdzJV/G6qZzLB2uPE8kcQfVHWQsm1rh1a0+ZONwILyngYHpTrcwB51t7CDEKtKeDe7fqBzxSYG83aVG06l4G9g6k5DwdgcGly/9KmhoFQnZWxZ0WjhJVbRzA64wisYk5xwrBpg2btjhQD9KPRbnjbfYl3baNVhGnGQNFpRPopqjxoyIpRSjOFSc0VGBBYzLNyy6MfiFegz9SxgfmNGs8osJfErwf+Y+UkaaZRUeioGZGELhLpE4XNFdPbJ/NOKn3vEFbdHpcp3wJbdYCAGCUNk7LnbMqhizK/adB7CpOs2W0MJtOLBf6qNi3te59r288YunDxC0SOYHCePh5vCFSvWzCsP3zFmmf3iQEOrWaMdC2obv+685Oh2VbKwuR1GPUZ+1dzKzjvaXuf0WkgR5CSbRJcO60johM3Ky7fzMVgJyFoDvtWAL5xViyP9y1OMOk4hPNOB68IxksgvYsdsspzfPPoK4GWtWRd/EHMKUuTljG2EQxJ0ZfkHMBEgFcI9ngW0UDFt8d8GmEOR0n5D0wOeezhohG9039hAHQxLxheYYvo8addfGxSTDkoA8to2BekUUmpGVKSf5r46LOk6L7wnh/C2UfzNwVXLDWN17qvIrBJUfEPTz+ar4tDv9nI=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(83380400001)(8676002)(2906002)(107886003)(6636002)(36860700001)(8936002)(4326008)(70206006)(70586007)(426003)(336012)(186003)(26005)(2616005)(16526019)(36756003)(53546011)(31686004)(47076005)(508600001)(6666004)(86362001)(31696002)(82310400004)(966005)(16576012)(54906003)(5660300002)(110136005)(81166007)(356005)(40460700003)(316002)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 08:11:25.3700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb443935-0230-4c57-6d14-08d9f2b64211
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1134
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 10:52 PM, Yishai Hadas wrote:
> External email: Use caution opening links or attachments
> 
> 
> This series adds mlx5 live migration driver for VFs that are migration
> capable and includes the v2 migration protocol definition and mlx5
> implementation.
> 
> The mlx5 driver uses the vfio_pci_core split to create a specific VFIO
> PCI driver that matches the mlx5 virtual functions. The driver provides
> the same experience as normal vfio-pci with the addition of migration
> support.
> 
> In HW the migration is controlled by the PF function, using its
> mlx5_core driver, and the VFIO PCI VF driver co-ordinates with the PF to
> execute the migration actions.
> 
> The bulk of the v2 migration protocol is semantically the same v1,
> however it has been recast into a FSM for the device_state and the
> actual syscall interface uses normal ioctl(), read() and write() instead
> of building a syscall interface using the region.
> 
> Several bits of infrastructure work are included here:
>   - pci_iov_vf_id() to help drivers like mlx5 figure out the VF index from
>     a BDF
>   - pci_iov_get_pf_drvdata() to clarify the tricky locking protocol when a
>     VF reaches into its PF's driver
>   - mlx5_core uses the normal SRIOV lifecycle and disables SRIOV before
>     driver remove, to be compatible with pci_iov_get_pf_drvdata()
>   - Lifting VFIO_DEVICE_FEATURE into core VFIO code
> 
> This series comes after alot of discussion. Some major points:
> - v1 ABI compatible migration defined using the same FSM approach:
>     https://lore.kernel.org/all/0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com/
> - Attempts to clarify how the v1 API works:
>     Alex's:
>       https://lore.kernel.org/kvm/163909282574.728533.7460416142511440919.stgit@omen/
>     Jason's:
>       https://lore.kernel.org/all/0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com/
> - Etherpad exploring the scope and questions of general VFIO migration:
>       https://lore.kernel.org/kvm/87mtm2loml.fsf@redhat.com/
> 
> NOTE: As this series touched mlx5_core parts we need to send this in a
> pull request format to VFIO to avoid conflicts.
> 
> Matching qemu changes can be previewed here:
>   https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2
> 
> Changes from V6: https://lore.kernel.org/netdev/20220130160826.32449-1-yishaih@nvidia.com/
> vfio:
> - Move to use the FEATURE ioctl for setting/getting the device state.
> - Use state_flags_table as part of vfio_mig_get_next_state() and use
>    WARN_ON as Alex suggested.
> - Leave the V1 definitions in the uAPI header and drop only its
>    documentation till V2 will be part of Linus's tree.
> - Fix errno's usage in few places.
> - Improve and adapt the uAPI documentation to match the latest code.
> - Put the VFIO_DEVICE_FEATURE_PCI_VF_TOKEN functionality into a separate
>    function.
> - Fix some rebase note.
> vfio/mlx5:
> - Adapt to use the vfio core changes.
> - Fix some bad flow upon load state.
> 
> Changes from V5: https://lore.kernel.org/kvm/20211027095658.144468-1-yishaih@nvidia.com/
> vfio:
> - Migration protocol v2:
>    + enum for device state, not bitmap
>    + ioctl to manipulate device_state, not a region
>    + Only STOP_COPY is mandatory, P2P and PRE_COPY are optional, discovered
>      via VFIO_DEVICE_FEATURE
>    + Migration data transfer is done via dedicated FD
> - VFIO core code to implement the migration related ioctls and help
>    drivers implement it correctly
> - VFIO_DEVICE_FEATURE refactor
> - Delete migration protocol, drop patches fixing it
> - Drop "vfio/pci_core: Make the region->release() function optional"
> vfio/mlx5:
> - Switch to use migration v2 protocol, with core helpers
> - Eliminate the region implementation
> 
> Changes from V4: https://lore.kernel.org/kvm/20211026090605.91646-1-yishaih@nvidia.com/
> vfio:
> - Add some Reviewed-by.
> - Rename to vfio_pci_core_aer_err_detected() as Alex asked.
> vfio/mlx5:
> - Improve to enter the error state only if unquiesce also fails.
> - Fix some typos.
> - Use the multi-line comment style as in drivers/vfio.
> 
> Changes from V3: https://lore.kernel.org/kvm/20211024083019.232813-1-yishaih@nvidia.com/
> vfio/mlx5:
> - Align with mlx5 latest specification to create the MKEY with full read
>    write permissions.
> - Fix unlock ordering in mlx5vf_state_mutex_unlock() to prevent some
>    race.
> 
> Changes from V2: https://lore.kernel.org/kvm/20211019105838.227569-1-yishaih@nvidia.com/
> vfio:
> - Put and use the new macro VFIO_DEVICE_STATE_SET_ERROR as Alex asked.
> vfio/mlx5:
> - Improve/fix state checking as was asked by Alex & Jason.
> - Let things be done in a deterministic way upon 'reset_done' following
>    the suggested algorithm by Jason.
> - Align with mlx5 latest specification when calling the SAVE command.
> - Fix some typos.
> vdpa/mlx5:
> - Drop the patch from the series based on the discussion in the mailing
>    list.
> 
> Changes from V1: https://lore.kernel.org/kvm/20211013094707.163054-1-yishaih@nvidia.com/
> PCI/IOV:
> - Add actual interface in the subject as was asked by Bjorn and add
>    his Acked-by.
> - Move to check explicitly for !dev->is_virtfn as was asked by Alex.
> vfio:
> - Come with a separate patch for fixing the non-compiled
>    VFIO_DEVICE_STATE_SET_ERROR macro.
> - Expose vfio_pci_aer_err_detected() to be set by drivers on their own
>    pci error handles.
> - Add a macro for VFIO_DEVICE_STATE_ERROR in the uapi header file as was
>    suggested by Alex.
> vfio/mlx5:
> - Improve to use xor as part of checking the 'state' change command as
>    was suggested by Alex.
> - Set state to VFIO_DEVICE_STATE_ERROR when an error occurred instead of
>    VFIO_DEVICE_STATE_INVALID.
> - Improve state checking as was suggested by Jason.
> - Use its own PCI reset_done error handler as was suggested by Jason and
>    fix the locking scheme around the state mutex to work properly.
> 
> Changes from V0: https://lore.kernel.org/kvm/cover.1632305919.git.leonro@nvidia.com/
> PCI/IOV:
> - Add an API (i.e. pci_iov_get_pf_drvdata()) that allows SRVIO VF drivers
>    to reach the drvdata of a PF.
> mlx5_core:
> - Add an extra patch to disable SRIOV before PF removal.
> - Adapt to use the above PCI/IOV API as part of mlx5_vf_get_core_dev().
> - Reuse the exported PCI/IOV virtfn index function call (i.e. pci_iov_vf_id().
> vfio:
> - Add support in the pci_core to let a driver be notified when
>   'reset_done' to let it sets its internal state accordingly.
> - Add some helper stuff for 'invalid' state handling.
> mlx5_vfio_pci:
> - Move to use the 'command mode' instead of the 'state machine'
>   scheme as was discussed in the mailing list.
> - Handle the RESET scenario when called by vfio_pci_core to sets
>   its internal state accordingly.
> - Set initial state as RUNNING.
> - Put the driver files as sub-folder under drivers/vfio/pci named mlx5
>    and update MAINTAINER file as was asked.
> vdpa_mlx5:
> Add a new patch to use mlx5_vf_get_core_dev() to get PF device.
> Jason Gunthorpe (7):
>    PCI/IOV: Add pci_iov_vf_id() to get VF index
>    PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata
>      of a PF
>    vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
>    vfio: Define device migration protocol v2
>    vfio: Extend the device migration protocol with RUNNING_P2P
>    vfio: Remove migration protocol v1 documentation
>    vfio: Extend the device migration protocol with PRE_COPY
> 
> Leon Romanovsky (1):
>    net/mlx5: Reuse exported virtfn index function call
> 
> Yishai Hadas (7):
>    net/mlx5: Disable SRIOV before PF removal
>    net/mlx5: Expose APIs to get/put the mlx5 core device
>    net/mlx5: Introduce migration bits and structures
>    vfio/mlx5: Expose migration commands over mlx5 device
>    vfio/mlx5: Implement vfio_pci driver for mlx5 devices
>    vfio/pci: Expose vfio_pci_core_aer_err_detected()
>    vfio/mlx5: Use its own PCI reset_done error handler
> 
>   MAINTAINERS                                   |   6 +
>   .../net/ethernet/mellanox/mlx5/core/main.c    |  45 ++
>   .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
>   .../net/ethernet/mellanox/mlx5/core/sriov.c   |  17 +-
>   drivers/pci/iov.c                             |  43 ++
>   drivers/vfio/pci/Kconfig                      |   3 +
>   drivers/vfio/pci/Makefile                     |   2 +
>   drivers/vfio/pci/mlx5/Kconfig                 |  10 +
>   drivers/vfio/pci/mlx5/Makefile                |   4 +
>   drivers/vfio/pci/mlx5/cmd.c                   | 259 +++++++
>   drivers/vfio/pci/mlx5/cmd.h                   |  36 +
>   drivers/vfio/pci/mlx5/main.c                  | 676 ++++++++++++++++++
>   drivers/vfio/pci/vfio_pci.c                   |   1 +
>   drivers/vfio/pci/vfio_pci_core.c              | 101 ++-
>   drivers/vfio/vfio.c                           | 358 +++++++++-
>   include/linux/mlx5/driver.h                   |   3 +
>   include/linux/mlx5/mlx5_ifc.h                 | 147 +++-
>   include/linux/pci.h                           |  15 +-
>   include/linux/vfio.h                          |  50 ++
>   include/linux/vfio_pci_core.h                 |   4 +
>   include/uapi/linux/vfio.h                     | 504 +++++++------
>   21 files changed, 1994 insertions(+), 291 deletions(-)
>   create mode 100644 drivers/vfio/pci/mlx5/Kconfig
>   create mode 100644 drivers/vfio/pci/mlx5/Makefile
>   create mode 100644 drivers/vfio/pci/mlx5/cmd.c
>   create mode 100644 drivers/vfio/pci/mlx5/cmd.h
>   create mode 100644 drivers/vfio/pci/mlx5/main.c
> 
> --
> 2.18.1
> 

We've tested Nvidia vGPU live migration functionality with the current 
v7 proposal and functionally, it works fine.
We're thinking of further performance optimizations to migrate large 
amounts of the data, will propose it later on after working out the details.

Thanks,
Tarun
