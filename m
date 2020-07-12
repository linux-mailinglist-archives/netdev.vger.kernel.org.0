Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408EE21CBE2
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGLWcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGLWcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:32:13 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071E4C061794;
        Sun, 12 Jul 2020 15:32:12 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id c11so6975573lfh.8;
        Sun, 12 Jul 2020 15:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=hJ7YYatv7XFtmk6h2N6lfH8IMWrBAYsuzgWcKqB5bII=;
        b=GC/HgKCnAEcpbfOmQIsVsYFn+1RF6/fz2ZllKOqnE6lLJUNLkecWD+cHYDfHM/6DCY
         wjs8nEAI+0dm3RL2YwCWTeltX8u8i5oD8fwCJDSZ0RSwqzV7smr58bVvIyBFktvvn2OY
         KOvIlZzrgq2ggG8s4sbWfu5W13yJ7h0EiM8lLbO5+ggBCVZfdxxACeP8MucgaFWNGxYj
         wVzf4TVRloc4EZ3hGne5e5pcv6qBC61jTDjvyJUzVXfEMbB/BXD6PFYUiz4Q3KG2SXqC
         WlhPFLdOdFhRvXcx8o0S4dxoHj6gDZrExcoxrn79O7yROMifAvz06I3H1jxkniiIRrUn
         grcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=hJ7YYatv7XFtmk6h2N6lfH8IMWrBAYsuzgWcKqB5bII=;
        b=qQru4O1PpYWwwKW4D+7CPgHbjWoFEmX4sWFYeUqdt17+7jMfKIADU0RNbvJe5yN4Yw
         N2fhIobRnxGkvImdkVscAc8ecglW8eY8WkLVjJ0Ujp7uUl77yBckREjk2Q4Y7Uyj0qOF
         RN2/pUqXnLHxv4S/AJbQBVtYvzaq5Ls8W3ViwTdXY93QSNMSZHOorpM/UfCrBrtw9vnt
         8rHtBbZ3a7Z1V5aTM+mrHhAlwWV1krlYeVUfjIBcU4HzREJhWU/MH8tqt1MptYSWcOV4
         +kakMBeyJytAkHz06UWTFcgw/LTZ8XyeTbEytIJhZ/LcvH/JjK/jhmqgIIxsp34nro95
         /NEA==
X-Gm-Message-State: AOAM530ppq21MreZhqGFawlLu4BzF+NdZzGCjAInR0IVaDWNjcwSUkc/
        4WYyjTuunAZvGYRZivNXtbo=
X-Google-Smtp-Source: ABdhPJzdxlKNI5NofCaDkiYdgOYRVCI9JO8J7QiGrIc1m+bvGfiuMcZyZJXdFywDZOuVrl91zt4+Xw==
X-Received: by 2002:a19:691c:: with SMTP id e28mr51350167lfc.131.1594593131300;
        Sun, 12 Jul 2020 15:32:11 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id f4sm4221041lfh.38.2020.07.12.15.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 15:32:10 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200711120842.2631-1-sorganov@gmail.com>
        <20200711231937.wu2zrm5spn7a6u2o@skbuf> <87wo387r8n.fsf@osv.gnss.ru>
        <20200712150151.55jttxaf4emgqcpc@skbuf> <87r1tg7ib9.fsf@osv.gnss.ru>
        <20200712193344.bgd5vpftaikwcptq@skbuf>
Date:   Mon, 13 Jul 2020 01:32:09 +0300
In-Reply-To: <20200712193344.bgd5vpftaikwcptq@skbuf> (Vladimir Oltean's
        message of "Sun, 12 Jul 2020 22:33:44 +0300")
Message-ID: <87365wgyae.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Sun, Jul 12, 2020 at 08:29:46PM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>> 
>> > As far as I understand. the reason why SKBTX_IN_PROGRESS exists is for
>> > skb_tx_timestamp() to only provide a software timestamp if the hardware
>> > timestamping isn't going to. So hardware timestamping logic must signal
>> > its intention. With SO_TIMESTAMPING, this should not be strictly
>> > necessary, as this UAPI supports multiple sources of timestamping
>> > (including software and hardware together),
>> 
>> As a side note, I tried, but didn't find a way to get 2 timestamps,
>> software and hardware, for the same packet. It looks like once upon a
>> time it was indeed supported by:
>> 
>> SOF_TIMESTAMPING_SYS_HARDWARE: This option is deprecated and ignored.
>> 
>
> With SO_TIMESTAMPING, it is supported through
> SOF_TIMESTAMPING_OPT_TX_SWHW.

This one I overlooked, -- thanks for pointing!

> With APIs pre-SO_TIMESTAMPING (such as SO_TIMESTAMPNS), my understanding
> is that it is not supported. One timestamp would overwrite the other. So
> this needs to be avoided somehow, and this is how SKBTX_IN_PROGRESS came
> to be.
>
>
>> > but I think
>> > SKBTX_IN_PROGRESS predates this UAPI and timestamping should continue to
>> > work with older socket options.
>> 
>> <rant>The UAPI to all this is rather messy, starting with ugly tricks to
>> convert PTP file descriptors to clock IDs, followed by strange ways to
>> figure correct PTP clock for given Ethernet interface, followed by
>> entirely different methods of getting time stamping capabilities and
>> configuring them, and so forth.</rant>
>> 
>
> Yes, but I don't think this really matters in any way here.

