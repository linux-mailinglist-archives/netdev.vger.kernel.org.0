Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5BB28F929
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391460AbgJOTE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391452AbgJOTEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 15:04:53 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48375C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:04:52 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id m3so40219vki.12
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FsqHAs58x4trJhhHbsTmRDV/y8bm/KqBtxUEW7L/rUE=;
        b=YNNWaoUtxTP/GIofNOCaOHVKhI6pyeffEbAmx886qQVLDGA3jsArPDvJf/qbzSWmCc
         C5JfSYJSVtYWs6UJQCeHi99QiHWdoFYMYViyrs4GkHdbebB9lvRoT5MsmnuVEbrv5sQ5
         xyBdn1KZD+RztL6gagqXOC5GBULxTxnMWP+g3mewAA2K+kcEaPCupv4dBfWaESKTZ0q4
         F/jljeAcNeIyh+7o++HQGpupYtGu3HVDJc3LL7YW5gHdbei4cJBlby+rSSR2WQbMITIL
         Y200lB9YcKNGyyeCJEg3TIV4W7HQoW+8SvWycOmJ5NiqvujbAt6k1iobSf04Y5uPkCOq
         SULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FsqHAs58x4trJhhHbsTmRDV/y8bm/KqBtxUEW7L/rUE=;
        b=lKsFhRC6iisVd+kbJ2NFM7RKMt3GAPTI4RLgygGUXVR+JJ90y5hLYqbHCbusAm9RSh
         EmJmVFAYHY9Ba0Lt0dXmOFZ7KYh4+jqaeETskqxNfMpQw4USLxuByWXMjMd5/wNaaoyh
         mL2s21C37tC8mxuLQqMUgOxOW05n8qhrSR4Z5xud8sF3U8Gzps4KEuixuxIdBGZfzjG0
         d4STYknfNuLj9N+V8W/OOUh8biBCqfv+r5K8SUhYpi+VIHeXuCkDUviA1dXcoqjZddPM
         pA6C28fVJhyt6X+LdyZLQi+6yDZvvyKTvRbFMMo3GsuwFCkghR4v6lSQkwsKGpp/Powo
         gdSw==
X-Gm-Message-State: AOAM533RWgTivv+udz7dESiwQ7B4kLeGZEQ2yVnkh3r3JGEiFGJscvL1
        EzypryBM/nc8pIq1Pgqp9BbZlMJnMzc=
X-Google-Smtp-Source: ABdhPJyFqaHVD780tE6W7dg3oCR4R5rXAxgEONkobhPkpWje+IO2pmfwvQEtSaNQ0c9TF8iL1JtXNQ==
X-Received: by 2002:a1f:e384:: with SMTP id a126mr227984vkh.16.1602788690293;
        Thu, 15 Oct 2020 12:04:50 -0700 (PDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id m125sm30020vkh.15.2020.10.15.12.04.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 12:04:49 -0700 (PDT)
Received: by mail-vs1-f45.google.com with SMTP id b3so67276vsc.5
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:04:48 -0700 (PDT)
X-Received: by 2002:a67:d84:: with SMTP id 126mr3522829vsn.51.1602788688034;
 Thu, 15 Oct 2020 12:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201007101726.3149375-1-a.nogikh@gmail.com> <20201007101726.3149375-2-a.nogikh@gmail.com>
 <20201009161558.57792e1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4Y+ZF_umjBpyJiCb8YPQOOSofG-M9h0CB=xn3bCgK=Kr=9w@mail.gmail.com>
 <20201010081431.1f2d9d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4Y+aEQoRMO6eA7iQZf4dhOu2cD1ZbbH6TT4Rs_uQwG0PWYg@mail.gmail.com>
 <CADpXja8i4YPT=vcuCr412RYqRMjTOGuaMW2dyV0j7BtEwNBgFA@mail.gmail.com> <20201013095038.61ba8f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013095038.61ba8f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 15 Oct 2020 15:04:11 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf2kfvdYydXYJNCCfE62q9DXXOBMh_ZSO5W=L9GK478HA@mail.gmail.com>
Message-ID: <CA+FuTSf2kfvdYydXYJNCCfE62q9DXXOBMh_ZSO5W=L9GK478HA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Aleksandr Nogikh <a.nogikh@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 12:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 13 Oct 2020 18:59:28 +0300 Aleksandr Nogikh wrote:
> > On Mon, 12 Oct 2020 at 09:04, Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > On Sat, Oct 10, 2020 at 5:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Sat, 10 Oct 2020 09:54:57 +0200 Dmitry Vyukov wrote:
> > > > > On Sat, Oct 10, 2020 at 1:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > [...]
> > > > > > Could you use skb_extensions for this?
> > > > >
> > > > > Why? If for space, this is already under a non-production ifdef.
> > > >
> > > > I understand, but the skb_ext infra is there for uncommon use cases
> > > > like this one. Any particular reason you don't want to use it?
> > > > The slight LoC increase?
> > > >
> > > > Is there any precedent for adding the kcov field to other performance
> > > > critical structures?
> >
> > It would be great to come to some conclusion on where exactly to store
> > kcov_handle. Technically, it is possible to use skb extensions for the
> > purpose, though it will indeed slightly increase the complexity.
> >
> > Jakub, you think that kcov_handle should be added as an skb extension,
> > right?
>
> That'd be preferable. I understand with current use cases it doesn't
> really matter, but history shows people come up with all sort of
> wonderful use cases down the line. And when they do they rarely go back
> and fix such fundamental minutiae.
>
> > Though I do not really object to moving the field, it still seems to
> > me that sk_buff itself is a better place. Right now skb extensions
> > store values that are local to specific protocols and that are only
> > meaningful in the context of these protocols (correct me if I'm
> > wrong). Although this patch only adds remote kcov coverage to the wifi
> > code, kcov_handle can be meaningful for other protocols as well - just
> > like the already existing sk_buff fields. So adding kcov_handle to skb
> > extensions will break this logical separation.
>
> It's not as much protocols as subsystems. The values are meaningful to
> a subsystem which inserts them, that doesn't mean single layer of the
> stack. If it was about storing layer's context we would just use
> skb->cb.
>
> So I think the kcov use matches pretty well.

skb_extensions was the first thing that came to mind when I read this
patchset too. It is not specific to protocols.

We have long stopped growing sk_buff size.
