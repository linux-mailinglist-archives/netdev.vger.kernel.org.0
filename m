Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1D442B09
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 10:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhKBJyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 05:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhKBJxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 05:53:15 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065B1C06122C;
        Tue,  2 Nov 2021 02:50:31 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so1609779wme.4;
        Tue, 02 Nov 2021 02:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oV0s+u8QiQmnjKjuoPQXLkVGEgq7irgWfISNaVxibvg=;
        b=I125bBsZTLZQrrB6vgaRjifQrWb+2NrjcGJhEgRURoeoOl0JFL+rMBOxYYpYaxpZK4
         +fWowieHZNM8x+TaJn2uG94gbouK0+mM7287Kj0ML/Phm/J0k0yTHTTz6XiFpxNG3IW3
         CrZ9Ga1Lq8a15snM9kS+B2K3fI28qXQxIwSgpjX7+/iPmS1Vv2K3iJPYW0JNJd2LwFAq
         abCpUA8VH/gb87JyJrJmrCRqbWY0etfTu/kHVUYn8jU4erkonW25JON4FqOr4E4JCLMY
         +A+aXhg9btdMgMW131d/3v+AK/mlCjCyZqVbblD5Cvec/PFDqeTZMOCKlcw/mctAl0al
         9pwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oV0s+u8QiQmnjKjuoPQXLkVGEgq7irgWfISNaVxibvg=;
        b=N3r297pLqVoi01jdWT2mQ6ytSpiCjPf7gekH0Qayx3dUVgo5y+a1iBYezyJ3kcVuF0
         0TLBGwUwuKEVtIdMOx2Upr2LlSgbl55Lc/dwyYCRRi4Wc3hqtUpsT1B/GIViWt2woA3P
         ABwCMH6oYTYMusLOXNUaFWop2QgF+s/WhAtwhTzGV7jyo4q4+scfPPUKGu2diBr2wr8n
         F+HhLLENOQk5UWrhi6PKjrUPcpUtvkhhZjtKMraQbZJPBl4shFcZ1xrdwV8iK7mDX/cJ
         hC0clKfKsZ6cDe02ZAceJbhHe6ICP9TocoJcIQH4B54IfBzU23m5DI8qoTTJh8vVUiPy
         sHSg==
X-Gm-Message-State: AOAM531QezACDKPgXtr3s0Fn9AEsEin5+PsBxwClgZGS5OVLjAhUv3Ez
        h79SYvBWuxB5V0q9E3Xy65Q=
X-Google-Smtp-Source: ABdhPJyPqqYUMd0iwbhra9iG2MqPMTGLA5Tg7Dl8bOVs4AJeHOjyNGH5F8AnmcpcUlSU47S2aIT1ng==
X-Received: by 2002:a1c:ac03:: with SMTP id v3mr5695607wme.13.1635846629643;
        Tue, 02 Nov 2021 02:50:29 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id o8sm4262688wrm.67.2021.11.02.02.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 02:50:29 -0700 (PDT)
Date:   Tue, 2 Nov 2021 10:50:27 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        kuba@kernel.org, linus.walleij@linaro.org,
        ulli.kroll@googlemail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: cortina: permit to set mac address in DT
Message-ID: <YYEJ46n978BjGF8H@Red>
References: <20211026191703.1174086-1-clabbe@baylibre.com>
 <YXiYZGEiVMLdN1zt@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YXiYZGEiVMLdN1zt@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, Oct 27, 2021 at 02:08:04AM +0200, Andrew Lunn a écrit :
> On Tue, Oct 26, 2021 at 07:17:03PM +0000, Corentin Labbe wrote:
> > Add ability of setting mac address in DT for cortina ethernet driver.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  drivers/net/ethernet/cortina/gemini.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
> > index 941f175fb911..f6aa2387a1af 100644
> > --- a/drivers/net/ethernet/cortina/gemini.c
> > +++ b/drivers/net/ethernet/cortina/gemini.c
> > @@ -2356,12 +2356,14 @@ static void gemini_port_save_mac_addr(struct gemini_ethernet_port *port)
> >  static int gemini_ethernet_port_probe(struct platform_device *pdev)
> >  {
> >  	char *port_names[2] = { "ethernet0", "ethernet1" };
> > +	struct device_node *np = pdev->dev.of_node;
> >  	struct gemini_ethernet_port *port;
> >  	struct device *dev = &pdev->dev;
> >  	struct gemini_ethernet *geth;
> >  	struct net_device *netdev;
> >  	struct device *parent;
> >  	unsigned int id;
> > +	u8 mac[ETH_ALEN];
> 
> Off by one in terms of reverse Christmas tree.
> 

Hello

I will fix it in a v2

Thanks
Regards
