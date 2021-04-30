Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4ABA3701BC
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 22:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhD3UFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 16:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbhD3UEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 16:04:14 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14984C06174A;
        Fri, 30 Apr 2021 13:03:26 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m11so6057639pfc.11;
        Fri, 30 Apr 2021 13:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ranfrW4Ke5FCKLRLAOIZRlwFGXqBmDaAIWDLfXK3aC0=;
        b=hrg1RADg0C8nbuj9x2k/f3mCUKzQIx5T5lVzDvYiNdCMeuyY1KH7rbxOoVNwNetE4a
         OQVU2vUp51CUcvdGx21VoeStwQU0jeaadGD6tQoqh22HXr8R8yGbFeV+ldOpc/WZAuU2
         5UO6p9+LnEug0MIPNIshi9xGy1KOHQHC/IHMRE5qW0P4oaOgAuiI/BHE9XunwF7ygp6z
         7INkfE0pr09IY2FOIIWSrH9e97NbooBzEXO1I/XrgLzu1lj2GCuPoqYStNbLB/Fe546A
         gDBVL+sBYK3WJwtFXh/IzBfXG6d2p758vZ1smip4QAGCE2BGdPnwJTUjzSCcYAGmIP8H
         2SfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ranfrW4Ke5FCKLRLAOIZRlwFGXqBmDaAIWDLfXK3aC0=;
        b=eLfzwSuewk6mF3todhjLq8O7SI/OwpsTwHyNZbZuJUmk+3EMtMIRmhKTioN/sUQL1r
         BC0Yn9og+rg/8ehZ0PFnqaRyDVGMqu6SYt1PPut1IJxgkvD6F5KccLnvR7AVEWWsLVeQ
         EoxV+u5kSz+zidg68jMUAi011z2x4jUzOx6j7yXe6Uy30gnoax/nn6MK5AVsav7VCf54
         WN1llverx+hd+qJEx1lksnr9ELWXaWPlNCQUNzu+GCS/yZ3TdAlDguNCbwUnj1B5XEC1
         mzAdiiFG0itYj1gBxB5JBid3PzIwBlVAFXNzcOgN9/VJS4kigTT1IuaEWYMy0i+qgZCB
         LrAA==
X-Gm-Message-State: AOAM533h9wFDjFx0ZSTVgDtrP2juKHKYtpFdfyZ47GV6CXLvD8ZOG2h0
        G2WqEZqnjNfGG7EpnwEejaVDQj/zU9mOMb25
X-Google-Smtp-Source: ABdhPJxXPwNJeO3ABihUSK3qgiuGbk7ZVglqEffWNn75B8eGSfHRlg3cDq4FYeqfJZkH86SDtBHq/w==
X-Received: by 2002:a62:29c2:0:b029:28c:d5f5:5ba3 with SMTP id p185-20020a6229c20000b029028cd5f55ba3mr4150917pfp.14.1619813005400;
        Fri, 30 Apr 2021 13:03:25 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n18sm2587890pgj.71.2021.04.30.13.03.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 13:03:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCHv2 net 2/3] Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"
Date:   Sat,  1 May 2021 04:02:59 +0800
Message-Id: <a9f65034deb5ffa57ea704f99102fcefb9bff539.1619812899.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1a42d5e9ae45c01dbf0378fca0cb8cfd85ee454b.1619812899.git.lucien.xin@gmail.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>
 <1a42d5e9ae45c01dbf0378fca0cb8cfd85ee454b.1619812899.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619812899.git.lucien.xin@gmail.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be reverted as shutdown and cookie_ack chunk are using the
same asoc since the last patch.

This reverts commit 145cb2f7177d94bc54563ed26027e952ee0ae03c.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

