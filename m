Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A64A474CF9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbhLNVK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhLNVK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:28 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81523C061574;
        Tue, 14 Dec 2021 13:10:28 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r25so66923865edq.7;
        Tue, 14 Dec 2021 13:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BX6NtYo8MAlEnIDBRiwbPzGlXM9EbNW3RaUn5EkETVI=;
        b=Fu4JYX8oU0obl+PSBvvfNP1M/gaNNNbtBSlDqsH8QuvcDW26jWFoGGhPtQUD8f4v9Z
         NugWmsSIZVrUvi0s15JdXNKLXaDF7BxMoPXLr3F46oILljW2zoXQ7NkytdQsehjiVVsF
         B7nExabA8CxHouOaqnUshx6ddj7phNZl7i0vpvQd9sPiRTAtGtfa1GHCZt8DdKjASBiG
         CaZys9290sKa4EUIvrzHHMPaz3gQ2sqNYubgilwdb7DlG/QV8oaCgYZ5PB8JEovFVQnG
         0ZkT7B7fkFHJxHTBTAIKk9m7wtwzaa5gQtiZ5EP40JPwiGTydwlpUdiHXLbN5RgTowdG
         sxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BX6NtYo8MAlEnIDBRiwbPzGlXM9EbNW3RaUn5EkETVI=;
        b=c4VKDasQ16j5e6Pf1WX/B4ugiW2TKjvJK58XOHsAstrCvMAJmcxX+sba9Wa0fa4X9E
         ga0fRhy4lHe+W1IHfpio+q3ZKk+iRvsqgq1urTBKeIvTna4+S2NBgNoEuCnIfW0R1ZJU
         5H25jPHfnegxazr9ID73crVTkaheTWoGbUN2R2J4Z4rt3d/ZW91CVFNab4wuMl+/8JmE
         fCXhSjljLlwfqNvUttD6vX2ht2bgu4vdPiIvVkV4wqb5LkVjw2iQwCVNT532IZz9R7sL
         falwFcgUhPkggo9uaL89Kp0p3z/XL9YKw7ROBP4ruQtoB2dzi5xzEXnZxerQJsBfwCSG
         DeRw==
X-Gm-Message-State: AOAM530xz47iQoUTbNeEEElsALfrwKyHS4oSzgNDXWN7jxtBa0j67V3u
        ceMsbKZXsji0Gl1d0+YODGY=
X-Google-Smtp-Source: ABdhPJyzZ7PXw8J1LT+UHQzSrQOvztmeCh3s9W/4VgTT7eAu4Gxmr2XeKWraHyasPHNGm2BxGqTAfw==
X-Received: by 2002:a17:906:4488:: with SMTP id y8mr8090992ejo.175.1639516226305;
        Tue, 14 Dec 2021 13:10:26 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:25 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 00/16] Add support for qca8k mdio rw in Ethernet packet
Date:   Tue, 14 Dec 2021 22:09:55 +0100
Message-Id: <20211214211011.24850-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is ready but require some additional test on a wider userbase.

The main reason for this is that we notice some routing problem in the
switch and it seems assisted learning is needed. Considering mdio is
quite slow due to the indirect write using this Ethernet alternative way
seems to be quicker.

The qca8k switch supports a special way to pass mdio read/write request
using specially crafted Ethernet packet.
This works by putting some defined data in the Ethernet header where the
mac source and dst should be placed. The Ethernet type header is set to qca
header and is set to a mdio read/write type.
This is used to communicate to the switch that this is a special packet
and should be parsed differently.

Currently we use Ethernet packet for
- MIB counter
- mdio read/write configuration
- phy read/write for each port

Current implementation of this use completion API to wait for the packet
to be processed by the tagger and has a timeout that fallback to the
legacy mdio way and mutex to enforce one transaction at time.

We now have connect()/disconnect() ops for the tagger. They are used to
allocate priv data in the dsa priv. The header still has to be put in
global include to make it usable by a dsa driver.
They are called when the tag is connect to the dst and the data is freed
using discconect on tagger change.

