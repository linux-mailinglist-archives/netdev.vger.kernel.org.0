Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5FA5A3195
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 23:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiHZV45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 17:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiHZV44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 17:56:56 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE92CACA2;
        Fri, 26 Aug 2022 14:56:54 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-32a09b909f6so69161807b3.0;
        Fri, 26 Aug 2022 14:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=YIsmXK/1IMUzBKPFPBCOzWlrG3vuxnAl26/EQEinaGU=;
        b=Woi3HMQVUTh9wjBeAKXEpTFy4sf0GT5G162/idyorzEjanNHHAAO45K6yb3Gq251vx
         vdGkWXeLHyJD1Eg5RShfMvgsW17hKDHZr/WeeDtgdpyt32v1ggnnjCHlRuAQ94Dpc11n
         zS2IwMRHR9s2PGlSxiCxhhs3r1G6RPkeqBKCOCYCE4mPWzWmQqlnHguY0hSWkrhmHkVP
         c80tnpQQ8aynngWmq9c20Rz5FIJYqJ1lG8EM+uu+/Bn+bD/1qLICngiaAtk0lCNG7gJn
         U7gXacECwV1iR4jaz+0w7cw+lJzQltivxlZf7vX/cHXdyHNxlEyqXdk9GMeHqzK764xE
         fj2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=YIsmXK/1IMUzBKPFPBCOzWlrG3vuxnAl26/EQEinaGU=;
        b=xtJ3U2yLwssHKz6czZ3Qs+tai4dTBlgdlPzgdlZ5kCmBHzUs4Q4+BqpIaYTYJg4xwe
         8+vxr/EqO+65qpYAatXv95S53IEZZsG2hUZ085JMjr6AbuvME6i/pZREpB+TwwKMdVHE
         zhSgFb++RH4cSFbCvG7DXaKiDQArf5momXl+O7c2qNE6BUgi8pfDLfxF8QZUUziI3QYR
         Uh+Gk8zGQwFCCaU4UI2Be3KXwtXeLFSudMPcrXeJo0P1dDs3t9n9xM8UBfk8A5mpAnhj
         tnR1KXjFx4EWJJVq5bNdBEiyhK1gyMCMIQXSmci6mxjMhgAO0fXPdePWtphaKpNjQ+lq
         rd9w==
X-Gm-Message-State: ACgBeo3R57Ucj1iiEZDefLlEEItyUdZ6LUMTw7XMYwhM9jqqaOQLDS4d
        Z99ETb3AKLCcvbQuHmrV/AEaeUx6m0PGS7sLv6Y=
X-Google-Smtp-Source: AA6agR4UTuA3qINNphj7afBVZTaQiWFU8zQh4oSl0I8d9SplK6OhHc5jyFq4/aR+zST0rOWp264LYbZR9vv+Gc1Ll04=
X-Received: by 2002:a5b:68e:0:b0:671:76c9:ff with SMTP id j14-20020a5b068e000000b0067176c900ffmr1606448ybq.630.1661551013566;
 Fri, 26 Aug 2022 14:56:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220820082936.686924-1-dario.binacchi@amarulasolutions.com> <20220820082936.686924-5-dario.binacchi@amarulasolutions.com>
In-Reply-To: <20220820082936.686924-5-dario.binacchi@amarulasolutions.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Sat, 27 Aug 2022 06:56:42 +0900
Message-ID: <CAMZ6RqKQJZBVOSU7oA3AGSRG11vxdysAyRotHavUzsVRuM28Kw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] can: bxcan: add support for ST bxCAN controller
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        michael@amarulasolutions.com, Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 20 Aug. 2022 =C3=A0 17:32, Dario Binacchi
<dario.binacchi@amarulasolutions.com> a =C3=A9crit :
> Add support for the basic extended CAN controller (bxCAN) found in many
> low- to middle-end STM32 SoCs. It supports the Basic Extended CAN
> protocol versions 2.0A and B with a maximum bit rate of 1 Mbit/s.
>
> The controller supports two channels (CAN1 as master and CAN2 as slave)
> and the driver can enable either or both of the channels. They share
> some of the required logic (e. g. clocks and filters), and that means
> you cannot use the slave CAN without enabling some hardware resources
> managed by the master CAN.
>
> Each channel has 3 transmit mailboxes, 2 receive FIFOs with 3 stages and
> 28 scalable filter banks.
> It also manages 4 dedicated interrupt vectors:
> - transmit interrupt
> - FIFO 0 receive interrupt
> - FIFO 1 receive interrupt
> - status change error interrupt
>
> Driver uses all 3 available mailboxes for transmission and FIFO 0 for
> reception. Rx filter rules are configured to the minimum. They accept
> all messages and assign filter 0 to CAN1 and filter 14 to CAN2 in
> identifier mask mode with 32 bits width. It enables and uses transmit,
> receive buffers for FIFO 0 and error and status change interrupts.
>
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>
> ---

(...)

> +static void bxcan_handle_state_change(struct net_device *ndev, u32 esr)
> +{
> +       struct bxcan_priv *priv =3D netdev_priv(ndev);
> +       struct net_device_stats *stats =3D &ndev->stats;
> +       enum can_state new_state =3D priv->can.state;
> +       struct can_berr_counter bec;
> +       enum can_state rx_state, tx_state;
> +       struct sk_buff *skb;
> +       struct can_frame *cf;
> +
> +       /* Early exit if no error flag is set */
> +       if (!(esr & (BXCAN_ESR_EWGF | BXCAN_ESR_EPVF | BXCAN_ESR_BOFF)))
> +               return;
> +
> +       bec.txerr =3D BXCAN_TEC(esr);
> +       bec.rxerr =3D BXCAN_REC(esr);
> +
> +       if (esr & BXCAN_ESR_BOFF)
> +               new_state =3D CAN_STATE_BUS_OFF;
> +       else if (esr & BXCAN_ESR_EPVF)
> +               new_state =3D CAN_STATE_ERROR_PASSIVE;
> +       else if (esr & BXCAN_ESR_EWGF)
> +               new_state =3D CAN_STATE_ERROR_WARNING;
> +
> +       /* state hasn't changed */
> +       if (unlikely(new_state =3D=3D priv->can.state))
> +               return;
> +
> +       skb =3D alloc_can_err_skb(ndev, &cf);
> +       if (unlikely(!skb))
> +               return;
> +
> +       tx_state =3D bec.txerr >=3D bec.rxerr ? new_state : 0;
> +       rx_state =3D bec.txerr <=3D bec.rxerr ? new_state : 0;
> +       can_change_state(ndev, cf, tx_state, rx_state);
> +
> +       if (new_state =3D=3D CAN_STATE_BUS_OFF)
> +               can_bus_off(ndev);
> +
> +       stats->rx_bytes +=3D cf->len;

Please do not increment the stats if the frame is remote (c.f. CAN_RTR_FLAG=
).

> +       stats->rx_packets++;
> +       netif_rx(skb);
> +}


Yours sincerely,
Vincent Mailhol
