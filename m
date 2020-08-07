Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EDE23F2BC
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 20:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHGS3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 14:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgHGS30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 14:29:26 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B65C061757
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 11:29:25 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id l84so2738789oig.10
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 11:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GRZscs3w79+OTYKLy1t5uEwBVQo4S2E3yAf0TmC6ezQ=;
        b=M87sxljRhgDKnOiY+w5VD4cJXvG7jw/q7azGnqtu3jmMp3QYwFtssH0Z6+asChmaBm
         +I1bw4NeZR0P6cMYJ4mTOv5f+tCG7sElwI7wtjNVVvF0ZMWBKs5dcv1bGp5hAKgn2bvs
         ng5DmwCuDu1n2RtWCqjXqh6GniagFwwQR4t6NDJW3aVJjZLmFe5lT/m5KA0ALE2cyqVD
         yGjDMYAG13VD82ukONfeoAA/5I0VL1SgTYmOJm0fxLCTqCqh332uJhojsg93dUmyIrZv
         C+raIMzHP6zHs+T1AoQJpcDADnFn9RLfyJaBtpDaHsk4f1RT13wl47kFQpTCH0TwR1xS
         VRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GRZscs3w79+OTYKLy1t5uEwBVQo4S2E3yAf0TmC6ezQ=;
        b=MXNXn3+qvll1nbitAl5rbOZVqzqpWLDaqdXvYmNYh2w5sVpfpxmLeB1HBNX+cOjPd9
         ihUGPKXPiymNo8t/SsbcRNJTTv3o+Tgp6pqCz9x1dpfYREJe6w3ZHTp2JB9qXtf1be+G
         C1uAoxuZMAEyJCH/QPeLYl7cKm0ZkbWTJPBSVdwTN4SutaPxR5GSplfkjrrEWfAhKaZr
         mAj3XkMiuDofWEZJzN05pE4vRxVRwXKSIrjaKNY4CqH7umi7OOyQgvk3A0IvWZ/7XI3b
         EFOq974DIWzOKBPfhl17YYwxgDlFh2CBViPkU1UGTUEtQtK+iwX9+UPlFazYiy7Db5Pe
         TNfw==
X-Gm-Message-State: AOAM5303oNvAHnrDicAysLaMzUe6IYD1t4EUUJiWb40yQ113eiOZtwp0
        W7hk5odXig3HmcLTd9+y/cfIUF9tTNvJNcPhLLcOGA==
X-Google-Smtp-Source: ABdhPJzSqBEwBD90o7enXkKcc9j2icDqdYfOORflr4DBAg2p5wuOERIh95avM+pnEaF+z97ZGau7xu5IuDErxZuDQVU=
X-Received: by 2002:aca:b50b:: with SMTP id e11mr10955479oif.10.1596824964855;
 Fri, 07 Aug 2020 11:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200805.185559.1225246192723680518.davem@davemloft.net>
 <CANcMJZA1pSz8T9gkRtwYHy_vVfoMj35Wd-+qqxQBg+GRaXS0_Q@mail.gmail.com>
 <011a0a3b-74ac-fa61-2a04-73cb9897e8e8@gmail.com> <CALAqxLVDyTygzoktGK+aYnT2dQdOTPFAD=P=Kr1x+TmLuUC=NA@mail.gmail.com>
 <CALAqxLWKGfoPya3u9pbvZcbMAhjXKmYvp8b6L7hpk4bNWyt7sQ@mail.gmail.com> <20200807071954.GA2086@lst.de>
In-Reply-To: <20200807071954.GA2086@lst.de>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 7 Aug 2020 11:29:14 -0700
Message-ID: <CALAqxLWNJPvS_7pMU4cq1VsbednmUi_Ujji6OrVt0z6_mnRK9A@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     Christoph Hellwig <hch@lst.de>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Todd Kjos <tkjos@google.com>,
        Amit Pundir <amit.pundir@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 12:19 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Aug 06, 2020 at 11:23:34PM -0700, John Stultz wrote:
> > So I've finally rebase-bisected it down to:
> >   a31edb2059ed ("net: improve the user pointer check in init_user_sockptr")
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a31edb2059ed4e498f9aa8230c734b59d0ad797a
> >
> > And reverting that from linus/HEAD (at least from this morning) seems
> > to avoid it.
> >
> > Seems like it is just adding extra checks on the data passed, so maybe
> > existing trouble from a different driver is the issue here, but it's
> > not really clear from the crash what might be wrong.
> >
> > Suggestions would be greatly appreciated!
>
> I think the sockpt optimization is just a little to clever for its
> own sake, as also chown by the other issue pointed out by Eric.
>
> Can you try this revert that just goes back to the "boring" normal
> version for everyone?

Yes! This seems to avoid the crash and networking looks ok.

Tested-by: John Stultz <john.stultz@linaro.org>

thanks
-john
