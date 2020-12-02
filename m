Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B63E2CBD14
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgLBMei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgLBMeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:34:37 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1171C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 04:33:50 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id v14so4459345lfo.3
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 04:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FhG5NVwi3he/NHTo8tsbfZd2R/LsNay6u/YWj2xHQDs=;
        b=Hou5SRlyrB5ySUuzNXiysaseWuJkUJ6ooy/axOtgMXAYO/WIiDJWpYu59zG+64uM2x
         H4Vuw0623NIYCePybPwB10Y+hvJAJqiycLwBCeiK1Ljnkbrou6cuETCf/WLAB39KWYjv
         gDWKBI58teFBmTdihz3p5RnUIx59099cJeL5HPMUrg+D8BlnGdqeeG4Xj/mYSNekf98v
         qjPgjY2eXGc+gPwmGBxevtz4ZSdqQODiVHh1Kx+fB0FOQjhgKGm2O7YDpr7Ar1nH+8wU
         nvWJ2mC26bEU7aH7Lx2wO1pDJkaOKJmeA72OS8NIVZoCZ1IpNfbUanCp3JuDBR+yFI2E
         H4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FhG5NVwi3he/NHTo8tsbfZd2R/LsNay6u/YWj2xHQDs=;
        b=FQkk5/xMMvEzL/C08CzG5qsgpl2dyK+8DDevuC1pn1N19Uu1clu1fZHifZhPS/62so
         pJ+ie4NP8/24CFKPgOoH/mOVi1D949j4S7G2MmuP1g+a+MLxyZky765jbF4OcMY+Xa1Y
         eHKqYeULJxpm+lDtqoURr2jJHe/NNAtnD3l4sdvE08QWIYTwyb5s1kBQRsD1Kh4gSlzq
         KXQt+yadSIMF37dpXJcFv9SATNYYG4LaVnRS74W8+XLfe4Rjaj8VnnIG4Q4et+YAgLSX
         HjcI7WUFD/6rQX0/xJdLgVyo8xOKq1V0afcT4C8YZYAr4GtYp2HgGQ/0RP3ULAm2TNk4
         JIYw==
X-Gm-Message-State: AOAM530U/cAmY+JD0nV/Jg3x7LcC1rwdpPhkJOsfMDIkjTYvPkIgzix/
        cTzeLUw6sPgkS05y2iOYq4LhFOlG2K+AMw==
X-Google-Smtp-Source: ABdhPJy7QgdZ5vSyBrUvJu7EHHuwsV9s7wHipndpyjuDxTF4IyDvs0zBQXvwXybHQhBkLPxemCOJ8A==
X-Received: by 2002:ac2:5619:: with SMTP id v25mr1131978lfd.102.1606912429313;
        Wed, 02 Dec 2020 04:33:49 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id m7sm439230ljb.8.2020.12.02.04.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 04:33:48 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org, pablo@netfilter.org
Cc:     laforge@gnumonks.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 2/5] gtp: include role in link info
Date:   Wed,  2 Dec 2020 13:33:42 +0100
Message-Id: <20201202123345.565657-2-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201202123345.565657-1-jonas@norrbonn.se>
References: <20201202123345.565657-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Querying link info for the GTP interface doesn't reveal in which "role" the
device is set to operate.  Include this information in the info query
result.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5a048f050a9c..096aaf1c867e 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -728,7 +728,8 @@ static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
 
 static size_t gtp_get_size(const struct net_device *dev)
 {
-	return nla_total_size(sizeof(__u32));	/* IFLA_GTP_PDP_HASHSIZE */
+	return nla_total_size(sizeof(__u32)) +	/* IFLA_GTP_PDP_HASHSIZE */
+		+ nla_total_size(sizeof(__u32)); /* IFLA_GTP_ROLE */
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

