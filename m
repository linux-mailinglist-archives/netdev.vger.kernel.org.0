Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8A433B4A8
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCONfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhCONfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:35:00 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D0FC06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 06:35:00 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id u20so33315505iot.9
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 06:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=siv8ALjvw5nAWM5oVnlAOXA/08MIyz7olXglWGx22ko=;
        b=l7lFexo0b5S+LJMcrD4VEZOBoMyKEJdpy4GLKvP0UuCvCnZ/Ib2cwt2IirxXVgzThr
         WGXcio2aZZAf5pUeJq9HINoY4eXbx0M/YwqVz9/LnGNtPGjJJ4FyZE+SxwGde1+7hqGM
         lenXuPW6+0QRD7PesJZr0tWyGrSNUd+TK8QIMBjiayLv4ah3H8DmPOHt6R/JwjOVUvhg
         jf5QF+/aXCEwR4OMZ0bp51EpnMrHrsVPBqa6jIF98l3XbyYsuIRvJgREeW0Z73Mt+PDb
         GcMrMIImU1ldqtyQnk6NcFd4sJju0L8BD8IVIyNfsH+FIiEBTJDmiQMPVhrV/U65PNsl
         1F0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=siv8ALjvw5nAWM5oVnlAOXA/08MIyz7olXglWGx22ko=;
        b=D4wlCQGJlezwMvDY/Q8+NPv3ve+3PMPpPSlBwsSUMA9dIPCl92cCjZ9xME1TfkBFiE
         UGP/qHTWJazQ7KzvplYX2vBy+UxgWZ1bkJlU2jRyCDawVapOiEp5EOl7EeZBjyRuU+R6
         FyND1hblV7wbiAYK7s44z0abSLtNcRwek2b3hoFYG8n3j08x9sAROJDy1/B52nI2AlvB
         tZtvZgKXrxB/iwN+h9IhkOf4lBsaET7wfXAiCqTY8YimkrZb3O/Zr41SoU3vZapUPBzw
         jRCougkQ9FQLmhYqwS4YThiJ5AuVFdVHcfR6/kJ2WgSE+sf0GAezXlGu3P1Cdxo7mybu
         vVEw==
X-Gm-Message-State: AOAM53282ZNd3He9ERHYZhuE8PEwRa7tUbJeXKis3D3YTfpiGPPXvERa
        zaXEdg1tQWax679amyZwnbiiqQ==
X-Google-Smtp-Source: ABdhPJxyCJSjEV6Tjt0zRglZ2m8CBVXotDqQBvzlhhITUu8yLQLAcLGcM1Y8rc+dxlaYZOSwPKt0Ng==
X-Received: by 2002:a02:a90f:: with SMTP id n15mr9697057jam.110.1615815300258;
        Mon, 15 Mar 2021 06:35:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o23sm7127672ioo.24.2021.03.15.06.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 06:34:59 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 1/6] net: qualcomm: rmnet: mark trailer field endianness
Date:   Mon, 15 Mar 2021 08:34:50 -0500
Message-Id: <20210315133455.1576188-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315133455.1576188-1-elder@linaro.org>
References: <20210315133455.1576188-1-elder@linaro.org>
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

