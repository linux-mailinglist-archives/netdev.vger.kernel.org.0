Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44598497463
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbiAWSjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239568AbiAWSjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:39:52 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA6CC06173D;
        Sun, 23 Jan 2022 10:39:52 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 128so13764292pfe.12;
        Sun, 23 Jan 2022 10:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/+jlT2lVXINBwoznetut/x5ZWQNE1yPkmkCWTyEGTdo=;
        b=WlBppxzgPlWg5Fo+7JOPT7hwoRV2dBbTOigaUI478r8KWllyra55XVUV9RfIMfsKlO
         lK/Z57nJOs3uZJYYR89Z627ep2lilGBNNvV51oOLJEUCil+VoUQzDO3iVymmYDo4Jr6e
         8Pyu5ceHZYdzwjGEgpUaLqykJppsp8vGmwcMd0U3+Vf+sNStZCYZXINjTdKftHLtxeWb
         aBx2DfLfxsA1E9xout1XqlvKwHGiV9lsTjLlaQNrIs63fkeq/ynEUrmKNYiJo/0bdiFn
         HTpQbXeGvTWjrpcuEkQ2jAVwneAiSL0tCPDcazSQIsW+u1L8DjED/rWgyW5uC1H810jF
         Rw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/+jlT2lVXINBwoznetut/x5ZWQNE1yPkmkCWTyEGTdo=;
        b=wTgqhyuCVM8sdtLxgQ4f8dLXBcPsA7S4AdHU82L8kLbPhCLao506z1diJaspBFp/gJ
         4Jfhf7CDOs8fpYlG/1ubMgiFdxWml7Csl1eTFoadbmOVSP6U6glxW1Bh6/1eWx0ylGxL
         dgLPNPA0bXedJqWPFwc+WEkI1bIol5hThy0jm0IMck/jAT1QPKWPQma92UnNZuRQ8dKK
         YNEaGeKcuWYqYFdnoYlivUoDjCot81ZtZcPB/oBOpcGwIbtVP31A94Xxfz0dG6UKqnTM
         aR7sIJsW86ox5MdE7H/t2Lmqzpmg1O4oBS1t1/1Ts4jpqwTGBgQU4VZRWo7CGL1AC4TL
         782w==
X-Gm-Message-State: AOAM532dv9MgCuODvfLqhVBz3f4CDwbdnwOEYvUTy47eSqAMSCUA10OB
        bTecohEYwyNs1BWkftz6llk=
X-Google-Smtp-Source: ABdhPJyHoKweRJ5zu+v4p1cIq4SLrkNpd6lpq/L4ePkg2QgQmYL9OAo+KD4DfHvS+HqH4DK46mH0xA==
X-Received: by 2002:a63:2b03:: with SMTP id r3mr9393877pgr.201.1642963191866;
        Sun, 23 Jan 2022 10:39:51 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id c26sm9566324pgb.53.2022.01.23.10.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:39:51 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 01/54] net/dsa: don't use bitmap_weight() in b53_arl_read()
Date:   Sun, 23 Jan 2022 10:38:32 -0800
Message-Id: <20220123183925.1052919-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't call bitmap_weight() if the following code can get by
without it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3867f3d4545f..9a10d80125d9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1620,12 +1620,8 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 		return 0;
 	}
 
-	if (bitmap_weight(free_bins, dev->num_arl_bins) == 0)
-		return -ENOSPC;
-
 	*idx = find_first_bit(free_bins, dev->num_arl_bins);
-
-	return -ENOENT;
+	return *idx >= dev->num_arl_bins ? -ENOSPC : -ENOENT;
 }
 
 static int b53_arl_op(struct b53_device *dev, int op, int port,
-- 
2.30.2

