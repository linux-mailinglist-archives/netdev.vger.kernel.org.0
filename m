Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50680196A68
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgC2AxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:53:04 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:38298 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgC2AxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 20:53:03 -0400
Received: by mail-wm1-f52.google.com with SMTP id f6so10578945wmj.3;
        Sat, 28 Mar 2020 17:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Na7wyrzT+k3IFcky+igmTe2zIXXsrDMhUb6NMdBSDCk=;
        b=kHlvkKtzYXJazfO1xiqET5xMF9bj8hEkhwoheKaJLlz15q/T7PmQrOX4wWP8zW9l7+
         Uz5oytDcceY5gWg3UsgNx+ZNiegbQSgISWXkvJvPPM3xop7ue85/UtaoCamukbRveR7d
         cInhnxid5XuGQK96V1R5ZmEL3c9y9VhxUotUZwT6yrVruZ/UDCuPOVt92/NqBF0rJ06R
         k3vCaKuj4vwPa2ktHTVNMOQIgmxiUbMK0Q9ZS/AuEmT/C6PjZxGyk6IvjWAWV5vfhiEq
         eM0LiKB2vnjKSGlckYwLnU3oUYV0Zk6NkdfzKMyriCX+web4HAxo8KQFFT2v4b7M2Nm8
         6fvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Na7wyrzT+k3IFcky+igmTe2zIXXsrDMhUb6NMdBSDCk=;
        b=rTHcPPGkSETJyUaJW/XA1XU2LXczk5MHXkS6blJSdCiwh2QXE29Jl/XGY+v8bfobY6
         TRLMHmDP3edPt6s8W+jC/6qSeFflPo1KBVs/tV+yhKf5GSlYqUTqRjcNX8/KNgikZHTH
         a/ODCyS03v6YtNHsWV+DchIZdDCP2SKe32qeRTIE5IY3f4KvOp3yhirg2FjAgQCT7P6e
         KCJqsTma+KqhnjCIYezP4dE8iqVzT3C5oALPX65iDjTI4mzUhMuZSoEk37wbUg2pYUZ1
         7tEJjB0NpgS07pXTELgT9cUn5a63Bh9vgXMU59MF+ylBz20ZCK1BLgm82r05NGmz76/0
         vP8w==
X-Gm-Message-State: ANhLgQ2yQb3AOrCz3K259uPOCdOTBMoEtoSfYM8Wz7d3+BNAjIJU402n
        j3e3M9oABgoxtoNXMx7nqOs=
X-Google-Smtp-Source: ADFU+vtZ4vmRDf+LHAwqfxnoVrDp7wIAEERU48jBEdKltGdY3MgKV5t0qR6Vs2+SJLi2tIo5CKt6Dw==
X-Received: by 2002:a1c:6146:: with SMTP id v67mr6312334wmb.78.1585443181188;
        Sat, 28 Mar 2020 17:53:01 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id l1sm8292652wme.14.2020.03.28.17.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 17:53:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com
Subject: [PATCH net-next 0/6] Port and flow policers for DSA (SJA1105, Felix/Ocelot)
Date:   Sun, 29 Mar 2020 02:51:56 +0200
Message-Id: <20200329005202.17926-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support for 2 types of policers:
 - port policers, via tc matchall filter
 - flow policers, via tc flower filter
for 2 DSA drivers:
 - sja1105
 - felix/ocelot

First we start with ocelot/felix. Prior to this patch, the ocelot core
library currently only supported:
- Port policers
- Flow-based dropping and trapping
But the felix wrapper could not actually use the port policers due to
missing linkage and support in the DSA core. So one of the patches
addresses exactly that limitation by adding the missing support to the
DSA core. The other patch for felix flow policers (via the VCAP IS2
engine) is actually in the ocelot library itself, since the linkage with
the ocelot flower classifier has already been done in an earlier patch
set.

Then with the newly added .port_policer_add and .port_policer_del, we
can also start supporting the L2 policers on sja1105.

Then, for full functionality of these L2 policers on sja1105, we also
implement a more limited set of flow-based policing keys for this
switch, namely for broadcast and VLAN PCP.

Vladimir Oltean (5):
  net: dsa: refactor matchall mirred action to separate function
  net: dsa: add port policers
  net: dsa: felix: add port policers
  net: dsa: sja1105: add configuration of port policers
  net: dsa: sja1105: add broadcast and per-traffic class policers

Xiaoliang Yang (1):
  net: mscc: ocelot: add action of police on vcap_is2

 drivers/net/dsa/ocelot/felix.c            |  24 ++
 drivers/net/dsa/sja1105/Makefile          |   1 +
 drivers/net/dsa/sja1105/sja1105.h         |  40 +++
 drivers/net/dsa/sja1105/sja1105_flower.c  | 340 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c    | 136 +++++++--
 drivers/net/ethernet/mscc/ocelot_ace.c    |  64 +++-
 drivers/net/ethernet/mscc/ocelot_ace.h    |   4 +
 drivers/net/ethernet/mscc/ocelot_flower.c |   9 +
 drivers/net/ethernet/mscc/ocelot_police.c |  27 ++
 drivers/net/ethernet/mscc/ocelot_police.h |  11 +-
 drivers/net/ethernet/mscc/ocelot_tc.c     |   2 +-
 include/net/dsa.h                         |  13 +-
 include/soc/mscc/ocelot.h                 |   9 +
 net/dsa/slave.c                           | 145 ++++++---
 14 files changed, 742 insertions(+), 83 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_flower.c

-- 
2.17.1

