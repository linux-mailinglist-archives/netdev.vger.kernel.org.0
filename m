Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EC258AE94
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 19:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbiHERB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 13:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiHERB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 13:01:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84316AA1C;
        Fri,  5 Aug 2022 10:01:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aB0FioVk+ewyLNmpVgBUy+LQlznjZrIcmjp33ABXouiUuMLJfuncb4K3tDCnIJ/ogbK6DYmkljm/AHtewqV/fuOs/wF3rjre46DWZX+FJhtvG6refCHdTMDBAHzYxoncqg6SMGat1GVw6QI85Dj64cHjp5MWEYppPRg3mhG2n3sP+obeuqqD4tw1aSFSMuV9XfkAyhqJ4rOtx//5dlRjlKJpCiwCzVirmf/RDUnQhBa4qIbBw1woTdNZbkOlc+yJMrKGDtepc9qBvkc7i+6UDjazKAswZxZjoDid7GLRkjqzf1SyjSqeDgEdeq/VbU3WZiWsQe8XSprHj+Lz/7oHjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gaKUnTfbl1WmLG23wm6zFC5ZuREi1nRGCLJtSssX0nA=;
 b=MCJLULHMgFg/9sN432jiHUquinWhY4QwACkLLWdV400LUJWZdqNK7J4CmQZFaYSC3ohY1AHHoSp9utylNsYHOiz8gfvM9PmzgCUh5JdflghVORUfTzxPbV84sZFfQNfNBd2BxwAEzJS7xff6/o8MqGMwxD9/HItviJ2+rE8612Ns7ci8fDNCxxmDNXE/kax0f/glFLUOx9edEw8bi7Z9w8w7k3qYjjhE+/LKeTNCyB0n8zrNj4wp+vELD16rETfPjjNeZ0rLvu6LEj2G74X6NVQtgutvjRbRi+i8Zl/DGem6uhajN680glHdJQzgDJvZXrk8WzWKHsPbwUwBc6txmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaKUnTfbl1WmLG23wm6zFC5ZuREi1nRGCLJtSssX0nA=;
 b=RV3JL+BFCLR3IGHVdcGaaZCk1eFl3bLf3Eop/ZtsMCVKgJmzPRByZYR4VNjN+nh9AU1iEQDVCkyGl5vELtcGobrc3Ga8YvwcgPZNvSqvbL3DjYY3aTUu9Q6hymhFtgp7nhEVPr2NrwvqFkX68FFRExxlf+mQBoa4Mpnuva+7twbhr52w79qHobKv90a1i5NdFDJjB+FHloesZrax5Pm5yZGMKxsTCq7cPmEHvKkt54P/QrYbCN35dEvadsF02z5b5BDI4XgjOrIFDcGkYtqGEVXPyJWfUTjhdfPoRqw9ciFGGSNKTRt9rUCFTE8F30Bl/priJ9CQ8uQYFW6LkV0l2Q==
