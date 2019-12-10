Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDF51186C8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfLJLos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:44:48 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43490 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbfLJLoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:44:46 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so19498747ljm.10;
        Tue, 10 Dec 2019 03:44:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P3dSQCHRI36SjPWYo0brD43NEdcMsLd/xYS8Df+31B4=;
        b=WlI/+IAY2YpfyFWJfmsfGOhePWAYppvUGULiDGAnStzwa455XbZ2t6gJMLPcCbaPwG
         m4Bnm4rlGeRS9Xb2EQFGp87dMQ4/KpWY+LWg0piNiBaqd5eMVLSzfpiiUPA7TeLQWT8b
         LLZNjoDtz1bS/weBFHu62kuaj22U4KERbVb2q7fuQ1n5XC6BTr5/gnZAy1UE1+P2WdaT
         3FeTK7HAV8yh4sC+iJsh5MHv+eBWGgRg1tg0D7Pq5tm6NK+lj4MC1XKPROZyBNO9Hqoh
         l8zeuUmPpvvXpmtsG6PIX8ss+Ig1dxS5lmLTdb7V0666bZGPtdWKH8FuQ/o45b9wNBEc
         Jr5w==
X-Gm-Message-State: APjAAAWFl2e9vXxKpWUITq0+9EU/eSt+WPVrOP/TtIShUxij5h+aMYGt
        lWU5fSghRi65lASh6b/r8po=
X-Google-Smtp-Source: APXvYqxLiCnWQg2+yXPqCdb9teaUE2XcyjKhLXsnKd7FWH2vE9SYKCnmXjufUvjYd9E8cLy+G53n5g==
X-Received: by 2002:a2e:585e:: with SMTP id x30mr20943600ljd.141.1575978283741;
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id n14sm1419005lfe.5.2019.12.10.03.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:42 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001Hs-Eq; Tue, 10 Dec 2019 12:44:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 2/7] at76c50x-usb: fix endpoint debug message
Date:   Tue, 10 Dec 2019 12:44:21 +0100
Message-Id: <20191210114426.4713-3-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210114426.4713-1-johan@kernel.org>
References: <20191210114426.4713-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure to use the current alternate setting, which may not be the
same as the first alternate setting, also when printing the number of
endpoints at probe.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index db2c3b8d491e..3b2680772f03 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2236,7 +2236,7 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 	at76_dbg(DBG_PROC_ENTRY, "%s: ENTER", __func__);
 
 	at76_dbg(DBG_URB, "%s: NumEndpoints %d ", __func__,
-		 interface->altsetting[0].desc.bNumEndpoints);
+		 interface->cur_altsetting->desc.bNumEndpoints);
 
 	ep_in = NULL;
 	ep_out = NULL;
-- 
2.24.0

