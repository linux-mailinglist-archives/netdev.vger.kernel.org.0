Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC126B18C1
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 02:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCIBbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 20:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjCIBbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 20:31:31 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9888115146
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 17:31:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wcmem2TY1uwlJRgWAtNinl7OmDvf48y19Ly8B3IXPat4aEMN4O7+4R8JtqetIETFfhHODOUmjrogKQAW1apmiHI7p7u94iJYOztKcSaihIqqFFUUh0u5faLKvoA36M5oaOQ/1+6BhaY6XAemqmBkYJlqKVEcXdX5GqbylsAGjrFZ3yNOUhGs3uyAzwoa17BJg6SNACfHI7gzYkBZiOqJt4JHo3XQG759hYRZD0e+ue+q42nPT7tpiXGvWiA8Kp6YHjUgx9Jf7ncJi78PLxxbQSRbZY4+cZ5hNq5dmPW3L8/2f6Q6DKFEZtVXCjPIjiAI0BZKSMEheOtGcS9033li6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hbu2dskX7n/1t9uvrndKQMy/RHnoqn3+kO+K0agIu0I=;
 b=TSmrPUMlYfOMuinS8eg0f/LS7dZ4h4nMcnaprFHyEDsHC9Ws3hfK1vq7dN9GSDSc08Vk4sH4EoKDXLXRUV30Bx0TexS378JgqBzumn52cKs37LWxMNeF/LhDXQVAUZ3XlKOjRnBlHEpHsY8KrsJFHQKmldRmg9WW+owdbAAcKLP6jxYj38C50UhEnDciGsfnQnx5cB27M+zFh0hGXaAxf4FVO+kO9oZdXIrc/7bO/y0ELEAT4Uv/vwbS6TP+7HUfefbZt7t7/081/Fy8cK2XjrwHfFNQMmpQX82wX2gKEd7V6RC1AGZBK0z+K6PI9obHfiUD0eDVFLLwP+wpZvrP/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hbu2dskX7n/1t9uvrndKQMy/RHnoqn3+kO+K0agIu0I=;
 b=XJSyWAOa+w2VyND6TTg3tB4pjnJaP8RLmoz7bNtgywSvZ22bf17A1bEy41CzqAOqyCk7RzMVAO6SdN8+xUlSahpQqx5r9dcpPbVZGSCL0oF9h/QgVHZuAJ1NQnnLypxk5nlt+FN4mLpVxXAJq8lOIvii9H4P6T7qk1OiswRlJMA=
