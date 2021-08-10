Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92A3E7D05
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhHJQCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbhHJQCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 12:02:39 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF81C061798
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 09:02:17 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e186so30923088iof.12
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 09:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1PRnQFLgAZaDD7EbkN4+BWtHqGym0jkd6ykX1SJWWbg=;
        b=RgaCat+Wj7sgZfBz3lRTE4ZluwhtWbKv7VRgfVdJX5vymBcX2czGapoM2BDWpbdEIX
         skDkn4uJH176nacMm9IaQoXjxR6JR9cnEnkSkIW0y/s2u/rS2qUvA9k3gP3jsMUxMK6F
         LGWh1NcUskwLYdxTFSos2FIV6hW9yGkfNmCtauUu7RdckLLE6wey+CcP+Dyl+Z4fTFZU
         TTTgdxLRnaSXVK1zfT236/gCz8ar73Fgdra3zOOeXtcAU28DYiJeXEuX3rJSCpDTLx0l
         fNB5M9zPPYBMJOPlsER7dNsQupPlkuQir2bZnHC0Hlkdn+Frk7y9y3wdvGfLOsoBf0hL
         6kdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1PRnQFLgAZaDD7EbkN4+BWtHqGym0jkd6ykX1SJWWbg=;
        b=TI4P1OMPfr8/60Xpyh1UZIJANIIc4Lq98ya/3uc3r3oUVLZzfyv5aCH9S226+Y3eut
         ri/B8gVKQOGBp4WOgWOppyLuBR3KbMDp4Kp9vB9Pwu59x2ZkZ5LFdhUmWLlzwhWP2USG
         u7u/LeHjC8e/tImuSHHYHdnW+u34sv5dt90uvPiSzC0UmGcIieXXqeyzXADAFUoKlrTx
         aCdm8E0Ozm9sQB+57UDBdJXAuBVoKiERntHi305qNA6YX77eqRUynFkxewiwbkrEASFp
         pg7+P9hrSu6BYFzqKLZLofbxVxKrQoMlGNv1cZiunlokLbd1BqWdYyuVAfUzwMr9utrI
         TptQ==
X-Gm-Message-State: AOAM532q2/KAaKe9PhXQPK/TyDt6m2E9KiYXJc+Uh9P0IiqlRGW8DI+e
        OflJ3lTGAj/bclDwNUs+iRwUNA==
X-Google-Smtp-Source: ABdhPJwLbvmmEDn/Srer4jrtXyQHYRDsJF5nBQ77YAuwBPv0xQcvbyNmJ6eHC4HvCrLCdlLcPWQMzw==
X-Received: by 2002:a02:c9c4:: with SMTP id c4mr4735367jap.67.1628611336887;
        Tue, 10 Aug 2021 09:02:16 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p8sm12765248iol.49.2021.08.10.09.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:02:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, lkp@intel.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: always inline ipa_aggr_granularity_val()
Date:   Tue, 10 Aug 2021 11:02:13 -0500
Message-Id: <20210810160213.2257424-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It isn't required, but all callers of ipa_aggr_granularity_val()
pass a constant value (IPA_AGGR_GRANULARITY) as the usec argument.
Two of those callers are in ipa_validate_build(), with the result
being passed to BUILD_BUG_ON().

Evidently the "sparc64-linux-gcc" compiler (at least) doesn't always
inline ipa_aggr_granularity_val(), so the result of the function is
not constant at compile time, and that leads to build errors.

Define the function with the __always_inline attribute to avoid the
errors.  And given that the function is inline, we can switch the
WARN_ON() there to be BUILD_BUG_ON().

Fixes: 5bc5588466a1f ("net: ipa: use WARN_ON() rather than assertions")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alex Elder <elder@linaro.org>
---

David/Jakub, this fixes a bug in a commit in net-next/master.  -Alex

 drivers/net/ipa/ipa_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 25bbb456e0078..f90b3521e266b 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -255,9 +255,9 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
  * less than the number of timer ticks in the requested period.  0 is not
  * a valid granularity value.
  */
-static u32 ipa_aggr_granularity_val(u32 usec)
+static __always_inline u32 ipa_aggr_granularity_val(u32 usec)
 {
-	WARN_ON(!usec);
+	BUILD_BUG_ON(!usec);
 
 	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
 }
-- 
2.27.0

