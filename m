Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE905A4D1
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfF1TJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:09:29 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36965 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfF1TJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:09:29 -0400
Received: by mail-yw1-f65.google.com with SMTP id u141so1922570ywe.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 12:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=449XblN0l6jdSpOjx7Le/3IqqVPDOSTgCHH+i4/r88o=;
        b=RwJkYmlVlijyN+MdHEcsc/YkWXFHbxv6OIZkk8PW1SaKrqUkU4fHbzvSS+akaO4nKJ
         i6LbJHgvh5NNQ/1TcsiCaZ7tlgrDlRwyuv3+yQI86w2JvxYBUKVsWJgz2Cpe6qwwgXU7
         0LZvYeauQQw+Bvb29wDhyZ3m31MkK4MDDKAi4HZ3XV4Bu70IrVR48eR2bwCB2hxR6mD2
         +wHSl+xMwGtEhLZZP+QMQfPOX2YUYOGt/1Mak9xZQntcC8vEZ33oKXGWlfQNSDt/mNOH
         tq7JM9XiZF40GmB1Co4DzcIsNaIMZTJLSeQU5aR7iY1aHdy2XVIDHO9wus01nNmzwCUx
         xskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=449XblN0l6jdSpOjx7Le/3IqqVPDOSTgCHH+i4/r88o=;
        b=HzDIMywfLL8inK73HMvP60Xrj1a/LXkfaVEETlTFplqmS9yUPJCjl3RzTEJiYqTO2S
         CuoYdGwY8tXv/X+BoRKHDP+DIKrnHFM9eEInSBGahsU9I5ao8EKSvVl71X7npUIvTMQy
         yflWfblVdyamlJWfQlFiqEcfAelhaBcZlWTjE8gZ+sh8DhMCiPmV8mHhH4t78XHWDkIi
         +xyBhUKkdteqkP4rTJb/VzBvlxbXJpUpOOnNMhWyFb+eIe0On0MZQBY1vUkH5EpNlE6J
         osVQ0YkIoAq98B45i6Wr2jYw7zG2IOG98zUk1E1LrjhHagS5xix9O11Ozn9cVZGptPjZ
         DR0g==
X-Gm-Message-State: APjAAAVoISTna5s+IgSM0W9tPNan2RRciqVClMMfrBuhrY4kQ0dEOwW0
        3tJZlfvxVNSeH3XwsLxX3viaQn7Q
X-Google-Smtp-Source: APXvYqxK5aAoSjPVsQn8dP0V+XjLHhqYgyrASWWeuG3p984gBo+exImwtxq6CWLzL68E683OfjVU+g==
X-Received: by 2002:a0d:d481:: with SMTP id w123mr1962408ywd.459.1561748968072;
        Fri, 28 Jun 2019 12:09:28 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id 204sm644633ywg.67.2019.06.28.12.09.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 12:09:26 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id l22so72015ybf.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 12:09:26 -0700 (PDT)
X-Received: by 2002:a25:99c4:: with SMTP id q4mr7787823ybo.390.1561748966368;
 Fri, 28 Jun 2019 12:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1561706800.git.joabreu@synopsys.com> <e4e9ee4cb9c3e7957fe0a09f88b20bc011e2bd4c.1561706801.git.joabreu@synopsys.com>
In-Reply-To: <e4e9ee4cb9c3e7957fe0a09f88b20bc011e2bd4c.1561706801.git.joabreu@synopsys.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 15:08:50 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc4MFfjBNpvN2hRh9_MRmxSYw2xY6wp32Hsbw0E=pqUdw@mail.gmail.com>
Message-ID: <CA+FuTSc4MFfjBNpvN2hRh9_MRmxSYw2xY6wp32Hsbw0E=pqUdw@mail.gmail.com>
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

On Fri, Jun 28, 2019 at 3:30 AM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> This is a performance killer and anyways the interrupts are being
> disabled by RX NAPI so no need to disable them again.

By the

        if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {
                stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
                napi_schedule_irqoff(&ch->rx_napi);
        }

branch directly above? If so, is it possible to have fewer rx than tx
queues and miss this?

this logic seems more complex than needed?

        if (status)
                status |= handle_rx | handle_tx;

        if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {

        }

        if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use)) {

        }

status & handle_rx implies status & handle_tx and vice versa.


>
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 4a5941caaadc..e8f3e76889c8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2061,10 +2061,8 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
>                 napi_schedule_irqoff(&ch->rx_napi);
>         }
>
> -       if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use)) {
> -               stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
> +       if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use))
>                 napi_schedule_irqoff(&ch->tx_napi);
> -       }
>
>         return status;
>  }
> @@ -3570,8 +3568,8 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
>         work_done = stmmac_tx_clean(priv, DMA_TX_SIZE, chan);
>         work_done = min(work_done, budget);
>
> -       if (work_done < budget && napi_complete_done(napi, work_done))
> -               stmmac_enable_dma_irq(priv, priv->ioaddr, chan);
> +       if (work_done < budget)
> +               napi_complete_done(napi, work_done);

It does seem odd that stmmac_napi_poll_rx and stmmac_napi_poll_tx both
call stmmac_enable_dma_irq(..) independent of the other. Shouldn't the
IRQ remain masked while either is active or scheduled? That is almost
what this patch does, though not exactly.
