Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3F6339AF
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 22:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfFCUY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 16:24:56 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:38369 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfFCUYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 16:24:53 -0400
Received: by mail-lf1-f50.google.com with SMTP id b11so14638859lfa.5
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 13:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u0bj5eMak8sMBiIk5v+RdqesL6i06Wpjl4vzJ82RYKU=;
        b=bGsk3ApGDZofDzGKFHvgiBN2+VdwbPx2ArHRIU4LNh7QQIwKy63JvZxImcCbDKyk8G
         kc4WjI69EAIRouwHENLzyO0GCNo2pwNo6/G88NTI5GZj89b/vNeksbJhCNhCr38YYv3C
         uPimuKUBbplSefi7zlDLj8BRg9cyvXFjvK5Lg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u0bj5eMak8sMBiIk5v+RdqesL6i06Wpjl4vzJ82RYKU=;
        b=NwQM/iP461YqDt6ljhP1o0EjQuIwjC2+Np1DE0DbDA6Up5wI2fUeXTyBNoczFNqilI
         8EGYa2qMHFumg6q3lRoS4KlAeMNWvmwyuzviBzpRpHlq2peVJ/sJh3kZfdbp4yjlweOO
         tD3SSMFG5jzCUKeD2i0Nzx3g4Vswn/cBcZn1tgg66gEUIjRlHGjRJPSvt7EXQx6rSuuE
         LwvxFgjpPUFcxub0djkntlN0o6jQ3NbB1nx/gvq5fAuu2iDEoVhT0ezepQ+ZH/5pu+fd
         8wA65MSPPddc6ZEKo2JDCHwWk+bmhlIExRem6+AE3eTgl/Ip3fPDB8RyNCsuL8n0359j
         Q62w==
X-Gm-Message-State: APjAAAWPjF8lyMXL0aa/BoQGh3WIqxEk9RcynPBYL46cELrtrtd/pmk8
        nrCd4AGt2X8VIpizkXudCVIbOnizcLM=
X-Google-Smtp-Source: APXvYqzVHhn2x6UvIuHoG6Em7G86zs86CWZsBTAX0Hg4PH719l9ZexWBQ/7g8Q/p0sHpO8urmZY66Q==
X-Received: by 2002:ac2:4565:: with SMTP id k5mr11210699lfm.170.1559593491288;
        Mon, 03 Jun 2019 13:24:51 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id o11sm3249848lfl.15.2019.06.03.13.24.48
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 13:24:48 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id s21so6878581lji.8
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 13:24:48 -0700 (PDT)
X-Received: by 2002:a2e:85d1:: with SMTP id h17mr14759938ljj.1.1559593488055;
 Mon, 03 Jun 2019 13:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com> <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge> <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au> <20190603000617.GD28207@linux.ibm.com>
 <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au> <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
 <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com> <20190603195304.GK28207@linux.ibm.com>
In-Reply-To: <20190603195304.GK28207@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Jun 2019 13:24:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=whXb-QGZqOZ7S9YdjvQf7FNymzceinzJegvRALqXm3=FQ@mail.gmail.com>
Message-ID: <CAHk-=whXb-QGZqOZ7S9YdjvQf7FNymzceinzJegvRALqXm3=FQ@mail.gmail.com>
Subject: Re: rcu_read_lock lost its compiler barrier
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 12:53 PM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
>
> I agree that !PREEMPT rcu_read_lock() would not affect compiler code
> generation, but given that get_user() is a volatile asm, isn't the
> compiler already forbidden from reordering it with the volatile-casted
> WRITE_ONCE() access, even if there was nothing at all between them?
> Or are asms an exception to the rule that volatile executions cannot
> be reordered?

Paul, you MAKE NO SENSE.

What is wrong with you?

I just showed you an example of where rcu_read_lock() needs to be a
compiler barrier, and then you make incoherent noises about
WRITE_ONCE() that do not even exist in that example.

Forget about your READ_ONCE/WRITE_ONCE theories. Herbert already
showed code that doesn't have those accessors, so reality doesn't
match your fevered imagination.

And sometimes it's not even possible, since you can't do a bitfield
access, for exmaple, with READ_ONCE().

> We can of course put them back in,

Stop the craziness. It's not "we can". It is a "we will".

So I will add that barrier, and you need to stop arguing against it
based on specious theoretical arguments that do not match reality. And
we will not ever remove that barrier again. Herbert already pointed to
me having to do this once before in commit 386afc91144b ("spinlocks
and preemption points need to be at least compiler barriers"), and
rcu_read_lock() clearly has at a minimum that same preemption point
issue.

                     Linus
