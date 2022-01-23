Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD272496F66
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiAWBdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiAWBdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:44 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FA5C06173B;
        Sat, 22 Jan 2022 17:33:43 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id s5so11100552ejx.2;
        Sat, 22 Jan 2022 17:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MOcW1whAHPYP3c4z42gknvYxdYpE8iK9sfzw5lwuJqM=;
        b=RWSKr5a1RrnT8os3PLBtvXX73CALP/ICiWdnR+vjeOEcWLaUDviRyta9W+HOrgzUjX
         gJP4YNFhPhlKCBv1Jmu4Zs/ioitv+tf9M72aTkrLz6eMcAMqbeV36KH8jw4VRz7l66P7
         XebPN755SlBIFJx4v3ELemCvTJsUZIS6FI7Pujqz3eKFD3ZKM02jjkrsYV2OxWCbXlWW
         QBzev2MW5aDgV6OprbKqnDZ/y/3wFKg+Z4uwKy583hdfEar0ZU7onDEM8It5Ha7QSqZZ
         usxKG9enPTknD8RgaTljwkhhiC8vdXhNCiN+NG9Nil3jU8Dd1oxLZd0QLjgkli8LUNPr
         B02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MOcW1whAHPYP3c4z42gknvYxdYpE8iK9sfzw5lwuJqM=;
        b=VF6c+fySM9vR0h6oQArUoKzgPA6q+G+IAxXJIxfXTvzlfYtkD66Y+Ij9adf2jqrtQr
         f+dDN7+4XvVxO1iNVpilyXGtScklMcz6epYu58FAVnwgWnhD5hE50cvtqjNroPmE1NFI
         cYNC/127NJf2YRaQIsBgYSxVp+a9LskIIXW3zCJoxQ1EW6vxGatICII2uKAgVPnhs0Do
         x9vM+GU+4/RC64nEhNxvlVeiWCG6/02qo0ZePlskC67tANaTeEyKk9qrIMHxnhKggH/B
         fpeGPb8NpeIjvpBdUnnwTPFnc3xtAsOQMg4/7T0Ugmx6kdOyjeKmJLDX11wr996UqcuH
         tccQ==
X-Gm-Message-State: AOAM533tH/hGyT2/xXx+DmmmkdQhaEnvUG+8bCi2ZDOdgXfKaKPwDaXm
        CdV9C5mfIgm3Uv5qCVueNpU=
X-Google-Smtp-Source: ABdhPJyElAOJxsD5mBODh7TV0y+KC74hUZyb78iL//DSQurBSQp2q7YwbBIGOw/yNcH/bkjv6S6XvA==
X-Received: by 2002:a17:906:5d08:: with SMTP id g8mr8110497ejt.759.1642901621419;
        Sat, 22 Jan 2022 17:33:41 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:40 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 00/16] Add support for qca8k mdio rw in Ethernet packet
Date:   Sun, 23 Jan 2022 02:33:21 +0100
Message-Id: <20220123013337.20945-1-ansuelsmth@gmail.com>
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




Sorry if I missed any comments. This series is 2 month old so I think it
would be good to recheck everything. In the mean time this was tested on
and no regression are observed related to random port drop.

v7:
- Rebase on net-next changes
- Add bulk patches to speedup this even more
v6:
- Fix some error in ethtool handler caused by rebase/cleanup
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

Ansuel Smith (14):
  net: dsa: tag_qca: convert to FIELD macro
  net: dsa: tag_qca: move define to include linux/dsa
  net: dsa: tag_qca: enable promisc_on_master flag
  net: dsa: tag_qca: add define for handling mgmt Ethernet packet
  net: dsa: tag_qca: add define for handling MIB packet
  net: dsa: tag_qca: add support for handling mgmt and MIB Ethernet
    packet
  net: dsa: qca8k: add tracking state of master port
  net: dsa: qca8k: add support for mgmt read/write in Ethernet packet
  net: dsa: qca8k: add support for mib autocast in Ethernet packet
  net: dsa: qca8k: add support for phy read/write with mgmt Ethernet
  net: dsa: qca8k: move page cache to driver priv
  net: dsa: qca8k: cache lo and hi for mdio write
  net: da: qca8k: add support for larger read/write size with mgmt
    Ethernet
  net: dsa: qca8k: introduce qca8k_bulk_read/write function

Vladimir Oltean (2):
  net: dsa: provide switch operations for tracking the master state
  net: dsa: replay master state events in
    dsa_tree_{setup,teardown}_master

 drivers/net/dsa/qca8k.c     | 709 +++++++++++++++++++++++++++++++++---
 drivers/net/dsa/qca8k.h     |  46 ++-
 include/linux/dsa/tag_qca.h |  82 +++++
 include/net/dsa.h           |  17 +
 net/dsa/dsa2.c              |  74 +++-
 net/dsa/dsa_priv.h          |  13 +
 net/dsa/slave.c             |  32 ++
 net/dsa/switch.c            |  15 +
 net/dsa/tag_qca.c           |  83 +++--
 9 files changed, 993 insertions(+), 78 deletions(-)
 create mode 100644 include/linux/dsa/tag_qca.h

-- 
2.33.1

