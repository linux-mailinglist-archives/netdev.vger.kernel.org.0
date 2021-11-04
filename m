Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D09445ADB
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 20:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhKDUCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 16:02:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230438AbhKDUCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 16:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636055991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5ysUK4zlUy4qbvF8xulmXFjW7M2EeOHCxuh+1FxUYgQ=;
        b=HQ/NEzYkGdhWhXvT4hnNkllhxHqk6yTDcgKOWcKIIbXAVepaQCcXwQFI49LXI3XVbvQ4N/
        jUMsF3f4BBWFbyTyg64m84F1wutAk6FrESAwZ16OgnaEMcFlka9YjcmvJsNKncqA1Y7Sfr
        yKQIVEzTpTlFnteqindsD77vdBFoCW8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-tKWsgbS5OTikMT9YaN6btQ-1; Thu, 04 Nov 2021 15:59:51 -0400
X-MC-Unique: tKWsgbS5OTikMT9YaN6btQ-1
Received: by mail-ed1-f69.google.com with SMTP id w26-20020a056402071a00b003e28a389d04so6796485edx.4
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 12:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ysUK4zlUy4qbvF8xulmXFjW7M2EeOHCxuh+1FxUYgQ=;
        b=W7/Tl5zhAtbJFj9l3SM61yB2tgNKUuBBobA/tTrGt4TtHzc8jcNwXVUhmkAK1AjxKh
         pVnVzng64klnA7SCCGVrtBTQdo2WrTmUM/lpjTEKdR97KcTA8altalyjS55hwWv5we7e
         rPdHrocBNLBRTr3Yc8HqzbZGl/EJhdBlih5PbLSR8QCoFO5xHGJ6xQ7lCyK8WUZAwsPG
         wr3JVMeRRcmNLR117VW9ndrxhEM9s0Rd62ZEc8dKMxbN/WlKrX3QIoKFe3rNJR51ao/k
         8mkDTmFv76B9vA3uaWLhl4Bx0oRCA0WqzHQ0FJ6abFzrWGrgbArwwrnTIZFwCPUTWYdy
         uLHA==
X-Gm-Message-State: AOAM532IQWDyh+OOl9mclDSoaZh55L1Jued0+YI8T4AYs6PZ6POoiwnF
        c/pgd0hEmEwUQ2f+jDR70IrzphfV4pkFzhHBz2ji2WXzt5BP2I+vNiFqJoftQtWHLqU/G2aPOvv
        Xh/fEyeReXQNckzBihooWS0w3WArqg0bIYgnI9VBeiccS5bRc8yPN9Kz2uBF1v46flsf1
X-Received: by 2002:a17:906:c9cb:: with SMTP id hk11mr64150307ejb.204.1636055989373;
        Thu, 04 Nov 2021 12:59:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBAGFvqsv+54+E13aafHdXqWywSbJFTfv5rjyniwJl/0Di8RDpeDpuIohiIg3dLqbwbBM56g==
X-Received: by 2002:a17:906:c9cb:: with SMTP id hk11mr64150267ejb.204.1636055989131;
        Thu, 04 Nov 2021 12:59:49 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b105:dd00:d067:83f0:d612:b70f])
        by smtp.gmail.com with ESMTPSA id p3sm3096445ejy.94.2021.11.04.12.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 12:59:48 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>, Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] selinux: fix SCTP client peeloff socket labeling
Date:   Thu,  4 Nov 2021 20:59:49 +0100
Message-Id: <20211104195949.135374-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit referenced in the "Fixes" tag mistakenly attempted to
preserve the label of the peeloff socket that had been set in
selinux_socket_post_create() in the case of a client socket. However,
the peeloff socket should in fact just inherit the label from the parent
socket. In practice these labels are usually the same, but they may
differ when setsockcreatecon(3) or socket type transition rules are
involved.

The fact that selinux_socket_[post_]create() are called on the peeloff
socket is actually not what should be happening (it is a side effect of
sctp_do_peeloff() using socket_create() to create the socket, which
calls the aforementioned LSM hooks). A patch to fix this is being worked
on.

In the meanwhile, at least fix sctp_assoc_established() to set
asoc->secid to the socket's sid and selinux_sctp_sk_clone() to
unconditionally get the peeloff socket's sid from asoc->secid, which
will ensure that the peeloff socket gets the right label in case of both
client and server SCTP socket. The label set by
selinux_socket_post_create() will be simply overwritten in both cases,
as was the case before the commit this patch is fixing.

Passed both the selinux-testsuite (with client peeloff tests added) and
the SCTP functional test suite from lksctp-tools.

Fixes: e7310c94024c ("security: implement sctp_assoc_established hook in selinux")
Based-on-patch-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---

As agreed with Xin Long, I'm posting this fix up instead of him. I am
now fairly convinced that this is the right way to deal with the
immediate problem of client peeloff socket labeling. I'll work on
addressing the side problem regarding selinux_socket_post_create()
being called on the peeloff sockets separately.

Please don't merge this patch without an ack from Paul, as it seems
we haven't reached an overall consensus yet.

 security/selinux/hooks.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5e5215fe2e83..5d9da4662449 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5502,8 +5502,7 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
 	if (!selinux_policycap_extsockclass())
 		return selinux_sk_clone_security(sk, newsk);
 
-	if (asoc->secid != SECSID_WILD)
-		newsksec->sid = asoc->secid;
+	newsksec->sid = asoc->secid;
 	newsksec->peer_sid = asoc->peer_secid;
 	newsksec->sclass = sksec->sclass;
 	selinux_netlbl_sctp_sk_clone(sk, newsk);
@@ -5566,7 +5565,7 @@ static void selinux_sctp_assoc_established(struct sctp_association *asoc,
 
 	selinux_inet_conn_established(asoc->base.sk, skb);
 	asoc->peer_secid = sksec->peer_sid;
-	asoc->secid = SECSID_WILD;
+	asoc->secid = sksec->sid;
 }
 
 static int selinux_secmark_relabel_packet(u32 sid)
-- 
2.31.1

