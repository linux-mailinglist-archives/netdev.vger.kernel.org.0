Return-Path: <netdev+bounces-3755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CDE7088ED
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 22:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7816A281AA5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0F8134C2;
	Thu, 18 May 2023 20:03:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBC03D38D
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 20:03:12 +0000 (UTC)
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F243EE4F;
	Thu, 18 May 2023 13:03:03 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-75764d20db3so223779685a.2;
        Thu, 18 May 2023 13:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684440183; x=1687032183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oCb49CNTaq+G5SD/ZC05T5pcG6RWc/US8QVKoq5lEYE=;
        b=E+q0ARappbP1jof+hcbhGjmXsGYlu2+Ph++HRHF7p3yAjXlmYegSxf31lO5sUDkHMl
         cxHHRcRBwxe+clpsbaVpkwo16ppv3KmspTYQXoIoViDKiMl+GPd6J6fK15wDzdaQxeo5
         jvww04haT3D1WSMnJJBx70mIOcBNWsJ8Vsz5THpYiCUob7iBmw/6FyUGAJLm8YT4Apxg
         k43vE6EWd1rrxrvxOjWVxC84lR6DvLdwyGohqbAp7y0eNfoL+CqiLqdB7D5UcL/qlErg
         5jw9CtI1lTTUIQyZXbIhAt2exAVqbu+0EvOowGqfDjqg/CpvkAhFHHoPeOnZFijFSeOg
         3lKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684440183; x=1687032183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oCb49CNTaq+G5SD/ZC05T5pcG6RWc/US8QVKoq5lEYE=;
        b=Opf9zWAKUl4Udxe6Wito7pMu1dptkYxCFejtxUUf5tv1sIjamgsyz3v4iGHKUnnwMG
         50tWVEfnHgkLxe4a9kmnYS+9G6Flyn10b/qlzHx/0//YJDZNyZ+15Znb5mO/QN1eGlbm
         u9HM5rBpcJRPFjbB4r/w59ucDHNXRSlt5SmfHR1zTfUJwKRtvW+QXznsTxBLTGagv21L
         mvi1h844K+vGvRUMiuc/PF50EGJz0JdphwMuPY+BTn+4I2EZtW4yhRKcqU0Fj5GkVGSW
         FGLF9apjFEdYLojVHJH+NznmI3F+wNH0Kbu1OunL/Ib18Ruon9E/EyOzoN1XdQD+IAXQ
         3sSQ==
X-Gm-Message-State: AC+VfDzgAxJjiMtiTDkq/f2c+QYAOAeshR1ARMo2T+tK8Lmvs16lHrpf
	D42iWqlQRqKLn5XRh+WpwLP+ATUo2TnBvw==
X-Google-Smtp-Source: ACHHUZ7oqwKqLtmWi9l5b+wZfnA+BOM21eaFZIWGSv/qKfGk3OY18DtLlvitnJ83jc22lPnE0x5vgA==
X-Received: by 2002:ac8:7d0b:0:b0:3f0:a755:61ef with SMTP id g11-20020ac87d0b000000b003f0a75561efmr1808135qtb.0.1684440182728;
        Thu, 18 May 2023 13:03:02 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x5-20020a05620a01e500b0074fb15e2319sm610462qkn.122.2023.05.18.13.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 13:03:02 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCHv2 net] sctp: fix an issue that plpmtu can never go to complete state
Date: Thu, 18 May 2023 16:03:00 -0400
Message-Id: <79f4da2e037fb14258865db606a102bf587404f0.1684440180.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When doing plpmtu probe, the probe size is growing every time when it
receives the ACK during the Search state until the probe fails. When
the failure occurs, pl.probe_high is set and it goes to the Complete
state.

However, if the link pmtu is huge, like 65535 in loopback_dev, the probe
eventually keeps using SCTP_MAX_PLPMTU as the probe size and never fails.
Because of that, pl.probe_high can not be set, and the plpmtu probe can
never go to the Complete state.

Fix it by setting pl.probe_high to SCTP_MAX_PLPMTU when the probe size
grows to SCTP_MAX_PLPMTU in sctp_transport_pl_recv(). Also, not allow
the probe size greater than SCTP_MAX_PLPMTU in the Complete state.

Fixes: b87641aff9e7 ("sctp: do state transition when a probe succeeds on HB ACK recv path")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v2:
- fix the probe size can't reach SCTP_MAX_PLPMTU, as Paolo suggested.
---
 net/sctp/transport.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 2f66a2006517..2abe45af98e7 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -324,9 +324,12 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
 		t->pl.probe_size += SCTP_PL_BIG_STEP;
 	} else if (t->pl.state == SCTP_PL_SEARCH) {
 		if (!t->pl.probe_high) {
-			t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_BIG_STEP,
-					       SCTP_MAX_PLPMTU);
-			return false;
+			if (t->pl.probe_size < SCTP_MAX_PLPMTU) {
+				t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_BIG_STEP,
+						       SCTP_MAX_PLPMTU);
+				return false;
+			}
+			t->pl.probe_high = SCTP_MAX_PLPMTU;
 		}
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
 		if (t->pl.probe_size >= t->pl.probe_high) {
@@ -341,7 +344,7 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
 	} else if (t->pl.state == SCTP_PL_COMPLETE) {
 		/* Raise probe_size again after 30 * interval in Search Complete */
 		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
-		t->pl.probe_size += SCTP_PL_MIN_STEP;
+		t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_MIN_STEP, SCTP_MAX_PLPMTU);
 	}
 
 	return t->pl.state == SCTP_PL_COMPLETE;
-- 
2.39.1


