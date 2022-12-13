Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E573E64BCC6
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 20:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiLMTKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 14:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiLMTKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 14:10:30 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275281DDD5
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 11:10:28 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o5-20020a05600c510500b003d21f02fbaaso1892550wms.4
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 11:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YB2zoZgzfOVD0XLCaIjp6ouesB1j3+hq28sBf8VmRvs=;
        b=o6LMJPH4/JumqJrtckqwMsecIkzo9XW5STBjmxMmpaAbosMIEjAzDvLrfi+XDlxUFD
         5YMmfh2L4vK7PpeJMgBFOC40jZBnF7hvalMqDluw5jy6HiI+6jOh1FaTXV2Q3pU6e98U
         iqIHZpEUMDGZuLavrXT6imbpG+QtxlDxrXIXrBbOsMx1IjUwbKP2PTur93gbUsm1Ge04
         hVfoVNA+bPIKbrqxc7/Jr2Yyb5LRHgqC6HfKK1G32vtuMFtudGyvqTPo/k7a6CasMXOx
         F2mCm0orS/kZyto4+34T1Ln7auUE6RQJY5nXFnktS6Kpqr7oVG6sgu1+zRRKQfflDVYL
         40fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YB2zoZgzfOVD0XLCaIjp6ouesB1j3+hq28sBf8VmRvs=;
        b=uoYPytBa/jdvd5BY0Xxu3PGBZajVwaLQuHWMjyltinlkcajNbrM32EqR0FvQbBRpEI
         4120Myu8bWVeGc4h4ZdGIdhfkV522tuJ5OK7pRdnjPjd/kvK9gu10X7WQKFJlJ65hHBn
         uCeJCQLE7Q1mVxGycUh5rNFyWgIdD6+Ge4H0e9tqs960ZW4dCxJJJqJhg5B/aWtm/Xej
         4BS8gxZTKx6sYHfTYuVMm5+MtzOlwryeayWO0vN2GlE+1gd4iArxUZNALYQehOxyXsPr
         vcmUHjLn7IM+JED/kiOJTKCEOLFF3iMSqK/FuyMT4J8Lhify0lm5bHKMPdUC9jE44frZ
         EXwA==
X-Gm-Message-State: ANoB5pnQeZzY8XlIEEdS6hl6+EBxlbE7qFL4XVvQ0SrfAs8pZlNE7+Ta
        s963woSC9LVh1QULp5NvIv/FHA==
X-Google-Smtp-Source: AA0mqf4GIk6Ad2m/IdywSoCDctE4xpAPLCBCANrj6yaQajiufhi1EHkzLrv2soIQ9DAVoVapFK+kuQ==
X-Received: by 2002:a05:600c:1e26:b0:3d2:2043:9cb7 with SMTP id ay38-20020a05600c1e2600b003d220439cb7mr9380463wmb.5.1670958626589;
        Tue, 13 Dec 2022 11:10:26 -0800 (PST)
Received: from blmsp ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c3ba900b003d23928b654sm28772wms.11.2022.12.13.11.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 11:10:26 -0800 (PST)
Date:   Tue, 13 Dec 2022 20:10:25 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] can: tcan4x5x: Specify separate read/write
 ranges
Message-ID: <20221213191025.ibq4xjhxcrlmcp45@blmsp>
References: <20221206115728.1056014-1-msp@baylibre.com>
 <20221206115728.1056014-12-msp@baylibre.com>
 <20221206162001.3cgtod46h5d5j7fx@pengutronix.de>
 <20221212105444.cdzzh2noebni4ibj@pengutronix.de>
 <20221213171034.7fg7m5zdehj2ksmj@blmsp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221213171034.7fg7m5zdehj2ksmj@blmsp>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Tue, Dec 13, 2022 at 06:10:36PM +0100, Markus Schneider-Pargmann wrote:
> Hi Marc,
> 
> sorry for the delay.
> 
> On Mon, Dec 12, 2022 at 11:54:44AM +0100, Marc Kleine-Budde wrote:
> > On 06.12.2022 17:20:01, Marc Kleine-Budde wrote:
> > > On 06.12.2022 12:57:28, Markus Schneider-Pargmann wrote:
> > > > Specify exactly which registers are read/writeable in the chip. This
> > > > is supposed to help detect any violations in the future.
> > > > 
> > > > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > > > ---
> > > >  drivers/net/can/m_can/tcan4x5x-regmap.c | 43 +++++++++++++++++++++----
> > > >  1 file changed, 37 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
> > > > index 33aed989e42a..2b218ce04e9f 100644
> > > > --- a/drivers/net/can/m_can/tcan4x5x-regmap.c
> > > > +++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
> > > > @@ -90,16 +90,47 @@ static int tcan4x5x_regmap_read(void *context,
> > > >  	return 0;
> > > >  }
> > > >  
> > > > -static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
> > > > +static const struct regmap_range tcan4x5x_reg_table_wr_range[] = {
> > > > +	/* Device ID and SPI Registers */
> > > > +	regmap_reg_range(0x000c, 0x0010),
> > > 
> > > According to "Table 8-8" 0xc is RO, but in "8.6.1.4 Status (address =
> > > h000C) [reset = h0000000U]" it clearly says it has write 1 to clear bits
> > > :/.
> 
> I am trying to clarify this. I guess table 8-8 is not correct, but we
> will see.

So it is indeed a typo in table 8-8. The register is R/W.

Best,
Markus
