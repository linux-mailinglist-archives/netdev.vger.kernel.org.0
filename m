Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0392C3CF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfE1KBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:01:18 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:37809 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfE1KBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:01:18 -0400
Received: by mail-lj1-f177.google.com with SMTP id h19so8689888ljj.4
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 03:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=X8tkbQZVCmZmpcviaI42T8EO/nRMmnbxkiCvDDBcq+E=;
        b=Kzl3cLBi6pQwgYWKxS5Ok/j+SC2I3RVSdNfZ9CXY7YlNMlDZhMbc6oBTHb/yQ2K1h2
         Z6KfrDu+AtbrHu1WPnwespjbkxXp/FatoqYJwzwhnouLo94OIPOAgoCV6VEHfA+bwUb9
         g9FfVeaW2z5VpLPqqkMe8pcSHahoo23/JzG2djWkW60A7OVP5Ty8OlBG1z680duS2L7O
         c0rnB2RNen+2pGxMpf9z7Wz0Cqzg3qzAzwl+B7gFxsavtfhLK2yA+umPdcRJWqsOvPbD
         i4xqVOr2nBuAGa1SzSo8BN33zy6PcRuaGED8RsmZSB/Gl9kZwra7EewdT41QpOzqs3VO
         cjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=X8tkbQZVCmZmpcviaI42T8EO/nRMmnbxkiCvDDBcq+E=;
        b=tSu+sXlwokyiqEDK5ait33CNKNt9/YTy/n1X4zbT7cdU4Ey3Lg0vetU509yTDiVuaJ
         Ml+ZZdtj+2NjgdeXJAGDY3dE2t4MJVRJMPENB7zIcZ+ECRFTYcFVKRS1jRADMOMHdEUs
         0XO+QuIGyJqvZVhIHPlrjjP7k/FTdoeX7LTpY39eisDWAS9Ksf898IInQN+/TulsLNlf
         aPjhnBCDTwdGsqO2wkUpou+kih6SOSllQKrvBHN+TSgIYOelUkSXYDOc3qQQpUCFg/Px
         CZu5aqdFb0XFJ73t5dVn7HD+MyZJGlS/A1J/ggDL6DM0sgCfab8xX+nXsOzLLt+9seXR
         uM6Q==
X-Gm-Message-State: APjAAAXnAoKlqTo+GI4wSIkuAvvQi21K5JzZ+Uz3fKA87DhAboK5bpMw
        BW74LoM3Rd/j8+I6pWKXzBteLa8hn2508g==
X-Google-Smtp-Source: APXvYqzx/AG/anHiyj3QiFg1UxgyDxuP+PBVFU4q9GVO2rtkp7+o5LzA0RlVZTYw3SBK+aub5nRHAQ==
X-Received: by 2002:a2e:b0d0:: with SMTP id g16mr38102816ljl.132.1559037676255;
        Tue, 28 May 2019 03:01:16 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id x28sm581816lfc.2.2019.05.28.03.01.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 03:01:15 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v3 0/4] net: phy: dp83867: add some fixes
Date:   Tue, 28 May 2019 13:00:48 +0300
Message-Id: <20190528100052.8023-1-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3: use phy_modify_mmd()
v2: fix minor comments by Heiner Kallweit and Florian Fainelli

Max Uvarov (4):
  net: phy: dp83867: fix speed 10 in sgmii mode
  net: phy: dp83867: increase SGMII autoneg timer duration
  net: phy: dp83867: do not call config_init twice
  net: phy: dp83867: Set up RGMII TX delay

 drivers/net/phy/dp83867.c | 41 +++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

-- 
2.17.1

