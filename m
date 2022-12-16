Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA9864F38A
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 22:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLPVzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 16:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiLPVzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 16:55:02 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D375F422
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 13:55:01 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so7408042pjs.4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 13:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6mShOEspDNqSdavZjd/f9r9xhfVEeTGt3kauNNZfaM4=;
        b=RpJX+8Eo4N9b+kWTvG6E/zv00fIFDFORk53EQaP1BmuO94riB8vvQU5ssC1eg0EdOV
         EnKTSad26aWdfjJljb9ZVkhJ/TAAGgXLE9luSCiHiFiDUMveL28ZvbBdgg4cmeLv6tG+
         tnemOULgmzmkBHgCiAiHRnK+aXABm1MM92iQsPSH2XgnOyQBRLAspneXFj2vmnjICJSU
         ukjjn9TbH6Q0ZAhZewQBSoa2HWemt/vJmeepb3Mj7qms5sND7TIAWNn8nrlJwsCXemOC
         kSdQOzTO2hhKt5ZzpokjKMieEeh3vl0AL0eVT/cgztthd9MURdsR3kGxuvNv3b+Jc6CX
         kPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mShOEspDNqSdavZjd/f9r9xhfVEeTGt3kauNNZfaM4=;
        b=Uh/BfBLr1c/aiALcE74U6obNv4n29ufc9pn1fAO+lVv8dV22qibbNyIRh7LSFQn4RQ
         FgWXlLyHMDCkyTAW5uFxBK5Wp4X4q6xbMRoKXp9wSmhTfb5DYbMuKJovoEOkjwbW//3X
         n+flRVKXmCStgrIZerPuywMr++CsV7BDUuUn9hfCqyWRBVGMvAB5vfDjvbfi6dqVuE/E
         BsZeY6piFMVdoTF2n34Db6rN3drL9xnZvtm03A9Q5xxnn0MFbnw3yQAwtDCWWPpZ7Ozp
         PGUF/hAI5AIUBwjVrZwnApb9xpZR1vosSyaS8YM3EGc5ADPE0XHvgFQ32X63LfyLWHPN
         /gig==
X-Gm-Message-State: AFqh2krYhokGaqBlr7mO1H9MeGXJLknFi/o4fTpKTVG85yCshhRa6fMy
        KH9kGM/hXth87fI6aSRfPmIuCQ69sSA=
X-Google-Smtp-Source: AMrXdXt9inl4iFdliddaOKnRi/64iTSrF6AIBN3nXTm3EcBIQGaPAOrQq1YLDdD+a+Tm391HONNFGA==
X-Received: by 2002:a17:903:328e:b0:189:dfae:f9c2 with SMTP id jh14-20020a170903328e00b00189dfaef9c2mr417100plb.23.1671227700562;
        Fri, 16 Dec 2022 13:55:00 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:211:6b31:5f6:6aef])
        by smtp.gmail.com with ESMTPSA id jj11-20020a170903048b00b001783f964fe3sm2102996plb.113.2022.12.16.13.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 13:54:59 -0800 (PST)
Date:   Fri, 16 Dec 2022 13:54:56 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Geoff Levand <geoff@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [PATCH] net: ks8851: Drop IRQ threading
Message-ID: <Y5zpMILXRnW2+dBU@google.com>
References: <20221216124731.122459-1-marex@denx.de>
 <CANn89i+08T_1pDZ-FWikarVq=5q4MVAx=+mRkSqeinfb10OdOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+08T_1pDZ-FWikarVq=5q4MVAx=+mRkSqeinfb10OdOg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 02:23:04PM +0100, Eric Dumazet wrote:
> On Fri, Dec 16, 2022 at 1:47 PM Marek Vasut <marex@denx.de> wrote:
> >
> > Request non-threaded IRQ in the KSZ8851 driver, this fixes the following warning:
> > "
> > NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
> 
> This changelog is a bit terse.
> 
> Why can other drivers use request_threaded_irq(), but not this one ?

This one actually *has* to use threading, as (as far as I can see) the
"lock" that is being taken in ks8851_irq for the SPI variant of the
device is actually a mutex, so we have to be able to sleep in the
interrupt handler...

> 
> 
> > "
> >
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > ---
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Geoff Levand <geoff@infradead.org>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Petr Machata <petrm@nvidia.com>
> > Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> > To: netdev@vger.kernel.org
> > ---
> >  drivers/net/ethernet/micrel/ks8851_common.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
> > index cfbc900d4aeb9..1eba4ba0b95cf 100644
> > --- a/drivers/net/ethernet/micrel/ks8851_common.c
> > +++ b/drivers/net/ethernet/micrel/ks8851_common.c
> > @@ -443,9 +443,7 @@ static int ks8851_net_open(struct net_device *dev)
> >         unsigned long flags;
> >         int ret;
> >
> > -       ret = request_threaded_irq(dev->irq, NULL, ks8851_irq,
> > -                                  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> > -                                  dev->name, ks);
> > +       ret = request_irq(dev->irq, ks8851_irq, IRQF_TRIGGER_LOW, dev->name, ks);
> >         if (ret < 0) {
> >                 netdev_err(dev, "failed to get irq\n");
> >                 return ret;
> > --
> > 2.35.1
> >

Thanks.

-- 
Dmitry
