Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A52231F0ED
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBRUYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 15:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhBRUYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 15:24:35 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DE5C06178A;
        Thu, 18 Feb 2021 12:23:40 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 189so2072492pfy.6;
        Thu, 18 Feb 2021 12:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCnJivUm4N39ctfjAGVgyrNIuCixL1r+xFuOLgzirNM=;
        b=LGlxBJWgUjqiVvva2jCU2+C4ql9KVEQCzWLLpjFmlF2cy1LZht+aOBVM1CBWx1Ny24
         S0LT51ziI7SkZo3qBD7UP3Hgnq9OGCn7WuyYc5Ee/+dmZNf6vecwdINNaqDzJ+TGpr+D
         xsn3dakkPjj04tNPYsL5LLFTxlgUlPXyRTd62X2CeBnEJ9yQesH+jzeYNUNdpb2Vc9F7
         X4r/FoiaZSdr/Yw6CxYWa8xHJb3Mcnna4Uhla7FFW7rdu2a9jxmdJEycqJDzkl6rz61r
         pbeHch1uUmo6pzAF2uyq+Sfyw16sDG56D4hcQFCMn6juLtWyR6eDSZgI9NF2WV3EE5jp
         +V3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCnJivUm4N39ctfjAGVgyrNIuCixL1r+xFuOLgzirNM=;
        b=B9LBSTqwZTox6kk+rBru3f1n5URTMsOQIDNPHz6RTvPVaVlPFWmVIwSF2oVdKi8iOr
         sUg0KNcAoSGXrB8S0Zcwp8WFkeVZD7xlZopRA7wCzt08fvVULtZCC9iYCvqK+L3EF253
         fy5Ezmwm7R7OzXh8bbTxf7/mriNP1lARjIvh8z/7a9/7d7KDEgMvjQMwACpf89U/ekET
         HHM+TYfU48AQZpAFqEzYqKYh81L3hyVMOC1wukjQTKw3o3m8kDghW00MgYg4cR0jk2EW
         Fq4XAXWNRrGUQPeYpMqNxvavzyfkR3QrgguNrmG7RSZB7UIXN21d8QIlTskhtjaPImUk
         jf4w==
X-Gm-Message-State: AOAM533Bi+DCYg9rQjxpRxC0I4mYZy3GTPUQSkh5COI80hZonRDZaTYa
        2NI3kc0t3juh5T/U1Q32ksnYC7jdAvQtNdHSk5g=
X-Google-Smtp-Source: ABdhPJwCsu3k0NuMXcYpFsZCxvkwxF4NHxtY0aPWmrv0RKttIWXBOFmrnpTcT66V//zUC8JItBKY1hdn9GuV9Zwi+ck=
X-Received: by 2002:a63:587:: with SMTP id 129mr5461734pgf.233.1613679819838;
 Thu, 18 Feb 2021 12:23:39 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal> <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal> <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
In-Reply-To: <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 18 Feb 2021 12:23:28 -0800
Message-ID: <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 12:06 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Feb 18, 2021 at 11:55 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > This is how we write code, we use defines instead of constant numbers,
> > comments to describe tricky parts and assign already preprocessed result.
> >
> > There is nothing I can do If you don't like or don't want to use Linux kernel
> > style.
>
> So what is your suggestion exactly? Use defines or write comments?
>
> As I understand, you want to replace the "3 - 1" with "2", and then
> write comments to explain that this "2" is the result of "3 - 1".
>
> Why do you want to do this? You are doing useless things and you force
> readers of this code to think about useless things.
>
> You said this was "Linux kernel style"? Why? Which sentence of the
> Linux kernel style guide suggests your way is better than my way?

Nevermind, if you *really* want me to replace this "3 - 1" with "2"
and explain in the comment that the "2" is a result of "3 - 1". I'll
do this. I admit this is a style issue. So it is hard to argue and
reach an agreement. Just reply with a request and I'll make the
change. However I'm not able to agree with you in my heart.

On Thu, Feb 18, 2021 at 12:06 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Feb 18, 2021 at 11:55 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > This is how we write code, we use defines instead of constant numbers,
> > comments to describe tricky parts and assign already preprocessed result.
> >
> > There is nothing I can do If you don't like or don't want to use Linux kernel
> > style.
>
> So what is your suggestion exactly? Use defines or write comments?
>
> As I understand, you want to replace the "3 - 1" with "2", and then
> write comments to explain that this "2" is the result of "3 - 1".
>
> Why do you want to do this? You are doing useless things and you force
> readers of this code to think about useless things.
>
> You said this was "Linux kernel style"? Why? Which sentence of the
> Linux kernel style guide suggests your way is better than my way?
