Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CC854A148
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 23:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351329AbiFMVVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245591AbiFMVVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 17:21:17 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B326159
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 14:04:51 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id c2so10870491lfk.0
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 14:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0bPIEvwh+kv/i7N879RmrfihKwJqx1X8GKXfQsY9+Pw=;
        b=AOPmRpVAYGZnd9Lg9Sfv5053p7vbdkmMl5a2q8iLRYg1DmiRxNM+r1DiuVsfUwD4kW
         oxfGDtLsPoB074M7NzORMx0jop+iKt5RIPenFmwa/9P1c+kvmUph1AX+HLTvg205ThkQ
         0rmiFCvyxSKJZggaH4Gm/PMz/sQfm0inObEc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0bPIEvwh+kv/i7N879RmrfihKwJqx1X8GKXfQsY9+Pw=;
        b=1rBBjlDqGV9v0HvcazQvCHlWzV6AhB/c6SAWmCAI6zuiCxr0sYRcv1zfy4VhYvK3c3
         +szxOYcikPjxdB/fuwn1ZXxRm6dPsTkIweuXAY/pFWmER2P6oGNeqo9rP+gZiqxSLW9d
         jWJ7adTyH457fzV1KJppnVytDT1P/QxI9R34XNRNmMuAvwnbOnOLns7btgINZmWH1fNB
         VEfO8Z5fy7+Jli7sWfhqJSMoaFlSx5g3Rc4HRvozqYstXmmC2+vqWpqTgrU0udR9sBrF
         A1CAwtthmM9NWaWxzb2DpIK9yphPDxCqBXBmTv+mQDNEm6AuE2s2RKSHOJsYufO9Qk9H
         sbAQ==
X-Gm-Message-State: AJIora+EKddxw+x31yMmtgTH071+d/1Qm0veuO/xKkn9f+2GSC19XBqb
        yAjfR5VqoDZVf1GR2xNQT3DrjNwldv29oceeHs4Rsw==
X-Google-Smtp-Source: AGRyM1veUkyLuRRpprmgBfGWfYtI7bGUcL+zVZuDQgowlb2OGgWX6h9JRUYqSbVwDfuheiLCnl8CRWIVNata3yL882I=
X-Received: by 2002:a05:6512:3fb:b0:479:6b9:27ce with SMTP id
 n27-20020a05651203fb00b0047906b927cemr988728lfq.429.1655154289436; Mon, 13
 Jun 2022 14:04:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
 <20220612213927.3004444-13-dario.binacchi@amarulasolutions.com> <20220613073208.anak24kpffnngube@pengutronix.de>
In-Reply-To: <20220613073208.anak24kpffnngube@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Mon, 13 Jun 2022 23:04:38 +0200
Message-ID: <CABGWkvrq6+N0rUaAmw_dJjJQAwMFv3-xK=LtTb-CSfTYFTs7QQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/13] can: slcan: extend the protocol with error info
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 9:32 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 12.06.2022 23:39:26, Dario Binacchi wrote:
> > It extends the protocol to receive the adapter CAN communication errors
> > and forward them to the netdev upper levels.
> >
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> >
> > ---
> >
> > (no changes since v2)
> >
> > Changes in v2:
> > - Protect decoding against the case the len value is longer than the
> >   received data.
>
> Where is that check?

I added the default case in the switch statement. Each line that is
processed by slc_bump_err()
is terminated by a '\r' or '\a' character. If len value is longer than
the received characters, it will
enter the default case for the eol character and the function will return.
But I realize now that I am wrong, the terminator is not placed in the
buffer passed to slc_bump_err() !!!!!! :)
I will add the right check in v4.

Thanks and regards,
Dario

