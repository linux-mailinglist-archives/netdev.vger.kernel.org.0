Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29B5474B82
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhLNTHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbhLNTHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 14:07:15 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B97C06173E
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 11:07:15 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id q14so19378982qtx.10
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 11:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2wlVPpuSrlrq2/3b5Q3d+JfiAzzAY/Lgb3NCBAaE4b8=;
        b=dyDEwgomvbK/Orf+H4ZZzhPvOP/xqgN7bGGr0r4ODWmZEsfsS/nWg1nVQMTHUOL9aK
         vLX3qZcEL31fCzotOShmijl366OnovUploW85pX0nF/OJasP5vvv5VlYU1Yak8cKJGO/
         T4drZpGyidYerIGDeJLcvXdjH8Sip9P2ZN3+gXcK7RbHDQwjzQqy0IyUflvi5u7Aijzv
         DEoUM2hefu4N28gBvl37YTX+/UqfoMI8k3yPDlTmpMjSUprZB1KrkJdqIGpgqevq0yYl
         8L54vdoxUx2cE+wOSniWCDUN+39JqL549dtjHRDqRJ8P8siwXaS9GOaZLFv0oi2138Yf
         Teow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2wlVPpuSrlrq2/3b5Q3d+JfiAzzAY/Lgb3NCBAaE4b8=;
        b=dFpd6Tjn/cdop2jHh58udE4wLF1QjajUGbtOXtjsaklKaOfIE3BHTnn4MOQycJrKiy
         8VFay5sWSZyEiFvQYzfcLcDM4iyTrZXtZ3u5peGlSU0GOLnYdlPt3RysTRRGBSos9x64
         SL4qRpQtE3/+gGFer5Qo1i+UcPOyS7W6y/pOaBa2SEknTqSXVbqQo3e1C00Hywo68FaQ
         +Xmc1xQ6Mt2dR0G2K8mQ9uuGtoIk+uy/zesHmGqPqC+uurMRbv9MUL8GTqkHRR3riJuU
         d6tuj8crqG9eV3sXUKQDZCcaJ8Xk0LkQ61Gmr6kQvKCePXbvW66zpWT3l+72209f1Npl
         xMVA==
X-Gm-Message-State: AOAM532zjCSITn8I69ucBbM6A7wNjVvySe9kPSX65ZvHT63ykQNjahK2
        aZtg7VLDA0OtfCm/i05isPofU5K/iqw=
X-Google-Smtp-Source: ABdhPJwE1Fr9C33TNwX+6wmexP65WH2O1NuY5JqTlsFb6QuQDrNebrCgZXxMz9u+tIRArVTi47fkeA==
X-Received: by 2002:ac8:4e4b:: with SMTP id e11mr8221683qtw.503.1639508834015;
        Tue, 14 Dec 2021 11:07:14 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id r16sm592936qta.46.2021.12.14.11.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 11:07:13 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     alsi@bang-olufsen.dk,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH net-next] net: dsa: rtl8365mb: add GMII as user port mode
Date:   Tue, 14 Dec 2021 16:07:05 -0300
Message-Id: <20211214190705.12581-1-luizluca@gmail.com>
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

