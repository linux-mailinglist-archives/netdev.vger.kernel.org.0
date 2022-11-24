Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952A16375A1
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiKXJyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiKXJyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:54:38 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3CE12F414;
        Thu, 24 Nov 2022 01:54:37 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p12so1051632plq.4;
        Thu, 24 Nov 2022 01:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XIgPTakbw0hwKBNbkmD4l8Qc3Gi4AwORlTsSds71r68=;
        b=BsVxydxBs9aa9qznlYR6MOpRqa+u8uFxiB2ZSUV2ZqJJjea+BTD88tv/TydzWSYKZw
         y61O5a77M6UpIz2D9skWnej+1q1TaK6Zzhfs4Nqp9dqXsIvn6jTPCfPMz5F4BfWwkJK2
         FizNA4s251QUQ7nrTbCLROW9StO58D5bf7zWydMwLqoHWVXDz38gZEdFBq7DRzd9Nqxe
         ZwjTvLpTuFUMhWP77QE3zbk6KlUUH2Aqaw9cirjp+FcXcZj8zSSIBrsGUzjcdf+iXr6n
         JggchEHjCJhbJuIErHC2MZrm2njvRWCWE6naWrbPWnKGiioXtO76e5o8s3V4Z9wEnLkE
         XWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XIgPTakbw0hwKBNbkmD4l8Qc3Gi4AwORlTsSds71r68=;
        b=b27iAqbR+CUYM6Empx1RdCjmaMz948mmMBpdFd5INf3/NgOsjhK9vENxPemmwY++4G
         jZc0s1ejPOXBXlO1zPZhR1A4tUzDY8hHZFngsx/dyI84+qJEf24LsiQ4huD149BcYWNK
         cr/WT1QStEhnFfUeQweWzOPEaIdNscb2eTi4DJRDkls4Oyge+ZPIRwSwop2JLnK1BaC0
         h7vNXDy2rTit9Tn9D0rK7/u+x4K54TKG3d8MlaIvh1zv2ZL2w1tmg6oHpxeMF2b7h3Fq
         21CjYBGSZPbSBz+qpMYyohmLlqF7DCPHgHjSNsVldoFbkoTDAJ+2XvD+UV4eVOvRa+Kw
         zimw==
X-Gm-Message-State: ANoB5plB7Exk42BTR+S+C7wKHPOOtfdHAUh6VX0apADZyoGQDzHaSRqC
        k5sjpbKN/VT7mniDHYpzEmOWH5ZYx9PnzAAF8cqNN0kBIjk=
X-Google-Smtp-Source: AA0mqf4fbm1xuFTG/tN/aKXkrNjqCIFMW6GMVvWfx1PI3bE9KWxnr1m3qJg+KAhUu7XhrDR1mYl5f3bwltqE49y0F8A=
X-Received: by 2002:a17:902:aa04:b0:17f:6fee:3334 with SMTP id
 be4-20020a170902aa0400b0017f6fee3334mr12975525plb.10.1669283676615; Thu, 24
 Nov 2022 01:54:36 -0800 (PST)
MIME-Version: 1.0
References: <20221123194406.80575-1-yashi@spacecubics.com> <CAMZ6RqJ2L6YntT23rsYEEUK=YDF2LrhB8hXwvYjciu3vzjx2hQ@mail.gmail.com>
 <CAELBRWLOKW8NCLpV=MG0_=XY4N3BaozsZCacfgaXEs-tyfzoAA@mail.gmail.com>
In-Reply-To: <CAELBRWLOKW8NCLpV=MG0_=XY4N3BaozsZCacfgaXEs-tyfzoAA@mail.gmail.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Thu, 24 Nov 2022 18:54:25 +0900
Message-ID: <CAMZ6Rq+-ya9VxSGUD4aP=N58gZ1CmDbFFGQ9Oys0aTKm1rWN0A@mail.gmail.com>
Subject: Re: [PATCH] can: mcba_usb: Fix termination command argument
To:     Yasushi SHOJI <yasushi.shoji@gmail.com>
Cc:     Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 24 Nov. 2022 at 18:52, Yasushi SHOJI <yasushi.shoji@gmail.com> wrote:
> On Thu, Nov 24, 2022 at 9:53 AM Vincent Mailhol
> <vincent.mailhol@gmail.com> wrote:
> > > diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> > > index 218b098b261d..67beff1a3876 100644
> > > --- a/drivers/net/can/usb/mcba_usb.c
> > > +++ b/drivers/net/can/usb/mcba_usb.c
> > > @@ -785,9 +785,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
> > >         };
> > >
> > >         if (term == MCBA_TERMINATION_ENABLED)
> > > -               usb_msg.termination = 1;
> > > -       else
> > >                 usb_msg.termination = 0;
> > > +       else
> > > +               usb_msg.termination = 1;
> > >
> > >         mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
> >
> > Nitpick: does it make sense to rename the field to something like
> > usb_msg.termination_disable or usb_msg.termination_off? This would
> > make it more explicit that this is a "reverse" boolean.
>
> I'd rather define the values like
>
> #define TERMINATION_ON (0)
> #define TERMINATION_OFF (1)
>
> So the block becomes
>
> if (term == MCBA_TERMINATION_ENABLED)
>     usb_msg.termination = TERMINATION_ON;
> else
>     usb_msg.termination = TERMINATION_OFF;

That also works! Thank you.
