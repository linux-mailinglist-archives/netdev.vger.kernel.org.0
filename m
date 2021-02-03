Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772AD30D3E3
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhBCHJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhBCHIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:08:52 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EED5C0613ED
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:08:12 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id b2so31844069lfq.0
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BGpaEg0j3hIwyT8YaseDu5lYmdNhnyii6Jj6H/mUeXo=;
        b=SrBB7QvA95msna1CXnwB4FT1PiIyEtTe98i0XdNsRlzCAMVweHitTGoXL1HFNtAUkz
         04WXtj+nXB3sHHb2zPyyPydYMqHUKDYc1C96LmDopH5KV8y6YjLkSuMK6Fg+qTjH9uUc
         IZvDBkT4fRA30z384suXuawaRCBXgOogqa78AcIOdqji+OBotQTdCgDmqozs+s2iuyK0
         LFERMYBcYeXNFKvry9dzM8fyqu/XPmfb1Cc8Kf2cgli6qcFgBl2QgQUVyum+RDktes3Y
         2SJuQ+okkMQXUqY+weVYtcZnFtcOA5RXGfyXJoANLGBd+ynW3VwP5nU9DlildJrOoXan
         BWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BGpaEg0j3hIwyT8YaseDu5lYmdNhnyii6Jj6H/mUeXo=;
        b=B6LyiEGEsL9ptbrwcnk+Aa2PqrMlvyp68m6eHv5OaWRMRw+akff5s69CMPVGMvlt1f
         nbMTH+boqU2djh1xkceAeKOFLzGRfkmrxUjPnBaqvakcuYXO7UBYzmzdR91Ja4/MpLc4
         hEMGoZCXHfCiDgHPlr/AqqGsrnB/M51rsf2MEuTeJ5A8e7aQLCr0eDxkNUbKMHB6DGOx
         2Zaate42RhYFZ69yFN6UcxwgA3qo6RVmE0CKx9WR66jQ6CWiXxL7EJMh/hsxE5pHO9Xd
         cPZqpf90fB4m2ew+gSJysagU1aPb+G3HaVnwL/o/gk7m/85+Qu0ACQsrc0W/5SX+7XhJ
         uUWA==
X-Gm-Message-State: AOAM533xQ+UWcTpqMyX9wvuOvaBqHAaewmbg1V8GkTouG2m43jhR9d7s
        jSAnnUVttPPtJBQzmhpvbxfsKry0Ok0G5Q==
X-Google-Smtp-Source: ABdhPJzCVq6jCBkcI53pH+twexFVq4JgLEZyCH4e/NPfELAJ+gQhoWcwkgqocI96oukLF275bVDmoA==
X-Received: by 2002:a05:6512:52f:: with SMTP id o15mr949378lfc.401.1612336090618;
        Tue, 02 Feb 2021 23:08:10 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d3sm147367lfg.122.2021.02.02.23.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:08:10 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 3/7] gtp: include role in link info
Date:   Wed,  3 Feb 2021 08:08:01 +0100
Message-Id: <20210203070805.281321-4-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
 <20210203070805.281321-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Querying link info for the GTP interface doesn't reveal in which "role" the
device is set to operate.  Include this information in the info query
result.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5a048f050a9c..5682d3ba7aa5 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -728,7 +728,8 @@ static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
 
 static size_t gtp_get_size(const struct net_device *dev)
 {
-	return nla_total_size(sizeof(__u32));	/* IFLA_GTP_PDP_HASHSIZE */
+	return nla_total_size(sizeof(__u32)) + /* IFLA_GTP_PDP_HASHSIZE */
+		nla_total_size(sizeof(__u32)); /* IFLA_GTP_ROLE */
 }
 
 static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
@@ -737,6 +738,8 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
 		goto nla_put_failure;
+	if (nla_put_u32(skb, IFLA_GTP_ROLE, gtp->role))
+		goto nla_put_failure;
 
 	return 0;
 
-- 
2.27.0

