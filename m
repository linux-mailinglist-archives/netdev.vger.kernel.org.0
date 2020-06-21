Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B30202A41
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgFULTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbgFULTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 07:19:46 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB4BC061794;
        Sun, 21 Jun 2020 04:19:45 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id c4so2829574iot.4;
        Sun, 21 Jun 2020 04:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=suTt0pS+l/ysHThYP3Io+1qHv2Z1U36c1O0c2IABO4g=;
        b=VvgZXG3lHfi+DkyCn2tooxxccvdrGVA/0xdHILF/nGY+oCrZG39AT/DCqdGnWlScdG
         dIndfQpyOaJGhuiKl45InjW9VFoNue6unWwxUHrER/iSRtZ1MMH8pnO1dd1GMBzVpko9
         GWJ6cvASrkBXAcJna/GOwtERv8m5BgDOWA6jX8pXIQqhGjSg/Gt9/f6hmXi/K2lK9GWf
         OXTB9Gc4CdGMQxSvSALp7tCQJwvqvCN4PJF/PMxf1DZdZO4ICvuS2j3JlvLrRptXbgmE
         vrY5GgRkF13JhkHZou9NvqLVp/05hSOYUTZcbf7bO80VXj2qhfg5jGppbbAne16Bx5Lj
         HcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=suTt0pS+l/ysHThYP3Io+1qHv2Z1U36c1O0c2IABO4g=;
        b=a6CDhYVs07d/DMmP8dCR9Cu+uStULrSGJozoB1SFQgafcg30uykGxyEFa2nFvQCzBS
         Tw7Zbs1rKmu6tFpauYJRq38v4cRIuq/FyydOXDhTEYN4RHo+rNUslt7PfDqEDOZY3EzN
         TP5lwF2UHPUPDibEtXm+hP0RyF0KWC+454K78h8C6lJnj4a96TJQK/zsRxauqPVVgbft
         Q3GvOqVxKNzLhAXLWTOp7w+ezkqX1elqbTbSiwwhCOiYCVGxDxO18+CFt607N5xUTuzF
         L5lxXxElGEKbY5Ft21V8Ip9/2R6rYcZAlJq0YI5t3sVH9xEGCxn1wwVQ+3K4mNSQN7BR
         ilew==
X-Gm-Message-State: AOAM5327p2m9p6St6QgBgHDXjrEYD8RuyKlq5tqHHOrHHgjdaoj8n67e
        huCXglDrcZ0KX7R/ZhzJN0kbCYcFcjtGpDF/ta4=
X-Google-Smtp-Source: ABdhPJwk2TL8Y73HRouNrfYM3rnZ6QtfQz9eowB6OyBY1KBXFqE7GIYQ7KtS3mUJ9kC/GaD51ebRPe4FWY2mcTK6eMA=
X-Received: by 2002:a6b:740a:: with SMTP id s10mr13450032iog.107.1592738384231;
 Sun, 21 Jun 2020 04:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200618190807.GA20699@nautica> <20200620201456.14304-1-alexander.kapshuk@gmail.com>
 <20200621084512.GA720@nautica> <CAJ1xhMWe6qN9RcpmTkJVRkCs+5F=_JtdwsYuFfM7ZckwEkubhA@mail.gmail.com>
 <20200621105645.GA21909@nautica>
In-Reply-To: <20200621105645.GA21909@nautica>
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date:   Sun, 21 Jun 2020 14:19:07 +0300
Message-ID: <CAJ1xhMVnvbX543YxNSTMgjTM1afcHvF98_wd8G1LQ0mDemgo3A@mail.gmail.com>
Subject: Re: [PATCH] net/9p: Validate current->sighand in client.c
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     lucho@ionkov.net, ericvh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 1:57 PM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> Alexander Kapshuk wrote on Sun, Jun 21, 2020:
> > Thanks for your feedback.
> > Shall I simply resend the v2 patch with the commit message reworded as
> > you suggested, or should I make it a v3 patch instead?
>
> Yes please resend the same commit reworded. v2 or v3 doesn't matter
> much, the [PATCH whatever] part of the mail isn't included in the commit
> message; I don't receive so much patches to be fussy about that :)
>
Understood. Thanks. :)


> > One other thing I wanted to clarify is I got a message from kernel
> > test robot <lkp@intel.com>,
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/TMTLPYU6A522JH2VCN3PNZVAP6EE5MDF/,
> > saying that on parisc my patch resulted in __lock_task_sighand being
> > undefined during modpost'ing.
> > I've noticed similar messages about other people's patches on the
> > linux-kernel mailing list with the responses stating that the issue
> > was at the compilation site rather than with the patch itself.
> > As far as I understand, that is the case with my patch also. So no
> > further action on that is required of me, is it?
>
> Thanks, I hadn't noticed this mail -- unfortunately I don't have
> anything setup to test pa risc, but __lock_task_sighand is defined in
> kernel/signal.c which is unconditionally compiled so shouldn't have
> anything to do with arch-specific failures, so I will run into the same
> problem when I test this.
>
> From just looking at the code, it looks like a real problem to me -
> __lock_task_sighand is never passed to EXPORT_SYMBOL so when building 9p
> as a module we cannot use the function. Only exported symbols can be
> called from code that can be built as modules.
>
> That looks like an oversight to me more than something on purpose, but
> it does mean I cannot take the patch right now -- we need to first get
> the symbol exported before we can use it in 9p.
>
>
> As things stand I'd rather have this patch wait one cycle for this than
> revert to manipulating rcu directly like you did first -- if you're up
> for it you can send a patch to get it exported first and I'll pick this
> patch up next cycle, or I can take care of that too if you don't want to
> bother.
>
> Letting you tell me which you prefer,
> --
> Dominique

I am willing to send in a patch to have the missing symbol exported as
well as resend my previous one with the commit message reworded.
Thanks.
