Return-Path: <netdev+bounces-3195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5BF705F36
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95FF1280D0B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E41749D;
	Wed, 17 May 2023 05:23:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8313E5680;
	Wed, 17 May 2023 05:23:08 +0000 (UTC)
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A475040DF;
	Tue, 16 May 2023 22:22:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-24dfc3c662eso327245a91.3;
        Tue, 16 May 2023 22:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300975; x=1686892975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3FN9sT9Rg9+6HLfWG/dAanGnOnS9deMkEnoHttFxs0=;
        b=Sv3W4QScFUqQqo8aS/h0bNjOH8VC2C9o0u3JFijUQbd4/7tTk/3TqecQKAR3o+85vv
         S59J6TPgFKObgKw5luhnusbaszwD9XByBVefwtqrMEh8SqX/9khqUuSwSv5SgmQcY691
         2wBCyALFyOrGzl+uYH8HSIKM2qhMrp/uWtjdvVgxf6dBSRriNs8JFqKYDwu2dhujpwDQ
         CVOW8mQVhjkMlchN7kciLX7OQRQd0+2G+zaMKFs9wOE9z0gAZJkAFlybMBl3GYWY5mrX
         tDerylF8jeZXhlkDbsqIo5Twcz2hZ9wXoFaQf9oMKrmEaIIPc7NUcq1eXemqVslNcnbU
         Nm4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300975; x=1686892975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3FN9sT9Rg9+6HLfWG/dAanGnOnS9deMkEnoHttFxs0=;
        b=CpsNXQcxn+svyI1Pc09Rp2HSlPG3NvtsMukN81ji9rH2nPdgHLpVCLHNv124pjD56X
         /5ekMZRDveVGbzvGuTrw8ZjkSzeqtJT+hLrMqtZ52GZko0dPL/bEf33jWD5DwI3057FC
         w3tx/yeEMJ84Y3GEudcCzdc7vTDJeqBGBdQq2BsbWHmP7ptVj/rcYE6H40bJAuCRMx7v
         w9AmRbJdjY2KRr5GjIpkhuqCmwuRHxGcQdkgAtYUd7PbIdQGkrmmo+RaIBtH8r26doji
         4NerWJXervP10LgWYvQHGzfpfpbxOmQyBzWTZWBEZpNg/zCevzzH9yGc8bw/9Rx2f94E
         gquA==
X-Gm-Message-State: AC+VfDz67UNmAKIi48GrkUn8uwu+Dw1DtDLj4iYSUT5lqgMzGz7tmUAE
	8oES/kxIzXS0uySm8/yjF0A=
X-Google-Smtp-Source: ACHHUZ4VEkpc3Plcv7acHB1zDbTNaawmizNsc5/R2lAzQm1SezljIKcSQLjlhSZwU0jr3nqY4MohUQ==
X-Received: by 2002:a17:90a:a681:b0:237:62f7:3106 with SMTP id d1-20020a17090aa68100b0023762f73106mr39860730pjq.17.1684300975050;
        Tue, 16 May 2023 22:22:55 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:22:54 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v8 03/13] bpf: sockmap, reschedule is now done through backlog
Date: Tue, 16 May 2023 22:22:34 -0700
Message-Id: <20230517052244.294755-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230517052244.294755-1-john.fastabend@gmail.com>
References: <20230517052244.294755-1-john.fastabend@gmail.com>
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

Now that the backlog manages the reschedule() logic correctly we can drop
the partial fix to reschedule from recvmsg hook.

Rescheduling on recvmsg hook was added to address a corner case where we
still had data in the backlog state but had nothing to kick it and
reschedule the backlog worker to run and finish copying data out of the
state. This had a couple limitations, first it required user space to
kick it introducing an unnecessary EBUSY and retry. Second it only
handled the ingress case and egress redirects would still be hung.

With the correct fix, pushing the reschedule logic down to where the
enomem error occurs we can drop this fix.

Reviewed-by: Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Fixes: bec217197b412 ("skmsg: Schedule psock work if the cached skb exists on the psock")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 0a9ee2acac0b..76ff15f8bb06 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -481,8 +481,6 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		msg_rx = sk_psock_peek_msg(psock);
 	}
 out:
-	if (psock->work_state.skb && copied > 0)
-		schedule_delayed_work(&psock->work, 0);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
-- 
2.33.0


