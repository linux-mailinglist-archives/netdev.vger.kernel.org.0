Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6449D2F1CD3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388070AbhAKRoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730937AbhAKRoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:44:14 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF75AC061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:33 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g24so600589edw.9
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KS1enu7JMCsba/RNhT/5Ko+ZJQMbssGJVzCOkP52yl4=;
        b=fyzGruIpRR71KAcVu9gOvRbQ/YNZqPBvPZbK23bMz0okPLxbX4Zd0pdVXRssRMtQCU
         FsqWOOd1dJkGeRKehkH8B8Kei7Z49FD1WjWK60mXAV38O/0K45h3lmeuY3rDTAUjFzr4
         uAohuXLdIl9F94YHD0fDnXStYJnWcKakhqZ+9ylbW7UmElznYe7s4KZFP63SL80/5PAP
         t0h6/hk40huAB9CHQFNaZmyvq2rbUroKbhZwt/4a5Rkayr/rJBNDh+beUXEmEWeoQG+2
         Mt0BlLcH16RsnXs4dUNn/cmCiuGtNHJyR8RyzxHw6GW5FK/ViIjaamOLhQZnUu1YnK/X
         XUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KS1enu7JMCsba/RNhT/5Ko+ZJQMbssGJVzCOkP52yl4=;
        b=qFmGdIbA9Jcx3Fpm+I/FZQ49mL3KmjhADfLqJdDV+0Xnk6l4FAXMqtGxxCcIy/jMPM
         2H0mlm3mn8L4X4J1gHMP6vtCLje23Y4Fvx9r0MI5j78vLMBnW8oCEYieEk6+sRZcBy0y
         AmYQ2jWjFeJWdyma7wHyg6uGkiRwL6yi9ZpBlXt7pLORjOH9B8xGQERGHxrLrKAyw9jY
         QkN0qoJRZx5VqDfWTPTh3GDdIIgg0CipCr4+ujVaEhFxO0HVQPcjvPdLRt26Zj5n+JM6
         zFJGZ9dk46tJVJjttOgcoUXN4xXR+pQ9RErDr/BNuZ1/3nkll2Hpr+Kzw1jwlTGLZ9nu
         XWkQ==
X-Gm-Message-State: AOAM533frT0Yft8PV2PE1AkE0GnJHlHi/MjqHufjKL6uEkg03HcJH9Ym
        TDLKygM96Gz0Tf9Rwd1YVQU=
X-Google-Smtp-Source: ABdhPJzVTpVX7h4hjaIptQguSL8uqK3YkaDISoc0ARxFItyOkqKkvsblYd4xY36UnvVLNcNhXdB1nQ==
X-Received: by 2002:a50:d4d9:: with SMTP id e25mr359634edj.243.1610387012417;
        Mon, 11 Jan 2021 09:43:32 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j22sm111132ejy.106.2021.01.11.09.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:43:31 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 00/10] Configuring congestion watermarks on ocelot switch using devlink-sb
Date:   Mon, 11 Jan 2021 19:43:06 +0200
Message-Id: <20210111174316.3515736-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In some applications, it is important to create resource reservations in
the Ethernet switches, to prevent background traffic, or deliberate
attacks, from inducing denial of service into the high-priority traffic.

These patches give the user some knobs to turn. The ocelot switches
support per-port and per-port-tc reservations, on ingress and on egress.
The resources that are monitored are packet buffers (in cells of 60
bytes each) and frame references.

The frames that exceed the reservations can optionally consume from
sharing watermarks which are not per-port but global across the switch.
There are 10 sharing watermarks, 8 of them are per traffic class and 2
are per drop priority.

I am configuring the hardware using the best of my knowledge, and mostly
through trial and error. Same goes for devlink-sb integration. Feedback
is welcome.

Vladimir Oltean (10):
  net: mscc: ocelot: auto-detect packet buffer size and number of frame
    references
  net: mscc: ocelot: add ops for decoding watermark threshold and
    occupancy
  net: dsa: add ops for devlink-sb
  net: dsa: felix: reindent struct dsa_switch_ops
  net: dsa: felix: perform teardown in reverse order of setup
  net: mscc: ocelot: export NUM_TC constant from felix to common switch
    lib
  net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
  net: mscc: ocelot: register devlink ports
  net: mscc: ocelot: initialize watermarks to sane defaults
  net: mscc: ocelot: configure watermarks using devlink-sb

 drivers/net/dsa/ocelot/felix.c             | 209 +++--
 drivers/net/dsa/ocelot/felix.h             |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  23 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  20 +-
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot.c         |  18 +-
 drivers/net/ethernet/mscc/ocelot.h         |   9 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c | 885 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c     | 253 +++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 108 ++-
 include/net/dsa.h                          |  34 +
 include/soc/mscc/ocelot.h                  |  55 +-
 include/soc/mscc/ocelot_qsys.h             |   7 +-
 net/dsa/dsa2.c                             | 159 +++-
 14 files changed, 1684 insertions(+), 101 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_devlink.c

-- 
2.25.1

