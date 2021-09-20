Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A46412BDA
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351119AbhIUCi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344706AbhIUCbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:31:34 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8043C0610FD
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 13:20:06 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 72so35067828qkk.7
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 13:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nwb8sws83qiBjYRWLXUwymKTX8jpZrgBzxK2/HvqTK0=;
        b=h4HHdg8dfF1Gzx/Y17fwBPA7DpVJDyrNbA2IzuL2eYJKs+z40OMP+3kGqQOyCA2/gG
         JaoEjqctbZE/FSA8WaI6dKzP/A8Yy8IgUHwyKzCBcAndV6ixnU0Fjtt3KZhJ34lpqnqR
         TgtVEPUXNZQ9r4U/fbM+ll0DzllrWEakzgkFXtL3v2Jg9Vc/8h2rL/yzELcrRBaQzBSe
         weuZhORQRJUcqk9aYo3bOPs0GVwE7PMGqfVKjHgysmyXtwP+8/5KRRe/mqnOMs8nwEto
         6/JPPouL8t/NA+KttnJ+HoN/dS2IpDYD1GmIanrr/x0U5B8ScC+Y31eISf4jZYN9dB5K
         USvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nwb8sws83qiBjYRWLXUwymKTX8jpZrgBzxK2/HvqTK0=;
        b=iBs5FmJL2Yes9COLJ9fR28ymQD77M6c/7i2vlYVNF6fASAsonye1FBGKZIgl0tmTex
         69ZIIu4PV/3UDECi616IBc/OjOTmGMzYxuUDv3weXmBk7bxP6Xt5Dtrz8ZPTMv8w/2GE
         EBQ3F6xMqw+x2dLYZjvhnQZEPnUJl0LLCWYX5ChdMLXnf1AFm0rfZXvCYcu5Tia0KuXT
         0Wi7IU9PQkOv5AF2WbEpi/uXav1WO3qgfDmA7bMTOqW5wsdOR95OFZXjSpbVCiz3L6YE
         Kv55y1dzxdF1lcfZiaVqGCWpk5S5/WG8aghjsldUMvBTeKEBMcBnPiD3ZEuGjlZOPYGD
         ei0w==
X-Gm-Message-State: AOAM532Tf4nryHrX5Q5Shx6QlPCy4UDiIpNIsf7/oXYxOs7YId/SkFbs
        bt8eYLXDBkncrV3fuk+z+6qwDD2SQRM7JhDgu9x8nIG3QAA=
X-Google-Smtp-Source: ABdhPJy5CVVVboupb6eTpmulLHG88qpKZLyilSeNNZ+qfE5nOipqZjjoZF5KB9aQGE/3OxHPG7K+d5xWI2RonMVMLrs=
X-Received: by 2002:a25:7350:: with SMTP id o77mr32152152ybc.549.1632169205691;
 Mon, 20 Sep 2021 13:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
 <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMuHMdUeoVZSkP24Uu7ni3pUf_9uQHsq2Xm3D6dHnzuQLXeOFA@mail.gmail.com> <20210920121523.7da6f53d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210920121523.7da6f53d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 20 Sep 2021 22:19:53 +0200
Message-ID: <CANP3RGd5Hiwvx1W=UOCY166MUpLP38u5V6=zJR9c=FPAR52ubg@mail.gmail.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 9:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 18 Sep 2021 12:53:31 +0200 Geert Uytterhoeven wrote:
> > > Yeah.. more context here:
> > >
> > > https://lore.kernel.org/all/7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com/
> > >
> > > default !USB_RTL8152 would be my favorite but that probably doesn't
> > > compute in kconfig land. Or perhaps bring back the 'y' but more clearly
> > > mark it as a sub-option of CDCETHER? It's hard to blame people for
> > > expecting drivers to default to n, we should make it clearer that this
> > > is more of a "make driver X support variation Y", 'cause now it sounds
> > > like a completely standalone driver from the Kconfig wording. At least
> > > to a lay person like myself.
> >
> > If it can be a module (tristate), it must be a separate (sub)driver, right?
>
> Fair point.

The problem is CDCETHER (ECM) tries to be a generic driver that just
works for USB standards compliant generic hardware...
(similarly the EEM/NCM drivers)

There shouldn't be a 'subdriver'
