Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCAE8A927
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfHLVSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:18:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43734 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfHLVS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:18:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so31249516wru.10
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=18Owpe5aMiH5TvMMQBE8d8UWZ+KGRIGlZ7yeAZC6dV4=;
        b=DFZz4ZbH03Pw1llUpyhekWj/gpTqwNKpaWWbvdivOtp9J0mHD6rRM7rXKasELzBGq7
         2KJVF7xn/Vk1eeJSMAcs2+nOhz08MWntOgiLmVx7IHPjWGWjWBlstux5zRDsByYD2RlF
         J0Jsuq4CAky5t1b4PtoVzojVsuzW4eKt4mMTjZZV79dS1GSdiIPGT688xKZBZQwRwzPV
         z6rLKHctK5pvGQstrVgYFxPNYn0EVcZl8LCnXlbmjMUWuse+UGQO4BA1uCUFSnuny15B
         tFwxSAcxb6jf9zFCv7mecsQogZbGeLniWBmnrwfOTzhrbQLSDJeUzAwy1UhXdQEA7dsW
         EeIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=18Owpe5aMiH5TvMMQBE8d8UWZ+KGRIGlZ7yeAZC6dV4=;
        b=jElXyNVeg8MSxcxyo8ycivyRiS4sSexRY7BxA8f/IByNghzVWNy+lHZtb7cjgNuX5a
         zz0ZEz16xQdB1y7SgJTVujVo3M6Lqu01AOvsTez/v1GnaPkAeQqXuIXbv2K9E9qK4/UX
         BvWzoqq0CdXEelg0PJBfz7bj01JaI8mJhafqzHFpq6q7qQ4bXyyZdlsjV/bYuBo874PJ
         8MqbU8AJ53YrjX17uplp5d4owRDWvkMGmY/t0iXNiFTveb+G8WDNGoeNpEZo4xSvMiJk
         Bh9B3BJ6ss+g+TIT1pO5peOaFtdp8Jp84StDOYl/sj3NCdVjNXAvKgxkey8w3LYEpsmV
         hQNg==
X-Gm-Message-State: APjAAAXHed9uwIDko/QZIlNxgxzx41hcW7db+tkcBYB1GkBIWAh/dboK
        SopnjvoRBgUtqy7GR9tLpjT+pR6N
X-Google-Smtp-Source: APXvYqy+2orwQFS3F30JcIwfQeQo7MJ6wbbIyzGcVNmOkKorjpX+WuA2R+WOLHa2A5AI1hClEsL56A==
X-Received: by 2002:adf:dc0f:: with SMTP id t15mr22592403wri.50.1565644707177;
        Mon, 12 Aug 2019 14:18:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id q20sm54072527wrc.79.2019.08.12.14.18.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:18:26 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/3] net: phy: let phy_speed_down/up support speeds
 >1Gbps
Message-ID: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
Date:   Mon, 12 Aug 2019 23:18:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far phy_speed_down/up can be used up to 1Gbps only. Remove this
restriction and add needed helpers to phy-core.c

Heiner Kallweit (3):
  net: phy: add __set_linkmode_max_speed
  net: phy: add __phy_speed_down and phy_resolve_min_speed
  net: phy: let phy_speed_down/up support speeds >1Gbps

 drivers/net/phy/phy-core.c | 39 +++++++++++++++++++++++--
 drivers/net/phy/phy.c      | 60 ++++++++++----------------------------
 include/linux/phy.h        |  3 ++
 3 files changed, 56 insertions(+), 46 deletions(-)

-- 
2.22.0

