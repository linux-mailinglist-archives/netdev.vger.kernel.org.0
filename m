Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A2F662C74
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbjAIRQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbjAIRNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:13:22 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4517B3593F;
        Mon,  9 Jan 2023 09:12:59 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ud5so21855669ejc.4;
        Mon, 09 Jan 2023 09:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVk2tvkPkHZ5g5LNY7Urh46Jb7AWYeyBlt2KxlDaies=;
        b=duKNLUsYGhXRTrE9ZiLvdX3iSKSJh+lfgoJMb4IH0MnDqXFO8mY3w3PeEg12au6y+8
         GkgZ14QeHbAlheEmWhwQJengL9nuI/IcG9XpuqqVpwcR9WPzgcoL6VMq5V4rEb2VO938
         9/DjmIwO6obyUwEVqFVvLmsCi6lZmzXolAxPL+WMKUPO8ezPIljsbrTsBweOvGugwK9J
         vblsWktOBq7dCPqxDzmDkEs27ElrGWQPNlDRuzvL+LbI6IRQmdQjoFDMln8SRm6YM0V1
         VMeCJMkNjdVjFda361lCSRpwHk7Z7UmlCPIblhHLLGrbIn2E0lmgKcbGN6LGOFXFpvl6
         eN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVk2tvkPkHZ5g5LNY7Urh46Jb7AWYeyBlt2KxlDaies=;
        b=PKlN1UkG602MrBcDxnJuFWFmlNUgHbaSfrRdQUcV6gaUtfhJUg8ZH/pP9pJSqPm0pN
         LCNEiArlbpoLG6k+UbLh9us4NDcL0bM2SK4YzM2ORQdZrM8xmafRj8noJZOhXMJ5135N
         ALrWhS3H8VxyN2VzZKrllRCYTxi+WeZHAHTTniuyMZt4xemlbgvtFpsPH36SkkgxmfWh
         sxuVzzNn9woOrp40alOUoqFqOFi1E6eC6R7Bs4vT03xWXj7gKvpNPEGkedX9ZxXvJ7BS
         7IONN0PFtXEtDtGf0XWAHu0vUeR92YqpePlozuRn8QMPrtONCH64P/XkUL6xxx1EgLoi
         QbWA==
X-Gm-Message-State: AFqh2kqfTE16nN0u2mgBoWgzeZe3srH+7Ztfxpl1YfK1VklTzVbKEME/
        FKVuSySyI42EloQUoUYGH2k=
X-Google-Smtp-Source: AMrXdXv6LkBRqT1IjUHh5J3DACwxjZUP9+aHvFVN9x7nofrt1xe9gNF2AaBJRLTktMkKxjmm9FAMsA==
X-Received: by 2002:a17:907:8dcc:b0:84d:21b2:735a with SMTP id tg12-20020a1709078dcc00b0084d21b2735amr10793393ejc.54.1673284377776;
        Mon, 09 Jan 2023 09:12:57 -0800 (PST)
Received: from gvm01 ([91.199.164.40])
        by smtp.gmail.com with ESMTPSA id y9-20020a1709064b0900b0084d34979423sm3044981eju.127.2023.01.09.09.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:12:57 -0800 (PST)
Date:   Mon, 9 Jan 2023 18:12:54 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y7xLFruSoyrWye3X@gvm01>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <b15b3867233c7adf33870460ea442ff9a4f6ad41.1673030528.git.piergiorgio.beruto@gmail.com>
 <Y7m4v8nLEc4bVBDf@lunn.ch>
 <Y7tYT8lkgCugZ7kP@gvm01>
 <Y7wXO7x7Wh7+Hw/Z@lunn.ch>
 <Y7wi3qwG3b6i0x7T@gvm01>
 <Y7wjmu9P2TXuNMeE@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7wjmu9P2TXuNMeE@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 03:24:26PM +0100, Andrew Lunn wrote:
> On Mon, Jan 09, 2023 at 03:21:18PM +0100, Piergiorgio Beruto wrote:
> > On Mon, Jan 09, 2023 at 02:31:39PM +0100, Andrew Lunn wrote:
> > > Linux tends to ignore Marketing, because Marketing tends to change its
> > > mind every 6 months. Also, Linux ignores companies being bought and
> > > sold, changing their name. So this PHY will forever be called whatever
> > > name you give it here. The vitesse PHY driver is an example of
> > > this. They got bought by Microsemi, and then Microchip bought
> > > Microsemi. The PHY driver is still called vitesse.c.
> > > 
> > > How about using the legal name, 'ON Semiconductor
> > > Corporation'
> > That's perfectly clear Andrew, I can certainly see why Linux should
> > ignore marketing.
> > 
> > Sill, 'ON Semiconductor' is the old company name, the product datasheet can be
> > found at www.onsemi.com. I would honestly feel more comfortable using
> > the current company name. If you really want the first 'o' to be
> > capitalized, then so be it. Hopefully people will not notice :-)
> 
> I would prefer it was capitalised, to make it uniform with all the
> other entries.
I've just re-submitted the patches, fixing also a warning on a
multi-line comment w/o newline.

Thanks!
Piergiorgio
