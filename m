Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE636DB625
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390554AbfJQSbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:31:05 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37082 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbfJQSbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:31:04 -0400
Received: by mail-lj1-f195.google.com with SMTP id l21so3615654lje.4
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=znpVz5tg9ACJ4Rmonx9XgytIE074tRKt/V61yqpE9EM=;
        b=rlpiNE5E4WJKGhsnbL+Fv4Ba8SI6IvsVhJ0mugQhZxlTrCUwhA9iWDB2SKv/8AhvrX
         pNNqFm31JInETMQB6B8KrtbV/I0eDf59qBWlyy457C/pvesJeT7ghoc+LfVQAfryZieI
         LHJyRKI1jQS6iCyFy58zwVhFxVzV6wsB4TtQ3R7sAKUrjM0QhJYZ/fn5g9xcI3QA4SOl
         CnYJ5e/QCDDO/iqguNxbVixfqyZ0yZiOI/cKus5rkAKgGvO7LxzWBHjIxN0rGluucNpG
         4mxMVbbyeXIGJzCNnABbYwZGi9hvVrYxQFRdGTVOmybHecFZpYGrGzfpdmedHvy78eza
         SJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=znpVz5tg9ACJ4Rmonx9XgytIE074tRKt/V61yqpE9EM=;
        b=ZWX/Bir3lgt7AlY2dhTcOlVi48lcQNqib2iR6q/3OeI931MqNRa2WufF9Pe72+xI+8
         pcORfYXRXL7SKufBhfxYJMnoKG6BCdIl2wmky5uSjOa314WxXaRD+K80qr2TgtDXXRxZ
         ABV/XT1Yz9JV/den7M+QzMlk32gF4+la8yEuIO8lRRaFk8CZOYaypRh5BpMWBZP+fTzB
         WaLNtUFf1ZEUjtdWrgZrxx5R+DUNQvLNsq2Mls8u4LpLCN5/7+TrYzG6/FLTa9OOkVj8
         jPlswl48L00h4v0XJZtWydyt07mzyqhNGOKsVyVqNWxA5DXIaYTxcLbp8+etKLlwFfJo
         +Drw==
X-Gm-Message-State: APjAAAXLBCVSKMl/GzNRrNhVzpNwaCeY/2CGrAM2uYI8jv4w2fyjbj7E
        0iVzcgkXqjIUxp0n6BvKWcz3T3z3g9VA53U1jHE=
X-Google-Smtp-Source: APXvYqzIUptju9cfU4HUqKbNdvkNT39ICrzFWUdbP2w68yD1IgirZAhyVJ+esy+a3RyRpWtrVg/jZXt2uPM8QyWaFms=
X-Received: by 2002:a2e:8417:: with SMTP id z23mr3491338ljg.46.1571337062330;
 Thu, 17 Oct 2019 11:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191008053507.252202-1-zenczykowski@gmail.com>
 <20191008053507.252202-2-zenczykowski@gmail.com> <20191008060414.GB25052@breakpoint.cc>
 <CAHo-OowyjPdV-WbnDVqE4dJrHQUcT2q7JYfayVDZ9hhBoxY4DQ@mail.gmail.com>
 <CAHo-Ooy=UC9pEQ8xGuJO+8-c0ZaBYind3mo7UHEz1Oo387hyww@mail.gmail.com> <CAM_iQpV7D73p7k=806u+2vxiDDK-ecFuW5Rbk6j_BDO0K-FEGg@mail.gmail.com>
In-Reply-To: <CAM_iQpV7D73p7k=806u+2vxiDDK-ecFuW5Rbk6j_BDO0K-FEGg@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 17 Oct 2019 11:30:51 -0700
Message-ID: <CAHo-OoxQ04vvBB-eO8_5MJLfWyy-fdvC_73TF0QfacH6Bg8d=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] netfilter: revert "conntrack: silent a memory leak warning"
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So you conclude as it is not leak too? Then what are you trying to
> fix?

I conclude there is no easily *visible* leak.
At least not at first glance - not with single threaded code.

> I am becoming more confused after this. :-/

I think adding kmemleak_not_leak() is hiding the fact that there
actually is a leak.

I think the leak is far more subtle.  Possibly some sort of race
condition or something.
I don't see it though.

The rcu doesn't seem entirely kosher, but I know little about such things.

And I think the leak is *still* here.

After all kmemleak_not_leak is purely annotation.
It doesn't fix any leaks, it just makes us not warn about them.

> > Basically AFAICT our use of __krealloc() is exactly like krealloc()
> > except instead of kfree() we do kfree_rcu().
> >
> > And thus I don't understand the need for kmemleak_not_leak(old).
>
> kfree_rcu() is a callback deferred after a grace period, so if we
> allocate the memory again before that callback, it is reported to
> kmemleak as a memory leak unless we mark it as not, right?
>
> Or kfree_rcu() works nicely with kmemleak which I am not aware
> of?

We have kfree_rcu() all over the kernel, but there's very few
kmemleak_not_leak's.

I don't see how kfree_rcu() could not work nicely with kmemleak.
If it didn't we'd have it reporting leaks all over the place...
