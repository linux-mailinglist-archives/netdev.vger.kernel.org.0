Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9652137B2D2
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhEKX5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEKX5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 19:57:40 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9D6C061574;
        Tue, 11 May 2021 16:56:33 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id j75so20642362oih.10;
        Tue, 11 May 2021 16:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVd0C6U+pOQCTdpKsYSoAOdkAaViQw9tGJFeL10a/eo=;
        b=KooqjuH3XsHQYC26jxJKyYTleW1BaqZqY802qbXkRoIY2LtGSZnQgHyasKc61dauDC
         Jjq+XZ8lwg237j5X7DPryg+6bHjmjRx1c7zXKe/507Z5+84KyXCp9TgYztCd9l792ljt
         5EvCi0MhR3HPD5qxnOwOalKNdFS0WQ+LeYeHOu4Rnp3CXJfixNgHplqxHmFLt1ddqpO8
         mxeQpF7pnMqOidm/WsDhbyBVDrGaVBYBjLmYOsly0UaODsRbw9l6dSbZymNY/4WwjUlk
         tNvXPdKJbkXWOhUnHczgYTw7qO/j6nbLCgLD58T+wH+LH4ilF3m1PGIcbqmdswVjtRkd
         lwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=GVd0C6U+pOQCTdpKsYSoAOdkAaViQw9tGJFeL10a/eo=;
        b=Gx4A+H81q/F4lCGIVEJ13PA/g5xWdmckhtfVQAPkog/Gn4WfEmGVd5JzGepQaa4CEq
         2A5iZ9DmVm6aIOC59+kVPMp8rzb4XpaqqtXCANXmgD8T3U8bp5gl7qPcm5Wev0G80PHH
         AQLp3G0ZuLSyzgh5piqaGwfXq+gRsRo+Qw98qPH3uFuzylOrwkNgtpaKb70z2/7YiDI8
         p9n2xonP1ZrrOlpPu937zfVQc/irSl2JTxdWKYsH2LGK7djHIlW5CJWjpO24xqZniEBV
         TIpQy1UJlzf+QmVdMKl9tC1b33i1WAIM4q997lSdf5xoaFV8HonqbdVU0s8P80RlOdpY
         j1Ig==
X-Gm-Message-State: AOAM532LAJuKpPEuGGIAu0HfN7zBPU6AJO/JLFlpQQWDKwPsFcjJu2r6
        aGjO+DlsSsbCzbtoB0E6GGI=
X-Google-Smtp-Source: ABdhPJz2Y4w7cSHleO+dJO2wqq43bsT3xrmZ5a5uadkZOaLIzG20LSakA2d2PWBg14X6XPqXuhtklA==
X-Received: by 2002:aca:4acf:: with SMTP id x198mr24019150oia.111.1620777392722;
        Tue, 11 May 2021 16:56:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d19sm3610578oop.26.2021.05.11.16.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 16:56:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Arend van Spriel <aspriel@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] brcm80211: Drop unnecessary NULL check after container_of
Date:   Tue, 11 May 2021 16:56:29 -0700
Message-Id: <20210511235629.1686038-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameter passed to ai_detach() is guaranteed to never be NULL
because it is checked by the caller. Consequently, the result of
container_of() on it is also never NULL, and a NULL check on it
is unnecessary. Even without that, the NULL check would still be
unnecessary because the subsequent kfree() can handle NULL arguments.
On top of all that, it is misleading to check the result of container_of()
against NULL because the position of the contained element could change,
which would make the check invalid. Remove it.

This change was made automatically with the following Coccinelle script.

@@
type t;
identifier v;
statement s;
@@

<+...
(
  t v = container_of(...);
|
  v = container_of(...);
)
  ...
  when != v
- if (\( !v \| v == NULL \) ) s
...+>

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/aiutils.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/aiutils.c
index 53365977bfd6..2084b506a450 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/aiutils.c
@@ -531,9 +531,6 @@ void ai_detach(struct si_pub *sih)
 
 	sii = container_of(sih, struct si_info, pub);
 
-	if (sii == NULL)
-		return;
-
 	kfree(sii);
 }
 
-- 
2.25.1

