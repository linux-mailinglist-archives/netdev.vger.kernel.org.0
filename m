Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD37A24490B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgHNLli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgHNLkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DB8C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:14 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d190so7207792wmd.4
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eeO60JjEAZIznFwCMtV3AvBpAyOLH6PI1v4S2BhJUMA=;
        b=nolgDExN35FECbtrc24iEOWD7RfDFbN8/TyWWnFUzFMH/xO9mu7Nx8VxkSOUxZDULJ
         WGtlSG/PDFbzGNGDQbtk37OWXP2S8NlrnczKNWWX1Rp11tOTaKMr8jmJn2Tp9AxFa8x5
         Oc0CB7UC9jLXzkDoS9S/jhqeG1SI6YhRci7mzdkLktsLCcKnAkDq8xM6OHK6C7iiFpX6
         FEc7OMpKW3nIeV2eQIISAbcrO2IQySwJ7FxzcV/ZMz7H0jGfCQrl2DJYPGuPZ0GXsZgh
         DPIGoyUgvcv4UhZYpJKMOfxieIZNxKPh1GWlgN+EFC+jADmNhJkaN4qSa12o0EDc8/+l
         Ml+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eeO60JjEAZIznFwCMtV3AvBpAyOLH6PI1v4S2BhJUMA=;
        b=c7euAtMZrP0lnJ9gQS7bdEWN92+v63UIYR5v+fh074ZLAYUxxHwclLGHNT3+efmWbq
         vlP79APg5qEFbfIgZ26+E7r6iJFuipaDVxqbjfjMQIx4dT42qKInXSenCtIRYFbhwUcR
         WkqrLVncn1S7RdTePTQS4H3LHp++CbnUTP6fKUHbAdSv1QunAPuSt5KjRdp7NjaEXD8N
         gu9tIe+hOFby7+Dc2fR2r7D7TqS4AYx+FIm53f2N2PRHNUUUIas8DgrA6LWblE23vOO3
         4WYf1kJmRZBNpjJ4ThFU4C0my/T6h45pecImGiuy4Wv3IQ7/Xgqzl3zuUdEK+nj/L1n1
         OiHg==
X-Gm-Message-State: AOAM531tFWjbTixMCA8GH0MH6jj+Dso5YPVIWJVMGIBrNIRJER+zdUw6
        xivnhniTrjRzevjeXwEBVP5RRw==
X-Google-Smtp-Source: ABdhPJw299VOAGaSIY6uYBiim4ZDaSskjd0OAiF9SHdEIKBvr+q3l9ynAWL4wwQ+nQuFxdawXEC6Dg==
X-Received: by 2002:a7b:c941:: with SMTP id i1mr2167015wml.73.1597405213070;
        Fri, 14 Aug 2020 04:40:13 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        netdev@vger.kernel.org
Subject: [PATCH 21/30] net: fddi: skfp: smt: Place definition of 'smt_pdef' under same stipulations as its use
Date:   Fri, 14 Aug 2020 12:39:24 +0100
Message-Id: <20200814113933.1903438-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable 'smt_pdef' is only used if LITTLE_ENDIAN is set, so only
define it if this is the case.

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/smt.c:1572:3: warning: ‘smt_pdef’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/smt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/smt.c b/drivers/net/fddi/skfp/smt.c
index b8c59d803ce68..a151d336b9046 100644
--- a/drivers/net/fddi/skfp/smt.c
+++ b/drivers/net/fddi/skfp/smt.c
@@ -1561,7 +1561,7 @@ u_long smt_get_tid(struct s_smc *smc)
 	return tid & 0x3fffffffL;
 }
 
-
+#ifdef	LITTLE_ENDIAN
 /*
  * table of parameter lengths
  */
@@ -1641,6 +1641,7 @@ static const struct smt_pdef {
 } ;
 
 #define N_SMT_PLEN	ARRAY_SIZE(smt_pdef)
+#endif
 
 int smt_check_para(struct s_smc *smc, struct smt_header	*sm,
 		   const u_short list[])
-- 
2.25.1

