Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30C661A389
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiKDVpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiKDVpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:45:21 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7463D9E;
        Fri,  4 Nov 2022 14:45:20 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id i9so3890772qki.10;
        Fri, 04 Nov 2022 14:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zbm9owRHu51lz1cJK/ODbAleVH2tKT1dicpuoLYsxJU=;
        b=Ke69EquF66rZwkT01/j9Vl/Hh0EcSu5Y3CwbpGGZz/wuBhODwa+//uAOOzksEVzE6M
         qHr1cauXtr+dK9tG8EdOk8QNHjibDyVPVrIEVTaTNE0nT34lImBGovJy1/Ix5fOucO4+
         /Yi/NHIwnDYrbcbx3z+n2nGICmBDCihhPjkXcKnuYqF0hiYR4PJMoNQLCPDrTJBS0wUq
         ADXhtnch9WTWqlFElAg9Mnb7MrP45GyEw+G0wBAVrK7RRQoQ1s2mZvORrZ1ojxa6zJfV
         D54KdsBPzFYQ+0MT4qKUnPWM/u90Hae3D6JTg7ShiBVx0ZS1Etk44I9C/JyIjdBuFoV5
         R/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zbm9owRHu51lz1cJK/ODbAleVH2tKT1dicpuoLYsxJU=;
        b=wqNcOgjH64dNeBJB3xQxSh6ZAkAvf9zqGqxyujDU0vxbpUWtkcgCrqWsPcwr1cFwH0
         lr14iHfWG0tE8tNK9A3huZXJgNUVJBEI/G4hAlHgb4cA0UyXRm3wiTLCrAaVNo7Qp0DY
         KgqVdWNUxC5kaxHflA26HlhoVx8aKwXz837ptvUC4xbzwYQy+cxiqUL08ak1OmdopW1i
         GJkHS8nc3annnIRoZGG+dY9l8lEDkNBt2dulk2VGyBy8pL3iaaLmoHt9rM8fMkWGq4ym
         6S/O6xH1rnsBcIWeoqbRzcSsmMae4zeam2mNKqnwfhUs/q3436CqLuxV+pB4gWtRG8V9
         WfHg==
X-Gm-Message-State: ACrzQf1egnL9k0U39ipBQiaYROg58cydH07GYCQp5rxP1XuJlDcf8ojq
        BG9q2E3lgAnv5xJldnTf+IRJYO0/2tiZEQ==
X-Google-Smtp-Source: AMsMyM6DwMzalzNf5bAV/VX7enmhm3PovNKacERorvcwGYLh0FKZ6JRS4MCgIRkmODvUsrjHuMcODA==
X-Received: by 2002:a05:620a:24ca:b0:6ee:d4e0:de38 with SMTP id m10-20020a05620a24ca00b006eed4e0de38mr27644203qkn.313.1667598319546;
        Fri, 04 Nov 2022 14:45:19 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k1-20020ac81401000000b003434d3b5938sm366185qtj.2.2022.11.04.14.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 14:45:19 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, chenzhen126@huawei.com,
        caowangbao@huawei.com
Subject: [PATCH net 1/2] sctp: remove the unnecessary sinfo_stream check in sctp_prsctp_prune_unsent
Date:   Fri,  4 Nov 2022 17:45:15 -0400
Message-Id: <b8547c3c8dc84caef4bd891b89deec226926207b.1667598261.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667598261.git.lucien.xin@gmail.com>
References: <cover.1667598261.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 5bbbbe32a431 ("sctp: introduce stream scheduler foundations"),
sctp_stream_outq_migrate() has been called in sctp_stream_init/update to
removes those chunks to streams higher than the new max. There is no longer
need to do such check in sctp_prsctp_prune_unsent().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/outqueue.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e213aaf45d67..c99fe3dc19bc 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -384,6 +384,7 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 {
 	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_chunk *chk, *temp;
+	struct sctp_stream_out *sout;
 
 	q->sched->unsched_all(&asoc->stream);
 
@@ -398,12 +399,9 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sctp_sched_dequeue_common(q, chk);
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		if (chk->sinfo.sinfo_stream < asoc->stream.outcnt) {
-			struct sctp_stream_out *streamout =
-				SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 
-			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		}
+		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
+		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
-- 
2.31.1

