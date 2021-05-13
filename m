Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA79A37F365
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhEMHJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 03:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhEMHJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 03:09:43 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ED1C06174A
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 00:08:33 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id r13so13354293qvm.7
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 00:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tyi0hLLwsaVhIG2kqmVitJUhgVmvI4jXmKcfvvz6ltQ=;
        b=DMKgdD30W8LrgmvfpHDsR7IBySr1EWTLYntNbEtJmrf3V1efZECo7cxiPIsjccFdFK
         Pwge9iZFRLHQQTTrolhcizYFv5v6E5A2cIHs6Xjv63q1WSBZPoEvJiWcI0EfgOwmrAgH
         /jU2TynityAh+A1/ps1fqD0sqcGnENKG+6TnsnNP3wkLjU5swNJ3saqudGTw5H5AlnEM
         At0TDCqmp+uvsGDLnZFX7gra2pb4lFj+cBwp+mbqAkHbtC1YgBzlakRPeMRTPqGlm73w
         ijPFLcntMhcQTTEHTAOq3y+H9LeoL0fG9Euzcb2yYV/9wKiB4K18Y6dA+MFwAcrYYd1o
         lWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tyi0hLLwsaVhIG2kqmVitJUhgVmvI4jXmKcfvvz6ltQ=;
        b=i8GfwzyaPVb7yHORnCmjWBx3dkQK6A0O4siaC0hwUh/B8OGKu2xyKEejoks3cRxEV9
         XthWG+X1z1qAnfkk3m74PQz1bq9VsHYhFMbms95+OPAPGD+QwSMYXa5AYxkxWdT4jUQD
         lBaNXp1h0MK1NVpSQTQuf/km0W5sncqhLKJnQw/S2d8g+bbaNXh5gqgGQKmcHjWIJuXw
         QxUY9MIF/ig45pGteS1E1KdnPhuIz0YOPfy2wOpAQRJTjZdb3L0nQjSxPBnEqOnTPjVr
         uE1rAYdsr0RQ7GzhQ1vR6kptcfjmh79GBmuTImTD2ak3wALgYrXz26GKCH4ETX1KOlIY
         zJmQ==
X-Gm-Message-State: AOAM5332O8VclYL9noFqtncBZnBKsCssxBQSMq09uqwIekQnNyhrRuXn
        cTWWSEhNss8ttRhITuEvRnSSrax8xLJ3nj0VwNJmQg==
X-Google-Smtp-Source: ABdhPJwB5oBJDYa+2C6xAdzfdJaOrzDsf8e7Xe2qHkkkwaeHaLAwZZdqU8kHm4BmIXqsMqWWpj/nXVM8IVAKDdmrTiM=
X-Received: by 2002:a0c:d786:: with SMTP id z6mr39155641qvi.18.1620889711884;
 Thu, 13 May 2021 00:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008ce91e05bf9f62bc@google.com> <CACT4Y+a6L_x22XNJVX+VYY-XKmLQ0GaYndCVYnaFmoxk58GPgw@mail.gmail.com>
 <20210508144657.GC4038@breakpoint.cc> <20210513005608.GA23780@salvia>
In-Reply-To: <20210513005608.GA23780@salvia>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 13 May 2021 09:08:20 +0200
Message-ID: <CACT4Y+YhQQtHBErLYRDqHyw16Bxu9FCMQymviMBR-ywiKf3VQw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __nf_unregister_net_hook (4)
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 2:56 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Sat, May 08, 2021 at 04:46:57PM +0200, Florian Westphal wrote:
> > Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
> > >
> > > Is this also fixed by "netfilter: arptables: use pernet ops struct
> > > during unregister"?
> > > The warning is the same, but the stack is different...
> >
> > No, this is a different bug.
> >
> > In both cases the caller attempts to unregister a hook that the core
> > can't find, but in this case the caller is nftables, not arptables.
>
> I see no reproducer for this bug. Maybe I broke the dormant flag handling?
>
> Or maybe syzbot got here after the arptables bug has been hitted?

syzbot always stops after the first bug to give you perfect "Not
tainted" oopses.
