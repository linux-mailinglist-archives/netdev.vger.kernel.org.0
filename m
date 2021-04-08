Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914E535836D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhDHMjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhDHMjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 08:39:41 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCAAC061760;
        Thu,  8 Apr 2021 05:39:30 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y16so1712799pfc.5;
        Thu, 08 Apr 2021 05:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+QmHxLtSKiy/M0k5RFjpXgoAxgaENLbGHZnwkZzXYD4=;
        b=eVFhWLUE7G9oQNgyvcq6kKZy8Vl0StafOcaJBTHm6NaU/B30SGmjqkSHvRpMnEu3yZ
         UFHsRB3n8VQGSK/aa3BhgFfHtwF7f6hP26FYUMstC5KPoD2P+kCxmkJTcKo7WGmNl6Zt
         j/X9WOK1TqTiiBXkcw77pZy1OmzhtK63xj06TQt5iG8jfk3cTiyy0ZCDWVkoFdSSdXDG
         uUJLVtsVKwiG9vZMhh0TNL3VmyamyrNivv/crV/eLcNX4zVeIBulNP9q5N4aBCzTGH9z
         OhCLm4GCv9pNLqNkLY9CjiyiYioQdOEoT7pIJM/iUCWYqagTEUnNE+KQ5ByHdWP9BLaU
         EhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+QmHxLtSKiy/M0k5RFjpXgoAxgaENLbGHZnwkZzXYD4=;
        b=sUApcw8LjfbiJJvE9Cu1uCvpDSkVXU2CQLZzgt66H3GZU2709yPZJnSS/Ns5GhnMEK
         ObbUKYjdkVuqiQuQhYo2KCi1ddvCCAKyIOAfBcGay4WuoLNhGOWGlw3z+QycAP6WTSQv
         BWPCjOK0jgoDl9Ka0ItSTBmDNFsIFUe8PAUoyyiDODJGut1oC7Es57WmkO0PuSU+KLTZ
         eDAI8vx1tE+OYD7F5AeUmulSLZIjuC1j0eE2KDGx5TZIf5hwjeO6QcmYFzX9A8SxD+Gy
         JWnzdfi54jsPVLo29ZhrQhpKh4NqqauQAyd+Z2LgV68DGI4QDvKleql+Za3OdpDdABgL
         9tQg==
X-Gm-Message-State: AOAM5315P8j843BRHaZeVcdC/WHhXb9VwjqMjdK1KSs6WSCj8MZlbRXz
        uEkViywAkpzFLr2i6/S3KYE=
X-Google-Smtp-Source: ABdhPJw7NzYVa2g9FhYvGUl4llk+/2n6jSAK9mJ0yj0DoybhePdFaNz3OQqsQtplw3NZrugrjc2Azw==
X-Received: by 2002:a63:d945:: with SMTP id e5mr7632086pgj.449.1617885570300;
        Thu, 08 Apr 2021 05:39:30 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id e65sm25831311pfe.9.2021.04.08.05.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 05:39:29 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [RFC v3 net-next 0/4] MT7530 interrupt support
Date:   Thu,  8 Apr 2021 20:39:15 +0800
Message-Id: <20210408123919.2528516-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MT7530 interrupt controller.

DENG Qingfang (4):
  net: phy: add MediaTek PHY driver
  net: dsa: mt7530: add interrupt support
  dt-bindings: net: dsa: add MT7530 interrupt controller binding
  staging: mt7621-dts: enable MT7530 interrupt controller

 .../devicetree/bindings/net/dsa/mt7530.txt    |   5 +
 drivers/net/dsa/Kconfig                       |   1 +
 drivers/net/dsa/mt7530.c                      | 266 ++++++++++++++++--
 drivers/net/dsa/mt7530.h                      |  20 +-
 drivers/net/phy/Kconfig                       |   5 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/mediatek.c                    | 112 ++++++++
 drivers/staging/mt7621-dts/mt7621.dtsi        |   3 +
 8 files changed, 384 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/phy/mediatek.c

-- 
2.25.1

