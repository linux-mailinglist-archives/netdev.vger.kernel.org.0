Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D31652031D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiEIRGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239473AbiEIRGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:06:40 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B76B2817BB
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:02:44 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id l15so9738257ilh.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 10:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=tFM7xIQtCpOuioxyy6/Mgl+Oz5Ak50q4/dFV83odINU=;
        b=um0dIWhKN/iXCfaGm8+FEYxlBDrzeVkWflwBl3MZDAYiXO0mWKB3mReX2kAQXacZXV
         ek9euhHPQLReN+sXMA2O630UW13e330/zgAILeukScpL+tsfcs4h1ynpWWQIpk1J4VaS
         WqpvAdF5PHCEsun6NJxb2Met7nPnrQyCQMjBKD4fF/uFhoqBBDrOhPi9doIOHZuGT1GZ
         B7qrXMKDPCBTvmAczfP+G9oIxupKr+vrwAX9SMmpHrcTLONGLXcR/v/L3qA2XdZCsM4v
         6o18/Cbk4lERTRX5a/Ck6T9JoP8tltSGYwr26nH0DnGU1hIRHdm439Q9Fdxf9C+Z3/r3
         +sUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tFM7xIQtCpOuioxyy6/Mgl+Oz5Ak50q4/dFV83odINU=;
        b=P5dt6l/AxVONyk6Q9RjXGTiUG9zaK9xyw9R7XBehO7b0eB9U1Sdm1ulL1ZC0rg6Lm7
         WotXbvea7GTEON/h9nr0JhKUnDyJRDUdDtSuUewobnmURTTwfxwUYRUzzgsnlZSJqM3C
         BmeKU8IBp4DL+OLG8dYcFV40HeYAcAtSVnAHYyuuEJfmd0Ya8sX2UOAJOucfR+v5v1LF
         JjXgbsNZcZc6QX/XCHDTYkGrHBowL2qOw70MBVE2vagtNwuUfCZ5oU/BwQuYjMCBJqwD
         NiGz34jmErNyZrOCmGyi29kIIVZDRFE+I+SLPkaUOK2aXPihwJ9SmbzfMtskdpeEv3CL
         R6UA==
X-Gm-Message-State: AOAM532Yuyt2gA1j/EG/o/CIw0BqgVDJW56qHa12cHJDYn3FNrd0eHi0
        SbgK2qXOo75OjL6xfQIgxaUX8Q==
X-Google-Smtp-Source: ABdhPJwSWLRXskKUk/xSTtlslzuAA/xGA0C0JNmxOobr7l0+SCxm22xrVKrUcAaF6GnHI5NXVzi5IA==
X-Received: by 2002:a05:6e02:144c:b0:2cf:7a91:50da with SMTP id p12-20020a056e02144c00b002cf7a9150damr6727276ilo.123.1652115763443;
        Mon, 09 May 2022 10:02:43 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i13-20020a056e020ecd00b002cde6e352dfsm3333827ilk.41.2022.05.09.10.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 10:02:42 -0700 (PDT)
Message-ID: <a72282ef-650c-143b-4b88-5185009c3ec2@kernel.dk>
Date:   Mon, 9 May 2022 11:02:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] KASAN: use-after-free Read in bio_poll
Content-Language: en-US
To:     syzbot <syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <00000000000029572505de968021@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000029572505de968021@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 10:14 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c5eb0a61238d Linux 5.18-rc6
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=112bf03ef00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=79caa0035f59d385
> dashboard link: https://syzkaller.appspot.com/bug?extid=99938118dfd9e1b0741a
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12311571f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177a2e86f00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in bio_poll+0x275/0x3c0 block/blk-core.c:942
> Read of size 4 at addr ffff8880751d92b4 by task syz-executor486/3607
> 
> CPU: 0 PID: 3607 Comm: syz-executor486 Not tainted 5.18.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
>  print_report mm/kasan/report.c:429 [inline]
>  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
>  bio_poll+0x275/0x3c0 block/blk-core.c:942
>  __iomap_dio_rw+0x10ee/0x1ae0 fs/iomap/direct-io.c:658
>  iomap_dio_rw+0x38/0x90 fs/iomap/direct-io.c:681
>  ext4_dio_write_iter fs/ext4/file.c:566 [inline]
>  ext4_file_write_iter+0xe4d/0x1510 fs/ext4/file.c:677
>  call_write_iter include/linux/fs.h:2050 [inline]
>  do_iter_readv_writev+0x3d1/0x640 fs/read_write.c:726
>  do_iter_write+0x182/0x700 fs/read_write.c:852
>  vfs_writev+0x1aa/0x630 fs/read_write.c:925
>  do_pwritev+0x1b6/0x270 fs/read_write.c:1022
>  __do_sys_pwritev2 fs/read_write.c:1081 [inline]
>  __se_sys_pwritev2 fs/read_write.c:1072 [inline]
>  __x64_sys_pwritev2+0xeb/0x150 fs/read_write.c:1072
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f6846af7e69

Guys, should we just queue:

ommit 9650b453a3d4b1b8ed4ea8bcb9b40109608d1faf
Author: Ming Lei <ming.lei@redhat.com>
Date:   Wed Apr 20 22:31:10 2022 +0800

    block: ignore RWF_HIPRI hint for sync dio

up for 5.18 and stable?

-- 
Jens Axboe

