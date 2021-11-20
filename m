Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694D8457ECC
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 16:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbhKTPFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 10:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236770AbhKTPFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 10:05:10 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C901C061574;
        Sat, 20 Nov 2021 07:02:06 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id b1so57302882lfs.13;
        Sat, 20 Nov 2021 07:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=iYwC9YQ4kJHdzsywvL9y8mfy/c47skD/0CgkzcadpUE=;
        b=PWwdYAz1dZdhqKdzYlShs41QlpbzofaOd/PMagiiDMmTPx0B8hQFkiRHhPNhl4yV1q
         dO/thHTSSIlcF4SogwHVtIX/bI2Dnl2sn43xjz68xZV4ZutPak5M1vRaXMcW5cFT68VP
         AuLSRsD15z6timRB3b9rg1SiF+/raA4CL7MWuq2gSe8/9XkQEXE2xjt2EJ67tR+jTgQl
         nkkt6eICNi7+TAHwFblTvadLMVcR779Sga7Ps0mJanWXphsjW1/AF66v1BVmebvHBuAg
         FxfAGv0tA54vnpDzJwoCVrd77kh83hmGF/UpPRJ52lOVurSNpUdl+k7aKz1bJWxB7dH/
         X3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iYwC9YQ4kJHdzsywvL9y8mfy/c47skD/0CgkzcadpUE=;
        b=xgaGedIYu7ZyuuuYvT924vyx1Wb1xnY5BisRMYVA9ZXZ8ynbaoL7GxsVtOXk6LIq3x
         BLtGf9/0NhgZUzEmgEqSaoGoUHNLRzOFTuCvLCALWFEWQYGbRSh+ZYGNECo/SYXYHjvO
         laD25ebT1nCCXF2neiZP2QogU27XG5fU1pdoikNI0WA+L/gTqo+ss0QXzDFZTXh0YNWQ
         zvV/wA1eyNJXjDe5Im1xamImHVAUkZT7iY9qH9K63nclmE5NP1TxVLZoRYnemvi06mLU
         M8Sa1JJSheTWzEfQBO7y4mSoLktZeYXO+VWdF0RwDE7Geiwgxmpf99f9DuIkVwFG9SvB
         VvAg==
X-Gm-Message-State: AOAM5315c59fsenIi9Aw7HoRHdozNLirLiKkfLQaK+jDU9kJvN31yknx
        VGtwQwIsdGPK/uoveBfcN5U=
X-Google-Smtp-Source: ABdhPJxdPk1D6EHw/Gg8Q2AW6S1zf/knnHu5BteszreKeqbuXTzT0DIP9Tvzck243nKiXholm8dvcA==
X-Received: by 2002:a19:f242:: with SMTP id d2mr42343402lfk.516.1637420524198;
        Sat, 20 Nov 2021 07:02:04 -0800 (PST)
Received: from [192.168.1.11] ([217.117.245.63])
        by smtp.gmail.com with ESMTPSA id k14sm242347ljk.57.2021.11.20.07.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 07:02:03 -0800 (PST)
Message-ID: <91426976-b784-e480-6e3a-52da5d1268cc@gmail.com>
Date:   Sat, 20 Nov 2021 18:02:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [syzbot] KASAN: use-after-free Read in rxe_queue_cleanup
Content-Language: en-US
To:     syzbot <syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com>,
        dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, zyjzyj2000@gmail.com
References: <000000000000c4e52d05d120e1b0@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000c4e52d05d120e1b0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/21 12:27, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8d0112ac6fd0 Merge tag 'net-5.16-rc2' of git://git.kernel...
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=14e3eeaab00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
> dashboard link: https://syzkaller.appspot.com/bug?extid=aab53008a5adf26abe91
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com
> 
> Free swap  = 0kB
> Total swap = 0kB
> 2097051 pages RAM
> 0 pages HighMem/MovableOnly
> 384517 pages reserved
> 0 pages cma reserved
> ==================================================================
> BUG: KASAN: use-after-free in rxe_queue_cleanup+0xf4/0x100 drivers/infiniband/sw/rxe/rxe_queue.c:193
> Read of size 8 at addr ffff88814a6b6e90 by task syz-executor.3/9534
> 

On error handling path in rxe_qp_from_init() qp->sq.queue is freed and 
then rxe_create_qp() will drop last reference to this object. qp clean 
up function will try to free this queue one time and it causes UAF bug.

Just for thoughts.


diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c 
b/drivers/infiniband/sw/rxe/rxe_qp.c
index 975321812c87..54b8711321c1 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -359,6 +359,7 @@ int rxe_qp_from_init(struct rxe_dev *rxe, struct 
rxe_qp *qp, struct rxe_pd *pd,

  err2:
  	rxe_queue_cleanup(qp->sq.queue);
+	qp->sq.queue = NULL;
  err1:
  	qp->pd = NULL;
  	qp->rcq = NULL;





With regards,
Pavel Skripkin
