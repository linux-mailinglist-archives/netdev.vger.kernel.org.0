Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0527E28EAEE
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 04:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbgJOCJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 22:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgJOCJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 22:09:38 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBE2C05BD16;
        Wed, 14 Oct 2020 15:31:18 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z33so464648qth.8;
        Wed, 14 Oct 2020 15:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2bDs98ntDIXfp42fz2irqL/7dwTOhw0qSbVCbyVX2Wo=;
        b=k23lljwg6UM4znZHShqTNR4m7IIkpr+/yjRNjNiUWczinS73SjZXxrf+nuQ3+N6B19
         o12umAMU/rJmWgJL4NFvx+fcp5V0LZFb94Sir88vRayBdbfheaDQaCor496q1O/N3cVE
         1gTvO3jeHyTS3MFZQS44E/WiKh0d/93XHw3Ds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bDs98ntDIXfp42fz2irqL/7dwTOhw0qSbVCbyVX2Wo=;
        b=Md9wgQM3jJlNjtJ+3SiTNzz9NYEraWDcvaTXLNTdh/6RXxAPcEPvlHVdhBFzFEZgBF
         PB8l5inN/tOdRkfpsrV3V2aoJWcqHuShaKT3oEIgzKWAEeukLgTQR8+r4SpiNI9HvNIz
         oBUzGIWTTnbduoYnLRgxxGp4sKftUMJ+JBBrac5D2cpSTB4Cgs3MXudJU3N4EzUTV9PU
         SeD/QEWMY76qMD9A80t0izYm9e/nMZIoM2KgFduz+zLSm94yFbfd3RD89Yatiq4/fM/1
         7jsv6NqRufBsbi2ZmVx93Rl9Bse6v4UpL3+28psI3A2lbIl0McHhg1mIbmzsVOuVh9IO
         qUTA==
X-Gm-Message-State: AOAM532gZwmAYhD+pGpdN4x0A1jixtPl4/vCkmAZitm9ptuBLoEVSvz7
        TbF7nRxeABwuDTdyUN5DgHjq2Ob6m1N++QX9Is8=
X-Google-Smtp-Source: ABdhPJzaTBI/jCETqEnDTpHoEVhA7+3xxi1+uoLLTUHoSHbaFmQBZ8EJFNXyYrbE1296c8fATMbvfuJ4Rn+Cshq2a3E=
X-Received: by 2002:aed:3325:: with SMTP id u34mr1433256qtd.263.1602714677688;
 Wed, 14 Oct 2020 15:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201014060632.16085-1-dylan_hung@aspeedtech.com>
 <20201014060632.16085-2-dylan_hung@aspeedtech.com> <CACPK8Xe_O44BUaPCEm2j3ZN+d4q6JbjEttLsiCLbWF6GnaqSPg@mail.gmail.com>
 <PS1PR0601MB1849DAC59EDA6A9DB62B4EE09C050@PS1PR0601MB1849.apcprd06.prod.outlook.com>
In-Reply-To: <PS1PR0601MB1849DAC59EDA6A9DB62B4EE09C050@PS1PR0601MB1849.apcprd06.prod.outlook.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 14 Oct 2020 22:31:04 +0000
Message-ID: <CACPK8Xd_DH+VeaPmXK2b5FXbrOpg_NmT_R4ENzY-=uNo=6HcyQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 at 13:32, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
> > > The new HW arbitration feature on Aspeed ast2600 will cause MAC TX to
> > > hang when handling scatter-gather DMA.  Disable the problematic
> > > feature by setting MAC register 0x58 bit28 and bit27.
> >
> > Hi Dylan,
> >
> > What are the symptoms of this issue? We are seeing this on our systems:
> >
> > [29376.090637] WARNING: CPU: 0 PID: 9 at net/sched/sch_generic.c:442
> > dev_watchdog+0x2f0/0x2f4
> > [29376.099898] NETDEV WATCHDOG: eth0 (ftgmac100): transmit queue 0
> > timed out
> >
>
> May I know your soc version? This issue happens on ast2600 version A1.  The registers to fix this issue are meaningless/reserved on A0 chip, so it is okay to set them on either A0 or A1.

We are running the A1. All of our A0 parts have been replaced with A1.

> I was encountering this issue when I was running the iperf TX test.  The symptom is the TX descriptors are consumed, but no complete packet is sent out.

What parameters are you using for iperf? I did a lot of testing with
iperf3 (and stress-ng running at the same time) and couldn't reproduce
the error.

We could only reproduce it when performing other functions, such as
debugging/booting the host processor.

> > > +/*
> > > + * test mode control register
> > > + */
> > > +#define FTGMAC100_TM_RQ_TX_VALID_DIS (1 << 28) #define
> > > +FTGMAC100_TM_RQ_RR_IDLE_PREV (1 << 27)
> > > +#define FTGMAC100_TM_DEFAULT
> > \
> > > +       (FTGMAC100_TM_RQ_TX_VALID_DIS |
> > FTGMAC100_TM_RQ_RR_IDLE_PREV)
> >
> > Will aspeed issue an updated datasheet with this register documented?

Did you see this question?

Cheers,

Joel
