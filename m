Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9704D410C76
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhISRBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhISRBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 13:01:50 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943C3C061574;
        Sun, 19 Sep 2021 10:00:24 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h17so51255090edj.6;
        Sun, 19 Sep 2021 10:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nVoyvvbClTh7u6Tn5R605abQeeTor6E9GHrbW/X2BVs=;
        b=Jwngxk3TLKOIX9ruU6rI7Aouc84xiNlN+YhUMZVpbzQVh7E79QSWbps23mNDjyFDRD
         lsNvpOTEVgCZGe1diZQHvjBiuHLb8YunPgLlPybIxGk19UZX3Vu1qepPkoe01cA8dK2+
         MVCqGQo+sYQgESBOfQmgH6sfxYduPhimmQkENZfPp1fXhD8KDV5Jq6+asDoOZA+4EI/g
         38PoVfa8KYYCzlHWVqAmELdA4+MnIkUXMKT05M9Lu2DDfg3Mgrwfnk3XN2LSxzK3tGR7
         CBGlbDaMDy0OfrPwKtF4o7GPVUsamQCUzZ+FvqaeVvYAyhnkexRUxAj0XUs1166paHAY
         TdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nVoyvvbClTh7u6Tn5R605abQeeTor6E9GHrbW/X2BVs=;
        b=LiKXJsjFWFZGz6EyxYvXGIenCZLlqtLIONZdzLLHO32qSjv0/Ctw3fkZlS7v+peKqq
         rKeJwDM/FgSvCSfMDx6SjcHs5H0vOJtrFsQE43PTtx0/LY+I0rx5pppHFIGsTaZyIgeq
         5++1pqzumhEVJ6VwPt7VD3gS2rQcC91D7kqNW7bah41Yusj0YdxKiIHF6XcYujqt5XCI
         bp0mZC1dc1QsTF+tO53wiReeHTRE5TxL0/E4LxcLzICDxEGczsRLUXiRTMAkUkj9aJa8
         h0nd8CpynSJP98gJv8U4DbdsLEXhqDuuaVoLvWqLlDprCY8IM68nXME5WWeKcnL++H9t
         mzTA==
X-Gm-Message-State: AOAM531AzBOlT2OkWi/3EKBXH/nS7zgfkO6xO7xwIvHiYWBK3h51brTr
        l+hRvQyzMDbHgzcNN3RAE24=
X-Google-Smtp-Source: ABdhPJwMt716RzcwKkrdTAZ0M+nfkDLiU6OG6uxDg67egWEwa1RE5N3XL2Vm9PfQwsnIBo+vcYAXHw==
X-Received: by 2002:a17:906:c014:: with SMTP id e20mr15574730ejz.166.1632070823023;
        Sun, 19 Sep 2021 10:00:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id a15sm6101760edr.2.2021.09.19.10.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 10:00:22 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 0/3] Improve support for qca8327 internal
Date:   Sun, 19 Sep 2021 18:28:14 +0200
Message-Id: <20210919162817.26924-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With more test with the qca8327 switch, it was discovered that the
internal phy can have 2 different phy id based on the switch serial
code. This patch address this and report the 2 different variant.
Also adds support for resume/suspend as it was requested in another
patch and improve the spacing and naming following how other phy are
defined in the same driver.

v2:
- Adds cover letter
- use genphy_suspend/resume generic function

Ansuel Smith (3):
  net: phy: at803x: add support for qca 8327 A variant internal phy
  net: phy: at803x: add resume/suspend function to qca83xx phy
  net: phy: at803x: fix spacing and improve name for 83xx phy

 drivers/net/phy/at803x.c | 67 ++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 23 deletions(-)

-- 
2.32.0

