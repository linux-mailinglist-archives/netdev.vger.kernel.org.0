Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F58C6EAD1A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjDUOhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjDUOhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:11 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D42D13C3D;
        Fri, 21 Apr 2023 07:36:59 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-506b20efd4cso2886999a12.3;
        Fri, 21 Apr 2023 07:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087817; x=1684679817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sx7QT+CfbRJuf7ipyvzI9VLyvr32Uv9zIwCFOCdllC4=;
        b=KqBupMCSod70Y958ehISGx6H0Hk58VkXRikprYBBIiecgLGS2MTLleCo9SvhmvEkKU
         jz8vsoBNeqrXcrN/Scju08aE8xCnHKNyPIlAli3EUe30khELo6b869qwOPDjJMGW4WSb
         Ok5wOYo8sXFwMCJsD50BKU1ISbchY0wIMPXyYBM6hn1lAWrZF9oLi24Y3npmGA6fKixt
         oP0dEmwcIby2+JVIyKO8PB1MREpqZ6FTmn6woSIsssN1H6QdVXY3MirHpdu/heK45XNT
         MHqCbJpAG+37GRfLIlTGePKQysSzWtbNtOQoec9KNjm5OpmtW43wlpJa3WZCZ85114/Y
         LxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087817; x=1684679817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sx7QT+CfbRJuf7ipyvzI9VLyvr32Uv9zIwCFOCdllC4=;
        b=ElVCOlesKgPMjxTzNmsmYFHj2HefTHVBqF38yR+TfZuSGFIviD1mXPPv1XFXWLfWWU
         OTJWaTBfx9gIwXFuaycj7rJ5j4QE9TgvOOjMP/VJaT4aKSIVve3HO1EdFT31T+ggr76A
         auuTYAfkj6rqs7WIxtwbXwYZGtc/4SBAoMDKX9AUwjkU3tGY4O3iYoUtxzYFRRjYysKV
         0Z7zOKXwZAX80CMd2khb2NzexaolpnAhC2KSflB8g/2tmqki3FzybdJhBIkLfO9Glv4K
         LCNIqmn4svYibN+w9DvbSeRCLtbJqDL/c1a0k4rIwUWBxn7XHC/dSX5PjU/f4H9luWdq
         yovw==
X-Gm-Message-State: AAQBX9eoOJ7EjbPKfgDRfbrJAxO3YoO6BpAAnAt7yHpCV6s0BLwMDepD
        SkQkleWLElNHajNOtIzKx8s=
X-Google-Smtp-Source: AKy350bB4/HdrT8woCCbxfnAVBekFnXUuEGFqFUKrXHi90jUUFu7MVJKe0mP9T5GsJvC/eqr454dDg==
X-Received: by 2002:a17:907:9503:b0:92c:8e4a:1a42 with SMTP id ew3-20020a170907950300b0092c8e4a1a42mr2100787ejc.32.1682087817083;
        Fri, 21 Apr 2023 07:36:57 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:36:56 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 01/22] net: dsa: mt7530: add missing @p5_interface to mt7530_priv description
Date:   Fri, 21 Apr 2023 17:36:27 +0300
Message-Id: <20230421143648.87889-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230421143648.87889-1-arinc.unal@arinc9.com>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Add the missing p5_interface field to the mt7530_priv description. Sort out
the description in the process.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 5084f48a8869..845f5dd16d83 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -746,7 +746,8 @@ struct mt753x_info {
  * @ports:		Holding the state among ports
  * @reg_mutex:		The lock for protecting among process accessing
  *			registers
- * @p6_interface	Holding the current port 6 interface
+ * @p6_interface:	Holding the current port 6 interface
+ * @p5_interface:	Holding the current port 5 interface
  * @p5_intf_sel:	Holding the current port 5 interface select
  * @irq:		IRQ number of the switch
  * @irq_domain:		IRQ domain of the switch irq_chip
-- 
2.37.2

