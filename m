Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B714E164F6E
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgBSUAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:00:54 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40419 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSUAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 15:00:54 -0500
Received: by mail-pl1-f196.google.com with SMTP id y1so506426plp.7;
        Wed, 19 Feb 2020 12:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=j39iNuqnLZOZPlYVTl/1tU2TtodnAbm1B4Eys0lmch8=;
        b=ggGElA4L7LXM+awgeiQt1quqxa+ZBU7lyljjhO4bX9XjvYl0OV4O5WedmANcfCef7v
         +uI9/xzuQhYw4FFYt1uacKCwNj6LGMOrXaI9L9gMlqkAuApbB3cx1jVc6BtAe+03PF5S
         5Qs39aLuMuCQbxWooJbyuZAPSx8DEmnJqHd4FqWTlpuMeVtZzxjBT4stsSuPIVQBzJCD
         6n9PIW9WBPqj2z8K5GWBiBcGzKkHKTr649Q4Py0iEFlJypmmPqhGJJT3AW/AY3/ThNmU
         q0tfSOF8VaooA26DNvCCx54Fw+2XhL1Rs6rLHDv5nHysNCjPrJ2gD1mKWON6KnzOjRZn
         Ot0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j39iNuqnLZOZPlYVTl/1tU2TtodnAbm1B4Eys0lmch8=;
        b=f0T022T72X/nNljA+BMD9Tv+RAes6mjZpMz2iuwTN9E29g25BY8xGn3AKPAXaC0+me
         c2f+/k8EcxRwu12YTl6KSgg5MEFU1tL200PcdAjGtptMbWVauTz5OyiukO0jTt0nF33I
         ARyAnsLIAukuBykucQmtM3yXIV/OnL7DP+K1Th/pV5NkpDO/UhTp1olnkUmkl1PYhJ76
         K+cPLfrgeNgXh9NvL4bOjAgLsLbCosXNQ7O/E223BIG0aDN9AlbGNqlApyitdlBSNsHf
         pHSjHLnwp+yOU0eFNvInAfwYhdIZ4IbXoQ4s6nG+fxo7GulRzBMnqAlJtPcb8Phuc5/W
         W2DQ==
X-Gm-Message-State: APjAAAU65W9KR8NH+79GPTRhdXd2iH5D4uBFcJ73XTRs/2ew5Xk+dBg6
        Q8CjZVJn/lcDYAwL8flgjDLB8KIJ
X-Google-Smtp-Source: APXvYqzljhQgrwv6nQj10fhCXQPCDkCHOHPTAbX8cuu8xzTfXclL6CaJdRX3GW6vEv3vvPz09u9T9g==
X-Received: by 2002:a17:902:8486:: with SMTP id c6mr28535078plo.147.1582142453327;
        Wed, 19 Feb 2020 12:00:53 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2sm625926pjv.18.2020.02.19.12.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 12:00:52 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 0/3] net: phy: Better support for BCM54810
Date:   Wed, 19 Feb 2020 12:00:46 -0800
Message-Id: <20200219200049.12512-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Andrew, Heiner,

This patch series updates the broadcom PHY driver to better support the
BCM54810 and allow it to make use of the exiting
bcm54xx_adjust_rxrefclk() as well as fix suspend/resume for it.

Changes in v2:

- added Reviewed-by tags from Andrew for patches #1 and #3
- expanded commit message in #2 to explain the change

Florian Fainelli (3):
  net: phy: broadcom: Allow BCM54810 to use bcm54xx_adjust_rxrefclk()
  net: phy: broadcom: Have bcm54xx_adjust_rxrefclk() check for flags
  net: phy: broadcom: Wire suspend/resume for BCM54810

 drivers/net/phy/broadcom.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

-- 
2.17.1

