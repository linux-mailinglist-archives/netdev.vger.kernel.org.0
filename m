Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5411734079E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCROQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbhCROQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:15 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E385CC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:13 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id f16so7726978ljm.1
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=RuTogrU6VF/X/a66cNlGy6htEJLtmDYL3EdJknFmnhQ=;
        b=YZ8skwvgWOBDYiWh94Yn+XwyaA3xF2PBNpNo8b1HrzLCtdlmP8yXpZqItzUrBqr1gy
         CtimTFkVueQn8so92YuYcGyH49M7XtTDIpiz9iYFoKu1MG43HF1zWXWpCtDKp6gFBrNB
         Hq4eIYWsdW6LvDkwMQaVPyF4A2g/iMFIurEEGpYpVHHHLJJwEGoctpTL3iICvAYYh+Ah
         d/e7ePFE3XSRNm9qyFaXjTUYkXghUk2sP8+xwd+JNZ5oQdt0g8TKfKipvLjBpRH55n87
         slmrmK759fgANJE8jjm2zOmhn9VaIy0AWQP4rjBRYk/1r3FwG1YNF+qG/+Z2+Sdhzh+x
         g1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=RuTogrU6VF/X/a66cNlGy6htEJLtmDYL3EdJknFmnhQ=;
        b=dhUi51459olqyS16Yehs8VE5o7kO2af+vML/Qq9VjyvLNfZRWv6EUptoGLQ71rwggC
         /umGT/iC4n3KjtFp6rZcBNzLiX1l3ejJK9AfG8s08XpQFwn0l3hEM0C6f6AR4kPNAfvp
         wetlqnIj+JUxCKK9bUcO48+ddabGMG9QZXJWaa740DWvp7PCUU7491WWht3qbVm3h4jT
         vohiAzrLe15O638Yn4OB/AjhHy6roOF5COaygHoRhquRms76m2C3gG/93DL1HZJhvbtA
         E5S95FUPyB+vT55zjpRPLuUZpox3g/2RzArDUTjMdS7tPV+DC++P9f4orIYlJ8weDYIs
         Ga3g==
X-Gm-Message-State: AOAM530hZ27RJ2QLktGze3j8veTXvWgBKh5ZTb7kaT+i1rcwhnXamlT8
        oEunehxyhaHDPxLwwBAB9NgPfg==
X-Google-Smtp-Source: ABdhPJyZfS2U3Hz1mT9wbq+SzYZWbo7mxMCYUn3a3akTEi/V7a9VIotXoivZWiBt+ufQa+3CcxOe/Q==
X-Received: by 2002:a2e:9bd0:: with SMTP id w16mr5371660ljj.465.1616076972466;
        Thu, 18 Mar 2021 07:16:12 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:12 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/8] net: dsa: mv88e6xxx: Offload bridge port flags
Date:   Thu, 18 Mar 2021 15:15:42 +0100
Message-Id: <20210318141550.646383-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading learning and broadcast flooding flags. With
this in place, mv88e6xx supports offloading of all bridge port flags
that are currently supported by the bridge.

Broadcast flooding is somewhat awkward to control as there is no
per-port bit for this like there is for unknown unicast and unknown
multicast. Instead we have to update the ATU entry for the broadcast
address for all currently used FIDs.

v1 -> v2:
  - Ensure that mv88e6xxx_vtu_get handles VID 0 (Vladimir)
  - Fixed off-by-one in mv88e6xxx_port_set_assoc_vector (Vladimir)
  - Fast age all entries on port when disabling learning (Vladimir)
  - Correctly detect bridge flags on LAG ports (Vladimir)

Tobias Waldekranz (8):
  net: dsa: Add helper to resolve bridge port from DSA port
  net: dsa: mv88e6xxx: Avoid useless attempts to fast-age LAGs
  net: dsa: mv88e6xxx: Provide generic VTU iterator
  net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
  net: dsa: mv88e6xxx: Use standard helper for broadcast address
  net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
  net: dsa: mv88e6xxx: Offload bridge learning flag
  net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag

 drivers/net/dsa/mv88e6xxx/chip.c | 272 ++++++++++++++++++++++---------
 drivers/net/dsa/mv88e6xxx/port.c |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h |   2 +
 include/net/dsa.h                |  14 ++
 net/dsa/dsa_priv.h               |  14 +-
 5 files changed, 234 insertions(+), 89 deletions(-)

-- 
2.25.1

