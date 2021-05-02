Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBD9370F0D
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 22:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhEBUiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 16:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhEBUiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 16:38:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2B0C06174A;
        Sun,  2 May 2021 13:37:16 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id j6so2808965pfh.5;
        Sun, 02 May 2021 13:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=qBb626UAryAdgm1T2pey6uV0joO//C8f4zZWIykiFHk=;
        b=owdkxVfeqfxf1akWBJJcpdJ5mBargcPVnGKdSk1J8ENrkq91GmpunuNwnVSarOTXKj
         c7R/mgfxVCAgUdTyJatS+8gFiLvgCHcFtPvWjnd9TdFxF5xMTqTct5OHS8IKL5wmLQNl
         ivgHcVYLXChjlOxU5ILq99bkCJb4vXiaCAZPma74FNtf1EgYvlALkOgAjKVMZ9OBafgj
         sw6JeDcVfCL6gD81pMOHVzxbZeyHUyh9jwZCvuJHaOi5mW8LQIEqoBStwD0CcP/9BvqS
         SiE71OH3h2G8v3OwTMcBMfJOb5Sx1F+iYBB5QCrPdMYdQyNlbZdcwnr7R3VZ7UBTibkk
         ZS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qBb626UAryAdgm1T2pey6uV0joO//C8f4zZWIykiFHk=;
        b=KqzEYsfAeV9D61kc1vVFoi0tp+otCPxMnWLjQqsj81g4wuIVaT3tYbJhuM0U+OFdgR
         8bHCd4lCCtPz6WRep3bbCWVRF6mHrvZvw8eNOc/IsOw/zLXb9WchPLMdDfkjqckX2YBE
         TqxW2X9a2N26T7ZllZAZqnn8W8F4T9lpSb/IP6OXox9lIFJrVn4iH5yEQPjlcGpv5dvg
         amjnW4RGo2d69Cz0S8Z36y9gKJ6QXmPHdYzSd2XudQm2wlQ6GWoAnNACpF5Jh54KfG59
         mXE7eTG53ShP/hpkE9BGGGBZSUw9k0sjvY341w6LuV0VdgEr6ELBKTRACqJRWLR8iM17
         VJfQ==
X-Gm-Message-State: AOAM530uY40uUBBT2ym03U8I/II5IIjT/9W4wpm7ljZ2IL/9bw8eJLcj
        dth3ofkP8YfUuDhxnjGKjt4OdAP3vDJg8mf/
X-Google-Smtp-Source: ABdhPJxzP2kqfSe/20haLDQkoKfg3VFeQ6sqaSXFycr9fkki9uGnmwm+357T1yDDX4YoafHHLkdnXw==
X-Received: by 2002:a62:1b94:0:b029:28d:496d:10d0 with SMTP id b142-20020a621b940000b029028d496d10d0mr11840467pfb.28.1619987835334;
        Sun, 02 May 2021 13:37:15 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a1sm1242769pfi.22.2021.05.02.13.37.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 May 2021 13:37:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com
Subject: [PATCH net 1/2] Revert "Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK""
Date:   Mon,  3 May 2021 04:36:58 +0800
Message-Id: <8b4e11506ccf62e18944bc94a02ea86c4c4de26e.1619987699.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1619987699.git.lucien.xin@gmail.com>
References: <cover.1619987699.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619987699.git.lucien.xin@gmail.com>
References: <cover.1619987699.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 7e9269a5acec6d841d22e12770a0b02db4f5d8f2.

As Jere notice, commit 35b4f24415c8 ("sctp: do asoc update earlier
in sctp_sf_do_dupcook_a") only keeps the SHUTDOWN and COOKIE-ACK
with the same asoc, not transport. So we have to bring this patch
back.

Reported-by: Jere Leppänen <jere.leppanen@nokia.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index a428449..5fc3f3a 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1903,7 +1903,7 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 		 */
 		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
 		return sctp_sf_do_9_2_start_shutdown(net, ep, asoc,
-						     SCTP_ST_CHUNK(0), NULL,
+						     SCTP_ST_CHUNK(0), repl,
 						     commands);
 	} else {
 		sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
@@ -5549,7 +5549,7 @@ enum sctp_disposition sctp_sf_do_9_2_start_shutdown(
 	 * in the Cumulative TSN Ack field the last sequential TSN it
 	 * has received from the peer.
 	 */
-	reply = sctp_make_shutdown(asoc, NULL);
+	reply = sctp_make_shutdown(asoc, arg);
 	if (!reply)
 		goto nomem;
 
@@ -6147,7 +6147,7 @@ enum sctp_disposition sctp_sf_autoclose_timer_expire(
 	disposition = SCTP_DISPOSITION_CONSUME;
 	if (sctp_outq_is_empty(&asoc->outqueue)) {
 		disposition = sctp_sf_do_9_2_start_shutdown(net, ep, asoc, type,
-							    arg, commands);
+							    NULL, commands);
 	}
 
 	return disposition;
-- 
2.1.0

