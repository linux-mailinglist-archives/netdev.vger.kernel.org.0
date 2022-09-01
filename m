Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACB85A972D
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiIAMrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiIAMrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:47:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3BDBE1A;
        Thu,  1 Sep 2022 05:47:41 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qh18so14160936ejb.7;
        Thu, 01 Sep 2022 05:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=L8LYAuplDmX65ai3aFgfTnHS09hziX6y5/VG9KrFqy8=;
        b=h4Jcy3v7PeLVhJbHHmv7gPnhsG0ahzf9jg0DrRMQ2If+BrMOjxYr3AoMPGbpTbaM+w
         RpO9123lUcxq2jzmp8cQ8X9LFBkxmg2P8dOHwDQmhzCh6a9gqeX70MQrQXK459dHgP5Z
         xwerjVQ1Vrse84JGh5jmIt84J4CkOzZbxoSMCfPewAGF8NRHmk38w7ACeAFEr5epPIxe
         /AOpdvtdbfae29+Xd4YmOPg5WRuXuoz9KSID5/nNrgPWiknD/0bdIYRetX8dYbIPcsAK
         SyVPiInKZm6Gsy5On5AYaw2u8dTEdmJMO5ize/d6UDgXAZYt6Fqto3FErBJ8FZYRsi4R
         19pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=L8LYAuplDmX65ai3aFgfTnHS09hziX6y5/VG9KrFqy8=;
        b=I/ftqG/ZGv60GT/w14mezZcbXCCb+17dWDnmY8joxYEzJFvV5Gb3SjeKtLNcFAgqfD
         uFhsKQ9cLFXO0FyxPFaJYAW4ozBh4Un9WytGBfG9+rzDR4ItkaaqZD8A/hJShh7uHgHR
         Dfi0FwYSDnelEn5lCUGz9Y6cmb6qOBnnXQyl2No4MkU/MaprtrD9bkSDI12wBlz0ZVtI
         sXPDu9gpqO70TahuXg2qMnJy5At+8ElW2QL6+F8WrFulFu0EBnChbk8T4fg63ANvU5mc
         IPVZx7DKKREAsA9n57ecDUCHDRj1LSxqOFczJvMBG9/MoBenWquGxex0EJM8x5N8SZuq
         wv4w==
X-Gm-Message-State: ACgBeo2Cn2jPhqzK9nsczpr5TKQbdquITWTxfHkUuZQquAgQ43Y/6f4j
        m3IiuJmEl9ZPNZATix4mmu8=
X-Google-Smtp-Source: AA6agR66alJCNSrRBRWnjFW1b+uSJNL88tvbDYZoZQR75AWJRtXCtnRlVgPmiyG76kp8KPnTye93aA==
X-Received: by 2002:a17:907:7612:b0:741:6559:de26 with SMTP id jx18-20020a170907761200b007416559de26mr15649825ejc.582.1662036460386;
        Thu, 01 Sep 2022 05:47:40 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g18-20020a056402181200b0044841a78c70sm1278652edy.93.2022.09.01.05.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:47:39 -0700 (PDT)
Date:   Thu, 1 Sep 2022 15:47:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Arun.Ramadoss@microchip.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, san@skov.dk, linux@armlinux.org.uk,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Message-ID: <20220901124737.mrfo3fefjsn4scuy@skbuf>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
 <20220830065533.GA18106@pengutronix.de>
 <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
 <20220830095830.flxd3fw4sqyn425m@skbuf>
 <20220830160546.GB16715@pengutronix.de>
 <20220831074324.GD16715@pengutronix.de>
 <20220831151859.ubpkt5aljrp3hiph@skbuf>
 <20220831161055.GA2479@pengutronix.de>
 <6c4666fd48ce41f84dbdad63a5cd6f4d3be25f4a.camel@microchip.com>
 <20220901112721.GB2479@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901112721.GB2479@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 01:27:21PM +0200, Oleksij Rempel wrote:
> > The global register 0x06 responsibilities are bit 4 for 10/100mbps
> > speed selection, bit 5 for flow control and bit 6  for duplex
> > operation. Since these three are new features added during refactoring
> > I overlooked it. 
> > To fix this, either I need to return from the ksz_set_100_10mbit &
> > ksz_duplex_flowctrl function if the chip_id is ksz87xx or add
> > dev->dev_ops for this alone.  Kindly suggest on how to proceed.
> 
> I would prefer to got ops way, to clean things up.

I can't say that that one approach is better or worse than the other.
Indirect function calls are going to be more expensive than conditionals
on dev->chip_id, but we aren't in a fast path here, so it doesn't matter
too much.

Having indirect function calls will in theory help simplify the logic of
the main function, but will require good forethought for what constitutes
an atom of functionality, in a high enough level such as to abstract
switch differences. Whereas conditionals don't require thinking that far,
you put them where you need them.

Also, indirect function calls will move the bloat somewhere else. I have
seen complaints in the past about the mv88e6xxx driver's layered structure,
making it difficult to see exactly what gets done for a certain chip.

It is probable that we don't want to mix these styles too much within a
single driver, so if work has already started towards dev_ops for
everything, then dev_ops be it, I guess.

Oleksij, are you going to submit patches with your proposal?
