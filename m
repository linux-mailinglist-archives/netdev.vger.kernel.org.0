Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7F7178973
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgCDEUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:20:24 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34144 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgCDEUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:20:24 -0500
Received: by mail-pg1-f194.google.com with SMTP id t3so362955pgn.1
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2mH5xBBfLe7mso0hgJDxdgacc7am90n2RbStotLP2EE=;
        b=u0ea7SGZiBx4Rh8WyXvLV1Rl7t0LGB1BZABQKw51zSacEKrPDc4l9o8FR7MJqQGeSk
         vGKk003ZnLtp+fpUBDk0YVSeW0BpI9239ydss1YunjY/rqmGkWXdrKwT2tqGKIa7Urq9
         8ydCnhipJ7rjjkbv1jI8eLPwbstVvYiQSMODSJUl3lPZlNilaHt4wgxvKlxdqCZYdOs1
         8Kw1bBDagXpt3Jul+caAyPCaEjyv+ZI6e+vL8h8vzjkbn4QYyOdvmRmTS62l0O+alzky
         JNt1OZodmOG7nIFiCDmvQ4+gZoiLIAcW2BryU4DpuCqPHSeejTBQqTxpuj2Td/bD7ISC
         LdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2mH5xBBfLe7mso0hgJDxdgacc7am90n2RbStotLP2EE=;
        b=amDbXBIXrje/Z1gDaxv2sIQ5+JCQcMBtoc6hq5zvdPKpc3AXquK8FZURBOfzh3ILTD
         1AZ3msxBXN0V+BSbGkSPCnyDO2b7lNRx38mqMaelRhP2xB+DH9xZVdLCDzTPY1XqJSLk
         iQqiM20JfUbbfh1+gAMsfzF6HzZUdFdWO2VLYo60R5cLTEkinpXjSIMVf2wLMSQ3M6gp
         cZGgTpT+HWFRrT102BWl88/V4Uq2xnW5Btsgg3jzPAd/oeFyLNBdURJzgAGHb+pv2pcs
         u19LXvt1vv51e5aKo1Tfbb1382wI0UcxfdO35wCbAfXWz9Qm42rnNlkJj6maUpkMmguw
         3Ktg==
X-Gm-Message-State: ANhLgQ1p1XCr3T0o6+159KjTk8ICLgKUXiPzoEi5c0B+a4D9rrVQYZGy
        VvrmTJJILEupa2ZVryQDYjlHiN9sO6E=
X-Google-Smtp-Source: ADFU+vt3tgDPGOjDncqk1JU3HARUkNcyr9aHgwFvZWIqh8R/mGupHlyRoqZDVvTq/8u2Fxqegonptg==
X-Received: by 2002:a62:17c8:: with SMTP id 191mr1202344pfx.105.1583295622052;
        Tue, 03 Mar 2020 20:20:22 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm671702pjo.28.2020.03.03.20.20.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:20:21 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/8] ionic updates
Date:   Tue,  3 Mar 2020 20:20:05 -0800
Message-Id: <20200304042013.51970-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a set of small updates for the Pensando ionic driver, some
from internal work, some a result of mailing list discussions.

v2 - removed print from ionic_init_module()

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
 .../net/ethernet/pensando/ionic/ionic_main.c  |  6 +--
 .../net/ethernet/pensando/ionic/ionic_stats.c | 20 ++++-----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  4 +-
 9 files changed, 86 insertions(+), 77 deletions(-)

-- 
2.17.1

