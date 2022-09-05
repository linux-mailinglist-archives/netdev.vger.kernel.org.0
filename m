Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17685AD457
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiIEN4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiIEN4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:56:38 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2049.outbound.protection.outlook.com [40.107.100.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDAA59256;
        Mon,  5 Sep 2022 06:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMjKGZ1WrgiHGYZlnZmjnl0+UCprK096yuGsWOOw079uHGgatgW1bCyZ7ulo4Tr45diwJeA3lbWWb25WsbwpZ2gf2OvnOWdwY4HO2RUr4qGkcIt/drS5L0fzZ1BLqyL/Nv7jE/A++Ek7Eh7asvebohQDcHQ5ogj8dYgcoynDDt5JfaQm8b69iu71C9CzQq6RChLz5I/7SP9yQjZ4PPT+UNmbknb61HL3BRPfb11wJTi2exoZ1RnsTB9QBXhHL2gC9oxR38xQe8HLUf/L2AyukKPKlpTsG1fShMe+dOnLfaW0vGkYaUgcRNYapANFn1NefIPYFEuFZb8chtkIhkAgcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2HJhcAIHq3Ep+UWAyX38FarJsxjGbelFKHII0mhI74=;
 b=YtGfasfxbsrCbPEMYmaq4Lol2eASo2aej6HUmuBv2V5Mjt8ftMzP2nO8/ErNnwJgIS4ihzhPdLXyovzYZScsKWWawfI8uHT2szqjx94Fm6YwRyWjfBM6x1Y0fOmTI3zNmrbLF46YA8/MSTz/HWirKfzI7XZW6eDpok1mWlwAIm0Ch48ETbVvJLrlrS0hcKTEHMr0IThTsJ6XuUyvmgupNiW1iKfBkfXpujx82dldUU5oTmW94UpPeFk2GkZ7EA7jpwZWdsecwPQjaLZGjZphCDlSuyQxrOcdQ/alWH+OP20zkUYzFBwUD5G6NCyyF1kV6wyRInYBqDWlP5fPPZzOVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2HJhcAIHq3Ep+UWAyX38FarJsxjGbelFKHII0mhI74=;
 b=qaOQMhXznbT5qO+Z/BV6od4HTwUPZUPtMN0OcPUhbfUuezLJT1qLQAuIe9kLqwFGTR6H6qk+dRtqC5CvIyTWADxf3JaeJRNzRqc7omcfPqLVk6g/ToJMZtxzkedkLoLz7bGAUr7bfSpKWKgsf5in0Zf/oG2JF3PIfQh7Rm3GgdPVh+8kudcMYFSkVEipgUbStsW8iCbOLkFXp39wA//JNR/E18fy0MaJdEZaSms6TRvorzIQJ4piaZIPaaIUWf/H4M0u3kJ2goIqJ6egVP7lrK/+zeAsiSjWOx19R0jPiKtD2PJ3yXidn9lLiqJoIA6PzXsoHArZcYw1vNU3ChOrcA==
Received: from BN0PR02CA0013.namprd02.prod.outlook.com (2603:10b6:408:e4::18)
 by BY5PR12MB4260.namprd12.prod.outlook.com (2603:10b6:a03:206::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 13:56:32 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::88) by BN0PR02CA0013.outlook.office365.com
 (2603:10b6:408:e4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Mon, 5 Sep 2022 13:56:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.10 via Frontend Transport; Mon, 5 Sep 2022 13:56:32 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 5 Sep
 2022 08:56:31 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 5 Sep
 2022 06:56:30 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 5 Sep 2022 08:56:26 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <michael.chan@broadcom.com>,
        <andy@greyhouse.net>, <saeed@kernel.org>, <jiri@resnulli.us>,
        <snelson@pensando.io>, <simon.horman@corigine.com>,
        <alexander.duyck@gmail.com>, <rdunlap@infradead.org>,
        <parav@nvidia.com>, <roid@nvidia.com>,
        <marcin.szycik@linux.intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next] docs: net: add an explanation of VF (and other) Representors
Date:   Mon, 5 Sep 2022 14:55:57 +0100
Message-ID: <20220905135557.39233-1-ecree@xilinx.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51e0d24b-c708-4333-9d8a-08da8f467061
X-MS-TrafficTypeDiagnostic: BY5PR12MB4260:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GgG2qku4o5RDVtf7h4kRu9Ryp3uj2QIA7YndbB/Eypefz+0lSnPQ+3+gvhMD58gkjYKh6gQH+vLtYsPwdwc4WqeK9DBVEzPUKqfbr7ULRnOUCdivVThFfWkQ5A3tnOzw4fXEdDgX8z36Kow/fy5g4MopaHkPBzNBNA3FBq8LB1VUQDluUSnZxlPicMUGug21ciuI0Yd0hVEbqY4VDpzBjLBgWvy7+MNlzW8PpmTr9kRuyDbsqqgW8gCTIHpbqULwO0WESNMxIlVXur9KiwNygmZLQvfPH9IWVok3QwueZUbQ2YxyE6SGbGkvm8jXeOycZzCGfQB9yx7DtL7GINJtUccvsOcZy8dlctkiKCHhiEmB8uU1+0QHTH5nSr05UUpmm2sFC/vJ8KNFEyYPSxEA2O95kbuKW2VZrCxHPMdV+1dnjxChLjwcP30BwF9x2IISNo1o6arSj0TmsrUWn8k3sGq9QbwlbBhkCKsnMnBYRHBokLaFzXduWmRKOH9CzNq0gelbryyChldtFU2Px/ZgeodL5a3UejBapdNZCb0mMgid6zweVbHbtm218KtSkzNXEvpruJY0mSyH+7bUss5TzLpMnl8JkUBrCZtug/pNDoE6FX4kaAeT4RymimKTaiQo5VhwRRtYQtZNSEu6oNrhb8iezxa11hbcWaslVFWzmazVtgYj4xasEU1DUJwMnWXtng7Zq1svMcKMKfEeTbxJMCZto07/plQUKV68ZOqcxVob7rZSMCzN/jHcfhpRNfwgzIOUBj5BHQkFsnbRnqxavFLy4Ed0PcrVpPxOc+yzQ5uWXSV/me81Kkj9sYcYW8sP
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(39860400002)(40470700004)(36840700001)(46966006)(40480700001)(82310400005)(2906002)(110136005)(54906003)(36756003)(40460700003)(316002)(356005)(81166007)(2876002)(83170400001)(8676002)(8936002)(5660300002)(336012)(36860700001)(7416002)(4326008)(82740400003)(83380400001)(47076005)(70206006)(70586007)(42882007)(41300700001)(186003)(2616005)(1076003)(30864003)(7696005)(6666004)(478600001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 13:56:32.1649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e0d24b-c708-4333-9d8a-08da8f467061
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4260
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

There's no clear explanation of what VF Representors are for, their
 semantics, etc., outside of vendor docs and random conference slides.
Add a document explaining Representors and defining what drivers that
 implement them are expected to do.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changed in v3:
 - renamed "master PF" to "switchdev function" (Parav)
 - reworded sentence in Motivation that caused some confusion (Marcin)
 - fixed preposition to->by (Parav)
 - used the word "external" when talking about other PCIe controllers, for
   consistency with devlink port documentation (Parav)
 - added more explanation about virtio-blk representors, and the conceptual
   point I was trying to use them to illustrate
 - made it more explicit that vswitch ports, and thus representors, can appear
   dynamically at run time, not just at probe (Parav)
 - used $VARIABLES for netdev names in TC rule examples (Marcin)

Changed in v2:
 - incorporated feedback from Jakub including rewrite of the Motivation section,
   representors for uplink/phys port, replace phys_port_name conventions with
   devlink port.
 - fixed archaic spelling (Randy)
 - painted the bike shed blue ("master PF") for now, we can always change it
   again later
 - added Definitions section
---
 Documentation/networking/index.rst        |   1 +
 Documentation/networking/representors.rst | 259 ++++++++++++++++++++++
 Documentation/networking/switchdev.rst    |   1 +
 3 files changed, 261 insertions(+)
 create mode 100644 Documentation/networking/representors.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 03b215bddde8..c37ea2b54c29 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -93,6 +93,7 @@ Contents:
    radiotap-headers
    rds
    regulatory
+   representors
    rxrpc
    sctp
    secid
diff --git a/Documentation/networking/representors.rst b/Documentation/networking/representors.rst
new file mode 100644
index 000000000000..ee1f5cd54496
--- /dev/null
+++ b/Documentation/networking/representors.rst
@@ -0,0 +1,259 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============================
+Network Function Representors
+=============================
+
+This document describes the semantics and usage of representor netdevices, as
+used to control internal switching on SmartNICs.  For the closely-related port
+representors on physical (multi-port) switches, see
+:ref:`Documentation/networking/switchdev.rst <switchdev>`.
+
+Motivation
+----------
+
+Since the mid-2010s, network cards have started offering more complex
+virtualisation capabilities than the legacy SR-IOV approach (with its simple
+MAC/VLAN-based switching model) can support.  This led to a desire to offload
+software-defined networks (such as OpenVSwitch) to these NICs to specify the
+network connectivity of each function.  The resulting designs are variously
+called SmartNICs or DPUs.
+
+Network function representors bring the standard Linux networking stack to
+virtual switches and IOV devices.  Just as each physical port of a Linux-
+controlled switch has a separate netdev, so does each virtual port of a virtual
+switch.
+When the system boots, and before any offload is configured, all packets from
+the virtual functions appear in the networking stack of the PF via the
+representors.  The PF can thus always communicate freely with the virtual
+functions.
+The PF can configure standard Linux forwarding between representors, the uplink
+or any other netdev (routing, bridging, TC classifiers).
+
+Thus, a representor is both a control plane object (representing the function in
+administrative commands) and a data plane object (one end of a virtual pipe).
+As a virtual link endpoint, the representor can be configured like any other
+netdevice; in some cases (e.g. link state) the representee will follow the
+representor's configuration, while in others there are separate APIs to
+configure the representee.
+
+Definitions
+-----------
+
+This document uses the term "switchdev function" to refer to the PCIe function
+which has administrative control over the virtual switch on the device.
+Typically, this will be a PF, but conceivably a NIC could be configured to grant
+these administrative privileges instead to a VF or SF (subfunction).
+Depending on NIC design, a multi-port NIC might have a single switchdev function
+for the whole device or might have a separate virtual switch, and hence
+switchdev function, for each physical network port.
+If the NIC supports nested switching, there might be separate switchdev
+functions for each nested switch, in which case each switchdev function should
+only create representors for the ports on the (sub-)switch it directly
+administers.
+
+A "representee" is the object that a representor represents.  So for example in
+the case of a VF representor, the representee is the corresponding VF.
+
+What does a representor do?
+---------------------------
+
+A representor has three main roles.
+
+1. It is used to configure the network connection the representee sees, e.g.
+   link up/down, MTU, etc.  For instance, bringing the representor
+   administratively UP should cause the representee to see a link up / carrier
+   on event.
+2. It provides the slow path for traffic which does not hit any offloaded
+   fast-path rules in the virtual switch.  Packets transmitted on the
+   representor netdevice should be delivered to the representee; packets
+   transmitted by the representee which fail to match any switching rule should
+   be received on the representor netdevice.  (That is, there is a virtual pipe
+   connecting the representor to the representee, similar in concept to a veth
+   pair.)
+   This allows software switch implementations (such as OpenVSwitch or a Linux
+   bridge) to forward packets between representees and the rest of the network.
+3. It acts as a handle by which switching rules (such as TC filters) can refer
+   to the representee, allowing these rules to be offloaded.
+
+The combination of 2) and 3) means that the behaviour (apart from performance)
+should be the same whether a TC filter is offloaded or not.  E.g. a TC rule
+on a VF representor applies in software to packets received on that representor
+netdevice, while in hardware offload it would apply to packets transmitted by
+the representee VF.  Conversely, a mirred egress redirect to a VF representor
+corresponds in hardware to delivery directly to the representee VF.
+
+What functions should have a representor?
+-----------------------------------------
+
+Essentially, for each virtual port on the device's internal switch, there
+should be a representor.
+Some vendors have chosen to omit representors for the uplink and the physical
+network port, which can simplify usage (the uplink netdev becomes in effect the
+physical port's representor) but does not generalise to devices with multiple
+ports or uplinks.
+
+Thus, the following should all have representors:
+
+ - VFs belonging to the switchdev function.
+ - Other PFs on the local PCIe controller, and any VFs belonging to them.
+ - PFs and VFs on external PCIe controllers on the device (e.g. for any embedded
+   System-on-Chip within the SmartNIC).
+ - PFs and VFs with other personalities, including network block devices (such
+   as a vDPA virtio-blk PF backed by remote/distributed storage), if (and only
+   if) their network access is implemented through a virtual switch port. [#]_
+   Note that such functions can require a representor despite the representee
+   not having a netdev.
+ - Subfunctions (SFs) belonging to any of the above PFs or VFs, if they have
+   their own port on the switch (as opposed to using their parent PF's port).
+ - Any accelerators or plugins on the device whose interface to the network is
+   through a virtual switch port, even if they do not have a corresponding PCIe
+   PF or VF.
+
+This allows the entire switching behaviour of the NIC to be controlled through
+representor TC rules.
+
+It is a common misunderstanding to conflate virtual ports with PCIe virtual
+functions or their netdevs.  While in simple cases there will be a 1:1
+correspondence between VF netdevices and VF representors, more advanced device
+configurations may not follow this.
+A PCIe function which does not have network access through the internal switch
+(not even indirectly through the hardware implementation of whatever services
+the function provides) should *not* have a representor (even if it has a
+netdev).
+Such a function has no switch virtual port for the representor to configure or
+to be the other end of the virtual pipe.
+The representor represents the virtual port, not the PCIe function nor the 'end
+user' netdevice.
+
+.. [#] The concept here is that a hardware IP stack in the device performs the
+   translation between block DMA requests and network packets, so that only
+   network packets pass through the virtual port onto the switch.  The network
+   access that the IP stack "sees" would then be configurable through tc rules;
+   e.g. its traffic might all be wrapped in a specific VLAN or VxLAN.  However,
+   any needed configuration of the block device *qua* block device, not being a
+   networking entity, would not be appropriate for the representor and would
+   thus use some other channel such as devlink.
+   Contrast this with the case of a virtio-blk implementation which forwards the
+   DMA requests unchanged to another PF whose driver then initiates and
+   terminates IP traffic in software; in that case the DMA traffic would *not*
+   run over the virtual switch and the virtio-blk PF should thus *not* have a
+   representor.
+
+How are representors created?
+-----------------------------
+
+The driver instance attached to the switchdev function should, for each virtual
+port on the switch, create a pure-software netdevice which has some form of
+in-kernel reference to the switchdev function's own netdevice or driver private
+data (``netdev_priv()``).
+This may be by enumerating ports at probe time, reacting dynamically to the
+creation and destruction of ports at run time, or a combination of the two.
+
+The operations of the representor netdevice will generally involve acting
+through the switchdev function.  For example, ``ndo_start_xmit()`` might send
+the packet through a hardware TX queue attached to the switchdev function, with
+either packet metadata or queue configuration marking it for delivery to the
+representee.
+
+How are representors identified?
+--------------------------------
+
+The representor netdevice should *not* directly refer to a PCIe device (e.g.
+through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
+representee or of the switchdev function.
+Instead, it should implement the ``ndo_get_devlink_port()`` netdevice op, which
+the kernel uses to provide the ``phys_switch_id`` and ``phys_port_name`` sysfs
+nodes.  (Some legacy drivers implement ``ndo_get_port_parent_id()`` and
+``ndo_get_phys_port_name()`` directly, but this is deprecated.)  See
+:ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>` for the
+details of this API.
+
+It is expected that userland will use this information (e.g. through udev rules)
+to construct an appropriately informative name or alias for the netdevice.  For
+instance if the switchdev function is ``eth4`` then a representor with a
+``phys_port_name`` of ``p0pf1vf2`` might be renamed ``eth4pf1vf2rep``.
+
+There are as yet no established conventions for naming representors which do not
+correspond to PCIe functions (e.g. accelerators and plugins).
+
+How do representors interact with TC rules?
+-------------------------------------------
+
+Any TC rule on a representor applies (in software TC) to packets received by
+that representor netdevice.  Thus, if the delivery part of the rule corresponds
+to another port on the virtual switch, the driver may choose to offload it to
+hardware, applying it to packets transmitted by the representee.
+
+Similarly, since a TC mirred egress action targeting the representor would (in
+software) send the packet through the representor (and thus indirectly deliver
+it to the representee), hardware offload should interpret this as delivery to
+the representee.
+
+As a simple example, if ``PORT_DEV`` is the physical port representor and
+``REP_DEV`` is a VF representor, the following rules::
+
+    tc filter add dev $REP_DEV parent ffff: protocol ipv4 flower \
+        action mirred egress redirect dev $PORT_DEV
+    tc filter add dev $PORT_DEV parent ffff: protocol ipv4 flower skip_sw \
+        action mirred egress mirror dev $REP_DEV
+
+would mean that all IPv4 packets from the VF are sent out the physical port, and
+all IPv4 packets received on the physical port are delivered to the VF in
+addition to ``PORT_DEV``.  (Note that without ``skip_sw`` on the second rule,
+the VF would get two copies, as the packet reception on ``PORT_DEV`` would
+trigger the TC rule again and mirror the packet to ``REP_DEV``.)
+
+On devices without separate port and uplink representors, ``PORT_DEV`` would
+instead be the switchdev function's own uplink netdevice.
+
+Of course the rules can (if supported by the NIC) include packet-modifying
+actions (e.g. VLAN push/pop), which should be performed by the virtual switch.
+
+Tunnel encapsulation and decapsulation are rather more complicated, as they
+involve a third netdevice (a tunnel netdev operating in metadata mode, such as
+a VxLAN device created with ``ip link add vxlan0 type vxlan external``) and
+require an IP address to be bound to the underlay device (e.g. switchdev
+function uplink netdev or port representor).  TC rules such as::
+
+    tc filter add dev $REP_DEV parent ffff: flower \
+        action tunnel_key set id $VNI src_ip $LOCAL_IP dst_ip $REMOTE_IP \
+                              dst_port 4789 \
+        action mirred egress redirect dev vxlan0
+    tc filter add dev vxlan0 parent ffff: flower enc_src_ip $REMOTE_IP \
+        enc_dst_ip $LOCAL_IP enc_key_id $VNI enc_dst_port 4789 \
+        action tunnel_key unset action mirred egress redirect dev $REP_DEV
+
+where ``LOCAL_IP`` is an IP address bound to ``PORT_DEV``, and ``REMOTE_IP`` is
+another IP address on the same subnet, mean that packets sent by the VF should
+be VxLAN encapsulated and sent out the physical port (the driver has to deduce
+this by a route lookup of ``LOCAL_IP`` leading to ``PORT_DEV``, and also
+perform an ARP/neighbour table lookup to find the MAC addresses to use in the
+outer Ethernet frame), while UDP packets received on the physical port with UDP
+port 4789 should be parsed as VxLAN and, if their VSID matches ``$VNI``,
+decapsulated and forwarded to the VF.
+
+If this all seems complicated, just remember the 'golden rule' of TC offload:
+the hardware should ensure the same final results as if the packets were
+processed through the slow path, traversed software TC (except ignoring any
+``skip_hw`` rules and applying any ``skip_sw`` rules) and were transmitted or
+received through the representor netdevices.
+
+Configuring the representee's MAC
+---------------------------------
+
+The representee's link state is controlled through the representor.  Setting the
+representor administratively UP or DOWN should cause carrier ON or OFF at the
+representee.
+
+Setting an MTU on the representor should cause that same MTU to be reported to
+the representee.
+(On hardware that allows configuring separate and distinct MTU and MRU values,
+the representor MTU should correspond to the representee's MRU and vice-versa.)
+
+Currently there is no way to use the representor to set the station permanent
+MAC address of the representee; other methods available to do this include:
+
+ - legacy SR-IOV (``ip link set DEVICE vf NUM mac LLADDR``)
+ - devlink port function (see **devlink-port(8)** and
+   :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`)
diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index f1f4e6a85a29..21e80c8e661b 100644
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -1,5 +1,6 @@
 .. SPDX-License-Identifier: GPL-2.0
 .. include:: <isonum.txt>
+.. _switchdev:
 
 ===============================================
 Ethernet switch device driver model (switchdev)
