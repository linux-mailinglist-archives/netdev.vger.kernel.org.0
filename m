Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A8C62FF2F
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 22:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiKRVLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 16:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiKRVLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 16:11:50 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102EE7AF6B
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:11:50 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso6183282pjc.5
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HS164PT1thWPX3+gJIUevbDgvzJj6XIx86U2ombNC6E=;
        b=V/10M61BAwjqfgwtW4m6+OLQQQVNW5qdkveInE2+NDix/ZB0ARQlpjaAePjf5krNjS
         MfLKsZzwmVtauIFxprl09NW9We65OAoxeJWj7HCzZ/aVDrFkBYTHh1dkZ6nuM9dC16uU
         ucPcJeE0B3y0t2RAv5Of1RObH4YoSyPsD1+cQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HS164PT1thWPX3+gJIUevbDgvzJj6XIx86U2ombNC6E=;
        b=1ljlGrD4oMrjs2migZ3/d68JaZtDv8IcfKvQDi/YJOlWz2dxTGReOntERNiWJkpV0V
         KjrEV34HWv+8HNUCSOjBzkT947LyvZvH10+qF0gDGVqPG2XytjijAZ5Invj0LZHalfh4
         XNEIJgF1wAlAgaYHhDLaKWTUTgBeXMnZfphM/Oe+QEz2ATKzaWo0ltN+y3DCKItgKQmY
         7XjlcBISL8x0aQXpdoG0/dmU4y00JaO4mCFxDRRQCoegLLRhMd7WbrZvMvqwDr8BBA4a
         iMsoLpMhkdCVN9siow/wNCDK7V9+jVyWM3dmc0MQInG04FW3/4d8ZlLmzQp9bAwR6Fa8
         9lpg==
X-Gm-Message-State: ANoB5pk2uoHvC/x/i82o/Wz1rx6BP9IwJdeL0d+OwL/B1JUhImK0pPn9
        F/jjLzx5wXLrUINgVn502IqvnQ==
X-Google-Smtp-Source: AA0mqf4/MwFX1Iqiu6FlU+9aTkJHZtAuq3pA/aTFngJdcgaTXnpd6zMAORQYE38fec5SPq+7DuJKbA==
X-Received: by 2002:a17:902:e385:b0:178:7040:9917 with SMTP id g5-20020a170902e38500b0017870409917mr1179204ple.109.1668805909571;
        Fri, 18 Nov 2022 13:11:49 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902d48600b001782aab6318sm4262797plg.68.2022.11.18.13.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 13:11:49 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Christian Lamparter <chunkeey@googlemail.com>
Cc:     Kees Cook <keescook@chromium.org>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] carl9170: Replace zero-length array of trailing structs with flex-array
Date:   Fri, 18 Nov 2022 13:11:47 -0800
Message-Id: <20221118211146.never.395-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1483; h=from:subject:message-id; bh=9oKJHA3pSUUlk2XRtoon41DyXm9EC5lRgSnJeNNG7Nk=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjd/USLIkMsbwjhdEbLcOY3U5QPGKPBFNJ6YbZMJoZ 0ZDGQQyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY3f1EgAKCRCJcvTf3G3AJpHOD/ wKY0GQZ2A8TAEq1UQ7FG9SLArIMDJDDT3g0EpAw5ve8vW+sMh1nv5jJPGd8MQerkzsujTsSPrh2G0c iPQbn+HlI6aQaDOuiuSEdMKJGqqOc/1WP87GGY3OOXa5shhaD6q8AQkfHE6oyrEuK33xeOmJVICKgY Av32wZ2kSTKy2HDZi+GdBlSzpoqkUFdB9AcQgajJ2V+ZbLWqvvWgQCUoU74qjujZDjsXqYuZJcBYdl CdsXdbJ7sYziQAXJB4p8ssHBg1rEfjeVaCx1066DHscGXgYa/if5SgIsCF5IE9pDxAKsUUEOGTYQPc ZsR+njBItdiDY8DYJSUCrstNR6hEmyJpA0u4cUsgH2uakYnt8hL43yIF4DTsNOpTqWDWUpoZpN14dh O4EHhbIrbHblUcz5TeFZgsg22MghgJlJMpsvW11AbpPtSH5rIwy5r7djol/fdNUeybVldBD5ZKVXCj 38UdKomgY//3Q+0O0D0SRKiTDgz3BJSRXrBAjSlu87cdhpNwXUvqoDeYsEcHi09tMwV8+46jUCZsEg SbDJFy4ZTezHATrffDLbWweDBK+LQo2UkP+WZVkah2C5E/Lj9wTIsoY1SXjbp1Bfv1U84zLoXOdpx8 fUksnNUWfZKOxTivJKSp1hVpry3W82obZcOz5rsCc6xdn67sycGb5AKyWgHw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated[1] and are being replaced with
flexible array members in support of the ongoing efforts to tighten the
FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.

Replace zero-length array with flexible-array member.

This results in no differences in binary output.

[1] https://github.com/KSPP/linux/issues/78

Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index 4a500095555c..ff4b3b50250c 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -118,10 +118,10 @@ struct carl9170_reg_list {
 } __packed;
 
 struct carl9170_write_reg {
-	struct {
+	DECLARE_FLEX_ARRAY(struct {
 		__le32		addr;
 		__le32		val;
-	} regs[0] __packed;
+	} __packed, regs);
 } __packed;
 
 struct carl9170_write_reg_byte {
-- 
2.34.1

