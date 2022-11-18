Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1315630762
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 01:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbiKSAej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 19:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiKSAeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 19:34:13 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A5F114B91
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:42:48 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 136so6309897pga.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gdy8THFQ217ArK5qAf8locqq0ea0wdI2wQ0KQQ2fz/s=;
        b=BxtRWJrHgOasPDbyKA01nQReUZgzUZg6/4Bvt2wpUMbvtO/NzBRy4yb4K7NNnaui7z
         ZKoGcX+rZGZwaFdgXrnSa2czgwNPRRYNXG71hyg0aQ9HxMwIlmkn+NGMMTz5Y1m91xRw
         6E5v8oz/mfPDQhfGbLbEdYGZ6/kBrnVXVXF3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gdy8THFQ217ArK5qAf8locqq0ea0wdI2wQ0KQQ2fz/s=;
        b=TbjLqu31x78vNSIHq2CmYHkRpufqc5s09EggiZFOvw2XofPWTmWfGekNIZkZrK2UNd
         Vv5qxPgZVmn6INYRVtZ4CWMY665q+OYBNMMRZUui4Vrj3FH3JPVDyuEavdIDU7zDaHxD
         Bg56yJZOAyvzIM4sMwoxfjj8tK+HX2OiWZ3E2WH5O4CPTnLlEP08HxIiqmydMNjZe01g
         MZnIc0WQ0sHNnhnegPEWQvqPQf7RjISsjVLAJ8LVbBmk07cqijYqSXjWnRz1ZO1IZ4Oc
         P3Qe7SkvXVccMzGjLou2l9PENoWk+Jjv6+JVVg3cDJeXPg/k8EMtX6zomQ2jh2c08mS1
         4GTA==
X-Gm-Message-State: ANoB5plb5Za4LVy4jDwRHiJo9L1nF6ePt52LhKxXSIlDilZzQ1GAUwvl
        Gh0fNp56vO6oMH03DCAMHhFwHg==
X-Google-Smtp-Source: AA0mqf66SlkGoi1KeBiWbmO1baSn/GeKKLl0in2EE+JnpytDffihGspac3rJNaC2ddKrmgRrYzkDpw==
X-Received: by 2002:a63:e09:0:b0:46b:8e9:749 with SMTP id d9-20020a630e09000000b0046b08e90749mr8370837pgl.260.1668814966918;
        Fri, 18 Nov 2022 15:42:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b00186c54188b4sm164191plf.240.2022.11.18.15.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 15:42:46 -0800 (PST)
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
Subject: [PATCH v2] p54: Replace zero-length array of trailing structs with flex-array
Date:   Fri, 18 Nov 2022 15:42:44 -0800
Message-Id: <20221118234240.gonna.369-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1744; h=from:subject:message-id; bh=frYwS/CNxid8oyzmUWma7Osq+zP62XTvZCZTt4IGeWs=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjeBh0f9MnBuxNAcv8AF9IXJq5IQXcPhkrRYT3czBK XoiyBLGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY3gYdAAKCRCJcvTf3G3AJo5DEA CErDezf9uGBzeffXHVEc6KW5d8b6cJulenKDodro6pDA0mLJLYysESpyoAEe5dxT0q1pYdE0tzhV3S jWP0krg7whj91sCODp2jVmwPHK+fwU9/QiYarSJb+w3aAMuPx44QzBLTEWl9zbpjrPVTzuyVpVrftn jlGwx84wxKoeQdJGBF5in0GyzFLP/hVeLE4Zd+ntsc2BmVULzfrwNwqlN5I/4pAX0Q7zYwMyIVOR8j z5v64icaG0BGj5RLTZ7wauNbfIqOZST4aOTNwebR5VK0+zLAyYKg5OVjsfhVcaATEXiYfEzRq6L1xn qMzwjvXdv/0EzjBFV5b4UI5FOsAdQ0VWPc/qDCDZ+1z0TOs0LBuQTyLnxubd5HXz+kOxLDMjQqge3Q 3Mpr2qPcaVaqjRpAN1YNFhgli/fb3dK2GYf6VunwqdTSMTfEykk1vKWlJbpPX2nm2oNJFnk3aaRsFd m083OQZQZ+QOkekrxZ6oukm5qapc+LcBjy+/CWQhdzI1Yxr4S0m2IZ+nKfZpGBTSjI7rTEWS/iIJ6u GD/HrfqnStwjJjgGx/GRClHRWZ4roYUXubU4mEQ/9J55gTJ0VQvJvp7nUiS9ODC51JZxaWTFDogTXe elAmug2mMq8e8aQEfFbVhcAjCnBInU6Jt9iYU4uZeorSptPZtaZ8iJooDsgQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

This results in no differences in binary output (most especially because
struct pda_antenna_gain is unused). The struct is kept for future
reference.

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
v2:
- convert normally (chunkeey)
v1: https://lore.kernel.org/lkml/20221118210639.never.072-kees@kernel.org/
---
 drivers/net/wireless/intersil/p54/eeprom.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/eeprom.h b/drivers/net/wireless/intersil/p54/eeprom.h
index 1d0aaf54389a..641c4e79879e 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.h
+++ b/drivers/net/wireless/intersil/p54/eeprom.h
@@ -108,10 +108,10 @@ struct pda_country {
 } __packed;
 
 struct pda_antenna_gain {
-	struct {
+	DECLARE_FLEX_ARRAY(struct {
 		u8 gain_5GHz;	/* 0.25 dBi units */
 		u8 gain_2GHz;	/* 0.25 dBi units */
-	} __packed antenna[0];
+	} __packed, antenna);
 } __packed;
 
 struct pda_custom_wrapper {
-- 
2.34.1

