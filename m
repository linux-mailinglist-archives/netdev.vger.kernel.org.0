Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133D8E8FE3
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfJ2TZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:25:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36658 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfJ2TZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 15:25:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id w18so14961122wrt.3
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 12:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=732R4xR3A/k6HUU3GVmtB3WYsvu+q3JkRXeRh+HiqL4=;
        b=U3qLJ/NJWUc0fC+7xXwiZBdm2yxDnCzGgfIleYAqX3PT02sl7k3q7whQrH2sNQT7vM
         V4UzRY/rEeG24QCbFX53EIIVxTsDElycOEcLYJ+PYC1R1kGssmR1e/nyDg1MLY6fWAbS
         33syjqO7tjP/jQxUrYLg9hGRT495qoS5iMCPQO7+D+zzfccAkeitMMYlulOjcCoO8eQf
         WfJmpMa9suHX/FeTMrLUcmHDl8arw8EwYPyY4GpSLINgrMhpAT/6rEkFhSL5BO/NwOYe
         HrsdiGLqynsbtnnjB8ahLvc5WZzMgnjY7faI3m2mESE4c2n+0lY0aQp+0jCJlhKKg4ut
         xRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=732R4xR3A/k6HUU3GVmtB3WYsvu+q3JkRXeRh+HiqL4=;
        b=e2OZArHGoKupq+ROkutz5Kd3n7Pi9+xTcSzrNcoe3S8u8cDxIw4oEzGrgKjobhr/8g
         B/TZgSLinjdhQ7m9ROeq78HDK/3FrS1+wNv36WPB/da7naoVQMA9oFOtD/lPLUIZ1zWM
         QtqdgLWQM4llgUgU6KzQEGV9ZeonOe9SXCcdAaBPH2cR0xyW2ioiDR0Kzc+cs9Kz16kB
         bQy4fmEhsQaH7YoziM70YpG+zYhkY73GK1KRGYZuM49nFPHaXNY7104i5/VVjdaVT7R8
         Em8YK0Te5Z+zrJ3z9WBEZaI9IKqLw+foRjNAcz3nxvlYvS4zSUihwG4m/lfnLTA2bKlq
         zJng==
X-Gm-Message-State: APjAAAVj3IAgacdUH47BDIMkBMWtXxroLq9OtjEShZmwRAdBvSoNN2sD
        3/QQ56PHowdI84xcjJ1hj/d3I7Ea
X-Google-Smtp-Source: APXvYqx+Z9RyxAxoCYoks5QlFe4UszRAJunTsTmSVyurGAYFrLQMHNXQxyGFz+b/GVFb4H0C7Bd5jw==
X-Received: by 2002:adf:f70f:: with SMTP id r15mr21591676wrp.262.1572377136221;
        Tue, 29 Oct 2019 12:25:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:4af:f87a:946b:e2ec? (p200300EA8F176E0004AFF87A946BE2EC.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:4af:f87a:946b:e2ec])
        by smtp.googlemail.com with ESMTPSA id d20sm2669991wra.4.2019.10.29.12.25.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 12:25:35 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: marvell: add downshift support for 88E1145
Message-ID: <b5308aff-01ad-08f1-7b6c-eb8c5b995744@gmail.com>
Date:   Tue, 29 Oct 2019 20:25:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add downshift support for 88E1145, it uses the same downshift
configuration registers as 88E1111.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/marvell.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index cb6570ac6..b1fbd1937 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2394,6 +2394,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1111_get_tunable,
+		.set_tunable = m88e1111_set_tunable,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1149R,
-- 
2.23.0

