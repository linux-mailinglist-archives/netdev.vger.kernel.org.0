Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACC1587B79
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbiHBLTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiHBLTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:19:47 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E81C5FE6;
        Tue,  2 Aug 2022 04:19:46 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id a89so17184183edf.5;
        Tue, 02 Aug 2022 04:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=khmnL6d1sgXdfX9qYl6R3hkeD9PilhxrNFLSsOskVQc=;
        b=HUaQKZpQyW2QYB9dHrq57sstOlNMtEPZqiaY8X2Lr7mimAT3laXRgSQiaHmJcR0Rhm
         ETE/v8Leoc5Bp8DtdrINYYT0E1CBpM5j0G1ohbaWPBoG/o0tjiAXjQDUQSI6Ov1hO8fu
         SkokhYBbMwrA6EfjOJodxxXFNdD9MtwZMpl7EGASFMRpZTUp5x8XxtLGwXcYAxbPDNF5
         flWq8b6Ki4DpnQjA2UHLTi09abkdnnSvoMmYfI1JD85lewAUSbGYDLeiYvj9jTpz+UuC
         pQ19Up7uylNV14xOciLcNIZZJXzfpxF6tgtn6eg08DQHgLbQ5D6qnCawwtueAbo6IEIo
         PdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=khmnL6d1sgXdfX9qYl6R3hkeD9PilhxrNFLSsOskVQc=;
        b=iKyGvcad9eZDUg/t47n9dyZoD6Kd0cVE7ORHRxqK/F8Z5ajpdWTU6Q5H+5DE9NszfZ
         5cy7LXUo8vBQUrtHyX7HgFrYyuYuM0CyssWIEv+IyMDGe8btzEoHlt4ZLDQnMPsDm6nG
         em4L/BFZx2xuQDOPle+231Yj4oMEn7HUGt1exdoHGeDZgpPGj50OoLLd4CuhE5qGv2ha
         kNt5fhobI252xhtsAXuieJvNblFunWOiNaHMYO9SJ0Nz2jxt62N8g4NanVHoVgD8QIxQ
         2UW9mcr31A7+luV5AqtNxim/NV6fwnmpXkFSA1qVBmJpTr3tbmbImq93rtotdS4j46pj
         7smg==
X-Gm-Message-State: AJIora9Wo1/Kcmw16ENMmhubrb/v2xBhA4LWCZg3IQodioWS5caY+i50
        xAV75NDKYAFWQrWScQdUXto=
X-Google-Smtp-Source: AGRyM1uUr0UWq3pPVrtU08Zm+s7iLRGdsFCvoQndfW/Eq+kllX683fbu3T4nXtoluVAU08BynF4nyA==
X-Received: by 2002:a05:6402:34c8:b0:43b:e7b1:353c with SMTP id w8-20020a05640234c800b0043be7b1353cmr20321484edc.171.1659439185040;
        Tue, 02 Aug 2022 04:19:45 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id l15-20020a170906644f00b0072efb6c9697sm6163311ejn.101.2022.08.02.04.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 04:19:44 -0700 (PDT)
Date:   Tue, 2 Aug 2022 14:19:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 03/10] net: dsa: microchip: forward error
 value on all ksz_pread/ksz_pwrite functions
Message-ID: <20220802111942.bwhtzz4hpmoiupxl@skbuf>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-4-o.rempel@pengutronix.de>
 <20220729130346.2961889-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729130346.2961889-4-o.rempel@pengutronix.de>
 <20220729130346.2961889-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:03:39PM +0200, Oleksij Rempel wrote:
> ksz_read*/ksz_write* are able to return errors, so forward it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
