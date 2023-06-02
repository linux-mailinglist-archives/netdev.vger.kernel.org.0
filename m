Return-Path: <netdev+bounces-7593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46BE3720C15
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E85D5281B35
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD60C2C0;
	Fri,  2 Jun 2023 22:53:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BCDC141
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:53:53 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAF1E40
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:53:52 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9700219be87so376087666b.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 15:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685746431; x=1688338431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=800f3+0Lsb+PmQixuAuDOEq2hZQ/QTMYoU+QGjAKizU=;
        b=KQKUoXTx39Yav8VGFeYO8c7s+y4jXFlquHdRHZsAqmUGJwM4SUOwebAKChgoB5jD6C
         CIOijE1k4h+BIGUUs3UbseZoyMPA3Zazi/GQHfbKrObLLPwR+iNGTIv62FGdL3/mCVkH
         t5Vyb4R1i2MY/R0C4upPp30yF2uz/v4xzehjrhxI7PE+kBSUh6s8VXCxjwd0zuZAqdTZ
         jzFx7x+KACVF/WtgyXeZ+/BZctA7qH4stdKWl+MQARvgapNoFMr6vSqdfVJauHutt5Jv
         QhLH0if8SkqaSpT/vOxbg89yVUd/HUfHtbQimG+SoxsdmyZluO7E6rzwAElMhrgVVPe6
         AAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685746431; x=1688338431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=800f3+0Lsb+PmQixuAuDOEq2hZQ/QTMYoU+QGjAKizU=;
        b=FNrNQaH+CTfBoDm+N9zQG//wf0Prsrhjeas+XJ1TcWd7masRQEbs+jdEQ9xl/DiZ/B
         PtAI9q9vhk9LVOBsIbtEvXS08fxyiDloREeIXKAvL66QbdvfRSvU/KRcMcl9bHlqokK7
         mdGccUAinHCqKUI2WeUzO51/8aOkJf3e+IbokRMTqGZTZ8VYY6MXPS+u5w+uEJgn04rz
         pnDYv7sGoL7oC5CX/0nXaCab5znt9hxVoaVWTPYooRp4tTO+5M+3mmhQ8KSNq4tMUtgd
         b9f9QHA0944NBgowmhTA6phn4Tqg0GkxAFLynVd4nhlc4FyzZ36FrJ5rExW251FtoN5P
         0Tng==
X-Gm-Message-State: AC+VfDzXESicpd7ndIvvUXub1gAFOR5HxQtPgj8seRILDDv3esK0CI6M
	nNxmpKYIB4OGIutEr6l8/SDURkXYnJI=
X-Google-Smtp-Source: ACHHUZ54uvQgqsE/6t2pHO70DTBj532VRt0GgmdwlAcKJLL4haGwoZixbfemnO6fNLGrnRucAR/GLw==
X-Received: by 2002:a17:907:97d3:b0:96a:928c:d391 with SMTP id js19-20020a17090797d300b0096a928cd391mr22484ejc.4.1685746430499;
        Fri, 02 Jun 2023 15:53:50 -0700 (PDT)
Received: from shift.daheim (p5b0d7936.dip0.t-ipconnect.de. [91.13.121.54])
        by smtp.gmail.com with ESMTPSA id l14-20020a170906a40e00b0095807ab4b57sm1274165ejz.178.2023.06.02.15.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 15:53:49 -0700 (PDT)
Received: from chuck by shift.daheim with local (Exim 4.96)
	(envelope-from <chuck@shift.daheim>)
	id 1q5DeX-007a97-01;
	Sat, 03 Jun 2023 00:53:49 +0200
From: Christian Lamparter <chunkeey@gmail.com>
To: netdev@vger.kernel.org
Cc: alsi@bang-olufsen.dk,
	luizluca@gmail.com,
	linus.walleij@linaro.org,
	andrew@lunn.ch,
	olteanv@gmail.com,
	f.fainelli@gmail.com
Subject: [PATCH v1] net: dsa: realtek: rtl8365mb: add missing case for digital interface 0
Date: Sat,  3 Jun 2023 00:53:48 +0200
Message-Id: <40df61cc5bebe94e4d7d32f79776be0c12a37d61.1685746295.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

when bringing up the switch on a Netgear WNDAP660, I observed that
no traffic got passed from the RTL8363 to the ethernet interface...

Turns out, this was because the dropped case for
RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(0) that
got deleted by accident.

Fixes: d18b59f48b31 ("net: dsa: realtek: rtl8365mb: rename extport to extint")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(0) is shared between
extif0 and extif1. There's an extra
RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK later on to diffy
up between bits for extif0 and extif1.
---
 drivers/net/dsa/realtek/rtl8365mb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 6c00e6dcb193..57aa39f5b341 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -209,7 +209,8 @@
 #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0		0x1305 /* EXT1 */
 #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1		0x13C3 /* EXT2 */
 #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extint) \
-		((_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 : \
+		((_extint) == 0 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 : \
+		 (_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 : \
 		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
 		 0x0)
 #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) \
-- 
2.40.1


