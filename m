Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFCA2A1AD2
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgJaVls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgJaVlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 17:41:47 -0400
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24DD92076D;
        Sat, 31 Oct 2020 21:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604180507;
        bh=C1phg8mElzHBrp6jWm/P3Py/2QR/sFCWl19as/wD9cQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qIyVT/60Y18+c2u9JEdyJJso6ZZXJqO3aw2RgDG5XI1HRnV8zVT8kKrEUubQleG0E
         l1TZdQzVPE8+xbvSyuJvRajFYDdXR7PwdF1JllbYFyjKoTGx6bcmhaeGfE9vc/WaHI
         MEQlMW64WXnS8tq8JdbRyJBHzorKqD6pVL5iW0rs=
Received: by mail-qk1-f176.google.com with SMTP id b18so8291178qkc.9;
        Sat, 31 Oct 2020 14:41:47 -0700 (PDT)
X-Gm-Message-State: AOAM531L+pCDL6b9SHKmrAVy8aX9gc7l8laQQvyH8zjUE8AacT+CPDWn
        1wW3GmRHv+7iQIe+IJjmbJ7tYP/BrRv34tPG16c=
X-Google-Smtp-Source: ABdhPJyVNchTwjs0Cqi50vP88wDfM8ehWQMw6xI76ZHKCLBRK78s1puoYTDv/01WehOX7mK5dhhnmnUxd81qlfxHSpw=
X-Received: by 2002:a37:4e57:: with SMTP id c84mr8539711qkb.394.1604180506363;
 Sat, 31 Oct 2020 14:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201028070504.362164-1-xie.he.0141@gmail.com>
 <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com> <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 31 Oct 2020 22:41:30 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1kJT50s+BVF8-fmX6ctX2pmVtcg5rnS__EBQvseuqWNA@mail.gmail.com>
Message-ID: <CAK8P3a1kJT50s+BVF8-fmX6ctX2pmVtcg5rnS__EBQvseuqWNA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 30 Oct 2020 22:10:42 -0700 Xie He wrote:
> > > The usual way of getting rid of old code is to move it to staging/
> > > for a few releases then delete it, like Arnd just did with wimax.
> >
> > Oh. OK. But I see "include/linux/if_frad.h" is included in
> > "net/socket.c", and there's still some code in "net/socket.c" related
> > to it. If we move all these files to "staging/", we need to change the
> > "include" line in "net/socket.c" to point to the new location, and we
> > still need to keep a little code in "net/socket.c". So I think if we
> > move it to "staging/", we can't do this in a clean way.
>
> I'd just place that code under appropriate #ifdef CONFIG_ so we don't
> forget to remove it later.  It's just the dlci_ioctl_hook, right?
>
> Maybe others have better ideas, Arnd?

I think it can just go in the bin directly. I actually submitted a couple of
patches to clean up drivers/net/wan last year but didn't follow up
with a new version after we decided that x.25 is still needed, see
https://lore.kernel.org/netdev/20191209151256.2497534-1-arnd@arndb.de/

I can resubmit if you like.

      Arnd
