Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1030AD175
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 03:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbfIIBKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 21:10:24 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40776 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731574AbfIIBKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 21:10:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id x127so8083376pfb.7;
        Sun, 08 Sep 2019 18:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OIovLqZ8dndVfgy4bS5bku+Skn01UN36L7YbEWe4yhw=;
        b=lbxLDfcLHoEKq7QwulF8CGpwNbxQWZEmLCfz/9fdnClPG6kBHrUkUA87vaBr5UNBdS
         b+8jWVpHZ1drk30QaPgcvQNO7LtwRn5uadC72pzEBiJUIx+X1tBFQ1XlQiayEsqRe74w
         jCTab/fObzBXTYSVNx0DlDtckQzubsesiDGy+Oa//B0aXtJpRFB0snA1tjOKNeLySXaU
         BF70FBEwh04yA41fAXtr79jeOqocLTWCq1Z5V0wZjZxxYO6/hs0YIF95wGFS1rYroFet
         uhz1gSTV5eIHjp/f1WeABeVgz7DPHh4Fw42QOcIfDeWzqrOeiphZrfuzwIHu1MtBJzVi
         zRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OIovLqZ8dndVfgy4bS5bku+Skn01UN36L7YbEWe4yhw=;
        b=K/ySBpEcozLgTFtmFnh5pJgoN3m+4q8dzl6f7befz7+v6RLUofAlvr4PwKX3Ov7P5j
         IJOHDvJQj6ci6mKfeA9bG42lMpnixnzRFWhFyJXTY5rHQRur6XMB4dWRAj9mQr8YPFzz
         bhBTwrIj4z834O8iyzSAr/tJuI8RgVmB8o6a8/8WInoLLu5L/233PBoVVYVe62ojp240
         2hfXkOIsdzmzBPPp1G90vcvqVvWKxsidSwbDGSMwGEU8FIKcREebu1rMnDpaPpXyuP7N
         bcj4qTP0q2Ez9EyQ3fLpsviBn/9a2Wk85DzYJ0rnepTIDZC1OIbce83tquqdxhbsKUQk
         2Ibg==
X-Gm-Message-State: APjAAAWhksrILsaY4Rppp1lzvY1m3fllZNcWsOE1nBDF+HYqDXaa/ykc
        WCYKXoOGPgjyrvIFxrz58Bs=
X-Google-Smtp-Source: APXvYqzYZOL2H+AO47roS6quUoNyMxcsV/gsDZ5uGmZvAcUnt1tQhmDYovzK8DvnQqwgXxNF0LA8bQ==
X-Received: by 2002:a63:1020:: with SMTP id f32mr19739610pgl.203.1567991423070;
        Sun, 08 Sep 2019 18:10:23 -0700 (PDT)
Received: from localhost ([110.70.15.13])
        by smtp.gmail.com with ESMTPSA id v43sm24235493pjb.1.2019.09.08.18.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2019 18:10:22 -0700 (PDT)
Date:   Mon, 9 Sep 2019 10:10:18 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, davem@davemloft.net,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        Qian Cai <cai@lca.pw>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190909011018.GB816@jagdpanzerIV>
References: <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <20190905132334.52b13d95@oasis.local.home>
 <20190906033900.GB1253@jagdpanzerIV>
 <20190906153209.ugkeuaespn2q5yix@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906153209.ugkeuaespn2q5yix@pathway.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/06/19 17:32), Petr Mladek wrote:
> > [..]
> > > I mean, really, do we need to keep calling wake up if it
> > > probably never even executed?
> > 
> > I guess ratelimiting you are talking about ("if it probably never even
> > executed") would be to check if we have already called wake up on the
> > log_wait ->head. For that we need to, at least, take log_wait spin_lock
> > and check that ->head is still in TASK_INTERRUPTIBLE; which is (quite,
> > but not exactly) close to what wake_up_interruptible() does - it doesn't
> > wake up the same task twice, it bails out on `p->state & state' check.
> 
> I have just realized that only sleeping tasks are in the waitqueue.
> It is already handled by waitqueue_active() check.

Yes.

> I am afraid that we could not ratelimit the wakeups. The userspace
> loggers might then miss the last lines for a long.

That's my concern as well.

> We could move wake_up_klogd() back to console_unlock(). But it might
> end up with a back-and-forth games according to who is currently
> complaining.

We still don't need irq_work, tho.

If we can do
	printk()->console_unlock()->up()->try_to_wake_up()
then we can also do
	printk()           ->             try_to_wake_up()

It's LOGLEVEL_SCHED which tells us if we can try_to_wake_up()
or cannot.

> Sigh, I still suggest to ratelimit the warning about failed
> allocation.

Hard to imagine how many printk()-s we will have to ratelimit.
To imagine NET maintainers being OK with this is even harder.

	-ss
