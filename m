Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E498B3FBE9F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbhH3V5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238674AbhH3V53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:57:29 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13566C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:56:35 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x27so34262004lfu.5
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C6YE7H5bkUAOn/FCZ5PtJHi+huiBz7klA5IL6wSh/pk=;
        b=Nxui/i+1+Cfa2tsydC8tKp3dxhqlW9kLtZpi2kFdgOT52PR+2tJdrJloi2qaADD/bX
         NhKYx/NsmISPo1XbRpBpJ6tEH9HM3/38//OU6EP4ri2KIabCqA8SukOI5EIFeUMpSZuv
         SvS4QyLRqlnQZc4cSNf3nVi/kjQjv6prthNhY8EnXTcgSI6gFwlk77013IY74kdpGIzQ
         oo3qCNxsdB2bkb90R4J+JjJL0KQvDC5tnnTLfpXcmUxvzIzQtL3JQBlvTChXBjWHKnC1
         K0dt7Hjjw2/ptyo75za0a15my9L20XvtciiFWH8Hf0UeKxJeNj6U6S42m4VziYhOqGEG
         aQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C6YE7H5bkUAOn/FCZ5PtJHi+huiBz7klA5IL6wSh/pk=;
        b=TntHJGH4y8y0gzOeTfc3+99/EkPwhMNsoPDDM83FtuYqZXRLi5+Nsoc9+9dsq44Gvr
         kn9F81KOPmtpnZaEf3E6t2kg0wxQQhfk17KKPTu5cCRUJlobXirfs3JFbKHVxyBB8RLE
         dzdWS10tq/q1VmcKGLIlz/Wj63q4bwHHxX+RUcqg99SFL6Mw75FqsoEMw6C2oY9xvosw
         OgVFbnCTBB2xzOrJcB44I4bcnQ7wzgTV0gJv1iliN1i7CaUbHZjWRiY6LsvQyqy3yRBd
         wt/wRPVPsOuYTxGCtg1snLf83rjDLSdliy6oIXOU/axU/gu9knxZUYQeOOCKttIDtrZq
         HsWw==
X-Gm-Message-State: AOAM530YTYrKUUWo23WBxGlheSZ7ZhUAegc7Sj03MhiRIL3OjR4V+kn1
        pk9Xgi32iAgdjoqAjI7yMdmycvAVVDWX8UI0hD4GWA==
X-Google-Smtp-Source: ABdhPJw+D390c7yOUfkvqeG1Jfiud30GS26CibkKL1kqUN3DdBK676NnbU49rd15oENlkXWZKXaLSZ/8WtoC48vDj/s=
X-Received: by 2002:ac2:5d4a:: with SMTP id w10mr19281206lfd.529.1630360593400;
 Mon, 30 Aug 2021 14:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210828235619.249757-1-linus.walleij@linaro.org> <20210830072913.fqq6n5rn3nkbpm3q@skbuf>
In-Reply-To: <20210830072913.fqq6n5rn3nkbpm3q@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 30 Aug 2021 23:56:22 +0200
Message-ID: <CACRpkdbVs9H8CPYV9Fgwje40qqS=wxXqVkDc=Du=c82eqeKCAw@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: tag_rtl4_a: Fix egress tags
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 9:29 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Sun, Aug 29, 2021 at 01:56:19AM +0200, Linus Walleij wrote:
> > I noticed that only port 0 worked on the RTL8366RB since we
> > started to use custom tags.
> >
> > It turns out that the format of egress custom tags is actually
> > different from ingress custom tags. While the lower bits just
> > contain the port number in ingress tags, egress tags need to
> > indicate destination port by setting the bit for the
> > corresponding port.
> >
> > It was working on port 0 because port 0 added 0x00 as port
> > number in the lower bits, and if you do this the packet gets
> > broadcasted to all ports, including the intended port.
> > Ooops.
>
> Does it get broadcast, or forwarded by MAC DA/VLAN ID as you'd expect
> for a regular data packet?

It gets broadcast :/

> > -     out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
>
> What was 2 << 8? This patch changes that part.

It was a bit set in the ingress packets, we don't really know
what egress tag bits there are so first I just copied this
and since it turns out the bits in the lower order are not
correct I dropped this too and it works fine.

Do you want me to clarify in the commit message and
resend?

Yours,
Linus Walleij
