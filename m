Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2541537004F
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhD3SRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhD3SRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:17:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F71C06174A;
        Fri, 30 Apr 2021 11:16:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so2169883pjj.3;
        Fri, 30 Apr 2021 11:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=5OCiEPAatbReSkjE5wR2GbKMnJQ5Bx8+pcuCTlZOL34=;
        b=hYEWcZ44oVLECfYLXZme7umwyVdwHZ8msZ0a9wdq76ryGLX6/YNiXPXC/5weEsbfEt
         nBun0mVLLtSLddxgyBRnIQUaylyrwKjv/WHFo5S6N0YPbpljWUYM8fv7dNX02ZyuQwkE
         l62SkkapT5P/djcqxDLy7o/8Ov2S4sTGjjWKtL67MRUiLKQXP3XJK8cMmdZnHjv2FS/D
         WRTb2xGBFhY38zisHAwhDwi0unrwfp3TpMIJvkDFRWjWnV0NhoyspZyJLHj0HnzBglB0
         G0GuV40unNDHgwyBDkPVEFyyRDFY3PS1lknKbLz1otw5ZDAwcuGc9/rdoU0PZ8d3qY7M
         o83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=5OCiEPAatbReSkjE5wR2GbKMnJQ5Bx8+pcuCTlZOL34=;
        b=k2iLmnQoMAP9v7MpLPjJjADB+0kNebyLbtyEDnNnZe0z4EAKfZkyvjpQhEVZncN6KY
         kJ2bQ83AjGMoF6dXySq3MZXZvMsuuC8VMeVu5aBzDSPYTWjnc3BgfVfLqCTLFM7Tk2nd
         XF0pkdhR3nBD/J6jnDmdaDmjZZvkO6J55rbn4Iu2p6tLqDI3x6syQWIowovchZoXPHlI
         a0mN/SsZFUZSgySloZ4/CHUH49U5yRoL+CyXZ9qVDo9dxuGZKqm+0DoSYmQM69aKxPON
         eNyljrJy3HxaiTKGDRmP+9oXTnVN0RyCJgZmCB6imiwiv54h3x4V6CgqlSbdtVjdU1jd
         hADg==
X-Gm-Message-State: AOAM5327K4WWPkNUtLCEtCI85zheJ694IC7ByMhnBTa5w8Ty+EgjHC6H
        cHjYESK2YRNS+FWKUHdX64RfBKR+YwWm1ggb
X-Google-Smtp-Source: ABdhPJzrgQJBTY5jrFxZWZFt1d7oPnApHTBKQlBInCAb1kUoPRIgpaN2rh6dXDdEZSpkKo1yH7cTBQ==
X-Received: by 2002:a17:90a:4313:: with SMTP id q19mr16464533pjg.158.1619806582560;
        Fri, 30 Apr 2021 11:16:22 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d17sm2709871pfn.60.2021.04.30.11.16.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 11:16:22 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCH net 2/3] Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"
Date:   Sat,  1 May 2021 02:15:56 +0800
Message-Id: <8a5afb3b24785e8837332dbec388ddf4f40c2297.1619806333.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ab7a35c9888202a34079baaa835294422bc3b5b3.1619806333.git.lucien.xin@gmail.com>
References: <cover.1619806333.git.lucien.xin@gmail.com>
 <ab7a35c9888202a34079baaa835294422bc3b5b3.1619806333.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619806333.git.lucien.xin@gmail.com>
References: <cover.1619806333.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be reverted as shutdown and cookie_ack chunk are using the
same asoc since the last patch.

This reverts commit 145cb2f7177d94bc54563ed26027e952ee0ae03c.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 30cb946..e8ccc4e 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1892,7 +1892,7 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 		 */
 		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
 		return sctp_sf_do_9_2_start_shutdown(net, ep, asoc,
-						     SCTP_ST_CHUNK(0), repl,
+						     SCTP_ST_CHUNK(0), NULL,
 						     commands);
 	} else {
 		sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
@@ -5536,7 +5536,7 @@ enum sctp_disposition sctp_sf_do_9_2_start_shutdown(
 	 * in the Cumulative TSN Ack field the last sequential TSN it
 	 * has received from the peer.
 	 */
-	reply = sctp_make_shutdown(asoc, arg);
+	reply = sctp_make_shutdown(asoc, NULL);
 	if (!reply)
 		goto nomem;
 
@@ -6134,7 +6134,7 @@ enum sctp_disposition sctp_sf_autoclose_timer_expire(
 	disposition = SCTP_DISPOSITION_CONSUME;
 	if (sctp_outq_is_empty(&asoc->outqueue)) {
 		disposition = sctp_sf_do_9_2_start_shutdown(net, ep, asoc, type,
-							    NULL, commands);
+							    arg, commands);
 	}
 
 	return disposition;
-- 
2.1.0

