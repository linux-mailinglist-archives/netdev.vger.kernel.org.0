Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D189E6293E3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiKOJI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiKOJI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:08:56 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2131.outbound.protection.outlook.com [40.107.93.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E0C194
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:08:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaZwJkrxi7qnF8EOA3Ow2gL3u6iEoG3Yf63PezAzWkRnEooeY3cY3wJa2i43a6UeUrG6peJneRepw/sXOCHWtC8yF633/DUXoMDZU3cVJ62clS2KakNF5udJ9tIdlko6SpQYUdfrl+c+fdJiyoKPwUVi2RjF6iYUAx3FmC/sKd8JUD5Z1g5SkEtPLeY/iwECFuWtsAXiz94LcvKP7Kti1XMMt6SBR/RifGuPx/LS8ZQ/LCYrnB+3q6aPCLFDV1C9W77QtUDrSbBISoKqd2dfgq4QCi2ag6Dtp8K/W4YGaUH7apkBvy+M3iMdLVwlpUS16YEGVxHHVsGo0x8Gs3PLHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwcTqLjy0Bmlr3plt2uD9OTbBg7gQB6S5aKvrRZMREw=;
 b=OI+Q3gbbvU/G+J8aCd/leWVsUuoHFr8KMb8vnJmHq4MIcuA9QZc9f2WRjPQ+0L96Qq5H3gS2PZ0yEMSRL3gm7cIfyNoqTJpi+fqN/2gq2xJBAdPzbjL5kdaNy2oM/JwSXAuszc4cwZzA/MN8qQT0xPmGoOAelHPLyVlwqPnmMxS5WTLi52Q01JrZE9vT9X8cTpI1ARPGmMnqAfqQKVjqk5YzkoyHaRcWm0m8f/6q1UFDz/tWCALE/kmH9SW8mVDU8OVvm1zh4188r10R52R6Gga+WP0ks8plB6r2VFZNzMbbAfFwCzjeVorFt+UY8949WZVgazbsqjBvwV+N6NviTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwcTqLjy0Bmlr3plt2uD9OTbBg7gQB6S5aKvrRZMREw=;
 b=dh5ht9Q4iA/qrygizMO+6lX7QB6fXwWquuR2POAimJ0rJ9RekZ4ixo3t2D+YE3weknfzqOpZTvluasHpRxpGWdZ0e6qCTBNyTT0MdpIetn5DxBE05igtIJiyCotDyyC0ylI49xTnDFPQzzZT95YvsC/aiz9aNjGZMTZ43TbdPo4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3774.namprd13.prod.outlook.com (2603:10b6:208:1ed::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 09:08:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 09:08:52 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Leon Romanovsky <leon@kernel.org>,
        Walter Heymans <walter.heymans@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3] Documentation: nfp: update documentation
Date:   Tue, 15 Nov 2022 10:08:34 +0100
Message-Id: <20221115090834.738645-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3774:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e15ad71-4b82-41aa-11d5-08dac6e903c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6QNkKJdgjMbYalYjIJenusnlYg3NTh2L3je0arjCsw+SwVcjEhWmpz3mzEULYUnf9fLLHulwU2onHyHJ+4lFHk3krpJQNDRRKyH0MYpWy6W4JEQP/Jd/b8WB/nINGdOV6i2YCp6AMnn/3mGdRz+oSxLza+el9HyTwMG2k+iGdGXahW/fREVnMWFuCXsQOiKYwCdFxbTRBDp9lplQNWNWPSbmBoc2+1Fp7ht/z0Xhhqbd2sayOEU+zzVrmZUkvDTwCV10jAtGl3ud165bXhFnTCQjfdw4HxARegZiZo3w3HUrzVU4d6nv0TrIFX5d5MhXSj6T7gWTioPbBy0Y+AAJVRa+w5Db3dSX4rFjFK5XZ1POLDFgkrVuPYErRs8dSvDLHij1bcNSeVWm6HHI67WgunMlrETumbl14xKsR5KU4izXP0NU1hnmu8EeX7vi5HvyiJjTrXZZFG1RAD7lXT7FuFi+n0EoFsNA02eCGF4lCzBe/nokafl9FnovS+imsPoqVHBMQxKFEkNTtT3f/wG7/CUl9wZEn9lP0SNfwqRivM+l6MDJl9v1vzWL3q77Ru9sqlJHMHhpqGyAS0UOyWnNkFqYrAZQN/BRQqBcBaopV95tWDbJuQwi97fYn8zFRykocjrgi15Avrll4REV0YIYGM/V4+PiXfiu+JoeS4pd/WH+/LJwWO/nmkKl598/4MXIp9kLRRpxJ0cKfFVyU2Trp5DtSa1RKP4FfX6g9te9MI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39840400004)(366004)(376002)(451199015)(36756003)(8676002)(8936002)(83380400001)(15650500001)(41300700001)(2906002)(54906003)(38100700002)(86362001)(110136005)(66946007)(478600001)(2616005)(186003)(66574015)(6486002)(4326008)(1076003)(107886003)(316002)(5660300002)(6512007)(6506007)(6666004)(44832011)(66556008)(66476007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGF2YTlkdVpEdkRFY1o2Nm1scHNmUEpMVlBUUzdsWEgxc3VwMXFST2hJbWZY?=
 =?utf-8?B?RzZVMS92dUUyQjJXd05NTTZTUWZWVFRUQkgySW1VRUhGSnJBUjVpTXZpM3F0?=
 =?utf-8?B?Q3BEQVpPU3lBVlZTUm1iVU42anUzYUZFOFNCcExHRFlRSHFxK09xRWFyaFha?=
 =?utf-8?B?MjdOdXkwZDBDOVVGcnRsdllRNWg1MkZmOCtLZkFUU3BoVGY3aXdJcnpEVEpl?=
 =?utf-8?B?RDdZMWVhQVgvdjdDbHZWOFVMU0JYMXBoa3UxaFVTS3FFODlOQnhwNDU2aktY?=
 =?utf-8?B?cUpLK1dMYjNta3ZRNUhRbjRsaDBVVnRpeTh4ZmpGQjloaEJ4SE01empqMHpF?=
 =?utf-8?B?UUZEYUF2dXVDc3pWenRQbkZVTlNlN2tsRmQwWG5maFF3NlBNd05maFRDaFo1?=
 =?utf-8?B?UjRjSVg0SGo4QTcxWlNBRGN5MERLbGloTXZHdnBPaFFXeDU4QTNkUDdUQWdK?=
 =?utf-8?B?RWxsQW9vekFpQno3aTIrRkhhaU80WEFoRnlKK09mTUhSUHByRVpkREFERllL?=
 =?utf-8?B?Y1NhNERUQ2RNd3BSQ2xhQ3pUeTJtL3dYNndXU01LK2tqdFBTRFhHdjBCWHpJ?=
 =?utf-8?B?T0JkOUdDZ2hMVzBVSlNXaUNnUXYvTk9BWUpZdkl3UlFSc3lmT2xMRlZNTXln?=
 =?utf-8?B?VzZlL0toNU4yc3BQSzUwV1RNRTB3bGRMSVpKREJzTTVETmVWUExGZnhZZDRG?=
 =?utf-8?B?dVNIMGh5eUVLb05nN0U1Tk13eWxKZmZiMW1ZUjBqVit3SERpZFcrS1VDNTRj?=
 =?utf-8?B?cEtSOUp6bEt2YldFQ21LMmFHLzE3alFuekRyd2VCVjNTRjdSZHNubk5HWFpP?=
 =?utf-8?B?YXBlZmlneWVVZy94WG9HZmppa0w3M25mMXR5TWFHSExKSDFrZ2MyQURMazJi?=
 =?utf-8?B?VnFOcFZ3UkljaUpvazZTRVBEZmJtRjBtVm05eGxHbXRmYnhVSHpSN2RBV2Zy?=
 =?utf-8?B?dTc2Zmk1NXBRaDQ4WHI0ZG14YWJLZGZtZHAwNUhWdytFUFRYRzg0ZkZxYTNm?=
 =?utf-8?B?UjdEYkpYU0l1Nm5jU3BlMm9GNW1SMjBmZXZ4U2tGczFJZkpnL29sR0s2bi9J?=
 =?utf-8?B?ZFQ5QkNsNGRUbC82VnZ5RXQrOWpFb3Jla29hczBzemdGcjU3bTVSMGwvUytG?=
 =?utf-8?B?VFAyRm91TzIrUEcyc05Rb25nZStLcm44M2Y2TWFZYlR0a3hhaGQybUdUQUNa?=
 =?utf-8?B?Siszei9xcmdVQkI0aUZMenFZaFlMODB5cW9EK1JDYkRzVUlreTNxbW9EM21y?=
 =?utf-8?B?OXAycDc2NDA5ZGVXeHRrSG1MajFZUlZpb1ZsVStuTzI2dFFxRWRtdWpmaGhp?=
 =?utf-8?B?WjcyZC9rOG0wZUh0cWVrY05VVXZ6cXZ4U2hkYitVVkZaYlUwVTZWckRvME42?=
 =?utf-8?B?OGJhMDBIanZ0RXhuaXJRNUFjM0hKemFYZDVLMHh3cGV4TnZQdXEzNFBFeWJy?=
 =?utf-8?B?Ty9WQ1J3RE9TWTV0YThqeVhOTmpjQnAzQys1c2tGWHI3dmttMHZWeDhDb2Ur?=
 =?utf-8?B?Yi9wRW1rMEQzeVoveFF5OGRBdmZqZHl1QVc0MFc3LysybHZjQ2hjU3dKdXZl?=
 =?utf-8?B?QUxCWk13bDhQWDBMQy9TNmtZOFcvemJpZUpOc3JhMjVCWVRFdmVPdFNRa0xp?=
 =?utf-8?B?ZFJ4UnoyS2RlZlVLamNTSlVrZy9KOWQyLyt3UUxFcWRzbGhpcUxGNlZ0aG5V?=
 =?utf-8?B?bXpmalZ3a2lUYTJ6QkdueEJ3K0d3c1JralN3M2ZLZmFuQkxJTFZ6VVNhSEd4?=
 =?utf-8?B?ei8zcWcwZUdEK2JkVGFyUWEzeC8rWlJ1RXJFM0RmNFNSVExVMllaYnhXdlhr?=
 =?utf-8?B?Unk3L3NNekFoQU5uU3JaZGdsaE16TmgySlM0NmcvSEdtaFdmaFhJVm90SlF6?=
 =?utf-8?B?cW15WXdUSXp2YXFYVURKQk04QUNZUXJtaFk4dGdPZU1BY1d6V1FkQnQ4OWRN?=
 =?utf-8?B?MVJZaERIQVBVYi9XTGtxUitESTRTcnJaT3RVMFlPTzUvSEVhZmx3S056M2Vi?=
 =?utf-8?B?b3FHYU03NVBHTmJ5NkpRMWNIV0FDZUkvWTZraHhsZ0dWdmx5US9xTHJ5VUJR?=
 =?utf-8?B?NEF0NmlEZzVaNlZxU29HdENOdDI1U25rRk1JL084WkhUV0FvM0Q5OFhHZnJ1?=
 =?utf-8?B?VTJNSWkxOFdRQitOTWFTWDRkSm5QbHEwaWFFYkZOdG13NEQraGh4cHlvQVZM?=
 =?utf-8?B?M21oMHB5azZHdzZDb3VwakxBMVd2c0xTY2Rnd3gwVndyK2R2QWlDTmRTdDZ1?=
 =?utf-8?B?eDFnUHU4a3g4MzJWY1JUYUFRSFpnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e15ad71-4b82-41aa-11d5-08dac6e903c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 09:08:52.1719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLcioRtLAmftG0OcETF1RJ/2a99pGMaI+a12bel+cbOZfGxIeegiMoeufH7ZjTMJhLBsegSbabSWdYh1MpXnVtriSJPfutFWPhZtRAKduj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3774
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Walter Heymans <walter.heymans@corigine.com>

The NFP documentation is updated to include information about Corigine,
and the new NFP3800 chips. The 'Acquiring Firmware' section is updated
with new information about where to find firmware.

Two new sections are added to expand the coverage of the documentation.
The new sections include:
- Devlink Info
- Configure Device

Signed-off-by: Walter Heymans <walter.heymans@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../device_drivers/ethernet/netronome/nfp.rst | 165 +++++++++++++++---
 1 file changed, 145 insertions(+), 20 deletions(-)

v3
* Moved changelog (this) to after scissors (---)

v2
* Add missing include of isonum.txt for unicode macro |copy|

diff --git a/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
index ada611fb427c..650b57742d51 100644
--- a/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
+++ b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
@@ -1,50 +1,57 @@
 .. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+.. include:: <isonum.txt>
 
-=============================================
-Netronome Flow Processor (NFP) Kernel Drivers
-=============================================
+===========================================
+Network Flow Processor (NFP) Kernel Drivers
+===========================================
 
-Copyright (c) 2019, Netronome Systems, Inc.
+:Copyright: |copy| 2019, Netronome Systems, Inc.
+:Copyright: |copy| 2022, Corigine, Inc.
 
 Contents
 ========
 
 - `Overview`_
 - `Acquiring Firmware`_
+- `Devlink Info`_
+- `Configure Device`_
+- `Statistics`_
 
 Overview
 ========
 
-This driver supports Netronome's line of Flow Processor devices,
-including the NFP4000, NFP5000, and NFP6000 models, which are also
-incorporated in the company's family of Agilio SmartNICs. The SR-IOV
-physical and virtual functions for these devices are supported by
-the driver.
+This driver supports Netronome and Corigine's line of Network Flow Processor
+devices, including the NFP3800, NFP4000, NFP5000, and NFP6000 models, which
+are also incorporated in the companies' family of Agilio SmartNICs. The SR-IOV
+physical and virtual functions for these devices are supported by the driver.
 
 Acquiring Firmware
 ==================
 
-The NFP4000 and NFP6000 devices require application specific firmware
-to function.  Application firmware can be located either on the host file system
+The NFP3800, NFP4000 and NFP6000 devices require application specific firmware
+to function. Application firmware can be located either on the host file system
 or in the device flash (if supported by management firmware).
 
 Firmware files on the host filesystem contain card type (`AMDA-*` string), media
-config etc.  They should be placed in `/lib/firmware/netronome` directory to
+config etc. They should be placed in `/lib/firmware/netronome` directory to
 load firmware from the host file system.
 
 Firmware for basic NIC operation is available in the upstream
 `linux-firmware.git` repository.
 
+A more comprehensive list of firmware can be downloaded from the
+`Corigine Support site <https://www.corigine.com/DPUDownload.html>`_.
+
 Firmware in NVRAM
 -----------------
 
 Recent versions of management firmware supports loading application
-firmware from flash when the host driver gets probed.  The firmware loading
+firmware from flash when the host driver gets probed. The firmware loading
 policy configuration may be used to configure this feature appropriately.
 
 Devlink or ethtool can be used to update the application firmware on the device
 flash by providing the appropriate `nic_AMDA*.nffw` file to the respective
-command.  Users need to take care to write the correct firmware image for the
+command. Users need to take care to write the correct firmware image for the
 card and media configuration to flash.
 
 Available storage space in flash depends on the card being used.
@@ -79,9 +86,9 @@ You may need to use hard instead of symbolic links on distributions
 which use old `mkinitrd` command instead of `dracut` (e.g. Ubuntu).
 
 After changing firmware files you may need to regenerate the initramfs
-image.  Initramfs contains drivers and firmware files your system may
-need to boot.  Refer to the documentation of your distribution to find
-out how to update initramfs.  Good indication of stale initramfs
+image. Initramfs contains drivers and firmware files your system may
+need to boot. Refer to the documentation of your distribution to find
+out how to update initramfs. Good indication of stale initramfs
 is system loading wrong driver or firmware on boot, but when driver is
 later reloaded manually everything works correctly.
 
@@ -89,9 +96,9 @@ Selecting firmware per device
 -----------------------------
 
 Most commonly all cards on the system use the same type of firmware.
-If you want to load specific firmware image for a specific card, you
-can use either the PCI bus address or serial number.  Driver will print
-which files it's looking for when it recognizes a NFP device::
+If you want to load a specific firmware image for a specific card, you
+can use either the PCI bus address or serial number. The driver will
+print which files it's looking for when it recognizes a NFP device::
 
     nfp: Looking for firmware file in order of priority:
     nfp:  netronome/serial-00-12-34-aa-bb-cc-10-ff.nffw: not found
@@ -106,6 +113,15 @@ Note that `serial-*` and `pci-*` files are **not** automatically included
 in initramfs, you will have to refer to documentation of appropriate tools
 to find out how to include them.
 
+Running firmware version
+------------------------
+
+The version of the loaded firmware for a particular <netdev> interface,
+(e.g. enp4s0), or an interface's port <netdev port> (e.g. enp4s0np0) can
+be displayed with the ethtool command::
+
+  $ ethtool -i <netdev>
+
 Firmware loading policy
 -----------------------
 
@@ -132,6 +148,115 @@ abi_drv_load_ifc
     Defines a list of PF devices allowed to load FW on the device.
     This variable is not currently user configurable.
 
+Devlink Info
+============
+
+The devlink info command displays the running and stored firmware versions
+on the device, serial number and board information.
+
+Devlink info command example (replace PCI address)::
+
+  $ devlink dev info pci/0000:03:00.0
+    pci/0000:03:00.0:
+      driver nfp
+      serial_number CSAAMDA2001-1003000111
+      versions:
+          fixed:
+            board.id AMDA2001-1003
+            board.rev 01
+            board.manufacture CSA
+            board.model mozart
+          running:
+            fw.mgmt 22.10.0-rc3
+            fw.cpld 0x1000003
+            fw.app nic-22.09.0
+            chip.init AMDA-2001-1003  1003000111
+          stored:
+            fw.bundle_id bspbundle_1003000111
+            fw.mgmt 22.10.0-rc3
+            fw.cpld 0x0
+            chip.init AMDA-2001-1003  1003000111
+
+Configure Device
+================
+
+This section explains how to use Agilio SmartNICs running basic NIC firmware.
+
+Configure interface link-speed
+------------------------------
+The following steps explains how to change between 10G mode and 25G mode on
+Agilio CX 2x25GbE cards. The changing of port speed must be done in order,
+port 0 (p0) must be set to 10G before port 1 (p1) may be set to 10G.
+
+Down the respective interface(s)::
+
+  $ ip link set dev <netdev port 0> down
+  $ ip link set dev <netdev port 1> down
+
+Set interface link-speed to 10G::
+
+  $ ethtool -s <netdev port 0> speed 10000
+  $ ethtool -s <netdev port 1> speed 10000
+
+Set interface link-speed to 25G::
+
+  $ ethtool -s <netdev port 0> speed 25000
+  $ ethtool -s <netdev port 1> speed 25000
+
+Reload driver for changes to take effect::
+
+  $ rmmod nfp; modprobe nfp
+
+Configure interface Maximum Transmission Unit (MTU)
+---------------------------------------------------
+
+The MTU of interfaces can temporarily be set using the iproute2, ip link or
+ifconfig tools. Note that this change will not persist. Setting this via
+Network Manager, or another appropriate OS configuration tool, is
+recommended as changes to the MTU using Network Manager can be made to
+persist.
+
+Set interface MTU to 9000 bytes::
+
+  $ ip link set dev <netdev port> mtu 9000
+
+It is the responsibility of the user or the orchestration layer to set
+appropriate MTU values when handling jumbo frames or utilizing tunnels. For
+example, if packets sent from a VM are to be encapsulated on the card and
+egress a physical port, then the MTU of the VF should be set to lower than
+that of the physical port to account for the extra bytes added by the
+additional header. If a setup is expected to see fallback traffic between
+the SmartNIC and the kernel then the user should also ensure that the PF MTU
+is appropriately set to avoid unexpected drops on this path.
+
+Configure Forward Error Correction (FEC) modes
+----------------------------------------------
+
+Agilio SmartNICs support FEC mode configuration, e.g. Auto, Firecode Base-R,
+ReedSolomon and Off modes. Each physical port's FEC mode can be set
+independently using ethtool. The supported FEC modes for an interface can
+be viewed using::
+
+  $ ethtool <netdev>
+
+The currently configured FEC mode can be viewed using::
+
+  $ ethtool --show-fec <netdev>
+
+To force the FEC mode for a particular port, auto-negotiation must be disabled
+(see the `Auto-negotiation`_ section). An example of how to set the FEC mode
+to Reed-Solomon is::
+
+  $ ethtool --set-fec <netdev> encoding rs
+
+Auto-negotiation
+----------------
+
+To change auto-negotiation settings, the link must first be put down. After the
+link is down, auto-negotiation can be enabled or disabled using::
+
+  ethtool -s <netdev> autoneg <on|off>
+
 Statistics
 ==========
 
-- 
2.30.2

