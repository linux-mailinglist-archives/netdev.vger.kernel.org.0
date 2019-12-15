Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8269311F9ED
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 18:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLORvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 12:51:39 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:38608 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfLORvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 12:51:39 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 47bX5k1XZKz9vJBX
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 17:51:38 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LA7sT2wT9O_Y for <netdev@vger.kernel.org>;
        Sun, 15 Dec 2019 11:51:38 -0600 (CST)
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com [209.85.219.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 47bX5k0V6Rz9vJBS
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:51:38 -0600 (CST)
Received: by mail-yb1-f198.google.com with SMTP id j194so2966157ybg.7
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 09:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2rmODKEIc4MD7niBVNAG3srAMkULqKzaTtL5GsTPKr4=;
        b=ndUwWqTOV8eJgWkt3A+zimBNrqZgOkk4mx82UHJiTFnfV5SPWHQQ/3mOwqM+X/lEcD
         wHihFytVBZVKo/KzHSkPWexBwaXWsEElfLMoJlUxL5qOFl/BgxyPAZckxakspyZFRKAy
         QNJinof2FUVltCN4q1Ozd4YV28BwwPHedse8GA1De8GQgA0zCG94iA4bj9Lap8qylAfC
         6/68JxtNZ/oxCXTc0ddGKRUhrqI5Nh5DyEsqJd9+OZZ6HxvR9R72wY6yqCuPWVXfze6Q
         1fTKElcBSqHUBAWzDe7F31mkJv4FO757xdIJ4cQWKeAV977SVLjQnQAyKcLfUDVwrbuq
         TaKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2rmODKEIc4MD7niBVNAG3srAMkULqKzaTtL5GsTPKr4=;
        b=aal4LA6732n+YXZB+g+EpRUOn5nbxmAls9YnfARBlYmXLqU8Ud4tQ1euAU7gYN9FM8
         9fe/6NRRV58iaPCsCswR+aPDRjT3vL0qdcrYx1h1Jz3ae1OdCLJ1GhnaiTFglszHzalf
         39UKHhmtWTxtvlIm/CJ9YcBnGE+0sce73iV6MlBtf2iPxS/XTh5HY3TmZsfpAI4lS7Un
         phLvZM9Lf4U6BWU+8FPN84mBi6jxTJkzIQIHM4Pg0AM7TFC9dTgKN7Cqt38nOceCwKwF
         MR/dLNImvG4mMe4l12/rH84Jk71ysYkjFIkWTtbqMCRwycIhSNC6RADLLHX2IJnY8sVt
         WwKA==
X-Gm-Message-State: APjAAAWVG21sxZU0UPqkMf45LZfs9MHbzoQIrvfIL2inkyyczfVo6JNQ
        RkN8dkPlC4k9IPYPil0EwohTzFAKsLuGnZKiV/VgkwKMIIpD2RTg5ZuTrPTO0Y1lJldGHWGN2aZ
        RoFkjo2X/g0LMpT3ha3Gh
X-Received: by 2002:a25:4290:: with SMTP id p138mr13981241yba.112.1576432297514;
        Sun, 15 Dec 2019 09:51:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqw0HHeIjcH7OnOW2tenzQrKmWXlYm720LYOj55jH+SMODNilD9yyzR9CazJpICeyA4QsooJTQ==
X-Received: by 2002:a25:4290:: with SMTP id p138mr13981225yba.112.1576432297273;
        Sun, 15 Dec 2019 09:51:37 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id g5sm6210011ywk.46.2019.12.15.09.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 09:51:36 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Richard Fontana <rfontana@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yang Wei <yang.wei9@zte.com.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: caif: replace BUG_ON with recovery code
Date:   Sun, 15 Dec 2019 11:51:30 -0600
Message-Id: <20191215175132.30139-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In caif_xmit, there is a crash if the ptr dev is NULL. However, by
returning the error to the callers, the error can be handled. The
patch fixes this issue.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/caif/caif_serial.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index bd40b114d6cd..d737ceb61203 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -270,7 +270,9 @@ static int caif_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ser_device *ser;
 
-	BUG_ON(dev == NULL);
+	if (WARN_ON(!dev))
+		return -EINVAL;
+
 	ser = netdev_priv(dev);
 
 	/* Send flow off once, on high water mark */
-- 
2.20.1

