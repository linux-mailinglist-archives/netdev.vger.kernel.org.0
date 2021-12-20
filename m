Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7EA47A98E
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhLTMZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhLTMZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 07:25:26 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF555C061747
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:25:25 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id f5so14439243edq.6
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BkU0CaGENz4v/3Yu7z2QNSSezrRYwzxHe/jHn0X53Fs=;
        b=E8cyRV5DAxSFah2JC3Fc1cxHI+3dwdXlh0T3LzXxrVVHTxoWCfuNZWfP9RqHSKFqv1
         ATFwo+0bsqYBmYTaEjVClE59qJ+1SGbjLDAg1JeCfLoi/sSuvo1MKhLEw8jMCJSiO1hD
         xggIkrPNYEP0PGChuMUbnhQU5uuW5oA8aYuOeUu5FX8gXswRadVvuuSJc6PH+7jjo9Rk
         2dR0RM+6aRa6QYn1myuadUT0uooHuq7bDgbUJYdRrdAkPklcbja4cayWzsbPcmxQzYXv
         Munx3hruaUqaEfe2RJaf0x4TyAnOpru5vfv0BhyGxIrdaYv7v0/QbPgM1D1CjqQGd8QU
         BuqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BkU0CaGENz4v/3Yu7z2QNSSezrRYwzxHe/jHn0X53Fs=;
        b=dAEilLHCX0UrcNTe8R2VJt5pn3QH3dQlb26offQj2HWSudsQHbk6Jn/KkNKY+3lm3L
         UQzz/0SqSQ5PYZ4P7cIQ/8FPaIi8ezzxby2fHrQUCfeSJCzG8IFqs0SubvskLGr2dPDf
         /O+aF5qEDo9mg2Rhyjh7XWmXWfA8d3mpOTcLxbAx19VBaa9FyqbtaH5oxCEXwu4j/S67
         NsJSwICVPHjXyCjbVUK10DSub7thrtvYK/mbbbN6C1kevmM8JddCgofHZu6/jKcs3NNs
         VcGfElavC8jHqiDtCBxL5a1JwYsCQu4p6VQXuVIYP5/qyU9AlxlSvISfg9rMqR9bIj7m
         SYzQ==
X-Gm-Message-State: AOAM530t+aNBvs+uKIjFUlQB7/B5Ik91CMVZYtmNStjeJb+GAhLp/HU3
        9ppD3yMXW4l6ifLODS+LZVgHyw==
X-Google-Smtp-Source: ABdhPJwY2sPvzyyxylJ5xxnZzQNbTOwgcmi5YbfCxJXmGTaRi0zIIkGC36V31RdLQtJrwa/vwP7bpg==
X-Received: by 2002:a17:906:4788:: with SMTP id cw8mr1045314ejc.22.1640003124185;
        Mon, 20 Dec 2021 04:25:24 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id z1sm6666242edq.54.2021.12.20.04.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 04:25:23 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        clang-built-linux@googlegroups.com, ulli.kroll@googlemail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 4.14 1/6] net: lan78xx: Avoid unnecessary self assignment
Date:   Mon, 20 Dec 2021 13:25:01 +0100
Message-Id: <20211220122506.3631672-2-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220122506.3631672-1-anders.roxell@linaro.org>
References: <20211220122506.3631672-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 94e7c844990f0db92418586b107be135b4963b66 upstream.

Clang warns when a variable is assigned to itself.

drivers/net/usb/lan78xx.c:940:11: warning: explicitly assigning value of
variable of type 'u32' (aka 'unsigned int') to itself [-Wself-assign]
                        offset = offset;
                        ~~~~~~ ^ ~~~~~~
1 warning generated.

Reorder the if statement to acheive the same result and avoid a self
assignment warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/129
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/net/usb/lan78xx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 838b6fe9dfaa..e286188b6ea1 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -920,11 +920,9 @@ static int lan78xx_read_otp(struct lan78xx_net *dev, u32 offset,
 	ret = lan78xx_read_raw_otp(dev, 0, 1, &sig);
 
 	if (ret == 0) {
-		if (sig == OTP_INDICATOR_1)
-			offset = offset;
-		else if (sig == OTP_INDICATOR_2)
+		if (sig == OTP_INDICATOR_2)
 			offset += 0x100;
-		else
+		else if (sig != OTP_INDICATOR_1)
 			ret = -EINVAL;
 		if (!ret)
 			ret = lan78xx_read_raw_otp(dev, offset, length, data);
-- 
2.34.1

