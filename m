Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C475930A2
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiHOOXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiHOOXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:23:42 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C464C12AEA;
        Mon, 15 Aug 2022 07:23:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCHjCqn/8yaK7bo4DcjOLLDF/q64iiA0IWSo6Ib6bB5AJGQD+Ays2MM56PQ7/ZEUtbmvsFMbQTtUlDQttsJ9nh/2qdCJTZxM0WncjY6RIYMe4ZujM0eMALCB84M8KK+wyXX4p2yQ7WyBWkQ/bfEt6y1h9d4AR1LL6Sk0p3/wEq0FguJVgpJ3rzpNzp8E4b1UOLyUviSkYS1eJCyeOUmoIemcQOAs/iar/Oqc6NAdkihCkll5TNzCHU/lGwbQDTI7RKVBE5qdZcOlUwC6UlE4UAyGefIyQFliId+xMPDxAR/qnY+WCz6VEXDAGQzB+x7tyazCFYWke0Yzz3Z4mmLX8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFyNHtIMbTmYKSo/523d4BBJQjquTEdjRgm84IyVt5A=;
 b=Ph9tdWkbcOH09DsdVz4tYP2zHlWXSN0CTu+FWQOBOYcrtG36ZIC4joVhDaXXS1/ge190Jwx9Vu2QVze4idNGQ5TAqCNUxjR1NCPdn2Dc6kKrQMJwXgE5FgscibDV2OJmshCdu50082veV4FGyUNZBUG9RcjO8A+hKVEJi9bitePMFxNvGnY3TOPVaaBvec6fBjmMhvdkFtXvPVhpMTqqdvyQgpuggBld9RrvoMaVIUlf719jjw3fijHSgmE+IDkeoJlAePSlAXVVQxelUOtu0dZXMigZnuFfe7IJOLLznXgLj8VnBipfJJTkA94RN+W1cAZ4tii1Txyoz68DCVPNTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFyNHtIMbTmYKSo/523d4BBJQjquTEdjRgm84IyVt5A=;
 b=SI9fBUH2Rb0Gjw9nxBixY1B8rtYRTOSBRLKJRigRkl3w4u6KvnPxpqfeBPmgMjOGM3ZvOwUsDQZAMa/7WPUs03CtkBGKO7+F9A+yUicEvF/I5B2at98vXK1NQB4EaUsFiKwutIzK0z4RALK+65vgJSJlB7LiouOZo0eOPJBvDhysSqf3hDZjeN9nf9RItool5KE/L4vDa9BSsrjRYqYYlGsTR1dhv8/7jAoxpPddYY4XQDxTGOMqwGnUhPa+NSxBRe4dKUqW9X2sOZzSj5ngduxfxudzSNtlzue93+dadk45j9kz6KEuqA99edtnkoYouG6ZWpPlSAB/wiyLM1Rnew==
Received: from MW4PR03CA0081.namprd03.prod.outlook.com (2603:10b6:303:b6::26)
 by BY5PR12MB3650.namprd12.prod.outlook.com (2603:10b6:a03:1a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 15 Aug
 2022 14:23:37 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::6e) by MW4PR03CA0081.outlook.office365.com
 (2603:10b6:303:b6::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Mon, 15 Aug 2022 14:23:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Mon, 15 Aug 2022 14:23:37 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 15 Aug
 2022 09:23:21 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 15 Aug
 2022 09:23:20 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 15 Aug 2022 09:23:18 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <michael.chan@broadcom.com>,
        <andy@greyhouse.net>, <saeed@kernel.org>, <jiri@resnulli.us>,
        <snelson@pensando.io>, <simon.horman@corigine.com>,
        <alexander.duyck@gmail.com>, <rdunlap@infradead.org>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and other) Representors
