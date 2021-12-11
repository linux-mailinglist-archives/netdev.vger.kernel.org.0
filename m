Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDA24715DD
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhLKT6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhLKT6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:16 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFA8C061714;
        Sat, 11 Dec 2021 11:58:16 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r25so39577482edq.7;
        Sat, 11 Dec 2021 11:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CqpqKhU0+Lmh3lJMOy6FtAfC8RxScM0RzyUAyQHvAzw=;
        b=UBcv/NA10KAjLxfHPwdTchWi6foL9mmEpRprNjXEgjfOCM4TQ1zmWo//j+lnV9LY92
         7I2SuWmjSUYkPKHgW6TmyQxSiygP0DUphtr3pfp1TQ7eELvnE+TUWKPf/Gs3Vy/VDAGF
         Bbd0ZM1uxeNnmNgkTgxBVD8iTPTATRSeFHoOvcikVvz3Z8mH12JCoUp0oGBf8IznHJ1H
         hkc9Tg403l70x+IFRg7gZSn/rqz4VTbXmUBZ4ZNpMpE4b6fQraHguNMynhbAUfPyjAMf
         s0RypWwiKNYXlfe461CfrJzZhjOlaGG9oX9BDT38K1jJmDpA7cE3HhEu7spxnqeiYFAY
         0ywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CqpqKhU0+Lmh3lJMOy6FtAfC8RxScM0RzyUAyQHvAzw=;
        b=gVKNrZIeODB7wei8t0Oi3Gi+4o2p8BITIUwDSrZzfkwlT3LMr9KjNGtCnGAHpFz2Hs
         vGigtrAg/EEQGCY9dEAmlLjcj+y/oYAEtB3H66qtB3sbyp7NqdVvF+kOoRsVFRtn5K1O
         6IE/wrFfDkHn1fBzrv9URL0eSA022NV5hG0qjg5qQ/04dLMaqb2etnVoWL/aLpfewOBz
         m3n/VtcMFB6CiAFKfWjARRG5c3uAcqCz4h2LDaerTte5fwJ/FUy6171vn5T2jg5+g55V
         ITbOm8D2N9J2S9DtAMt7KLMmWlRumCBBZYhmWjhgc8NqMfAvVGLQZptbyfy9J4/Omt2z
         OtvA==
X-Gm-Message-State: AOAM532ha99agEfVZ25lno6II2EJHvQnmCoeiR+cl2lcS496gcTlqDpI
        lIwT2AmZYRDHPp7KbJhEkF7/TF6IjMV0FA==
X-Google-Smtp-Source: ABdhPJzy0TB8zX42CkEUICEzB0tpAVqGcC1XZLdEBXnF33xmYTmIZTGjlZeHXKlcUOwhXkzk5qYncA==
X-Received: by 2002:a17:907:86a1:: with SMTP id qa33mr33559577ejc.142.1639252694434;
        Sat, 11 Dec 2021 11:58:14 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:13 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 00/15] Add support for qca8k mdio rw in Ethernet packet
Date:   Sat, 11 Dec 2021 20:57:43 +0100
Message-Id: <20211211195758.28962-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This require the "Replace DSA dp->priv with tagger-owned storage" series
https://patchwork.kernel.org/project/netdevbpf/cover/20211209233447.336331-1-vladimir.oltean@nxp.com/
This require specifically
https://patchwork.kernel.org/project/netdevbpf/patch/20211209233447.336331-2-vladimir.oltean@nxp.com/
of Vladimir series to correctly compile and work.



Hi, this is still WIP and currently has some problem but I would love if
someone can give this a superficial review and answer to some problem
with this.

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

Current implementation of this use completion API to wait for the packet
to be processed by the tagger and has a timeout that fallback to the
legacy mdio way and mutex to enforce one transaction at time.

Here I list the main concern I have about this:
- Is the changes done to the tagger acceptable? (moving stuff to global
  include)
- Is it correct to put the skb generation code in the qca8k source?
- Is the changes generally correct? (referring to how this is
  implemented with part of the implementation split between the tagger
  and the driver)

