Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D44820E6AE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404403AbgF2Vtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404386AbgF2Vt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:49:28 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B86C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:28 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f6so3234011ioj.5
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x3WsjEvMX2jVlQmLpoImtSBZfw4ruLu125L1QjdLE6c=;
        b=IPdS1l8btarTTx8Pg20WcJKVz5lv3iSeocJNQG5d9q3bXMuLLd80FQTDLn63bBoLEP
         klo0qXxUSVg47JUWi0J2CeJR334hWulsGF71rXX1n8zc+ffWwd7aigAElQ58vXLK/Mru
         4BYlHXde0ZEBJiWEKcxdhR/tLsFYVU4AR3XLOeK6sfe3MO/5l32SUA5w++fyy4HtFLhe
         F8o5vqDYNl7KvkVOXY7f4dtLmeiw+erStlxo2D3xhX1YH3A7ZAHBfAKBIdoDdmbP0dU0
         SrnhiFsnTbfC5vAe3t3UDcOMiPHvr4PJKcQ3axIaFI13/Mciu3bvJGK/ZadCt7oaGPLq
         Wd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x3WsjEvMX2jVlQmLpoImtSBZfw4ruLu125L1QjdLE6c=;
        b=M1B6QC4l3m/yOSSenbbODmBG+XXwwzMNmJJkQjGt12Mg/N04Ifb4uGCkoCL3UuKwkM
         BiYHSXa9SoWew6Z2ajWI5ysGDobSMeQZ7UDyWXSlxDS7SsFUWsZdi5MB/LjyelAbWrdJ
         H59fRgWi+95Eyx4gHVwUJSC3eAuD/YUUDIEeCUEqJboZCOrtiXLjzBdD8+9mx/8juwhw
         k0K8o1arR890V4Te3Rtwu7bwBFi0Bd8P7M/t/Gk7whPELYmNvle6E9LOIH/9HIBtDDup
         VXjiXH5Jf3VuqdBYgHmANt28JPpZIxB9IXFmS0kwW0c3NtyvixvgAOeW82R0H1lZi1VO
         7oIg==
X-Gm-Message-State: AOAM532S/KnOz9VRUe6XUxkc737NEgNYC+qqLobSts1gf/nIkPXSHvGW
        JBjOGNp/5lZIuQ7qmdOXc3jRArsHFh8=
X-Google-Smtp-Source: ABdhPJxxvMhyvmL6ew9qDBRpHAYYfqbOaQ6QxeQQeIxiwl2aOGKijf6q6PROkEkBA8+tu2Nvld/aVQ==
X-Received: by 2002:a05:6638:d05:: with SMTP id q5mr19477503jaj.2.1593467368176;
        Mon, 29 Jun 2020 14:49:28 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u10sm555500iow.38.2020.06.29.14.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:49:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: HOL_BLOCK_EN_FMASK is a 1-bit mask
Date:   Mon, 29 Jun 2020 16:49:19 -0500
Message-Id: <20200629214919.1196017-6-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629214919.1196017-1-elder@linaro.org>
References: <20200629214919.1196017-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The convention throughout the IPA driver is to directly use
single-bit field mask values, rather than using (for example)
u32_encode_bits() to set or clear them.

Fix the one place that doesn't follow that convention, which sets
HOL_BLOCK_EN_FMASK in ipa_endpoint_init_hol_block_enable().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index ee8fc22c3abc..447dafab8f18 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -679,7 +679,7 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
 
 	/* assert(!endpoint->toward_ipa); */
 
-	val = u32_encode_bits(enable ? 1 : 0, HOL_BLOCK_EN_FMASK);
+	val = enable ? HOL_BLOCK_EN_FMASK : 0;
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(endpoint_id);
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
-- 
2.25.1

