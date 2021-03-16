Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FEA33D2E4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhCPLYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhCPLYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:31 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C251C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:30 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id c10so71409807ejx.9
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QXqHpOQoy/Kk5pei4kuycWUmrEJa8bIinA5w7A6OUnQ=;
        b=dmDDc/NYNpJjbzOtD4+TkJxisopeAIN5ZubajNapa5Zeomb/ICDHwosgEUSGz/4yxO
         Do4SN2SSjOZpxHjZHxx8oNAabbysvJRJm1Lbt6sutNRmxevWfbS06HNp2YRKmEjJKulp
         05EyfHuQ7E+YdmRuk7OH260PnWIHM5sDrg85YV8f/h1sHyv4hHnrEF9OOqIJBESHnPsY
         xCD43z2C9C1YTES3KWIZ6I68zZaCVBt+2rMbuCgnVT2UijpfDdC+huY4uqCDsVaVwCEU
         QN5fBOgWjCcBJ/eVDCNOmZXgo9kh9ymi4Q8nWRkhtOSDKQAg6mLH2cAsdF2iz3sqZl3v
         bXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXqHpOQoy/Kk5pei4kuycWUmrEJa8bIinA5w7A6OUnQ=;
        b=UDrTY9UoLyeI15UFre95U7GgaDKSCfAMBqYJD7qSOt4HsD9kHk/t8Q2/Sjalg65iTd
         Wkz/dOymIDR+roVHvgNPXwfzTHOAZ5r0Hr8umx0Bj1ywBD7KqHIE1Y6paceBnS80fipI
         im+nBWd4m/yssznTvgoVunoVBZ/D2A+AbyGzYi//S7+86h4Fhg/KuUw6xB/88e46Z9iS
         ssgD9fWEKEpw8Kzu9pGfBlPkKgY8zq3bw8Wu/oTOEGxvz/tzz+itvM80Kf89R4TLAp0W
         IDa5XtaLOjqGwthHzIVWx2zY/LnTxNnOa8eHua2Q+jFy5LdJT0Iw5zajRrgQEiRqAZ7L
         kDYw==
X-Gm-Message-State: AOAM532UbOVSi05bbh7Gr6b8XovdzXbaY1m6iqH/ltaTMOF81HzcH6Lt
        ZtDBCn2yj7KV+EQ7wYGeJFdXsXx3wqs=
X-Google-Smtp-Source: ABdhPJx12Zny1b3Udv1/yrj4FgGb0DJVE4M2+KbHSKvCtw8X6vbqCsVd/feNfJhHnBZVWeEyZEGTlg==
X-Received: by 2002:a17:906:3881:: with SMTP id q1mr29211913ejd.490.1615893868978;
        Tue, 16 Mar 2021 04:24:28 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 02/12] Documentation: networking: dsa: rewrite chapter about tagging protocol
Date:   Tue, 16 Mar 2021 13:24:09 +0200
Message-Id: <20210316112419.1304230-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The chapter about tagging protocols is out of date because it doesn't
mention all taggers that have been added since last documentation
update. But judging based on that, it will always tend to lag behind,
and there's no good reason why we would enumerate the supported
hardware. Instead we could do something more useful and explain what
there is to know about tagging protocols instead.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 Documentation/networking/dsa/dsa.rst | 148 +++++++++++++++++++++++++--
 1 file changed, 140 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index e20fbad2241a..17d1422ac085 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -65,14 +65,8 @@ Note that DSA does not currently create network interfaces for the "cpu" and
 Switch tagging protocols
 ------------------------
 
-DSA currently supports 5 different tagging protocols, and a tag-less mode as
-well. The different protocols are implemented in:
-
-- ``net/dsa/tag_trailer.c``: Marvell's 4 trailer tag mode (legacy)
-- ``net/dsa/tag_dsa.c``: Marvell's original DSA tag
-- ``net/dsa/tag_edsa.c``: Marvell's enhanced DSA tag
-- ``net/dsa/tag_brcm.c``: Broadcom's 4 bytes tag
-- ``net/dsa/tag_qca.c``: Qualcomm's 2 bytes tag
+DSA supports many vendor-specific tagging protocols, one software-defined
+tagging protocol, and a tag-less mode as well (``DSA_TAG_PROTO_NONE``).
 
 The exact format of the tag protocol is vendor specific, but in general, they
 all contain something which:
