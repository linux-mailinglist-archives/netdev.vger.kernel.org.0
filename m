Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF10184186
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 08:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCMHbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 03:31:11 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40730 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgCMHbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 03:31:11 -0400
Received: by mail-qt1-f196.google.com with SMTP id n5so6738181qtv.7
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 00:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=otjCA0qUOdrbDfCxjamOr2JfsohGEgJgplUkLsbNr4E=;
        b=ZyaC46HF44G9D3UVtFVFnr1FvCuUAuDuU6fdUNcNPX/xO05FUwGz11D7mK5B+T0WJL
         cJizWGQUGrSIovoj0XOopxczBCSNjbrIRi89l9uw26i8Lvt6CgEo45yR7hmJg7OI4e24
         f35T8f6Q1HzUqRmjtzGbnUlp08Km19leQ+RpfkKrpRiCOGUOO3xs3YzZKMr2zQbyhxaV
         BuhZO6rniiH6gZdR8aDRjy2pR8NApcQ0aS7FiJw7M5xkzCJEYtvpBoAvrtATeAtVRqSy
         4J0E5zZewUXfqiPwSY4EgshTl8aZwKYT1K8FGdjdJRYwBTklP16RGnH+FSAzJgdk8ae7
         0mVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=otjCA0qUOdrbDfCxjamOr2JfsohGEgJgplUkLsbNr4E=;
        b=nKXGnts+vMtf2YNR0E7lDmOOx/MZr02OuxFdGdi54BagN7hcE/5DkSPQWoj+3hKGGc
         Ojl6n4MIRTwaFy41l2rz97fgRV4OeYUpBdbr8NMDeXqXSBxXf+HlaTdVXHQSE3kof3X4
         xJJl9wLyC+CLMFZphB4pBNEAAQfw0HboasLpFd2tKwowIFzlGvmfjScd3mxpW8kSvupg
         D/UuiQTTf/S5ty6OkqxI5JvfW/UEgvc9xSzurylNo+rZYaMFGCKALadmdC5ybcMvF7jj
         FA/6ztW/4wskP8sLxsC9sCKAis5s37sRhqOXrb5NBPZbsu/36voI0IawkMI1N78RWW7t
         zzIg==
X-Gm-Message-State: ANhLgQ3vYsgem4fy9/8elDA3uap5U0MHog+diaNkmNqk1+kDblwKZNdd
        kddGikQ1Ei+hTZDgU1telNxAFvgqGzVboPjs00pNww==
X-Google-Smtp-Source: ADFU+vuv3HwZeTF5PsruoeS+N8rIruzo+vgdaAkOxSLbvfRlYHD1x0nqc8BJf9m+C9//uMqVnG1egWzVQBf8UmOQInY=
X-Received: by 2002:ac8:f85:: with SMTP id b5mr10932879qtk.158.1584084669617;
 Fri, 13 Mar 2020 00:31:09 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000ea4b4059fb33201@google.com> <000000000000c7979105a0a311f6@google.com>
 <20200313014435.GY979@breakpoint.cc>
In-Reply-To: <20200313014435.GY979@breakpoint.cc>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 13 Mar 2020 08:30:58 +0100
Message-ID: <CACT4Y+aPA8byGU=rt5P9tt3wWHL8Wr3t_uiXZ5fJBzAtcc=+AA@mail.gmail.com>
Subject: Re: WARNING in geneve_exit_batch_net (2)
To:     Florian Westphal <fw@strlen.de>
Cc:     syzbot <syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Hillf Danton <hdanton@sina.com>, Jiri Benc <jbenc@redhat.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        LKML <linux-kernel@vger.kernel.org>, moshe@mellanox.com,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 2:45 AM Florian Westphal <fw@strlen.de> wrote:
>
> syzbot <syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com> wrote:
> > syzbot has bisected this bug to:
> >
> > commit 4e645b47c4f000a503b9c90163ad905786b9bc1d
> > Author: Florian Westphal <fw@strlen.de>
> > Date:   Thu Nov 30 23:21:02 2017 +0000
> >
> >     netfilter: core: make nf_unregister_net_hooks simple wrapper again
>
> No idea why this turns up, the reproducer doesn't hit any of these code
> paths.

The attached bisection log usually makes this reasonably transparent.
It seems that in this case another kernel bug gets in the way of bisection.

> The debug splat is a false-positive; ndo_stop/list_del hasn't run yet.
> I will send a fix for net tree.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20200313014435.GY979%40breakpoint.cc.
