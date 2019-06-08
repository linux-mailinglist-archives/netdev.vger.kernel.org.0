Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413093A0F0
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 19:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfFHRvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 13:51:11 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:33874 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfFHRvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 13:51:11 -0400
Received: by mail-lj1-f180.google.com with SMTP id j24so4460594ljg.1
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 10:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W+9QCBgZ9J2LCx+rEhbyPEc2X/CUYFq2IbJFH8fkL3M=;
        b=OJ1oYvJZ6e6i4G7bdLCVhlcvwr0pHFtMP6ZQaim/xPyhSQUqj99YSqUAeVdG+dLmxk
         mLPivGpd5euSbx5fKXvsmlx732m9r2LNS2ieZcz/rui4qyxz+94OKMK8wzJDt6Ofhiud
         xnGO27CZ1iE+XuSlD7A1HP5aPnFLZs/BzWKsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W+9QCBgZ9J2LCx+rEhbyPEc2X/CUYFq2IbJFH8fkL3M=;
        b=NwokD/I/tfOzAS+ovYgFptlObRomqvmkfqyoYdrbXqVNaQt/4t1/ZOiP3Zz2eFyJPC
         O+SfjNLhGVCmldF073sCSKN6gpts0SpxPBQGIz2C6ntUGNb3B85l5OSEe9/gJEWlbpIy
         5n2cVELI7ny/s4IZkDbytN7M+wTb/PB5i8LdaF1lCJtBbf3YrUwr2D7FT3uy7ZYByVVy
         641FJ63+qS7s0rs898rUhPZ+9OXOJOpe89DOr7h8kS8K6TTfv7C8fKU5DvgG0EeQiE1C
         OwNjpKDLj/bMNKD++dwJmTyEKEsoRFnMbSrSFeXq/yEDDqsTShCDnyFrSb/2GH7EkYIJ
         sf/g==
X-Gm-Message-State: APjAAAWKICiQOeVyUfQTu5kaePsWp0eJ9HAv0QYuaVjT5SeHsrG4kFif
        Uhl9de1QA8elemRopAoHbC+GqbRlKss=
X-Google-Smtp-Source: APXvYqx6kikq2WY5jiGFLuruDyiCtPa6TIO3phSl4/HrLGSZ9up0geF7aU6yR3Wjys/6IYVovVJCOA==
X-Received: by 2002:a2e:635d:: with SMTP id x90mr21589397ljb.140.1560016268488;
        Sat, 08 Jun 2019 10:51:08 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id l1sm1042905lfe.60.2019.06.08.10.51.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 10:51:07 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id v29so4469164ljv.0
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 10:51:07 -0700 (PDT)
X-Received: by 2002:a2e:6109:: with SMTP id v9mr31679230ljb.205.1560016266935;
 Sat, 08 Jun 2019 10:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190603200301.GM28207@linux.ibm.com> <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
 <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au> <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
 <CAHk-=wgtY1hNQX9TM=4ono-UJ-hsoFA0OT36ixFWBG2eeO011w@mail.gmail.com>
 <20190608152707.GF28207@linux.ibm.com> <CAHk-=wj1G9nXMzAu=Ldbd4_bbzVtWgNORDKMD4bKTO6dRrMPmQ@mail.gmail.com>
In-Reply-To: <CAHk-=wj1G9nXMzAu=Ldbd4_bbzVtWgNORDKMD4bKTO6dRrMPmQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 8 Jun 2019 10:50:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiRduKzoLpAwU7iFiOJ6DX7RE+PZ_wFi9Cvq=hDoaNsPA@mail.gmail.com>
Message-ID: <CAHk-=wiRduKzoLpAwU7iFiOJ6DX7RE+PZ_wFi9Cvq=hDoaNsPA@mail.gmail.com>
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

On Sat, Jun 8, 2019 at 10:42 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> There are no atomic rmw sequences that have reasonable performance for
> the bitfield updates themselves.

Note that this is purely about the writing side. Reads of bitfield
values can be (and generally _should_ be) atomic, and hopefully C11
means that you wouldn't see intermediate values.

But I'm not convinced about that either: one natural way to update a
bitfield is to first do the masking, and then do the insertion of new
bits, so a bitfield assignment very easily exposes non-real values to
a concurrent read on another CPU.

What I think C11 is supposed to protect is from compilers doing
horribly bad things, and accessing bitfields with bigger types than
the field itself, ie when you have

   struct {
       char c;
       int field1:5;
   };

then a write to "field1" had better not touch "char c" as part of the
rmw operation, because that would indeed introduce a data-race with a
completely independent field that might have completely independent
locking rules.

But

   struct {
        int c:8;
        int field1:5;
   };

would not sanely have the same guarantees, even if the layout in
memory might be identical. Once you have bitfields next to each other,
and use a base type that means they can be combined together, they
can't be sanely modified without locking.

(And I don't know if C11 took up the "base type of the bitfield"
thing. Maybe you still need to use the ":0" thing to force alignment,
and maybe the C standards people still haven't made the underlying
type be meaningful other than for sign handling).

            Linus
