Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B942977264
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfGZTtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:49:43 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38096 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727643AbfGZTtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:49:43 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so53768810qtl.5
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZTgTHrN6B+JKK0bxUfsBC3AuqiptBA1np1rV+FpgXS8=;
        b=vYpaC/nQschTK08XZSTMuyTP3F9LCSSLlQ5cEHAh/JYkSCAQpCwO2qAf+uDX5wRKL9
         LkqFzpFb9AFA81VV8y49VzYJoviYcKA30KipAxG8gZLkXJ5j5xh3B8Xi6aSdwoMi6oRx
         3s0D7Zc4HRIA9zMtJW7TUfjcqKuy25q4PrhL8e0ryE4jS8J2MriT/lR1/AtMBZstXOiF
         YLGiazPW+EdBnTFOJbYGhgpigK2fvlAU/1PjLFGHbuDsUjCLV2sYaHVNHApIkW5xrhYO
         lbcF9hW040vXQ/LQYIao27ZqqNxRZLvxgvhoMBZU66B9XE8IQ39LuD1WWC+AwQBwyJkl
         T8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZTgTHrN6B+JKK0bxUfsBC3AuqiptBA1np1rV+FpgXS8=;
        b=nICCqroy7beHb1cH6p8v3W+IH0m6kDkz3cpSBoD7Uci/8bEeUFvpG0oXpC3cRsp9SW
         PI9MIW/dEGAWw+zylnmxNDFnlcDke0Txn3yYH33mFmaQwTwG1je7yUQEComacRoJEWiC
         m3NHDGc+SzkqUUH+kBUk5C+V5l/hvAVzhVcgfI6aj/+c1wX/6s8dNwaW33MKvEUDavjg
         9tiZ7w7xV0mlsJ+4soXuuTmGM76Ks2lP9WFcQSxNR9NAAJxmxGKQLFVttX3nuONGXe+n
         CnK9DZ+r7mJ0CnA7oWPHJl22/GVLMTprhSOWiqOR1RFWVoFyUz5uA9V6NK7gGKcZA+pr
         5NHA==
X-Gm-Message-State: APjAAAVn12KtrllFsbQNyKqEuKzM9LYmL0RXM3BvTE7yykbNUrJnujG9
        5EU3oB/gDi2kFDJ1Z00r6v90A9vNsooRsTLGjHKs8w==
X-Google-Smtp-Source: APXvYqyz+HZo+hz+50oIUBT+Ci74ViWrpTikyXGqsAjt2avy5pzWrJYRGhJgiJyHNg0NzKoxh7dEaZwnmnKE17vZF0Q=
X-Received: by 2002:ac8:1ba9:: with SMTP id z38mr69008671qtj.176.1564170582398;
 Fri, 26 Jul 2019 12:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190716222650.tk2coihjtsxszarf@ast-mbp.dhcp.thefacebook.com>
 <20190716224150.GC172157@google.com> <20190716235500.GA199237@google.com>
 <20190717012406.lugqemvubixfdd6v@ast-mbp.dhcp.thefacebook.com>
 <20190717130119.GA138030@google.com> <CAADnVQJY_=yeY0C3k1ZKpRFu5oNbB4zhQf5tQnLr=Mi8i6cgeQ@mail.gmail.com>
 <20190718025143.GB153617@google.com> <20190723221108.gamojemj5lorol7k@ast-mbp>
 <20190724135714.GA9945@google.com> <20190726183954.oxzhkrwt4uhgl4gl@ast-mbp.dhcp.thefacebook.com>
 <20190726191853.GA196514@google.com>
In-Reply-To: <20190726191853.GA196514@google.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Fri, 26 Jul 2019 15:49:30 -0400
Message-ID: <CAJWu+opEckc++G6btY6Muhi6ToJQYSW7HfxPYdrJkXiAoy4Fww@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to ftrace
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Cc: Android Kernel" <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 3:18 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Fri, Jul 26, 2019 at 11:39:56AM -0700, Alexei Starovoitov wrote:
[snip]
> > > For bpf program:
> > > https://android.googlesource.com/platform/system/bpfprogs/+/908f6cd718fab0de7a944f84628c56f292efeb17%5E%21/
> >
> > what is unsafe_bpf_map_update_elem() in there?
> > The verifier comment sounds odd.
> > Could you describe the issue you see with the verifier?
>
> Will dig out the verifier issue I was seeing. I was just trying to get a
> prototype working so I did not go into verifier details much.

This is actually slightly old code, the actual function name is
bpf_map_update_elem_unsafe() .
 https://android.googlesource.com/platform/system/bpf/+/refs/heads/master/progs/include/bpf_helpers.h#39

This function came about because someone added a DEFINE_BPF_MAP macro
which defines BPF map accessors based on the type of the key and
value. So that's the "safe" variant:
https://android.googlesource.com/platform/system/bpf/+/refs/heads/master/progs/include/bpf_helpers.h#54
(added in commit
https://android.googlesource.com/platform/system/bpf/+/6564b8eac46fc27dde807a39856386d98d2471c3)

So the "safe" variant of the bpf_map_update_elem for us became a map
specific version with a prototype:
static inline __always_inline __unused int
bpf_##the_map##_update_elem(TypeOfKey* k, TypeOfValue* v, unsigned
long long flags)

Since I had not upgraded my BPF program to the "safe" variant, I had
to use the internal "unsafe" variant of the API (if that makes
sense..).

thanks Alexei!

- Joel
