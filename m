Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE546C8DEC
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 13:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjCYMRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 08:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYMRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 08:17:01 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3362D73;
        Sat, 25 Mar 2023 05:17:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id i5so18012903eda.0;
        Sat, 25 Mar 2023 05:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679746619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ufDezf/2mgJNNUHYMvg3SzSTeTnAgZrcDpCGtiA56M=;
        b=qhOVvNNnXRBXooYnUbLCDtzLTKwcVnR1SQnQiBtBDHjX8/KDpDriNw9v5GX/fjbnzM
         MAdQTPjUhD+OuNMtxvauTp45dYbw7x/tm1B26UwFEBYTk+s8qYOH/SZptVRlEp9VnxK1
         qyiFpLnH6oETfb0C7ezQr6D647E8XZzUtqKWNAoZ0WdDpGTl62e/+Jxh+85ud4JrIFfx
         WWyvCrkIOx9eX/sXMvksdhOc9hVBztJdvAuhNs1S47DZzVWDh1sB9zPkuYu9VEB8DQUl
         gxPfY1Fj4s1d1VQmNw6XvldUEeHalscJ6EkMqGyQBCYbXgwrslM1L8f6GxW3BnXRiE4D
         KJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679746619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ufDezf/2mgJNNUHYMvg3SzSTeTnAgZrcDpCGtiA56M=;
        b=r3K/EjFJ6ut9SUJ2MLm/U9WT1Myr22qOTqMK2yLR/xpOVJJm5qK7RmYNwC03GZKcw8
         hOrpPOKZbdfrnbpp4quAXfGTRMy9fp1/WGmmD7S50onRv9MS0Fi0zn58LIV+ZPFgSN4X
         F/gP3JQ5EquB4iKhQRmyA8bFcw27QhnUj03Gb9k9JIgzNnm5e33R1K9NGSl1q2WCjYRW
         rr2K+pJEpYfQnSMC8P/zYzaNsY607C9uzTlNGtH1W2OFyNDez03f3wA/gUaNjgaIOt9n
         ut3w0N1j/WxGBdoBM+BIpCW6SA57JS1gM8Zlx/2fo43vvH6ahZ3DqMiyUS74xSYTYm6D
         pIwg==
X-Gm-Message-State: AO0yUKXn+9j3ZhlGvtjSw7vGrgJSMUmgx+ku0KCqdGY1el/D0Q+uuC3a
        qAhOodSJsCBm50t8J3kTHhg=
X-Google-Smtp-Source: AK7set+wjsV7F+KibMR9vLtoK0XJdVSooCdWPgVyXoreBEyO64agi/Fulp/XCvbzfPWdOGg8jkAnDg==
X-Received: by 2002:a17:906:445:b0:8af:3382:e578 with SMTP id e5-20020a170906044500b008af3382e578mr12949402eja.4.1679746618619;
        Sat, 25 Mar 2023 05:16:58 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090607d100b0093a768b3dddsm6282615ejc.216.2023.03.25.05.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 05:16:58 -0700 (PDT)
Date:   Sat, 25 Mar 2023 14:16:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Ben Hutchings <ben.hutchings@mind.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 2/4] net: dsa: microchip: partial
 conversion to regfields API for KSZ8795 (WIP)
Message-ID: <20230325121655.oz3afcempaaniqc4@skbuf>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
 <20230316161250.3286055-3-vladimir.oltean@nxp.com>
 <20230317094629.nryf6qkuxp4nisul@skbuf>
 <20230317114646.GA15269@pengutronix.de>
 <20230317125022.ujbnwf2k5uvhyx53@skbuf>
 <20230317132140.GB15269@pengutronix.de>
 <20230317140722.wtobrtpgazutykaj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317140722.wtobrtpgazutykaj@skbuf>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 04:07:22PM +0200, Vladimir Oltean wrote:
> On Fri, Mar 17, 2023 at 02:21:40PM +0100, Oleksij Rempel wrote:
> > If you'll give up, may be i'll be able to take it over.
> 
> I have not given up yet, I just need someone to run a few tests on KSZ8795.

Seeing that the first line of people (able to test on KSZ8795) has no
opinion, maybe it's time to turn to the second line of people.

Russell, you've expressed that this driver is "vile" for permitting
access to the same hardware register through 2 different ksz8795_regs[]
elements. Does the approach used in this patch set address your concerns,
or in other words, do you believe is it worth extending the conversion
to the KSZ switches that other people can test, such that the entire
driver ultimately benefits from the conversion?
