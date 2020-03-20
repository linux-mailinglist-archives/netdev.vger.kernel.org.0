Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C07718D4DE
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCTQuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:50:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35305 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgCTQuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:50:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id m3so7141433wmi.0
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EDBXfxpcV4bB7dinrzAqUrsej7kZKK8DUViiXvPGzGI=;
        b=d14lAZ5KGFZArW7KxVvYkmySHMzL2ZjAz91AvxIy4YG9DV1sWPE/gy8aSmJlJE+MvI
         7c3PzFJpxGqgCg5FdVKO2eSGtp6F+GXZxzA153QhZH7fSnv0RTKWV7WAszfxjOJ2UfHE
         lPwrTLXI4Fcr7N+KgvfoAS0K87jCZonw4qXmwwoNMy/LxEgGWqtM8w0+4cGE9bNDBKbZ
         BhIPmwZl5Sv2jm4gNihF+Hs/coMa39N18HsmXP/dqgYwhXUNMjbV3MXpfmJooZFtfoLO
         kl2+9GxHkWiaRos06l5YN3QOg99WfCXlhLe6DrNgO2nvwhmll6pWzhs/Pc77vJruO00P
         52kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EDBXfxpcV4bB7dinrzAqUrsej7kZKK8DUViiXvPGzGI=;
        b=gtPQANXmSnmO8+GXvUW7GFbOSrqCto6Y3ArlxLbcLtA6MiWYw1HQPW9xsK/unocneC
         HpfekFuelWl56XQnUaI4I8MKIxC0Og7ZG2J5u/8RN5eGGrI1YlkvoZoOURtT5HxNm01N
         +DxFKWJ/qVTHGSVjSH6ZJwCDgLq3oTeZBdBa7Ff4DRTeS+qeZGP47IA5TSPmf7As3RIl
         sJ6z9Dsq16kHz8r3Rwr4+7V+/mxSoTElI2MJpaPuDFOLknRAmKWgGqT95FFyc5fp+KvV
         7iaLyupDxbz5BOp/zxXGnzkgFxU//Auy+QrlHbgRD3JTeMywFDUr+7UFdQaTZjlZH9WF
         du3Q==
X-Gm-Message-State: ANhLgQ1I+eGwYuS9+fTnmmWLSXTpDm+2vhULWt8U5KjbVp7WKS6JYyB/
        x2iTQZr1pHvuxQcybrlSOw9IPzY1
X-Google-Smtp-Source: ADFU+vuKzDvIQvTQlR2VzTS4yR5oF+D+aRrgkrUjqJlIMFYVti1f9Ry/OT3HbJkvwve22OhVbsKv1A==
X-Received: by 2002:a05:600c:2947:: with SMTP id n7mr11854352wmd.13.1584723021184;
        Fri, 20 Mar 2020 09:50:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:b52a:38f:362f:3e41? (p200300EA8F296000B52A038F362F3E41.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b52a:38f:362f:3e41])
        by smtp.googlemail.com with ESMTPSA id n9sm8652668wmi.23.2020.03.20.09.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 09:50:20 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/3] net: phy: add and use phy_check_downshift
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <6e451e53-803f-d277-800a-ff042fb8a858@gmail.com>
Date:   Fri, 20 Mar 2020 17:50:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far PHY drivers have to check whether a downshift occurred to be
able to notify the user. To make life of drivers authors a little bit
easier move the downshift notification to phylib. phy_check_downshift()
compares the highest mutually advertised speed with the actual value
of phydev->speed (typically read by the PHY driver from a
vendor-specific register) to detect a downshift.

v2: Add downshift hint to phy_print_status().

Heiner Kallweit (3):
  net: phy: add and use phy_check_downshift
  net: phy: marvell: remove downshift warning now that phylib takes care
  net: phy: aquantia: remove downshift warning now that phylib takes
    care

 drivers/net/phy/aquantia_main.c | 25 +---------------------
 drivers/net/phy/marvell.c       | 24 ---------------------
 drivers/net/phy/phy-core.c      | 38 +++++++++++++++++++++++++++++++++
 drivers/net/phy/phy.c           |  4 +++-
 include/linux/phy.h             |  3 +++
 5 files changed, 45 insertions(+), 49 deletions(-)

-- 
2.25.2

