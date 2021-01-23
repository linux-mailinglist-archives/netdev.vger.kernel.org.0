Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C523301828
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbhAWUD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbhAWUAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:39 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C216DC06121D
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:40 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id p21so7220468lfu.11
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D4axjSfGQ2KiBmAfemDsyXw/2yGOzXxndCOpqPCFG+A=;
        b=yEcAXsJCr2YzWoYpyveMY0W2UqZPL87xtYnBeBEO/BeTwNN6G+IvgvCQM+v0Yb5Mgc
         xqlGsU1j9qSD6xGWiPBx0j/RfpREIraz0euEfU8p1QMqP0r/0KCGv7IrPgjF9VLxCGP0
         LI+a9RKXdKjgNc5xLQM+xl1BuanVgMHjj2cc2KLsciM3MFOcio7G9lpnlvg7qMx+nf9Z
         U+Qk4SUYV2z9FVdoELzfBI7emI8rEMhbbwuRqZY4bV3XsHtMhSfBmNwStJvY8xvCdWcI
         w3UqtWSHVw8NG/5QvOG8Fkq6luG0W41UbuLygZwoITEevI76JzCXVzlko0PdwY7bFDfT
         d7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D4axjSfGQ2KiBmAfemDsyXw/2yGOzXxndCOpqPCFG+A=;
        b=Mrss8siMxY7jIzWnewghoZxr3XPjwY/piySVzKmDePQ/631+7fk6b+U6siFPyCp0xM
         R0GeonZ+Z//bgoDaW2AYAlFAavUD67J/i+3XXh1EnF0JVIYS5IWdJ8vhKnjSplucJqHj
         8qtrXyQexZ8uMwmt3qFkb/IrrYp/HOT8QVn+c9zs71W+687H7X6i4Xj945BZhoxsaA4R
         PtEy+zt600dVGOuTqcF1BNPWIVEUsNGAhNWO2TuWQiHDws3EBB9iig0Ep+aS3Hk1RkOc
         iQxNgZlPRGKaize0CYqfXbuCbcHtT23xjcafr+ulWAZl7SjvwKCQ07BAbpiWwQTzHA1d
         RQvw==
X-Gm-Message-State: AOAM531eXQHe2mRtQjD051vfXwOhijffc1/rxK3M/8Y1STZZM4BhqxXg
        zo+/8ZDzLHxyFPl0ompyuo44ww==
X-Google-Smtp-Source: ABdhPJyUv+zz6zbPNQkhpBtWDpDjNvNubqnX7wSMwUlC/u3cUupYewMBfe2FkRa4bSU8GIyQwdQuSQ==
X-Received: by 2002:a19:6b0e:: with SMTP id d14mr631098lfa.210.1611431979390;
        Sat, 23 Jan 2021 11:59:39 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:39 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 11/16] gtp: drop duplicated assignment
Date:   Sat, 23 Jan 2021 20:59:11 +0100
Message-Id: <20210123195916.2765481-12-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This assignment is already done a few line earlier.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index c42092bb505f..023d38b1098d 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -268,8 +268,6 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
-	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
-
 	pctx = gtp1_pdp_find(gtp, ntohl(gtp1->tid));
 	if (!pctx) {
 		netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
-- 
2.27.0

