Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05181141E2F
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgASNbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:31:16 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34850 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgASNbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:31:16 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so12053051wmb.0
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 05:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=GzsQbfGEab7xUly0pH19a75zLOH6QohOwz3MooVS2Hg=;
        b=UCM7A2/M/7LDjS2De0nLKZj7C8YRhxq66KPnyjWWeS/a39jBh+cp0SYrvlYwwM0GhS
         sZBCDNLzMgOf/L28N8gv7DALt8bsI44orZHp1/PkFvJOQO0jJxIaloTCUglS3gB+l2t5
         /FFIsNRvTe7l7v5iHI5ijpZ5PrwziPnkWl7gGZpRTdOBBjeX3zOLc24PfYsmv2op/IWZ
         lHrLqY4f+N5I0Il1be9wY7umLNv4vwHOz2Q0Fak3098cUj3SV1vDduxruurgbnWR8PFv
         HRGAkw6P1JOrlpTs+L+Ch2wizYS8s2jhn36MogqII0gCBFWZgx/Ur6Q86TY7g0bvSwYY
         E8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=GzsQbfGEab7xUly0pH19a75zLOH6QohOwz3MooVS2Hg=;
        b=G6Kgh39HvS/ZoxtS9+KUwrBn2G0gmeA51e9rAF/x3yY4gBThnrWh68s1H5LWUSAUQv
         6t2hfnzEVv7fD04JiT1qHhK5WELiDFoeindyB7UF0Awgza5z6sADZXCntnNO9PrDu4ZZ
         zJ3VX8N3oVv9VW+9yxHzg5pt4lDho1m3M5eqx8zDY1/VWOJBOPTUwE9fThWyBKkpzG4Y
         yTEQTh5aTFccfD8HAN1Oi2RQuR9zvf8oR8YcgC38ROLUnzyt0BIiPzTeqePTNC5QtH1e
         RmgyjA1FP/PKsnn8BvUhWJcsgQcC9oIWpMbNU4JZfHu1sxINDVVMozSIyRUIoa5YxLVH
         XfIw==
X-Gm-Message-State: APjAAAWcza1em28hHTSwtPvuK1q51pALALCCey4dAxftcGgw5p4NCm5b
        CbcQK8h/p6w41GwgFFsldFNAsJpg
X-Google-Smtp-Source: APXvYqwutsCbsGMuQrkrCXHGkdnWDE+kgUT8RIDmYhYEWdH9ozEz/kgBgcwenSIFCM/De4aErmjL6w==
X-Received: by 2002:a1c:6755:: with SMTP id b82mr14712006wmc.126.1579440673648;
        Sun, 19 Jan 2020 05:31:13 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id o4sm41636650wrx.25.2020.01.19.05.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 05:31:13 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
Message-ID: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
Date:   Sun, 19 Jan 2020 14:31:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of network drivers has the same glue code to use phy_mii_ioctl
as ndo_do_ioctl handler. So let's add such a generic ndo_do_ioctl
handler to phylib. As first user convert r8169.

Heiner Kallweit (2):
  net: phy: add generic ndo_do_ioctl handler phy_do_ioctl
  r8169: use generic ndo_do_ioctl handler phy_do_ioctl

 drivers/net/ethernet/realtek/r8169_main.c | 12 +-----------
 drivers/net/phy/phy.c                     | 15 +++++++++++++++
 include/linux/phy.h                       |  1 +
 3 files changed, 17 insertions(+), 11 deletions(-)

-- 
2.25.0

