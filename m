Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2686DDE06
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjDKOdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjDKOdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:33:45 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724431721
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:33:44 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ga37so21269329ejc.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681223623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xbThNpV0h2rrot2ClK3m/0dSEYM/5XMR8dXbUMNm3zw=;
        b=dc4kbSN/I5PG1JuxQZ7lNbcXoaBWd0fgqzfymH2z8veBzxKSu+FNHI/ySvS79nC+SP
         pNLSOUcg81LcR5C4BrziyqaxyEQiz2Fb/KomD3Id/zL9NXQoAH0LtjpADziWasCaTn4e
         49glPRyPidBjln6x2V+nsSMjIYpXbOVIAPd86Ro4emjCrsiJzvhmzwudLANvlsN72/8p
         OcXlKSxmWiSYRakiFVEo17ft+7S2pm2VSthskXTs7+IpMdHX4M8tpteigiKoAcV4Uggb
         K4eQYMhY2I6XM9MNVUtnjPdQu+z4VPQqqUgq+uBshMieK6cOrP6Spe6SFeEbE7EqNYOs
         4VTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681223623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbThNpV0h2rrot2ClK3m/0dSEYM/5XMR8dXbUMNm3zw=;
        b=GUJGhBBaIP20d6oEhoKK4LcpptroPOPilvfL71I/gr2xFcrjFbHmw5hTCHaYCcJog9
         eBz3eVfF6sUg2gpUr+31m3Bzd7v60gowjuq8Hgl89lOz2NnboEjh+39EAY2ME/4mVlRJ
         P1rV8kcf687Ne4S9Bh4JJvvrsuBJErqLvpA3d5Z5EBYKeZkEL+ARSbw8178EX9rhO2db
         SBPzt4/fZOGKar90eXQ1d8AIOHzOzT9PxBwi1AStsOMDtkt7AoLLr4jEr2hr1CEajl4L
         05Blv53f29FZD1AQYaFX0/ZpYMwE7hCY9weztR5rocc3UNOOc/HXGxJ+W3qSgvYkPXBL
         l19Q==
X-Gm-Message-State: AAQBX9dVdvKf7nAajKcSFtffccwAqcxuxHIngLB/6FzM9cw5u9UpBt/m
        GFpFBADucePAjvTd/gRPZRY=
X-Google-Smtp-Source: AKy350a+qsvG/r+SROAMZPZxIEBQBLvtmSQ7+VG6LVqHbZsMOOf+uJ1wFpYFP5+M1RL/YCCxNLeg2w==
X-Received: by 2002:a17:907:d689:b0:94a:58fb:2546 with SMTP id wf9-20020a170907d68900b0094a58fb2546mr9044792ejc.71.1681223622692;
        Tue, 11 Apr 2023 07:33:42 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id v15-20020a17090610cf00b00932ba722482sm6309486ejv.149.2023.04.11.07.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 07:33:42 -0700 (PDT)
Date:   Tue, 11 Apr 2023 17:33:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <20230411143340.cguwmjbyi2tyrjh2@skbuf>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:44:20PM +0100, Russell King (Oracle) wrote:
> Lastly, a more general question for ethtool/network folk - as for half
> duplex and back pressure, is that a recognised facility for the MAC
> to control via the ethtool pause parameter API?

AFAIU, the ethtool pause API is for PAUSE-based flow control (as defined
in IEEE 802.3-2018 annex 31B), not half duplex collision based flow control.
That being said, I don't know what facility could be used to enable
collision based flow control. I'd say it is an abuse of the API.
