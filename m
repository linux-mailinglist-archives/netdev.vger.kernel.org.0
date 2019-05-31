Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A63931384
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfEaRLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:11:46 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:35928 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfEaRLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:11:45 -0400
Received: by mail-yb1-f193.google.com with SMTP id y2so3823438ybo.3
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QOZqg+HYN41MGcZXnbzu+lG/2AcgsNtdxfeqPjWSGV8=;
        b=SkidUbfOAynW/t7qWQDQab/hmWZQ7HdAKVBhpwpqOXMBBV5cRhd2EF84wyIpkDhr3D
         6yCE+K+edBc0Xifv563al13LpyJnHdIzW1XlLT70yI4vuW8BGy18u1yi5NXE5Uya6D9S
         yT7D1ZGVzN9pbIUyCBGgOfjbvzdRzsApScvpwubzNjaiakT4XPfrhseepiWlcF+VsCXL
         5P4p0Fsy5mwXVEYb4T/bW6HHxVrao7DN0md2JzjB8kHAU51BRoJ0npu3ihBPxlzBdpg5
         yN4qNNuhsYQUvtYB9+odIe4Qr/JETJ3+ybMlTr2Wj0z717tR9ijStgO42i2gePm5GSJQ
         Q6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QOZqg+HYN41MGcZXnbzu+lG/2AcgsNtdxfeqPjWSGV8=;
        b=EptYFPWV4i4SBFT8HlIr3MgDgXUrJ+SMeKkEI8TP6/yrMo8rfUCtb7t5MajCUFGjvD
         JIl8tsWpXCMpMmj6Tj35b4sneyRbeN7ERF4W2/1qey/dw3YoSr2ufM1HD0X+u2TV0HHk
         WffFnrdGBNVChbAhH5CPdIllAHtRVlGCZh1OJsbStD4Py+DiepO0d0Ve3HgTiaEAyCLa
         oqvatjVlLsqJTAiHx3Zxt4xzNPGSYSyv5xLD8UTIs9nuQmX/6MMmZMef+TihY7/FGCUd
         lN4xrQj73a+kGEJxHQqq8x+ufkBeIs5fxsuYqHubc1K7azj8aRMJ6ZuZIm1Oamep9hwO
         Qr9w==
X-Gm-Message-State: APjAAAXGwwIscdbfbPRS0p1oQhIF94JoHksVU7hxp6TYHEqHK1CSZ+K6
        wKqoqkKNb1GD8mwVWdGcrNC4uhPlaXwjX+423DbqdA==
X-Google-Smtp-Source: APXvYqznKYsxhMM9Y0s7/vDSX3G7w48wD6bLlgv8dJwHmXezOEM9n38X8kReauKwtiO6U0Vj+z3AS4lCbrx1D8/GiG8=
X-Received: by 2002:a25:bf83:: with SMTP id l3mr5595836ybk.446.1559322704544;
 Fri, 31 May 2019 10:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190524160340.169521-12-edumazet@google.com> <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au> <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
 <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au> <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
 <20190531144549.uiyht5hcy7lfgoge@gondor.apana.org.au> <4e2f7f20-5b7f-131f-4d8b-09cfc6e087d4@gmail.com>
 <20190531162945.GA600@andrea>
In-Reply-To: <20190531162945.GA600@andrea>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 May 2019 10:11:32 -0700
Message-ID: <CANn89iLJAM8kB8ySk2hDReewbL3AqrcEZb8Zf64=mj-cda=onA@mail.gmail.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary smp_store_release/READ_ONCE
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 9:29 AM Andrea Parri
<andrea.parri@amarulasolutions.com> wrote:
>
> On Fri, May 31, 2019 at 08:45:47AM -0700, Eric Dumazet wrote:
> > On 5/31/19 7:45 AM, Herbert Xu wrote:
>
> > > In this case the code doesn't need them because an implicit
> > > barrier() (which is *stronger* than READ_ONCE/WRITE_ONCE) already
> > > exists in both places.
>
>
> > I have already explained that the READ_ONCE() was a leftover of the first version
> > of the patch, that I refined later, adding correct (and slightly more complex) RCU
> > barriers and rules.
>
> AFAICT, neither barrier() nor RCU synchronization can be used as
> a replacement for {READ,WRITE}_ONCE() here (and in tons of other
> different situations).  IOW, you might want to try harder.  ;-)

At least the writer side is using queue_rcu_work() which implies many
full memory barriers,
it is not equivalent to a compiler barrier() :/

David, Herbert, I really do not care, I want to move on fixing real
bugs, not arguing with memory barriers experts.

Lets add back the READ_ONCE() and be happy.
