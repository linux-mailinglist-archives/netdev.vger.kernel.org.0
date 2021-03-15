Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9925233C615
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhCOSuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhCOSte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 14:49:34 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0FCC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:34 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id r7so10394711ilb.0
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tkE3LmGUj01YPH3BPs1/nEBfeLQdWBdBqpXnFwRgcR4=;
        b=bom4lMmQJrp5VcTVXyEm9MMJ4NeJCRL6bqdHhGXRV8mep6rnDF0QdfZZzpn1mM50H6
         qvHHmBXE2mqaHSkdqifKS546EMOYBAnUJ5FhxHltL83Pdxc5JCc4ZUiIFrxjZNQeQ5bV
         Okf91VbuTCBZJ6I4UYIxfXiwnzNKEfNANWfqyKPqkk1ZaDlOHyfibNOZBNFIcDjjQyTE
         qtTU/ERepKCjDksL8h+aY++zNqwez/tAA1gpPrf09QeUe08+i+ryBizTgRUUSBnQVqoD
         nkP3sOy/HYJ4nzBS01d7XTLT+SqI0ubN7ayRTRPjYdv02YaufxlII17g5KoZztlN2IHG
         M3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkE3LmGUj01YPH3BPs1/nEBfeLQdWBdBqpXnFwRgcR4=;
        b=Fy1C1ghBjS0UIpylXNyW8xFavgHieKlTnEYrdzPMhFlWFg8G2DvdofeaiTabouWWcU
         ZfAvDLFxnrk9019X5oBjXIBUbCEhZVrj4wW6AJOqq54RlkRalPVhszLQyYaPwUOoGvNx
         DFEi2lsWHefwb9oTIqg/cXCf2m19gQxRm5vEXx+I5BNezUj94VQ4Y++Invq97aVSmesE
         2Bm3u0JGrFOo9T9HBUrf0Yuw65E6l1hzTHRD1SGk5Q67Kruy4CtlGbf6YYVkiIF2PTsT
         NaG5gCAO3yxpiuc6ZQs9Kb6DjX9maY93uZySvBGpLiZoEZsDQq5qcglAH/tqfgvywF3r
         w1qA==
X-Gm-Message-State: AOAM532gQs76qYB8guWslXUOZIkkVORqSj5akJLi2hvXmLQVbFuOuXMi
        YIIiSx79SXh4gDoAVkqa5fb4/A==
X-Google-Smtp-Source: ABdhPJxoEqSlw3wLBbuIXMxokGl4pSHO7F63WKkv8o6e2lAwtEG+kIowll9PL/c1tM70omcDWEfwMQ==
X-Received: by 2002:a05:6e02:ee1:: with SMTP id j1mr765610ilk.179.1615834173956;
        Mon, 15 Mar 2021 11:49:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a5sm8212162ilk.14.2021.03.15.11.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 11:49:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v5 1/6] net: qualcomm: rmnet: mark trailer field endianness
Date:   Mon, 15 Mar 2021 13:49:23 -0500
Message-Id: <20210315184928.2913264-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315184928.2913264-1-elder@linaro.org>
References: <20210315184928.2913264-1-elder@linaro.org>
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

