Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA37CB0A0
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfJCU60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:58:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38407 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728503AbfJCU6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:58:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id j31so5622079qta.5;
        Thu, 03 Oct 2019 13:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIrZFzsJy4iycGCbOe0uKReizu+dGey8/8JfUByM3aY=;
        b=TUELeMGj1bnZp0T6dXOObTKSWjB6GhVTk1U3pAbRQWpYvWEnGpJn32dyCPfgJp8vBY
         1ItpjtUQhm0H3CCe2Q19Udml9dQVWGhA+H+RMyxdiHETM4e+fjkgK6Z2BrCxgJUcRMuW
         /HhwXEwBK9x2MqZ+rntfhF7v3koRfj6cB8IwDJ0mRXXx6h4OCkFkM9ya1El9wHBPYSQq
         Vxl577u3dj6cBqUM6718XQugrH3kn+KenZdor2eb5QxyGE2BEDOX8Shg80PpCs+zbf/g
         KEEJmaVWe0lTBDGZ4vVvdPNxyKCVwhhHBZ1F+EyGNCwvtiJTHEqZTgZFoMTtjZ9QfD56
         6mKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WIrZFzsJy4iycGCbOe0uKReizu+dGey8/8JfUByM3aY=;
        b=ihub32iBSiCoT4JbmcCrGH8o0bHTTQMhyFe68U8A0g12dXGmwlVLJNQG0kQH7e/p52
         K6A7QANMjYihVkgDa2QTmjXgk9vX/8O0FDMt/UJdDvxQebSVCR+n4Y1czid6LKC+TTgZ
         z2KOXzfyKQ5v9YAdj3edg1+p8L66E0rB/SwYRelXbpi4qIVyXhQl2vrqYLpy5F+SZK0c
         Sz3DMnTMwqhUo+RTOjFnSXoBjAGhpVaZlAl1NjoUGCFfLUNX9HyynhpORzvV2w2kngaj
         n/t10mRlBCCYqtmUOmVRs1IwBcW5Kxdm8AyBD3KGk23k8T+pEOtfLIXwOC1+iQUJ0wz8
         bLeA==
X-Gm-Message-State: APjAAAUNkStSpLb6aih7weDxR52VY/NbnI1D5uwpygOUbBG2v2e/nHVn
        05tIj1c43NVXcE/LEu6uARPso1BFXO37urN8Uq0=
X-Google-Smtp-Source: APXvYqx8pJ3WWpgB3HKjBdeqRnKtSmk9B7++9MNYZYl5YXKOTp5N2c7zor6mXaH+z8duvvJ7CrD6z/1c6qd6N82m9Zk=
X-Received: by 2002:a0c:9846:: with SMTP id e6mr10462518qvd.114.1570136304688;
 Thu, 03 Oct 2019 13:58:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191003014153.GA13156@paulmck-ThinkPad-P72> <20191003014310.13262-6-paulmck@kernel.org>
 <CAEf4BzaBuktutCZr2ZUC6b-XK_JJ7prWZmO-5Yew2tVp5DxbBA@mail.gmail.com>
In-Reply-To: <CAEf4BzaBuktutCZr2ZUC6b-XK_JJ7prWZmO-5Yew2tVp5DxbBA@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 3 Oct 2019 13:58:13 -0700
Message-ID: <CAPhsuW6vFwhhYngbftZk4NrSJ+qQx3F6ChUCm=n16HDK-N9vMg@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 6/9] bpf/cgroup: Replace rcu_swap_protected()
 with rcu_replace()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     paulmck@kernel.org, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, jiangshanlai@gmail.com,
        dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, dhowells@redhat.com,
        Eric Dumazet <edumazet@google.com>, fweisbec@gmail.com,
        Oleg Nesterov <oleg@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 10:43 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 2, 2019 at 6:45 PM <paulmck@kernel.org> wrote:
> >
> > From: "Paul E. McKenney" <paulmck@kernel.org>
> >
> > This commit replaces the use of rcu_swap_protected() with the more
> > intuitively appealing rcu_replace() as a step towards removing
> > rcu_swap_protected().
> >
> > Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: <netdev@vger.kernel.org>
> > Cc: <bpf@vger.kernel.org>
> > ---
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
