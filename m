Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8D92025F1
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 20:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgFTSR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 14:17:56 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35672 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgFTSRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 14:17:55 -0400
Received: by mail-lj1-f194.google.com with SMTP id q19so15054228lji.2
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 11:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvNVjKHLtWO1dFhcir+/iDU+Lfgpi6JKmP8lzEdvB4E=;
        b=XZhtEb+0zgTmk7p1FKGgpCykCJGCR4QhBQlCJIvFhX2gO0uR1pqoBoOBIBXk8xm1oo
         nnYsLEAqabKP6xPYAXRe3MXkcyadqTMH+s5IProFdvebzb7pzQ6AkXwlDow2qmIdedzm
         oZw5CZPotJ22BL1wUHzVnLaBOGBVpYDODO31o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvNVjKHLtWO1dFhcir+/iDU+Lfgpi6JKmP8lzEdvB4E=;
        b=Hltifp0OnFarRNDKjZOnHC4PmqrQO0ZU1rVhgDRmb3COOQbE7kp7QLNJRbnt1m8tKF
         RjEV2Ip0TZ75ocSQNqAcDkHiUEoBetDXC5xr2Q0zFGoIaD3L/l4EVl7Qr8/ud+B4tcqo
         5xYfC4kiEEbyTgi7EvwKicEsu8wCXhqCn/JrtTjH6KBq8TpM7aqkul8ln9SkqvCqso9x
         clZxDC5jbt4aOEItorhVfQ5bAmY0GYs62uIMAhzvBe8e/OWUa+CIjOr711bIuB5CjuhK
         UizXb3UOyBEzOadiznhxsQk5WDtpO1Qge+HUsm7EALGaEVZj472I4NZZ01h7tndD3phK
         s1qw==
X-Gm-Message-State: AOAM532mVYGVGSV7Zl/IREqV28zQKUqdeCk6rpSgLdb6glJSevrtoIHs
        ntGRwLv9BLDfrAzyK7xBYBuDuqRbtdY=
X-Google-Smtp-Source: ABdhPJwImdvqDJdtdEOg4v9vz5lwIlPWVXBRRDm/hxYFtDbjwCE+obp7zvDKLo79+20XW8DM8d7okw==
X-Received: by 2002:a2e:7219:: with SMTP id n25mr4398615ljc.168.1592677012733;
        Sat, 20 Jun 2020 11:16:52 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id a23sm2220005lfb.10.2020.06.20.11.16.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 11:16:51 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id u25so7400216lfm.1
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 11:16:51 -0700 (PDT)
X-Received: by 2002:a19:ae0f:: with SMTP id f15mr5206631lfc.142.1592677011252;
 Sat, 20 Jun 2020 11:16:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200618210645.GB2212102@localhost.localdomain>
 <CAHk-=whz7xz1EBqfyS-C8zTx3_q54R1GuX9tDHdK1-TG91WH-Q@mail.gmail.com> <20200620075732.GA468070@localhost.localdomain>
In-Reply-To: <20200620075732.GA468070@localhost.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 20 Jun 2020 11:16:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjt=mTBqymWuRYeiXQxdEdf6si_it=Yzm7KR62ws0vknw@mail.gmail.com>
Message-ID: <CAHk-=wjt=mTBqymWuRYeiXQxdEdf6si_it=Yzm7KR62ws0vknw@mail.gmail.com>
Subject: Re: [PATCH] linux++, this: rename "struct notifier_block *this"
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 12:57 AM Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> > If you want to build the kernel with C++, you'd be a lot better off just doing
> >
> >    /* C++ braindamage */
> >    #define this __this
> >    #define new __new
> >
> > and deal with that instead.
>
> Can't do this because of placement new.

Can you explain?

> > Because no, the 'new' renaming will never happen, and while 'this'
> > isn't nearly as common or relevant a name, once you have the same
> > issue with 'new', what's the point of trying to deal with 'this'?
>
> I'm not sending "new".

My point about 'new' is that

 (a) there's a lot more 'new' than 'this'

 (b) without dealing with 'new', dealing with 'this' is pointless

So why bother? Without some kind of pre-processing phase to make our C
code palatable to a C++ parser, it will never work.

And if you _do_ have a pre-processing phase (which might be a #define,
but might also be a completely separate pass with some special tool),
converting 'this' in the kernel sources isn't useful anyway, because
you could just do it in the pre-processing phase instead.

See? THAT is why I'm harping on 'new'. Not because you sent me a patch
to deal with 'new', but because such a patch will never be accepted,
and without that patch the pain from 'this' seems entirely irrelevant.

What's your plan for 'new'? And why doesn't that plan then work for 'this'?

              Linus
