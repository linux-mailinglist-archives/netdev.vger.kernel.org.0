Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199D7196D25
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgC2LwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:52:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44998 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgC2LwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:52:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id m17so17450495wrw.11;
        Sun, 29 Mar 2020 04:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f1hjWQ0VpwwG+vtkKj0P9tGfDlVpUagazi+4VPhlgcc=;
        b=WJhBdZASkPc2a16jpH2meYRTTE/0QbpY+ClOMtx6kHEDXiPplaaN25hrq/1r6PfOBh
         Dks+Db3UU7Bat9gvr4/Rf1UBgsXM2NOvzj5VDJeAr6htHXKjIGyzxz2kibbmVr7j4qZ9
         t4L6oVJdqvObxW/z0ihOVEenX+hJHa6t3lT421xi6FdmL7oWtD0NXiuroX68NNOi67Ud
         7p7OS0jsfaTri0WQcvTIqFsiBrG2Ed7X4C0J2ZOZ0iB/o7NPFikFi9JjbIYWo+jkMKbI
         oEm+y0ZAo1ymw3che08X+egbXNxhaLRtRr29qaJuQWc3LavHT4y7xjr30ukorrmlAZ5K
         NJYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f1hjWQ0VpwwG+vtkKj0P9tGfDlVpUagazi+4VPhlgcc=;
        b=aDllgC0Az8qlPzVOdni3r/JPuC9QXvAssN359hVv0b51OK7rVk3x41NxrHdQ+omesZ
         x0Dmc2PLmehco8yF0f6j0GFCmTd83NDhku+t0lp2z85/6NVtCUvCeC9+0u2+GrvxW111
         f0ciGH51eWwOPe8afymNCp2Zd0DGtk53E+EZMCzzPvYDkyh+Al9Eo0nf6WZNm002M/gA
         Y+S7HQzhquNa2ej9YOe/Vz5ryAL1wMI2NXj8iofJGTRjdtYufhgztjz21/q+1xyRWsIR
         UmxjyFj3UBFmZ44MKJ4du5Ryjjk3f5rJkuEyW8aDcr2kSO9+Ma62hE/iQZjilpTrUYdg
         AAHA==
X-Gm-Message-State: ANhLgQ3RloQ7AWwho6iSoLnWTA7rDIKqkd5skp6/ZjPUSBLbZX5GEv3+
        vMEg+gX19hQnZwyrNfRrl7A=
X-Google-Smtp-Source: ADFU+vvsYHg0S/NfJXJATtai7aumc5Ci7xZ3WKrLq+Ia1r36SpdRohFwPos7nxdiRLop3mAvM0p3ig==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr2824269wrs.2.1585482735741;
        Sun, 29 Mar 2020 04:52:15 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id 5sm14424108wrs.20.2020.03.29.04.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 04:52:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 0/6] Port and flow policers for DSA (SJA1105, Felix/Ocelot)
Date:   Sun, 29 Mar 2020 14:51:56 +0300
Message-Id: <20200329115202.16348-1-olteanv@gmail.com>
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

Series version 1 was submitted here:
https://patchwork.ozlabs.org/cover/1263353/

Nothing functional changed in v2, only a rebase.

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

