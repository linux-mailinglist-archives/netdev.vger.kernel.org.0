Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D4621F65A
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgGNPqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgGNPqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:46:09 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D972C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:46:09 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f12so22527496eja.9
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dgkFuCXpoImPRRz/Ik94h7JviPPGcigSGHam2ptQZw4=;
        b=QhRHwsUCrzjFyjvbvKbFkIxKUsJR6dw/a/4SRyeOCBvAs3bv4Zxcq3+XcFtCnyx1L2
         bWL44LMJKZyRSz+oC30o8kpRfZtd/YyLqSA1LOVvbSFe4fiGXODieOoXCUhdrOBtBDah
         LhGWIoDRwbqQAfk7FFwA2R+zt6+/AE8NBzPCh9I2NOqwTJS3KEBrJVdX2SMqGgWEpGX/
         in30tN8Dox3uUwyP1vAdFLHrbaf8tVvGXixsJ0AxfQ6DqzNxh/bQEih7/TJ9PuNgk1La
         FjhRHio+jiFo6N9mZr34ef7OpBSt/lJRxoZfXO3yScrsrIB5Q/3TP7hkigM4a+N7iRg/
         ypYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dgkFuCXpoImPRRz/Ik94h7JviPPGcigSGHam2ptQZw4=;
        b=KkWrUc17CzlN9csogG93KZoJ1E7AUHtKfuvUMNTbLxswT6OcohEwjIaFfupX+6ZFGp
         x4b2RVAv0GLqKCQARp+uVx9AylS6Bfqy/hROMptl7aNcr2eWU+Oef5X65CHU0+T6cIZk
         n8iCC4h3Z02sZujvSTn9G0kH3w/abkhOgijDSulw0zrCY9Uuueyu0gcwL7PeZw/MXGL+
         kOKims/y6mNhwLrIeVtpR3x7YtLbaWi2LI8Kmx3++nZOs4CXfzxvkilRotdSJGeSr4gY
         Jsp4oD/iw5L8RQmHO0KrOy2Dmz5hEZpF5x3j/HGITGTasG4796/jJg3myq7aXSsqK9fv
         a44g==
X-Gm-Message-State: AOAM533Z2O1pPC5DsMVARcAPs3H7E81sZviZuA++pGAOJvXWwFKORAKF
        rwoDo3noeFs8so3u0tpRxIJx/6SeqfE=
X-Google-Smtp-Source: ABdhPJxQ4k4imulS2z0hCNvC0aNk1pdAVC+hwWsOrRu4RYJ4Jjf/33fMSvEKKPbrW6TkEYwlBRehnw==
X-Received: by 2002:a17:906:4d4c:: with SMTP id b12mr5021529ejv.506.1594741567743;
        Tue, 14 Jul 2020 08:46:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b47b:7b5:8aff:5077? (p200300ea8f235700b47b07b58aff5077.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b47b:7b5:8aff:5077])
        by smtp.googlemail.com with ESMTPSA id w8sm12942011ejb.10.2020.07.14.08.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 08:46:07 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: realtek: add support for
 RTL8125B-internal PHY
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1cf79621-63ab-0886-3a23-2c9b3625c23f@gmail.com>
Message-ID: <c1205e46-0705-3cb8-6416-b130b04f8105@gmail.com>
Date:   Tue, 14 Jul 2020 17:45:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1cf79621-63ab-0886-3a23-2c9b3625c23f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek assigned a new PHY ID for the RTL8125B-internal PHY.
It's however compatible with the RTL8125A-internal PHY.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index c7229d022..95dbe5e8e 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -637,6 +637,18 @@ static struct phy_driver realtek_drvs[] = {
 		.write_page	= rtl821x_write_page,
 		.read_mmd	= rtl8125_read_mmd,
 		.write_mmd	= rtl8125_write_mmd,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001cc840),
+		.name		= "RTL8125B 2.5Gbps internal",
+		.get_features	= rtl8125_get_features,
+		.config_aneg	= rtl8125_config_aneg,
+		.read_status	= rtl8125_read_status,
+		.suspend	= genphy_suspend,
+		.resume		= rtlgen_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
+		.read_mmd	= rtl8125_read_mmd,
+		.write_mmd	= rtl8125_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.27.0


