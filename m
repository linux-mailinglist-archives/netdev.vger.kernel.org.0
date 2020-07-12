Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4DC21CB23
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 21:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgGLTdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 15:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbgGLTdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 15:33:49 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEB6C061794;
        Sun, 12 Jul 2020 12:33:48 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e22so9722062edq.8;
        Sun, 12 Jul 2020 12:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gv/WG+Y46HcwRViY5lcbCAyUv1mNyptIBBZZW/zIaGc=;
        b=bVSGfO6m+q73NGCLPhJEO75lf7TjyKm1VeIGJMZga8xWw3Yd3UFn1tevI/M6T2aAwc
         S0Bn9soD6wkGIhvwO1824HZjl0HttlVf6IqZbPoq0n/sgLmYG/Yq1pFUctcyeV7P4/kA
         8govMo8DIgVlpoHMRJT0NJycxdj/ETKVSM58Ym5AXqHaCJy+nQyxKbfs6qnEEXDOaO/b
         N1qCenjYu+7aFQS7nyex28PXWhMtrGyXCfzCqpoMaDKjW3RkJU0iH1kicPkeDuszApW7
         /cErMcROlgl4+B1RjgpkCCAkGvoACmLuwmEZpEOxyiPWsCTvVjBJfhOwq9yoIZeUfVdL
         2NZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gv/WG+Y46HcwRViY5lcbCAyUv1mNyptIBBZZW/zIaGc=;
        b=HaSYEdTUUwcvpQb43a2s5OrLvtn51DCuoyj2T9uyXN3N+vbvCPNI89sVoWoZVxLpyl
         vo9YgcReV+hE+cu7qKeq4cph7WU/LOt8kU//shVipSD2ilUiWdVXD09XiEf08ppOkpXF
         /DFmz78p2a4dieXfJrYsvJQFYx3QkGyoaENzCoebN78C19cJ5iGbd2mFAv1VYbN7M7Vi
         jY3Tjr6j3rdhZjJT+sqelmshJ9kZGTmf5sejieE2HaQyxuCLXc0qYcwNkJ3VxfiQxpuh
         M+hBgV13xqDOTOXiDaV+dh7qFIGZC9OUSITDpM5k2hRX4FzgRubq6hZkmwg90gBVpBI0
         jOaQ==
X-Gm-Message-State: AOAM532WM/V+Sjo+Qy3MLNGRQLgkVGNZeogCrf77ol5VezoHcoKf/C+w
        CcqDwKsweNuMKs0DMlXhaBU=
X-Google-Smtp-Source: ABdhPJwrZRMFAdKMEpLYS5y2zYhuufB7OBGT5jztOt3rXk4ejL6HNsgcy24K+EKzNYMXI28zL37eVw==
X-Received: by 2002:a50:8f83:: with SMTP id y3mr46327793edy.257.1594582427414;
        Sun, 12 Jul 2020 12:33:47 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id p4sm8273886eji.123.2020.07.12.12.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 12:33:46 -0700 (PDT)
Date:   Sun, 12 Jul 2020 22:33:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200712193344.bgd5vpftaikwcptq@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200711120842.2631-1-sorganov@gmail.com>
 <20200711231937.wu2zrm5spn7a6u2o@skbuf>
 <87wo387r8n.fsf@osv.gnss.ru>
 <20200712150151.55jttxaf4emgqcpc@skbuf>
 <87r1tg7ib9.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1tg7ib9.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 08:29:46PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > As far as I understand. the reason why SKBTX_IN_PROGRESS exists is for
> > skb_tx_timestamp() to only provide a software timestamp if the hardware
> > timestamping isn't going to. So hardware timestamping logic must signal
> > its intention. With SO_TIMESTAMPING, this should not be strictly
> > necessary, as this UAPI supports multiple sources of timestamping
> > (including software and hardware together),
> 
> As a side note, I tried, but didn't find a way to get 2 timestamps,
> software and hardware, for the same packet. It looks like once upon a
> time it was indeed supported by:
> 
> SOF_TIMESTAMPING_SYS_HARDWARE: This option is deprecated and ignored.
> 

With SO_TIMESTAMPING, it is supported through
SOF_TIMESTAMPING_OPT_TX_SWHW.
With APIs pre-SO_TIMESTAMPING (such as SO_TIMESTAMPNS), my understanding
is that it is not supported. One timestamp would overwrite the other. So
this needs to be avoided somehow, and this is how SKBTX_IN_PROGRESS came
to be.

> > but I think
> > SKBTX_IN_PROGRESS predates this UAPI and timestamping should continue to
> > work with older socket options.
> 
> <rant>The UAPI to all this is rather messy, starting with ugly tricks to
> convert PTP file descriptors to clock IDs, followed by strange ways to
> figure correct PTP clock for given Ethernet interface, followed by
> entirely different methods of getting time stamping capabilities and
> configuring them, and so forth.</rant>
> 

Yes, but I don't think this really matters in any way here.

