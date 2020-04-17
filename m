Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE911ADE57
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 15:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbgDQNbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 09:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730370AbgDQNbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 09:31:16 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB8CC061A0C;
        Fri, 17 Apr 2020 06:31:15 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x2so1923346qtr.0;
        Fri, 17 Apr 2020 06:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zD2hyP2njzf+JLR/yZbIZJx3UrjGaarac4VvkjGYRc4=;
        b=VLOJMmy8eo8EAhdxUSFSAMthHxQawRfo3+C4UinpMBJUHaUlvTpWeCnwIY570qHaEK
         2vucuaJJ5tQ6vBVCxJBhAvJbh8U+we7Nk4XxV0wRR0TQYnj0PMZsf/3gfCEcq30Ir9Fm
         PWoTWB2OhRhqrTFzacIiXGSsS0KMHQsaVkB1aFVA/V0t7S6ZKNWtymBYjIvHIsF4IPLv
         sJPT0kZ75QrW2BDdWp255kkDqr0uCwpxdnAaI+WvupnDRh70+LQEXny43WdW07KlPmL7
         zgQvPHr8z00UOEvq4V5M/3/g/BU7lOXPVaGLr7eMWXlb9YT3Fdbuv1FjokwkKlOuhlNU
         zq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zD2hyP2njzf+JLR/yZbIZJx3UrjGaarac4VvkjGYRc4=;
        b=onErySaZ2DVnuGJqZToezct7LS+U/2XYCT9/0gFM20FZSgzZ8kjj76w/H5k3FnI/a4
         UM6zWh98ismHz+GEWtVpZdFQmoSzpbyFHrc14STFKWPTW7VOXuRgPkvVWYSTgAcZ6myb
         3SsgbsWEcnUWdIcYpMZ6XgCO5P/eo8SlQIoSfebCb1Z+qaiRVrNXwQFGCLRZ4ub5H/0G
         x+j6VYYOmJ6JQPD/j6oePrVtYNf491R26DXpjLXZfM8VD5mAOz6CRZYIp3oHUq3Cdfts
         3P4fIQfDJ5YIQLRGbAv+7zjtFzQY0+T/gPEfpFx+2BaRvy+5IsTuMUplIJy3pAbOpqXK
         vEDw==
X-Gm-Message-State: AGi0PuboDGsql90kd0Ls1xmREUP/vBWuUjH7P6J3smLJJ9Wcz2WFtvee
        Yg32Exz36TunBNZr41DYhZ4=
X-Google-Smtp-Source: APiQypKqAHB+sGS71RtZpy0uC4grvuK0SP47TXWEUYmVYPe9gcet7gJ5BGeuBnDhUXawC8b03B0vjg==
X-Received: by 2002:ac8:1e91:: with SMTP id c17mr2976062qtm.237.1587130274102;
        Fri, 17 Apr 2020 06:31:14 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.229])
        by smtp.gmail.com with ESMTPSA id m11sm16530411qkg.130.2020.04.17.06.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 06:31:13 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C2EB3C163C; Fri, 17 Apr 2020 10:31:10 -0300 (-03)
Date:   Fri, 17 Apr 2020 10:31:10 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+96e916d6f6f7617bc9fc@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Subject: Re: memory leak in sctp_stream_init_ext (2)
Message-ID: <20200417133110.GA2688@localhost.localdomain>
References: <0000000000004373bc05a37460df@google.com>
 <20200417083224.13400-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417083224.13400-1-hdanton@sina.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 04:32:24PM +0800, Hillf Danton wrote:
> 
> On Thu, 16 Apr 2020 20:45:10 -0700
> > syzbot found the following crash on:
> > 
> > HEAD commit:    00086336 Merge tag 'efi-urgent-2020-04-15' of git://git.ke..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12996107e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=efff978b972fb2c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=96e916d6f6f7617bc9fc
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137ddf3fe00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+96e916d6f6f7617bc9fc@syzkaller.appspotmail.com
> > 
> > BUG: memory leak
> > unreferenced object 0xffff888103ba4580 (size 96):
> >   comm "syz-executor.1", pid 8335, jiffies 4294953411 (age 14.410s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000b06f3e80>] kmalloc include/linux/slab.h:555 [inline]
> >     [<00000000b06f3e80>] kzalloc include/linux/slab.h:669 [inline]
> >     [<00000000b06f3e80>] sctp_stream_init_ext+0x28/0xe0 net/sctp/stream.c:162
> >     [<00000000aff2ecba>] sctp_sendmsg_to_asoc+0x9af/0xab0 net/sctp/socket.c:1811
> >     [<00000000d5d5eb76>] sctp_sendmsg+0x2a6/0xc60 net/sctp/socket.c:2031
> >     [<0000000023cdbfa3>] inet_sendmsg+0x39/0x60 net/ipv4/af_inet.c:807
> >     [<00000000885878ef>] sock_sendmsg_nosec net/socket.c:652 [inline]
> >     [<00000000885878ef>] sock_sendmsg+0x4c/0x60 net/socket.c:672
> >     [<0000000009d727e5>] __sys_sendto+0x11d/0x1c0 net/socket.c:2000
> >     [<0000000066974477>] __do_sys_sendto net/socket.c:2012 [inline]
> >     [<0000000066974477>] __se_sys_sendto net/socket.c:2008 [inline]
> >     [<0000000066974477>] __x64_sys_sendto+0x26/0x30 net/socket.c:2008
> >     [<00000000ecc1fea9>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
> >     [<00000000605d798b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Release ext in case of failure of initializing stream.
> 
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -145,9 +145,10 @@ in:
>  	ret = sctp_stream_alloc_in(stream, incnt, gfp);
>  	if (ret) {

Are you working on the right code? Seems you're missing
61d5d4062876 ("sctp: fix err handling of stream initialization")

Anyhow, the patch intention looks right.

>  		sched->free(stream);
> +		for (i = 0; i < stream->outcnt; i++)
> +			kfree(SCTP_SO(stream, i)->ext);
>  		genradix_free(&stream->out);
>  		stream->outcnt = 0;
> -		goto out;
>  	}
>  
>  out:
> 