Received: from MW3PR05CA0002.namprd05.prod.outlook.com (2603:10b6:303:2b::7)
 by DM4PR12MB5181.namprd12.prod.outlook.com (2603:10b6:5:394::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Thu, 9 Mar
 2023 01:31:26 +0000
Received: from CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::ed) by MW3PR05CA0002.outlook.office365.com
 (2603:10b6:303:2b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Thu, 9 Mar 2023 01:31:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT111.mail.protection.outlook.com (10.13.174.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.18 via Frontend Transport; Thu, 9 Mar 2023 01:31:26 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Mar
 2023 19:31:21 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC v2 virtio 0/7] pds_vdpa driver
Date:   Wed, 8 Mar 2023 17:30:39 -0800
Message-ID: <20230309013046.23523-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT111:EE_|DM4PR12MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: c63f31da-b807-4bef-5157-08db203e000d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwlK2MNEVyK0pM8SNmI6AenM2JA/PtxDtzawEfzfnGi4UbfXlJMzpgeRpOCb9+9uJv2AqRTwUGskHO016nCkGgdnLLhCb7loBrgm8DkCiZ1kfGDKkddjFKXnn2ifa/Yub0sAsLV+ACYNxNLzg5hDz3+f/eQW3BcdRuI1/W9sw6tG/T/Hf1mZ0pA8uiiiNKm/bVzkaZ7GsMZLZJv2HCK1E3TnlMt0Q5KDxdv4IRJ19ZTxRLEskG7TpsabpF/JaA4lnl/FIfCidLDrIOTYZuM3lRFQiAqo4l+J+6M9cYGUv6FMHl3nKuk/IHCrRZieEKSCPXRcr09syxj4J7r7RDx+TQUyW7CpbHKHzvQOLmH60MRI+mEBLyUL1SpRPSSLaQmOlj1J+6KaxjN7HlhwOJrrbI+fjoCus4S34D+fRg5ZI7QUakDj5AhTB6SjxUythcXqUQDQCDX3EUCd43tGWmViX96h7eSkCmkSVztEY4DgaiaMnginz/BY/RHjP9M/gD8OeWx4SQq+ZtSUu0ciXotBBWiso8mpsjE6HtNZAOSWGb9QDEPpPCX272+AbLLsuZu+wqjyaMGbH7GAb43CqlPteMYHxJE2RcgjHBDhrOy0q/97Mgl6OaHhRW3qtVOWbb8aGZgpYz/AQGC6LOY8dT5L4AsfbfhzwIYeDHcTwYIlAYJQZ9LG8qksEuCuSJkVLXYtDEUXFlp7Xwr/pyUEe0oqLBgwO87k98ebVxGCtpS2j/DvgmpUrE9gAK+XbfB08cgejq46IV1rncAQsa76ur+N5A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(46966006)(40470700004)(36840700001)(966005)(4326008)(8936002)(44832011)(36756003)(41300700001)(70206006)(70586007)(5660300002)(8676002)(2906002)(82740400003)(81166007)(86362001)(36860700001)(356005)(1076003)(6666004)(2616005)(110136005)(478600001)(316002)(82310400005)(47076005)(40480700001)(83380400001)(426003)(186003)(26005)(16526019)(336012)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 01:31:26.2428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c63f31da-b807-4bef-5157-08db203e000d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements a new module for the AMD/Pensando DSC that
supports vDPA services on PDS Core VF devices.  The pds_core driver
described here[0] creates the auxiliary_bus devices that this module
connects to, and this creates vdpa devices for use by the vdpa module.

The first version of this driver was a part of the original pds_core RFC
[1] but has since been reworked to pull out the PCI driver and to make
better use of the virtio and virtio_net configuration spaces made available
by the DSC's PCI configuration.  As the device development has progressed,
the ability to rely on the virtio config spaces has grown.

To use this module, enable the VFs and turn on the vDPA services in the
pre_core PF, then use the 'vdpa' utility to create devices for use by
virtio_vdpa or vhost_vdpa:
   echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
   devlink dev param set pci/$PF_BDF name enable_vnet value true cmode runtime
   PDS_VDPA_MGMT=`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1`
   vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:55

[0]: https://lore.kernel.org/netdev/20230308051310.12544-1-shannon.nelson@amd.com/
[1]: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

Changes:
 v2:
 - removed PCI driver code
 - replaced home-grown event listener with notifier
 - replaced many adminq uses with direct virtio_net config access
 - reworked irqs to follow virtio layout
 - removed local_mac_bit logic
 - replaced uses of devm_ interfaces as suggested in pds_core reviews
 - updated copyright strings to reflect the new owner

Shannon Nelson (7):
  pds_vdpa: Add new vDPA driver for AMD/Pensando DSC
  pds_vdpa: get vdpa management info
  pds_vdpa: virtio bar setup for vdpa
  pds_vdpa: add vdpa config client commands
  pds_vdpa: add support for vdpa and vdpamgmt interfaces
  pds_vdpa: subscribe to the pds_core events
  pds_vdpa: pds_vdps.rst and Kconfig

 .../ethernet/pensando/pds_vdpa.rst            |  84 ++
 MAINTAINERS                                   |   4 +
 drivers/vdpa/Kconfig                          |   8 +
 drivers/vdpa/Makefile                         |   1 +
 drivers/vdpa/pds/Makefile                     |  11 +
 drivers/vdpa/pds/aux_drv.c                    | 141 ++++
 drivers/vdpa/pds/aux_drv.h                    |  24 +
 drivers/vdpa/pds/cmds.c                       | 207 +++++
 drivers/vdpa/pds/cmds.h                       |  16 +
 drivers/vdpa/pds/debugfs.c                    | 201 +++++
 drivers/vdpa/pds/debugfs.h                    |  26 +
 drivers/vdpa/pds/vdpa_dev.c                   | 723 ++++++++++++++++++
 drivers/vdpa/pds/vdpa_dev.h                   |  50 ++
 drivers/vdpa/pds/virtio_pci.c                 | 281 +++++++
 drivers/vdpa/pds/virtio_pci.h                 |   8 +
 include/linux/pds/pds_vdpa.h                  | 279 +++++++
 16 files changed, 2064 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
 create mode 100644 drivers/vdpa/pds/Makefile
 create mode 100644 drivers/vdpa/pds/aux_drv.c
 create mode 100644 drivers/vdpa/pds/aux_drv.h
 create mode 100644 drivers/vdpa/pds/cmds.c
 create mode 100644 drivers/vdpa/pds/cmds.h
 create mode 100644 drivers/vdpa/pds/debugfs.c
 create mode 100644 drivers/vdpa/pds/debugfs.h
 create mode 100644 drivers/vdpa/pds/vdpa_dev.c
 create mode 100644 drivers/vdpa/pds/vdpa_dev.h
 create mode 100644 drivers/vdpa/pds/virtio_pci.c
 create mode 100644 drivers/vdpa/pds/virtio_pci.h
 create mode 100644 include/linux/pds/pds_vdpa.h

-- 
2.17.1

