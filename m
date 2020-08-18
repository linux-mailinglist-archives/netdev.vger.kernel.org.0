Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7553F248EDF
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgHRToY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRToX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66193C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:23 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e2so14673pjm.3
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6o2fokmwthlVE1RGD9/QtSrulCn7PrtV66hoPmnGMhk=;
        b=wA8ZQjO+XCCtGb3b5/koj43t8onRK5XLZ5cxOzI6j8PZXyPUgWT0toSA3cW8VA2LNr
         1vE/IEAHhAsezI4KBA79A/UWIfhDm5aR+HH0buCzGO/aWh4tnZqnLvLSld/BgxT7paMl
         tCmhr+cKeRqGuunn8I0rRUA98ZEuO4CGt6GTHw51xBPZAH/ilsAm/dXx3BoySi+5Ccch
         JY6y7ACdADhEvjU9Qmxn9UJ96c7V2Odd6S+8iiL8eRtpksMSvVGHnU8Ufqfu8WvF660M
         BrhrpJt+yyezw1gfFBkeYnxBYqSsKgPGwWCkFZDA1nShX4EZIaKKQxqVTEi0/CHOeg++
         P2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6o2fokmwthlVE1RGD9/QtSrulCn7PrtV66hoPmnGMhk=;
        b=KsmCThiuIkADhTiKKJKCBDe8wVusjZao1jBNKcfJHh0naDwBhN4ToyfACtnnsSzX0C
         53ufJFDjPIH7eO0nsPLhesAXTqrHnN7xBOuy8a3PkrjDLo+RJmkvc59H7L9ODXn7MX2W
         SGFDqRN4LbB/+f8UX6ySokCQKwAShYSfyRziMzuIQa7fLpBh70/Fc44OXnCnoaw6+GxF
         hW4XdJ+kRd9SAFmOnCexq+cD+Knp02wIXYJOwgY8aHNEMrWHyARBqDvAq6Ww5VhPnqqw
         7fQdkE4b/Me7Bb0+Rmk0lzy7pMc7+aPvTMmv8I9vUmQM+iCp6uknCMmfl+y/UWKfVBau
         xivg==
X-Gm-Message-State: AOAM5307QPBGKrbttscQn216AT+w2C5Fsk/YsXJNlGKIKKeMpISuzQ8P
        lRYAcu1/Dyz85qEzTo5qoOfdwqwWcwXSKac7H0ylgixWplNPBVpVRtrt2yg/e8DQTFILnntyQzk
        4GUTGs3NmBD7YxZ4R/NmpGSwoAZZ/4eF45VR15yzEJqM8FBqb4rWs40qQVDjzdfPX2Z1xdA2A
X-Google-Smtp-Source: ABdhPJxJZlr2B0mqGQCykB/Z3lj/0efolJCJzwUC8N9MwRcI1w8Am4wLc1E4bsGtx2WbbYbleKNSwK6nkvChEiUf
X-Received: by 2002:a62:f843:: with SMTP id c3mr16380277pfm.247.1597779861783;
 Tue, 18 Aug 2020 12:44:21 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:43:59 -0700
Message-Id: <20200818194417.2003932-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 00/18] GVE Driver v1.1.0 Features.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series updates the GVE driver to v1.1.0 which broadly includes:
- introducing "raw adressing" mode, which allows the driver avoid copies in
  the guest.
- increased stats coverage.
- batching AdminQueue commands to the device.

Catherine Sullivan (8):
  gve: Register netdev earlier
  gve: Add support for dma_mask register
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path
  gve: Add netif_set_xps_queue call
  gve: Add rx buffer pagecnt bias.
  gve: Move the irq db indexes out of the ntfy block struct

David Awogbemila (3):
  gve: Enable Link Speed Reporting in the driver.
  gve: Also WARN for skb index equals num_queues.
  gve: Bump version to 1.1.0.

Kuo Zhao (3):
  gve: Get and set Rx copybreak via ethtool
  gve: Add stats for gve.
  gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.

Patricio Noyola (1):
  gve: Use link status register to report link status

Sagi Shahar (1):
  gve: Batch AQ commands for creating and destroying queues.

Yangchun Fu (2):
  gve: Prefetch packet pages and packet descriptors.
  gve: Switch to use napi_complete_done

 drivers/net/ethernet/google/gve/gve.h         | 171 +++++--
 drivers/net/ethernet/google/gve/gve_adminq.c  | 372 +++++++++++++--
 drivers/net/ethernet/google/gve/gve_adminq.h  |  77 +++-
 drivers/net/ethernet/google/gve/gve_desc.h    |  18 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 366 +++++++++++++--
 drivers/net/ethernet/google/gve/gve_main.c    | 424 +++++++++++++-----
 .../net/ethernet/google/gve/gve_register.h    |   4 +-
 drivers/net/ethernet/google/gve/gve_rx.c      | 409 +++++++++++++----
 drivers/net/ethernet/google/gve/gve_tx.c      | 215 +++++++--
 9 files changed, 1700 insertions(+), 356 deletions(-)

-- 
2.28.0.220.ged08abb693-goog

