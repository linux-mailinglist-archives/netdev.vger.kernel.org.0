Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC88346EEC
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCXBf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhCXBfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:35:09 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E901C061763;
        Tue, 23 Mar 2021 18:35:09 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id d10so13187470ils.5;
        Tue, 23 Mar 2021 18:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WnbdkW31AZCP279wJrfi61OFtaM3U9OB5n7/54JuxrY=;
        b=PYRfhkFTr4vk6INv4PYQuWF+RqvtGa5xvbf1Fn/PAg9dHoKUylnWVdVYFim2HQOwEA
         Uw50j7qBVIwWgSd51qKqlt9lOSsJPWsot9chCQYr9QH/u+xl+E43Dr/+21AFnF5MlaA4
         d/91gX33AAneBrz3TTKDVGpYgZluc3DWfTUctbqkku5tuceYsUacreyRs18QrxlKsHxT
         QY8KVHJi10M3zQfefYEjQKluan1uqVeLp5N0mU2uPb0jGKI3rvvj7xEUzD1+PeoQM3XA
         DgZtKZ7WroIJsB1CgMJwciErr3o9IZX75nfLDRVUQ7OuGMwsNt0yPdiC9i4K5Uv3S+jg
         Wk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WnbdkW31AZCP279wJrfi61OFtaM3U9OB5n7/54JuxrY=;
        b=lnC0ouLHSkIuy97h4hd5SMSdi8VpZojMdmiqR/J2dgbdRpSNSAEDK6FkxnJux1/Njh
         W0AgBqeFDhlVOzSNp28gz6WnUpRd5wRH3mn46A3gv4j+HQJZloVkpj3JuzB/q9Ae5tPb
         VbbA1j4CCqca8Q49QQHTlf0ILOieS+L0vLTTomBNzr4sbbENZs4iTcluqMjEgN1lAyd2
         L0cgP7ME0DljPQ7egNgS2QtUTCrwP79mPJyShUtAMdUunyVEYVYDIJa2SvAR4gXfDz66
         EeqzcVtqz2s/1rTsEaxU/V08OGlBuyQ6/WjCdOYGmrtO8dV8RukBnzNOVkejUujz1sgz
         vChQ==
X-Gm-Message-State: AOAM531fZY999gp6conhDCtKt0Js6SZAMn7psn7F0eFcqTiblqcJteDX
        olCHZI5cEQvOv0TXt4N8yjYEyOTak7Wa4Ulwqbc=
X-Google-Smtp-Source: ABdhPJwvHx8t8NX/6uo4TYe98DKgtwFdK2RsZmCxfsEUuBy1GCEM51qGHAmiKarmLEfYwHTimvtO7gw8YSrn392MbVc=
X-Received: by 2002:a92:c842:: with SMTP id b2mr785236ilq.179.1616549708783;
 Tue, 23 Mar 2021 18:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com>
 <YEpWVAnYLkytpIWB@lunn.ch> <CALCv0x02RQ=TQDjRNwAN1FJVFEwAbFYiif6JGtV=V4b2u0beKw@mail.gmail.com>
In-Reply-To: <CALCv0x02RQ=TQDjRNwAN1FJVFEwAbFYiif6JGtV=V4b2u0beKw@mail.gmail.com>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Tue, 23 Mar 2021 18:34:57 -0700
Message-ID: <CALCv0x33Pc6vbzzzQ2kv3JR6Yaz_sru_4dp=JptDS5dKSV5nUw@mail.gmail.com>
Subject: Re: [PATCH net-next,v2 1/3] net: dsa: mt7530: setup core clock even
 in TRGMII mode
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 6:33 PM Ilya Lipnitskiy
<ilya.lipnitskiy@gmail.com> wrote:
>
> On Thu, Mar 11, 2021 at 9:41 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Wed, Mar 10, 2021 at 06:09:52PM -0800, Ilya Lipnitskiy wrote:
> > > A recent change to MIPS ralink reset logic made it so mt7530 actually
> > > resets the switch on platforms such as mt7621 (where bit 2 is the reset
> > > line for the switch). That exposed an issue where the switch would not
> > > function properly in TRGMII mode after a reset.
> > >
> > > Reconfigure core clock in TRGMII mode to fix the issue.
> > >
> > > Tested on Ubiquiti ER-X (MT7621) with TRGMII mode enabled.
> >
> > Please don't submit the same patch to net and net-next.  Anything
> > which is accepted into net, will get merged into net-next about a week
> > later. If your other two patches depend on this patch, you need to
> > wait for the merge to happen, then submit them.
> I don't mind waiting, but it's been more than a week now. When is the
> next merge of net-next into net planned to happen?
Oops, I meant net into net-next...

Ilya
