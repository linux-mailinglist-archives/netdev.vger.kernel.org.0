Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2756CD37B
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfJFQUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:20:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42944 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfJFQUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 12:20:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id n14so12381013wrw.9
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=21XlraqO5v6935P75+EMAYXu0ZygoFz0HfWWT7WbXtQ=;
        b=JVHHFKzVfhizC7csayuDKOdq+cBIglc6oMuE7oL1zrc1aKxwV4ZHk1NamFZVMr3kUe
         YkRFJMnwcHs5N0juMeb1rU1Xxl6/eff4/yRJgDEGKOasYZHJ6xK7QKcKoVE6/IZtsxmO
         7pDQMxC1nkLhDtLYIGzJY1HsfC5CVljIokV76XglC/Xdk5/ElR631ahuSUz8A9L3Ti52
         Zy8WwZoyeIuki6JdPbZeMfMIAdg3Zd0Co58RfmbiML2iGBk2jNNA+40lnKnlRXGuDhJv
         PZHPnjhURX3DrYxLNUeAqXEzWcNHukiq9+mYKraKoIaNAPzqmc92X5ssv8pDgj/4BIHW
         EFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=21XlraqO5v6935P75+EMAYXu0ZygoFz0HfWWT7WbXtQ=;
        b=CXn7euZvXh9/6vif1tHPg2Ms+Y5LyiASmfhac1b1P078UwM/HixblyqOp2swP3YBlN
         2v7ymmuOrYYbRQa5AVZlpyKI5wLywH1oTEWReRT8P6hsmsOwncCcnTTmDb/EyzFJaR99
         f6FklF/PpUGzduoMRnkLYLiy12EXWZuAjXWxeow6+8raci2AP3QMJcXXlkQ/caKBD20W
         pzp1ymW+yj5Cukm7Xsn03NEt0IGYP5Ef3P1OM2frhR0HJ93o+FtLrLDTxP6eRa3AiQEU
         DbbiW4RHJqtXPVTnec7NpPZydtrsklpOrkp9XFWFXI0qiiokbdmotJ5oIrVNTJcA0VPn
         TShQ==
X-Gm-Message-State: APjAAAXXtrszk2kQSjriUWMfowy0AnyQEZFHY2Gqmndztl42THn/Kwv7
        4E6CQUk51krLip3J+RuWYmRMBj7a
X-Google-Smtp-Source: APXvYqzbJZgWHnoo/1WCdPwbMKlt6df8mDLlOUJpWwnmKrrY6fEU8gzr7KrOL0Vh0S3e8LY1uSfpPQ==
X-Received: by 2002:adf:f20e:: with SMTP id p14mr18108423wro.212.1570378800628;
        Sun, 06 Oct 2019 09:20:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:64e8:8137:5430:1a37? (p200300EA8F26640064E8813754301A37.dip0.t-ipconnect.de. [2003:ea:8f26:6400:64e8:8137:5430:1a37])
        by smtp.googlemail.com with ESMTPSA id t4sm11069506wrm.13.2019.10.06.09.19.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 09:20:00 -0700 (PDT)
To:     David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: core: change return type of pskb_may_pull to
 bool
Message-ID: <8c993693-cbef-e401-bfc3-c2a915621c51@gmail.com>
Date:   Sun, 6 Oct 2019 18:19:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function de-facto returns a bool, so let's change the return type
accordingly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/skbuff.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4351577b1..0a58402a1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2261,12 +2261,12 @@ static inline void *pskb_pull(struct sk_buff *skb, unsigned int len)
 	return unlikely(len > skb->len) ? NULL : __pskb_pull(skb, len);
 }
 
-static inline int pskb_may_pull(struct sk_buff *skb, unsigned int len)
+static inline bool pskb_may_pull(struct sk_buff *skb, unsigned int len)
 {
 	if (likely(len <= skb_headlen(skb)))
-		return 1;
+		return true;
 	if (unlikely(len > skb->len))
-		return 0;
+		return false;
 	return __pskb_pull_tail(skb, len - skb_headlen(skb)) != NULL;
 }
 
-- 
2.23.0