Surprisingly it does, as you've got a wrong premise that ethtool doesn't
support external PTP PHY on FEC. And I think it's due to complexities of
the current implementation, where ethtool has entirely separate path of
doing things, with zero help from the FEC driver, see below.

[...]

>> I'll do as you suggest, but I want to say that I didn't question your
>> claim that my proposed changes may fix some existing PTP/DSA setup.
>> 
>> What I still find doubtful is that this fact necessarily means that the
>> part of the patch that fixes some other bug must be submitted
>> separately. If it were the rule, almost no patch that needs to fix 2
>> separate places would be accepted, as there might be some bug somewhere
>> that could be fixed by 1 change, no?
>> 
>
> So, I am asking you to flag this as a separate bugfix for DSA
> timestamping for multiple reasons:

OK, you want it, I'll do it, however:

>
> - because you are not "fixing PHY timestamping", more on that
> separately

I believe I do, more on that below.

> - because I am looking at this problem from the perspective of a user
>   who has a problem with DSA timestamping (aka code that already exists,
>   and that is already claimed to work). They're going to be searching
>   through the git log for potentially relevant changes, and even if they
>   might notice a patch that "adds support for PHY timestamping in FEC"*,
>   it might not register as something relevant to them, and skip it.
>   Just as you don't care about DSA, neither does that hypothetical user
>   care about PHY timestamping.

I don't think it's fair. I believe I do care about both, please re-read
the subject and description of the patch:

"net: fec: fix hardware time stamping by external devices"

that sure must be relevant for any external device, be it PHY or DSA,
and then:

"Fix support for external PTP-aware devices such as DSA or PTP PHY:"

And while formally I do add "support for external PTP PHY in FEC", as
you mention, I still consider it a bug-fix, as ethtool already correctly
supports this, see below for more background.

[...]

>> > Nope. The PHY timestamping support will go to David's net-next, this
>> > common PHY/DSA bugfix to net, and they'll meet sooner rather than
>> > later.
>> 
>> I'll do as you suggest, separating the patches, yet I fail to see why
>> PHY /time stamping bug fix/ should go to another tree than PHY/DSA /time
>> stamping bug fix/? What's the essential difference? Could you please
>> clarify?
>> 
>
> The essential difference is that for PHY timestamping, there is no
> feature that is claimed to work which doesn't work.

I believe this is a feature that is supposed to work, yet it doesn't,
see below.

>
> If you run "ethtool -T eth0" on a FEC network interface, it will always
> report its own PHC, and never the PHC of a PHY. So, you cannot claim
> that you are fixing PHY timestamping, since PHY timestamping is not
> advertised. That's not what a bug fix is, at least not around here, with
> its associated backporting efforts.

You can't actually try it as you don't have the hardware, right? As for
me, rather than running exactly ethtool, I do corresponding ioctl() in
my program, and the kernel does report features of my external PTP PHY,
not of internal one of the FEC, without my patches!

> The only way you could have claimed that this was fixing PHY
> timestamping was if "ethtool -T eth0" was reporting a PHY PHC, however
> timestamps were not coming from the PHY.

That's /exactly/ the case! Moreover, my original work is on 4.9.146
kernel, so ethtool works correctly at least since then. Here is quote from
my original question that I already gave reference to:

<quote>
Almost everything works fine out of the box, except hardware
timestamping. The problems are that I apparently get timestamps from fec
built-in PTP instead of external PHY, and that

  ioctl(fd, SIOCSHWTSTAMP, &ifr)

ends up being executed by fec1 built-in PTP code instead of being
forwarded to the external PHY, and that this happens despite the call to

   info.cmd = ETHTOOL_GET_TS_INFO;                                                                             
   ioctl(fd, SIOCETHTOOL, &ifr);                                                                     

returning phc_index = 1 that corresponds to external PHY, and reports
features of the external PHY, leading to major inconsistency as seen
from user-space.
</quote>

You see? This is exactly the case where I could claim fixing PHY time
stamping even according to your own expertise!

> From the perspective of the mainline kernel, that can never happen.

Yet in happened to me, and in some way because of the UAPI deficiencies
I've mentioned, as ethtool has entirely separate code path, that happens
to be correct for a long time already.

> From your perspective as a developer, in your private work tree, where
> _you_ added the necessary wiring for PHY timestamping, I fully
> understand that this is exactly what happened _to_you_.
> I am not saying that PHY timestamping doesn't need this issue fixed. It
> does, and if it weren't for DSA, it would have simply been a "new
> feature", and it would have been ok to have everything in the same
> patch.

Except that it's not a "new feature", but a bug-fix of an existing one,
as I see it.

>
> The fact that you figured out so quickly what's going on just means
> you're very smart. It took me 2 months to find out the same bug coming
> from the DSA side of things.

Thanks, but I'd rather attribute this to the fact that in my case there
was the code that worked correctly, so I was lucky to get support point
to rely upon.

Thanks,
-- Sergey
