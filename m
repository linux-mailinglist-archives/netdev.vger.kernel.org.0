Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D8131A8A6
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhBMAPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhBMAPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:08 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0871C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:27 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id w1so1986224ejf.11
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WDqyLt8kROLz9VmL7KI/l5D3PbLq6wLFVavRLaGEAss=;
        b=AV7VlK6YVj3vc0UR5bQvb2gZYitK6HENOPiglWVlcBJu5nboMDWz7OjJ4gSD5fjqMK
         NgckUEFJVd0m/rR+O8zPtvdYPoRn0QDF95PEUAusRPVh8TYMWn6VmMl3UZ2+Q7rir4XL
         4nFT8AaolZnPOP02nZpx86UQp1RqrhFaYbe7zsC3WjZY6MGDI05aOBcAW9C7w5nupgKH
         dtNTEhTuPlmlPSjQVO/JV/3ZwpU7dpErltU+hikscB39Ew6djfkPnFJ7Xr7McAO+bpOF
         pZR8QjSxsfAm3zXRu7E5LVSV1G0Zp9eyRXj8zt0cR+KEBVIq7z7fSprfIaAg5UPl5PIT
         1ivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WDqyLt8kROLz9VmL7KI/l5D3PbLq6wLFVavRLaGEAss=;
        b=OoMNtFZU06sImBY9vc5rqvXMJm/q3cyxj7Ypcp9JlUSCFENu3u2WtbJIFO+FGXY9Sk
         2mGG3n8LQJkMYiAbyALqPs+3rQn73sUdyaNe0OaKstBMN8E4Eh9qZjNPo4dMFygM2MDC
         Y9P8yIBvdzIuhLdn78z6w6Akhkp4Swmc2uRBus6XyzBgIuCeippF6MaB7kRm3LvGb9zG
         G5Yo+44S0dQjnLVa2q71GjvsdJ9ktRqQfzvg9A9mr2ZaO7CaO0elveqEtdKgcl+yhl6o
         pDs6jgEuf+vNK977///ndEKXCgKWJROafqTGl7SixcPnhoLgaXCrGjFI0OaYj+U86Rw4
         qTNg==
X-Gm-Message-State: AOAM532iL92CB18x+xQyEaWHIsCzUAhJukWDWKOGpKq+mzZVNroP2qmm
        0/jbVSQcbCgHg9z+vRK6gd0=
X-Google-Smtp-Source: ABdhPJz7UIXatUANnwFIKgcKWfuRK/Qv6yXt/fHzz7OQcGMSn03gIsmH4+62+4pTtafa8782Q9ySyw==
X-Received: by 2002:a17:906:1457:: with SMTP id q23mr3596205ejc.43.1613175266360;
        Fri, 12 Feb 2021 16:14:26 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:25 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 00/12] PTP for DSA tag_ocelot_8021q
Date:   Sat, 13 Feb 2021 02:14:00 +0200
Message-Id: <20210213001412.4154051-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is part two of the errata workaround begun here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210129010009.3959398-1-olteanv@gmail.com/

Now that we have basic traffic support when we operate the Ocelot DSA
switches without an NPI port, it would be nice to regain some of the
features lost due to the lack of the NPI port functionality. An
important one is PTP timestamping, which is intimately tied to the DSA
frame header added by the NPI port: on TX, we put a "timestamp request
ID" in the Injection Frame Header, while on RX, the Extraction Frame
Header contains a partial 32-bit PTP timestamp. Get rid of the NPI port
and replace it with a VLAN-based tagger, and you lose PTP, right?

Well, not quite, this is what this patch series is about. The NPI port
is basically a regular Ethernet port configured to service the packets
in and out of the switch's CPU port module (which has other non-DSA I/O
mechanisms too, such as register-based MMIO and DMA). If we disable the
NPI port, we can in theory still access the packets delivered to the CPU
port module by doing exactly what the ocelot switchdev driver does:
extracting Ethernet packets through registers (yes, it is as icky as it
sounds).

However, there's a catch. The Felix switch was integrated into NXP
LS1028A with the idea in mind that it will operate as DSA, i.e. using
the CPU port module connected to the NPI port, not having I/O over
register-based MMIO which is painfully slow and CPU intensive. So
register-based packet I/O not supposed to work - those registers aren't
even documented in the hardware reference manual for Felix. However
they kinda do, with the exception of the fact that an RX interrupt was
really not wired to the CPU cores - so we don't know when the CPU port
module receives a new packet. But we can hack even around that, by
replicating every packet that goes to the CPU port module and making it
also go to a plain internal Ethernet port. Then drop the Ethernet packet
and read the other copy of it from the CPU port module, this time
annotated with the much-wanted RX timestamp.

This is all fine and it works, but it does raise some questions about
what DSA even is anymore, if we start having switches that inject some
of their packets over Ethernet and some through registers, where do we
draw the line. In principle I believe these concerns are founded, but at
the same time, the way that the Felix driver uses register MMIO based
packet I/O is fundamentally the same as any other DSA driver capable of
PTP makes use of a side-channel for timestamps like a FIFO (just that
this one is a lot more complicated, and comes with the entire actual
packet, not just the timestamp).

Nonetheless, I tried to keep the extra pressure added by this ERR
workaround upon the DSA subsystem as small as possible, so some of the
patches are just a revisit of some of Andrew's complaints w.r.t. the
fact that tag_ocelot already violates any driver <-> tagger boundary,
and as a consequence, is not able to be used on testbeds such as
dsa_loop (which it now can). So now, the tag_ocelot and tag_ocelot_8021q
drivers should be dsa_loop-clean, and have the ERR workarounds as
self-contained as possible, using all the designated features for PTP
timestamping and nothing more.

Comments appreciated.

Vladimir Oltean (12):
  net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
  net: mscc: ocelot: only drain extraction queue on error
  net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
  net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
  net: mscc: ocelot: refactor ocelot_port_inject_frame out of
    ocelot_port_xmit
  net: dsa: tag_ocelot: avoid accessing ds->priv in ocelot_rcv
  net: mscc: ocelot: use common tag parsing code with DSA
  net: dsa: tag_ocelot: single out PTP-related transmit tag processing
  net: dsa: tag_ocelot: create separate tagger for Seville
  net: mscc: ocelot: refactor ocelot_xtr_irq_handler into
    ocelot_xtr_poll
  net: dsa: felix: setup MMIO filtering rules for PTP when using
    tag_8021q
  net: dsa: tag_ocelot_8021q: add support for PTP timestamping

 drivers/net/dsa/ocelot/felix.c             | 224 +++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h             |  14 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  29 +--
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  30 +--
 drivers/net/ethernet/mscc/ocelot.c         | 216 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h         |   9 -
 drivers/net/ethernet/mscc/ocelot_net.c     |  81 +------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 178 +--------------
 include/linux/dsa/ocelot.h                 | 218 ++++++++++++++++++
 include/net/dsa.h                          |   2 +
 include/soc/mscc/ocelot.h                  |  13 +-
 net/dsa/tag_ocelot.c                       | 244 +++++++--------------
 net/dsa/tag_ocelot_8021q.c                 |  31 +++
 13 files changed, 794 insertions(+), 495 deletions(-)
 create mode 100644 include/linux/dsa/ocelot.h

-- 
2.25.1

