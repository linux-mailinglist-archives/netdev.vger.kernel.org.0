Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC6F30A952
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhBAOGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbhBAOF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:05:57 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D49C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 06:05:16 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id d18so18890598oic.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 06:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AOOjf5mf1DQlXkdUw4GWpmEWWn2gbfTXlxrpwqDRdco=;
        b=sXr+2bi7W9poXqPMuRIU28MW5F9AU13Zp0vnZYCn8LEwtkPHtBKZXlxfMSaWIVIJPV
         huzp+V8H9ZZ4mhg9sC4Tk9F1J77C9IWhMic+Y6KW5N0I3kmrfHAk7ACT8Th2zP33llmK
         3rEC6HO30q3LiFU+WJ9PpJzcM115DS5eHRB6lLNRXE9VdsNwozbOd6BFDb5eHZ42F8eL
         ItMVZqvTw3vbJcPy7KlsV9a+sSjMymzKb/E+fbnuf37u+M4PZ1WlI316HlVk4sBEch1t
         iFcOH3C1RuEfSyaeb4hBDFUZnL+efWyLpaYJPHgS9kg7N7l01f8WXUoTAw9m8Tswl12u
         Ra0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AOOjf5mf1DQlXkdUw4GWpmEWWn2gbfTXlxrpwqDRdco=;
        b=Skd32o4amsc8pYvyj92+b4IYojM8i3jEwoA13ry/acIsH2T3GlnGqVNIzeHfOrTfd7
         RgwsieCstzvgHz7TwYlEK7fNvOxMSjYDKCUAi18JIfF1b8VXNx5KRUotdMPe7HPhUj6W
         kChSk9+jsD0pjZpO0To4Ejg/rb5sEs767zmXBODSZjzfMDbsuFCHmuH92Vy2YjZGKI1w
         Trapl6Gkcw5G3FXI57+Jg1dCEJWAd/XOtZldECrutT+5o/uEEQWx32g4uOzJWCUHDSWx
         qvQcBmPZ0PcKom0chk3epUbOxpxTG5WXtily2/zBNAHRFZNYtYGWE2e5EdITWg5n+I5g
         bxzg==
X-Gm-Message-State: AOAM530oknmzzTMVzg59AEOwWn3qnBsmcorOYVwPUt9D3bD2wYalxfbE
        T2vquMJKBl37+WjqmtuZig==
X-Google-Smtp-Source: ABdhPJxZ0G8n/esUkk8Gtanlj5kxrfsztZCWJTkTLYgGJcyZwytfbGolMXzdXDW75yXRdbvMwmMCeQ==
X-Received: by 2002:a05:6808:8a:: with SMTP id s10mr11486937oic.152.1612188316159;
        Mon, 01 Feb 2021 06:05:16 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id q6sm3967972otm.68.2021.02.01.06.05.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Feb 2021 06:05:13 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [RESEND PATCH net-next 0/4] add HSR offloading support for DSA switches
Date:   Mon,  1 Feb 2021 08:04:59 -0600
Message-Id: <20210201140503.130625-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
removal, forwarding and duplication on DSA switches.
This series adds offloading to the xrs700x DSA driver.

Resent. Jakub says "looks like this is not showing up in patchwork
probably because of the ML server issue - please repost"

Changes since RFC:
 * Split hsr and dsa patches. (Florian Fainelli)

George McCollister (4):
  net: hsr: generate supervision frame without HSR tag
  net: hsr: add offloading support
  net: dsa: add support for offloading HSR
  net: dsa: xrs700x: add HSR offloading support

 Documentation/networking/netdev-features.rst |  20 +++++
 drivers/net/dsa/xrs700x/xrs700x.c            | 106 +++++++++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h        |   5 ++
 include/linux/if_hsr.h                       |  22 ++++++
 include/linux/netdev_features.h              |   9 +++
 include/linux/netdevice.h                    |  13 ++++
 include/net/dsa.h                            |  13 ++++
 net/dsa/dsa_priv.h                           |  11 +++
 net/dsa/port.c                               |  34 +++++++++
 net/dsa/slave.c                              |  13 ++++
 net/dsa/switch.c                             |  24 ++++++
 net/dsa/tag_xrs700x.c                        |   7 +-
 net/ethtool/common.c                         |   4 +
 net/hsr/hsr_device.c                         |  44 ++---------
 net/hsr/hsr_forward.c                        |  37 ++++++++--
 net/hsr/hsr_forward.h                        |   1 +
 net/hsr/hsr_main.c                           |  14 ++++
 net/hsr/hsr_main.h                           |   8 +-
 net/hsr/hsr_slave.c                          |  13 +++-
 19 files changed, 343 insertions(+), 55 deletions(-)
 create mode 100644 include/linux/if_hsr.h

-- 
2.11.0

