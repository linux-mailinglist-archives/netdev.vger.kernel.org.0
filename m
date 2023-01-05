Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE4065F2D1
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbjAERfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbjAEReu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:34:50 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE5BD2DB;
        Thu,  5 Jan 2023 09:34:49 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b88so46461129edf.6;
        Thu, 05 Jan 2023 09:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/8P9qLgjiMzV8lpWcePHnq/MxKq7ehjDKoilzFu5jD8=;
        b=ZLm5OfteTIQ1dXkWac5VK6XVTZBoPaHWivbbm+YuBfzMa6zJwCgvDpbaH+E6NZsDDg
         y7kqEb1aAKcY0HG8ASjrC8azw3TN/nuUZ4iUJyYf4eSmmLK7QsSS6yrGMsL5xQgygek/
         buB3E5eRUEzhqIgFs0+vHb4+JfXc/+coS2bkbg3p5ojUzFYdDv9rELz1tqCy86w0clq+
         WIt05CnixdKqsfRisO6qP2NaIqca18gehw2uw2ip2Eot+4Ge0uG7WrPGVzzwtXHtu9W1
         LrWC6tW3Bifp/XaQ+Iidonvm/NV7iOcsS0V76/m7R/9pRvNo0m0CpHmdDyV5cVwF8x6M
         wzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8P9qLgjiMzV8lpWcePHnq/MxKq7ehjDKoilzFu5jD8=;
        b=a0MLzaCgGnNsC9wBr/MCQQ3OZDzkD4UG7DQrch8eS3IyIGKTzBE5oy4Fj3DepFogE/
         aq60I1FIdIiEfWcVYPYL+eVeyRzl7po56yTHaRgDwQCRh7jNGh2INy41aiS7bQsM4uWq
         FB+R5AKmwF9okICX4jjacsPgxtbwdPLyAkoVOqiHCNwclzSV/N4norGy3KhjspRYprup
         Ce+mrOh6PmZjQMeZFSPrVYkUc5gmJNiuKvdHxxC8550y9XbsJKCyGSeDX6WT2Uf9gyNS
         gNOEPSnRKv3T1OuqrTtx5eZHKG0GsZtq+L5I8A/QfG65YHF27Z2LfVlTteb9k0UXqHal
         RrZA==
X-Gm-Message-State: AFqh2kpr329Tv18N6I6QCpmQD5osYozJmXEHXAl0ppuH2a5fiekqwXmr
        7rWJ9uBlUmTgjBtvCNjE2iE=
X-Google-Smtp-Source: AMrXdXsHLD/2PFkOxgRQtVaxOhpGj/wL5dSj+8f54VHz0LO/GfwunOoDyJGzTWZS7MzO/2Uj7Kp0zw==
X-Received: by 2002:a05:6402:449a:b0:47d:88f3:1165 with SMTP id er26-20020a056402449a00b0047d88f31165mr50665235edb.12.1672940087853;
        Thu, 05 Jan 2023 09:34:47 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id t18-20020a056402021200b0048447efe3fcsm13566818edv.84.2023.01.05.09.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 09:34:47 -0800 (PST)
Date:   Thu, 5 Jan 2023 19:34:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230105173445.72rvdt4etvteageq@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 11:21:14AM -0500, Sean Anderson wrote:
> > Your code walks through the speed_table[] of media speeds (from 10M up
> > until the max speed of the SERDES) and sees whether the PHY was
> > provisioned, for that speed, to use PAUSE rate adaptation.
> 
> This is because we assume that if a phy supports rate matching for a phy
> interface mode, then it supports rate matching to all slower speeds that
> it otherwise supports. This seemed like a pretty reasonable assumption
> when I wrote the code, but it turns out that some firmwares don't abide
> by this. This is firstly a problem with the firmware (as it should be
> configured so that Linux can use the phy's features), but we have to be
> careful not to end up with an unsupported combination.

When you say "problem with the firmware", you're referring specifically
to my example (10GBASE-R for >1G speeds, SGMII for <=1G speeds)?

Why do you consider this a firmware misconfiguration? Let's say the host
supports both 10GBASE-R and SGMII, but the system designer preferred not
to use PAUSE-based rate adaptation for the speeds where native rate
adaptation was available.

> > If the PHY firmware uses a combination like this: 10GBASE-R/XFI for
> > media speeds of 10G, 5G, 2.5G (rate adapted), and SGMII for 1G, 100M
> > and 10M, a call to your implementation of
> > aqr107_get_rate_matching(PHY_INTERFACE_MODE_10GBASER) would return
> > RATE_MATCH_NONE, right?
> 
> Correct.
> 
> > So only ETHTOOL_LINK_MODE_10000baseT_Full_BIT
> > would be advertised on the media side?
> 
> If the host only supports 10GBASE-R and nothing else. If the host
> supports SGMII as well, we will advertise 10G, 1G, 100M, and 10M. But
> really, this is a problem with the firmware, since if the host supports
> only 10GBASE-R, then the firmware should be set up to rate adapt to all
> speeds.

So we lose the advertisement of 5G and 2.5G, even if the firmware is
provisioned for them via 10GBASE-R rate adaptation, right? Because when
asked "What kind of rate matching is supported for 10GBASE-R?", the
Aquantia driver will respond "None".

> > Shouldn't you take into consideration in your aqr107_rate_adapt_ok()
> > function only the media side link speeds for which the PHY was actually
> > *configured* to use the SERDES protocol @iface?
> 
> No, because we don't know what phy interface modes are actually going to
> be used. The phy doesn't know whether e.g. the host supports both
> 10GBASE-R and SGMII or whether it only supports 10GBASE-R. With the
> current API we cannot say "I support 5G" without also saying "I support
> 1G". If you don't like this, please send a patch for an API returning
> supported speeds for a phy interface mode.
