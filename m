Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81EC2F0C9B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbhAKFpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbhAKFpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 00:45:34 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0068C061786;
        Sun, 10 Jan 2021 21:44:53 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 11so10294779pfu.4;
        Sun, 10 Jan 2021 21:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=88GcoNGL/AXgeCjNvngovwMr6/msxp3BLQE6/faGv1E=;
        b=h4+cG8LBG4mJ2vwsd0js8PfV+47sXFW4md16+AhwPXwgU9YZmmW2Lbaanew5uI+efR
         zxNOSQz+NPgRzUZN54kj7M4CTyLAeDMQ4sI8MlJaKA6U28f5X1Ttwhlvn6ke5ccL99bV
         IhZ0wc4vjAW+v0aiYBZscmF0Hg5up2X/8PWzw1QVEx2emEkzgZ0isVk5GQuCHEjDh+Au
         mTjoRy8bwfYWPmGnaPczlFMa5fPx7oQD8HJdtlJki8doIr1dyB0vwKO4zcaRR+nFpvnU
         kiJOLyZdXC4wL862hDu6srQ8LXH2o98c2u1m2wnEqj2kHNZNPJh4m8P6LZZtKEpgyoQL
         8EDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=88GcoNGL/AXgeCjNvngovwMr6/msxp3BLQE6/faGv1E=;
        b=LNKdUuUuQCcQ5wcUU5aJ4Tj+po9sICDBVO8lTdyczJiT8fpS8QZJUAxTjh09FfHjPJ
         EqJVbL15Sv6N3rmQWjo10AdNvDcbTaOfFc9b7DV6vrGSSC95u+20cT0CETPCuHmCxn/q
         3/r4Q83FZVvl0SsRJ3Ymnv+5axh5efwjKfeA6GKtcjY0fAoYOPIpcv9DwaJh5zvW7126
         t5HWCBvvjrsnAjsR+KFU28PlbopKdkZ7PRSXY2QuCY9Vgjn5VEK1WrohLvmGjrXVD1J9
         Ntq9YUj74GcDNsU+2Fkv/7vMlTdwHmv84Ipctmw7dQwslcorkwIGY0pyCa1VwDXx332p
         qLVg==
X-Gm-Message-State: AOAM53158Kwex2hRgZrNckAG+kFTj3lgK06S9A3f51tOkkWbp4V6B+6o
        xhKXwcPcaq1SLT7i+XH0rsI=
X-Google-Smtp-Source: ABdhPJxglMNH6WCUJJua0ObPzfzCa/AOfasQge6NqUl2igBLSmJcdZvEEwFVOyUKepzuXmQCloQ5tA==
X-Received: by 2002:a63:1d59:: with SMTP id d25mr18119366pgm.259.1610343893413;
        Sun, 10 Jan 2021 21:44:53 -0800 (PST)
Received: from container-ubuntu.lan ([218.89.163.70])
        by smtp.gmail.com with ESMTPSA id q16sm17548005pfg.139.2021.01.10.21.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 21:44:52 -0800 (PST)
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
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next 0/2] dsa: add MT7530 GPIO support
Date:   Mon, 11 Jan 2021 13:44:26 +0800
Message-Id: <20210111054428.3273-1-dqfext@gmail.com>
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
  drivers: net: dsa: mt7530: MT7530 optional GPIO support

 .../devicetree/bindings/net/dsa/mt7530.txt    |  6 ++
 drivers/net/dsa/mt7530.c                      | 96 +++++++++++++++++++
 drivers/net/dsa/mt7530.h                      | 20 ++++
 3 files changed, 122 insertions(+)

-- 
2.25.1
