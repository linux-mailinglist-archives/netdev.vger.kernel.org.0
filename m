Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEEF51F1DE
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 23:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiEHVs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 17:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbiEHVsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 17:48:54 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56506445;
        Sun,  8 May 2022 14:45:02 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 1-20020a05600c248100b00393fbf11a05so9763420wms.3;
        Sun, 08 May 2022 14:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sz9yDMbWolCR5CSm2J/3vC7zIKazVJISgiLAk/Sxmjk=;
        b=odEgRES1w3ohIoQJFJMZIgwiqx0w9ikZ5ahO6mKSOCp5MV2nmKdXmMa7ejQCzBEk4V
         6R1CSUB6tZptfCRhrKnB1vNWbOLi64YT2Hi+c0HL9+oYjINMASi5tDhYdw1fCJODPbC0
         10rOjcK0UOKfoJ9Xc2hOCRXvC4k93g2wuIfbmyvn8OAYISHIKxVyzlFQ6Z5BC1EeRkS8
         TNbylN5WqYiOAPbiz7hubby5HgaJazQtdpHYw8dsoEzhyXIqBJQyR2QLMLXiSuU4ogmj
         mHCIC/h9Ee/4LheQ8KaApm5E5dDQkinwP02y2XvlLjowe5BZWJZSU3awpGaNzlP1y1Or
         98Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sz9yDMbWolCR5CSm2J/3vC7zIKazVJISgiLAk/Sxmjk=;
        b=3Kwd00JdbKJTfx+8mGkVFSgKQt3KkMQTdvSPXVj8Oot83KtMKlt5MxEzRF5uxLpH89
         uM1KoSopDNokwGuWVr8cW0kwUI/eO/ROSIyzOR9w9qVHI1NyQ9sXxYD3B0WLnxyFYZur
         ggKk/TRO+tqfpgpqWR5lbN8O1hNSw/1UyoyT2r1DJBwlaFG0oNnoKpfHQt0AhYwRDruA
         l08bhi/z3V41cdICvSlM9isFjgyeKRRNODYEHSxGLaAF8bmH6rwPB/Q00HAXZaWtyV0m
         dgS/DpANONSNDHD9EM0i5eiFVMmfFrh2/NUqm3/6s5BKw2fc2FdKJZ0O3zJl1ZCyQ1cb
         moKA==
X-Gm-Message-State: AOAM533zBDHKzO1RDGSHKNcr2BkQgCZTBSvL6CjrikhbPo1PHu/WY+yk
        7dh0TnAER4NjiyXAUTzYI10=
X-Google-Smtp-Source: ABdhPJzsQei1PUBRbz+zo5dt6pV/R1IwS6bibqDjpiffCWMdTH92R5BM6ZHxo9cYWaGnJYzDCUJvbw==
X-Received: by 2002:a05:600c:4187:b0:394:4cf8:7c61 with SMTP id p7-20020a05600c418700b003944cf87c61mr13164229wmh.119.1652046301468;
        Sun, 08 May 2022 14:45:01 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l17-20020adff491000000b0020c6a524fe0sm9283123wro.98.2022.05.08.14.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 14:45:01 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x25: remove redundant pointer dev
Date:   Sun,  8 May 2022 22:45:00 +0100
Message-Id: <20220508214500.60446-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointer dev is being assigned a value that is never used, the assignment
and the variable are redundant and can be removed. Also replace null check
with the preferred !ptr idiom.

Cleans up clang scan warning:
net/x25/x25_proc.c:94:26: warning: Although the value stored to 'dev' is
used in the enclosing expression, the value is never actually read
from 'dev' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/x25/x25_proc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/x25/x25_proc.c b/net/x25/x25_proc.c
index 3bddcbdf2e40..91a2aade3960 100644
--- a/net/x25/x25_proc.c
+++ b/net/x25/x25_proc.c
@@ -79,7 +79,6 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 {
 	struct sock *s;
 	struct x25_sock *x25;
-	struct net_device *dev;
 	const char *devname;
 
 	if (v == SEQ_START_TOKEN) {
@@ -91,7 +90,7 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 	s = sk_entry(v);
 	x25 = x25_sk(s);
 
-	if (!x25->neighbour || (dev = x25->neighbour->dev) == NULL)
+	if (!x25->neighbour || !x25->neighbour->dev)
 		devname = "???";
 	else
 		devname = x25->neighbour->dev->name;
-- 
2.35.1

