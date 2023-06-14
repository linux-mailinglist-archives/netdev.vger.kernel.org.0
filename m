Return-Path: <netdev+bounces-10740-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA538730092
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6136280A70
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50B8C2C8;
	Wed, 14 Jun 2023 13:50:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85C0AD43
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:50:01 +0000 (UTC)
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E691FF7;
	Wed, 14 Jun 2023 06:50:00 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-340a05c22deso2187135ab.1;
        Wed, 14 Jun 2023 06:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686750599; x=1689342599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEPuphakaNp1fYcyZ4pObojDdVaUBwTgM8okY278g5E=;
        b=ipsgnUCS9NMIbr5fKQnk6kUv67E3x/wY8Rq+aGR0dr6qp/ctIpczO2KxLo1i9Cez3l
         y8qlys4Sx5KpiBn9Nnjg44K0M0X/fQ3mvM5r9ErMiOAADRI5WwBa5rpflBHNJ87ta5qN
         Vj33y4B2iKVL/rP7Wi/cm2uV+G8nxboYFqLXVv1CuqLQ/MJq23RcFH3XD7OUkDBvQJCc
         Wt/8MaUcl1t5faWXnbe3x198W8AabOJRZ0a+UaFI+MjqVfGYlZceaEqLt/FpCCw0q+co
         /m0OOa1RD0pmujC8dngUrmQcYCRaL/5JGUqS9jRI14oY9K361mymCboKbWJACZHWfH02
         cXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686750599; x=1689342599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZEPuphakaNp1fYcyZ4pObojDdVaUBwTgM8okY278g5E=;
        b=foYcaPNq4OHEIJ7vwPJaMP7oIgoOOR2VBZiw8NERWdIhAK476WqfF6CUXexdpjjBIJ
         B/mMs+6y2Tf96NCzZnuEfxLDNnvo2wM6jSexljXxNg0sxy3rkK6wtEi0nHtl6xx5C0e5
         0MJegbbFAxxGYbbeRlRWDrsiZAltPs2pkaQzXbTgZ9kWe2pA+kWsEmyIMmKSwNAsxG8a
         Hm2nr7DMzFCmGt0qJbwUNfoQtiNQdHRawxLcJUrY4eDAdeqNx1/WnGGymswGQJgXNMFE
         mPhbv+Aj5cRdV8xf7JDBvYlC3yfIiDjdUGg/Xl0ux/uWju0MCoD6Vx4YziH+/Qaqky0L
         h3Ng==
X-Gm-Message-State: AC+VfDwud9kqottb5ItIQTftJp0p7DEsGXnq2+jY1ECHIP0R6kawTJL4
	gL1QnPi1q23lyMIxy0mhcf0=
X-Google-Smtp-Source: ACHHUZ4Q+vvd86epl/4PhLMQWi6vLCuv0c4ale/GTY/nnvGPX8Z/2yHYNXQj/hF9L+IuVhfQH7e0pg==
X-Received: by 2002:a92:cacd:0:b0:33a:5bb5:f8f6 with SMTP id m13-20020a92cacd000000b0033a5bb5f8f6mr11581580ilq.18.1686750599414;
        Wed, 14 Jun 2023 06:49:59 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (54.70.188.35.bc.googleusercontent.com. [35.188.70.54])
        by smtp.gmail.com with ESMTPSA id a26-20020a056638019a00b004182f88c368sm5072190jaq.67.2023.06.14.06.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 06:49:59 -0700 (PDT)
From: Azeem Shaikh <azeemshaikh38@gmail.com>
To: Kalle Valo <kvalo@kernel.org>
Cc: linux-hardening@vger.kernel.org,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3] wifi: cfg80211: replace strlcpy() with strscpy()
Date: Wed, 14 Jun 2023 13:49:56 +0000
Message-ID: <20230614134956.2109252-1-azeemshaikh38@gmail.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
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

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().

Direct replacement is safe here since WIPHY_ASSIGN is only used by
TRACE macros and the return values are ignored.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
v1: https://lore.kernel.org/all/20230612232301.2572316-1-azeemshaikh38@gmail.com/
v2: https://lore.kernel.org/all/20230614134552.2108471-1-azeemshaikh38@gmail.com/

Changes from v1 and v2 - updated patch title.

 net/wireless/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 716a1fa70069..a00da3ebfed5 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -22,7 +22,7 @@
 
 #define MAXNAME		32
 #define WIPHY_ENTRY	__array(char, wiphy_name, 32)
-#define WIPHY_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(wiphy), MAXNAME)
+#define WIPHY_ASSIGN	strscpy(__entry->wiphy_name, wiphy_name(wiphy), MAXNAME)
 #define WIPHY_PR_FMT	"%s"
 #define WIPHY_PR_ARG	__entry->wiphy_name
 
-- 
2.41.0.162.gfafddb0af9-goog



