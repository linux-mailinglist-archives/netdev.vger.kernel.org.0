Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F17A7176DE0
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCCEQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:16:01 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36054 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgCCEQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:16:01 -0500
Received: by mail-pg1-f195.google.com with SMTP id d9so899670pgu.3
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GeM6rOYFrMmwjH/HmS6eKKsz7s0Iviy3rznsJWzBjSo=;
        b=3v07VGubr/pBEzoLG4+GCS6i8BrUyn12sa9cHudcp1gsgeSkNJFXynSIkLiUbA7l2l
         +zrwg7j5opCkO7Lw/VX8pcTzgHQUVMF3tvT38oMi2prKzCkl1cVt1XKcMPPI/9TwExtm
         nSjEpxVKnHsEZjoueyQb9JOAeBRYnEZpW5S1E1+L4UM8YpDlV5Z8YPEWD3PrMc//8gkt
         Lt3XL3yXRxWWv+af8M4hxhdLp1/ASqugWjESo/Sku4FvzmNa23tzpJRZcFzjKftTpdLk
         NrERWlpLEW8dpxOFcrFJhvmv409to8lPWwL5OBOIw1GLBOPMAml2mdpcP1ZIQpybFU7j
         o/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GeM6rOYFrMmwjH/HmS6eKKsz7s0Iviy3rznsJWzBjSo=;
        b=fMDtLJBJ1F/RkL4rFezPgHT1aAU71hNq6t0lemS+5ZmIVvN3kSLQBXhbtsKSjG7WBn
         cb4dDWl5PauXLBe4yOMBZE7XSTkU/lcifrtimS+avvDdwR1zbG9SMEPLYkse439QEqJb
         B7i1UuzJyWRShpdKM0j4Na9pobEnyDfzFsheQd1cmUSAKOx8jeq1+P1iz6MeAZY/skF5
         A8O3E/GayouIJqTDuRl9sVVWao5xI+mhdVv/uWVOnzyai+9RQPSghWVn6SZClrSxW28P
         tI7xH/GvyRHDxuW95ppBgfZXvWvs6tc43YBmGJRxoc2rdZTXUUKI1oi9lNEL+/I65vye
         fLSQ==
X-Gm-Message-State: ANhLgQ2pnQOnDuqUnE1BN1nuk/SgzX76VJkMK77M747v8lNlO19pVCxL
        RPMeiSqz3VcilklX0kKCWPRpWg91+Nk=
X-Google-Smtp-Source: ADFU+vvG0uH1mlzcgOw1WoAXKwbhjcCEKCc04tgr7iolIMTelu9wYnweXLKfNzZZzA96YUyGEAC8sA==
X-Received: by 2002:a63:d60c:: with SMTP id q12mr2264151pgg.419.1583208960273;
        Mon, 02 Mar 2020 20:16:00 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t7sm396682pjy.1.2020.03.02.20.15.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:15:59 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/8] ionic updates
Date:   Mon,  2 Mar 2020 20:15:37 -0800
Message-Id: <20200303041545.1611-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a set of small updates for the Pensando ionic driver, some
from internal work, some a result of mailing list discussions.

Shannon Nelson (8):
  ionic: keep ionic dev on lif init fail
  ionic: remove pragma packed
  ionic: improve irq numa locality
  ionic: clean up bitflag usage
  ionic: support ethtool rxhash disable
  ionic: print pci bus lane info
  ionic: add support for device id 0x1004
  ionic: drop ethtool driver version

 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 10 +++++
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 25 +++++------
 .../net/ethernet/pensando/ionic/ionic_if.h    | 38 ++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 43 ++++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 15 +++----
 .../net/ethernet/pensando/ionic/ionic_main.c  |  7 ++-
 .../net/ethernet/pensando/ionic/ionic_stats.c | 20 ++++-----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  4 +-
 9 files changed, 87 insertions(+), 77 deletions(-)

-- 
2.17.1

