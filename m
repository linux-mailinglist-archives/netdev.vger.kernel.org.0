Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6D32845D2
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgJFGMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:12 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C280BC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:12 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x16so7412128pgj.3
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W5Cxnjm27rVFohF1NeLCpuB94XlqPyxIcIP+NJKmVQ8=;
        b=vcce6IrgugqUhUWqbFKYoXIbNCB3BJnjyaH8jUpEAy3dBos0UdKlQEpEe/2LLWiX2h
         21HvfwMsMLPpuqSsOryxPxuF8G2SYYaw1xH1Nd665McemdLxodmKKhb0c0VsBt2gJqHQ
         isuS4EqRrYKcDGOMPtBBP4B+MBWWI4eJp6NMSxR0wXIjDaH3BLaNU4HGkyWWZU8QrSbG
         OuG5Q3r4UoqZPBoiDMxPZJv8ysYdO2gu4rDrv4IewjRIJVF/0iU8GvGoXXAGiCjkN3iO
         A6w2+0eGLFKd66GnBVaScIBGjXUS93ZEXhQjsCFwxci2y5KY8n0HS6Wb74Un9M6YCvut
         L7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W5Cxnjm27rVFohF1NeLCpuB94XlqPyxIcIP+NJKmVQ8=;
        b=iqwlDlC3ujx9anJxLvljPttQZUhhNI3FeL1vLCcMgN6Vy5J2E4adqIqC/YMnekNHcM
         +bj7gH2G4LCZRHkc40b4bM6USmJb/f7etofbmzUJpRGTFbHZsuMDASSKdA+fGuicd92F
         3VS6R8uCP1HY8AuFuYg1SmzYTjb0m+zMpb16MVorzgQMtCHpZBttMycTJyk+OjuYRaJG
         rmK3+JTNfHDKLeIdk0tV8+XkfG/83x9kEDuoHT/WqCk2DgOtBMWSdcE/nASoW/Gt+w0t
         b1fRERQOeALmzOZpgvvK1YMhWkwugfiuQw9hrT8Ghf5jRzqLiEaiyQ0Xo7sD/I2UgPiu
         LXOw==
X-Gm-Message-State: AOAM5303nPHUcDY7298a+I0Lr0VyeInRXldnq2F5vCzn+TUoS+Xn8kgI
        RbdKoFdgdZKoi0cukBpVorA=
X-Google-Smtp-Source: ABdhPJzoIKRbYJ5DMNQe5Jd7y30ixrjrZBZ10oYhrsyglRauGxv8utaaBQyKHT7rgOwwFXlLM6K5Xg==
X-Received: by 2002:aa7:9201:0:b029:13e:d13d:a10c with SMTP id 1-20020aa792010000b029013ed13da10cmr2885202pfo.40.1601964732232;
        Mon, 05 Oct 2020 23:12:12 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:11 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: [next-next v3 00/10] drivers: net: convert tasklets to use new
Date:   Tue,  6 Oct 2020 11:41:49 +0530
Message-Id: <20201006061159.292340-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
the remaining drivers in net/ to use the new tasklet_setup() API

Allen Pais (10):
  net: arcnet: convert tasklets to use new tasklet_setup() API
  net: caif: convert tasklets to use new tasklet_setup() API
  net: ifb: convert tasklets to use new tasklet_setup() API
  net: ppp: convert tasklets to use new tasklet_setup() API
  net: cdc_ncm: convert tasklets to use new tasklet_setup() API
  net: hso: convert tasklets to use new tasklet_setup() API
  net: lan78xx: convert tasklets to use new tasklet_setup() API
  net: pegasus: convert tasklets to use new tasklet_setup() API
  net: r8152: convert tasklets to use new tasklet_setup() API
  net: rtl8150: convert tasklets to use new tasklet_setup() API

 drivers/net/arcnet/arcnet.c    |  7 +++----
 drivers/net/caif/caif_virtio.c |  8 +++-----
 drivers/net/ifb.c              |  7 +++----
 drivers/net/ppp/ppp_async.c    |  8 ++++----
 drivers/net/ppp/ppp_synctty.c  |  8 ++++----
 drivers/net/usb/cdc_ncm.c      |  8 ++++----
 drivers/net/usb/hso.c          | 10 +++++-----
 drivers/net/usb/lan78xx.c      |  6 +++---
 drivers/net/usb/pegasus.c      |  6 +++---
 drivers/net/usb/r8152.c        |  8 +++-----
 drivers/net/usb/rtl8150.c      |  6 +++---
 11 files changed, 38 insertions(+), 44 deletions(-)

-- 
2.25.1

