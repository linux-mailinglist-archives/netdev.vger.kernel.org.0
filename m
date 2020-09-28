Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215BB27B7A6
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgI1XNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29C8C05BD0D
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:52 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y74so2885092iof.12
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=idjGAQ7MQS14u+65LdARnv7/5MnPPt3V31TAdfoMMxk=;
        b=pIw9997sSVansIhN2qSSz90iYSVKQHHZi21ggs7dzEA25Hl0yTD6ShGd49MuZm7jh1
         /c1LfVzbTc7RxuBnPX7kZ1pjPQi+kJafDCsJUgp4tdSCFJbOmkd8IDAxWcuCUABTFF3R
         O8HnAHsuhhcf6EtYoab+QgBPjR6sc0PPhoBvCQQT5wt1/AinKQzyxOPYWCePCwFRirXL
         NrqMV59WI6PlkRrfFJ0u78ZdQQYSGYZUne6oGpG4AFYkLE/RH1bCi/2XArinqRUpbRWr
         +tNtUTyFDav0mzYVFay5f4E+3s2VJE/bTfPHbRNvXvQhIKP3faD9iVan3AJuCXctCX43
         zIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=idjGAQ7MQS14u+65LdARnv7/5MnPPt3V31TAdfoMMxk=;
        b=b/3ht5Cb44qIL8itoic2ui2BtjUqGOqaqqtQlpZJswx4I3A6qUhRtWnV1tju/G0QyC
         3xx5FPfFjs5sUQUU5gAbtwzgsPpCXGh9OFGzLAYKHF2AoFkqW8cU1e7nbxKsQvWwz4Uk
         bTNISToPtS5jJv4eOEeQRJtDo5/Z6Cjp8ruMXRxwmAoas9wO5NVRPrioNOXKQqo7TBC/
         Bzqq4zAHlJjeUps5N7jxrDkabDojHMMNF7BQ11bxNOtPQvV2pxzE+KYFR3QsVj8bwpco
         A3QQpkjTg9qck7FRZmyComnVtLYtUrYQiINNy9t6tVm5Go9fvWxW6qXbdj16fCPVfpNw
         Ngfw==
X-Gm-Message-State: AOAM530fgUGPEVg2/f2agGyzh7P23am7pr0as7lzoJUeBDTU2/n5VLod
        wCgax0FjrVXuMov5UqyNQj8g8A==
X-Google-Smtp-Source: ABdhPJx0HKKCLVGA0dhin3W/dMnYt/7qq235QtA2wYI5z15ATKYZvMVuzVZx5XgWKWaiHOKUxlcMBg==
X-Received: by 2002:a05:6602:18a:: with SMTP id m10mr401040ioo.174.1601334292211;
        Mon, 28 Sep 2020 16:04:52 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/10] net: ipa: kill unused status opcodes
Date:   Mon, 28 Sep 2020 18:04:38 -0500
Message-Id: <20200928230446.20561-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three status opcodes are not currently supported.  Symbols
representing their numeric values are defined but never used.
Remove those unused definitions; they can be defined again
when they actually get used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index b7efd7c95e9c8..e5e64ca244cbd 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -42,11 +42,8 @@
 /** enum ipa_status_opcode - status element opcode hardware values */
 enum ipa_status_opcode {
 	IPA_STATUS_OPCODE_PACKET		= 0x01,
-	IPA_STATUS_OPCODE_NEW_FRAG_RULE		= 0x02,
 	IPA_STATUS_OPCODE_DROPPED_PACKET	= 0x04,
 	IPA_STATUS_OPCODE_SUSPENDED_PACKET	= 0x08,
-	IPA_STATUS_OPCODE_LOG			= 0x10,
-	IPA_STATUS_OPCODE_DCMP			= 0x20,
 	IPA_STATUS_OPCODE_PACKET_2ND_PASS	= 0x40,
 };
 
@@ -1048,8 +1045,7 @@ static bool ipa_endpoint_skb_build(struct ipa_endpoint *endpoint,
 }
 
 /* The format of a packet status element is the same for several status
- * types (opcodes).  The NEW_FRAG_RULE, LOG, DCMP (decompression) types
- * aren't currently supported
+ * types (opcodes).  Other types aren't currently supported.
  */
 static bool ipa_status_format_packet(enum ipa_status_opcode opcode)
 {
-- 
2.20.1

