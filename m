Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F256530E57
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbiEWKnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiEWKnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:06 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18B0274
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:04 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id f9so27956400ejc.0
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=01WA8pFyMHR9NLJ1obeHNHl3D1QwsyhGDKgeQr7KWj0=;
        b=CxsHJazkmmqnzmU/GwqTK5sF+Ek2T19rG4ni+IXWLYrHnNuBPSGv35OQrWw53c2BFc
         puv2NbHZYK8s+KC1KuvXjcZXN+Z84Feq0UWpllNsfub1VvtQ9jwefG5ZggXbICmtd/XT
         DSjxOgbwgWaVUKXFiU/avkRZJ4kQZZ+EjHHi6rWOfvg6lU+43ZcnS8h6M7jmWavBorHV
         LEIfgE8IZZB8HG5NiD1mfDMfKVogxNfrP91lraQF0KAKrDdeaI4FgJVZGk1T/9YSXqtK
         84E5eqDMapGPjHe5ccrlk82v86tnKV7RKMTn4Jn78clYP3o53Bk3OgU+8Nl5DYIs3pef
         1vrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=01WA8pFyMHR9NLJ1obeHNHl3D1QwsyhGDKgeQr7KWj0=;
        b=J+DAQXIhVRk+lVWX4arvao60CU8pxe33IDI1SHF/KeYez2oyNVXU1rXc16ZlibX0P4
         LMrtBY4mCuMOCZetaaZZXvZosEuimU6LPDbEmp55RGPh8glhZrC6UEZVaMLyDrR9ihhy
         MNNfIjqYebGGDsxAPreKZjkx0PFcAU3Ijd1VSuRPtYMYnFAkPBmlUHsenuxyuDLE+MT+
         hVIVSt2TwdXHL6p5QBp6r8JwDZrV54WP0KmhpSUY+g+IZ2Ns+luuX8gCV6XWyIIBMQ+2
         5pkCvO7BGyjst/gi1kk5C4qNMUcfLzp3qq/muY5BJq4+rzgbPk4JG45txzu4z+w1hCsp
         Z0xg==
X-Gm-Message-State: AOAM530bzHsFvEXWA7bxKQQBmpygiR3MId8eaHCWoD0NBvjP5eFhJd4z
        84j8ZfPbmtZYjy+8T9w/03P38zZWl4Y=
X-Google-Smtp-Source: ABdhPJwX8X8AAn8vCqtoBQ0zXs0Q9kx/2EKL6sfoE+XBVYXpk6nsIL7M875iVi8AuTlHjIcObHawMQ==
X-Received: by 2002:a17:907:7ea0:b0:6fe:f024:d006 with SMTP id qb32-20020a1709077ea000b006fef024d006mr2226380ejc.248.1653302582998;
        Mon, 23 May 2022 03:43:02 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 01/12] net: introduce iterators over synced hw addresses
Date:   Mon, 23 May 2022 13:42:45 +0300
Message-Id: <20220523104256.3556016-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some network drivers use __dev_mc_sync()/__dev_uc_sync() and therefore
program the hardware only with addresses with a non-zero sync_cnt.

Some of the above drivers also need to save/restore the address
filtering lists when certain events happen, and they need to walk
through the struct net_device :: uc and struct net_device :: mc lists.
But these lists contain unsynced addresses too.

To keep the appearance of an elementary form of data encapsulation,
provide iterators through these lists that only look at entries with a
non-zero sync_cnt, instead of filtering entries out from device drivers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f615a66c89e9..47b59f99b037 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -253,11 +253,17 @@ struct netdev_hw_addr_list {
 #define netdev_uc_empty(dev) netdev_hw_addr_list_empty(&(dev)->uc)
 #define netdev_for_each_uc_addr(ha, dev) \
 	netdev_hw_addr_list_for_each(ha, &(dev)->uc)
+#define netdev_for_each_synced_uc_addr(_ha, _dev) \
+	netdev_for_each_uc_addr((_ha), (_dev)) \
+		if ((_ha)->sync_cnt)
 
 #define netdev_mc_count(dev) netdev_hw_addr_list_count(&(dev)->mc)
 #define netdev_mc_empty(dev) netdev_hw_addr_list_empty(&(dev)->mc)
 #define netdev_for_each_mc_addr(ha, dev) \
 	netdev_hw_addr_list_for_each(ha, &(dev)->mc)
+#define netdev_for_each_synced_mc_addr(_ha, _dev) \
+	netdev_for_each_mc_addr((_ha), (_dev)) \
+		if ((_ha)->sync_cnt)
 
 struct hh_cache {
 	unsigned int	hh_len;
-- 
2.25.1

