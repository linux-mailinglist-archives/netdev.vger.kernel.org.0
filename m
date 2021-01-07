Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E662ED590
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbhAGR2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728836AbhAGR2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:28:17 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F77C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:27:37 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id t16so10675074ejf.13
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MnZsQ8Y6MnViksTSH+PpBq/T7qEHK6CxdwYTCgwzow8=;
        b=uXJZxn8tEE011NsPaaDB0utbiHSBd3WFvgX6sTvptiIypNAj5gsMb6GkfBK9zFMJJ7
         WJVWXs4BMMA3Sq1zP174661XBWP9TDp9Z/Z2GDw1zpCEfoboXMCs+365xDeVOkkRnsX3
         ix02KG/JZ4iScYj+xZNiygdgGWY120mkW9UMCUVZCReMhDLP2CujipSRlGJKBVKPGD3e
         yeh/MWvNyi0/beLpS/Av7FJxizjPbfr5qFnUweIPQTfu2eR3MnHBHpTePsk6MRbNK5pf
         ca4fgvxwEWFPYPELiV5KdoNGbNSHVEDhcCUsH6zAekgf4xvkBSsu4A6KjAdH2ViJd5b5
         I6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MnZsQ8Y6MnViksTSH+PpBq/T7qEHK6CxdwYTCgwzow8=;
        b=B5/T9O2oSr5QSiSsT1QooAfZgOdSJKvOxOjFwMIxCMmLnp7x7ocdGi6NEbWwEmD0TZ
         m5VuMio3wykcEqF4fob1cBvrYs0KGJt79VnS7pjLnmbQEfXFPKg2Hx9UubgFH3GURrn3
         A2TR9J7e84L2fCkD6vDgILHbk3VfMOjrO+MaqiN07Tu9d9b309j7faD6J5OMVfN2ZcRq
         tJ3A4CT5w6le8z8cWicguDOAzYeOMRxUsMS2y5uDp7/PLYpC32uegOkgHFW9ckPYX/S3
         hU0uXDaB++2V/iO66AUkPTZVHQX8PDKpZrH+K/3ho5Na84sOH4X6pCnYy2eNKRxfMEri
         PKnw==
X-Gm-Message-State: AOAM531fsV7EMZ6PUTwR+kQxA/BLJdYtvFzcxztfrhtlhxuwARDShhNe
        aRv4kqwc4prJtBDP6d+9wniBsGXgSig=
X-Google-Smtp-Source: ABdhPJxhiucWCZVrPLtirsBh22sCuEuvg2mj2li7yFkswOrWPRgYpoxawEn7TnQ77vZLNFT1tMQoQA==
X-Received: by 2002:a17:906:d0c1:: with SMTP id bq1mr6871073ejb.202.1610040455793;
        Thu, 07 Jan 2021 09:27:35 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id y14sm2643351eju.115.2021.01.07.09.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:27:35 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 00/10] Configuring congestion watermarks on ocelot switch using devlink-sb
Date:   Thu,  7 Jan 2021 19:27:16 +0200
Message-Id: <20210107172726.2420292-1-olteanv@gmail.com>
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

 drivers/net/dsa/ocelot/felix.c             | 210 +++--
 drivers/net/dsa/ocelot/felix.h             |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  23 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  20 +-
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot.c         |  18 +-
 drivers/net/ethernet/mscc/ocelot.h         |   8 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c | 885 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c     | 282 ++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  47 +-
 include/net/dsa.h                          |  34 +
 include/soc/mscc/ocelot.h                  |  54 +-
 include/soc/mscc/ocelot_qsys.h             |   7 +-
 net/dsa/dsa2.c                             | 174 +++-
 14 files changed, 1672 insertions(+), 95 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_devlink.c

-- 
2.25.1

