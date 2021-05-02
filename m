Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCB5370F0F
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 22:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhEBUiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 16:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhEBUiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 16:38:16 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE87C06138C;
        Sun,  2 May 2021 13:37:24 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q2so2766191pfh.13;
        Sun, 02 May 2021 13:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=mR9e4NkKqzrDkV1l6zV2ulkWewV/V4ENDDwbld/8TKY=;
        b=K8HshOlG18N3SMVofWgPCloxSQyPHL/44AtEfmXz7vNLZSb50FrYpPa2q1A38T2Br+
         spg1KzYIo3RoOnZICS7g0mhUSKmnH853bGGAPuTp7vIBzBNl6MJTcZj9POca3gJSkbWh
         X+k1wjhyZp/XAbNow/4NFFPNNZQGHFigZQtGrjjYn/ymw6WnMtLZscbVWbbQ9mWIY1cE
         egEMiIOkvgu6sNL/PmaG6EKkQkq9S6H1jUrrHzKVb+qTBP7pP60ywZki6hy+T6vCEMxI
         xFy4zBJy7YyPCncLNhhW0ul7Htj7adN+7qoqDYVkB6LVx10wlM5igE/n/GXUuzjMHXqZ
         5aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mR9e4NkKqzrDkV1l6zV2ulkWewV/V4ENDDwbld/8TKY=;
        b=i6F0ZUAIXIN9Ej/AMX0i8Opu4pmFuzuShrW0OkW6VOWbc6q7x3eQ3A9vrjeo1kf7t+
         gUCBfLdRiNpNIOA25cXc8dz4/NJQ5YRHhwcPJjF4+v2I219XQKfrQVXX77E0hIivHqBa
         IrJ1hr6y+e8lpbUG+SWq1CVw6EK/hoBh9ouKLbDd++cZSI2J7tj8I565T+lyOKIH+XsQ
         u7zPOlRdFWc3TWicSBYis1fDsL2ul89T2dgH6NgBBPFIU2L42KjBq+kri5BDpyKJMGgR
         YX0bkiL6tLmvXFceavVEUAyfTCJZkK0w95cqSWZVoPV0penaz1i6xfDhIUnvzGuQjbpf
         YCKA==
X-Gm-Message-State: AOAM533UfOF98EZP3Hl77ru1RGKL4GS1gwYKcHKCRU2LDYWIXi9S1JCp
        5aEVAY+sHMMya3Sk1L/4ZRzn/8dY8dXmfsDO
X-Google-Smtp-Source: ABdhPJymtN5VBEeezmnt9cZX4ei/cmISN9t7628dQPjOpNbXjV/qN+TTAJd6zjmQwjKQXrkntILlhA==
X-Received: by 2002:a63:9e02:: with SMTP id s2mr15717002pgd.134.1619987843404;
        Sun, 02 May 2021 13:37:23 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a128sm7231175pfd.115.2021.05.02.13.37.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 May 2021 13:37:23 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com
Subject: [PATCH net 2/2] Revert "sctp: Fix SHUTDOWN CTSN Ack in the peer restart case"
Date:   Mon,  3 May 2021 04:36:59 +0800
Message-Id: <a6638459ead12f3c0683b20b5e6502f71c387f22.1619987699.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <8b4e11506ccf62e18944bc94a02ea86c4c4de26e.1619987699.git.lucien.xin@gmail.com>
References: <cover.1619987699.git.lucien.xin@gmail.com>
 <8b4e11506ccf62e18944bc94a02ea86c4c4de26e.1619987699.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619987699.git.lucien.xin@gmail.com>
References: <cover.1619987699.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 12dfd78e3a74825e6f0bc8df7ef9f938fbc6bfe3.

This can be reverted as shutdown and cookie_ack chunk are using the
same asoc since commit 35b4f24415c8 ("sctp: do asoc update earlier
in sctp_sf_do_dupcook_a").

Reported-by: Jere Leppänen <jere.leppanen@nokia.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_make_chunk.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 5f9a7c0..5b44d22 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -858,11 +858,7 @@ struct sctp_chunk *sctp_make_shutdown(const struct sctp_association *asoc,
 	struct sctp_chunk *retval;
 	__u32 ctsn;
 
-	if (chunk && chunk->asoc)
-		ctsn = sctp_tsnmap_get_ctsn(&chunk->asoc->peer.tsn_map);
-	else
-		ctsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map);
-
+	ctsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map);
 	shut.cum_tsn_ack = htonl(ctsn);
 
 	retval = sctp_make_control(asoc, SCTP_CID_SHUTDOWN, 0,
-- 
2.1.0

