Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F57C22E352
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 01:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGZXez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 19:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGZXez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 19:34:55 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15D2C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 16:34:53 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id v15so3467906lfg.6
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 16:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LkWVxJ3o7ODSfVS8rC75HAt0MF+cnQ3HfPe7qP7A1BU=;
        b=IX8csHfkaLNSVpVlyQYd4bG6bS1vH3NWrgfnN38foHxqEwv8yGFTfCJfDQt/6+5iRS
         pGymXdeDBb7yVVkPVtmzvmJ9VNqq9H3A2oXIq+1VUpUnHPHbKy41V7Xq3rXWdaiDc5yn
         lRUE8zaYOYK4cmftlcfxGEgXr5xRs2CPutffXoLiLtu6RnyzdtTwd7DqFCzY7slr5Czr
         yLhUXO5dvo0w96Th/xIEKZ96oK09GUXHxdz+5k7QCngidFGFq+Nm1rNLULb0P09t9Tna
         p+oi2erAQSpyKTsh7A0azPQPmFXsCB6of+FPfuC7g6APZPaGvIOIGnb+hUGgADiO2d5u
         b2KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LkWVxJ3o7ODSfVS8rC75HAt0MF+cnQ3HfPe7qP7A1BU=;
        b=j6hpRvM9YZQqwPcLNUFGa+m9sPj2uJQvusnxXMMcbXTpWVjxrf6owSXatvLevxqRqj
         onWtbAWNIBbPpQ+Ft2uFStE60sdTL9aXUx8ct9OOL6/CvYzZAASHzeNnBveq92XoKSm8
         bDdrPF8JMpgHXZS+V7mvP5Yb5iFD+JJfvEUuBN8jpeqGE2E8HJ59DaWmZSOkunLvCBKw
         c0t6puhndPZtoopbn7aAWPBJN2d5P+f8JAVQh4fzCQBO/LnhLbMgdRGKFoYeWLvPT7Je
         ewjf3WYgVDqRa3RdbcAmew6gv7TLPjXNBn6kWDxNmOPCieFd0OAf8DxX2wMc/u5PgBK/
         mOIw==
X-Gm-Message-State: AOAM533d4WXA/6BmiVh9/ewH4bzYlMZ0sp/U2uVP4Thdn+espWZ+BrHN
        s1JjoE4OUeIlyBvQqP4mA2ZjfzDiPnY/8g==
X-Google-Smtp-Source: ABdhPJxif+l78sEbJJdKsiH8ykmRVFXgfjIEMQp6mIIDR6fG3FYqh07H4Sb4Zez91QRj+mw+y2eCTA==
X-Received: by 2002:ac2:4351:: with SMTP id o17mr10318434lfl.103.1595806490977;
        Sun, 26 Jul 2020 16:34:50 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id v25sm2028605ljg.95.2020.07.26.16.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 16:34:50 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 0/2 v2] RTL8366 VLAN callback fixes
Date:   Mon, 27 Jul 2020 01:34:38 +0200
Message-Id: <20200726233440.374390-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While we are pondering how to make the core set up the VLANs
the right way, let's merge the uncontroversial fixes.

Linus Walleij (2):
  net: dsa: rtl8366: Fix VLAN semantics
  net: dsa: rtl8366: Fix VLAN set-up

 drivers/net/dsa/rtl8366.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

-- 
2.26.2

