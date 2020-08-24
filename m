Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE180250B68
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgHXWIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXWIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:08:20 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A7DC061574;
        Mon, 24 Aug 2020 15:08:19 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id o22so7534451qtt.13;
        Mon, 24 Aug 2020 15:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBxRutKoRvBsYMY7DjEDLutlgfOhzLlM9Y1VeLJ+A7s=;
        b=T/2Bfrf1wY8nhFiNcBiCCQhHmW5zBx7JXmfuWVBbQB+x1k7mRvciNL7nUBN7oFE8LJ
         oEzm5C8MEsIWBoZob/1OcU3xpIar/nzvkhjBV76G4FfLUyxyDx5aOfuWsfhLlXyOjTFy
         cwdHFDxZsPGRF2um51QavWrE9tpB9dd6qMZs72+xi0KEHHLe0ivLOQ4bCM55rreYFIMX
         2+/cfSxNhUmdZfAprWggg8dBWbwQyy6fdmbmcbVcVrVF4hP6G7MgYOIxVP85hQc3PJxD
         Or465Fn93dC8QrfshSd0ivrVPnxMiiEMS1dH/fWwqMUFBXGx8bA1rBTX+HPAFuQfc4xT
         iONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBxRutKoRvBsYMY7DjEDLutlgfOhzLlM9Y1VeLJ+A7s=;
        b=TO2OivIUQrVMdakkgtZrKlJbhGfex1+O9ReyvKfeRTRztZVqGI0l5oO7W7yQrcxU6f
         QDn0/hIpnYecbSzhho4YWV+eT5mt6NEGJb6VCkg4X3c5DpsI40UkkCc8l/O/nGieDp/g
         WyMRRfpr/rHyvRQ7l7GDkmuqNIJYDNEBTpBTsgCv9gMu2L9Jw2CRDUP6EgBO0AY6zbor
         9WYjyKTXMFNy2S19ReQHcJVIM61PKNQ8AmkRQQJUtbo/gjBZXMTPh7BeS/e1d3cMXESJ
         8nphqGCRcaWv05oQ9S2sxK43Tmwbi1tvuLyFZlzN3ELXs4HCjyzOqC+EjkTCDeFdx5+V
         k4Bw==
X-Gm-Message-State: AOAM532QvmuIyCgawdkI/N/1N1uYj8czK5WZETBQpV40ZoK3vkQBNbSM
        cHxReIUmsTrkGq/GkQ9kDng=
X-Google-Smtp-Source: ABdhPJzKshlK6jcVf/9HMVRKL2q2AuOpfROK7MkWUZaFhH9sfkW0M9H1pE69KAD4NDzRvQPAc/a1Rw==
X-Received: by 2002:aed:364a:: with SMTP id e68mr6690391qtb.260.1598306898013;
        Mon, 24 Aug 2020 15:08:18 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c100:b9d:e9aa:e42d:21e4:5150])
        by smtp.googlemail.com with ESMTPSA id x31sm8241177qtx.97.2020.08.24.15.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 15:08:17 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, ztong0001@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: caif: fix error code handling
Date:   Mon, 24 Aug 2020 18:08:06 -0400
Message-Id: <20200824220806.1257123-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cfpkt_peek_head return 0 and 1, caller is checking error using <0

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 net/caif/cfrfml.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/caif/cfrfml.c b/net/caif/cfrfml.c
index ce2767e9cec6..7b0af33bdb97 100644
--- a/net/caif/cfrfml.c
+++ b/net/caif/cfrfml.c
@@ -116,7 +116,7 @@ static int cfrfml_receive(struct cflayer *layr, struct cfpkt *pkt)
 	if (segmented) {
 		if (rfml->incomplete_frm == NULL) {
 			/* Initial Segment */
-			if (cfpkt_peek_head(pkt, rfml->seghead, 6) < 0)
+			if (cfpkt_peek_head(pkt, rfml->seghead, 6) != 0)
 				goto out;
 
 			rfml->pdu_size = get_unaligned_le16(rfml->seghead+4);
@@ -233,7 +233,7 @@ static int cfrfml_transmit(struct cflayer *layr, struct cfpkt *pkt)
 	if (cfpkt_getlen(pkt) > rfml->fragment_size + RFM_HEAD_SIZE)
 		err = cfpkt_peek_head(pkt, head, 6);
 
-	if (err < 0)
+	if (err != 0)
 		goto out;
 
 	while (cfpkt_getlen(frontpkt) > rfml->fragment_size + RFM_HEAD_SIZE) {
-- 
2.25.1

