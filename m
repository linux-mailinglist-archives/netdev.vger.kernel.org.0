Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CB96D34EF
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 01:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDAXKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 19:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDAXKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 19:10:01 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CEF1B35C;
        Sat,  1 Apr 2023 16:10:00 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id nc3so1555123qvb.1;
        Sat, 01 Apr 2023 16:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680390599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xrgZTOAVUhWKefcg7vhZUdQaOyjVCef0gOc62Bm3Ad0=;
        b=iy0ufdhh6X5+s1jVvBMNrnD2tMJkW8/1bHxIjlXRyHO7dCw88wh4gE418eTWBv9ql/
         fbJL9qITLYmWLXR6aoCt2IPVMzLiLC+J3uJe3olt8ZjTI0/ZeY8sQpjAFj4D1LpYSyOm
         1DWyuFDkci7g0pXCXZSaCQ03LKkEBR/o+xa07zMqbAvD5jskm4QvE85TYQX4ornVSXCy
         OQY+swiIh9UTv9afjTbBViGY7Ki9SjBxendFcAb80xj9Pt4Arc0wuR9EMQQYrP3+/FTs
         ZNPm3k7Kzg28iHQSg5jp7uoaPCp9F0TiU68TtUyoPDcVekyBhDvCx1Hfc0YW4+GRbD2D
         OOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680390599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xrgZTOAVUhWKefcg7vhZUdQaOyjVCef0gOc62Bm3Ad0=;
        b=Ylw31TxmyZSg6RpGsElHO2vUzR/zNGFlCZJWZa675Byb7TVREKrppqaBrjnQmLdadb
         iQKP3tMClp1t6AOdeFM/jj7V7QLCtJonL3BZrSrMg/uGmRPuNvrbnl7MP0WvOxuBWWLu
         pVfDPWHbo5OhxEWZ2NbxbZl/7rtofB5Dz5C1s8EL031FtEktmdwZFndZvU04KaLsN9m2
         Rs9TpPzNY8ET82zcGYiiwC/EaKucWllp7km2KiXtfXN9/uu2X9KSO9u2TsKkoUH5Ntp8
         yvTnJVwhyTPm/ARJTnWkqGA1nl1R2eOKmbx3XmbfJ/xTIhxTqSwGNtTCfpLzh4qc+xUB
         yRvw==
X-Gm-Message-State: AAQBX9dbJSZ+EMJbfeKR5a4C9ZbwrahBZVLyW3aUCDPYzi0B4bwa45rp
        c3xYvKcaKmPFin0aUTgbODMI296rXGvVJg==
X-Google-Smtp-Source: AKy350ZY8OomxGbNrAVTNfDhGgM2ikQTqC8bqbkWmTrGRxWIT29eM5kOOnRgCtYyLHnUegKwQOtY/Q==
X-Received: by 2002:a05:6214:2127:b0:56f:b28f:cc30 with SMTP id r7-20020a056214212700b0056fb28fcc30mr27222900qvc.4.1680390599117;
        Sat, 01 Apr 2023 16:09:59 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id mx5-20020a0562142e0500b005dd8b9345desm1565614qvb.118.2023.04.01.16.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 16:09:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: check send stream number after wait_for_sndbuf
Date:   Sat,  1 Apr 2023 19:09:57 -0400
Message-Id: <313e35feff94a17a88c2b6f6c4fa0b743754ec01.1680390597.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a corner case where the asoc out stream count may change
after wait_for_sndbuf.

When the main thread in the client starts a connection, if its out stream
count is set to N while the in stream count in the server is set to N - 2,
another thread in the client keeps sending the msgs with stream number
N - 1, and waits for sndbuf before processing INIT_ACK.

However, after processing INIT_ACK, the out stream count in the client is
shrunk to N - 2, the same to the in stream count in the server. The crash
occurs when the thread waiting for sndbuf is awake and sends the msg in a
non-existing stream(N - 1), the call trace is as below:

  KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
  Call Trace:
   <TASK>
   sctp_cmd_send_msg net/sctp/sm_sideeffect.c:1114 [inline]
   sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1777 [inline]
   sctp_side_effects net/sctp/sm_sideeffect.c:1199 [inline]
   sctp_do_sm+0x197d/0x5310 net/sctp/sm_sideeffect.c:1170
   sctp_primitive_SEND+0x9f/0xc0 net/sctp/primitive.c:163
   sctp_sendmsg_to_asoc+0x10eb/0x1a30 net/sctp/socket.c:1868
   sctp_sendmsg+0x8d4/0x1d90 net/sctp/socket.c:2026
   inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:825
   sock_sendmsg_nosec net/socket.c:722 [inline]
   sock_sendmsg+0xde/0x190 net/socket.c:745

The fix is to add an unlikely check for the send stream number after the
thread wakes up from the wait_for_sndbuf.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: syzbot+47c24ca20a2fa01f082e@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b91616f819de..218e0982c370 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1830,6 +1830,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
 			goto err;
+		if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt)) {
+			err = -EINVAL;
+			goto err;
+		}
 	}
 
 	if (sctp_state(asoc, CLOSED)) {
-- 
2.39.1

