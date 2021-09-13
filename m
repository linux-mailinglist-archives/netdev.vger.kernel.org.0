Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2451409769
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbhIMPfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbhIMPfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:35:30 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB50C12C75A
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:44 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id a4so21636812lfg.8
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LYtrDDoObxsNg9Qa7tHy5LD0Y+VUcx6GaTlCkfBdhkQ=;
        b=YL6zKWNz3wU/ISXiZadwLvMF586w0XIR0RTFi2tr9IPTOGvvOrF2Gt+TWW3RuXQvRR
         eobC2QEIK+DsCqtLcXgf+a2B28zMC5vOP/E0P4f0kvWkvFNfqyDwssQ/USmSfBik5XAH
         IU8Cys0uNY/eY11UFlDlDCuVsge/sK5iS/QexhK7jJ9ukkFSUMHs/8LlZZBlyJjoFNkh
         OxCfb6OZQsNXN4U2wm0OeQUy0D/WZHbWIkH+xp1ghf0Im7dWbQlRODEtQroqsLV2tXzC
         0DUqU5LVebvRzg04aJ6+6zrZfSYaptMMqrsUF1sJRUvUnjJXHbjCjzmgydVA7GOtKPuG
         5n0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LYtrDDoObxsNg9Qa7tHy5LD0Y+VUcx6GaTlCkfBdhkQ=;
        b=Xadlf0LmuMpOFmUyjywc1Be6/aJcVk96Sd1nid0D07cCO/zK1X67HsuphLSF1qFGy+
         /f2WdGskjfDaDNoVv3EHvZoSOPYKmvS+hc462mdQThCP4oN7cySBuovXUNGlHSzsPc/s
         s4WVh/mRKw84v5cbPDMfEOPoGQWsaMTFtYV4p2tmv444BqUjLV5Z/bifQnZ/KRmdz80F
         Wg2/iXPKG3XhOC1QOdyegTmz+a/vSW809PIJUIgP05Wz0ftUd0erJgq4f8vMP7Np/2KP
         du3qTXRLIsZM9MQZSmZDk5Cr8oSlUHyINKZ8YkWJrwvLESOZHy9EHXfcJjpDILX10yR8
         h7Jg==
X-Gm-Message-State: AOAM530TnkV0fIPoT0IXDbdKR38X54Eq6mz2HHDD5G5Zoqqk/0Ee3I+J
        VJkkd0i6B654Pa7T9CW1Vl1kCw==
X-Google-Smtp-Source: ABdhPJyd6tFq/gLGkcz8y8IRgMiKQsbahE8zWxtzdUTAj8hbKj53WRBOPJHbk92z+wDCR0F5nBE43Q==
X-Received: by 2002:a05:6512:903:: with SMTP id e3mr7707690lft.668.1631544341227;
        Mon, 13 Sep 2021 07:45:41 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id i12sm849825lfb.301.2021.09.13.07.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 07:45:40 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 6/8] net: dsa: rtl8366rb: Fix off-by-one bug
Date:   Mon, 13 Sep 2021 16:42:58 +0200
Message-Id: <20210913144300.1265143-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913144300.1265143-1-linus.walleij@linaro.org>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The max VLAN number with non-4K VLAN activated is 15, and the
range is 0..15. Not 16.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v4:
- New patch for a bug discovered when fixing the other issues.
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 6c35e1ed49aa..dfc8ef470972 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1456,7 +1456,7 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 
 static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 {
-	unsigned int max = RTL8366RB_NUM_VLANS;
+	unsigned int max = RTL8366RB_NUM_VLANS - 1;
 
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
-- 
2.31.1

