Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E878A3D9192
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 17:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbhG1PNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 11:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbhG1PNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 11:13:43 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558B7C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 08:13:41 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id r23so3525013lji.3
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 08:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iH7MSHpYkHvJt7wqynx3N1nt28MSGKLy81RVHV/rOTQ=;
        b=llOIVjkPDOZVDBnCosKuNvsEwkGlWS1duCcU81fec5dLbyZ+vz3cfmKDjR9lQtzwSG
         A0ymlnFmm9551mLAmo5Whqh/m6dBueJazpXw/bGY1fiIosrvEj2QAAxL5QpxTKUYSIlS
         HX7IoGgIHHYboHkDAS9HOUX4BCbesRw74+gJuKvZbUZDwK/3KZfYK8/gLLT3rSpiKBJM
         9LN5HJL/IwS1rnrcnZ738sljO+6aSoih7gJROXbEZhfMWE/uLDXzLMAF6fnB4//FdKtX
         SjS5Hd0psszALArFmdQekmeSjC+2D82Tytzk4WzeKsRxLO6AeVG/ev1ccO2iv4SqMl7a
         iXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iH7MSHpYkHvJt7wqynx3N1nt28MSGKLy81RVHV/rOTQ=;
        b=gatnsR8vFBSXrw6LA2Wmq5Lt2XOS2dUR9pd+zDS0+RReh9R5D/ClKWajzUP5cNgWbP
         lezLNAFqr63Uy051bmzFtbbi6UeNsanO2CFlFqPS5E7frWhKtXjLQv0RcmM0o+FLoqjQ
         TPH+7s4ec3XZwUxvVIEfTzRdrsY1hybM8+Fx4InwQE2q78sFnbi3YnsxN0kL9tNum66h
         1P1NdY4F1HiP+i1p3QfTAffeO7TftK5gBZfxbbIQb8eLEVX/pXugFjLe9urTt3fBI9Er
         XSTu1B1tp00WCASYqDbzlqC7EjYFgU1ItGRK1Npzp0rjghOCxBuR6kPf9gIDy5bFQb1c
         g18A==
X-Gm-Message-State: AOAM533507ihFAhaZNH/JTsEL/iuXx5V5wkWZoDjYT+RNPxIw1ZCxZdM
        bJMizQ7kA9TQ4T+w7e1dJdxgY/k4vlAHAjjOvfWmqA==
X-Google-Smtp-Source: ABdhPJzeiZ+1TgzPSirdloqJjM8mUbNaOn+fNJgtn233eJ55reHRi5N7Rx6u/RLgqpRP2CibU35ecP2NVyDLu+yjOlU=
X-Received: by 2002:a05:651c:218:: with SMTP id y24mr221427ljn.448.1627485219260;
 Wed, 28 Jul 2021 08:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210715055923.43126-1-xiyou.wangcong@gmail.com> <202107230000.B52B102@keescook>
In-Reply-To: <202107230000.B52B102@keescook>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 28 Jul 2021 17:13:12 +0200
Message-ID: <CAG48ez0b-t_kJXVeFixYMoqRa-g1VRPUhFVknttiBYnf-cjTyg@mail.gmail.com>
Subject: tracepoints and %p [was: Re: [Patch net-next resend v2] net: use %px
 to print skb address in trace_netif_receive_skb]
To:     Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+tracing maintainers

On Fri, Jul 23, 2021 at 9:09 AM Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jul 14, 2021 at 10:59:23PM -0700, Cong Wang wrote:
> > From: Qitao Xu <qitao.xu@bytedance.com>
> >
> > The print format of skb adress in tracepoint class net_dev_template
> > is changed to %px from %p, because we want to use skb address
> > as a quick way to identify a packet.
>
> No; %p was already hashed to uniquely identify unique addresses. This
> is needlessly exposing kernel addresses with no change in utility. See
> [1] for full details on when %px is justified (almost never).
>
> > Note, trace ring buffer is only accessible to privileged users,
> > it is safe to use a real kernel address here.
>
> That's not accurate either; there is a difference between uid 0 and
> kernel mode privilege levels.
>
> Please revert these:
>
>         851f36e40962408309ad2665bf0056c19a97881c
>         65875073eddd24d7b3968c1501ef29277398dc7b
>
> And adjust this to replace %px with %p:
>
>         70713dddf3d25a02d1952f8c5d2688c986d2f2fb
>
> Thanks!
>
> -Kees

Hi Kees,

as far as I understand, the printf format strings for tracepoints
don't matter for exposing what data is exposed to userspace - the raw
data, not the formatted data, is stored in the ring buffer that
userspace can access via e.g. trace_pipe_raw (see
https://www.kernel.org/doc/Documentation/trace/ftrace.txt), and the
data can then be formatted **by userspace tooling** (e.g.
libtraceevent). As far as I understand, the stuff that root can read
via debugfs is the data stored by TP_fast_assign() (although root
_can_ also let the kernel do the printing and read it in text form).
Maybe Steven Rostedt can help with whether that's true and provide
more detail on this.

In my view, the ftrace subsystem, just like the BPF subsystem, is
root-only debug tracing infrastructure that can and should log
detailed information about kernel internals, no matter whether that
information might be helpful to attackers, because if an attacker is
sufficiently privileged to access this level of debug information,
that's beyond the point where it makes sense to worry about exposing
kernel pointers. But even if you disagree, I don't think that ftrace
format strings are relevant here.




> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#p-format-specifier
>
> >
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> > ---
> >  include/trace/events/net.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> > index 2399073c3afc..78c448c6ab4c 100644
> > --- a/include/trace/events/net.h
> > +++ b/include/trace/events/net.h
> > @@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
> >               __assign_str(name, skb->dev->name);
> >       ),
> >
> > -     TP_printk("dev=%s skbaddr=%p len=%u",
> > +     TP_printk("dev=%s skbaddr=%px len=%u",
> >               __get_str(name), __entry->skbaddr, __entry->len)
> >  )
> >
> > --
> > 2.27.0
> >
>
> --
> Kees Cook
