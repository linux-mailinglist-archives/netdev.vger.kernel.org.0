Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB4B3A0EB
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 19:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfFHRtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 13:49:21 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:43262 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfFHRtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 13:49:21 -0400
Received: by mail-lj1-f179.google.com with SMTP id 16so4420435ljv.10
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 10:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I4wuZBASsrfrcVNwlwV9UqOEN6oWZwE6ONOc/qGw3VI=;
        b=Uu1B6CJ0y6i8Y4/pgQnaoS95gdTJiRuJ++PTvjfS1VHjeY7KoMbrI03rgRi88d8bO9
         gy6t9EHCiUmVjonW+cF34EBKqdCBxo0aHHhXx3ME8R4QFi0/niyGdSTdm1gMEAHSJKuE
         l0ftlnvh3k0TseM0yzFVUQwYJmRTVuUAqpwgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I4wuZBASsrfrcVNwlwV9UqOEN6oWZwE6ONOc/qGw3VI=;
        b=inEuZ2z2+2oC33cYueWZiFi4QE24QLwmHpzgBw1JH/6DS9NQMZh8uhxRLCGZC+Xs9p
         W567wANIZyHrMlERwxUDy1Sx6Y0GP35+WmFKWDPDc215XL9JXshRPP+HQi/TnqpJOegH
         S+dO4bFGH+KQ+ysdYE5+/KNFm7VhqlFRaDAVSzHK0uRnE0YbQZkeqqwuQuiWEfwuRKB2
         BzpSpLXtA36I8HMttw4AI8cvPTZskvlInEoKjc5AsZi2Xqt2VM+MGW1cep7WZfva79sp
         kkTtE0SKeCYAfNXv0AAGJ9jruPrfSn37KQGCvKn9KodhgRvCbvfS4+wlvFhs2KgTftxw
         Alng==
X-Gm-Message-State: APjAAAXYBSwpyYHPaYmHcYrbKc9k8bz+kqTfKblIJOdVrK1BVR/3GxUR
        e9qR7Xc1bAJ3Tt+iDqdRqOEjv9nr29g=
X-Google-Smtp-Source: APXvYqw3VBtMzkTYkGwj4ZMkkIp0xkKDH/ru4MeBhifsebJRW6SMWH2J5ONd9FMs7L2H0Wh+wn6Mbw==
X-Received: by 2002:a2e:1510:: with SMTP id s16mr2472779ljd.19.1560016159267;
        Sat, 08 Jun 2019 10:49:19 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id n3sm1042871lfh.3.2019.06.08.10.49.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 10:49:19 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id r15so3893167lfm.11
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 10:49:18 -0700 (PDT)
X-Received: by 2002:ac2:59c9:: with SMTP id x9mr29635980lfn.52.1560015777829;
 Sat, 08 Jun 2019 10:42:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190603200301.GM28207@linux.ibm.com> <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
 <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au> <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
 <CAHk-=wgtY1hNQX9TM=4ono-UJ-hsoFA0OT36ixFWBG2eeO011w@mail.gmail.com> <20190608152707.GF28207@linux.ibm.com>
In-Reply-To: <20190608152707.GF28207@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 8 Jun 2019 10:42:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj1G9nXMzAu=Ldbd4_bbzVtWgNORDKMD4bKTO6dRrMPmQ@mail.gmail.com>
Message-ID: <CAHk-=wj1G9nXMzAu=Ldbd4_bbzVtWgNORDKMD4bKTO6dRrMPmQ@mail.gmail.com>
Subject: Re: inet: frags: Turn fqdir->dead into an int for old Alphas
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alan Stern <stern@rowland.harvard.edu>,
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

On Sat, Jun 8, 2019 at 8:32 AM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
>
> On Fri, Jun 07, 2019 at 09:19:42AM -0700, Linus Torvalds wrote:
> >
> >  - bitfields obviously do need locks. 'char' does not.
> >
> > If there's somebody who really notices the alpha issue in PRACTICE, we
> > can then bother to fix it. But there is approximately one user, and
> > it's not a heavy-duty one.
>
> C11 and later compilers are supposed to use read-modify-write atomic
> operations in this sort of situation anyway because they are not supposed
> to introduce data races.

I don't think that's possible on any common architecture. The
bitfields themselves will need locking, to serialize writes of
different fields against each other.

There are no atomic rmw sequences that have reasonable performance for
the bitfield updates themselves.

The fields *around* the bitfields had better be safe, but that's
something we already depend on, and which falls under the heading of
"we don't accept garbage compilers".

              Linus
