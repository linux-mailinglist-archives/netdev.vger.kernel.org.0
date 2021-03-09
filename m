Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0C03325B3
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 13:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCIMs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 07:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhCIMsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 07:48:53 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FE6C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 04:48:53 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e7so12032684ile.7
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 04:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=siv8ALjvw5nAWM5oVnlAOXA/08MIyz7olXglWGx22ko=;
        b=kC8B6lj3o08cGovB26B9exuiv8S3XJQVO38EPn3FDus4bdyX3gY/cpxyOvP9AGOnQJ
         EOqtN4cC89OHDSOhSIngjvJaTAAb7HOHeTRHyHflrsyKx0da1IG10suDL0pm6F7O6P9F
         2Q1DEbVLKMyzisqhb1hrgCyapRNo6i6QVFujXO5ZPMFOWX3s/3qFOJ96egzJawHvTrDL
         7iJpjDASzw2TAMEbSbE7yOFlC9bwvHB/xU0tc1RhQUqPckHG5lQYVFvhSfJRSs+sOqX+
         pgWZH6uVPQNqKxqgwoUZ9MV6q/tAaa0p5+xfgJWnUzR8Y/6ZbEWzYyCY5xYFxY+VYybZ
         n9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=siv8ALjvw5nAWM5oVnlAOXA/08MIyz7olXglWGx22ko=;
        b=dpuP71a3ebUw/DL0J5IhWp9ofRSK1KULDr7HMzi4fPyVST4ZgHCJ7IgbvQihR0//tv
         u8YdDFxE+XWW8L8ASBsRQuCMo8kXyE03VbfYkzZnhyR2v6cwXpasR/vR4CwsQqk5Ih1L
         br8rTI9qqYT+Y1NtbW1ZFEjJVml1ETDF4fbOupqi6zTPqYCGaOPHCZu8GAUV7bMn4Kve
         lixKMhWoJkCuMGmRDkmNJkkGKA/49uIfQa9/k1gLMHal9lxevKan1Ebu4LoIREr10uBJ
         GHNjzJ4tarxyTLoGZBg+BrkfdYSZHA6nNOKfp2NDFhaQA9sp+pio25nU+CSVbsbUcF3K
         3xfA==
X-Gm-Message-State: AOAM5312nVLOCB/UArwcWrZwyEcyd3PP9nEdLxNDGTQLBetAJ0mrXLaS
        pFqy7Bp1IsiVU48srv00ETZHBw==
X-Google-Smtp-Source: ABdhPJwWPuyEXFsEhr6SsfI000Bo7Tlqd/6cwnZna3h2qxFl+0XHnkQlNGo7oALyjSapMaJwd+0Aaw==
X-Received: by 2002:a05:6e02:1544:: with SMTP id j4mr23743257ilu.67.1615294132685;
        Tue, 09 Mar 2021 04:48:52 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o23sm7810009ioo.24.2021.03.09.04.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 04:48:52 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/6] net: qualcomm: rmnet: mark trailer field endianness
Date:   Tue,  9 Mar 2021 06:48:43 -0600
Message-Id: <20210309124848.238327-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210309124848.238327-1-elder@linaro.org>
References: <20210309124848.238327-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fields in the checksum trailer structure used for QMAP protocol
RX packets are all big-endian format, so define them that way.

It turns out these fields are never actually used by the RMNet code.
The start offset is always assumed to be zero, and the length is
taken from the other packet headers.  So making these fields
explicitly big endian has no effect on the behavior of the code.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 include/linux/if_rmnet.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 9661416a9bb47..8c7845baf3837 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -32,8 +32,8 @@ struct rmnet_map_dl_csum_trailer {
 #else
 #error	"Please fix <asm/byteorder.h>"
 #endif
-	u16 csum_start_offset;
-	u16 csum_length;
+	__be16 csum_start_offset;
+	__be16 csum_length;
 	__be16 csum_value;
 } __aligned(1);
 
-- 
2.27.0

