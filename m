Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF06664BAA8
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 18:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbiLMRKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 12:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiLMRKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 12:10:39 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81783DEBA
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 09:10:37 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id h11so16323471wrw.13
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 09:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w7bINMp8tykjrtmdTLoMymqvaH8kKY42pvQKrznvouI=;
        b=j6prwx0GnzEerg7Au3dHa0SfMc9i9k16MzGFk9+Pbcxt2Vzml6Z695tAZx+8NKLHX7
         01hRw45+/9m7O+apb/mP+1GnBZ2r8Wn5Fg2Jgd128IitWDClPnotNtTl4xeiTs1vClKe
         sT+Oi/n1klUvoX1QC1lpvkk2F8VwhCfcGvhv0a5/ZL7Shx6sqx2u8GdDj7Q2wSA6bimp
         rzZ9zooNPDIRGGmxQ/hWEhxRtkl8yKt0TR6VP9hfOlTxdlEWPydKAOszVMCQJwAFDSTf
         YXQBqjo/WIVf4xtEvE+WlPgMCg+edOfyqK4gskAuA77Dmx11sQD/Kjch3gciHBBGHFO8
         tVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7bINMp8tykjrtmdTLoMymqvaH8kKY42pvQKrznvouI=;
        b=tc1DWqINU5unmq2TJBB1qi8/EAnJ/XzrVwIsj6jTD5tJujQevWhzILddxLjaGofhmo
         vUAablaUGmFYuHln+GHZ+qrJlHN7z4tUpgNbQXyuiLAU0i7SUfdIP7mktnTrIaG6w2c+
         IkJ9BBuJ2CumzEpYFvpn0KFL1aF75en6JmHL8+SpAPnW60UKFwDJM9MbLpAsA5AOXSUX
         nBn/+jjKGeJi8VgyF9XXaE3NySioOr8kY6+DN2KLUe6Fq+lGnjMQt6UJjHueV+iXYOrt
         XM4wuiHT1+8SxiOncoOX0u1vXAnuXYGmvDh+3CIz4EaSR1KPS/zWylwHXbLnW4Xi/MAa
         O5Nw==
X-Gm-Message-State: ANoB5pmSWZp/xuGnAmkUolTf/PhouUz75rUzW4uXLEDOiBd55R4Ndx19
        ipSkm/FAhYBWMNTERoZvlz9irw==
X-Google-Smtp-Source: AA0mqf7FG7OAA2/Kw4X12f6YFjw23Tz7jc9JtZqHG/iwnPNMHjHcPtIFwW/Uc2icFKVoRTvLyBD3dA==
X-Received: by 2002:adf:fa0c:0:b0:242:1a1e:e074 with SMTP id m12-20020adffa0c000000b002421a1ee074mr12979095wrr.61.1670951436100;
        Tue, 13 Dec 2022 09:10:36 -0800 (PST)
Received: from blmsp ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id j23-20020adfa557000000b00241ce5d605dsm275175wrb.110.2022.12.13.09.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:10:35 -0800 (PST)
Date:   Tue, 13 Dec 2022 18:10:34 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] can: tcan4x5x: Specify separate read/write
 ranges
Message-ID: <20221213171034.7fg7m5zdehj2ksmj@blmsp>
References: <20221206115728.1056014-1-msp@baylibre.com>
 <20221206115728.1056014-12-msp@baylibre.com>
 <20221206162001.3cgtod46h5d5j7fx@pengutronix.de>
 <20221212105444.cdzzh2noebni4ibj@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221212105444.cdzzh2noebni4ibj@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

sorry for the delay.

On Mon, Dec 12, 2022 at 11:54:44AM +0100, Marc Kleine-Budde wrote:
> On 06.12.2022 17:20:01, Marc Kleine-Budde wrote:
> > On 06.12.2022 12:57:28, Markus Schneider-Pargmann wrote:
> > > Specify exactly which registers are read/writeable in the chip. This
> > > is supposed to help detect any violations in the future.
> > > 
> > > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > > ---
> > >  drivers/net/can/m_can/tcan4x5x-regmap.c | 43 +++++++++++++++++++++----
> > >  1 file changed, 37 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
> > > index 33aed989e42a..2b218ce04e9f 100644
> > > --- a/drivers/net/can/m_can/tcan4x5x-regmap.c
> > > +++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
> > > @@ -90,16 +90,47 @@ static int tcan4x5x_regmap_read(void *context,
> > >  	return 0;
> > >  }
> > >  
> > > -static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
> > > +static const struct regmap_range tcan4x5x_reg_table_wr_range[] = {
> > > +	/* Device ID and SPI Registers */
> > > +	regmap_reg_range(0x000c, 0x0010),
> > 
> > According to "Table 8-8" 0xc is RO, but in "8.6.1.4 Status (address =
> > h000C) [reset = h0000000U]" it clearly says it has write 1 to clear bits
> > :/.

I am trying to clarify this. I guess table 8-8 is not correct, but we
will see.

> > 
> > > +	/* Device configuration registers and Interrupt Flags*/
> > > +	regmap_reg_range(0x0800, 0x080c),
> > > +	regmap_reg_range(0x0814, 0x0814),
> > 
> > 0x814 is marked as reserved in "SLLSEZ5D – JANUARY 2018 – REVISED JUNE
> > 2022"?
> 

Yes that's a mistake, sorry. I will add a fixup for the upcoming series.

> I'll take the series as is, that can be fixed later.

Thank you!.

Best,
Markus