> >
> > Now, out of the 2 mainline DSA drivers, 1 of them isn't setting
> > SKBTX_IN_PROGRESS, and that is mv88e6xxx. So mv88e6xxx isn't triggerring
> > this bug. I'm not sure why it isn't setting the flag. It might very well
> > be that the author of the patch had a board with a FEC DSA master, and
> > setting this flag made bad things happen, so he just left it unset.
> > Doesn't really matter.
> > But sja1105 is setting the flag:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/sja1105/sja1105_ptp.c#n890
> >
> > So, at the very least, you are fixing PTP on DSA setups with FEC as
> > master and sja1105 as switch. Boards like that do exist.
> 
> I'll do as you suggest, but I want to say that I didn't question your
> claim that my proposed changes may fix some existing PTP/DSA setup.
> 
> What I still find doubtful is that this fact necessarily means that the
> part of the patch that fixes some other bug must be submitted
> separately. If it were the rule, almost no patch that needs to fix 2
> separate places would be accepted, as there might be some bug somewhere
> that could be fixed by 1 change, no?
> 

So, I am asking you to flag this as a separate bugfix for DSA
timestamping for multiple reasons:

- because you are not "fixing PHY timestamping", more on that separately
- because I am looking at this problem from the perspective of a user
  who has a problem with DSA timestamping (aka code that already exists,
  and that is already claimed to work). They're going to be searching
  through the git log for potentially relevant changes, and even if they
  might notice a patch that "adds support for PHY timestamping in FEC"*,
  it might not register as something relevant to them, and skip it.
  Just as you don't care about DSA, neither does that hypothetical user
  care about PHY timestamping.



According to its design principles, DSA TX timestamping is supposed to
"just work". The FEC driver should have been DSA-ready from day one,
however it wasn't. In fact, subtle requirements from the MAC driver,
such as not indulging in solipsism (like gianfar, fec and probably many
more other drivers, in more subtle ways **), were unobvious enough to
the designers of DSA timestamping that they didn't, probably, even see
this coming.

Look, if the argument you're trying to make is that you should be using
this tag instead:

Fixes: 90af1059c52c ("net: dsa: forward timestamping callbacks to switch drivers")

since what gianfar/fec/etc were doing was not illegal as part of the
rules "back then", then I won't oppose that.



And according to the design principles of PHY TX timestamping, that is
not supposed to "just work" unless there is MAC driver collaboration.
That collaboration is _obviously_ not there for FEC, you don't even need
to open one kernel source code file to see that, just run a simple
command from user space, see below.

> In this particular case, you just happen to identify such a bug
> immediately, but I, as patch submitter, should not be expected to check
> all the kernel for other possible bugs that my changes may happen to
> fix, no?
> 

Well, ideally you would, it gives reviewers and readers confidence that
you understand the changes you are making. Some time in the future, when
you're no longer going to be reachable for questions, the commit still
needs to speak for itself.

> It seems like I misunderstand something very basic and that bothers me.
> 

Yes, but I can't seem to pinpoint what that is...
I _think_ the problem seems to be that you're not differentiating your
point of view from the mainline kernel's point of view.

> >
> >> In case you insist they are to be separate, I do keep the split version
> >> in my git tree, but to finish it that way, I'd like to clarify a few
> >> details:
> >> 
> >> 1. Should it be patch series with 2 commits, or 2 entirely separate
> >> patches?
> >> 
> >
> > Entirely separate.
> 
> OK, will do a separate patch, as you suggest.
> 
> [...]
> 
> >
> >> 3. If entirely separate patches, should I somehow refer to SKBTX patch in
> >> ioctl() one (and/or vice versa), to make it explicit they are
> >> (inter)dependent? 
> >> 
> >
> > Nope. The PHY timestamping support will go to David's net-next, this
> > common PHY/DSA bugfix to net, and they'll meet sooner rather than
> > later.
> 
> I'll do as you suggest, separating the patches, yet I fail to see why
> PHY /time stamping bug fix/ should go to another tree than PHY/DSA /time
> stamping bug fix/? What's the essential difference? Could you please
> clarify?
> 

The essential difference is that for PHY timestamping, there is no
feature that is claimed to work which doesn't work.

If you run "ethtool -T eth0" on a FEC network interface, it will always
report its own PHC, and never the PHC of a PHY. So, you cannot claim
that you are fixing PHY timestamping, since PHY timestamping is not
advertised. That's not what a bug fix is, at least not around here, with
its associated backporting efforts.

The only way you could have claimed that this was fixing PHY
timestamping was if "ethtool -T eth0" was reporting a PHY PHC, however
timestamps were not coming from the PHY.
From the perspective of the mainline kernel, that can never happen.
From your perspective as a developer, in your private work tree, where
_you_ added the necessary wiring for PHY timestamping, I fully
understand that this is exactly what happened _to_you_.
I am not saying that PHY timestamping doesn't need this issue fixed. It
does, and if it weren't for DSA, it would have simply been a "new
feature", and it would have been ok to have everything in the same patch.

The fact that you figured out so quickly what's going on just means
you're very smart. It took me 2 months to find out the same bug coming
from the DSA side of things.

> Thanks,
> -- Sergey

* That was my first complaint about your patch. You've changed that
  since, and your new commit is odd because it's now adding a new
  feature in a bug fix, therefore for a totally different reason.

** After I fixed gianfar, I did grep for other drivers that might be
   suffering from the same issue. The FEC driver did *not* strike me as
   obviously broken, and I was *specifically* searching for this bug
   pattern.

Thanks,
-Vladimir
