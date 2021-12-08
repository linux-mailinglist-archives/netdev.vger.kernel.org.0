Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C3246DD0D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhLHUbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbhLHUbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 15:31:41 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE14C061746;
        Wed,  8 Dec 2021 12:28:09 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id m24so2291895pls.10;
        Wed, 08 Dec 2021 12:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jz4/jhk7xUVrW5OJzyayX19wmA7qwRHFCoEj1X6o+D0=;
        b=klG8dEI8WhCoAU9txu76Q0XMHG3ulTxn9uIOsRgKVqQKcxRAdjBKp19Gl9s34GIXkN
         WH/ZyypNEzSHS8+5HsAuabqYJAOnby1VvgOXYoMLz7q9LQnNuIWTB5+xojT6I53f3OUH
         cXrCfcxRBsMyQk08So2uDd+zSau2fTgM20ba1MvXswhr8WoHAQzlm7OvznucQNZkV0JO
         zk0lGweRyvvA3IgB8Q5PDGBg8j8Q+dNBMA/wSdd6qQvDas40ZGoJrkO/4o6hFOcz5FFq
         rcgfVowRxFwu7TDLP1X7hzKTYnLaGq2T2iL7OprfNTJC40ShmKlE06LR5wnQHHUDiAoj
         k2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jz4/jhk7xUVrW5OJzyayX19wmA7qwRHFCoEj1X6o+D0=;
        b=HCw/2qLS50TohCIzn1CfvYTyobQnySjtnmWrojTCYRsrKGw2Xmz6Aj2hINKqV5CfFw
         XfwXpW9wYANYJbh52mAgwRyrlbbqeyYmF4XPM0JTvgpiKWSqI29QoY95UwehuqttL7Fb
         mhYA0nBaRRHKe3toP2maNvcWRpaxGB03CNGwm8uej/5r2UzWHvRAGsTIIR3Aq2xMo4up
         2edLKVbSOP5SespReNJoimlDI+8Z8HXuDqoI22tRke+lUERmaDpD48iHsfVgxZ2DtZcd
         E8D+FomZLivwS8r+ebN4tieKI3djqd3BfqvAI+whtMawDbBPxxWUVAzkP4CWAVO3I/qU
         SyfQ==
X-Gm-Message-State: AOAM533Hs58ZBZZYvhwV0MeZJbineUYWPG9bwcb4ewJF6Q9KRoxiuEFb
        fk8y1pRMfRqI6ahFVgyKD5+1cnFUk1E=
X-Google-Smtp-Source: ABdhPJyD+kKsgF5hTQe7M9iR+tNaoIlc4hO0a72rHii9syBkAthNp3goDYX0d6p0oftRplofWM77kg==
X-Received: by 2002:a17:90a:fe1:: with SMTP id 88mr10033843pjz.24.1638995288570;
        Wed, 08 Dec 2021 12:28:08 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d17sm4592291pfj.124.2021.12.08.12.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 12:28:07 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 0/2] AMAC and SYSTEMPORT bindings YAML conversion
Date:   Wed,  8 Dec 2021 12:27:59 -0800
Message-Id: <20211208202801.3706929-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Since the other patches have been applied to dt/next, here are the two
that you requested changes to be made:

Changes in v4:

- updated AMAC to list all possible reg-names values and then use
  conditionals to adjust minItems/maxItems based upon the compatible
  string

- updated SYSTEMPORT to indicate the tx/rx queue range, drop unnecessary
  quotes and use unevaluatedProperties: false

Thanks!

Florian Fainelli (2):
  dt-bindings: net: Convert AMAC to YAML
  dt-bindings: net: Convert SYSTEMPORT to YAML

 .../devicetree/bindings/net/brcm,amac.txt     | 30 -------
 .../devicetree/bindings/net/brcm,amac.yaml    | 88 +++++++++++++++++++
 .../bindings/net/brcm,systemport.txt          | 38 --------
 .../bindings/net/brcm,systemport.yaml         | 88 +++++++++++++++++++
 MAINTAINERS                                   |  3 +-
 5 files changed, 178 insertions(+), 69 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,amac.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,amac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.yaml

-- 
2.25.1

