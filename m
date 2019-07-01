Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0545BB6B
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfGAMXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:23:42 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38700 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfGAMXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:23:42 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so23209397edo.5;
        Mon, 01 Jul 2019 05:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TqJ5FwFb7YyscLWlQXilVsOJTgQDq/FFV13jnAzIBSA=;
        b=SL8qpN87+0x+YgiO7CxEarJHROlGcqh2Hz8kq2O/Xcy6RIT4sMzzDVbyxuLHskKkDY
         KTR6ri9py2vcxPGxcQ9KPtHJiIY17F0lAo8lR/9D61FOc1d7Q1obGl7/Zj4MIgfHbtRn
         Q2Zmfpi3HMGX6MhOYPUiKGs43PAQHMY2/dAoJTW8ZFWvXNCyYfk7Cj9an6Jm7d6MrPpr
         rLtyKyfErpdU6wyepGoCK2aYLJiJ4lRy+rjFfjhUF5HBIq6NQGdrjbybSdJhCl8bkz1E
         o5xnFH/dBkK7IVDvqJvAuldVd2ZlLpawCbJa9vsX2yby7HzP+F3SITT+gc2HobR54ZlQ
         6A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TqJ5FwFb7YyscLWlQXilVsOJTgQDq/FFV13jnAzIBSA=;
        b=dUIWWD9DRQuyp3V7G8ATh6HdkFdPDOq+DXNDA8w2tLMfCRGWeIWdp3ly7BKXC/8GIp
         VeEHskBSdoDUfHfExvALoUe1ThEEtnlbQH/3Gfb16UQ0sBE926RbaMqKflJjpEbh/iG3
         1Ysco/0gQ9di784HDlC7f4RBb5Wu9QdbExpV3tb3C+CzKleAbAdbHaRlLMbtKXrDXY0g
         RIHBNPjSrruJ03qmnBC2uXs2JXxAbNjAu31z4lbBwEp140ZLo3ihg3+LEvlgBmj2fqf6
         0/fEikvKz3Zvvxjgds3cRN6+d2boJhgKjTm+8nC2+rxW8Zz9tr6vxgRisxad71ZpRuW/
         4LwA==
X-Gm-Message-State: APjAAAUMuqX0UF0W1gAV8IW5hGoWRlF95oqcqddaWHzALzhzc/Z2unkH
        zK6ISLBq3BlCMtmLME7VYgwF/Y5sYGG2jEMTdm8=
X-Google-Smtp-Source: APXvYqx0HFUnYm5/0uR+9Qh51tm1qPSRjeb5pdf0KaghBF5O1NR0L3wpZtjTEGFSRaNosFZa0Miceq4KmgZoL2uihCk=
X-Received: by 2002:a50:bdc2:: with SMTP id z2mr28517471edh.245.1561983820432;
 Mon, 01 Jul 2019 05:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1561706800.git.joabreu@synopsys.com> <e4e9ee4cb9c3e7957fe0a09f88b20bc011e2bd4c.1561706801.git.joabreu@synopsys.com>
 <CA+FuTSc4MFfjBNpvN2hRh9_MRmxSYw2xY6wp32Hsbw0E=pqUdw@mail.gmail.com> <BN8PR12MB326638B0BA74DA762C89DF54D3F90@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB326638B0BA74DA762C89DF54D3F90@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Jul 2019 08:23:03 -0400
Message-ID: <CAF=yD-+55uqYawF9oUFVT5T_cyxso4s5r+vxFrcxBTXuieNVRA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 06/10] net: stmmac: Do not disable interrupts
 when cleaning TX
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 6:15 AM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
>
> > By the
> >
> >         if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {
> >                 stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
> >                 napi_schedule_irqoff(&ch->rx_napi);
> >         }
> >
> > branch directly above? If so, is it possible to have fewer rx than tx
> > queues and miss this?
>
> Yes, it is possible.

And that is not a problem?

>
> > this logic seems more complex than needed?
> >
> >         if (status)
> >                 status |= handle_rx | handle_tx;
> >
> >         if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {
> >
> >         }
> >
> >         if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use)) {
> >
> >         }
> >
> > status & handle_rx implies status & handle_tx and vice versa.
>
> This is removed in patch 09/10.
>
> > > -       if (work_done < budget && napi_complete_done(napi, work_done))
> > > -               stmmac_enable_dma_irq(priv, priv->ioaddr, chan);
> > > +       if (work_done < budget)
> > > +               napi_complete_done(napi, work_done);
> >
> > It does seem odd that stmmac_napi_poll_rx and stmmac_napi_poll_tx both
> > call stmmac_enable_dma_irq(..) independent of the other. Shouldn't the
> > IRQ remain masked while either is active or scheduled? That is almost
> > what this patch does, though not exactly.
>
> After patch 09/10 the interrupts will only be disabled by RX NAPI and
> re-enabled by it again. I can do some tests on whether disabling
> interrupts independently gives more performance but I wouldn't expect so
> because the real bottleneck when I do iperf3 tests is the RX path ...

Sharing the IRQ sounds fine. My only concern was TX-only IRQs in case
more TX than RX queues are configured. If that is possible with this
driver.
