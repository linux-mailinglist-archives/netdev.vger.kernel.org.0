Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8EA85750
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 02:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbfHHAxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 20:53:15 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40257 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730382AbfHHAxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 20:53:15 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so43063539pgj.7
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 17:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RYvASjp7Wn9RMY59p408gW18WYgaC6cZBG6rwBoYt8c=;
        b=EQ1V5532pWSC01xRIbBals7TfyG8s0+WGku7qiJ5OJ8JmmQN7e+VFUFiIRP4vj2NWq
         SJtgkNzW3gStYja/vtBrUY+SBwOsXWnZsCNGWiGNjGtg6Yji/EkgQ3mDYSdjFuJm3BC/
         YKOCb/nDnL1cpXWi/bMZHltHFiEn8YRLmKfnY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RYvASjp7Wn9RMY59p408gW18WYgaC6cZBG6rwBoYt8c=;
        b=D+fXE29NCoWfvZIoWWpaQTu2QR77O4cifgA8IMazZgU2ugTXqN52H3CQfOwnQa8ncl
         A3gbvIOUi5KmOQnH9C9Wiv6av4dToGxs3/V9vu6myJk1DO81zS2thr8muj+oA2K1RCCH
         wA1DNzPk2rXKFpZBktX5Fwq7fCsL648sNPQOV9VaHFLClGEZfaT6e9orZknZHxJF1h4F
         KU4f0Z3qutfhxlZVBZFRXycgu5Q9mttVwZeZEYmiapsQre62Uh1uT6i6RTUXUhs0AGKB
         mRVydR6f9Etk9j2YltUYssqdID7vhQusU2QShR3yVgbyeiwFcR1Wa8vDyIELkYrz9ZuN
         nkfQ==
X-Gm-Message-State: APjAAAUGb6OBl4gW+P/KI9VAt87H/rGScZZ1xwynnDRRyAPDe7q7iRm6
        juECAvj7BNkEm07e5HRJPlr7/g==
X-Google-Smtp-Source: APXvYqyMfzV1h6/SCyekjmDcrbuLcZLPLV1nHCP/caQMz+jJuG+42aGNUBeRBEeIFp/PVkM4tniLEw==
X-Received: by 2002:aa7:93bb:: with SMTP id x27mr12721421pff.10.1565225595039;
        Wed, 07 Aug 2019 17:53:15 -0700 (PDT)
Received: from egranata0.mtv.corp.google.com ([2620:15c:202:0:20e7:7eb9:f5ee:bbbc])
        by smtp.gmail.com with ESMTPSA id 64sm94456617pfe.128.2019.08.07.17.53.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 17:53:14 -0700 (PDT)
From:   egranata@chromium.org
To:     linux-kernel@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        trivial@kernel.org, egranata@google.com
Subject: [PATCH] vhost: do not reference a file that does not exist
Date:   Wed,  7 Aug 2019 17:52:55 -0700
Message-Id: <20190808005255.106299-1-egranata@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Granata <egranata@google.com>

lguest was removed from the mainline kernel in late 2017.

Signed-off-by: Enrico Granata <egranata@google.com>
---
 drivers/vhost/vhost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 0536f8526359..2c376cb66971 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -4,8 +4,8 @@
  *
  * Author: Michael S. Tsirkin <mst@redhat.com>
  *
- * Inspiration, some code, and most witty comments come from
- * Documentation/virtual/lguest/lguest.c, by Rusty Russell
+ * Inspiration, some code, and most witty comments come from lguest.c
+ * by Rusty Russell
  *
  * Generic code for virtio server in host kernel.
  */
-- 
2.22.0.770.g0f2c4a37fd-goog

