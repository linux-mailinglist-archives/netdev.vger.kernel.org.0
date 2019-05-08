Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C216E9F
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 03:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfEHBaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 21:30:20 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38674 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEHBaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 21:30:20 -0400
Received: by mail-lj1-f195.google.com with SMTP id u21so6867941lja.5;
        Tue, 07 May 2019 18:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZHTiBxRO8PZN7WRvOIH6EO3lTDXQqkdpmwve/AMQ14s=;
        b=NYJnF/vdWYY3+45C4CS5RhJAjXCsEAPxIulDLLQ6iYVtPYnLWxPVxq9CqNc0HmxTJB
         XBxF3wcT03xkWNcbkSwwDJQXgxwaeMNuGY1dQdpnlEfqGrXZ2lxFETWb3ZH4vCcakHxM
         Vj3zn7IeaKzaY1stGwMiZjg/4sm9KYw9MUkVVcObZBa99z0oc7DTNQbh4MhlxLl0gWWr
         KgtppJtMXlnzJj3WJElmtoUPdzTagnmndXfapovsJoTplDpDgmGLrkHS0k+U5jhprTqz
         CtqeXHFtztVbbHu0gu3gPIdA2EuQAFY7laydNlOeqVyKzf/2VT+vrDj4yv94jc/WKVF0
         cQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZHTiBxRO8PZN7WRvOIH6EO3lTDXQqkdpmwve/AMQ14s=;
        b=h+WVREzjyQXdVHBDeG0nivq0azQxfazyDhUwBGOvlF8yeLKxBs3/o9M4HK1ouCuoQ9
         S95JtNfs+oQy/zEX6jXx302P3dwkndm3U7hvtoTgUcXdjEKLtI+Rtx1ukELyf4dqDN6M
         Eo8NAQCiKNr0g50BLNQETkdgZtzlKXrrvRm3cv5hRDEViyIpCpuvFFPQ3n+pQc4stwgX
         jV50zhjrBP1aDxu5Ycwt/WKQW8TEJ/o1GJvBlDg4QbQifDIez9YErlm60qBAgOX89gK2
         sarcWaFHIvOC6ECS9KmXd5dw6WhkZPk3WL6plZ3h/qvnh/kRWMWyHthiLSXkcSqdsh/D
         gl7Q==
X-Gm-Message-State: APjAAAWtD2Tcvi8asmiPzc+mNQkR+mQIIr9AoSQ4yKnFD0Cp/N33bitF
        +vZiD8rQ3tw5bulFi53XRsc=
X-Google-Smtp-Source: APXvYqyAsUMwpWXAOtdhDEmxGIZRIN4yMb7ur/EOIjbTpfMKkRewkvBSXg5TPY/sFB6yvFz3z36mSA==
X-Received: by 2002:a2e:5b18:: with SMTP id p24mr5710942ljb.50.1557279017872;
        Tue, 07 May 2019 18:30:17 -0700 (PDT)
Received: from localhost.localdomain ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id o1sm3524339ljd.74.2019.05.07.18.30.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 18:30:16 -0700 (PDT)
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] net: phy: realtek: Fix RGMII TX/RX-delays initial config of rtl8211(e|f)
Date:   Wed,  8 May 2019 04:29:18 +0300
Message-Id: <20190508012920.13710-1-fancer.lancer@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190426212112.5624-1-fancer.lancer@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been discovered that RX/TX delays of rtl8211e ethernet PHY
can be configured via a MDIO register hidden in the extension pages
layout. Particularly the extension page 0xa4 provides a register 0x1c,
which bits 1 and 2 control the described delays. They are used to
implement the "rgmii-{id,rxid,txid}" phy-mode support in patch 1.

The second patch makes sure the rtl8211f TX-delay is configured only
if RGMII interface mode is specified including the rgmii-rxid one.
In other cases (most importantly for NA mode) the delays are supposed
to be preconfigured by some other software or hardware and should be
left as is without any modification. The similar thing is also done
for rtl8211e in the patch 1 of this series.

Signed-off-by: Serge Semin <fancer.lancer@gmail.com>

Changelog v3
- Add this cover-letter.
- Add Andrew' Reviewed-by tag to patch 1.
- Accept RGMII_RXID interface mode for rtl8211f and clear the TX_DELAY
  bit in this case.
- Initialize ret variable with 0 to prevent the "may be used uninitialized"
  warning in patch 1.


Serge Semin (2):
  net: phy: realtek: Add rtl8211e rx/tx delays config
  net: phy: realtek: Change TX-delay setting for RGMII modes only

 drivers/net/phy/realtek.c | 70 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

-- 
2.21.0

