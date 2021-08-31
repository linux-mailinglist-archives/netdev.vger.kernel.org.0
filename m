Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486253FCCFF
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 20:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhHaSgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 14:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhHaSgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 14:36:18 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB200C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:35:18 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id s3so290833ljp.11
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QV218J3T9eJ8kIUA8zvGkWzAmy7P7pzqsDTRqvc5QCA=;
        b=UOx1eaAY/fmUSXcdzH1SoVTKTRpKjOyzrt+lkWqZM5ajH9LEGuzOc6w64GS6PEUq1t
         8WLpORQIwdoIzJlOsWwTnZwYt9d1itzG8W4gGzCWT0E9GW63P1nZgLsFVNLlz2/siEK9
         3UsM5XirbmBxGD49UbY+bKJyR3tccV0l+AFPzaX4uRhNZL5DfLHX8ftkvH1p3018zU+D
         nFSLV6ofV5luevHY84nf7SIUhbr/tpfW2NfaHbxQkOn8jcTYmImWmkCvV+fyrhlb9YYT
         AF6rp74EsdJDg8D4d6QV9mVfgecdrje+XM94S4FldwDoUA7FH2vhK2FBw1cU71UWqC66
         20xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QV218J3T9eJ8kIUA8zvGkWzAmy7P7pzqsDTRqvc5QCA=;
        b=L/kUNS4pB9XkAroyh/D0myMLRL0OpyhVn5oNnfr6ownFmUCL1jq4Mbq+4FagTlr4pQ
         3MyCw316/P1nk5jtkkagANRuDcI4MgaEEzycfKBcFU2Vcm9ZcPlxa0Nyrz0GWctFcDPa
         LHFe99KSLRuih8Ib3V3d/uacmU+YfSDAqVT4beicE59tEbTBL5IyUHG743ltae/Y8vng
         ZtlR/rW2TiiuOr3Rb8P3bLrK9UQnJD3+mwHTPOhWNBIJX6brfNhmkc89EeONtHdhuTBs
         34biv8zMcUd2pvUBE+TfMfyFvHu4mFwPc5JkuPO4XrujptEJmykR6j7BoWbwH9MS3ys6
         QkcA==
X-Gm-Message-State: AOAM532jI0XqICM9VCslRy9I5x+SNbjHyvQ9LCknNAlehs6F3TilaDlW
        y7QZazkkD/b6/N5ZatdpnRC9YhuYSS7c5k2aD1TTgQ==
X-Google-Smtp-Source: ABdhPJyatgkcydlVdMajBj6cbP38rDPB7M3MVj8aNy6nu4XyGfjDCrZtNvtQR9euL8mOlNjejN+jQGnEfDzN8dx7xzo=
X-Received: by 2002:a2e:9d88:: with SMTP id c8mr25947200ljj.467.1630434917097;
 Tue, 31 Aug 2021 11:35:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210828235619.249757-1-linus.walleij@linaro.org>
 <20210830072913.fqq6n5rn3nkbpm3q@skbuf> <CACRpkdbVs9H8CPYV9Fgwje40qqS=wxXqVkDc=Du=c82eqeKCAw@mail.gmail.com>
 <20210830222007.2i6k7pg72yuoygwh@skbuf>
In-Reply-To: <20210830222007.2i6k7pg72yuoygwh@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 31 Aug 2021 20:35:05 +0200
Message-ID: <CACRpkdbX4XErV-7UCezobF4jLX-HvjMHE=dnYYLqD5Sb8LkCpw@mail.gmail.com>
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

On Tue, Aug 31, 2021 at 12:20 AM Vladimir Oltean <olteanv@gmail.com> wrote:

> > > Does it get broadcast, or forwarded by MAC DA/VLAN ID as you'd expect
> > > for a regular data packet?
> >
> > It gets broadcast :/
>
> Okay, so a packet sent to a port mask of zero behaves just the same as a
> packet sent to a port mask of all ones is what you're saying?
> Sounds a bit... implausible?
>
> When I phrased the question whether it gets "forwarded by MAC DA/VLAN ID",
> obviously this includes the possibility of _flooding_, if the MAC
> DA/VLAN ID is unknown to the FDB. The behavior of flooding a packet due
> to unknown destination can be practically indistinguishable from a
> "broadcast" (the latter having the sense that "you've told the switch to
> broadcast this packet to all ports", at least this is what is implied by
> the context of your commit message).
>
> The point is that if the destination is not unknown, the packet is not
> flooded (or "broadcast" as you say). So "broadcast" would be effectively
> a mischaracterization of the behavior.

Oh OK sorry what I mean is that the packet appears on all ports of
the switch. Not sent to the broadcast address.

> Just want to make sure that the switch does indeed "broadcast" packets
> with a destination port mask of zero. Also curious if by "all ports",
> the CPU port itself is also included (effectively looping back the packet)?

It does not seem to appear at the CPU port. It appear on ports
0..4.

> > > > -     out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
> > >
> > > What was 2 << 8? This patch changes that part.
> >
> > It was a bit set in the ingress packets, we don't really know
> > what egress tag bits there are so first I just copied this
> > and since it turns out the bits in the lower order are not
> > correct I dropped this too and it works fine.
> >
> > Do you want me to clarify in the commit message and
> > resend?
>
> Well, it is definitely not a logical part of the change. Also, a bug fix
> patch that goes to stable kernels seems like the last place to me where
> you'd want to change something that you don't really know what it does...
> In net-next, this extra change is more than welcome. Possibly has
> something to do with hardware address learning on the CPU port, but this
> is just a very wild guess based on some other Realtek tagging protocol
> drivers I've looked at recently. Anyway, more than likely not just a
> random number with no effect.

Yeah but I don't know anything else about it than that it appear
in the ingress packets which are known to have a different
format than the egress packets, the assumption that they were
the same format was wrong ... so it seems best to drop it as well.
But if you insist I can defer that to a separate patch for next.
I just can't see that it has any effect at all.

Yours,
Linus Walleij
