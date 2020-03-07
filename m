Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE09B17CA11
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgCGBET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:04:19 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50471 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgCGBES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:04:18 -0500
Received: by mail-pj1-f68.google.com with SMTP id u10so140755pjy.0
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Pc0uPcyrEOlCrGPSA6/JYYc+/1ehYrAZwHQEWZL1v28=;
        b=GpfFRXT4qwTzQHVxPqaOWYNci9+mWHOMdgGL0onvQLD4uh8SekwK5A/Z3cH9g5vIyk
         Y1epaVTelvCouF9K386dPTI36cS54Ehij6V3sMchsDrEvV6QkDIsxhHDO6UnYsed/OKr
         ONBdqINPHXsyS5tErtI31wzCV3NTMXNNzOMmARUiAtpU1JcbyAr50Jvjej2Tc7DUR92G
         P99RY2OwhQyU5/FO4bjfYin4v1sPopF2ywr0NZN9ftWqoa+fU5xz9PbK9JKW3rbC12Px
         2tbU0Y1Nn27MoqeUyrZ9FlcyaD366SEpLbZBH1/1byJjvRgPEbQahR4RqTrthmSfamqR
         v7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Pc0uPcyrEOlCrGPSA6/JYYc+/1ehYrAZwHQEWZL1v28=;
        b=KA/pO0pLt2bV40aI+roqv8BfxUDSMLFj7OWX0aHMIHgTv0/hhwBjbdjrAe5nNnQ52V
         81iHKpeq2Fxvg0fxGK2yCnQ0oBoMLMnIUctUoR2SvCl9ZBIRUpyjALGIqiDMEvgkU+KY
         zdK7HBK7Kylt7I2B/9xs0nX2uLJ0+aS5QKKsUxk44Aq+E+uoraexbQ+h906fLQRrMJfV
         0mfG3NT/dz/6OJcQnSHf75MHe+Vn51uZgCxKWUIcyKEHFz3rBDp2/eXnm+lvmMr6Z2fz
         Wus+C92ekigdYTN0mlhi9c/OXU0QruA756PhGr8H2+vL3oxWagLA6sHy+yNsngn1j0h7
         NQKQ==
X-Gm-Message-State: ANhLgQ1VtwQm1rysbPHCVqRYVq+OfJcz2GNaLoCREcLKJ5Q2ap97dKy6
        Mwc4fHiyB/gYkxX5RrdRK7iCfEUY1no=
X-Google-Smtp-Source: ADFU+vuYvLWgwME2ZJnMESxLGUDvXu45fzxQXtFsKR/gkC77CRopXBxh22vBU0EQwzA5T4qM3yKTMg==
X-Received: by 2002:a17:90a:e2d4:: with SMTP id fr20mr6369558pjb.146.1583543056773;
        Fri, 06 Mar 2020 17:04:16 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o66sm23224949pfb.93.2020.03.06.17.04.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 17:04:15 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 0/8] ionic updates
Date:   Fri,  6 Mar 2020 17:04:00 -0800
Message-Id: <20200307010408.65704-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a set of small updates for the Pensando ionic driver, some
from internal work, some a result of mailing list discussions.

v4 - don't register mgmt device netdev
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

 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 27 ++++++++--
 .../ethernet/pensando/ionic/ionic_devlink.c   |  2 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 25 ++++-----
 .../net/ethernet/pensando/ionic/ionic_if.h    | 38 ++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 53 +++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 15 +++---
 .../net/ethernet/pensando/ionic/ionic_main.c  |  6 +--
 .../net/ethernet/pensando/ionic/ionic_stats.c | 20 +++----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  4 +-
 10 files changed, 110 insertions(+), 83 deletions(-)

-- 
2.17.1

