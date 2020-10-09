Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748AA2886A9
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387559AbgJIKP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgJIKP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:15:27 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8A4C0613D2;
        Fri,  9 Oct 2020 03:15:26 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id i2so9070433ljg.4;
        Fri, 09 Oct 2020 03:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MSRJBnhRdQQ8GN9vZCV3kAUl0v/Or166lRQaXemEiV4=;
        b=blXbEMInMk+ia+hm8apj0WC11aVFlmdKnpWlwf+nr5OlRfbABXeWCR73RPzR6EBrBw
         fyoDkSZn+KOCpv/UPJuRA3fTF/Udb2Jp+tpcE0zYl9djrGWrXJ5m/3VfTAUOc8nsX78p
         YXkSmdaaEHOAiXNs6tdFiVns8I8UAb4prVflfq5kSbjaevybwjxVxbCc4EZOB0k4nvEQ
         n/U3rK/b4rZ8pXM/Hyl+i2FRq5qoXPuIEWsqiPfuJmXdjasZO1mecLGIPyR0JKW5eq/7
         Hesy0HEmsqi4WGWAmSdgcO7RbkdUQMiSc8m0YTzt0Pc1nV86k8uToMm72wQy0mGrUtJP
         mPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MSRJBnhRdQQ8GN9vZCV3kAUl0v/Or166lRQaXemEiV4=;
        b=da/srZaUDJm2V+ACbRTbIoKl3Vn8Ao7bMO18vE/UX5uK5uBbYMdUzy/A3fk//bGsLF
         TIKyTFKnNCzkmVrXpD5aAW878QTtYBapJvEAwQKZ0Ncmfgtd/WuIINnj43Jj+VbP7HFQ
         EERp0Kuq9cLka3j+KM3gxOI7LuNAmOT8kb2zIZ+66KQTWBdDUIKfLneXRgpwMGBiBc/G
         QX3KRzQhbMVy9u4NTxSSeyyqY9Gm3Qhj1MqbtRKQCI2wXQzvmJaZQN8K9dNRpvS4qldd
         uJJb9edyT/wr9iqIEFeC1K5nJJSJiWm8oKHaCCnvgWxBeTkncFjYIB0zTHiLmDwTNk1y
         fyrQ==
X-Gm-Message-State: AOAM532AcNRfLxuSt9C93yc0MAtQ2tnw2pqmZXtWLAuijED0Vr5IboJ3
        enCoT5QGOO8QHj/4dCPwUXv2QQrmopqybRrHqao=
X-Google-Smtp-Source: ABdhPJw/NFiuu+WVoaJKIREq/HxSEjdL4CKpKn+95hnZ68YvTFM0uFIFBeLwPucQroSaQjGv/WrtZ1pEwnc8bOHBiPU=
X-Received: by 2002:a2e:9612:: with SMTP id v18mr4579428ljh.255.1602238525006;
 Fri, 09 Oct 2020 03:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20201008155048.17679-1-ap420073@gmail.com> <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
 <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
 <87v9fkgf4i.fsf@suse.de> <fd8aaf06b53f32eae7b5bdcec2f3ea9e1f419b1d.camel@sipsolutions.net>
In-Reply-To: <fd8aaf06b53f32eae7b5bdcec2f3ea9e1f419b1d.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 9 Oct 2020 19:15:14 +0900
Message-ID: <CAMArcTUdGPH5a0RTUiNoLvuQtdnXHOCwStJ+gp_noaNEzgSA1Q@mail.gmail.com>
Subject: Re: [PATCH net 000/117] net: avoid to remove module when its debugfs
 is being used
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Nicolai Stange <nstange@suse.de>,
        David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 at 16:45, Johannes Berg <johannes@sipsolutions.net> wrote:
>

Hi Johannes,
Thank you for the review!

> On Fri, 2020-10-09 at 07:09 +0200, Nicolai Stange wrote:
> > Johannes Berg <johannes@sipsolutions.net> writes:
> >
> > > On Thu, 2020-10-08 at 15:59 +0000, David Laight wrote:
> > > > From: Taehee Yoo
> > > > > Sent: 08 October 2020 16:49
> > > > >
> > > > > When debugfs file is opened, its module should not be removed until
> > > > > it's closed.
> > > > > Because debugfs internally uses the module's data.
> > > > > So, it could access freed memory.
> > > > >
> > > > > In order to avoid panic, it just sets .owner to THIS_MODULE.
> > > > > So that all modules will be held when its debugfs file is opened.
> > > >
> > > > Can't you fix it in common code?
> >
> > Probably not: it's the call to ->release() that's faulting in the Oops
> > quoted in the cover letter and that one can't be protected by the
> > core debugfs code, unfortunately.
> >
> > There's a comment in full_proxy_release(), which reads as
> >
> >       /*
> >        * We must not protect this against removal races here: the
> >        * original releaser should be called unconditionally in order
> >        * not to leak any resources. Releasers must not assume that
> >        * ->i_private is still being meaningful here.
> >        */
>
> Yeah, found that too now :-)
>
> > > Yeah I was just wondering that too - weren't the proxy_fops even already
> > > intended to fix this?
> >
> > No, as far as file_operations are concerned, the proxy fops's intent was
> > only to ensure that the memory the file_operations' ->owner resides in
> > is still valid so that try_module_get() won't splat at file open
> > (c.f. [1]).
>
> Right.
>
> > You're right that the default "full" proxy fops do prevent all
> > file_operations but ->release() from getting invoked on removed files,
> > but the motivation had not been to protect the file_operations
> > themselves, but accesses to any stale data associated with removed files
> > ([2]).
>
> :)
>
> I actually got this to work in a crazy way, I'll send something out but
> I'm sure it's a better idea to add the .owner everywhere, but please
> let's do it in fewer than hundreds of patches :-)
>
Okay, as you mentioned earlier in 001/117 patch thread,
I will squash patches into per-driver/subsystem then send them as v2.

Thanks a lot!
Taehee
