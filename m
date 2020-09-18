Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0454326EA40
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgIRBHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIRBHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:07:37 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9CAC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:36 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id c8so4410934edv.5
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TI/8PU6Tkj4cU+ivZkFQA2uUaQTeF49GKTEA6KOTySQ=;
        b=DwArsyZBQoSigofgOOvnJgxT4PIf/jGC6NFU78UeEZNGhWXGqMLBN21GY/UFqb6tv7
         HqXEXl9dRfK30ZTtJvBzlT+QYcGRzOty1Vzv+XxmuXot/Fht3K8x353cYTVplTt/N82Y
         mL5ENK818GYHhnZW+uB5HJeydeY0w51aZd61lVjr9mpwn8Xwn79qaC0BPniijNgt0d4m
         at+dGdoxuxNzpX6kQk6VZ0vh6YTi3xxNEJIFpsYkTgAn6DxxZVAPHKAI3K0Bwu39Of6x
         ZPSfMPExP56d0JO59SUpimDe0rIV5XK/Fa6fDPrz+gIO5Alr5WsfwAmWhdgvEHKyq/m2
         pguA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TI/8PU6Tkj4cU+ivZkFQA2uUaQTeF49GKTEA6KOTySQ=;
        b=op6MY8Ita/uvi+isprwopIE0wa+g9DwFD+TjUmfLKS+0IHNI4pSr5URRVODmPWrPxU
         w7qgADZfWJr1kRGJfkbgpoCOLudrYCjMBbfPhWCBar101r1de/TopgXC1X7nE2MBA/J6
         t4aFcgz+3EJUmlJQxo8vzj8OATiwIHsh6xe1PR22jQzu4P67vFReYPIZIMTOV/NcaiSn
         un08QxG6MKNDbmjYwGQxMI78CU4HlHgJqMR3z0X8lzHQEKYaZhc5PwOPIZzAZbuUbwlz
         8crWDhBxSmkWRoTQmlmNtjOA7b3OmBrpyT/KnvP6zcwHDxNsbvf6R5Dc2fRNv3S5j+nz
         rwtw==
X-Gm-Message-State: AOAM530InSvFN1dlcKM2gYdPJvjogsso2e74JjXNq9XGvbvVoVdsRj/j
        lMSGPTaRZvRtD58LYiBeB68=
X-Google-Smtp-Source: ABdhPJw0O668bG2XoxIEZ1QLh3B921SIgYlBsExqfNkKc0UXZCTy8FPDRAdnsbt5iZpKusCsWn11Xg==
X-Received: by 2002:aa7:d7ca:: with SMTP id e10mr34900837eds.191.1600391255555;
        Thu, 17 Sep 2020 18:07:35 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g20sm1068591ejx.12.2020.09.17.18.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:07:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net 0/8] Bugfixes in Microsemi Ocelot switch driver
Date:   Fri, 18 Sep 2020 04:07:22 +0300
Message-Id: <20200918010730.2911234-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a series of 8 assorted patches for "net", on the drivers for the
VSC7514 MIPS switch (Ocelot-1), the VSC9953 PowerPC (Seville), and a few
more that are common to all supported devices since they are in the
common library portion.

Vladimir Oltean (8):
  net: mscc: ocelot: fix race condition with TX timestamping
  net: mscc: ocelot: add locking for the port TX timestamp ID
  net: dsa: seville: fix buffer size of the queue system
  net: mscc: ocelot: check for errors on memory allocation of ports
  net: mscc: ocelot: error checking when calling ocelot_init()
  net: mscc: ocelot: refactor ports parsing code into a dedicated
    function
  net: mscc: ocelot: unregister net devices on unbind
  net: mscc: ocelot: deinitialize only initialized ports

 drivers/net/dsa/ocelot/felix.c             |   8 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   2 +-
 drivers/net/ethernet/mscc/ocelot.c         |  24 ++-
 drivers/net/ethernet/mscc/ocelot_net.c     |  12 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 233 ++++++++++++---------
 include/soc/mscc/ocelot.h                  |   2 +
 net/dsa/tag_ocelot.c                       |  11 +-
 7 files changed, 175 insertions(+), 117 deletions(-)

-- 
2.25.1

