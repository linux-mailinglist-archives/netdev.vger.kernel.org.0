Return-Path: <netdev+bounces-4089-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA6970AC6F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 07:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE0541C209AD
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 05:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7042A3D;
	Sun, 21 May 2023 05:05:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA9AA29
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 05:05:14 +0000 (UTC)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1069A116;
	Sat, 20 May 2023 22:05:11 -0700 (PDT)
Received: from fsav412.sakura.ne.jp (fsav412.sakura.ne.jp [133.242.250.111])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 34L545Vo045924;
	Sun, 21 May 2023 14:04:05 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav412.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp);
 Sun, 21 May 2023 14:04:05 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 34L545uK045921
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 21 May 2023 14:04:05 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <680fe81d-6d33-ef0a-95d2-0bb79430019d@I-love.SAKURA.ne.jp>
Date: Sun, 21 May 2023 14:04:03 +0900
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [syzbot] [fs?] INFO: task hung in synchronize_rcu (4)
Content-Language: en-US
To: Martin KaFai Lau <martin.lau@linux.dev>,
        syzbot <syzbot+222aa26d0a5dbc2e84fe@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Cc: amir73il@gmail.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hdanton@sina.com,
        jack@suse.cz, kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, peterz@infradead.org, torvalds@linux-foundation.org,
        willemdebruijn.kernel@gmail.com
References: <000000000000baea9905fc275a49@google.com>
 <048219d7-2403-b898-129f-a0f85512cdf5@linux.dev>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <048219d7-2403-b898-129f-a0f85512cdf5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/05/21 11:26, Martin KaFai Lau wrote:
> On 5/20/23 3:13 PM, syzbot wrote:
>> syzbot has found a reproducer for the following issue on:
>>
>> HEAD commit:    dcbe4ea1985d Merge branch '1GbE' of git://git.kernel.org/p..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=123ebd91280000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f20b05fe035db814
>> dashboard link: https://syzkaller.appspot.com/bug?extid=222aa26d0a5dbc2e84fe
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1495596a280000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1529326a280000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/41b9dda0e686/disk-dcbe4ea1.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/64d9bece8f89/vmlinux-dcbe4ea1.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/42429896dca0/bzImage-dcbe4ea1.xz
>>
>> The issue was bisected to:
>>
>> commit 3b5d4ddf8fe1f60082513f94bae586ac80188a03
>> Author: Martin KaFai Lau <kafai@fb.com>
>> Date:   Wed Mar 9 09:04:50 2022 +0000
>>
>>      bpf: net: Remove TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET macro
> 
> I am afraid this bisect is incorrect. The commit removed a redundant macro and is a no-op change.
> 
> 

But the reproducer is heavily calling bpf() syscall.

void execute_call(int call)
{
  switch (call) {
  case 0:
    NONFAILING(*(uint32_t*)0x200027c0 = 3);
    NONFAILING(*(uint32_t*)0x200027c4 = 4);
    NONFAILING(*(uint32_t*)0x200027c8 = 4);
    NONFAILING(*(uint32_t*)0x200027cc = 0x10001);
    NONFAILING(*(uint32_t*)0x200027d0 = 0);
    NONFAILING(*(uint32_t*)0x200027d4 = -1);
    NONFAILING(*(uint32_t*)0x200027d8 = 0);
    NONFAILING(memset((void*)0x200027dc, 0, 16));
    NONFAILING(*(uint32_t*)0x200027ec = 0);
    NONFAILING(*(uint32_t*)0x200027f0 = -1);
    NONFAILING(*(uint32_t*)0x200027f4 = 0);
    NONFAILING(*(uint32_t*)0x200027f8 = 0);
    NONFAILING(*(uint32_t*)0x200027fc = 0);
    NONFAILING(*(uint64_t*)0x20002800 = 0);
    syscall(__NR_bpf, 0ul, 0x200027c0ul, 0x48ul);
    break;
  }
}

Something caused infinite loop or too heavy stress to survive?
The first report was 7d31677bb7b1.
Rechecking or running the reproducer on commits shown by
"git log 7d31677bb7b1 net/bpf" might help.