>
> > - Continue error handling even if no skb can be allocated.
> >
> >  drivers/net/can/slcan/slcan-core.c | 130 ++++++++++++++++++++++++++++-
> >  1 file changed, 129 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
> > index 3df35ae8f040..48077edb9497 100644
> > --- a/drivers/net/can/slcan/slcan-core.c
> > +++ b/drivers/net/can/slcan/slcan-core.c
> > @@ -175,8 +175,118 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
> >    *                  STANDARD SLCAN DECAPSULATION                     *
> >    ************************************************************************/
> >
> > +static void slc_bump_err(struct slcan *sl)
> > +{
> > +     struct net_device *dev = sl->dev;
> > +     struct sk_buff *skb;
> > +     struct can_frame *cf;
> > +     char *cmd = sl->rbuff;
> > +     bool rx_errors = false, tx_errors = false;
> > +     int i, len;
> > +
> > +     if (*cmd != 'e')
> > +             return;
>
> This has already been checked in the caller, right?
>
> > +
> > +     cmd += SLC_CMD_LEN;
> > +     /* get len from sanitized ASCII value */
> > +     len = *cmd++;
> > +     if (len >= '0' && len < '9')
> > +             len -= '0';
> > +     else
> > +             return;
> > +
> > +     skb = alloc_can_err_skb(dev, &cf);
> > +
> > +     if (skb)
> > +             cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
> > +
> > +     for (i = 0; i < len; i++, cmd++) {
> > +             switch (*cmd) {
> > +             case 'a':
> > +                     netdev_dbg(dev, "ACK error\n");
> > +                     tx_errors = true;
>
> Nitpick:
> Please decide if you want to set tx/tx_errors here and increment at the
> end of the function....or.....
>
> > +                     if (skb) {
> > +                             cf->can_id |= CAN_ERR_ACK;
> > +                             cf->data[3] = CAN_ERR_PROT_LOC_ACK;
> > +                     }
> > +
> > +                     break;
> > +             case 'b':
> > +                     netdev_dbg(dev, "Bit0 error\n");
> > +                     tx_errors = true;
> > +                     if (skb)
> > +                             cf->data[2] |= CAN_ERR_PROT_BIT0;
> > +
> > +                     break;
> > +             case 'B':
> > +                     netdev_dbg(dev, "Bit1 error\n");
> > +                     tx_errors = true;
> > +                     if (skb)
> > +                             cf->data[2] |= CAN_ERR_PROT_BIT1;
> > +
> > +                     break;
> > +             case 'c':
> > +                     netdev_dbg(dev, "CRC error\n");
> > +                     rx_errors = true;
> > +                     if (skb) {
> > +                             cf->data[2] |= CAN_ERR_PROT_BIT;
> > +                             cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
> > +                     }
> > +
> > +                     break;
> > +             case 'f':
> > +                     netdev_dbg(dev, "Form Error\n");
> > +                     rx_errors = true;
> > +                     if (skb)
> > +                             cf->data[2] |= CAN_ERR_PROT_FORM;
> > +
> > +                     break;
> > +             case 'o':
> > +                     netdev_dbg(dev, "Rx overrun error\n");
> > +                     dev->stats.rx_over_errors++;
> > +                     dev->stats.rx_errors++;
>
> ....if you want to increment in the case.
>
> > +                     if (skb) {
> > +                             cf->can_id |= CAN_ERR_CRTL;
> > +                             cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
> > +                     }
> > +
> > +                     break;
> > +             case 'O':
> > +                     netdev_dbg(dev, "Tx overrun error\n");
> > +                     dev->stats.tx_errors++;
> > +                     if (skb) {
> > +                             cf->can_id |= CAN_ERR_CRTL;
> > +                             cf->data[1] = CAN_ERR_CRTL_TX_OVERFLOW;
> > +                     }
> > +
> > +                     break;
> > +             case 's':
> > +                     netdev_dbg(dev, "Stuff error\n");
> > +                     rx_errors = true;
> > +                     if (skb)
> > +                             cf->data[2] |= CAN_ERR_PROT_STUFF;
> > +
> > +                     break;
> > +             default:
> > +                     if (skb)
> > +                             dev_kfree_skb(skb);
> > +
> > +                     return;
> > +             }
> > +     }
> > +
> > +     if (rx_errors)
> > +             dev->stats.rx_errors++;
> > +
> > +     if (tx_errors)
> > +             dev->stats.tx_errors++;
> > +
> > +     if (skb)
> > +             netif_rx(skb);
> > +}
> > +
> >  /* Send one completely decapsulated can_frame to the network layer */
> > -static void slc_bump(struct slcan *sl)
> > +static void slc_bump_frame(struct slcan *sl)
> >  {
> >       struct sk_buff *skb;
> >       struct can_frame *cf;
> > @@ -255,6 +365,24 @@ static void slc_bump(struct slcan *sl)
> >       dev_kfree_skb(skb);
> >  }
> >
> > +static void slc_bump(struct slcan *sl)
> > +{
> > +     switch (sl->rbuff[0]) {
> > +     case 'r':
> > +             fallthrough;
> > +     case 't':
> > +             fallthrough;
> > +     case 'R':
> > +             fallthrough;
> > +     case 'T':
> > +             return slc_bump_frame(sl);
> > +     case 'e':
> > +             return slc_bump_err(sl);
> > +     default:
> > +             return;
> > +     }
> > +}
> > +
> >  /* parse tty input stream */
> >  static void slcan_unesc(struct slcan *sl, unsigned char s)
> >  {
> > --
> > 2.32.0
> >
> >
>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
