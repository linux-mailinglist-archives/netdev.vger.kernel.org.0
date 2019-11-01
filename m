Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C05EC2D0
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbfKAMi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:38:59 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45734 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbfKAMi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:38:58 -0400
Received: by mail-lj1-f195.google.com with SMTP id q64so10054300ljb.12
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eJi5RuoHHaWaDwWIiOiYivJc8X2A5zszL2ofHOuzPQw=;
        b=fELlXBC+m2oDVEVVp+lLH4PDPoC7PUuLgmWFlnU6B8iBP+LpO7IBe6HPsVehmLiDCO
         PBrXC8OPvIVRSXe6/E7Dztu7e9BBFyT2dbPD3bkfFRWz90CwSSS/8b4FH2PTl3oxa+0x
         pyRsWXRAGcSVOm7thhi3hYSUQAWxXTCkX4BTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eJi5RuoHHaWaDwWIiOiYivJc8X2A5zszL2ofHOuzPQw=;
        b=JlzBXZJwZVCEjMQItPvXTjMjtZljzzVtBxzWZhq7FKKyuJBxdUgWh3xeBHt9qU0cyW
         FAH4FN7On5l7v04sE400L2gbqyIs5CgdQi5V4AkoFSoulf18FSFPJayHGFowLXs1fdC2
         DYDXClnktYg3tpmeDlaj6hh1YdS965cKUz4IMjtPSUbkOXHUPWIA98RtJHsmBgiOvKOE
         GmiwEYtLA6/hdhSBk0/m6T6XJ1PceHWHpzAz7lKQ7V0hVRtOCvoYTqKCil911MU46wyg
         n/HFgcsHn0nPDt/Sf9FpRTJ2FTjACtvIFkH/EGcM/ML2zZLmna9pV+m94gb9i9SN+Lwc
         06Fg==
X-Gm-Message-State: APjAAAUCQHNlO9DtQkq6w+jaf+DB1n/LXKTGbg4AmYPaeQlNk5JiMdIp
        bQlChety1EDf1TOXO1X6ICFT/cKjRY8=
X-Google-Smtp-Source: APXvYqzZZL9C0nxRhxpitUItz37TOi+L7VLDMk1APpbU3NJv+h+y8i2n5s9c+mg0dQKoPq10ee78Kw==
X-Received: by 2002:a2e:9a9a:: with SMTP id p26mr3274753lji.164.1572611936105;
        Fri, 01 Nov 2019 05:38:56 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f25sm2349909ljp.100.2019.11.01.05.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:38:55 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/3] net: bridge: minor followup optimizations
Date:   Fri,  1 Nov 2019 14:38:40 +0200
Message-Id: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
After the converted flags to bitops we can take advantage of the flags
assignment and remove one test and three atomic bitops from the learning
paths (patch 01 and patch 02), patch 03 restores the unlikely() when taking
over HW learned entries.

Thanks,
 Nik


Nikolay Aleksandrov (3):
  net: bridge: fdb: br_fdb_update can take flags directly
  net: bridge: fdb: avoid two atomic bitops in
    br_fdb_external_learn_add()
  net: bridge: fdb: restore unlikely() when taking over externally added
    entries

 include/trace/events/bridge.h | 12 ++++++------
 net/bridge/br_fdb.c           | 30 +++++++++++++++---------------
 net/bridge/br_input.c         |  4 ++--
 net/bridge/br_private.h       |  2 +-
 4 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.21.0

