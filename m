Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0665410E92
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhITDKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhITDKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:10:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67FDC061574;
        Sun, 19 Sep 2021 20:08:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so11114061pjb.1;
        Sun, 19 Sep 2021 20:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmMZOAHgTdh616hp06L3sF5WAAO2pLT5BUpQivYWsdg=;
        b=Nos1fs8WfPVA9K4ec57AGhj3TGrFCLXzxE17ag5vbX43KyJxhSUO+SwS3S0aErW+bG
         FyaNh16pPjKUFl1rwTenwJpqTi/+E5kpo86+oUWHTRhrldhSejRQNbwtOaWUPdMQicIp
         pgFWAu07E8hRGdq3vKzKLhWR2zvimM/mI8rsIErWdO6t9wFuxhWmBy6Hwo32kI6s6lO1
         HEuw/Wt6LoDXeXGRtUccc37riJlYPqIcDXFfXJjHsMXWfLBOq/KesyP+rr0Tg8Oh5pnf
         28kpFn1wDVnhiWeldCUAlrkK6qrrVzFoQ8iEbNW8a0GbXRV+jnDilfHBAUmcctvNM3rh
         d23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmMZOAHgTdh616hp06L3sF5WAAO2pLT5BUpQivYWsdg=;
        b=CGqe0lC9/mFXLpKHBIkvmZC45Rw66vcb0Pts8jMNLZRna+WBSWFyoJxFFM6WJaQsrN
         YTRitBq0nIWD0uoCb+m0ZYVUeLDdOFEC0wEkU//Fn7hQkCh4PmjdmdTd/9nLZ+8XSbYn
         uwXx9pF57SHZ4MhFh1WUNRx+omTDqaxF9Z/g29fGHEvgrWgGtTD0fAlZGcYyyVzSLycY
         m1x26VnPrxEjxbZpstsCLe9lO0i4+YN6f/V9yp93zHLamht2iexMZ7fo4cKvw1+7rIYx
         PHPeq5cdG0TmXyl0DNwSDJR8ltk/X3Pp1OD1dmMVlX16o4u2tke5iBiLSAnBIz9BABxd
         nKRw==
X-Gm-Message-State: AOAM530ISfbPg4Y1Jah9HLpL8aaaPFUO6N9ZZeqe4ioSAF8p7y8rEg5C
        m+Lr+kmHfP8KhhSDXpbdHM06jNiscynUX7Ot
X-Google-Smtp-Source: ABdhPJwWZzgDwh6RqSj8/TuWxlcFs/Rq5lYyCOnoRVrwKswqHtJV4OWrbmKUvidSkEeTdQ0dMzVHWA==
X-Received: by 2002:a17:90b:38cf:: with SMTP id nn15mr4677301pjb.81.1632107318285;
        Sun, 19 Sep 2021 20:08:38 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:08:38 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 01/17] net: ipa: Correct ipa_status_opcode enumeration
Date:   Mon, 20 Sep 2021 08:37:55 +0530
Message-Id: <20210920030811.57273-2-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Lypak <vladimir.lypak@gmail.com>

The values in the enumaration were defined as bitmasks (base 2 exponents of
actual opcodes). Meanwhile, it's used not as bitmask
ipa_endpoint_status_skip and ipa_status_formet_packet functions (compared
directly with opcode from status packet). This commit converts these values
to actual hardware constansts.

Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_endpoint.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 5528d97110d5..29227de6661f 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -41,10 +41,10 @@
 
 /** enum ipa_status_opcode - status element opcode hardware values */
 enum ipa_status_opcode {
-	IPA_STATUS_OPCODE_PACKET		= 0x01,
-	IPA_STATUS_OPCODE_DROPPED_PACKET	= 0x04,
-	IPA_STATUS_OPCODE_SUSPENDED_PACKET	= 0x08,
-	IPA_STATUS_OPCODE_PACKET_2ND_PASS	= 0x40,
+	IPA_STATUS_OPCODE_PACKET		= 0,
+	IPA_STATUS_OPCODE_DROPPED_PACKET	= 2,
+	IPA_STATUS_OPCODE_SUSPENDED_PACKET	= 3,
+	IPA_STATUS_OPCODE_PACKET_2ND_PASS	= 6,
 };
 
 /** enum ipa_status_exception - status element exception type */
-- 
2.33.0