@@ -80,6 +74,144 @@ all contain something which:
 - identifies which port the Ethernet frame came from/should be sent to
 - provides a reason why this frame was forwarded to the management interface
 
+All tagging protocols are in ``net/dsa/tag_*.c`` files and implement the
+methods of the ``struct dsa_device_ops`` structure, which are detailed below.
+
+Tagging protocols generally fall in one of three categories:
+
+1. The switch-specific frame header is located before the Ethernet header,
+   shifting to the right (from the perspective of the DSA master's frame
+   parser) the MAC DA, MAC SA, EtherType and the entire L2 payload.
+2. The switch-specific frame header is located before the EtherType, keeping
+   the MAC DA and MAC SA in place from the DSA master's perspective, but
+   shifting the 'real' EtherType and L2 payload to the right.
+3. The switch-specific frame header is located at the tail of the packet,
+   keeping all frame headers in place and not altering the view of the packet
+   that the DSA master's frame parser has.
+
+A tagging protocol may tag all packets with switch tags of the same length, or
+the tag length might vary (for example packets with PTP timestamps might
+require an extended switch tag, or there might be one tag length on TX and a
+different one on RX). Either way, the tagging protocol driver must populate the
+``struct dsa_device_ops::overhead`` with the length in octets of the longest
+switch frame header. The DSA framework will automatically adjust the MTU of the
+master interface to accomodate for this extra size in order for DSA user ports
+to support the standard MTU (L2 payload length) of 1500 octets. The ``overhead``
+is also used to request from the network stack, on a best-effort basis, the
+allocation of packets with a ``needed_headroom`` or ``needed_tailroom``
+sufficient such that the act of pushing the switch tag on transmission of a
+packet does not cause it to reallocate due to lack of memory.
+
+Even though applications are not expected to parse DSA-specific frame headers,
+the format on the wire of the tagging protocol represents an Application Binary
+Interface exposed by the kernel towards user space, for decoders such as
+``libpcap``. The tagging protocol driver must populate the ``proto`` member of
+``struct dsa_device_ops`` with a value that uniquely describes the
+characteristics of the interaction required between the switch hardware and the
+data path driver: the offset of each bit field within the frame header and any
+stateful processing required to deal with the frames (as may be required for
+PTP timestamping).
+
+From the perspective of the network stack, all switches within the same DSA
+switch tree use the same tagging protocol. In case of a packet transiting a
+fabric with more than one switch, the switch-specific frame header is inserted
+by the first switch in the fabric that the packet was received on. This header
+typically contains information regarding its type (whether it is a control
+frame that must be trapped to the CPU, or a data frame to be forwarded).
+Control frames should be decapsulated only by the software data path, whereas
+data frames might also be autonomously forwarded towards other user ports of
+other switches from the same fabric, and in this case, the outermost switch
+ports must decapsulate the packet.
+
+Note that in certain cases, it might be the case that the tagging format used
+by a leaf switch (not connected directly to the CPU) to not be the same as what
+the network stack sees. This can be seen with Marvell switch trees, where the
+CPU port can be configured to use either the DSA or the Ethertype DSA (EDSA)
+format, but the DSA links are configured to use the shorter (without Ethertype)
+DSA frame header, in order to reduce the autonomous packet forwarding overhead.
+It still remains the case that, if the DSA switch tree is configured for the
+EDSA tagging protocol, the operating system sees EDSA-tagged packets from the
+leaf switches that tagged them with the shorter DSA header. This can be done
+because the Marvell switch connected directly to the CPU is configured to
+perform tag translation between DSA and EDSA (which is simply the operation of
+adding or removing the ``ETH_P_EDSA`` EtherType and some padding octets).
+
+It is possible to construct cascaded setups of DSA switches even if their
+tagging protocols are not compatible with one another. In this case, there are
+no DSA links in this fabric, and each switch constitutes a disjoint DSA switch
+tree. The DSA links are viewed as simply a pair of a DSA master (the out-facing
+port of the upstream DSA switch) and a CPU port (the in-facing port of the
+downstream DSA switch).
+
+The tagging protocol of the attached DSA switch tree can be viewed through the
+``dsa/tagging`` sysfs attribute of the DSA master::
+
+    cat /sys/class/net/eth0/dsa/tagging
+
+If the hardware and driver are capable, the tagging protocol of the DSA switch
+tree can be changed at runtime. This is done by writing the new tagging
+protocol name to the same sysfs device attribute as above (the DSA master and
+all attached switch ports must be down while doing this).
+
+It is desirable that all tagging protocols are testable with the ``dsa_loop``
+mockup driver, which can be attached to any network interface. The goal is that
+any network interface should be capable of transmitting the same packet in the
+same way, and the tagger should decode the same received packet in the same way
+regardless of the driver used for the switch control path, and the driver used
+for the DSA master.
+
+The transmission of a packet goes through the tagger's ``xmit`` function.
+The passed ``struct sk_buff *skb`` has ``skb->data`` pointing at
+``skb_mac_header(skb)``, i.e. at the destination MAC address, and the passed
+``struct net_device *dev`` represents the virtual DSA user network interface
+whose hardware counterpart the packet must be steered to (i.e. ``swp0``).
+The job of this method is to prepare the skb in a way that the switch will
+understand what egress port the packet is for (and not deliver it towards other
+ports). Typically this is fulfilled by pushing a frame header. Checking for
+insufficient size in the skb headroom or tailroom is unnecessary provided that
+the ``overhead`` and ``tail_tag`` properties were filled out properly, because
+DSA ensures there is enough space before calling this method.
+
+The reception of a packet goes through the tagger's ``rcv`` function. The
+passed ``struct sk_buff *skb`` has ``skb->data`` pointing at
+``skb_mac_header(skb) + ETH_ALEN`` octets, i.e. to where the first octet after
+the EtherType would have been, were this frame not tagged. The role of this
+method is to consume the frame header, adjust ``skb->data`` to really point at
+the first octet after the EtherType, and to change ``skb->dev`` to point to the
+virtual DSA user network interface corresponding to the physical front-facing
+switch port that the packet was received on.
+
+Since tagging protocols in category 1 and 2 break software (and most often also
+hardware) packet dissection on the DSA master, features such as RPS (Receive
+Packet Steering) on the DSA master would be broken. The DSA framework deals
+with this by hooking into the flow dissector and shifting the offset at which
+the IP header is to be found in the tagged frame as seen by the DSA master.
+This behavior is automatic based on the ``overhead`` value of the tagging
+protocol. If not all packets are of equal size, the tagger can implement the
+``flow_dissect`` method of the ``struct dsa_device_ops`` and override this
+default behavior by specifying the correct offset incurred by each individual
+RX packet. Tail taggers do not cause issues to the flow dissector.
+
+Due to various reasons (most common being category 1 taggers being associated
+with DSA-unaware masters, mangling what the master perceives as MAC DA), the
+tagging protocol may require the DSA master to operate in promiscuous mode, to
+receive all frames regardless of the value of the MAC DA. This can be done by
+setting the ``promisc_on_master`` property of the ``struct dsa_device_ops``.
+Note that this assumes a DSA-unaware master driver, which is the norm.
+
+Hardware manufacturers are strongly discouraged to do this, but some tagging
+protocols might not provide source port information on RX for all packets, but
+e.g. only for control traffic (link-local PDUs). In this case, by implementing
+the ``filter`` method of ``struct dsa_device_ops``, the tagger might select
+which packets are to be redirected on RX towards the virtual DSA user network
+interfaces, and which are to be left in the DSA master's RX data path.
+
+It might also happen (although silicon vendors are strongly discouraged to
+produce hardware like this) that a tagging protocol splits the switch-specific
+information into a header portion and a tail portion, therefore not falling
+cleanly into any of the above 3 categories. DSA does not support this
+configuration.
+
 Master network devices
 ----------------------
 
-- 
2.25.1

