Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50B32C7C19
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgK3AWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgK3AWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:22:39 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DC3C0613D4
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:53 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id l17so9038555pgk.1
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EkhG6AFxavZ5abglJ6kOnkEVdmyu4algVumO7xanA0Q=;
        b=j1/t0Gwc3huo4y0dlJdRRybuJmjeDfsOR36i+hsRhdeIK5/Q2CCr1jQZCnaAd5YbB9
         dCVdPb+rkBkiLIVRHJyyd6zrHP141RpwCir+UvbxPnVIzuX8GI5FNZY2u/0f+lZJ4juj
         p48Y3vLi9J6WmnwucVAK+u1f6bSIZw7d1cZh1oAKkgcLf3ZZoKYQkKSOympnbOpG7W8e
         sx+UFo4R9q6nj5AcccApUmBWXrzBE6BggRa4LvvhJyB+U535yhaFcWOvxueXfWCIfd0y
         /FOZ+mL9mQce/s4k2AjS/OLfaSRn5gOJJ81uGq1tXRDlRUBMLdeYRzJ6jvxrHLWVoVXt
         +uAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EkhG6AFxavZ5abglJ6kOnkEVdmyu4algVumO7xanA0Q=;
        b=Piq3205pt2cjDs9XNv4qdHTvzBWxRYJTsN6tp2cqAp3Ozwyqjx3Bv+n3XaoF774nBX
         +mCPAOUZH8Fzy/UVOloQN/RGbZWxErjbzSC0zh4PgLGPYvID9vszDN6BH+Wf34fMX2o8
         nLTp+4CVKaaAjya0QyUJ3FI8e0SqArp2vP6iSDluPK8ULSy3e9nHMzPQoNDbgQ2JnO4P
         oPz76bX/sJXlSgoW8Z3F2+SXIz0iavwmQ+t7gNa0m+nsF51LgkRlP45QIUx/sEdP2FeY
         uPvSb/B6uNvASx9mEHT5ar2Zcdu+V6ElsuiVzSHpOJr2yDDqWLFpI3/ZI3gvsaeVe3Po
         ixRQ==
X-Gm-Message-State: AOAM533wtAQdISuNu3z8NcuDN8Hx61DpFHSN13osNRgAmO1mJFZrxIK1
        Vsy+GVRT1xhse6gVVeKbsFsnLSFmk+0+7XlI
X-Google-Smtp-Source: ABdhPJx8GT8BJbot0A6yeIkmZ3Uc8weLLnW02ru3sse13V9T5/WAkruE0l3BKUJ5DenXO4u2eIYsHA==
X-Received: by 2002:a62:188a:0:b029:19a:cdab:9841 with SMTP id 132-20020a62188a0000b029019acdab9841mr5860089pfy.12.1606695712563;
        Sun, 29 Nov 2020 16:21:52 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d3sm20746129pji.26.2020.11.29.16.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 16:21:51 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>, petrm@mellanox.com
Subject: [PATCH 3/5] tc: fix compiler warnings in ip6 pedit
Date:   Sun, 29 Nov 2020 16:21:33 -0800
Message-Id: <20201130002135.6537-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130002135.6537-1-stephen@networkplumber.org>
References: <20201130002135.6537-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gcc-10 complains about referencing a zero size array.
This occurs because the array of keys is actually in the following
structure which is part of the overall selector.

The original code was safe, but better to just use the key
array directly.

Fixes: 2d9a8dc439ee ("tc: p_ip6: Support pedit of IPv6 dsfield")
Cc: petrm@mellanox.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/p_ip6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/p_ip6.c b/tc/p_ip6.c
index 71660c610c82..83a6ae8183a7 100644
--- a/tc/p_ip6.c
+++ b/tc/p_ip6.c
@@ -82,7 +82,7 @@ parse_ip6(int *argc_p, char ***argv_p,
 		/* Shift the field by 4 bits on success. */
 		if (!res) {
 			int nkeys = sel->sel.nkeys;
-			struct tc_pedit_key *key = &sel->sel.keys[nkeys - 1];
+			struct tc_pedit_key *key = &sel->keys[nkeys - 1];
 
 			key->mask = htonl(ntohl(key->mask) << 4 | 0xf);
 			key->val = htonl(ntohl(key->val) << 4);
-- 
2.29.2