I still have to find a solution to a slowdown problem and this is where
I would love to get some hint.
Currently I still didn't find a good way to understand when the tagger
starts to accept packets and because of this the initial setup is slow
as every completion timeouts. Am I missing something or is there a way
to check for this?
After the initial slowdown, as soon as the cpu port is ready and starts
to accept packet, every transaction is near instant and no completion
timeouts.

As I said this is still WIP but it does work correctly aside from the
initial slowdown problem. (the slowdown is in the first port init and at
the first port init... from port 2 the tagger starts to accept packet
and this starts to work)

Additional changes to the original implementation:

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

From what I read in the old series we probably need to drop the priv and
move to a more specific use to prevent any abuse... (or actually just
add an additional priv just for the tagger to prevent any breakage by
removing priv from dsa_port)

I still didn't investigate the slowdown problem that is still present in
some part when the port are actually init.

Hope Andrew is not too angry about this implementation but it seems
flexible and not that bad.

(also in the current code I assume a tagger is always present. This
should be the case or a check if the tagger is not present is needed?)

Also still have to work on the autocast handler but it's really a
function to add with the current implementation. Tagger is already have
support to handle them.



Additional changes to current implementation v3:

The tagger priv has changed to only implement the handler. All the
other stuff is now placed in the qca8k_priv and the tagger has to access
it under lock.
We also add MIB in Ethernet packet with an additional handler.
We also use mdio Ethernet for phy read/write but that is still dubious.
We use the new API from Vladimir to track if the master port is
operational or not. We had to track many thing to reach a usable state.
Checking if the port is UP is not enough and tracking a NETDEV_CHANGE is
also not enough since it use also for other task. The correct way was
both track for interface UP and if a qdisc was assigned to the
interface. That tells us the port (and the tagger indirectly) is ready
to accept and process packet.



Current concern are:
- Any hint about the naming? Is calling this mdio Ethernet correct?
  Should we use a more ""standard""/significant name? (considering also
  other switch will implement this)
- Should we use Ethernet packet also for phy read/write? From my test it
  works right but wonder if we should use mdio for phy and Ethernet for
  config/other task? It looks like the switch can work with both mdio
  mdio used for reg and Ethernet. (probably a locking internally)
  Also from CPU load, what is heavier? mdio or ethernet handling?
  Considering how phy works we require 3 skb allocation while for
  mdio we need at worst 9+ write.

Aside from these minor concern this should be ready for review.

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

Ansuel Smith (11):
  net: dsa: tag_qca: convert to FIELD macro
  net: dsa: tag_qca: move define to include linux/dsa
  net: da: tag_qca: enable promisc_on_master flag
  net: dsa: tag_qca: add define for handling mdio Ethernet packet
  net: dsa: tag_qca: add define for handling MIB packet
  net: dsa: tag_qca: add support for handling mdio Ethernet and MIB
    packet
  net: dsa: qca8k: add tracking state of master port
  net: dsa: qca8k: add support for mdio read/write in Ethernet packet
  net: dsa: qca8k: add support for mib autocast in Ethernet packet
  net: dsa: qca8k: add support for phy read/write with mdio Ethernet
  net: dsa: qca8k: cache lo and hi for mdio write

Vladimir Oltean (4):
  net: dsa: provide switch operations for tracking the master state
  net: dsa: stop updating master MTU from master.c
  net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
  net: dsa: replay master state events in
    dsa_tree_{setup,teardown}_master

 drivers/net/dsa/qca8k.c     | 501 +++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h     |  31 ++-
 include/linux/dsa/tag_qca.h |  79 ++++++
 include/net/dsa.h           |  11 +
 net/dsa/dsa2.c              |  81 +++++-
 net/dsa/dsa_priv.h          |  13 +
 net/dsa/master.c            |  29 +--
 net/dsa/slave.c             |  32 +++
 net/dsa/switch.c            |  15 ++
 net/dsa/tag_qca.c           |  94 +++++--
 10 files changed, 820 insertions(+), 66 deletions(-)
 create mode 100644 include/linux/dsa/tag_qca.h

-- 
2.32.0

