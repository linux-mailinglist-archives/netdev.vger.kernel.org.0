Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34922AC183
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbgKIQ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730736AbgKIQ4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:56:44 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D48EC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:56:43 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id s10so10523016ioe.1
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Vdf65yzuDCrr/hvWk0aTTXpWc5ZNNvy02Ck48ydFJk=;
        b=mibJzcXpvmvzLZWpCf4PGwU3zb/b293QV8UyvXMkNooM1NutYjJ1qw9av82rcrIW3j
         /l9dlo+1o69PfGRzbXggHMQT/Q97/M3TrkrsQIHRMoW+5d4Z03XqY73BzqhGudOBKgRU
         lz40pPJbQtuOY0nQ0m7dMkvI02iQ2N1UIpkB73Ok2h1FvynxocisqyhBig3jDqbeZ04n
         Yo5khOIdzpC8JJsCekgN0lNMAkykgpzY3M5U7WA248uwZgUuvI7vG6Vun6OYS7oGicHC
         Al+25ntjcAed667J28ayHlmmUgdjKsaF0Sve+1uphCEAI8tXF6rIj+DBpTgCAThXiwNb
         u+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Vdf65yzuDCrr/hvWk0aTTXpWc5ZNNvy02Ck48ydFJk=;
        b=tfNlYGGi/GeWUJW7G3uA3a6+SJ+hh2cAcPUFS3Rypu6YIadt3AgQljlz7biSehOlJ8
         sEAFm5ZYehS5KjvugDraTy1UE28CK9NrBhO7f4UVQO5DBwzzyzoqwDtsdMkWzJHArMem
         uxGPQDslOJZheUsfrjcAUdy4LLnu0HEuu0HuxdVZ4eV55eeaPy7pnSkOUA7jBz1cp7GR
         CZaqoy6PF0E/v9W3V1SY6EC+xglIfaxse4aOsdlwIUdkEwOAOiEUz2ghF/AqtkZchCKR
         OKZnqUO2CB3jLJMrBiwRQaIgWIkKH3GWcv57jtKRe+rzRAgujU1o1exd0A9hig9RNvKU
         z4wA==
X-Gm-Message-State: AOAM531+Gr6B2TT4eoAF/hD+5L7MUvOw7xsHZwf49e6OzXkQQj9P6zCo
        yzJPI/9xJpI5BbqyGm7m12VcJQ==
X-Google-Smtp-Source: ABdhPJyCZD37+5GLNdlIUheP0c26GJSlEs5udDlo9v9agnXPx/FZTudP0vSl0QZNMsVb0i1r2UAmfA==
X-Received: by 2002:a02:cb99:: with SMTP id u25mr7544235jap.73.1604941002534;
        Mon, 09 Nov 2020 08:56:42 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j85sm7576556ilg.82.2020.11.09.08.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 08:56:41 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH net-next 3/4] net: ipa: change a warning to debug
Date:   Mon,  9 Nov 2020 10:56:34 -0600
Message-Id: <20201109165635.5449-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201109165635.5449-1-elder@linaro.org>
References: <20201109165635.5449-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we determine from hardware what the size of IPA memory is
we compare it against what we learned about it from DT.

If DT defines a region that's larger than actual memory, we use the
smaller actual size and issue a warning.

If DT defines a smaller region than actual memory we issue a warning
too.  But in this case the difference is harmless; so rather than
issuing a warning, just provide a debug message instead.

Reorder these checks so the one that matters more is done first.

Reported-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index ecfd1f91fce3b..0cc3a3374caa2 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -160,13 +160,13 @@ int ipa_mem_config(struct ipa *ipa)
 	mem_size = 8 * u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
 
 	/* If the sizes don't match, issue a warning */
-	if (ipa->mem_offset + mem_size > ipa->mem_size) {
-		dev_warn(dev, "ignoring larger reported memory size: 0x%08x\n",
-			mem_size);
-	} else if (ipa->mem_offset + mem_size < ipa->mem_size) {
+	if (ipa->mem_offset + mem_size < ipa->mem_size) {
 		dev_warn(dev, "limiting IPA memory size to 0x%08x\n",
 			 mem_size);
 		ipa->mem_size = mem_size;
+	} else if (ipa->mem_offset + mem_size > ipa->mem_size) {
+		dev_dbg(dev, "ignoring larger reported memory size: 0x%08x\n",
+			mem_size);
 	}
 
 	/* Prealloc DMA memory for zeroing regions */
-- 
2.20.1

