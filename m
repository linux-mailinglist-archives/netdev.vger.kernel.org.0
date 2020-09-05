Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A95D25EB37
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgIEWFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgIEWFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 18:05:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0A4C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 15:05:50 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t7so1669906pjd.3
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 15:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YnaMCdeWvZXYvgvIk9eHrbMNqT0nfMk9PTITFH8gDAQ=;
        b=joecbzDbQAQ3Mstnk3x60Ovy1MQ/UN47TH3qMV0heHJ6LVcpaUloL7XZ8KULPH6fQH
         A8c9Etg2NB6KsnvHUbPOiFEewP4qtndYs/4vA4tkdec7IvgtCXusKhE87ePaJJEFOubr
         Lq9L50pjIwUZHXU96kDmO7I0s+s9apyukzibH72RUu/0MmSyLXH5geXhW616zLJo+Ytn
         7+YYcxMJLeZhOvfy6PDfruTGGqQFPdGVOfXDOZVyeSu5XRdknLf7u8aqV8FtRtMAEBAR
         laXG0BE7/AHmtaHo4QZNAhqRtDUvWnmeeOhfhKQB1W6xgokizeWFZg2kb9mWdCKClhPV
         hyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YnaMCdeWvZXYvgvIk9eHrbMNqT0nfMk9PTITFH8gDAQ=;
        b=cCPoA7MII8bBLOq9+eEo+eMda8jJw0HZhj90O7n60hSpqS6fmDldvTtihQNBvaM3R8
         hkbFLy1gzHYE2I6t4ZA/rTpNtu7humG4rLy960ZP+vcYTsShLqKFp31eOaZAYvOUEEwP
         /5g4IVVK/LQxbOBJwKlamfAg1h55qBY8GetaI2XdB+Tss/hljaY0Djynrrd2gdktFGit
         L4WRRcui3VktvfzzgXHkaW9PklFKCvxX4RbVGUoyUVND2Vj4aKrIgOzehCu6OohquYza
         bhjJW5ku53EbZRilWbysQKwR+MXHGIq2dtilcJuS2ehzj5ljjDWQ7XuJqD2/aCc3MZ3Q
         FhyQ==
X-Gm-Message-State: AOAM533uxrUrt7G2FOQAX5CUtUndlLKaz3Y9GEVztkhjnkQiDyFAu22b
        xqZp2rifrUX0eK+L7qwp4+KmmhoNJQgmp/q4
X-Google-Smtp-Source: ABdhPJyNT6JzP9tAQQAakzXED+WSYM1u8xEvmfUjLp9imnj4afow1LI3D9491zXwUYpILsOIPCQ/Zg==
X-Received: by 2002:a17:90a:aa15:: with SMTP id k21mr6963736pjq.22.1599343549913;
        Sat, 05 Sep 2020 15:05:49 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p9sm8819686pjm.1.2020.09.05.15.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 15:05:49 -0700 (PDT)
To:     Networking <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] net: provide __sys_shutdown_sock() that takes a
 socket
Message-ID: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
Date:   Sat, 5 Sep 2020 16:05:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes in this patch, needed to provide io_uring support
for shutdown(2).

Cc: netdev@vger.kernel.org
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

There's a trivial io_uring patch that depends on this one. If this one
is acceptable to you, I'd like to queue it up in the io_uring branch for
5.10.

diff --git a/include/linux/socket.h b/include/linux/socket.h
index e9cb30d8cbfb..385894b4a8bb 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -436,6 +436,7 @@ extern int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
 			     int __user *usockaddr_len);
 extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
+extern int __sys_shutdown_sock(struct socket *sock, int how);
 extern int __sys_shutdown(int fd, int how);
 
 extern struct ns_common *get_net_ns(struct ns_common *ns);
diff --git a/net/socket.c b/net/socket.c
index dbbe8ea7d395..59307db6097e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2192,6 +2192,17 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
  *	Shutdown a socket.
  */
 
+int __sys_shutdown_sock(struct socket *sock, int how)
+{
+	int err;
+
+	err = security_socket_shutdown(sock, how);
+	if (!err)
+		err = sock->ops->shutdown(sock, how);
+
+	return err;
+}
+
 int __sys_shutdown(int fd, int how)
 {
 	int err, fput_needed;
@@ -2199,9 +2210,7 @@ int __sys_shutdown(int fd, int how)
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
-		err = security_socket_shutdown(sock, how);
-		if (!err)
-			err = sock->ops->shutdown(sock, how);
+		err = __sys_shutdown_sock(sock, how);
 		fput_light(sock->file, fput_needed);
 	}
 	return err;

-- 
Jens Axboe

