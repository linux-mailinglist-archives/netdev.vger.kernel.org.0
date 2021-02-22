Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297EF322227
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 23:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhBVWa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 17:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBVWaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 17:30:55 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A63C061574;
        Mon, 22 Feb 2021 14:30:15 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id ds5so562026pjb.2;
        Mon, 22 Feb 2021 14:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kx6Dchna4hn/dVA9JmVwo8evWAsk2O8u38C6RCiJgXg=;
        b=MU6IRhzqMkVc3QQYia+AI5XcnunTDYzxwOwzFEu+C24iVoVTPI6EUy67FByXT0JJgY
         flgOQzSd98RbPhsXZjwTqq9/Kz5gKu2N2jalBcSGfFNMwKYeMCtVfZ/f416E2aS+5/iv
         UkABjA8ELSh5bL2FvKyoPGT40b6uo9v6xmlMmE5TZo2V3G5GGAi2D9Tjn3saF/W3bMEC
         Ig7ogz+sqKGxzkjaixSUQg2nAKMmektWNYpRRcVfvZM8kzE56OU4MnmQYWTrg8Fjqg2L
         HCZChCXwlmcZ/UjmL8cUOEwfRkREjKCXcNouZ8z+f/LYUgwoZW959K9b34JrdI5xLmn2
         L9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kx6Dchna4hn/dVA9JmVwo8evWAsk2O8u38C6RCiJgXg=;
        b=Cb7hh4ReMoViUnyVadhMgnWyWfTq1wcVhyYQ/wUzsGGGCRTDj4B8tF0eGmAYTu5ILl
         B4RqGd2rGHuYAx1Coc1vemybVxoz6l/a7fr1FJ5R9c35iVL8gIja2lIBfoNCjRY3Ihz8
         x9eb2FmFLNmHOC0qq2GmbnzDERwRvGaiRBagHAGC2e8CDubmO/aWMP8jGuxsLr9o/LTw
         3M2CZMYSzHYvt/UIvrOhnGDqRO9o0/jbkKvRrdVSKUsUqUJzTQhwyP53HaqD6hoedjXY
         9CWRptZibGXJoiuPj4EjkyblCua/K/oi8LXRbfVveZ8AXRBJTBy9HY9zalG6NZgD1C2t
         eJXw==
X-Gm-Message-State: AOAM531vGFjaG9211ZiwQhmAdd/EeSaSB+NmnTQe19duUsVmaBSshxNH
        Km+swgx1K1Gd2mTQAFhjuY46613h+P8=
X-Google-Smtp-Source: ABdhPJyD5s/+qnlYW2kJZ+0TodyEx7Ybr7cmbvDCKKIeOajh9ykpjhqo91wHxX8s80/xxXcYfKYKgg==
X-Received: by 2002:a17:902:aa42:b029:e3:492a:7b37 with SMTP id c2-20020a170902aa42b02900e3492a7b37mr24286147plr.6.1614033014435;
        Mon, 22 Feb 2021 14:30:14 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gg5sm495385pjb.3.2021.02.22.14.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 14:30:13 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2 0/2] net: dsa: Learning fixes for b53/bcm_sf2
Date:   Mon, 22 Feb 2021 14:30:08 -0800
Message-Id: <20210222223010.2907234-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

This patch series contains a couple of fixes for the b53/bcm_sf2 drivers
with respect to configuring learning.

The first patch is wiring-up the necessary dsa_switch_ops operations in
order to support the offloading of bridge flags.

The second patch corrects the switch driver's default learning behavior
which was unfortunately wrong from day one.

This is submitted against "net" because this is technically a bug fix
since ports should not have had learning enabled by default but given
this is dependent upon Vladimir's recent br_flags series, there is no
Fixes tag provided.

I will be providing targeted stable backports that look a bit
difference.

Changes in v2:

- added first patch
- updated second patch to include BR_LEARNING check in br_flags_pre as
  a support bridge flag to offload

Florian Fainelli (2):
  net: dsa: bcm_sf2: Wire-up br_flags_pre, br_flags and set_mrouter
  net: dsa: b53: Support setting learning on port

 drivers/net/dsa/b53/b53_common.c | 39 ++++++++++++++++++++++++--------
 drivers/net/dsa/b53/b53_priv.h   |  8 +++++++
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        | 18 ++++-----------
 4 files changed, 43 insertions(+), 23 deletions(-)

-- 
2.25.1

