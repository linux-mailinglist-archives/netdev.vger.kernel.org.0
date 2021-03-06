Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC6232F802
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 04:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCFDQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 22:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhCFDP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 22:15:59 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB4CC061762
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 19:15:56 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id d5so3856239iln.6
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 19:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=siv8ALjvw5nAWM5oVnlAOXA/08MIyz7olXglWGx22ko=;
        b=VaG23pAj8JOs+CT9cgwwHYOa0+JEos2V4LSaNc5NiboFIMDa6NIW9Njr6Tic3vZQj+
         ud1QGV7C0CUFhgk02O9V5sxvLl/z0WlZTFmlf3XSZSWP1al4lrQ19CtsK+hSNUQt9TwH
         wbLpSKexzyuafiBtRYNJ56LIR0XrwTjVoi0hL4h0rJBV47Tl/T5j9J4FLq6uRy/+tfv1
         krPb9Tq36Ab2hg+kvq8h0gYWZlr2NibtRnil57rpD3fGeeZxDlqJNAYQ54NWFPiVKfe/
         frZjcpfTVaga8Inw+np2mr/ngDYqMS4I+lT2MUxb3r/xtu8TA0M+s7rOXOFDzk/1AjJ0
         bcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=siv8ALjvw5nAWM5oVnlAOXA/08MIyz7olXglWGx22ko=;
        b=i5tbz+QtJOlzt/+r6AvClyCBFPOEwfo/yS6mTzhTgkTncygMTlBRUdZMhNOjLxXEW+
         zwPHvd2dScdT2/InPVatlCpKw4v/XYCCUpYKEzoE9eEtoK961B0r51VQyLJPmXUWt8iO
         xyyFAeFkXY3NAhImCi5z5ndpGE2mgpchi9MHVw0CdYQ8Mpefig4SMO1eVQNiCtPX7QJY
         rf+BREW1zzdjVV0F0QhJIgTZ/3jqHOaF/NOhU0HzhuCp/bqvReqn+U8eBIQBW+68612Z
         xW9Adi7A2kmGSHrRXSn/TcrZK9vq2s+nkVygBnwmQ3YnqTRqK118vRkGrAjvVZyMnGx3
         yQNQ==
X-Gm-Message-State: AOAM5324o6dE1I50KnsOFlvRs4iXwPm7OuUBndfnPQJl2WQPEIVEJP0j
        I8bW/+UCqWMBdBr77BFjxXdZvQ==
X-Google-Smtp-Source: ABdhPJxMzN0vbK6J5eK3Cwe+/FK1dnkQHHyTMC2tDezE3WTyipmZ4eIno0DFINaIds83nvoMQxNwFg==
X-Received: by 2002:a92:c7c2:: with SMTP id g2mr11802891ilk.209.1615000555738;
        Fri, 05 Mar 2021 19:15:55 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i67sm2278693ioa.3.2021.03.05.19.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 19:15:55 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/6] net: qualcomm: rmnet: mark trailer field endianness
Date:   Fri,  5 Mar 2021 21:15:45 -0600
Message-Id: <20210306031550.26530-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210306031550.26530-1-elder@linaro.org>
References: <20210306031550.26530-1-elder@linaro.org>
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

