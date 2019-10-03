Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD49CB091
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbfJCU4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:56:43 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33878 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730405AbfJCU4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:56:41 -0400
Received: by mail-ed1-f66.google.com with SMTP id p10so3951569edq.1
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 13:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=BTfVQUPvkSd3zwtzD41gJMj25Cg2Y0JL+4smmLswzXk=;
        b=F6/Tmi2+gUyjaVvJ2wK3fTR2sBNckqLfVqfjk2asu/RuZp3rOovhMMMe3ehDsmYJTo
         mDe+0nStJ/5oQdAW+xASSxerDDseZ3ynS6kXYbH6es7fhczv+s92ll7dUiOZujCvP3Rw
         6CbX2DtioEj3bQfn91AtLBkQP8xSjMmZ6UEmTEMLlI8qYWYXWRwWg6+iHkZuNjF7m2Y1
         8eJYAu7gy5CR3+jiRkxWF+/jgPfOOFUTG/g0x16oVg4QXCU6T4bsdH3IQO4+t0/yJ4w3
         Iic4d5HIGrshjCCkyI8PzpP/JD66sPvYrdru0rhzE4VTStKBM0DL6dxgMFQZHDbzLN1Y
         UwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=BTfVQUPvkSd3zwtzD41gJMj25Cg2Y0JL+4smmLswzXk=;
        b=EWpM3dWicrtkFpMI+L2TV2E9lWXmiVXTswe15BRo16C2mQmAQBgrDo0hfvUK8SXslq
         6lch2FdfTbCZKgmJgtfEPGNIJJclCZSWQSvpant6Gy+b0e3YOH/jaQ2qFi122llbkPz0
         BoRTpe8llHwe5snmTjsQCDbEOzsjx5abTnEk8gIzE1w/n8EsJNYiwJcZucbdZNVsxm1M
         x/M+KX7FKGK3Pa/nWW1oIdjGtNBBnL6fLHWKbhAQcBP1+ShSeTJuRsttvjvI08YkMayt
         V2OoFYItTvoroF0tdJMC+6kz/mVHdxgVIGf0JNGTsHLAU5b2IsV567H5sRZEdesOPHPg
         H8lg==
X-Gm-Message-State: APjAAAWqC2fZTxkdZObIYzxjt0eivJkNajbYiuzhVXxyrPLQ5+ChJHCy
        qZbC6tEB+WTEG9ShuSDG0vWcHT4=
X-Google-Smtp-Source: APXvYqxdhSeOWOCaImAE+sCdOwl87+8ySxwk4pxF7OHrbM9IZlM7lDlpoJg4MeC6HzD+h5SjjraEJQ==
X-Received: by 2002:a17:906:454c:: with SMTP id s12mr9425931ejq.69.1570136199266;
        Thu, 03 Oct 2019 13:56:39 -0700 (PDT)
Received: from avx2 ([46.53.250.203])
        by smtp.gmail.com with ESMTPSA id h1sm375983ejb.86.2019.10.03.13.56.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 13:56:38 -0700 (PDT)
Date:   Thu, 3 Oct 2019 23:56:37 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: spread "enum sock_flags"
Message-ID: <20191003205637.GA24270@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some ints are "enum sock_flags" in fact.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/net/sock.h |    2 +-
 net/core/sock.c    |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2512,7 +2512,7 @@ static inline bool sk_listener(const struct sock *sk)
 	return (1 << sk->sk_state) & (TCPF_LISTEN | TCPF_NEW_SYN_RECV);
 }
 
-void sock_enable_timestamp(struct sock *sk, int flag);
+void sock_enable_timestamp(struct sock *sk, enum sock_flags flag);
 int sock_recv_errqueue(struct sock *sk, struct msghdr *msg, int len, int level,
 		       int type);
 
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -687,7 +687,8 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
 	return ret;
 }
 
-static inline void sock_valbool_flag(struct sock *sk, int bit, int valbool)
+static inline void sock_valbool_flag(struct sock *sk, enum sock_flags bit,
+				     int valbool)
 {
 	if (valbool)
 		sock_set_flag(sk, bit);
@@ -3033,7 +3034,7 @@ int sock_gettstamp(struct socket *sock, void __user *userstamp,
 }
 EXPORT_SYMBOL(sock_gettstamp);
 
-void sock_enable_timestamp(struct sock *sk, int flag)
+void sock_enable_timestamp(struct sock *sk, enum sock_flags flag)
 {
 	if (!sock_flag(sk, flag)) {
 		unsigned long previous_flags = sk->sk_flags;
