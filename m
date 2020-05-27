Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401A91E51ED
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgE0Xlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgE0Xla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:30 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C98C08C5C4
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:29 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y13so8120623eju.2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1omMY1FkHNIoCi3WwK8lCi6qHFZnw91kkZg+tgZteqY=;
        b=QrKh0ospKdBza+F8YM5Mra8aBwQzw1xMAg3C6ALTtI39VakmaBWu/Gw8dlDXj0Jp9W
         lolLOvsP3ZyeixRLptJAit9DWhyPMO/J3Xubm2XSiSvYXEiEN7mFjuBkCuwB5BC0qCsw
         WiZAljBX0lEpjo/825Qn1Q40/EOt5CV+vaDxN/BOCFeGwmBuoMlyNd2NhvQ0jF+gzu/H
         BJxmljUAk00gdaBi1fh3lhEogwgRfHn0jrFs0HelO99yf7356FQ/51vyfNvxu7YMKSZ1
         fIRt2P/LcZvCCMVyv7Jz3I0KaKXJJ0VUlfbm7nNRSGY5vqnGbwAGh5AC2qpYfVce4Ywe
         fMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1omMY1FkHNIoCi3WwK8lCi6qHFZnw91kkZg+tgZteqY=;
        b=rgmFfbtRG/4K2WKzQ9qI2fwRTgIwrb7IQetbvQyLLq32G/NuHFL3vHphTR1in+0mlO
         Z/M3BS6LTa4CYAbtjTsdC+9S7+OLF21qtSGl5kGBzunKj2Z96c9UzaZ32sg8hayvDKNG
         5HeM3y0NnMQPB+E45bfRgsDuuaBAlu+A1GD70ISifGsEWqwRFsMv60stYnUjgb0Fytwh
         pUuEQPL/TMnerg+UMNqdMZp5hWCSvA6hb/XRv/IX1DFoDKaIU4UhWaKcOlEN9v1JD9xo
         4ZO72JRBlMYw1dkn3XfjX5yrjUmIdp/gYVKGDGwkTQScZCEHd35Ux4OkGmL2eisXSjCJ
         aGAw==
X-Gm-Message-State: AOAM533XhyFBR/mzGjTy6TLFyIFBq9jUdXI9rN2yQI8JVQpZ+iCT1WcH
        kO26QWjj5FtOJ0Yt4MEGiM4=
X-Google-Smtp-Source: ABdhPJwt8NIjUYGwuXknCDQbmVHO6g28eeMu6oh+BthZsjZwq/WjaEEvD0YP2JYs4p7oNHoqxcJBPw==
X-Received: by 2002:a17:906:934d:: with SMTP id p13mr673370ejw.414.1590622888588;
        Wed, 27 May 2020 16:41:28 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 04/11] soc/mscc: ocelot: add MII registers description
Date:   Thu, 28 May 2020 02:41:06 +0300
Message-Id: <20200527234113.2491988-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

Add the register definitions for the MSCC MIIM MDIO controller in
preparation for seville_vsc9959.c to create its accessors for the
internal MDIO bus.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/soc/mscc/ocelot.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 79c77aab87e5..85b16f099c8f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -394,6 +394,9 @@ enum ocelot_reg {
 	PTP_CLK_CFG_ADJ_CFG,
 	PTP_CLK_CFG_ADJ_FREQ,
 	GCB_SOFT_RST = GCB << TARGET_OFFSET,
+	GCB_MIIM_MII_STATUS,
+	GCB_MIIM_MII_CMD,
+	GCB_MIIM_MII_DATA,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
@@ -481,6 +484,8 @@ enum ocelot_regfield {
 	SYS_RESET_CFG_MEM_ENA,
 	SYS_RESET_CFG_MEM_INIT,
 	GCB_SOFT_RST_SWC_RST,
+	GCB_MIIM_MII_STATUS_PENDING,
+	GCB_MIIM_MII_STATUS_BUSY,
 	REGFIELD_MAX
 };
 
-- 
2.25.1

