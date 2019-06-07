Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F1391C3
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfFGQUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:20:01 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:37141 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbfFGQUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:20:00 -0400
Received: by mail-lf1-f53.google.com with SMTP id m15so2065942lfh.4
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 09:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sah1sze9qZQXC9dhxye7WQeDvgCv5Q6wpPURRp8bWQs=;
        b=GZp/BOH8X5Pg721SyiLtnieCJ/ZD2Ktw+FSJGwq590YKHcmVc4mKv9e4VgZjoepG+N
         L9grIrK4IatsF2cxfARKtaaDuUoOOYkIk1HZzSNsBgIVd6L0FrIRl1HF5p2lKnJv9IyM
         mXYfqUagFtpgySX1R/W0DkVdRgXr8y5qemuHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sah1sze9qZQXC9dhxye7WQeDvgCv5Q6wpPURRp8bWQs=;
        b=jPeB0hFzRVOFv2ITZzjLhJosUNfKA+KlchMa/MkDMEVdmn3f5jEJx2fGWzpHLiank9
         pXm/WtdKwnALObRJlb3ZbKMlSj2t7To8HSR2Nl94P0Z7iJy90NK0V9RLalAAJN+E2oxV
         iv7QPSgewE3Kt8vRQmIHR25u/D1PMymJx1CyEimUM3Prvmv5n6IPveXLqe3kj2/Yb2Hy
         yUl6NuKKno0aktH+CARUOLWUHRiqA6L1aKE1oFT16ir9NKvOM2JYl2oEuwT8+ca2p5fW
         8dS6Lr1OFxZUTOkLnwAr0lrlksaJdXJXS1lDDex9vE/ErdIxYAItPAs1PaY2NK+BvHmh
         PsvA==
X-Gm-Message-State: APjAAAXWCA9oubpNzaw8tvUhAzEOndCHlIRGJ+DjhKrvPQFT+mAwFr/8
        bqyoHpAsSDaOy+c/3q8ITwbZi5zKBdc=
X-Google-Smtp-Source: APXvYqynM5C3BHYU+cAFzoVQmFwlL32D98AR9GLsyqSDauFeGwgExysePGdCxNINHJ4oG1Njp7QbqQ==
X-Received: by 2002:ac2:4904:: with SMTP id n4mr11659208lfi.53.1559924399013;
        Fri, 07 Jun 2019 09:19:59 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id v16sm442158lji.88.2019.06.07.09.19.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 09:19:58 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id u10so2043329lfm.12
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 09:19:58 -0700 (PDT)
X-Received: by 2002:a19:521a:: with SMTP id m26mr2437446lfb.134.1559924398137;
 Fri, 07 Jun 2019 09:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190603200301.GM28207@linux.ibm.com> <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
 <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au> <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
In-Reply-To: <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Jun 2019 09:19:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgtY1hNQX9TM=4ono-UJ-hsoFA0OT36ixFWBG2eeO011w@mail.gmail.com>
Message-ID: <CAHk-=wgtY1hNQX9TM=4ono-UJ-hsoFA0OT36ixFWBG2eeO011w@mail.gmail.com>
Subject: Re: inet: frags: Turn fqdir->dead into an int for old Alphas
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 8:26 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> There is common knowledge among us programmers that bit fields
> (or bool) sharing a common 'word' need to be protected
> with a common lock.
>
> Converting all bit fields to plain int/long would be quite a waste of memory.

Yeah, and we really don't care about alpha. So 'char' should be safe.

No compiler actually turns a 'bool' in a struct into a bitfield,
afaik, because you're still supposed to be able to take the address of
a boolean.

But on the whole, I do not believe that we should ever use 'bool' in
structures anyway, because it's such a badly defined type. I think
it's 'char' in practice on just about all architectures, but there
really were traditional use cases where 'bool' was int.

But:

 - we shouldn't turn them into 'int' anyway - alpha is dead, and no
sane architecture will make the same mistake anyway. People learnt.

 - we might want to make sure 'bool' really is 'char' in practice, to
double-check that fthe compiler doesn't do anything stupid.

 - bitfields obviously do need locks. 'char' does not.

If there's somebody who really notices the alpha issue in PRACTICE, we
can then bother to fix it. But there is approximately one user, and
it's not a heavy-duty one.

                   Linus
