Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF69368BE3
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhDWERJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDWERI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:17:08 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D602EC061574;
        Thu, 22 Apr 2021 21:16:30 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id p15so3946817iln.3;
        Thu, 22 Apr 2021 21:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hPK7cG0zjnt5TeP27jRXX6nUc9rgjxQfRBDSkb6etdM=;
        b=ABcxNFaWRXA4+Ao/XLy8ex+as4Wjge2NpRvhfycyIe7eGjGf4seefFjFm0WmD0a6Cz
         1KgTFlKnijJARlQmdE+klWSDWuEub8losRomhubAH8aBhUpfG/xpd3yjDuyvJzYvnktn
         UdsnoXiA0F/iZm9aKAvvhzm6hy2WFWHRUt62GHL5rwHr797FihDR0iQPfG2cehhAl5WE
         XiPLowo/rxLwwVxf7Yg/no8y4i8sX8nmGG4nXNfr0qtuqB3GanmxUYA6xdSBeaHDCgEj
         6ZHBb0g/cx3b68Uo7eSZ7qoCKHlgAD4RlrKb9KApXxhugluA+tVUxQgpxbKhGcDoJMzR
         1Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hPK7cG0zjnt5TeP27jRXX6nUc9rgjxQfRBDSkb6etdM=;
        b=NVOKjISIGBVwC1SySC74oovpjQU6V41++dQ4pJfVz1Em4byIPy9duOhtzi3ZIa0eRv
         NXKvGdRuxaEfZ+g36tN/TlzvnVXa7qZay62xHpkO+Zq58nl+MHJkifsTpS37Um78nhHL
         vBu7tbAsKGb9ddJfXMGeeGR+gurfnF3PG/e9hPnrBLYFqF9gBsgcVkH4YrhA1eftfHml
         Yl6gNCIPcypuZOw6xfcDIQMWTiW4dtvRW402DnFn3DvZwnQOcei+A+TNStZCSiMu0SH2
         arqTmzsjrqO3kiGL+9bVYwgtGQGKuiE6XM+mz+SIELoROgxf70I7guNwkCUjTS2T15d1
         49Mg==
X-Gm-Message-State: AOAM530//4HzpkpUkFY2oxcB1Ev72TvcYdldwuvHm0j5hsOUfXkZLLo8
        DOlE+szsn/fpOTAAkTGyxxNXu6E97X+AL81kk5U=
X-Google-Smtp-Source: ABdhPJwGHyGyExbKWugTt390DWihZsZ7YnfgC0bSUbNtiC0PmUmYeiHfmohSfuyl01ciyvNB11XHGySHTPoN2BBs3Rc=
X-Received: by 2002:a05:6e02:d41:: with SMTP id h1mr1395747ilj.0.1619151390373;
 Thu, 22 Apr 2021 21:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
 <20210422040914.47788-6-ilya.lipnitskiy@gmail.com> <d96206db-96e2-1eb7-6b19-47c9596ccfea@nbd.name>
In-Reply-To: <d96206db-96e2-1eb7-6b19-47c9596ccfea@nbd.name>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Thu, 22 Apr 2021 21:16:19 -0700
Message-ID: <CALCv0x0dRPDsrkNYOgWW-+rFj_7ysNfj+x_2AmFRa0f3No2YZg@mail.gmail.com>
Subject: Re: [PATCH net-next 05/14] net: ethernet: mtk_eth_soc: reduce MDIO
 bus access latency
To:     Felix Fietkau <nbd@nbd.name>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:33 AM Felix Fietkau <nbd@nbd.name> wrote:
>
>
> On 2021-04-22 06:09, Ilya Lipnitskiy wrote:
> > From: Felix Fietkau <nbd@nbd.name>
> >
> > usleep_range often ends up sleeping much longer than the 10-20us provided
> > as a range here. This causes significant latency in mdio bus acceses,
> > which easily adds multiple seconds to the boot time on MT7621 when polling
> > DSA slave ports.
> >
> > Use udelay via readx_poll_timeout_atomic, since the MDIO access does not
> > take much time
> >
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > [Ilya: use readx_poll_timeout_atomic instead of cond_resched]
> I still prefer the cond_resched() variant.
No problem, I will respin with your original change. Looks like we
can't take advantage of iopoll.h routine in this case, but that's not
the end of the world!

> On a fully loaded system, I'd
> prefer to let the MDIO access take longer instead of wasting cycles on
> udelay.
>
> - Felix

Ilya
