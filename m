Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DC130214E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 05:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbhAYEoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 23:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbhAYEoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 23:44:17 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF33C061573;
        Sun, 24 Jan 2021 20:43:37 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j21so2224532pls.7;
        Sun, 24 Jan 2021 20:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CjKIlCnAp40LXXxyE/ljdpUidkTMFHjswfBhcPJLNKE=;
        b=VtI1egLQ+tTQjQ5Tm7aJkEIjjZs60jUHxCHW3mSwKzC1nChsvZnb8tZekBZYwd71eb
         XP8va3jFniMofiApITFRgf87GCMYrAGcBZx7YQfvNjazFadZXiD/l9lPVHoqb0bcaaGu
         akG0Tkum04+Xl7YXFw1PNdVIU2okgZp1zHhYRw+6hRVhxZnpbOuSqyiwrp7FZx31soqO
         NQ84m1csamiGXIP/AzGz5o/3CQQEi6XIKC1UOnw2r882Iu8oXRxrYXItJ9pY+ZeuxI61
         o6wSZhgLE8pQMIP2mFeZaV44qfnknDZvQ6Xjen8RfTVyrFKRFK4uEfp3dUxnYnbY4c9m
         +04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CjKIlCnAp40LXXxyE/ljdpUidkTMFHjswfBhcPJLNKE=;
        b=BomaM2y/VBHyQkexC5p7HsQXgvIoCqqtwAQJeEj7K8ZHtU+kWXMb0P8NOIDCpk8Ucr
         U+lbfwclKiJyJzuq6zh13kJZrSfwL1LKEei64MgUxYybH4vvQBZgQv51SMpvWF3xkOaq
         PY2psTFtSOCqHtdVG3g+XzEx1VV0L+DXa0iTdWoO32WEU4s4ELt3SaQIJnxbSTzy7p0c
         XgKk/LtkfJtupGW5ty74SbvyuqvVQ36+wHXim/If0cjm6CCFLV5LnqUYZtE/HlViIBrX
         Fm2tTQl9LrcDtjWx0zfshC9lYwGOYVlTIWAOiiCE8v3aMMm2q0cImjRBifJyV9EwJC8u
         ormw==
X-Gm-Message-State: AOAM531fIrNCUf6KEdvMaTeEPN7K97ZznUzZ91i4DiowBCfQcnhN7Vay
        XiYh8Ru/hst3lg9Xaewe+Gc=
X-Google-Smtp-Source: ABdhPJxbu3zuYr6d4RIC2ayqOy95V7a1SqBzIS32F4SdMgpijq7017S96q5Cz87Dr6A7fv32F6tAEA==
X-Received: by 2002:a17:90a:8595:: with SMTP id m21mr4717423pjn.111.1611549816841;
        Sun, 24 Jan 2021 20:43:36 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.26.203])
        by smtp.gmail.com with ESMTPSA id h4sm11913369pfo.187.2021.01.24.20.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 20:43:35 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2 0/2] dsa: add MT7530 GPIO support
Date:   Mon, 25 Jan 2021 12:43:20 +0800
Message-Id: <20210125044322.6280-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7530's LED controller can be used as GPIO controller. Add support for
it.

DENG Qingfang (2):
  dt-bindings: net: dsa: add MT7530 GPIO controller binding
  net: dsa: mt7530: MT7530 optional GPIO support

 .../devicetree/bindings/net/dsa/mt7530.txt    |   6 +
 drivers/net/dsa/mt7530.c                      | 110 ++++++++++++++++++
 drivers/net/dsa/mt7530.h                      |  20 ++++
 3 files changed, 136 insertions(+)

-- 
2.25.1

