Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F626E277D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407648AbfJXAtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:49:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40266 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389995AbfJXAtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 20:49:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id 15so7787369pgt.7
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 17:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=rc9aq54PsfKlL89fVj66P8QmbygDQpTH8opaPIVrOTM=;
        b=MlEpXRaMg63BOAMmYTU0VfE+4yAZ24DaK87yLJuTn0XdkkQvnI7aUdFSnbHM6Llatp
         ahi/kMPDXFZNx49umKVxilYM4ehuTQZiVMI35R7FCCnaV+HJbdclCXSlJoCu0GNiMzVX
         CjoZOYvSz+z7UkrAU9u0j2soJE/48sNbJA2K5CtUPiokLJBS+pykk1Dz3y6/s3z1FQ+/
         35lb7MohlyC56retY6MAjV4WSKqJvF+dcxSsHtv16Lj07qz/9UZkltC1wbwpVv8I7Lnc
         +3rmaQxKpwJTHMSSdd4YCUOgElFFhhCpNnDMx8l3agDgxPDByUJJv9/tEMRnCla5ZBXb
         ffPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rc9aq54PsfKlL89fVj66P8QmbygDQpTH8opaPIVrOTM=;
        b=euzRgcjL3lQOisLFSkfl4AwbF0MTWmSHGKJP4gqQPes9CNgG6zHa4fASpTzM6kB20h
         /MvIOXNGoB6l1hlyROw6kc6ARlCVO7oJ1e64lw+EM46z/9/p2x5Bng5VH0aigJIhXbmU
         0AXLA+Hf/Pu1d7ar3MRkFtsoZ3kmKHzH5JxvSaolKOPyD7VfIzLCo6vOa788ZqyH7Qtr
         GQr9mqOiOMzpG9E9ZbI9Qn1Ovkfynt+4UD9cgMmdmVMD+ICrY2cDvgJqcBBvW3WHnOP6
         YztzDNubRPhvoWG65RMQYMpSdsy/ayPLrQSlZyADmrFP3rAIOscOCZP4ZdsaxswNfqqD
         xKIw==
X-Gm-Message-State: APjAAAU/Vi0CGvIPx2YCn5eMY2DNGmEN2HBx+Jbh8SJyULe1A+v6HQ/A
        ISwXumleaFdJiQZ+qJOZnAbhCD3poFeKqg==
X-Google-Smtp-Source: APXvYqwQD/GgKaHXQtP56auNcRZqbtyAn5s/REuzBQYbP/D9XoJwU+YbhUS2Fo43G5ipbnYSmJdlxw==
X-Received: by 2002:a63:3fce:: with SMTP id m197mr13223631pga.328.1571878154640;
        Wed, 23 Oct 2019 17:49:14 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b3sm24696440pfd.125.2019.10.23.17.49.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 17:49:14 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/6] ionic updates
Date:   Wed, 23 Oct 2019 17:48:54 -0700
Message-Id: <20191024004900.6561-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few of the driver updates we've been working on internally.
These clean up a few mismatched struct comments, add checking for dead
firmware, fix an initialization bug, and change the Rx buffer management.

These are based on net-next v5.4-rc3-709-g985fd98ab5cc.


v2: clear napi->skb in the error case in ionic_rx_frags()


Shannon Nelson (6):
  ionic: fix up struct name comments
  ionic: reverse an interrupt coalesce calculation
  ionic: add heartbeat check
  ionic: add a watchdog timer to monitor heartbeat
  ionic: implement support for rx sgl
  ionic: update driver version

 drivers/net/ethernet/pensando/ionic/ionic.h   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  60 +++-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  12 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 196 ++++++------
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  11 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  24 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 289 +++++++++++++-----
 7 files changed, 410 insertions(+), 186 deletions(-)

-- 
2.17.1

*** BLURB HERE ***

Shannon Nelson (6):
  ionic: fix up struct name comments
  ionic: reverse an interrupt coalesce calculation
  ionic: add heartbeat check
  ionic: add a watchdog timer to monitor heartbeat
  ionic: implement support for rx sgl
  ionic: update driver version

 drivers/net/ethernet/pensando/ionic/ionic.h   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  60 +++-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  12 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 196 ++++++------
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  11 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  24 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 292 +++++++++++++-----
 7 files changed, 413 insertions(+), 186 deletions(-)

-- 
2.17.1

