Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5568576E20
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 15:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiGPNNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 09:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiGPNNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 09:13:52 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A510A7659;
        Sat, 16 Jul 2022 06:13:50 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id b11so13339004eju.10;
        Sat, 16 Jul 2022 06:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vypCuEq/rCX9HvlkITtGSPUFoDxSLRPZn98T+qV3Xf4=;
        b=WjA5VfCC/rZXpbOeSX9aHYmBGP49eby3ugoPBRHLpX5UQxvaT/LsKYkLfAIFJtNSGd
         ca1rd41z4niKpWi5tihqGcMdIdgzf+++E86A0mPqYKnHofAEF+Jbo2LcVRyh5Qq4a7HV
         +POutI91tGrQq1pj6ZraycCRcfSRfXZ+/h9Dg6SjBqtdgD7/09e3VSyN8KdPzF+gTmFQ
         mwZ8nFqh2whpQExmhq+sIyGjsw8m/1lz3zX1rH89jSw7++GBy7EZBVdVesFaxfqMwf+f
         sGWjTuslkljUN/35i8ZAkIOev5RTwINOlmLBOpKCG+YG8AVNRVkl2Hu0jGZmW/EyHMvB
         fMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vypCuEq/rCX9HvlkITtGSPUFoDxSLRPZn98T+qV3Xf4=;
        b=zDI5ZUcWCRBvaQwoMPqyOHDgdPuY7o2/ldzXFFmeU0yZp1iJpgxCTVo+uJEK/ySKuH
         rGm6+++S3iM1IMIOtjbGyG8uJ26AqCr8tESdG4789fFXxCMydwvRnX13r3BYptOz7qy0
         4E7Y3QIqQIlpg7pcu8Zt603BNDH45A/Wg0I5H3M0DVKNIO5lyMRAFlLUFJrgjaTTDqs7
         qLP7AqGQ4RerX1EPpETeiHK272YQDwSrCsNCMaUT5jJppshchb/R3ScffRHDRrnxNt+G
         2V+1ISmoKvNgbXZS3jUNSZRtdx8Xhfr8DcxD4OwSF+kjSpj9p8dlV6qQ4SksfrueJtro
         YGSg==
X-Gm-Message-State: AJIora/Oq5FOijKt6/jSa5ztKMb49rao9ymR1/RR1KDkbSle1JwGVt9+
        Qt/d2pbu8J/GMiJtOOIthHI=
X-Google-Smtp-Source: AGRyM1v6lwArwzwqDjUSKayn7lfOf6YdBDjzkR+KmWYHKQQRa+FZwUV3F3Eo1RWzpX/X4H1xYJfwPg==
X-Received: by 2002:a17:907:6d01:b0:72f:53f:7a25 with SMTP id sa1-20020a1709076d0100b0072f053f7a25mr6177694ejc.126.1657977229200;
        Sat, 16 Jul 2022 06:13:49 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id jl10-20020a17090775ca00b0072ed9efc9dfsm3203279ejc.48.2022.07.16.06.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 06:13:48 -0700 (PDT)
Date:   Sat, 16 Jul 2022 16:13:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <20220716131345.b2jas3rucsifli7g@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <20220715171719.niqcrklpk4ittfvl@skbuf>
 <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
 <20220715160359.2e9dabfe@kernel.org>
 <20220716111551.64rjruz4q4g5uzee@skbuf>
 <YtKkRLD74tqoeBuR@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtKkRLD74tqoeBuR@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 12:43:00PM +0100, Russell King (Oracle) wrote:
> In the first RFC series I sent on the 24 June, I explicitly asked the
> following questions:
(...)
> I even stated: "Please look at the patches and make suggestions on how
> we can proceed to clean up this quirk of DSA." and made no mention of
> wanting something explicitly from Andrew.
> 
> Yet, none of those questions were answered.
> 
> So no, Jakub's comments are *not* misdirected at all. Go back and read
> my June 24th RFC series yourself:
> 
> https://lore.kernel.org/all/YrWi5oBFn7vR15BH@shell.armlinux.org.uk/

I don't believe I need to justify myself any further for why I didn't
leave a comment on any certain day. I left my comments when I believed
it was most appropriate for me to intervene (as someone who isn't really
affected in any way by the changes, except for generally maintaining
what's in net/dsa/, and wanting to keep a clean framework structure).
Also, to repeat myself, blaming me for leaving comments, but doing so
late, is not really fair. I could have not responded at all, and I
wouldn't be having this unpleasant discussion. It begs the question
whether you're willing to be held accountable in the same way for the
dates on which you respond on RFC patches.

> I've *tried* my best to be kind and collaborative, but I've been
> ignored. Now I'm hacked off. This could have been avoided by responding
> to my explicit questions sooner, rather than at the -rc6/-rc7 stage of
> the show.

I think you should continue to try your best to be kind and collaborative,
you weren't provoked or intentionally ignored in any way, and it isn't
doing these patches any good.
