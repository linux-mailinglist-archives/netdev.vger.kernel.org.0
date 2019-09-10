Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B68AF181
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfIJTEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:04:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45640 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfIJTEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:04:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id l16so21725668wrv.12;
        Tue, 10 Sep 2019 12:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/hilQzsCJxKwP3iLZ8HzlKgy8yH9kb6fEFDV5ZKdCyE=;
        b=guKxL0FnNLiU5TMDidgTSYgeuDCCp9r9hApW3wtyxtFScjHBwNUsnLsm6tbY6FDwTU
         t/u6ZlTtchki5wWrmGjqydgbnJVG294aOW8R7AIuqm5Bs5KsHs3wl2T99FmZupA7VDCg
         o0rxxL1oXw+Ri45p4uOBLTCt5GMjMfYHvHxVLajupEnJmLUrLAiwKh9bnKbrYIfBjYBx
         6VvJkzNH7YWgmau1t/18BmxoxrWiWahHXK55ckcMydegZ7iwrbTXAlfVYOm9riF/dQkk
         6gNcQydwC6SA9TgoL5a54gFvE7sWcMOBPCjOS0Gj3yCftaKtL2HpUMq/2Ll8s7UeZMQS
         HgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/hilQzsCJxKwP3iLZ8HzlKgy8yH9kb6fEFDV5ZKdCyE=;
        b=Szp45FCjl0RcoC6iO247VrzOnGQ2N4AtQN0/3z/f44VQUyqchz+aOgpngQ1X/qRnt2
         n80yAKEnkzqqMhuHsGe/+ZtSme0fqjT+FyLQTDeHyfXfossVw0dt9Yfs2XEH3M9reogG
         b5SgdKGMxC8/4l+mly7MxSMaYSBmKRtOZr7WiYtQmwr8q01FYglE2kbOUhEUqoN240eB
         UBDhQxhrcH8gENPsdsBpeZFhB1XJLiZWfOja5EhmCIFIlVkDthNT7Q0Jhh8xkU8cvjTI
         Qlw4NH14vTFB/B66xb0TMAg+6bcjds/4r93CAm2FVYPuSDm8l908/VGPG71IU17aCcEY
         aKNQ==
X-Gm-Message-State: APjAAAWsl0ej9dmxc5LAxF3wJKELpFyZ3OY+Mcv5qCI36Cn+OcMlkbTW
        s0T4YzBqiMP29wCnekJmuJk=
X-Google-Smtp-Source: APXvYqziVqQ9ov3KhhvPUgg3puxHFUg4O/RuIwQstmHpmz5lZB8ZM3LWhklSgOXw5sYb+cS3M4JxRA==
X-Received: by 2002:adf:f2cd:: with SMTP id d13mr26723957wrp.143.1568142289391;
        Tue, 10 Sep 2019 12:04:49 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8108:96bf:e0ab:2b68:5d76:a12a:e6ba])
        by smtp.gmail.com with ESMTPSA id w15sm14222967wru.53.2019.09.10.12.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 12:04:48 -0700 (PDT)
From:   Michael Straube <straube.linux@gmail.com>
To:     kvalo@codeaurora.org
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 3/3] rtlwifi: rtl8192de: replace _rtl92d_evm_db_to_percentage with generic version
Date:   Tue, 10 Sep 2019 21:04:22 +0200
Message-Id: <20190910190422.63378-4-straube.linux@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190910190422.63378-1-straube.linux@gmail.com>
References: <20190910190422.63378-1-straube.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function _rtl92d_evm_db_to_percentage is functionally identical
to the generic version rtl_evm_db_to_percentage, so remove
_rtl92d_evm_db_to_percentage and use the generic version instead.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c   | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index d162884a9e00..2494e1f118f8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -4,6 +4,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../base.h"
+#include "../stats.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -32,21 +33,6 @@ static u8 _rtl92d_query_rxpwrpercentage(s8 antpower)
 		return 100 + antpower;
 }
 
-static u8 _rtl92d_evm_db_to_percentage(s8 value)
-{
-	s8 ret_val = value;
-
-	if (ret_val >= 0)
-		ret_val = 0;
-	if (ret_val <= -33)
-		ret_val = -33;
-	ret_val = 0 - ret_val;
-	ret_val *= 3;
-	if (ret_val == 99)
-		ret_val = 100;
-	return ret_val;
-}
-
 static long _rtl92de_translate_todbm(struct ieee80211_hw *hw,
 				     u8 signal_strength_index)
 {
@@ -215,7 +201,7 @@ static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 		else
 			max_spatial_stream = 1;
 		for (i = 0; i < max_spatial_stream; i++) {
-			evm = _rtl92d_evm_db_to_percentage(p_drvinfo->rxevm[i]);
+			evm = rtl_evm_db_to_percentage(p_drvinfo->rxevm[i]);
 			if (packet_match_bssid) {
 				if (i == 0)
 					pstats->signalquality =
-- 
2.23.0

