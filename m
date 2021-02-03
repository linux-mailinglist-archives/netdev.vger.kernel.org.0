Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3CF30D3FB
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhBCHQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhBCHQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:16:26 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC665C061573;
        Tue,  2 Feb 2021 23:15:46 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id s23so15421028pgh.11;
        Tue, 02 Feb 2021 23:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCplaxx+G/WjU4K1QFLVkvqSzFQBK1Dh3zZTYlV1r9g=;
        b=H7MtAneniyH/4SWxkj4bIPDg7tNEFkIJmh/URu3iGiyAFYphZBpJdujnazu09VQck3
         6u0lD0VnvKZoXmgSzyJzLvqHluXddaEYyZAfF0MX2qNpGe09ihytlVR0eDbuLPdHh6iZ
         ZSzh0CQ+Y1tKictzkI2yF1z9Y1VyiRMSpGFpKSgvfwu+APdWIVhy0pfkJ2O5BQ7P5n1D
         haYaPd6W6xc3Kl7B91dBYReDPKHfMwzUn0UrcajujUffzjTk4tp8SKDKMj9Vx9ceITlg
         OGiCea81wNVbm1Z3T2H6eizyc47z9id8x/EuOELUuD9QPU/fbWhhgr3yKxqIMkoHIS9C
         j97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCplaxx+G/WjU4K1QFLVkvqSzFQBK1Dh3zZTYlV1r9g=;
        b=lCurIech23kh6Zu7zTKkO/x78ZNSyVFU+0MiOLpzgVGFdIhwKG73/YpLzpcSI/KFA2
         AiCliG09QK7/282jWOFzT68/T35Em2XA/2t8zBuYENFitSGNWQsGt8K7v6aI0oEJr+4N
         QbaGGeZlkrS+j2Hbex2OJMI6smb6VvQZuNQw6gIYwIXvyNDptnOlKaEsAkWGO5krBbdb
         thtoz65VTJEu3ox9IXnWRiqZqq3VnT8KRYdWoy7E1/SvxKvnvzVhcrthpeVG49320cYE
         yzLqBd+OPeekOnkmiOV7W+mcy+t0vlzD5iM8X72ZUvXjI77KwUusf944QiJjzHqekHq2
         X5Bg==
X-Gm-Message-State: AOAM530FFAY/4jk3lXrMMq7+pB8I7TMQOuE6OsIK2AH6H6KwThVl1QCM
        pLMvCEFKYdBs/UxtPX4uAfY=
X-Google-Smtp-Source: ABdhPJxF+TLd/Rwb5SOiSykgs+fVTnABwuKomE9qt6YqvQv/LDVptKNkSrO9I7uzHmCXNUsFZqY6Ig==
X-Received: by 2002:a63:a03:: with SMTP id 3mr2139589pgk.366.1612336546333;
        Tue, 02 Feb 2021 23:15:46 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:1828:42e5:bdb:81ad])
        by smtp.gmail.com with ESMTPSA id b206sm1158252pfb.73.2021.02.02.23.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:15:45 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: hdlc_x25: Return meaningful error code in x25_open
Date:   Tue,  2 Feb 2021 23:15:41 -0800
Message-Id: <20210203071541.86138-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not meaningful to pass on LAPB error codes to HDLC code or other
parts of the system, because they will not understand the error codes.

Instead, use system-wide recognizable error codes.

Fixes: f362e5fe0f1f ("wan/hdlc_x25: make lapb params configurable")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_x25.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index bb164805804e..4aaa6388b9ee 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -169,11 +169,11 @@ static int x25_open(struct net_device *dev)
 
 	result = lapb_register(dev, &cb);
 	if (result != LAPB_OK)
-		return result;
+		return -ENOMEM;
 
 	result = lapb_getparms(dev, &params);
 	if (result != LAPB_OK)
-		return result;
+		return -EINVAL;
 
 	if (state(hdlc)->settings.dce)
 		params.mode = params.mode | LAPB_DCE;
@@ -188,7 +188,7 @@ static int x25_open(struct net_device *dev)
 
 	result = lapb_setparms(dev, &params);
 	if (result != LAPB_OK)
-		return result;
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.27.0

