Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2E83746FC
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbhEERgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhEERc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:32:59 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0B3C04BE41;
        Wed,  5 May 2021 10:02:46 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id c11so3559929lfi.9;
        Wed, 05 May 2021 10:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=YSt2n6tg1L8D8NfOV5h6bZa4yblTsEFW9SIkP8Zz44c=;
        b=U/jQhSoJlxhMF4no9yg1cUK0jtF9uHZLjTBkrKe6tGAQHYiVfh3EJACbomUnHQ5zO5
         fj2dK0vAl6CsxLqlqtHimm05p6vNDYFclT20TRsbo69v0dWVTDwqgb9EqSe551PuKJNu
         n2469YPr7jLXrPqkx/EojzOQ2/G04tOrY8JZdaWzU4ZSJqPqLjd4n/E2ORUz05TUyIDl
         ZqYHyUX/uNZOC67SWPPTgs6MNL/uCI8dMR8QF+ORrqs14rhjvngDO1bgBOt+0kZcPjr8
         tn+zOxLwErIQ+r3ZCReIBuxceUTJvZUUT+WaHl0QsP41CuIbKa/yqdl1RPFY3Hwxj4eo
         ZTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=YSt2n6tg1L8D8NfOV5h6bZa4yblTsEFW9SIkP8Zz44c=;
        b=C48PiYnat7URei/wDVsbfRQ8wi76KcVxT6qM2DtTqsH3eWxGplY+Phh7CgPeX0iUCt
         dFI8J/i47lkyGovo+7Q3BKRM1LR3NeaYfIPK8S8CEEtZCMGIA0YrFsfykseU6/xcHIsb
         epcV+R29PQYY09KE03b93+opd2T7pKKuF1aKwY5bEjXDPdcwbV+4vxm/p8KkJ7pvCu7a
         pfV7+pneWEzxt6bAJiCX6dbiW9TNinygR6TE71nHRCXjtF1V2pZUT/e2U9dUe81B2UHh
         TMAySFErhLFUkh9BiBU9LuWp2Yn/n+CuS4mYehkPLxypueLpU4JoXeS0yYJXktF+Nb5N
         tCpg==
X-Gm-Message-State: AOAM533Fm0J45WYlE1yvSDv7Gdx0b9Xr4UsEkEk1y/MZT7Gxf4IzX03A
        aYI0i6T7VJPP8oJ0BuC0Wu8=
X-Google-Smtp-Source: ABdhPJxyJD7PYRXhpF8nXrPAT1q+3x3hASqqSJLHr3jBDbPpUPySoxwpFhKmXhFpFO4Ws4ii2TTFHg==
X-Received: by 2002:a05:6512:33c4:: with SMTP id d4mr11423548lfg.536.1620234164982;
        Wed, 05 May 2021 10:02:44 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.84])
        by smtp.gmail.com with ESMTPSA id m2sm664151lfo.23.2021.05.05.10.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:02:44 -0700 (PDT)
Date:   Wed, 5 May 2021 20:02:42 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: GPF in net sybsystem
Message-ID: <20210505200242.31d58452@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, netdev developers!

I've spent some time debugging this bug
https://syzkaller.appspot.com/bug?id=c670fb9da2ce08f7b5101baa9426083b39ee9f90
and, I believe, I found the root case:

static int nr_accept(struct socket *sock, struct socket *newsock, int flags,
		     bool kern)
{
....
	for (;;) {
		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
		...
		if (!signal_pending(current)) {
			release_sock(sk);
			schedule();
			lock_sock(sk);
			continue;
		}
		...
	}
...
}

When calling process will be scheduled, another proccess can release
this socket and set sk->sk_wq to NULL. (In this case nr_release()
will call sock_orphan(sk)). In this case GPF will happen in
prepare_to_wait().

I came up with this patch, but im not an expect in netdev sybsystem and
im not sure about this one:

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 6d16e1ab1a8a..89ceddea48e8 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -803,6 +803,10 @@ static int nr_accept(struct socket *sock, struct socket *newsock, int flags,
 			release_sock(sk);
 			schedule();
 			lock_sock(sk);
+			if (sock_flag(sk, SOCK_DEAD)) {
+				err = -ECONNABORTED;
+				goto out_release;
+			}
 			continue;
 		}
 		err = -ERESTARTSYS;

I look forward to hearing your perspective on this :)


BTW, I found similar code in:

1) net/ax25/af_ax25.c
2) net/rose/af_rose.c


I hope, this will help!

With regards,
Pavel Skripkin
