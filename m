Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401622AA97C
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 06:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgKHF2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 00:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgKHF2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 00:28:49 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DCFC0613CF;
        Sat,  7 Nov 2020 21:28:48 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id r186so4215499pgr.0;
        Sat, 07 Nov 2020 21:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v7uO+4tymTzpGaO0kxRYzy6la1dUIrl8lP4+3AeMlpM=;
        b=DqFR5FawS/AQuqh/HAmfkEgzPh3P4GYc+AikwrifEDm27ZOOczPg2bGbirjr3XuDnh
         Tp7hTt2UM598yigXJ93850W4mOxkmACnJ17hU7Unc5LiLq60D/W3Rg2EtooQFwfF6wKA
         nGuyx2ukwdMet8kmDLDDbcuBDkHsIowx2eaBP2VqhxVlr2tMwgjA4g0ks/PBkf9iN5zo
         /36UIrLcteQhpz01xXAS9An/SUL0cHp7sxODjDdDAGga0IScmx0uuNGPA5QrfX5+f6B+
         IrNiRxuVMTNYxzYUl+EGbkzNqU3AJW6GM3jYF2+XQlMFVf5Hr2i87Qz7144FvlA9ck3d
         i/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v7uO+4tymTzpGaO0kxRYzy6la1dUIrl8lP4+3AeMlpM=;
        b=h9j/weIhDftP4efiEYsiDx0yo583oY7OvQlEVYeYUG7Q609i3gnzJvEd6FXPaY8cAe
         v+Q8D6AaZsu5z+MI8uEu3iqCY59vX/2cv7V3TpIOK38v1CjZTy1OnBh+/HxRXN5jAIYO
         nwYOp+ZCvQHZMqWMVWk8lWQUcFi3LIab2UFn2z9HoHZmD9GvRfCAfaPCnRFv4+neJbVV
         PIWmzyDgzISGfpW+Mu5Qd1/eySkVNuumzrENyrE8m3rIYTE10srp0kCkUlGcsi0GrD7+
         IgbniTz8F1KfH9NuybrPoMgW2gJ9OYwOrgX5SRbVD99rjbEPYc+wngT6CXu9TyiFCiaw
         8a4A==
X-Gm-Message-State: AOAM5311kU96PuMJF7x99+eYz4l5rjn8/r7b+/HgcuY7J8d4sgfT0tZn
        CNpW+l6M4ehm/aPq4NsLM38scpw/lzCirHBV1Vw=
X-Google-Smtp-Source: ABdhPJxP0gMBi4LZoJKrRAHoLhqd3uVGpSJAGvARPxdjIz9wGwCk3Uj8Y+vC4aKAjIhnJwE9Lz9sZZPL6Q4lKaXJtY0=
X-Received: by 2002:a65:52cb:: with SMTP id z11mr8020662pgp.368.1604813328575;
 Sat, 07 Nov 2020 21:28:48 -0800 (PST)
MIME-Version: 1.0
References: <20201028070504.362164-1-xie.he.0141@gmail.com>
 <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com>
 <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAK8P3a1kJT50s+BVF8-fmX6ctX2pmVtcg5rnS__EBQvseuqWNA@mail.gmail.com> <20201031150359.0f944863@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031150359.0f944863@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 7 Nov 2020 21:28:37 -0800
Message-ID: <CAJht_EMzCpNKOwuZgxKz0nPbA=zkq-Jz30ddhYbVOyrj072x1A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
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

On Sat, Oct 31, 2020 at 3:04 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 31 Oct 2020 22:41:30 +0100 Arnd Bergmann wrote:
> >
> > I think it can just go in the bin directly.
>
> Ack, fine by me.
>
> > I actually submitted a couple of patches to clean up drivers/net/wan
> > last year but didn't follow up with a new version after we decided
> > that x.25 is still needed, see
> > https://lore.kernel.org/netdev/20191209151256.2497534-1-arnd@arndb.de/
> >
> > I can resubmit if you like.
>
> Let's just leave it at DLCI/SDLA for now, we can revisit once Dave
> is back :)

Hi Arnd,

Can you resubmit your patch to delete the DLCI / SDLA drivers? I
really want them to be deleted. Thank you so much!