(if someone wonder why the bind function is put at in the general setup
function it's because tag is set in the cpu port where the notifier is
still not available and we require the notifier to sen the
tag_proto_connect() event.

We now have a tag_proto_connect() for the dsa driver used to put
additional data in the tagger priv (that is actually the dsa priv).
This is called using a switch event DSA_NOTIFIER_TAG_PROTO_CONNECT.
Current use for this is adding handler for the Ethernet packet to keep
the tagger code as dumb as possible.

The tagger priv implement only the handler for the special packet. All the
other stuff is placed in the qca8k_priv and the tagger has to access
it under lock.

We use the new API from Vladimir to track if the master port is
operational or not. We had to track many thing to reach a usable state.
Checking if the port is UP is not enough and tracking a NETDEV_CHANGE is
also not enough since it use also for other task. The correct way was
both track for interface UP and if a qdisc was assigned to the
interface. That tells us the port (and the tagger indirectly) is ready
to accept and process packet.

I tested this with multicpu port and with port6 set as the unique port and
it's sad.
It seems they implemented this feature in a bad way and this is only
supported with cpu port0. When cpu port6 is the unique port, the switch
doesn't send ack packet. With multicpu port, packet ack are not duplicated
and only cpu port0 sends them. This is the same for the MIB counter.
For this reason this feature is enabled only when cpu port0 is enabled and
operational.

Current concern are:
- Any hint about the naming? Is calling this mdio Ethernet correct?
  Should we use a more ""standard""/significant name? (considering also
  other switch will implement this)

v5:
- Adapt to new API fixes
- Fix a wrong logic for noop
- Add additional lock for master_state change
- Limit mdio Ethernet to cpu port0 (switch limitation)
- Add priority to these special packet
- Move mdio cache to qca8k_priv
v4:
- Remove duplicate patch sent by mistake.
v3:
- Include MIB with Ethernet packet.
- Include phy read/write with Ethernet packet.
- Reorganize code with new API.
- Introuce master tracking by Vladimir
v2:
- Address all suggestion from Vladimir.
  Try to generilize this with connect/disconnect function from the
  tagger and tag_proto_connect for the driver.

Ansuel Smith (12):
  net: dsa: tag_qca: convert to FIELD macro
  net: dsa: tag_qca: move define to include linux/dsa
  net: dsa: tag_qca: enable promisc_on_master flag
  net: dsa: tag_qca: add define for handling mdio Ethernet packet
  net: dsa: tag_qca: add define for handling MIB packet
  net: dsa: tag_qca: add support for handling mdio Ethernet and MIB
    packet
  net: dsa: qca8k: add tracking state of master port
  net: dsa: qca8k: add support for mdio read/write in Ethernet packet
  net: dsa: qca8k: add support for mib autocast in Ethernet packet
  net: dsa: qca8k: add support for phy read/write with mdio Ethernet
  net: dsa: qca8k: move page cache to driver priv
  net: dsa: qca8k: cache lo and hi for mdio write

Vladimir Oltean (4):
  net: dsa: provide switch operations for tracking the master state
  net: dsa: stop updating master MTU from master.c
  net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
  net: dsa: replay master state events in
    dsa_tree_{setup,teardown}_master

 drivers/net/dsa/qca8k.c     | 597 ++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/qca8k.h     |  46 ++-
 include/linux/dsa/tag_qca.h |  79 +++++
 include/net/dsa.h           |  17 +
 net/dsa/dsa2.c              |  81 ++++-
 net/dsa/dsa_priv.h          |  13 +
 net/dsa/master.c            |  29 +-
 net/dsa/slave.c             |  32 ++
 net/dsa/switch.c            |  15 +
 net/dsa/tag_qca.c           |  81 +++--
 10 files changed, 898 insertions(+), 92 deletions(-)
 create mode 100644 include/linux/dsa/tag_qca.h

-- 
2.33.1

