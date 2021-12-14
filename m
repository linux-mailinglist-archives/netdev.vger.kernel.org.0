Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D64474E0A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhLNWoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbhLNWoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:24 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB93C061574;
        Tue, 14 Dec 2021 14:44:23 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z5so68864999edd.3;
        Tue, 14 Dec 2021 14:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTMa6nBW2dVDD4ivSmBS0v0oje7pKvnZd8kC99gARJI=;
        b=Fxw0CYlRA/rEAedZO5kF5CKN3BQwD02sxl4Lq6bT5RTpCZ6/4/RseRye/IvRIvoBiD
         wBJzFBl+5/Di52mkNoyyqoLkW9H699aMvOB6+lDInWoZRdy9NOhM3NH26DaeA98QE6Sj
         3jRzhUl2Lof9s8YY+cuenPKPLosYZX4WIefuat7AE69EliSar7XqMLr/6jfHLXcZKn3s
         21txN34ccvzthz9yebpENjmLGQAElH6o/pWEXLFxiIzLXJUEcHX3AGjf7PbmP6mfgtCa
         mPDcZO6+uJ2wrBFBuGuUrDdB39QnypctI0zKjLHM7syjudKfixEustlJuUoomKEOk2Af
         ciCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTMa6nBW2dVDD4ivSmBS0v0oje7pKvnZd8kC99gARJI=;
        b=C7COfpdQq/mC1mzGMP4drQxXgG+dXWV28FesjkZvbhDM143s1jWqYqUVw9XImpQUlA
         Vh6HU7je2yMBOrpDyIqQ/UG6G/G+LLu7653j67gnFHloVSfijj6yghr3TbM6aWU+q1v+
         I/U7tIGbTZcrvNgkPRVfzXvq98VrXsGt7cguMm2a9JDYxtHRtT+BPMZqTLSfGImQqIAv
         zxpmi2DHc51N/ni2+TjFkZiodQAb1tNZSBgv1nMEUO8xjt/UVLVPLgFTv94SIJISMB1a
         Ve5ZLxMXGY77hmEPj58mh/9zOpQ1Zn0VoJVRc27rJ3juC9Venp53PivZZqgej25hULx1
         IndA==
X-Gm-Message-State: AOAM533IyGTCmFh25wY5Q57FfAaFHzQkYgc2ws1xVzQvHMeTuj4kuj2S
        7mApitUiVznBIMOt8mt9KMMPAPncFNYcQQ==
X-Google-Smtp-Source: ABdhPJwr5Z0Od7rOz1+ze0fDToJKfFx3uYByz5AHRNn29+pJx/C0/zie5/AEm5g8oKhApEipLvPmeA==
X-Received: by 2002:a17:906:478e:: with SMTP id cw14mr1398725ejc.319.1639521862145;
        Tue, 14 Dec 2021 14:44:22 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:21 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v6 00/16] Add support for qca8k mdio rw in Ethernet packet
Date:   Tue, 14 Dec 2021 23:43:53 +0100
Message-Id: <20211214224409.5770-1-ansuelsmth@gmail.com>
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

 drivers/net/dsa/qca8k.c     | 600 ++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/qca8k.h     |  46 ++-
 include/linux/dsa/tag_qca.h |  79 +++++
 include/net/dsa.h           |  17 +
 net/dsa/dsa2.c              |  81 ++++-
 net/dsa/dsa_priv.h          |  13 +
 net/dsa/master.c            |  29 +-
 net/dsa/slave.c             |  32 ++
 net/dsa/switch.c            |  15 +
 net/dsa/tag_qca.c           |  81 +++--
 10 files changed, 901 insertions(+), 92 deletions(-)
 create mode 100644 include/linux/dsa/tag_qca.h

-- 
2.33.1

