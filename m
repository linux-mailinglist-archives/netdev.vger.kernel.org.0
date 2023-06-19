Return-Path: <netdev+bounces-12016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E69735AF9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A8291C2033F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A36912B6E;
	Mon, 19 Jun 2023 15:18:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5C0D2F8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:18:11 +0000 (UTC)
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2D99B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:18:09 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f870247d6aso1665031e87.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1687187887; x=1689779887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cEBqqEbsAEqTlHtnTSlW5ia+mGmNFYqtgBvN37JXgA8=;
        b=CtAds3xIbv/apAMtZk7CGLHsf0ygYiEu4Hqr8tSO0CJ/NbTxanJD/vN8TOX6iiYHfO
         26NDQAMYLYZZhpeTH6miC6+9mmNuoSIROKzXXvKjzizm/0VciiW9DmTyFcwOapjhL6s5
         839BmYcr5t++jx8ER3ptFyQ734Fv1p/TIjlZtnxYQwcds6UkCYoKtp4mHYc2y/9aW8JG
         zN+z0qxaIkTq9+xqwWXUSgHE2VLoIkkjduothwgjTLDNyL4zdABUspeUC76ecDdPMakF
         QIhQZ4vb95hweUpiPBR0fklc8Hl63bNNJnC4qdsFTdpLmDeiyE4a4NFoKe91/LQCt4r8
         v3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687187887; x=1689779887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEBqqEbsAEqTlHtnTSlW5ia+mGmNFYqtgBvN37JXgA8=;
        b=kC8I+mjJrZLjeAGo3oxo+ebdjFAfk+mu7hiEeRQIqrTks2a5iCp1s4ZiieLE6wkxQL
         EoGRK9YH4rOCDKJh6TijLudq2WSwMFsp8DS/BPA4Q323IkbBo/flvTZw8mATyR6/iy+j
         RTu68Uy82jjEbM3VZtpfOpuyBqwNoSF0pnp261c+psIrEDRV5yJIx9VT/LoWVUII/5NG
         iEHRMBnknWdFzXAQvkGqr6QR9bLPJL2CKUN+fQmqkKc5gIlDaa/vKYJunlDL8NlQX5c/
         Z6GX/uHmJpTSU9GC98soTthd0Fd1HQZ4Cv7TfY+7kP7q9iy3yDF+c7scoSLN4re3zX6q
         8JcA==
X-Gm-Message-State: AC+VfDxfiu0P+xiF5zdvEn+i4r81uIXyhhPfwP5gy9CX4oTfCV2oA7Tv
	9bvCzpFO41ZLngZLTnuvHRBVJA==
X-Google-Smtp-Source: ACHHUZ5SRknqzXsBbghXY8JXOZNHqAobP/6x/QA+010SVESkq5P0BSItMFKnaZVHvqIlDUzayfEQCg==
X-Received: by 2002:a19:790a:0:b0:4f8:417b:c752 with SMTP id u10-20020a19790a000000b004f8417bc752mr5309414lfc.44.1687187887389;
        Mon, 19 Jun 2023 08:18:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d16-20020ac25450000000b004f84162e08bsm2095633lfn.185.2023.06.19.08.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 08:18:06 -0700 (PDT)
Date: Mon, 19 Jun 2023 17:18:05 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	syzbot <syzkaller@googlegroups.com>,
	Breno Leitao <leitao@debian.org>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH net-next] net: remove sk_is_ipmr() and sk_is_icmpv6()
 helpers
Message-ID: <ZJBxrWmScxYvcDGv@nanopsycho>
References: <20230619124336.651528-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619124336.651528-1-edumazet@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, Jun 19, 2023 at 02:43:35PM CEST, edumazet@google.com wrote:
>Blamed commit added these helpers for sake of detecting RAW
>sockets specific ioctl.
>
>syzbot complained about it [1].
>
>Issue here is that RAW sockets could pretend there was no need
>to call ipmr_sk_ioctl()
>
>Regardless of inet_sk(sk)->inet_num, we must be prepared
>for ipmr_ioctl() being called later. This must happen
>from ipmr_sk_ioctl() context only.
>
>We could add a safety check in ipmr_ioctl() at the risk of breaking
>applications.
>
>Instead, remove sk_is_ipmr() and sk_is_icmpv6() because their
>name would be misleading, once we change their implementation.

Hurts my fingers to write this, but it would be easier to follow the
patch description and actually undestand what you do with imperative
mood commanding the codebase, without the "we"nesses. But again,
nevermind :)


>
>[1]
>BUG: KASAN: stack-out-of-bounds in ipmr_ioctl+0xb12/0xbd0 net/ipv4/ipmr.c:1654
>Read of size 4 at addr ffffc90003aefae4 by task syz-executor105/5004
>
>CPU: 0 PID: 5004 Comm: syz-executor105 Not tainted 6.4.0-rc6-syzkaller-01304-gc08afcdcf952 #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
>Call Trace:
><TASK>
>__dump_stack lib/dump_stack.c:88 [inline]
>dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
>print_report mm/kasan/report.c:462 [inline]
>kasan_report+0x11c/0x130 mm/kasan/report.c:572
>ipmr_ioctl+0xb12/0xbd0 net/ipv4/ipmr.c:1654
>raw_ioctl+0x4e/0x1e0 net/ipv4/raw.c:881
>sock_ioctl_out net/core/sock.c:4186 [inline]
>sk_ioctl+0x151/0x440 net/core/sock.c:4214
>inet_ioctl+0x18c/0x380 net/ipv4/af_inet.c:1001
>sock_do_ioctl+0xcc/0x230 net/socket.c:1189
>sock_ioctl+0x1f8/0x680 net/socket.c:1306
>vfs_ioctl fs/ioctl.c:51 [inline]
>__do_sys_ioctl fs/ioctl.c:870 [inline]
>__se_sys_ioctl fs/ioctl.c:856 [inline]
>__x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
>do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>entry_SYSCALL_64_after_hwframe+0x63/0xcd
>RIP: 0033:0x7f2944bf6ad9
>Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>RSP: 002b:00007ffd8897a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2944bf6ad9
>RDX: 0000000000000000 RSI: 00000000000089e1 RDI: 0000000000000003
>RBP: 00007f2944bbac80 R08: 0000000000000000 R09: 0000000000000000
>R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2944bbad10
>R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
></TASK>
>
>The buggy address belongs to stack of task syz-executor105/5004
>and is located at offset 36 in frame:
>sk_ioctl+0x0/0x440 net/core/sock.c:4172
>
>This frame has 2 objects:
>[32, 36) 'karg'
>[48, 88) 'buffer'
>
>Fixes: e1d001fa5b47 ("net: ioctl: Use kernel memory on protocol ioctl callbacks")
>Reported-by: syzbot <syzkaller@googlegroups.com>
>Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

