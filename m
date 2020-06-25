Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B830B20A1CF
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405797AbgFYPXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:23:42 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D105C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:42 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n24so6374801ejd.0
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+kj2acuuA2lCGz+pFr4q1ldUeYjDP04ANATQOwchg2A=;
        b=CwLQciYWwonhiJKJ/jf/OGUP2g/mfJPfPiP45qI2lKj1DvduGt69nF5UyN3/p0XVQL
         zgqossFiauiqdWBo7NATeEWDILh70yybx3P6NXuV5MQ6K2kHtL7iwMo68jSl3VS8nsyd
         Bpi6NKGnJ+c9x7W5kLuBR71vWCDpM1NaWJZzrfvNmJn3Npn8VWU33fGWUMDBliD67FbC
         YFf8TX3tnD11+0t+I53JhA+DPnTle+NQoszQEBDLN7exYErHiqgJi28OtBfA5PZDAuiy
         Ms9oAR03tfkKMoRvGbD0nJqdcnsTWBZ6Sj6pnsranLogPJEW+zZXxsek0SWyCF4OoKMk
         J6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+kj2acuuA2lCGz+pFr4q1ldUeYjDP04ANATQOwchg2A=;
        b=TFnr9gte3n1VfRd70j6npYvmP1hszfeK7n/vTXogJOk2TkluqQRG62fiIi9hLMiUll
         ffju7z/6Fg71B8NXiWZHL4VOqFhTDnOLT40LOOZXKbxCZXaT24L09FdBLLgCSjGj1Jh1
         2cP/vQ4KjsbvNniT9P5ntIByUFOAP6o0TRSSf+IJjO52h+/UsYm2iD4tysuMLwB65XAd
         cc2y8MKdW1sC6idrioJYtVLHF9BpHmR2VU6TjhzVkrMGgYHgFHwa6m9datIcq7ePdAVy
         9wOrK13MMCs91K3sgZawE0nv43MqP/cz4hHBZkMpCHSEn8OsXj+oZX7fSLKW4VRY9tdS
         2a9g==
X-Gm-Message-State: AOAM5302Vwh89WSXEDxsjqCHZfSweOkNmhzkwtJ3bhpgBisX2tItfVsO
        ny0H7U/fb7QT7JyO1/6K4+g=
X-Google-Smtp-Source: ABdhPJwGiJoolfhSScupaqzG89djManyxeOKsQ8+EcYPGXu2fZ05X8c9Wo7YoCiDV54OLx6zmyF9lg==
X-Received: by 2002:a17:906:3945:: with SMTP id g5mr21738748eje.549.1593098620726;
        Thu, 25 Jun 2020 08:23:40 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o17sm9102898ejb.105.2020.06.25.08.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:23:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH net-next 0/7] PHYLINK integration improvements for Felix DSA driver
Date:   Thu, 25 Jun 2020 18:23:24 +0300
Message-Id: <20200625152331.3784018-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is an overhaul of the Felix switch driver's PHYLINK operations.
Some of the patches (7/7) were done at the request of Russell King
(https://patchwork.kernel.org/cover/11386917/), while others are simply
cleanup. There is also one new feature being added: half-duplex for
10/100/1000 link speeds (2/7).

Vladimir Oltean (7):
  net: dsa: felix: stop writing to read-only fields in MII_BMCR
  net: dsa: felix: support half-duplex link modes
  net: dsa: felix: unconditionally configure MAC speed to 1000Mbps
  net: dsa: felix: set proper pause frame timers based on link speed
  net: dsa: felix: delete .phylink_mac_an_restart code
  net: dsa: felix: disable in-band AN in MII_BMCR without reset
  net: dsa: felix: use resolved link config in mac_link_up()

 drivers/net/dsa/ocelot/felix.c         | 108 +++++----
 drivers/net/dsa/ocelot/felix.h         |  11 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 298 ++++++++++++-------------
 include/linux/fsl/enetc_mdio.h         |   1 +
 4 files changed, 213 insertions(+), 205 deletions(-)

-- 
2.25.1

