Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC66A6A5480
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 09:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjB1Igm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 03:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjB1Igk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 03:36:40 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB4C234C7;
        Tue, 28 Feb 2023 00:36:26 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so12851464pjb.3;
        Tue, 28 Feb 2023 00:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TIAOi6OCtROUY7duKjKxd5xEJUKhJhjfjkjOjblVliw=;
        b=k3L2FIZo2E/iyTRpGPdRs/Zrkf7BmDJWAiQwEweZAkszCyHJDl6Yr1Wi5wWXij//sY
         BNrrQIk4PL6OHgKvfwLsgRpZsP4jei7h+nyPCnLcwXI2YlUwK7s+dqVYAib2VwNi9ugF
         keiY0LIr1lmCEnw2m3Jr4eSQuRgcYDtHPVVOySckN90x/uUfvh+ilL3VmgNAuxFl6QW3
         tSUOa8mShvJqp046adNt6yHO2KBfbZR1N8QERgoeaJxM1nRn2XWD6CG89agWMSoD5Lo2
         XFy8bVywNkM8S8ZpWN1P11W8wp/7IIPeq6dOg9lNheUDo3Y4DoI3uwPRIG3wwdX9GF53
         1IEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TIAOi6OCtROUY7duKjKxd5xEJUKhJhjfjkjOjblVliw=;
        b=wa3kVYIdaclZuBhm0PEYFTAlx/UGnQbfSFqQ4xhS7+5IYO6f+qPtGtBAYHNtZ6z6be
         jwpZ6Fk9LfgMHTb1tPXbSDmJdj/KTVUjbBJG70S6AJ8rnJVbNKLe7vSRuH3DCy5GbjbU
         J436c2avvS3eSTsTrNhi1PEoTu5va0vADVA4pq5lJHeJa7Sc/XlVxOffHnYTwGjL4MVs
         vY8Mdv2cpPd2UrcuRPhg6YGPI3iRJ2bb4Jtwzbnu8M67zBi8GOY33ifFPAVUuft5hM26
         Oel6Zp1wb5GsloTUtICF/IG2R59456NRINLH416Lf3y7ekRjjh35SiELY1mEVma1BnyM
         /plg==
X-Gm-Message-State: AO0yUKVUTdm9uln0ZZ6BAZ2YOLA8au6nYTxVVWzZBEFxR9Nlw2LxUrdi
        xV59heQUL68y/tHdhoPetP33Hht3QglQGg==
X-Google-Smtp-Source: AK7set9xKEjlBQZNrelFMavXv49YN9uV1eD8ja3Q4bq/y9cJYf3p3a2yHa5n+SqQR8UC9pjANlA7EQ==
X-Received: by 2002:a17:90b:1807:b0:234:eeb:8df4 with SMTP id lw7-20020a17090b180700b002340eeb8df4mr2534619pjb.14.1677573385614;
        Tue, 28 Feb 2023 00:36:25 -0800 (PST)
Received: from localhost ([98.97.39.75])
        by smtp.gmail.com with ESMTPSA id nh12-20020a17090b364c00b002369d3b282csm5654218pjb.40.2023.02.28.00.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 00:36:24 -0800 (PST)
Date:   Tue, 28 Feb 2023 00:36:23 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, edumazet@google.com,
        john.fastabend@gmail.com, jakub@cloudflare.com,
        davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, cong.wang@bytedance.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, liujian56@huawei.com
Message-ID: <63fdbd07b3593_5f4ac208eb@john.notmuch>
In-Reply-To: <20230223120212.1604148-1-liujian56@huawei.com>
References: <20230223120212.1604148-1-liujian56@huawei.com>
Subject: RE: [PATCH bpf] bpf, sockmap: fix an infinite loop error when len is
 0 in tcp_bpf_recvmsg_parser()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> When the buffer length of the recvmsg system call is 0, we got the
> flollowing soft lockup problem:
> 
> watchdog: BUG: soft lockup - CPU#3 stuck for 27s! [a.out:6149]
> CPU: 3 PID: 6149 Comm: a.out Kdump: loaded Not tainted 6.2.0+ #30
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:remove_wait_queue+0xb/0xc0
> Code: 5e 41 5f c3 cc cc cc cc 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 41 57 <41> 56 41 55 41 54 55 48 89 fd 53 48 89 f3 4c 8d 6b 18 4c 8d 73 20
> RSP: 0018:ffff88811b5978b8 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: ffff88811a7d3780 RCX: ffffffffb7a4d768
> RDX: dffffc0000000000 RSI: ffff88811b597908 RDI: ffff888115408040
> RBP: 1ffff110236b2f1b R08: 0000000000000000 R09: ffff88811a7d37e7
> R10: ffffed10234fa6fc R11: 0000000000000001 R12: ffff88811179b800
> R13: 0000000000000001 R14: ffff88811a7d38a8 R15: ffff88811a7d37e0
> FS:  00007f6fb5398740(0000) GS:ffff888237180000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000000 CR3: 000000010b6ba002 CR4: 0000000000370ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  tcp_msg_wait_data+0x279/0x2f0
>  tcp_bpf_recvmsg_parser+0x3c6/0x490
>  inet_recvmsg+0x280/0x290
>  sock_recvmsg+0xfc/0x120
>  ____sys_recvmsg+0x160/0x3d0
>  ___sys_recvmsg+0xf0/0x180
>  __sys_recvmsg+0xea/0x1a0
>  do_syscall_64+0x3f/0x90
>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> 
> The logic in tcp_bpf_recvmsg_parser is as follows:
> 
> msg_bytes_ready:
> 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
> 	if (!copied) {
> 		wait data;
> 		goto msg_bytes_ready;
> 	}
> 
> In this case, "copied" alway is 0, the infinite loop occurs.
> 
> According to the Linux system call man page, 0 should be returned in this
> case. Therefore, in tcp_bpf_recvmsg_parser(), if the length is 0, directly
> return.
> 
> Also modify several other functions with the same problem.
> 
> Fixes: 1f5be6b3b063 ("udp: Implement udp_bpf_recvmsg() for sockmap")
> Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
> Fixes: c5d2177a72a1 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---

Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
