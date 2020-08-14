Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DC4244909
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgHNLlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgHNLkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B60C061350
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f12so8044493wru.13
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B0W9kY9gOABObNMzFU7qR/h3u0fr5wbeuus7asIVtUU=;
        b=E1U4hFDlHsWCrCkg8hTw44iOHiljc6bi7sr1Wngty/U98hc+h9XGcyQ8CEPIhui25F
         417ZFpDXtzly+m5CyiKiImTP9a7jsJEnrbK2mDUY4RV2aUb8RAaOTOeYXrnu7x2pZkJP
         MXMXxJm2OxEMEeCtooLzYPX5nKAMBlZ8mOkgLiyuBoIxkxGXJcrQPFqxhI7DueNgEDNW
         1Tko1MSqREU27ERvsb1rPQmtYkym9UhJw73R4INHVU0lLcDfaladGaiFIpKRdzSlBrGl
         uhWKAE6rof7skSjSOHuNbtr8UJgLSnlj/vtEhmYu5cLxOVa6hirwnLYWuAtE2zYZv3rN
         WPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0W9kY9gOABObNMzFU7qR/h3u0fr5wbeuus7asIVtUU=;
        b=rpwj6/ROsjpLYiLSWoztoOgohSy4Jl3dM3j+f0S6qx+ZyShWgyz93jI/hXu+L+TpY8
         7lBcphvKIL3KDStgl/iiCb1ezJlvUOABlA1zX6aGW4PQPrWSshrGD59J4K0u8RXxQE4G
         Sv4IZiQSB7v/te7WVa3TpcljqZu2OeCB9xFJB/RHw4beiMh4A52OXVf7+wUryx8ygAdi
         qkrdHAHytpn4RBm0MhDa6CZbafUE4IpuWAOENWdz+KD5nnLF/nWOfbioFFoOhkDtbgTS
         pRE0JAtcr9u9xrkdYHK7yGbOnuWTVHdkUK1ahSOdF26qjxbOsmzE6VgquUDrfaqotN6g
         QSCw==
X-Gm-Message-State: AOAM531CCd0GPOKaCs17QHaLHUDwwuAD33q34GWFK8pKpEbwvGDZUw+j
        UMop7AVSZ25czhbIAU178MB34Q==
X-Google-Smtp-Source: ABdhPJwZp2MJiKoowkR6rTySosLQ4LI6NDWDp3ihnDEADkd3a0DOkIa7HHs6uIgFFvyT1RnLJb/lDA==
X-Received: by 2002:a5d:6748:: with SMTP id l8mr2534059wrw.358.1597405211761;
        Fri, 14 Aug 2020 04:40:11 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 20/30] net: wireless: ath: ath5k: base: Fix kerneldoc formatting issue
Date:   Fri, 14 Aug 2020 12:39:23 +0100
Message-Id: <20200814113933.1903438-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kerneldoc expects attributes/parameters to be in '@*.: ' format and
gets confused if the variable does not follow the type/attribute
definitions.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath5k/base.c:1111: warning: Function parameter or member 'ah' not described in 'ath5k_drain_tx_buffs'

Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/ath5k/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 65a4c142640d0..b70acefdc3fb7 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1098,7 +1098,7 @@ ath5k_beaconq_config(struct ath5k_hw *ah)
 /**
  * ath5k_drain_tx_buffs - Empty tx buffers
  *
- * @ah The &struct ath5k_hw
+ * @ah: The &struct ath5k_hw
  *
  * Empty tx buffers from all queues in preparation
  * of a reset or during shutdown.
-- 
2.25.1

