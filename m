Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B0B1C2FF0
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgECWVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729170AbgECWVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:21:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95F6C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:21:43 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x4so6268959wmj.1
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uLMzoy9UrAxDrpWW7XQCHDdN1eDM7/mxOQlqMm3iQds=;
        b=gfPB8U+M8dUXB+wOJxn2XChYavpVAQB3EVUoOKlM0C+Y7y9YxOCGNccpxNOnCQb9O7
         OaaWpHbPR4TDmXDxis6/GEkhmNgUigSOMl0H1jLXgD3FzqlVUGLOyYkB6XqMNEL0/hPS
         9m6/yEPgaELphWpgf5wwWAIK8pX3Pp5GtDZp/Coh1AToWFTCOewe/pYQTy3HWgoEBEeO
         yL+jSiL7+ccvU8ztt6DORlxto2Gifv8NlXss+xWjdh8198jeyaw0yidXKpHLWdvVABHn
         76fpcJ8Vp9eyOJV6+0JXnZ8x6sYx2mLxyMhFHEK+6kaYFwTSeZDZEQJiMmIVuNCSJteb
         KU4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uLMzoy9UrAxDrpWW7XQCHDdN1eDM7/mxOQlqMm3iQds=;
        b=iREwSead7TEitymek7hkNZ0k99O6Z4yPNq73f2YoNIMn2vxnYE7TMrdf+UmQMC2JFG
         0F58u61u8psd4oXxozSEnN8ymtmTy8uMUhNxrqBHwhJVnlewKdAgZyUfThOJVle/JYQR
         W7COVhx1Tq+ffoqPGjAkG3RKNrksOwrXQ/2XEceN1YGYzkb9ZwHI/ldmuc8fmJBhc08v
         Gu8g8/ndHM5UYvqb/Za9Ug5rK+j/9kDuSxrxNLdzlO/8sfrT4RVbOd1ALKNVJ2tNrHcQ
         ZXP7z8VyYrP+/tWszqqRa5VMhRNwxtoRItGRQ6xPpGJR4mZsLcQS38HrsWvrlmyxaC58
         lfig==
X-Gm-Message-State: AGi0Puasa52Lkw0zCmbPLzPxGppTi85c7vWAPuAyavBYqK8+xTY8nUE3
        r/T54E76Qp8QYOjVYSRhWKtdygizh14=
X-Google-Smtp-Source: APiQypLSYYBYO0r1O+jUm1zaiLnjUHeZBoxMHvQa5R8D7TF1Nbl4Ce5eJchkt5st7pHwOJNCRwHaog==
X-Received: by 2002:a05:600c:2284:: with SMTP id 4mr10675020wmf.97.1588544502343;
        Sun, 03 May 2020 15:21:42 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i19sm15405847wrb.16.2020.05.03.15.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 15:21:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
Subject: [PATCH net 0/2] FDB fixes for Felix and Ocelot switches
Date:   Mon,  4 May 2020 01:20:25 +0300
Message-Id: <20200503222027.12991-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series fixes the following problems:
- Dynamically learnt addresses never expiring (neither for Ocelot nor
  for Felix)
- Half of the FDB not visible in 'bridge fdb show' (for Felix only)

Vladimir Oltean (2):
  net: dsa: ocelot: the MAC table on Felix is twice as large
  net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds,
    not ms

 drivers/net/dsa/ocelot/felix.c          |  1 +
 drivers/net/dsa/ocelot/felix.h          |  1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c  |  1 +
 drivers/net/ethernet/mscc/ocelot.c      | 17 +++++++++++------
 drivers/net/ethernet/mscc/ocelot_regs.c |  1 +
 include/soc/mscc/ocelot.h               |  1 +
 6 files changed, 16 insertions(+), 6 deletions(-)

-- 
2.17.1

