Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9936449759D
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 21:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbiAWU7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 15:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbiAWU7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 15:59:30 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C88C06173B;
        Sun, 23 Jan 2022 12:59:29 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso31436081wma.1;
        Sun, 23 Jan 2022 12:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1zHk6r090femVQyMjvd03up3U3/SAxHfZYjYYutsrU8=;
        b=b2gDoP9/uN1kjQpfG2eOUr66K7XmNZs42NhrwS8Yp4iNxGgBJOHDuGYCqK93MRdIbA
         0+EKJKMgQ8WatHnG6x0ayz3tzpI906UxhLwg0dvr++u8I7vXu6C6BdIntFYyrjEAROxU
         /XsFgTR79FWdQSsJb5tDvr/yHaQHUlXBSTe1cg05B8wgG8gGEEYJ07kmzP3u4I8O3CCZ
         3pb3sfpF04Ydbf5qCkGtrYYQHbaLEQQEzZdw2fF9QuqwyQtFQwdi6gdJGQF3ukCcD0qD
         BOcVWDZWDYNlC0XA9G7vaCvq7V16KsRzCi+XYjEyfpFRAabBQcWOAqaZST7n3wdkByLy
         H2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1zHk6r090femVQyMjvd03up3U3/SAxHfZYjYYutsrU8=;
        b=EE1kb74XcpDkpb66zdM0UmnEjDE/dPQ04XlaAh5oGgqmD6s3Dw0rYeAh4cHR8MPdU5
         rtV9fjuENxLoD1kVZWy/AAueNr3fGZYSagzLsHnRqU6awx6ePlZKE4K3YLEaME2F2LAZ
         QbuQ7fHonvQqW9WtjXUS+AxbD3tTSg+cw5P1eRsXhOAgPXWPWxQMJ56Pwbw8XYIdSc/m
         bE5/NxyvHrKPpuKVbN5DDz7q+xoTlq4wFN1gDefbulKcEuY+571g+naR4RshFf1f/5C/
         SF7pxmDuwOO/kQbihe4KGPWCQylFTSRa/68QJ2dC3AhhjQPtjG750VgbFAVHOQZ2vYNN
         /10A==
X-Gm-Message-State: AOAM533LAlFleDvlOwubMPyJGZTuvQjkR/Zn+E51hbmouhOLuv7GzNEa
        ctAP3MDddHX1JWRMMMPsgNK8q4Ytg15WGf+oIa7NOiEe
X-Google-Smtp-Source: ABdhPJxjjNOe5F0Thrcmzrbqf59D190QSa861ktfPNLgpQFnZVqEJnakvdZ10UVi12WWaOIiSY4d4qjrW9kvXCDMd+Y=
X-Received: by 2002:a05:600c:2042:: with SMTP id p2mr8776240wmg.167.1642971568121;
 Sun, 23 Jan 2022 12:59:28 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
 <20220120112115.448077-5-miquel.raynal@bootlin.com> <CAB_54W721DFUw+qu6_UR58GFvjLxshmxiTE0DX-DNNY-XLskoQ@mail.gmail.com>
In-Reply-To: <CAB_54W721DFUw+qu6_UR58GFvjLxshmxiTE0DX-DNNY-XLskoQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 23 Jan 2022 15:59:16 -0500
Message-ID: <CAB_54W6Z=F4CNw9o+UiZu24_YdOz7TSM57YpipHj8TgZc0Oa9w@mail.gmail.com>
Subject: Re: [wpan-next v2 4/9] net: ieee802154: at86rf230: Stop leaking skb's
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 23 Jan 2022 at 15:43, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Upon error the ieee802154_xmit_complete() helper is not called. Only
> > ieee802154_wake_queue() is called manually. We then leak the skb
> > structure.
> >
> > Free the skb structure upon error before returning.
> >
> > There is no Fixes tag applying here, many changes have been made on this
> > area and the issue kind of always existed.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/at86rf230.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> > index 7d67f41387f5..0746150f78cf 100644
> > --- a/drivers/net/ieee802154/at86rf230.c
> > +++ b/drivers/net/ieee802154/at86rf230.c
> > @@ -344,6 +344,7 @@ at86rf230_async_error_recover_complete(void *context)
> >                 kfree(ctx);
> >
> >         ieee802154_wake_queue(lp->hw);
> > +       dev_kfree_skb_any(lp->tx_skb);
>
> as I said in other mails there is more broken, we need a:
>
> if (lp->is_tx) {
>         ieee802154_wake_queue(lp->hw);
>         dev_kfree_skb_any(lp->tx_skb);
>         lp->is_tx = 0;
> }
>

Also we should free the skb at first _then_ wake_queue().

- Alex
