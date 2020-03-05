Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0897F179F16
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgCEFXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:23:31 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45361 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgCEFXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:23:31 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so2162762pfg.12
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qldxqEhhwALsgQbGH9b9y2wqebQXz5/6dsX24BKoaTE=;
        b=L8RS4YbF8C3pRRkOKbYXL9Y10fDivYGQ2o++GWw6RqYZyq/lr1Y6XFx1WPMyCAHwOT
         vRAGlOy/DeP60sdo+N2vJfBq3vBWjnoTB7fVXcXqMHGVWh5laYcwxYEfzM6hYoy+dO6Q
         5WLcLC258sR1YCtKpdHyE7eFG/rSCSV7xb8pFTTzC9A+yqnJyQIw+PdDYH/DpiJHg9uz
         aseg3h9NXuhmubPZL93rc5+dDBwDj31deGiLun75XptLJqO6fhvVZO5ZVqQHNGdlDeIj
         N/rgOx0Xgvt3n2DlqtuB128+YzwyVnxTiyh4FALUqPZDY5KTK95lh/LdaghYUcdRRghl
         8TIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qldxqEhhwALsgQbGH9b9y2wqebQXz5/6dsX24BKoaTE=;
        b=Sqqr2jr6IahpnytUqc9l3V6B0yvQBVfaacdHHQdbOghd3a9zljFR//ppOkmLJKNW6k
         iU63ikAdB6++Y3iK1jlT/sNeoCUyBPz8uPSp/ohnYcJ39dJpgYLdKrvEKhSQUrJPzDCA
         TIHKcgR3pVxymJnUfQPBBq1SPUR90Rz6A/aDVWb2aq/lQ6DqqeWZOITu+KvONra2QT+v
         H3tQ2biJPEPvwZ+ZOfrV57GVBF4Yziu149oiYjUJq1I4t3X/iZ0VXBnRuGadi9BCgUwZ
         NZiPbEzjyXfvkGQyzQaKsqZBMXLVdKyUZyGJzFdeA3gf78Za/yxbrUTLOITbiuH8bX9E
         jNgg==
X-Gm-Message-State: ANhLgQ2iMtQkqxOVj/HJhB13XDmLO/sPJnwJBJ1ZskDy+yxL7AM1ljCY
        nbzp5nrezcD7tXVyhgU64zZ38Uvio3U=
X-Google-Smtp-Source: ADFU+vtjWO3Lketj751gFQtHy8s8sbenpTGJU3wIwrHYFdq3I42KBUmTDaJsyt+a0J3MtaYRqM5LVA==
X-Received: by 2002:a62:1456:: with SMTP id 83mr5176495pfu.237.1583385808497;
        Wed, 04 Mar 2020 21:23:28 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h2sm29337759pgv.40.2020.03.04.21.23.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 21:23:27 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 0/8] ionic updates
Date:   Wed,  4 Mar 2020 21:23:11 -0800
Message-Id: <20200305052319.14682-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a set of small updates for the Pensando ionic driver, some
from internal work, some a result of mailing list discussions.

v3 - changed __attribute__(packed)) to __packed
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

