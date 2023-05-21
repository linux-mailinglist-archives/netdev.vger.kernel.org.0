Return-Path: <netdev+bounces-4084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF86770AC01
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 04:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DD00281087
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 02:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74EEB80E;
	Sun, 21 May 2023 02:26:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674A77E9
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 02:26:34 +0000 (UTC)
Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [IPv6:2001:41d0:203:375::32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A34912A
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 19:26:33 -0700 (PDT)
Message-ID: <048219d7-2403-b898-129f-a0f85512cdf5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684635990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/ZpxMQ8Ylpc/R+35Ghc5qquHo+Bz5A9wc6kWaeW7Dg=;
	b=tFPhMscgu4nSy6Uu1xDdXqUdhAWEuc7/Dz4AVNeEENdJRCvKSCNHgt+79M+RPo2B/XaOY4
	vc6TaZgw9KNb/iDZP1167ajPfFzlOP2kZNpK2s9xPdDD/1IQvKT5Vcve7OlTRjYnbB/KCZ
	bae77+HcxYbrAQtnghIE2uHaPuh8vz8=
Date: Sat, 20 May 2023 19:26:22 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [syzbot] [fs?] INFO: task hung in synchronize_rcu (4)
Content-Language: en-US
To: syzbot <syzbot+222aa26d0a5dbc2e84fe@syzkaller.appspotmail.com>,
 syzkaller-bugs@googlegroups.com
References: <000000000000baea9905fc275a49@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
Cc: amir73il@gmail.com, bpf@vger.kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, edumazet@google.com, hdanton@sina.com, jack@suse.cz,
 kuba@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 penguin-kernel@i-love.sakura.ne.jp, peterz@infradead.org,
 torvalds@linux-foundation.org, willemdebruijn.kernel@gmail.com
In-Reply-To: <000000000000baea9905fc275a49@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/20/23 3:13 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    dcbe4ea1985d Merge branch '1GbE' of git://git.kernel.org/p..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=123ebd91280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f20b05fe035db814
> dashboard link: https://syzkaller.appspot.com/bug?extid=222aa26d0a5dbc2e84fe
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1495596a280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1529326a280000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/41b9dda0e686/disk-dcbe4ea1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/64d9bece8f89/vmlinux-dcbe4ea1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/42429896dca0/bzImage-dcbe4ea1.xz
> 
> The issue was bisected to:
> 
> commit 3b5d4ddf8fe1f60082513f94bae586ac80188a03
> Author: Martin KaFai Lau <kafai@fb.com>
> Date:   Wed Mar 9 09:04:50 2022 +0000
> 
>      bpf: net: Remove TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET macro

I am afraid this bisect is incorrect. The commit removed a redundant macro and 
is a no-op change.