Received: from DS7PR03CA0200.namprd03.prod.outlook.com (2603:10b6:5:3b6::25)
 by DM4PR12MB5071.namprd12.prod.outlook.com (2603:10b6:5:38a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Fri, 5 Aug
 2022 17:01:54 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::a8) by DS7PR03CA0200.outlook.office365.com
 (2603:10b6:5:3b6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Fri, 5 Aug 2022 17:01:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5504.14 via Frontend Transport; Fri, 5 Aug 2022 17:01:54 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 5 Aug
 2022 12:01:49 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 5 Aug 2022 12:01:47 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>,
        <linux-net-drivers@amd.com>
Subject: [RFC PATCH net-next] docs: net: add an explanation of VF (and other) Representors
Date:   Fri, 5 Aug 2022 17:58:50 +0100
Message-ID: <20220805165850.50160-1-ecree@xilinx.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82bef67f-995c-4194-1070-08da77043324
X-MS-TrafficTypeDiagnostic: DM4PR12MB5071:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BhrEnm7R0TU3b5HiGhE1TBbgS0pWIULgFKL67q/1Kj2IhzXSMPOGqxVlbwzg8UrmkDkBoML/eQNzGcYHQeZ5LNzJiR4N4isCWRpf1z0Hyjizdhdqw2wQfFdoGEIRSQuzYVYqD1xH8Q1jd8+pJ0736TjYSIJudiFlH/2AMsEpIf8TZKW8wfGj+73+YKrIxZAG4UGSjN2YZxI5mZlxfMV8nUBXDuwyMoXqTiVUHYh97rzFbue2qP1Cy8n31l2sZILa8A7FUpVBx55s5V8ffkFsHiCK1jg9+RYLZBmaEpSRjDozRGHqS9Fu4jU46KXqr3RucSCW78KbW6dKwmz47WMNx7ZWHneR+NY26YnGAlqxxLoDsNsr0WmW/fICZfHBBfAvYIl+ka6cupC/quTytA3AHJxjfMhMssIEZWSN6ReEksZPEuxbim7Jvze1sgvKbO8tYr9dP9YROQr5TWNHbf2AoL/qeshmRJ1cZhq62Re3rYzalou63YczeSR/zpjMqu7IqPXDLwWgTC/62ayCSv1qOUUzFVydaiYZH/4Egk5u9thNG1A2kDVpRSwSBoSBVDpPdYZIkYHXr9d/k377T/epxCWkDlfDkywWLN74e6HqmLkAvn5lzSTdfjg3EiZr6oVR7OyamkY0Z5oceiN4J+W42QkGpuyoFu+IMGMXwDy1YaQZvvY7kbZW/QKFOEXRtdzBZPqokNcSsScdUZPNoDbCAo9kPjRmpRVIfiVR2GWM57HArOy5R0+kuyRkqyl5ABm2tV8gA0nobdum+xcBSfGRwflUkH5fLav7T9bJRAZY7HniYMzQTU+/AW0spvOfnLbJGlL68Rn9gsAOdEt/zFRX2w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(40460700003)(82740400003)(47076005)(186003)(66574015)(336012)(42882007)(2616005)(83380400001)(30864003)(36756003)(2876002)(5660300002)(82310400005)(2906002)(478600001)(36860700001)(83170400001)(6916009)(356005)(40480700001)(4326008)(54906003)(81166007)(1076003)(316002)(70206006)(7696005)(26005)(8676002)(41300700001)(6666004)(70586007)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 17:01:54.6828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bef67f-995c-4194-1070-08da77043324
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5071
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
This documents representors as I understand them, but I suspect others
 (including other vendors) might disagree (particularly with the "what
 functions should have a rep" section).  I'm hoping that through review
 of this doc we can converge on a consensus.

 Documentation/networking/index.rst        |   1 +
 Documentation/networking/representors.rst | 219 ++++++++++++++++++++++
 Documentation/networking/switchdev.rst    |   1 +
 3 files changed, 221 insertions(+)
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
index 000000000000..4d28731a5b5b
--- /dev/null
+++ b/Documentation/networking/representors.rst
@@ -0,0 +1,219 @@
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
+Network function representors provide the mechanism by which network functions
+on an internal switch are managed.  They are used both to configure the
+corresponding function ('representee') and to handle slow-path traffic to and
+from the representee for which no fast-path switching rule is matched.
+
+That is, a representor is both a control plane object (representing the function
+in administrative commands) and a data plane object (one end of a virtual pipe).
+As a virtual link endpoint, the representor can be configured like any other
+netdevice; in some cases (e.g. link state) the representee will follow the
+representor's configuration, while in others there are separate APIs to
+configure the representee.
+
+What does a representor do?
+---------------------------
+
+A representor has three main rôles.
+
+1. It is used to configure the representee's virtual MAC, e.g. link up/down,
+   MTU, etc.  For instance, bringing the representor administratively UP should
+   cause the representee to see a link up / carrier on event.
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
+The only exceptions are the management PF (whose port is used for traffic to
+and from all other representors) and perhaps the physical network port (for
+which the management PF may act as a kind of port representor.  Devices that
+combine multiple physical ports and SR-IOV capability may need to have port
+representors in addition to PF/VF representors).
+
+Thus, the following should all have representors:
+
+ - VFs belonging to the management PF.
+ - Other PFs on the PCIe controller, and any VFs belonging to them.
+ - PFs and VFs on other PCIe controllers on the device (e.g. for any embedded
+   System-on-Chip within the SmartNIC).
+ - PFs and VFs with other personalities, including network block devices (such
+   as a vDPA virtio-blk PF backed by remote/distributed storage).
+ - Subfunctions (SFs) belonging to any of the above PFs or VFs, if they have
+   their own port on the switch (as opposed to using their parent PF's port).
+ - Any accelerators or plugins on the device whose interface to the network is
+   through a virtual switch port, even if they do not have a corresponding PCIe
+   PF or VF.
+
+This allows the entire switching behaviour of the NIC to be controlled through
+representor TC rules.
+
+An example of a PCIe function that should *not* have a representor is, on an
+FPGA-based NIC, a PF which is only used to deploy a new bitstream to the FPGA,
+and which cannot create RX and TX queues.  Since such a PF does not have network
+access through the internal switch, not even indirectly via a distributed
+storage endpoint, there is no switch virtual port for the representor to
+configure or to be the other end of the virtual pipe.
+
+How are representors created?
+-----------------------------
+
+The driver instance attached to the management PF should enumerate the virtual
+ports on the switch, and for each representee, create a pure-software netdevice
+which has some form of in-kernel reference to the PF's own netdevice or driver
+private data (``netdev_priv()``).
+If switch ports can dynamically appear/disappear, the PF driver should create
+and destroy representors appropriately.
+The operations of the representor netdevice will generally involve acting
+through the management PF.  For example, ``ndo_start_xmit()`` might send the
+packet, specially marked for delivery to the representee, through a TX queue
+attached to the management PF.
+
+How are representors identified?
+--------------------------------
+
+The representor netdevice should *not* directly refer to a PCIe device (e.g.
+through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
+representee or of the management PF.
+Instead, it should implement the ``ndo_get_port_parent_id()`` and
+``ndo_get_phys_port_name()`` netdevice ops (corresponding to the
+``phys_switch_id`` and ``phys_port_name`` sysfs nodes).
+``ndo_get_port_parent_id()`` should return a string identical to that returned
+by the management PF's ``ndo_get_phys_port_id()`` (typically the MAC address of
+the physical port), while ``ndo_get_phys_port_name()`` should return a string
+describing the representee's relation to the management PF.
+
+For instance, if the management PF has a ``phys_port_name`` of ``p0`` (physical
+port 0), then the representor for the third VF on the second PF should typically
+be ``p0pf1vf2`` (i.e. "port 0, PF 1, VF 2").  More generally, the
+``phys_port_name`` for a PCIe function should be the concatenation of one or
+more of:
+
+ - ``p<N>``, physical port number *N*.
+ - ``if<N>``, PCIe controller number *N*.  The semantics of these numbers are
+   vendor-defined, and controller 0 need not correspond to the controller on
+   which the management PF resides.
+ - ``pf<N>``, PCIe physical function index *N*.
+ - ``vf<N>``, PCIe virtual function index *N*.
+ - ``sf<N>``, Subfunction index *N*.
+
+It is expected that userland will use this information (e.g. through udev rules)
+to construct an appropriately informative name or alias for the netdevice.  For
+instance if the management PF is ``eth4`` then our representor with a
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
+As a simple example, if ``eth0`` is the management PF's netdevice and ``eth1``
+is a VF representor, the following rules::
+
+    tc filter add dev eth1 parent ffff: protocol ipv4 flower \
+        action mirred egress redirect dev eth0
+    tc filter add dev eth0 parent ffff: protocol ipv4 flower \
+        action mirred egress mirror dev eth1
+
+would mean that all IPv4 packets from the VF are sent out the physical port, and
+all IPv4 packets received on the physical port are delivered to the VF in
+addition to the management PF.
+
+Of course the rules can (if supported by the NIC) include packet-modifying
+actions (e.g. VLAN push/pop), which should be performed by the virtual switch.
+
+Tunnel encapsulation and decapsulation are rather more complicated, as they
+involve a third netdevice (a tunnel netdev operating in metadata mode, such as
+a VxLAN device created with ``ip link add vxlan0 type vxlan external``) and
+require an IP address to be bound to the underlay device (e.g. management PF or
+port representor).  TC rules such as::
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
