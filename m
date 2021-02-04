Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BFB30FFCC
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 23:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhBDWAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhBDWAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 17:00:41 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DBEC061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 14:00:01 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id f6so4954467ots.9
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 14:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PR5sIRddjttmYY26gf6+l9XsaokgdpdKOvEvDwQXp5Q=;
        b=YWMlfPNVFHVauM9RBhgEmTipJWfzhKuLZvhk2q9MF/niy4efBMJ3tqyskIdjhPs71x
         D7Z7nYMiG/pofCOMvRW1yzKQwRgyEvZ0bZPHvAWU4OW5Uprl3IaKDAfo5d5+esZuZGgh
         X+NIBs3urwv5ExKXlj+oskGmBc9atNeWz//+ga8S/KZyL7kg8h+wxYTtVw9nFgQVOKUx
         2/Hh7KxYnud9WWbids8z5X7z2fgoNWJYWYD027w3+m3b2nCHh6cRXYZlmk92GZOzywij
         QfScP56Ouh/6zkz442Mu27fMw+KzBLb09pSeUX4pzZvyMZBfMy+quiRISjqYCdyo9lMo
         dMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PR5sIRddjttmYY26gf6+l9XsaokgdpdKOvEvDwQXp5Q=;
        b=DGyHYNrah9Ay7sndxC1inUGxBPKruFOjED75tzIAbZ3maAgaSSlFGR3nTkYiQ1FO/G
         MTlTKmFt/lI+xKb6SFJ86GXx7v4KP1a44NTLo/PDsCjZhGJlz9GYJ1HS9TzMkhRgF2aJ
         IuErh8VUT2hipaZLGzBD+DAN2wyRCUbqUKNqjgamq0AyOPH1zWr3+C8jYBp3XtWGah/j
         Ig9R+fcN/Li8TE0+rTNP0pGhtq2m1Z5RS2nYZQq5E3upjSS1IqwAiI54B39VstOolAqj
         FnMsgig+LQEMYK4g0fCrtqoUmzq0Gx/CWvuctemiM8jYkmDvts6XyTdPmy2wS2A4jXXF
         XTyg==
X-Gm-Message-State: AOAM530rtqui5Pz0MLxhZiUSPHFYOQgOEt3Ynf1B7ce1U7bPUDt4WxXA
        9z08GvxoLYcm4ibeQx9O2Ey6eR+adEz1BEw=
X-Google-Smtp-Source: ABdhPJz1k21QKdpdxtv+yVGjHxUeiHDcr0xLMlbMPlxJDpDIDDI9JuBWv8BRaU7YwgFbd9nPHPKEIA==
X-Received: by 2002:a9d:6e8f:: with SMTP id a15mr1099557otr.195.1612476000804;
        Thu, 04 Feb 2021 14:00:00 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y10sm1361395ooy.11.2021.02.04.13.59.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 13:59:59 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 0/4] add HSR offloading support for DSA switches
Date:   Thu,  4 Feb 2021 15:59:22 -0600
Message-Id: <20210204215926.64377-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
removal, forwarding and duplication on DSA switches.
This series adds offloading to the xrs700x DSA driver.

Changes since RFC:
 * Split hsr and dsa patches. (Florian Fainelli)

Changes since v1:
 * Fixed some typos/wording. (Vladimir Oltean)
 * eliminate IFF_HSR and use is_hsr_master instead. (Vladimir Oltean)
 * Make hsr_handle_sup_frame handle skb_std as well (required when offloading)
 * Don't add hsr tag for HSR v0 supervisory frames.
 * Fixed tag insertion offloading for PRP.

George McCollister (4):
  net: hsr: generate supervision frame without HSR/PRP tag
  net: hsr: add offloading support
  net: dsa: add support for offloading HSR
  net: dsa: xrs700x: add HSR offloading support

 Documentation/networking/netdev-features.rst |  21 ++++++
 drivers/net/dsa/xrs700x/xrs700x.c            | 106 +++++++++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h        |   5 ++
 include/linux/if_hsr.h                       |  27 +++++++
 include/linux/netdev_features.h              |   9 +++
 include/net/dsa.h                            |  13 ++++
 net/dsa/dsa_priv.h                           |  11 +++
 net/dsa/port.c                               |  34 +++++++++
 net/dsa/slave.c                              |  14 ++++
 net/dsa/switch.c                             |  24 ++++++
 net/dsa/tag_xrs700x.c                        |   7 +-
 net/ethtool/common.c                         |   4 +
 net/hsr/hsr_device.c                         |  46 ++----------
 net/hsr/hsr_device.h                         |   1 -
 net/hsr/hsr_forward.c                        |  33 ++++++++-
 net/hsr/hsr_forward.h                        |   1 +
 net/hsr/hsr_framereg.c                       |   2 +
 net/hsr/hsr_main.c                           |  11 +++
 net/hsr/hsr_main.h                           |   8 +-
 net/hsr/hsr_slave.c                          |  10 ++-
 20 files changed, 331 insertions(+), 56 deletions(-)
 create mode 100644 include/linux/if_hsr.h

-- 
2.11.0

