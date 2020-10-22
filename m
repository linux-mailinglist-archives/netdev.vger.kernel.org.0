Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD4B2967C0
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 01:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373634AbgJVXzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 19:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373630AbgJVXzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 19:55:52 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E82BC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 16:55:52 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w21so2327180pfc.7
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 16:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=H+TIErdCQO6oIlSaxfVn2UECuenKRHxHiZaCeW5PpxM=;
        b=x+JHabiRdjjBVfNfTtHQMUWQAq7eQfeW4n41dfsHvnzl7MGITbLiZe7VsR4lf+9rWW
         LRBnBIujKLF1dHRxvgrYL93LGKcIYaEp7dOAcnZKHJeTyZMpl0yi6c5TbqaQKNRAE29B
         TVQOf3TeHieGQuYUV6NIrLgKbo1QaLtGbOTvZkcXviSRE3rTJPObx3XwSWo79GnuwCuM
         U6Ycup1bf+3HAuyGV8EwhFgkthpKXrCT5tBttwQJY2jjffqspEZ8URKazcOQUNhaw02b
         Xgs4BjfDJLxphbRriSaCxin6DTmM9s31gWMxn3NkjDCBEfzR8e3laBUqI9cMXHL6CHkY
         5lKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H+TIErdCQO6oIlSaxfVn2UECuenKRHxHiZaCeW5PpxM=;
        b=bB0Mp7Bo6JEFemvcQVNNguIS9yDcUahCA5NeICCoUDCazz4vbZRs6Ur5yJjAvtSwaM
         VhZVcqtQp9JfoE0X0OfYYNPYyPN/XlPXRCyMancttMUj3trRtkUBlu+LD4BV3ygDO2ZW
         E3GwYcqp+qc0G7dfeg4GiWA5WlZjNJbeMEf13XMZVmDn5YOlfZPOkQgU0fxk+B0iPuNE
         vrQDH5nfggc4PnOI887aYLJZS/97nYqHOm9EkBfiGXzOilnbnpQe9VFQf8UTnsRlHOva
         ZcpXEsAe4pKW7FWfWJWv3CZh/pPDfx0B6J/BUqkXJKj3mD3gCP9QXWef+9gFSUtvJ75k
         hkIA==
X-Gm-Message-State: AOAM531O4Dnv/9baQLeSKZr3TLCtnwB8R9o4e+hZszfLaipRoRUEWviO
        DqAgGOoUDqtoTZfyUHSTvRLb4Jx7/Ez66Q==
X-Google-Smtp-Source: ABdhPJyD3BIwAOJYPeUHsMVEAwmnfVLKnR2GnghKwcsOhEblWpD8HcT2UivtrOoYTXbCVA1A5ecyWg==
X-Received: by 2002:a17:90b:4409:: with SMTP id hx9mr2591414pjb.54.1603410951603;
        Thu, 22 Oct 2020 16:55:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id v3sm3167244pfu.165.2020.10.22.16.55.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 16:55:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 0/3] ionic: memory usage fixes
Date:   Thu, 22 Oct 2020 16:55:28 -0700
Message-Id: <20201022235531.65956-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset addresses some memory leaks and incorrect
io reads.

Shannon Nelson (3):
  ionic: clean up sparse complaints
  ionic: no rx flush in deinit
  ionic: fix mem leak in rx_empty

 .../net/ethernet/pensando/ionic/ionic_dev.c   |  4 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_fw.c    |  6 +--
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 29 ++++++------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  4 +-
 .../net/ethernet/pensando/ionic/ionic_stats.h |  2 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 47 +++++++------------
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |  1 -
 8 files changed, 40 insertions(+), 55 deletions(-)

-- 
2.17.1

