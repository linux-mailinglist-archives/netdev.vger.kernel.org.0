Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E775433C8D3
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCOVwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhCOVv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:51:56 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CBAC06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:51:56 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id f20so35009945ioo.10
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tkE3LmGUj01YPH3BPs1/nEBfeLQdWBdBqpXnFwRgcR4=;
        b=hRSakI25uH/iqPFFwdYMutKVZkBqZDAiup5YEL0MEXGQQB8+ccGfQy8VEfOFnwdDUv
         X3GT0uWFTky5HvlgFc3ReSioSYnABS6VYnZoKDacviUuSfibMUEm5B/icGkIAnTkGIPB
         wH2d7OGxd0ZbUn+LFp5aGKzZje0rN77Ewhmp4f8cXL0RgML8D0eUA/bqcbfY6bFrD02f
         jR/hAwSTk9hadNE/elS86jdJEnZjGzQQrJffrtXYsHaltpk8W1jawXj43qD/cwxK428y
         Au3q2fQYRw/OpKDKQkm9nUpWFrD8oE+TusW68mH8W3dzPOPCN/pMUdB2NsgdipE6TnKG
         ZZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkE3LmGUj01YPH3BPs1/nEBfeLQdWBdBqpXnFwRgcR4=;
        b=heufmJlu3tQF7baXI2IZUUBk5YMdPcJ8jLIEiMr5J07ehNrLJ60SRuC4pkY8TpHOhQ
         vfqiN/tOCvLyNnG1ks0MOKEJUzvWGm8cxnrcog/hpOxRO1q8Ib7pas4E35gSJOVEZBo4
         ukbXSWT6efjMkiFBxCZCMaoC7NldGrBVdVVb0uzSE1yUhqW4lG7+7gT7TIIWk5INg+VW
         hxKX4c+XGVen7IK/pWXm9zI01q/aGG4YoNKV64p2rqfglrU6lvRMtMZpb35edtnj04lg
         5SKF3U4+fBR6zx4VMfMQXYarKNq6jIJjG0Z21qVV4o5Z5BuRImiK7VWC61K4Tr8B/yWN
         66rQ==
X-Gm-Message-State: AOAM533JtMKN4TUG6xtDf2w8pbXkqNiti5GsLOL3rLWGCVSDmvCTH5bf
        Fbvy1T6KyRS6KmDViw2X3vaUAw==
X-Google-Smtp-Source: ABdhPJzLSrpXxf6+JBGpcYl2Loe/76e92bVm0CkHDmNdmQiQTZhb8iuqdr69zFP/mUWz8AapDN2KAw==
X-Received: by 2002:a02:9645:: with SMTP id c63mr11445641jai.84.1615845116270;
        Mon, 15 Mar 2021 14:51:56 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y3sm7424625iot.15.2021.03.15.14.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:51:55 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v6 1/6] net: qualcomm: rmnet: mark trailer field endianness
Date:   Mon, 15 Mar 2021 16:51:46 -0500
Message-Id: <20210315215151.3029676-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315215151.3029676-1-elder@linaro.org>
References: <20210315215151.3029676-1-elder@linaro.org>
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
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
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

