Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D48628A03
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbiKNUBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbiKNUBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:01:40 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A75A3AC;
        Mon, 14 Nov 2022 12:01:39 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x2so18928432edd.2;
        Mon, 14 Nov 2022 12:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qgEFTpfru0TP5dduWNUns3KhyePG9T+scnEKT6I0Amc=;
        b=URiV4ZMYsyZIoIFgJQfs3EqLUBBwdL7swXYQoOgnzFIg2HwSAcpGsACYIIFmilbJ96
         V9SSVAH4iY2rLmDbHYxBtJoiysDFYi8b9/OEo/s2v2W5iYPK1rG2kzLNaShQEFHNcqCt
         9EKejsS4VdHJ7K9iJgvHABGJ9QjKid3y2gLfzzf9nD0zHJVmRSXNsRysW6q6RsAkHcFx
         4wIoW0Vaax3A+s9q7SzkbvcmpaAGF+UO2+JQ2J0tMZ895n+VgReYKWkIIblnTIZ8mchT
         pELMOfcpolEwIgTdV/+/Fqu7lcyJ3zGwYfr1m77sAi+GA46D5ZkfEI7KfPHNj4GRr+Ua
         79iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qgEFTpfru0TP5dduWNUns3KhyePG9T+scnEKT6I0Amc=;
        b=4ufi8ASmWTD3ybmID12t/42hT0loQU9neqdQdOSU2+fJn3n7+r3ETZcHYrWdhifBFp
         Xi5owz3Kp0oM7hC0c/2j6PoyQvDT4gEmVnrc6C2yHOfKumXX301Dbde7EtYD+ZYz3yMD
         0rX1J5rxcq80FwuaMJY4i4FReyjSwOb8Ej3gh6zydKPkCvKUJGArAoP9DCa6kWi/7UPH
         Ai+SS3/lj6BXSUj5HejZrK/UFhKmk5SYck5okepOqipt3fPVmIaNrkQLVhEB1vivJfOi
         5OxYf8n/r/K7SdraD/4hDga2cFKZ/UmgFTwEySj3K0Cp91fX32QL8TdFC6k2rU/Xr3t3
         SyhA==
X-Gm-Message-State: ANoB5pm3cpnDp2kBgLhP5Zs2cmiEXT7k88zjSrNgs/nE6HeeXJZPPnT/
        fEZUvuorW6Su2s4f2SaLff0=
X-Google-Smtp-Source: AA0mqf4tC3PSryKYZC57AtnHN6m7iP2oh1sOfw5r0hp/1+Crl85nfK7ZvfbvOnbGLMkv6RlGMoms/g==
X-Received: by 2002:aa7:cf07:0:b0:461:f1c6:1f22 with SMTP id a7-20020aa7cf07000000b00461f1c61f22mr12863520edy.95.1668456097647;
        Mon, 14 Nov 2022 12:01:37 -0800 (PST)
Received: from matrix-ESPRIMO-P710 (p54a07888.dip0.t-ipconnect.de. [84.160.120.136])
        by smtp.gmail.com with ESMTPSA id p9-20020a05640243c900b0046447e4e903sm5217776edc.32.2022.11.14.12.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 12:01:37 -0800 (PST)
Date:   Mon, 14 Nov 2022 21:01:35 +0100
From:   Philipp Hortmann <philipp.g.hortmann@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: cfg80211: Correct example of ieee80211_iface_limit
Message-ID: <20221114200135.GA100176@matrix-ESPRIMO-P710>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct wrong closing bracket.

Signed-off-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e09ff87146c1..ba45a49c8c84 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4740,7 +4740,7 @@ struct ieee80211_iface_limit {
  *
  *	struct ieee80211_iface_limit limits1[] = {
  *		{ .max = 1, .types = BIT(NL80211_IFTYPE_STATION), },
- *		{ .max = 1, .types = BIT(NL80211_IFTYPE_AP}, },
+ *		{ .max = 1, .types = BIT(NL80211_IFTYPE_AP), },
  *	};
  *	struct ieee80211_iface_combination combination1 = {
  *		.limits = limits1,
-- 
2.37.3

