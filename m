Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21FE2A8B26
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgKFAMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbgKFAMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:31 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDD2C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:31 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id u4so2526227pgr.9
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=d+eT+etP9Zk0uRf1auXDGRbc6RMDXBHVHiQkd7bBHII=;
        b=IbSp29LRaQf58KSgx18cDrA4I9Y/q3ndQ6mI9PcCDtc9ZETGyJYDldO6JUpzhH+Phq
         zO6p3H63Rx/oKiSWV2p/NkxP6ewgpygUovPu8/7rs5pn3subXrnmY+0g4ul3+z13rxD8
         1VTu5+3Uo7JZfqpPIlqKXY1+ZO88KCLpPUtNi5WozM57WbLNezKteKt/N1Hznmv0Djm7
         /N+wpeVyI2dGGx8lDIQSkNmjeh6qSlRGBKbIpM8J/7XkYc3c6HOc7HEkorD6CpYiYSIX
         g6kgGaTOoXnGXB+GFYXYtAR4TREH88o7iPgrN9vsQ8/+qUIJTwYKNh+IcefJJ+44WUCY
         yRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d+eT+etP9Zk0uRf1auXDGRbc6RMDXBHVHiQkd7bBHII=;
        b=f1KMx6nPpek9du2D+S4x7dz0CflSqLqNpqlZ93Ba+F/cQOp7tnkmg0R/4nA7FdI5Dw
         vXbdTnn6aVzlr2K/ERBlwt5lqimM66PITC4wZr/BBi2DgUp8lqudmJbGfb2Jeh3TsJYY
         LQE1PUwSsaCP8k7Wb63fqfyqcBmIgNipeGJaZmLRYrt0Q8niZyRgWgyiqSeSFaiGtRZR
         WGatXFagAFl3EgK5vXyT57rBAQo3UOXBHmrvcccTQjUG2fqpuJg2YhKFekgTfT00jlxs
         zatzXKDyTV5gjcRIz89artNIXSceFpbwsAFu2G1McKBI3AQK5iZRrOHrKO7GHAzpDOhQ
         kR+w==
X-Gm-Message-State: AOAM530tnCWSYwD/Nv/Gvy/MwCpXp94NwG5hyHx3EUHzO7qBmZDRPJ4e
        I+J4vT0cdFYldQ8wNUCMSlBhmPMOatqJeQ==
X-Google-Smtp-Source: ABdhPJy3R5aHSII+0y2KqVQ9JN7AE1489ySLcmJ3Nhr1AAnxXYuK1bMEN2RiMD1ksXBna0QuN7rolg==
X-Received: by 2002:a17:90a:5908:: with SMTP id k8mr4809063pji.222.1604621550037;
        Thu, 05 Nov 2020 16:12:30 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:29 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/8] ionic updates
Date:   Thu,  5 Nov 2020 16:12:12 -0800
Message-Id: <20201106001220.68130-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These updates are a bit of code cleaning and a minor
bit of performance tweaking.

v2: added void cast on call to ionic_lif_quiesce()
    lowered batching threshold
    added patch to flatten calls to ionic_lif_rx_mode
    added patch to change from_ndo to can_sleep

Shannon Nelson (8):
  ionic: start queues before announcing link up
  ionic: check for link after netdev registration
  ionic: add lif quiesce
  ionic: batch rx buffer refilling
  ionic: use mc sync for multicast filters
  ionic: flatten calls to ionic_lif_rx_mode
  ionic: change set_rx_mode from_ndo to can_sleep
  ionic: useful names for booleans

 .../net/ethernet/pensando/ionic/ionic_dev.c   |   2 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 113 ++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  18 +--
 5 files changed, 85 insertions(+), 58 deletions(-)

-- 
2.17.1

