Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB65A3B7C14
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 05:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhF3DdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 23:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbhF3DdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 23:33:08 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255D9C061760;
        Tue, 29 Jun 2021 20:30:39 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id y29so1039044qky.12;
        Tue, 29 Jun 2021 20:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JdrxMzAaJMrFuyeOjHR3/dbJ4P/gMbhkkMnKf8Ns2pU=;
        b=T5SXEndFkObdTfR1Ajo/Prc5yX9dP+tjBpNxXqApIDCJ5JT/L+1tX2J1B8GxsI8Rgn
         XXvUuPpC/7OOZ3O4KNgZG3DFENRQI/YlEzelysBszgq/vRGWTSvaLFy/a75/MQ06o5P+
         fdYRRX6amNKidgjrebyDLp2v7T0mMMTYPeTBES2+syU2yTK9j+nrbAq4maY4sPFZx9XI
         yU/hZy6AbA7i7guPzDGq6CQboxk4OpsYwsXP4V1WgauD9BOENxEMsoclxZaPJjACjL3/
         fABe6jSd56wf4A4gbWgCrM66Ja7Y4AGHOALycemjZ8KSf/wPJnUqwkAKFkjSgnUecA4c
         oqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JdrxMzAaJMrFuyeOjHR3/dbJ4P/gMbhkkMnKf8Ns2pU=;
        b=K6EdgdfNDcvG0oEDqtFMk2LzV1qx1aFbMh33QH0limWBkid3YELc9UtqiBcL5Rbkph
         oU9DX7zYSoJkvTzwKCDB989wEP98zNdKfX9fhqjmfbXIR9OBaLtgb9xVAB+cFYAxteM7
         KUOB3Sik14t8qLVjurr9/wk0DaL5abofqfy8U9EsvAkNkhMvrLxj3DZiGUlqTWjRfM2S
         lRdkMHYhpFxdiqCYGJnTP/uUCGfHrgW9UFKzzby0gqeLbd4bTCn9CSwZ1s5fQ+Ptz9Yd
         XAPXpDAa6YbultIXTO1vqeosas8jVXjIHevGiljTGGTHxOyVKK1KwRtBWXWBLBYnKobb
         7FgA==
X-Gm-Message-State: AOAM533cyv6/fAdECKEVTCRSqRFOMOHFEY7oGngaupc9Oz4h8yoAM8UY
        DxMalO3GBnPhH+WmXuREcuA2VnHpDEg=
X-Google-Smtp-Source: ABdhPJxrj2WJ1ZcOGcPZviJamJyPeQy0yuSyQn9aSADtVDrvkjB3/qX/PlDoWWo7oD0Gu6avW5uh1Q==
X-Received: by 2002:a37:9c57:: with SMTP id f84mr18506585qke.129.1625023838139;
        Tue, 29 Jun 2021 20:30:38 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id q6sm612416qtr.61.2021.06.29.20.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 20:30:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next] sctp: check pl.raise_count separately from its increment
Date:   Tue, 29 Jun 2021 23:30:36 -0400
Message-Id: <727028cb5f9354809a397cf83d72e71b4c97ab85.1625023836.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Marcelo's suggestion this will make code more clear to read.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/transport.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 5f23804f21c7..397a6244dd97 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -335,10 +335,13 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
 			sctp_assoc_sync_pmtu(t->asoc);
 		}
-	} else if (t->pl.state == SCTP_PL_COMPLETE && ++t->pl.raise_count == 30) {
-		/* Raise probe_size again after 30 * interval in Search Complete */
-		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
-		t->pl.probe_size += SCTP_PL_MIN_STEP;
+	} else if (t->pl.state == SCTP_PL_COMPLETE) {
+		t->pl.raise_count++;
+		if (t->pl.raise_count == 30) {
+			/* Raise probe_size again after 30 * interval in Search Complete */
+			t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
+			t->pl.probe_size += SCTP_PL_MIN_STEP;
+		}
 	}
 }
 
-- 
2.27.0

