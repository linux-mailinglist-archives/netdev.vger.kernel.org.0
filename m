Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63F53AF13E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFURFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhFURFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:05:11 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70746C051C74
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s15so19837730edt.13
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4nL29uv/20PMHqwY3okHATHAvpPEGFlsW1fNkvG47lM=;
        b=HWNK2p252iYelBIvvYq6+9nn/JzWHxudnPGXH9kkOEg5wju7+icdlbw3EFmFz4NOjM
         /5vM1yRY6aLVi6NyLYf74M4ZiMIHvrwQnF1+H1TsXyT0/7+un5umQz0Hb+NVDroP4ITk
         bqeN4QYY/4cVXdsUGgatP8YBuubw++0icfEyq6IZYb6yxJQVLpmqQsV5mmfl0LIoGSLV
         2sP6X4aeDcD1ZuP9JAxI7otX5h/Cmde49t96GhvukqcCa35L84Xy6uGmqqhhqfaGaYQh
         AGsQcKP36eoWpM5+ENDe7BNwxoQOaioQMA3BHVcWqVcBbfa1vm6ta/JjqK2G0CYZ1HVB
         yzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4nL29uv/20PMHqwY3okHATHAvpPEGFlsW1fNkvG47lM=;
        b=b71UhVuNlCCFobe08fmZ5wj4se0BPsgaKHZuEYG1xXimB7+TWzDkERAVTL15ioFPr8
         9krlnUjroTW+1hSLm5ascAdkGMWHHV38xnHRLJeuuk/Rw5zaNh/tcAhJabWO1x6yQXKx
         yLe64QKVVhMfRkxLaj1q/fLgMlTy0VGa1YnpNdQm1+xaUbbpDRJfSubcQVNu7lSWB2g/
         MHQZTQ0BbmEfoNu3eolyHwySQIEyg6bJTCdHoC2f9VuaqizU6xwfM6OapJ9pVuFxXJX6
         q0SS8PLBZhUVJgQX672QExu6cYM5uTdxcDOcPObbGvbsTOr9o00U4LdeNUz1F4I4YXbs
         3whA==
X-Gm-Message-State: AOAM531Won4FgxNMKxdVFv8OTKGxbuCzla4tBZVMJ2w9wYWoHqesR6hN
        NmomJdg6fktQlbgoF+DDnZo=
X-Google-Smtp-Source: ABdhPJy5nFGzrynZyGKhQCjOy/w6gc1MOzWiosYZyC/xFL7JUR3j2GxILTlm92UCiO76aH41qJy6Wg==
X-Received: by 2002:a05:6402:204:: with SMTP id t4mr22555144edv.34.1624293754078;
        Mon, 21 Jun 2021 09:42:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c23sm10931093eds.57.2021.06.21.09.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:42:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 0/6] Improvement for DSA cross-chip setups
Date:   Mon, 21 Jun 2021 19:42:13 +0300
Message-Id: <20210621164219.3780244-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series improves some aspects in multi-switch DSA tree topologies:
- better device tree validation
- better handling of MTU changes
- better handling of multicast addresses
- removal of some unused code

Changes in v2:
Remove an unused variable in patch 6.

Vladimir Oltean (6):
  net: dsa: assert uniqueness of dsa,member properties
  net: dsa: export the dsa_port_is_{user,cpu,dsa} helpers
  net: dsa: execute dsa_switch_mdb_add only for routing port in
    cross-chip topologies
  net: dsa: calculate the largest_mtu across all ports in the tree
  net: dsa: targeted MTU notifiers should only match on one port
  net: dsa: remove cross-chip support from the MRP notifiers

 include/net/dsa.h  | 15 ++++++++
 net/dsa/dsa2.c     | 22 ++++--------
 net/dsa/dsa_priv.h |  4 +--
 net/dsa/port.c     |  4 +--
 net/dsa/slave.c    | 22 ++++++------
 net/dsa/switch.c   | 89 ++++++++--------------------------------------
 6 files changed, 53 insertions(+), 103 deletions(-)

-- 
2.25.1

