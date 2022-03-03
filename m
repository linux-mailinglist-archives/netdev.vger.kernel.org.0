Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B583D4CB467
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiCCBjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 20:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiCCBjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 20:39:06 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A5639684;
        Wed,  2 Mar 2022 17:38:22 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2d07ae0b1c4so39071467b3.11;
        Wed, 02 Mar 2022 17:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5hlAKeJCmJMR/cAYdpKEw4pHq90wUKYdfUsO0fMGF/4=;
        b=piRuZTEK8y2DTytxHjr3XSCGAnedDErY3XcDBKqwBiZQ19+PaCsBftib5ydtBMxn7V
         fQB4Js3bjvWZ6eH33JEvct0GBGnaAJFrnlsreT2m39p8wuSyxK+RY4TLIrMc9QBusyfa
         0j3Bch6cG6YdMK+8GxCN5m11A9cHU4/KL17c6XtIJ1SoMcZhsAGFmiO4YEqPpJQyKY0+
         /FTp9dWTXbYw481hanOr6ikJzo0+ucNkrUmF52A2gjCAEqr0JHjhRRAxoOAXKQtyemsg
         GakM56IFCjDZJZGtqfmvXYkq9DWJiitIcDWz4T3RbJKYds+R0TunoTdZz9lwtOKD6BGJ
         luCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5hlAKeJCmJMR/cAYdpKEw4pHq90wUKYdfUsO0fMGF/4=;
        b=4ReExbOImk/S/thOUq4SY5l9MrZZz9JG4PI5FNg8ofmS5xXa32wp/AhyJO9kZBSwOD
         vJswdrkheHAFpIB2Cu1DbH+g7wse7gUaK68TA1EpmY8ela/Gbvbc1UFHPTCHihjpWzMa
         8ZHULhbUGrxfxWXhO/d3hM/BLPhypk3lVDAuvHnAI62Edr/d0vzwa3GxXx1QpAJ8UbAt
         W9KUkq+AL00+K6+NrARSg4nx855x5XUbhR/9uUjiojRM9gACVgDuS3j7/DgYbdfoMfXj
         u/ZuZg9ndcUcxKAVM55Rbpu2nAoC5mk3BT/nvYNQhAWmVTqQhob2DbCxbl4Ns+Thw6hs
         UNdg==
X-Gm-Message-State: AOAM531WRUnNDEoZwvk7H1JFns2yVAUMIDDmszUXYAgWtpz4U0WqbNz7
        A3bND63eT5eh5Rx5ZzGmpp+MA9aNBPBN7xjaxcph00t61KsbC65+lmM=
X-Google-Smtp-Source: ABdhPJyYmud61vfBErDjxizv/6VxrfGJ5q1vYo8+n1S3FBdMbZbtlk/lPcIXe80dVFgPWfT6f9w1SwrSW5CqkUMNwhk=
X-Received: by 2002:a81:6307:0:b0:2d6:6aee:dc75 with SMTP id
 x7-20020a816307000000b002d66aeedc75mr33572142ywb.249.1646271501383; Wed, 02
 Mar 2022 17:38:21 -0800 (PST)
MIME-Version: 1.0
References: <1646203686-30397-1-git-send-email-baihaowen88@gmail.com> <f519c59e-fdf0-14e8-8cce-c6c2d19cff8b@gmail.com>
In-Reply-To: <f519c59e-fdf0-14e8-8cce-c6c2d19cff8b@gmail.com>
From:   lotte bai <baihaowen88@gmail.com>
Date:   Thu, 3 Mar 2022 09:38:10 +0800
Message-ID: <CAFo17Pj2oi1fdgc=ypKZj+J0H8A4uettkk=trzq--9qe_8QYaQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: marvell: Use min() instead of doing it manually
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I have compiled at local, either unsigned and U is pass.  Thank
you for your kindly reminder.

Heiner Kallweit <hkallweit1@gmail.com> =E4=BA=8E2022=E5=B9=B43=E6=9C=882=E6=
=97=A5=E5=91=A8=E4=B8=89 19:06=E5=86=99=E9=81=93=EF=BC=9A
>
> On 02.03.2022 07:48, Haowen Bai wrote:
> > Fix following coccicheck warning:
> > drivers/net/ethernet/marvell/mv643xx_eth.c:1664:35-36: WARNING opportun=
ity for min()
> >
> > Signed-off-by: Haowen Bai <baihaowen88@gmail.com>
> > ---
> >  drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/e=
thernet/marvell/mv643xx_eth.c
> > index 143ca8b..e3e79cf 100644
> > --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> > +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> > @@ -1661,7 +1661,7 @@ mv643xx_eth_set_ringparam(struct net_device *dev,=
 struct ethtool_ringparam *er,
> >       if (er->rx_mini_pending || er->rx_jumbo_pending)
> >               return -EINVAL;
> >
> > -     mp->rx_ring_size =3D er->rx_pending < 4096 ? er->rx_pending : 409=
6;
> > +     mp->rx_ring_size =3D min(er->rx_pending, (unsigned)4096);
>
> Don't just use unsigned w/o int. Why not simply marking the constant as u=
nsigned: 4096U ?
> And again: You should at least compile-test it.
>
> >       mp->tx_ring_size =3D clamp_t(unsigned int, er->tx_pending,
> >                                  MV643XX_MAX_SKB_DESCS * 2, 4096);
> >       if (mp->tx_ring_size !=3D er->tx_pending)
>
