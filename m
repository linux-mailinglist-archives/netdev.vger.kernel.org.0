Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4AE4FE727
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358285AbiDLRf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358212AbiDLRfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:35:43 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E3D61A06
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:33:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id r13so38772132ejd.5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DC9ar6WVuy8H//hRbG7nMUtpZuF4AvspHn0mVs8y4F4=;
        b=dzanuMKUFyt8XFvAW++8zP2aQ3lZU4nsxEF4W2HXgX3INmny7m55Z4SYmUhODKnOCh
         9O6Vjmvf4LIgYdK4CB0wbk5yonLYwN+vpxvy7guN1JxNSUh1E5SB55oV/pukdi7+Wv6K
         ZlI3TfabmMQXNgGpqT2kCmUfoFgd/iDhartcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DC9ar6WVuy8H//hRbG7nMUtpZuF4AvspHn0mVs8y4F4=;
        b=iqxytBuOy1/LmdEWKowoWzU0UjcS0II7W2g9hBgRVvUHVr3HXDeNtTfezVewOIc1vy
         3hXnEb1D0Yz98FNcxqD97b4ti5BJdAlAtLSU+hdmAG0MCOnUD+6XBzkgFNrGrsB7vnyk
         7D7wjQ93wL3TlUbZ2wxhjmyBvCpzcNm4woIMti3gFOMaAiFA4mwTE4xq9IMu61kbtYdz
         2GYK5CMqxeVuBHR6OQg4olJA+ODM1sOuOeGi3vJu5Ow3kAU1awiqGpUWoYJn6ZXFkoYE
         lQhdBtVuhSCat3KzOg5f4LH/TUgX3Im3ja5BJ17XxJPc0sneMQgeptKZsIk44OAx18HA
         w92A==
X-Gm-Message-State: AOAM531UhZVm8X37c1t9w9Dz1T04fR9nYSq4qjwBAP8cDxeFXjnBnVHc
        niQvItHu5eTe+FOXrkkbKnqc8g==
X-Google-Smtp-Source: ABdhPJwhHDhcrRl1hoquPk1uVIXdYrKQmJhG0BOzDhXrDr+tJG0QcTjI1W96DDU6NAzAp9Cnx2IYBg==
X-Received: by 2002:a17:907:6d0b:b0:6e8:b449:df70 with SMTP id sa11-20020a1709076d0b00b006e8b449df70mr3383233ejc.533.1649784799698;
        Tue, 12 Apr 2022 10:33:19 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7dd43000000b00419db53ae65sm56142edw.7.2022.04.12.10.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:33:19 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Michael Rasmussen <mir@bang-olufsen.dk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH stable 5.16+ 3/3] net: dsa: realtek: make interface drivers depend on OF
Date:   Tue, 12 Apr 2022 19:32:52 +0200
Message-Id: <20220412173253.2247196-4-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412173253.2247196-1-alvin@pqrs.dk>
References: <20220412173253.2247196-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 109d899452ba17996eccec7ae8249fb1f8900a16 ]

The kernel test robot reported build warnings with a randconfig that
built realtek-{smi,mdio} without CONFIG_OF set. Since both interface
drivers are using OF and will not probe without, add the corresponding
dependency to Kconfig.

Link: https://lore.kernel.org/all/202203231233.Xx73Y40o-lkp@intel.com/
Link: https://lore.kernel.org/all/202203231439.ycl0jg50-lkp@intel.com/
Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
Fixes: 765c39a4fafe ("net: dsa: realtek: convert subdrivers into modules")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20220323124225.91763-1-alvin@pqrs.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[alsi: backport to 5.16: remove mdio part]
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 1c62212fb0ec..1315896ed6e2 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -14,6 +14,7 @@ menuconfig NET_DSA_REALTEK
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI connected switch driver"
 	depends on NET_DSA_REALTEK
+	depends on OF
 	default y
 	help
 	  Select to enable support for registering switches connected
-- 
2.35.1

