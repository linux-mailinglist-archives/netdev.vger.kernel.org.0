Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD84890FFF
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfHQKa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 06:30:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50729 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfHQKaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 06:30:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so5951714wml.0
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 03:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=upg+bZO2tl76NuL5qRGzzUNcHidJHyMzxJdBLW1vxSA=;
        b=UqQU7ZVCLDuOtj5cpUVLBciSpHee/z3pfnfGiiDuvw9TeetpSSnAG4DYuq1kQbc85d
         9k30a5WDZiFiuW5uEsZPY9dTtbyXH0qyfffY50czRnyQN7qNl5XVnjgiXOiNOTUI5ygf
         6v+hDyQGtXg9wfSswjCKzDlus+n6E7awUFv2YNxGJmRxdShIP+O5GyFVdr6zeVlsRQZ/
         4ouksB19dRcxlPgmC2TEHs+I0Ak7YXIyCrLxai4k862PLlXHq9j3Rx/AJfruMsUrjbP0
         31s9AsNoXNUUxPE8b7lnSTuo8mE06uWvsoGssPxD8RLJ8sk0gjfeWz3gWSN+FgHEFNOn
         ndGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upg+bZO2tl76NuL5qRGzzUNcHidJHyMzxJdBLW1vxSA=;
        b=gxTtWgvTaPUq6hEdV2P23ZkNZFYUpbwtNTShUKHanFhllaKxXzjYkb/GHzzaocc9R6
         H1ephsPQdubH9ukFEj9vuxxqhRo5N8pDShM+XRmi3yF1pcx5doh+1YBMlc07pultrSpk
         my7ifWgOzFIZ2Hsrfn+oiGH+wC7XNKRrZ/1XZf+q7jJdxCWc0kebJBpxa4Sc36zGV73+
         1vyiFwH6TnrlWu/IsRTJ7R89qaxUh8wlpbxmjsIKlqtk6ElQ2oNu3vYSths0z3wa4EuY
         PJYp3WEicTvVs0UTWjHDASzGtvpEFf7cf/QBAhH7gLfYvOA6rJFlQUZQsXD4SiFZ/jL/
         tsNQ==
X-Gm-Message-State: APjAAAXv2oW6wkovvabKI5Vtia0Bw4mbIC9xNcEs9jNeSFi5FGCbV9Xg
        iIJDmpYegnSJ280Y9ssC364=
X-Google-Smtp-Source: APXvYqy1XVrWM83AAVaa9HGJ+ln1uvqCFxtzBtkXtH/IFLshi3NwRTSkUorZpFFabuTMi3r8TXEHFw==
X-Received: by 2002:a1c:6504:: with SMTP id z4mr10920954wmb.172.1566037853098;
        Sat, 17 Aug 2019 03:30:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f47:db00:ec01:10b1:c9a3:2488? (p200300EA8F47DB00EC0110B1C9A32488.dip0.t-ipconnect.de. [2003:ea:8f47:db00:ec01:10b1:c9a3:2488])
        by smtp.googlemail.com with ESMTPSA id l3sm14010973wrb.41.2019.08.17.03.30.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 03:30:52 -0700 (PDT)
Subject: [PATCH net-next v3 2/3] net: dsa: remove calls to genphy_config_init
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
Message-ID: <347f42f8-ad9e-041e-0886-534162be64a9@gmail.com>
Date:   Sat, 17 Aug 2019 12:29:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supported PHY features are either auto-detected or explicitly set.
In both cases calling genphy_config_init isn't needed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/dsa/port.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index f071acf28..f75301456 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -538,10 +538,6 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 		return PTR_ERR(phydev);
 
 	if (enable) {
-		err = genphy_config_init(phydev);
-		if (err < 0)
-			goto err_put_dev;
-
 		err = genphy_resume(phydev);
 		if (err < 0)
 			goto err_put_dev;
@@ -589,7 +585,6 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 		mode = PHY_INTERFACE_MODE_NA;
 	phydev->interface = mode;
 
-	genphy_config_init(phydev);
 	genphy_read_status(phydev);
 
 	if (ds->ops->adjust_link)
-- 
2.22.1


