Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0265626ABDD
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgIOS2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbgIOSXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:23:31 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA780C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:50 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id w1so4027359edr.3
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gT6Gz5m6moOODWK8Kt5bgtrqD1oKBeDUi/nGQD03HVs=;
        b=EamPb4tXaSPykhnY4qcDQgyvL/Y2r3lzZ32QvZbb9X2ZpFStNGHdezzFSGlsh6+lEr
         XOct4J+qFw40gW0+yEUrIGcyPpkLC2Z0YdpaOqRMoOrwPpz9ZYTRkzG9Sy+qaG8HGXE0
         tG/zHwnLr+3MHv5AS9hYD6lLxYVG5N2X9UIPaBtfBJSQlppuYLqRZWO6NCENOZhb4pxA
         JghwJEf+Qw3gJvQw+gh7TxPFNW3FqC5wWGl8JH3AWU2XFW0f5jvntHINGIufkSNPgPIm
         OuMrGX87ppBi1tyPB19EA5+K62w+qVbXzyBAeQR4ln1WMdbPYIeCqOjmvCs2SCEy8BI4
         Vxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gT6Gz5m6moOODWK8Kt5bgtrqD1oKBeDUi/nGQD03HVs=;
        b=U2dQ36BaD4/gvkOf66gHGsHWQP9kmoh7CTM3ySa3ajOfAzLSOtEyQmA3Z9bF5gGVSE
         Taezjntz+JDOmFfLrVoYLHaxfuFntzj+5YFjlxMrXvV91vOFcqQK2cG3oUjwLnp7pS8k
         QWLO5idtSK3u2iD9/5hTflX0+0je7runv7AQql0R58rF2v3ttY07X5Jkw0XrkjghEqj3
         6HxQwckq8LDvTMs5RIYMkykwO5Al65ZH/9Tjex0gDBTqLz51S/V2HlZ0pA1qX1wZC5p5
         qFEiZxJMAWrUS6EHq0n6yIqATt2GvUrr4HVsTxOyldSw8gynnYL/dapERg2/Wme6AUxQ
         cpXg==
X-Gm-Message-State: AOAM530ZfI/kELRKgPnrysftg9jCQnFe1jWUrHhMUqd6SuLZkx6KTkZ0
        9MsPfw340S693Sb4L11o6XU=
X-Google-Smtp-Source: ABdhPJxK64hiHsY/CZhKK3mKSgbsrlvKtr7fbXxgFgzbzf3nSbpg4yjNdOGn735zK9395CgBXkWiPQ==
X-Received: by 2002:a05:6402:1851:: with SMTP id v17mr23395480edy.46.1600194169337;
        Tue, 15 Sep 2020 11:22:49 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q11sm11860481eds.16.2020.09.15.11.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:22:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 0/7] Bugfixes in Microsemi Ocelot switch driver
Date:   Tue, 15 Sep 2020 21:22:22 +0300
Message-Id: <20200915182229.69529-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a series of 7 assorted patches for "net", on the drivers for the
VSC7514 MIPS switch (Ocelot-1), the VSC9953 PowerPC (Seville), and a few
more that are common to all supported devices since they are in the
common library portion.

Vladimir Oltean (7):
  net: mscc: ocelot: fix race condition with TX timestamping
  net: mscc: ocelot: add locking for the port TX timestamp ID
  net: dsa: seville: fix buffer size of the queue system
  net: mscc: ocelot: check for errors on memory allocation of ports
  net: mscc: ocelot: error checking when calling ocelot_init()
  net: mscc: ocelot: refactor ports parsing code into a dedicated
    function
  net: mscc: ocelot: unregister net devices on unbind

 drivers/net/dsa/ocelot/felix.c             |   5 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   2 +-
 drivers/net/ethernet/mscc/ocelot.c         |  13 +-
 drivers/net/ethernet/mscc/ocelot_net.c     |  12 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 234 ++++++++++++---------
 include/soc/mscc/ocelot.h                  |   1 +
 net/dsa/tag_ocelot.c                       |  11 +-
 7 files changed, 168 insertions(+), 110 deletions(-)

-- 
2.25.1

