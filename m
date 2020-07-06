Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C320E2161E1
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgGFXKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgGFXKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:10:16 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3CBC08C5E0
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 16:10:16 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o3so17014688ilo.12
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 16:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=se6npIx/isoI+wc+DuA8rTR4AlHBZ2FFSB7wVA4cQcE=;
        b=UBuCvzeWAF5+IDTI7RF1zsFrtgZM/fbjlSisrBTBcKRILehXI+LrHwlgiz4LyYb8pW
         Sf/SlBzf13tuYo7bFT8anxfKfI/fAOybik1Dpi4uQs30mVQm3eDvraBaivCejyOojATg
         7MBl8KArREbaxVhzRuGvbOrFSZbJDp52D+yMjWCJs6den5Ah9H5jt8p3V8SI+cR/BbUI
         KPcdF0KK8/mCWakrO/4pq96mlk8xkwxg2KOrENdz/Iy0u2LZsvmmByOfJqkGw5u15Iu+
         xZwvgB/on5WygSTkF7Y5XPoEaRfZpv4rEz0j99mcxVW6qB9dZI9aZgneyFJYc36FMcnO
         jLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=se6npIx/isoI+wc+DuA8rTR4AlHBZ2FFSB7wVA4cQcE=;
        b=laAdBlB6tbmGks6f+b9whkOBiqfdTzPP1QxMVCsDy0YLA7smhO8dpAdZykbcMBKBhe
         6+M9W4AwM4d5rM7wJY+ZwRUYekOH7XmWckOn4qqmOH6UgkDaDGoOu8I3VjwJ/knrS/bd
         PqYw2+EUOkpXjKCYO7lZWKTH2FQYkbedRT3FBFrhwL1aKTp/aAcOGLMIeA5vXVv+nhvb
         A43qTrb6bOsHmYQMIj8v5XOkGk7vFzjRwOZD77P8odDQzokhEtXYobQSIPHy/FWKz6Nb
         uYyUuy/Nm1lqllX3srcDwqiYfvXnsLAhM3n7CAvay9fUjUHSf7GUhVWwNshSZnah6Id2
         xHxw==
X-Gm-Message-State: AOAM531tfRPXPo5yuA8EE89Cr0iLJ2gUs2FpzIQRjX6/Po4i1ggGL/+X
        1whyJkRYs8DrI/tC4DLot/Bkrg==
X-Google-Smtp-Source: ABdhPJz+uOnUC2+fv7mONCYyVbVTuWfakSgIjtxksvBBZj8yHC5xDmCxIRCMR3/dUnlXEPmw8bbGgg==
X-Received: by 2002:a92:dd02:: with SMTP id n2mr32990236ilm.257.1594077015622;
        Mon, 06 Jul 2020 16:10:15 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w16sm11523029iom.27.2020.07.06.16.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 16:10:15 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] net: ipa: declare struct types in "ipa_gsi.h"
Date:   Mon,  6 Jul 2020 18:10:09 -0500
Message-Id: <20200706231010.1233505-3-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706231010.1233505-1-elder@linaro.org>
References: <20200706231010.1233505-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointers to two struct types are used in "ipa_gsi.h", without those
struct types being forward-declared.  Add these declarations.

Fixes: c3f398b141a8 ("soc: qcom: ipa: IPA interface to GSI")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_gsi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_gsi.h b/drivers/net/ipa/ipa_gsi.h
index 3cf18600c68e..0a40f3dc55fc 100644
--- a/drivers/net/ipa/ipa_gsi.h
+++ b/drivers/net/ipa/ipa_gsi.h
@@ -8,7 +8,9 @@
 
 #include <linux/types.h>
 
+struct gsi;
 struct gsi_trans;
+struct ipa_gsi_endpoint_data;
 
 /**
  * ipa_gsi_trans_complete() - GSI transaction completion callback
-- 
2.25.1

