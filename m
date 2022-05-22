Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6556530624
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 23:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiEVV03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 17:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241415AbiEVV0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 17:26:17 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1952A11470
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 14:26:16 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t28so4504956pga.6
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 14:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=BNAm4uZtl2ITDQyex4FwWrTK2V0fmL72ApwyQhtN0kY=;
        b=1DAMa/AabR3ZVY1ssDP3W9oTu/d5AIu8NMXZ/6EvLAht9rSTmf8UricQdLFteZ2poU
         YUZwTQ382fJiW9iudNe4opCIhDslx1ZSFNs/xZwQYWnVIDFfwMvj4EE3UU7s3mpWnl2d
         lfYPyMNcKXrwYM1Oc72TMzusDR/kjlOe+iI78IHIK+tQBhpm/Uj+2kRgr8evwgc9AbEE
         9NF5j0BW8EV22Q3LQhPPQ6THgvjSX5kdSHHsG2ufSmgbPkxdd/dS4vCAMlJjYa/Yyqht
         sF1O60rQ50oy7fJzKDLHIU8Zv5lG/YEUcTbg/LR7kNVEKPeKBN3pzAI70hWfeQmJ8JCj
         awRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=BNAm4uZtl2ITDQyex4FwWrTK2V0fmL72ApwyQhtN0kY=;
        b=CKa9vaeiSJE4PF6E3xGXlueUxR7kiGzvJMb/0rheMETksdIVxphsP/08xdHj5y9vF1
         ujr4MwLCKqvQzsJT1pnir1nF7W8cyN2YdnjmgMFQK/7JVzFdth6n4BiqWxYWcOATjuF4
         GIDs/viDceEGdodFiKsyEudtadX9KvmqvNZaIt5qGuQMDqo34EGDVtB3MrX1T3YyObr/
         /iKOYA+hQP+YA536phMSsIZmruCaT9lS7W6xsAW+81xpf1gGzMf+hjALGnaH6xKSJWi3
         /SMkaKZAgT4eaNQrddxNLUY7RoLY0c2Vcv/iSZPWmehQlIAjol7tSoNt3qPP9MzqSWGg
         NZUA==
X-Gm-Message-State: AOAM532vnAtdCqxEOdw6MMJwgnYAwdHHkeIqMz8K31KsG84S7m6cq5Vg
        xiP7Kl0fpA/44GBlE2wmBRIViQ5wUvR+dA==
X-Google-Smtp-Source: ABdhPJxHxvJrNIXNeDlUx6M10J0qPezIpoG6cTjT+EqCekbBRI/y05kBTTB9W0cCsEDpVtMSKyfKAw==
X-Received: by 2002:a65:404c:0:b0:3c6:4018:ffbf with SMTP id h12-20020a65404c000000b003c64018ffbfmr17994479pgp.408.1653254775374;
        Sun, 22 May 2022 14:26:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b4-20020a62a104000000b005181409a78esm5678484pff.110.2022.05.22.14.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 14:26:14 -0700 (PDT)
Message-ID: <6fd7e1ff-7807-442b-3c4a-344e006e0450@kernel.dk>
Date:   Sun, 22 May 2022 15:26:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring 'more data in socket' support
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

To be able to fully utilize the 'poll first' support in the core
io_uring branch, it's advantageous knowing if the socket was empty after
a receive. This pull request adds support for that.

The core networking change conflicted with changes in netdev-next, so
it's sitting in a separate branch that both Jakub and I pulled in.

Note that this will through a merge conflict due to later changes in the
core io_uring branch, resolution:

diff --cc fs/io_uring.c
index d9529275a030,20c5d29e5b6c..1015dd49e7e5
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@@ -6115,6 -5947,8 +6115,7 @@@ static int io_recvmsg(struct io_kiocb *
  	struct io_async_msghdr iomsg, *kmsg;
  	struct io_sr_msg *sr = &req->sr_msg;
  	struct socket *sock;
 -	struct io_buffer *kbuf;
+ 	unsigned int cflags;
  	unsigned flags;
  	int ret, min_ret = 0;
  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@@ -6154,7 -5982,10 +6155,8 @@@
  	if (flags & MSG_WAITALL)
  		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
  
+ 	kmsg->msg.msg_get_inq = 1;
 -
 -	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 -					kmsg->uaddr, flags);
 +	ret = __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg, kmsg->uaddr, flags);
  	if (ret < min_ret) {
  		if (ret == -EAGAIN && force_nonblock)
  			return io_setup_async_msg(req, kmsg);


Please pull!


The following changes since commit 8013d1d3d2e33236dee13a133fba49ad55045e79:

  Merge tag 'soc-fixes-5.18-3' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc (2022-04-29 15:51:05 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-net-2022-05-22

for you to fetch changes up to f548a12efd5ab97e6b1fb332e5634ce44b3d9328:

  io_uring: return hint on whether more data is available after receive (2022-04-29 21:12:12 -0600)

----------------------------------------------------------------
for-5.19/io_uring-net-2022-05-22

----------------------------------------------------------------
Jens Axboe (4):
      tcp: pass back data left in socket after receive
      Merge branch 'for-5.19/io_uring-socket' into for-5.19/io_uring-net
      Merge branch 'tcp-pass-back-data-left-in-socket-after-receive' of git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux into for-5.19/io_uring-net
      io_uring: return hint on whether more data is available after receive

 fs/io_uring.c                 | 19 +++++++++++++++----
 include/linux/socket.h        |  6 +++++-
 include/uapi/linux/io_uring.h |  2 ++
 net/ipv4/tcp.c                | 16 ++++++++++------
 4 files changed, 32 insertions(+), 11 deletions(-)

-- 
Jens Axboe

