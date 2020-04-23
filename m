Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B006A1B52CC
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgDWC6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgDWC6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:58:06 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8453DC03C1AA;
        Wed, 22 Apr 2020 19:58:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f20so2137556pgl.12;
        Wed, 22 Apr 2020 19:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VWF0s91Rr6co0y2UjAXIZbDJkuO/rQAI79phGMELR4c=;
        b=igAUFSOlc9ohHgtjFBVAqIAuMf2+4wcTpBFbb/JBqtceU3+cyv0ygT+5RpJqDvsjmv
         /lKXagZTgiFPw82pgm2yPxpl1Cu5P2sNGaO30DnBGp/nzmDeepPjke/SzcbSzu9rMxC5
         IwECwZ6tc0OXM91W2kBYmA3P//bbr2PBUixKk+SLPq6HIayOkWhncuTgv2pcqzL4lOMn
         2tgAmdoEXawfw32oJwPPVuAOEqdNNEz68RKXCYjOmBAKdtm/9jZkUfY4vYg/t7P43zZC
         viOum1g3gSmt+WrbN0be6JSWXHFJn1JjCqrVVnbQFc+vYHmbC1knbK4D7h8M/L0sz4MV
         dt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWF0s91Rr6co0y2UjAXIZbDJkuO/rQAI79phGMELR4c=;
        b=AMRy3JoPUUruV7w8I9/jPIuGfZj0ldGyNpUp71DbWKoggz8I4JtlNzgML0JYn9Vgln
         BF8s8KAC5sFwZ5oDA3Nbg0pxCFDaF952lMcQpwZ1IAseucE2rpe4Poawj97BhNXQAmQN
         EV4oq9qY2SHVjX6hXtkJcF5PDLAU6gtFgK7AkZDoSXEM/T1C9jUkqiZw1vyoy4tnzQUB
         PneXjUPaUzbNqG16Yv2iWaFuk1QMgSYYcOkuTSAdikVlXp3FrjRPY3T/2sUs9G1SYOPh
         PdXjGPLJLPkhuBC9YnZQboozgt3slq7l6xcjtpWAMpLG1PgF9uW3t/75KsBKUK/drk5M
         uYxw==
X-Gm-Message-State: AGi0PuZGNbUPREoCn+Ngb+7qJv8qNy96EBpt00ZMCJRv0BSqD265KkWN
        Xgrnn+bBrNoqvmaURGVfuSQ=
X-Google-Smtp-Source: APiQypLsqdUj2HmFGBSYFZOIJtdfiTbqcJhIfmplE7r1Vxe8grqP3dvlrFoRqTQgCr0c7ISKSXQuDg==
X-Received: by 2002:aa7:8ec1:: with SMTP id b1mr1670385pfr.103.1587610685045;
        Wed, 22 Apr 2020 19:58:05 -0700 (PDT)
Received: from localhost (146.85.30.125.dy.iij4u.or.jp. [125.30.85.146])
        by smtp.gmail.com with ESMTPSA id i185sm948558pfg.14.2020.04.22.19.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 19:58:04 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Thu, 23 Apr 2020 11:58:02 +0900
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzbot <syzbot+1c36440b364ea3774701@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Network Development <netdev@vger.kernel.org>,
        James Chapman <jchapman@katalix.com>,
        Petr Mladek <pmladek@suse.com>
Subject: Re: WARNING: locking bug in tomoyo_supervisor
Message-ID: <20200423025802.GD246741@jagdpanzerIV.localdomain>
References: <000000000000a475ac05a36fa01e@google.com>
 <5b71a079-54bb-57a0-360d-33fce141504f@i-love.sakura.ne.jp>
 <20200423015008.GA246741@jagdpanzerIV.localdomain>
 <5e192ca2-3b24-0b45-fc13-51feec43c216@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e192ca2-3b24-0b45-fc13-51feec43c216@i-love.sakura.ne.jp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (20/04/23 10:57), Tetsuo Handa wrote:
> On 2020/04/23 10:50, Sergey Senozhatsky wrote:
> > On (20/04/17 13:37), Tetsuo Handa wrote:
> >> On 2020/04/17 7:05, syzbot wrote:
> >>> Hello,
> >>>
> >>> syzbot found the following crash on:
> >>>
> >>> HEAD commit:    4f8a3cc1 Merge tag 'x86-urgent-2020-04-12' of git://git.ke..
> >>> git tree:       upstream
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=1599027de00000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3bfbde87e8e65624
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=1c36440b364ea3774701
> >>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> >>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150733cde00000
> >>
> >> This seems to be a misattributed report explained at https://lkml.kernel.org/r/20190924140241.be77u2jne3melzte@pathway.suse.cz .
> >> Petr and Sergey, how is the progress of making printk() asynchronous? When can we expect that work to be merged?
> > 
> > I'd say that lockless logbuf probably will land sometime around 5.8+.
> > Async printk() - unknown.
> 
> I see. Thank you. I've just made a patch for
> 
>   A solution would be to store all these metadata (timestamp, caller
>   info) already into the per-CPU buffers. I think that it would be
>   doable.
> 
> part (shown below). Should I propose it? Or, should I just wait for lockless logbuf ?

I think this will be doable with a mix of the lockless buffer and per-CPU
printk context variable. We can store all printk data into the lockless
buffer, but need to avoid calling up()/down()/console_drivers() if per-CPU
printk context is non zero (the existinf printk_safe/printk_nmi enter/exit
functions will help). So I think waiting for lockless printk buffer would
be a better option, effort-wise.

	-ss
