Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70210513EF0
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbiD1XQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiD1XQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:16:38 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EA4C0F
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:13:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a11so5492401pff.1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=s+Bpp1VQWZiMXyDy3amNmtGG8toAf7BM9+lLPafbqKA=;
        b=z/uRLf5j/5tkxgHV7NKiDMF3LyZxOhl+UfhBdOjYF4yld9GJrIXplV9bCfqxcqBBuj
         BNlGePvnokNHZbPIvMcuJCuHGe/KBBIf+M1b6A0ulwcepjIL9XWNn9yw0J7I2fCABqFX
         ocLCIBmxtL9yCg0M5qVcqrtGw0DJQkTu2mexdkSuQDv5NHEw3enlEOo+6yQCMkEx0+mI
         Q+w/pwNmbmZJp4bPKyyN+nRkPuw0rTnsgvHreykGiya8EDILzPNNpgUMFdLey5B/TJ6E
         YILvMOs5b2DNcc/BrQhTZAfFRujvI2agQnYxGfjb23KsIoSOxI2AcIkXhWocZmJwVT3D
         cHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=s+Bpp1VQWZiMXyDy3amNmtGG8toAf7BM9+lLPafbqKA=;
        b=0K5eFkRtamUGz8J2q6p9dLr7mm4c8ZD9Rc8NZZ+9UX7Qlf6/zoYDW2ZOjG85OSlX2f
         DBuFooYfCeQbpJlCZD6rxmnGKj0R70L57KMYwXGAmzkQ+M2NHvawF4gmV4zp4tPAKSfO
         uk5uz4jfH1H6ATjCJj+nlkk1p/V1/re5tvwLeR1A8xZ3KJW6FTY3ij+qEy0k2z+RIwZO
         xqRxtzFbMvw0OzfDUdyAZMuFq1SxSk3Huz6jYSP3yYbGFBj07/72IrUxPeV3fg5m+ZWl
         X1wb2tana1u4y554QS2eq8DzXSasYnChlDAP9hfc4oSQen6uQYUfqNPuIvJ/pCBBVvBu
         kaOw==
X-Gm-Message-State: AOAM530JV5O53OZLiaGO77pO12+zzQz0xAXIwADC3UhlAm7vN3ouf0Wg
        mBRtV6gZ3ZQa7e3v9GbRb5l05JfZPNerWlGS
X-Google-Smtp-Source: ABdhPJxoAAY1EkUh91vFkbZDCTGQwCxo232XPAWYkVBMS5tgNdtUNFSe/xba8Bt9IqWeBnyS6HRpWg==
X-Received: by 2002:a62:bd14:0:b0:50d:4bec:ff78 with SMTP id a20-20020a62bd14000000b0050d4becff78mr19079950pff.71.1651187601728;
        Thu, 28 Apr 2022 16:13:21 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090abd0300b001cd630f301fsm11675701pjr.36.2022.04.28.16.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 16:13:20 -0700 (PDT)
Message-ID: <2975a359-2422-71dc-db6b-9e4f369cae77@kernel.dk>
Date:   Thu, 28 Apr 2022 17:13:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] tcp: pass back data left in socket after receive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is currently done for CMSG_INQ, add an ability to do so via struct
msghdr as well and have CMSG_INQ use that too. If the caller sets
msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.

Rearrange struct msghdr a bit so we can add this member while shrinking
it at the same time. On a 64-bit build, it was 96 bytes before this
change and 88 bytes afterwards.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

v2: rebased on net-next, s/net/tcp in subject

 include/linux/socket.h |  6 +++++-
 net/ipv4/tcp.c         | 14 +++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 6f85f5d957ef..12085c9a8544 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -50,6 +50,9 @@ struct linger {
 struct msghdr {
 	void		*msg_name;	/* ptr to socket address structure */
 	int		msg_namelen;	/* size of socket address structure */
+
+	int		msg_inq;	/* output, data left in socket */
+
 	struct iov_iter	msg_iter;	/* data */
 
 	/*
@@ -62,8 +65,9 @@ struct msghdr {
 		void __user	*msg_control_user;
 	};
 	bool		msg_control_is_user : 1;
-	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
+	bool		msg_get_inq : 1;/* return INQ after receive */
 	unsigned int	msg_flags;	/* flags on received message */
+	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index db55af9eb37b..b6aa4df79429 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2314,8 +2314,10 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
-	if (tp->recvmsg_inq)
+	if (tp->recvmsg_inq) {
 		*cmsg_flags = TCP_CMSG_INQ;
+		msg->msg_get_inq = 1;
+	}
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	/* Urgent data needs to be handled specially. */
@@ -2537,7 +2539,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		int *addr_len)
 {
-	int cmsg_flags = 0, ret, inq;
+	int cmsg_flags = 0, ret;
 	struct scm_timestamping_internal tss;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
@@ -2552,12 +2554,14 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	ret = tcp_recvmsg_locked(sk, msg, len, flags, &tss, &cmsg_flags);
 	release_sock(sk);
 
-	if (cmsg_flags && ret >= 0) {
+	if ((cmsg_flags || msg->msg_get_inq) && ret >= 0) {
 		if (cmsg_flags & TCP_CMSG_TS)
 			tcp_recv_timestamp(msg, sk, &tss);
+		if (msg->msg_get_inq)
+			msg->msg_inq = tcp_inq_hint(sk);
 		if (cmsg_flags & TCP_CMSG_INQ) {
-			inq = tcp_inq_hint(sk);
-			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
+			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(msg->msg_inq),
+				 &msg->msg_inq);
 		}
 	}
 	return ret;
-- 
2.35.1

-- 
Jens Axboe

