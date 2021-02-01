Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0618630B385
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhBAX10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhBAX0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 18:26:54 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E1DC061756
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 15:26:14 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id h11so19316825ioh.11
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 15:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lc/k5K9QUyP48nZxgWZukJoyJ65VbtFetvLAJEaMjJg=;
        b=QS+709Ti8z2gOlzrId8etHfiB6R62SANk4U1CHSaRcCSJdHGaWF8H5D4ZVNL7LwxlD
         8U/AMcARtH4vh6q6k6DbR5ut/Kbg4upYgeY2SCSS8JotI6JcYnUkikr375tUilMM8NwC
         TInh2poMgo76eVbV0XrsXPe3uJbET31f8c9hqM8rwmDesQF8Z5wwSXte2oeCvqgnUwlI
         xmyCW8ll23UGYs1HkBfIFHkrM4HXNS6ZRcbkAX61c3RihXUVJO60iq5r/9mZO9FzHMS5
         iHC7ln/zUAmTUrJJQbYJrGMHNC3FME8nq1Bbgci2Q2ZZtOukNVDG+qFb0jcjnCsMk0p7
         3ZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lc/k5K9QUyP48nZxgWZukJoyJ65VbtFetvLAJEaMjJg=;
        b=M9f1YhxgQ5wzfebP1Thb+TmxGjLqpbsc7NIaakAFkARDp1WYyyC45Ah4OStNeT3rKm
         HqTk4XKSrR29VPVWnK6jgqK1I2ZGaRP/cch4JQjEUwtPyyJW3wOtK3polY+X2F+bKIfa
         gNVFkQGd4uVBl00r6lbxr8Cj6evgsshVPaOJX7rVPl2FP7O0XftRkk8+VX0IAVWXJY31
         kYufZClDh+WGddz3oaryzP2yAwa3m/4uq+ZNDCcIPNJ2Y9kDHMRHEB0EW/809phVc3Do
         soEpKZqtxQ7TEHNjbXLabzg9UMR9fgDmvyBXsf9bYh2Cw8WEENKtQJKqRoK/adlvmhmx
         EpHw==
X-Gm-Message-State: AOAM532zazNYxWAAcPW7FL4qlIutHRAF7EPWkaNmdmYlEJacnWr+8p3i
        u3ct+s3Qe898KH/EQB3oCEEraw==
X-Google-Smtp-Source: ABdhPJw0cpo5vxVLTTBQyAYNebZbIXSs1VHiHP22h5aV6E+P/l6CQ5PjnFpUba5LbMBq8T3bqgrdGw==
X-Received: by 2002:a02:caaa:: with SMTP id e10mr16083799jap.102.1612221974236;
        Mon, 01 Feb 2021 15:26:14 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v18sm10359588ila.29.2021.02.01.15.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 15:26:13 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/4] net: ipa: add a missing __iomem attribute
Date:   Mon,  1 Feb 2021 17:26:06 -0600
Message-Id: <20210201232609.3524451-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210201232609.3524451-1-elder@linaro.org>
References: <20210201232609.3524451-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virt local variable in gsi_channel_state() does not have an
__iomem attribute but should.  Fix this.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 14d9a791924bf..e2e77f09077a9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -440,7 +440,7 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
 {
 	u32 channel_id = gsi_channel_id(channel);
-	void *virt = channel->gsi->virt;
+	void __iomem *virt = channel->gsi->virt;
 	u32 val;
 
 	val = ioread32(virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
-- 
2.27.0