Date:   Mon, 15 Aug 2022 15:22:51 +0100
Message-ID: <20220815142251.8909-1-ecree@xilinx.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27ba8913-b0a7-4593-12a1-08da7ec9be57
X-MS-TrafficTypeDiagnostic: BY5PR12MB3650:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0dgcNYKUvJc6Zv41QFy1T6FUB+BseEtfjoajgyQ/Mio7f1omV5E3Ze6sdN1TDsDXQMgybdqp0CSYMln6c4gbRFOklcmQzXYuba5FX5tplrcGb2wbXV9mJ8YKZz3BvGwUKH7CEHkakA8ewI0HVALQSmmEPUSTJFugVGhFECI3G0y/gMot6Czpha/fgxskIpxe1RLb2s3MWm54CLvUNapPymdJ6ot6Zw+nLoiT0Zt8q0BRAGJQd2Un6vtGufvyLThTJPBogp2N/fNaMWTxV3l/24W9EoK7xQztfgwP5Ppgt7uwLctT4f82udtp5KNc5x+NrIqfqjOlBOSKmCoU7FrR/ial1ekBjtKHYtWylqQ4hSLO1niP4xtnrShgQFLqOTHSdZPuZ6thd15GDkRazns01W/eH0H2fUY40E8e787RrFd051c42XqbumHwAFUSJVxp9jI8cOKkkE98s9WTRNynw4TiTMh7M5zAfumzsZZsfX3PKjV9jgYWKa7THeY1dAVtwJl1qjGnvLc8GmxPd7RHCCLnFvjmvPRVqEwwRJQln3szGJCcGZQSy4RbgX890JLG/ayZbe50NLBjbsYCdXVESuW5oW8i9sgOYgufuSrGy1+ovQUm6D8Ro/Jhyaoy6UDLDRVEUNZYaiJI9SfoI3PL5qZpVOh4ksGetpGfN/ZXeHTR7q6ntxVRWNFzpOVLxrlBGk/GCBEmXwhbHNDyziM1Pd6cx+vBITUQBME7J9zoMFR5SOgdrQLmmFTazh9+PlusyPqxU4NBpm17Vg8EEQ7teIQbu7RJAF/LTvmlVZCnzSNsFwvIHDS6XABnbc+h4GZ4HfS5nNa+QrPtPD7kbSQgUQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(36840700001)(46966006)(40470700004)(5660300002)(83170400001)(40460700003)(356005)(8676002)(4326008)(82740400003)(70586007)(81166007)(70206006)(47076005)(2616005)(1076003)(336012)(42882007)(186003)(41300700001)(478600001)(26005)(2876002)(6666004)(7696005)(316002)(83380400001)(110136005)(8936002)(7416002)(82310400005)(30864003)(36756003)(40480700001)(2906002)(54906003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 14:23:37.1375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ba8913-b0a7-4593-12a1-08da7ec9be57
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3650
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
Changed in v2:
 - incorporated feedback from Jakub including rewrite of the Motivation section,
   representors for uplink/phys port, replace phys_port_name conventions with
   devlink port.
 - fixed archaic spelling (Randy)
 - painted the bike shed blue ("master PF") for now, we can always change it
   again later
 - added Definitions section

 Documentation/networking/index.rst        |   1 +
 Documentation/networking/representors.rst | 228 ++++++++++++++++++++++
 Documentation/networking/switchdev.rst    |   1 +
 3 files changed, 230 insertions(+)
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
index 000000000000..be7cc4752d11
--- /dev/null
+++ b/Documentation/networking/representors.rst
@@ -0,0 +1,228 @@
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
+virtual switches and IOV devices.  Just as each port of a Linux-controlled
+switch has a separate netdev, so each virtual function has one.  When the system
+boots, and before any offload is configured, all packets from the virtual
+functions appear in the networking stack of the PF via the representors.
+The PF can thus always communicate freely with the virtual functions.
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
+This document uses the term "master PF" to refer to the PCIe function which has
+administrative control over the virtual switch on the device.  Conceivably a NIC
+could be configured to grant these administrative privileges instead to a VF or
+SF (subfunction); the terminology is not meant to exclude this case.
+Depending on NIC design, a multi-port NIC might have a single master PF for the
+whole device or might have a separate virtual switch, and hence master PF, for
+each physical network port.
+If the NIC supports nested switching, there might be separate "master PFs" for
+each nested switch, in which case each "master PF" should only create
+representors for the ports on the (sub-)switch it directly administers.
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
+   transmitted to the representee which fail to match any switching rule should
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
+ - VFs belonging to the master PF.
+ - Other PFs on the local PCIe controller, and any VFs belonging to them.
+ - PFs and VFs on other PCIe controllers on the device (e.g. for any embedded
+   System-on-Chip within the SmartNIC).
+ - PFs and VFs with other personalities, including network block devices (such
+   as a vDPA virtio-blk PF backed by remote/distributed storage), if their
+   network access is implemented through a virtual switch port.
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
+A PCIe function which does not have network access through the internal switch
+(not even indirectly through the hardware implementation of whatever services
+the function provides) should *not* have a representor (even if it has a
+netdev).
+Such a function has no switch virtual port for the representor to configure or
+to be the other end of the virtual pipe.
+
+How are representors created?
+-----------------------------
+
+The driver instance attached to the master PF should enumerate the virtual ports
+on the switch, and for each representee, create a pure-software netdevice which
+has some form of in-kernel reference to the PF's own netdevice or driver private
+data (``netdev_priv()``).
+If switch ports can dynamically appear/disappear, the PF driver should create
+and destroy representors appropriately.
+The operations of the representor netdevice will generally involve acting
+through the master PF.  For example, ``ndo_start_xmit()`` might send the packet
+through a hardware TX queue attached to the master PF, with either packet
+metadata or queue configuration marking it for delivery to the representee.
+
+How are representors identified?
+--------------------------------
+
+The representor netdevice should *not* directly refer to a PCIe device (e.g.
+through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
+representee or of the master PF.
+Instead, it should implement the ``ndo_get_devlink_port()`` netdevice op, which
+the kernel uses to provide the ``phys_switch_id`` and ``phys_port_name`` sysfs
+nodes.  (Some legacy drivers implement ``ndo_get_port_parent_id()`` and
+``ndo_get_phys_port_name`` directly, but this is deprecated.)  See
+:ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>` for the
+details of this API.
+
+It is expected that userland will use this information (e.g. through udev rules)
+to construct an appropriately informative name or alias for the netdevice.  For
+instance if the master PF is ``eth4`` then a representor with a
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
+As a simple example, if ``eth0`` is the master PF's netdevice and ``eth1`` is a
+VF representor, the following rules::
+
+    tc filter add dev eth1 parent ffff: protocol ipv4 flower \
+        action mirred egress redirect dev eth0
+    tc filter add dev eth0 parent ffff: protocol ipv4 flower \
+        action mirred egress mirror dev eth1
+
+would mean that all IPv4 packets from the VF are sent out the physical port, and
+all IPv4 packets received on the physical port are delivered to the VF in
+addition to the master PF.
+
+Of course the rules can (if supported by the NIC) include packet-modifying
+actions (e.g. VLAN push/pop), which should be performed by the virtual switch.
+
+Tunnel encapsulation and decapsulation are rather more complicated, as they
+involve a third netdevice (a tunnel netdev operating in metadata mode, such as
+a VxLAN device created with ``ip link add vxlan0 type vxlan external``) and
+require an IP address to be bound to the underlay device (e.g. master PF or port
+representor).  TC rules such as::
+
+    tc filter add dev eth1 parent ffff: flower \
+        action tunnel_key set id $VNI src_ip $LOCAL_IP dst_ip $REMOTE_IP \
+                              dst_port 4789 \
+        action mirred egress redirect dev vxlan0
+    tc filter add dev vxlan0 parent ffff: flower enc_src_ip $REMOTE_IP \
+        enc_dst_ip $LOCAL_IP enc_key_id $VNI enc_dst_port 4789 \
+        action tunnel_key unset action mirred egress redirect dev eth1
+
+where ``LOCAL_IP`` is an IP address bound to ``eth0``, and ``REMOTE_IP`` is
+another IP address on the same subnet, mean that packets sent by the VF should
+be VxLAN encapsulated and sent out the physical port (the driver has to deduce
+this by a route lookup of ``LOCAL_IP`` leading to ``eth0``, and also perform an
+ARP/neighbour table lookup to find the MAC addresses to use in the outer
+Ethernet frame), while UDP packets received on the physical port with UDP port
+4789 should be parsed as VxLAN and, if their VSID matches ``$VNI``, decapsulated
+and forwarded to the VF.
+
+If this all seems complicated, just remember the 'golden rule' of TC offload:
+the hardware should ensure the same final results as if the packets were
+processed through the slow path, traversed software TC and were transmitted or
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
