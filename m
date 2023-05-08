Return-Path: <netdev+bounces-903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4332B6FB4BE
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3D8F280FE0
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059BE525D;
	Mon,  8 May 2023 16:08:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57C153AF
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:08:19 +0000 (UTC)
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00384EE5;
	Mon,  8 May 2023 09:08:18 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-38e12d973bfso2432763b6e.0;
        Mon, 08 May 2023 09:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683562098; x=1686154098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69E6AsuuXwrvkEgAjEjrOIUSbBdHMkfJE23qGTOBaOk=;
        b=hs4+MAQKI5VYFgAmWz5llsM2uWDPDVW6OUsybVZCf3Zi+7YciwPM2APztUHQYCf40U
         j+1JhqRu8tCk5ba0XF4PHOgnGOeva9aUOu9J1W5hWYQ7wpG9JWhV+44y8L8UrTOO8lD3
         RUIghfW+LpkbEmTudEwVxcowPUs7chAwf7V/EF4jY1fTd+7524n2R34v3Tbq56PaEbiu
         1MhuJsH84mpDj9FkLouVNxyCfAqnOUIWTzSX0Ge8Tkt8uzeAkcUi+HTYiIE1vWskKSeO
         FXme/X9TDATQ8Yh70UsFhUC2AtuRZgROrWTojMnHH8k85YHi3pyz3PjVsae3XJ3HoQe4
         rvmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683562098; x=1686154098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69E6AsuuXwrvkEgAjEjrOIUSbBdHMkfJE23qGTOBaOk=;
        b=PlhpPQJJme0GTkahAH90AVwG7mAxUW6/TMGcUH/A4ns1wUGQFXFbub4tSJ4qTGMNaM
         cH/spLYzH3U+ivNwN3n860CyrcWQfRiDyWjNQE72uoazXZTIUAi+0KP7LIV2akvR5Ips
         3OLhzeDYclB5dXvIetAaNtKnad3ymHcJrsmIKkQyCd8S/GBoQmL6K193HSGYo+H6exeR
         k+CHVmpbX5lirQHvBtNQtmsxQGyMrVzh5awj2b/tVgX/rmGaI0hxEF5kMwfoNys+p4M4
         XpKDb/vItbQiZk2E0ccg9hpF23tNSsnQaNF9JOTHINnddwfXmUnQ6D2xwrWCKPXuCugP
         4A6Q==
X-Gm-Message-State: AC+VfDxKcj7Mb6nD7iJhMujcquch+sGc9TSvAgyjlL4yZxlsrQil4JI/
	oRkHAYrToFSiDnmtC8psupC10/orBwmeQA==
X-Google-Smtp-Source: ACHHUZ5nWw1+Un0d1fFFclW/qIosdXnltPYdfkMiWgP+YdgC7q42WAolQMr83w62ebWBjF5I3yiq3Q==
X-Received: by 2002:a54:488c:0:b0:38b:c4c3:b3ec with SMTP id r12-20020a54488c000000b0038bc4c3b3ecmr4882823oic.3.1683562098038;
        Mon, 08 May 2023 09:08:18 -0700 (PDT)
Received: from localhost.localdomain ([76.244.6.13])
        by smtp.gmail.com with ESMTPSA id v206-20020aca61d7000000b0038c0a359e74sm136391oib.31.2023.05.08.09.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 09:08:17 -0700 (PDT)
From: Chris Morgan <macroalpha82@gmail.com>
To: devicetree@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org,
	netdev@vger.kernel.org,
	anarsoul@gmail.com,
	alistair@alistair23.me,
	heiko@sntech.de,
	conor+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	Chris Morgan <macromorgan@hotmail.com>
Subject: [PATCH 2/2] arm64: dts: rockchip: Fix compatible for Bluetooth
Date: Mon,  8 May 2023 11:08:11 -0500
Message-Id: <20230508160811.3568213-3-macroalpha82@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508160811.3568213-1-macroalpha82@gmail.com>
References: <20230508160811.3568213-1-macroalpha82@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Chris Morgan <macromorgan@hotmail.com>

The realtek Bluetooth module uses the same driver as the
realtek,rtl8822cs-bt and the realtek,rtl8723bs-bt, however by selecting
the 8723bs advanced power saving features are disabled that appear
to interfere with normal operation of the bluetooth module. This
change switches the compatible string to disable power saving. Without
this patch evtest of a paired bluetooth controller fails, with this
patch the controller operates as expected.

Fixes: b6986b7920bb ("arm64: dts: rockchip: Update compatible for bluetooth")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
---
 arch/arm64/boot/dts/rockchip/rk3566-anbernic-rgxx3.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rgxx3.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rgxx3.dtsi
index 8fadd8afb190..ad43fa199ca5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rgxx3.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rgxx3.dtsi
@@ -716,7 +716,7 @@ &uart1 {
 	status = "okay";
 
 	bluetooth {
-		compatible = "realtek,rtl8821cs-bt", "realtek,rtl8822cs-bt";
+		compatible = "realtek,rtl8821cs-bt", "realtek,rtl8723bs-bt";
 		device-wake-gpios = <&gpio4 4 GPIO_ACTIVE_HIGH>;
 		enable-gpios = <&gpio4 3 GPIO_ACTIVE_HIGH>;
 		host-wake-gpios = <&gpio4 5 GPIO_ACTIVE_HIGH>;
-- 
2.34.1


