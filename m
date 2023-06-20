Return-Path: <netdev+bounces-12119-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5E57363E4
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32FE4280ED6
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625DC1FDC;
	Tue, 20 Jun 2023 06:58:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562691119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:58:19 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163EB10D5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:58:17 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-970028cfb6cso691870066b.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1687244295; x=1689836295;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qsg1aMwRSR6OWjKsFQc+68svUmsIsZYDttCWRH+vV+0=;
        b=tZlgBsAyJ4QkOw8WAi/eBI+kdb1yD/LfSTYi52Y0hR6l8G88LrFkRKtOYPRZ5iolag
         TQ3g+hPncFWE7QfkW5dObieO05NrRcxUuTTYgXoWbwfbOsksngwX7H2KMym8rpr6pDXT
         UnF3wEMImwLB8zmWx+CS9aSx6yxOtjT+/Lv1yPcHaaENOXkXeQDpzlWOoOX0ob6BjB5a
         s3UJjZgOfrftLFO0vmfvgF1ToWHcB1TOTeUa2T2AEFBfvqEXOksEpHGO2YL+ttJ4+smQ
         P90NOoxFZWNrZlA333rF6KO2hPj0CQMXeNXeCqYu6E8PDCYF64bAU8/V0WeEAzVnvaWA
         rg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687244295; x=1689836295;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qsg1aMwRSR6OWjKsFQc+68svUmsIsZYDttCWRH+vV+0=;
        b=L2vtCIKVylUEVsVxYXh7rnAnFB1TvNi3GhVIkKTCJTdEDOjuxRmp4AYLZ2MWneyjk5
         7LJyKaJ5+Um+rTy1upc2V+IdJJwhTPC3JU7+thuEpbw/IltToaGG8YBhPOttJsVuxXD3
         3ceGkJNmx8Igz1cvS4fOs4SXSWL0S10g+7BPmuSHKlsWWAOCHG1dTKQBc0/jjXZIIucq
         NUz0wbfaI/1d6+/v3UO3sWt33YpWvoIV8PX6JObQMnv9I2+zMBG95g8sLm4rD0Shs7MQ
         F0BEsOOoRAXJ8uk+adCUxPHyl4iR4SBjFqi40z7ji1p3vQorw/JcPypKcuaCx32vOVUi
         GHoQ==
X-Gm-Message-State: AC+VfDyPixURYNP8vYsWXpG9EDkmSzglEyWnvwNBRyCYMTRv8UDVb8MR
	aSSNnTyULDmlWTTqrqabuW9dTA==
X-Google-Smtp-Source: ACHHUZ41CO3jiQr/UcTuBZa65LXKBRbGPom73ixs6GgVMuu3YRL6EUFKDyHPeKcQSXRSmkLDL5EFfw==
X-Received: by 2002:a17:907:360e:b0:96a:4ea0:a1e7 with SMTP id bk14-20020a170907360e00b0096a4ea0a1e7mr11238956ejc.50.1687244295455;
        Mon, 19 Jun 2023 23:58:15 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g15-20020a17090613cf00b009885462a644sm775753ejc.215.2023.06.19.23.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 23:58:14 -0700 (PDT)
Date: Tue, 20 Jun 2023 08:58:13 +0200
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
Message-ID: <ZJFOBZ6Rf529rl2i@nanopsycho>
References: <20230619124336.651528-1-edumazet@google.com>
 <ZJBxrWmScxYvcDGv@nanopsycho>
 <CANn89iL5Mjfs7orwjn+H5P6sqyeAguXkKsAj_svrkMZPNWOrbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iL5Mjfs7orwjn+H5P6sqyeAguXkKsAj_svrkMZPNWOrbA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, Jun 19, 2023 at 07:31:35PM CEST, edumazet@google.com wrote:
>On Mon, Jun 19, 2023 at 5:18 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Mon, Jun 19, 2023 at 02:43:35PM CEST, edumazet@google.com wrote:
>> >Blamed commit added these helpers for sake of detecting RAW
>> >sockets specific ioctl.
>> >
>> >syzbot complained about it [1].
>> >
>> >Issue here is that RAW sockets could pretend there was no need
>> >to call ipmr_sk_ioctl()
>> >
>> >Regardless of inet_sk(sk)->inet_num, we must be prepared
>> >for ipmr_ioctl() being called later. This must happen
>> >from ipmr_sk_ioctl() context only.
>> >
>> >We could add a safety check in ipmr_ioctl() at the risk of breaking
>> >applications.
>> >
>> >Instead, remove sk_is_ipmr() and sk_is_icmpv6() because their
>> >name would be misleading, once we change their implementation.
>>
>> Hurts my fingers to write this, but it would be easier to follow the
>> patch description and actually undestand what you do with imperative
>> mood commanding the codebase, without the "we"nesses. But again,
>> nevermind :)
>
>It is not the first time you comment on the style of my changelogs.

It is the first time. I did my best to not to do that in your case :)


>
>I would prefer we spend time elsewhere, we obviously have different
>ways of writing in English.

This is not about "ways of writing in English". This is about making
obvious to the reader what you do in the patch. So eventually it saves
time of the reader/reviewer and also submitter who does not need to
explain possible uncertainties.
Citing from Documentation/process/submitting-patches.rst:

"Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
 instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
 to do frotz", as if you are giving orders to the codebase to change
 its behaviour."


>
>Just my two cents.
>
>
>
>>
>>
>> >
>> >[1]
>> >BUG: KASAN: stack-out-of-bounds in ipmr_ioctl+0xb12/0xbd0 net/ipv4/ipmr.c:1654
>> >Read of size 4 at addr ffffc90003aefae4 by task syz-executor105/5004
>> >
>> >CPU: 0 PID: 5004 Comm: syz-executor105 Not tainted 6.4.0-rc6-syzkaller-01304-gc08afcdcf952 #0
>> >Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
>> >Call Trace:
>> ><TASK>
>> >__dump_stack lib/dump_stack.c:88 [inline]
>> >dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>> >print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
>> >print_report mm/kasan/report.c:462 [inline]
>> >kasan_report+0x11c/0x130 mm/kasan/report.c:572
>> >ipmr_ioctl+0xb12/0xbd0 net/ipv4/ipmr.c:1654
>> >raw_ioctl+0x4e/0x1e0 net/ipv4/raw.c:881
>> >sock_ioctl_out net/core/sock.c:4186 [inline]
>> >sk_ioctl+0x151/0x440 net/core/sock.c:4214
>> >inet_ioctl+0x18c/0x380 net/ipv4/af_inet.c:1001
>> >sock_do_ioctl+0xcc/0x230 net/socket.c:1189
>> >sock_ioctl+0x1f8/0x680 net/socket.c:1306
>> >vfs_ioctl fs/ioctl.c:51 [inline]
>> >__do_sys_ioctl fs/ioctl.c:870 [inline]
>> >__se_sys_ioctl fs/ioctl.c:856 [inline]
>> >__x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
>> >do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>> >do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>> >entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> >RIP: 0033:0x7f2944bf6ad9
>> >Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>> >RSP: 002b:00007ffd8897a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> >RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2944bf6ad9
>> >RDX: 0000000000000000 RSI: 00000000000089e1 RDI: 0000000000000003
>> >RBP: 00007f2944bbac80 R08: 0000000000000000 R09: 0000000000000000
>> >R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2944bbad10
>> >R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>> ></TASK>
>> >
>> >The buggy address belongs to stack of task syz-executor105/5004
>> >and is located at offset 36 in frame:
>> >sk_ioctl+0x0/0x440 net/core/sock.c:4172
>> >
>> >This frame has 2 objects:
>> >[32, 36) 'karg'
>> >[48, 88) 'buffer'
>> >
>> >Fixes: e1d001fa5b47 ("net: ioctl: Use kernel memory on protocol ioctl callbacks")
>> >Reported-by: syzbot <syzkaller@googlegroups.com>
>> >Signed-off-by: Eric Dumazet <edumazet@google.com>
>>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

