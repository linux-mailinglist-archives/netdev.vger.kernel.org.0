Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C49475174
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 04:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhLODlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 22:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhLODlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 22:41:55 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37493C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 19:41:55 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id kl7so2308548qvb.3
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 19:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2wlVPpuSrlrq2/3b5Q3d+JfiAzzAY/Lgb3NCBAaE4b8=;
        b=Aro2CH293RqcEFyIBYMix5hDSZPQ7O/mWLIFtpMXWJupfOhxlR1ZRj9bVJhIfa01gu
         QTP13jr9T87b6h7FYPpWga2J7TsGkXscwF5VnTcyehKIE3GXSUwZpZJJZfQJbzxZp4jV
         FOzgl9VJC/1DrGWEwyPs/MQw6uK+1IlH1WixlYrdq6rjPOHHhdzb6rZF92PtMvS68CMe
         XeRaHFOPE1AhgYcMaQyy2GzllRn4/6SDmyFKUaYMkvrk9m3h+AXJ44RsyYeeDiJ1tkYi
         RXz888CF00BtETMb04bcZWXjaPaPpnvsHaN8eFcSIn5zWQPDeLIA/QhnXrec0Ug+NXoZ
         cMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2wlVPpuSrlrq2/3b5Q3d+JfiAzzAY/Lgb3NCBAaE4b8=;
        b=A9379eJoWfWud9d5xtlAZd1yfng+QHecKO/lwAlHVfV9rxH4zeg3E+2fo6dBoEXqrA
         IzPkE1zE/HbstKCF7l0Bp8yESn67fc3M68eRvwe6XJmj2xOCWLFWGuI+TgGUXRROZi4M
         clSvtrSAZzbPXFPzQzJQ816rKarZaGKtOEoADjklR/DGRuFSvkFJ9JneKfK+cx16LZKI
         m09K68sR7qi+Mji42pywgzYQTk7gfr5Ng+fV1eVCd3ok3x9qYCbsH2U5rIzORDC/UjdT
         jAwbaY0Jbswb/3X+4faXUwO8pCK0hS6Pz+0UpDOUSGlKBwJgZEgkQYqxsj1DGtboD4II
         xrmw==
X-Gm-Message-State: AOAM531TFdw9pHmytaLYCn1uLHKp6vszizdWSv8Pwton8ql3iQq8W2dN
        cSIC0cnacMYFZRymFguc75buIEkK+FjC0w==
X-Google-Smtp-Source: ABdhPJwx2Hm5zVxy++0oq/p7KKk0L/+Nv7ah/vY1N8Iizrz+a9v6VLP0y5mbt6YQ5RaiOhFJf9BQ1A==
X-Received: by 2002:ad4:4eec:: with SMTP id dv12mr9385417qvb.23.1639539713997;
        Tue, 14 Dec 2021 19:41:53 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id s7sm614316qta.31.2021.12.14.19.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 19:41:53 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     alsi@bang-olufsen.dk, linus.walleij@linaro.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH net-next] net: dsa: rtl8365mb: add GMII as user port mode
Date:   Wed, 15 Dec 2021 00:41:28 -0300
Message-Id: <20211215034128.18199-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Recent net-next fails to initialize ports with:

 realtek-smi switch: phy mode gmii is unsupported on port 0
 realtek-smi switch lan5 (uninitialized): validation of gmii with
 support 0000000,00000000,000062ef and advertisement
 0000000,00000000,000062ef failed: -22
 realtek-smi switch lan5 (uninitialized): failed to connect to PHY:
 -EINVAL
 realtek-smi switch lan5 (uninitialized): error -22 setting up PHY
 for tree 1, switch 0, port 0

Current net branch(3dd7d40b43663f58d11ee7a3d3798813b26a48f1) is not
affected.

I also noticed the same issue before with older versions but using
a MDIO interface driver, not realtek-smi.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/rtl8365mb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/rtl8365mb.c
index 2ac68c867636..3b729544798b 100644
--- a/drivers/net/dsa/rtl8365mb.c
+++ b/drivers/net/dsa/rtl8365mb.c
@@ -900,7 +900,8 @@ static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
 {
 	if (dsa_is_user_port(ds, port) &&
 	    (interface == PHY_INTERFACE_MODE_NA ||
-	     interface == PHY_INTERFACE_MODE_INTERNAL))
+	     interface == PHY_INTERFACE_MODE_INTERNAL ||
+	     interface == PHY_INTERFACE_MODE_GMII))
 		/* Internal PHY */
 		return true;
 	else if (dsa_is_cpu_port(ds, port) &&
-- 
2.34.0

