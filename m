Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F035B6DD92F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDKLQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDKLQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:16:27 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600FFB4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:16:14 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id jg21so19028332ejc.2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5bjBPfHLTHiDXy8v4PSlpPXJJ0MA0T/QekU8XqDtEWE=;
        b=bVOEIeHXx7QysmlitN9puqMz4Fv74jVTVy3os69ATfenF+dgzaDx9XrYdGGAFG6oLV
         48hNOK+wZJLhkPFw1+eQ72JIUFiTwyUJ0/0yDNDhG4MS2FQfp3FJnBG+w6YAdzmrlr55
         q4sAJR47T3EKkAjPMMR4d2UmhuhzWxJULI6Fwn9VgHqwTmJ8zUmKMJYfxVVO6YpLoFEb
         4ZLo8Ns0kOr4WGHgiy7IMjUNl3ugdUPniiubOeyjrdtJ2K+aAbOY9rRTu6n8r80UB0jj
         6Y3fx3nIj/CwyWiOico/yvhTmieHQt+YeMPcsHVZn3c0NJtiHcb4SgL8u6W8I+/FAaBN
         knEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bjBPfHLTHiDXy8v4PSlpPXJJ0MA0T/QekU8XqDtEWE=;
        b=j0vbOlBzJGa24r8ouUF/kIpgzQYT5sKpCSF9Uk7PBwW8e9/0mZFL998AdAvAVzG0i3
         Kt/xTSWQ1yi185hcr/IgVBT8k5QV8jmuLJ/91TH3MQOdD4JUOcOwYgwzf+CQKzU7bMxi
         +wNkKt/cMzwzMBcO0Z2wxHLYLDS4oNyqucWNY5CSc1d1nTFRpbMUxtzbCDqA3ARikojn
         edUguhTuTZfREMH5EfRtqdNgQGueLNCwWhmYG57NQLzH3AvFesH0xOGdIZvJRtAqi7Ui
         y0PE4+/7KF+K/qijKbiNrSf+KEVa0o4zm9kJ5FSa8hkTRhKkDgjMvDFwa9pg36b7sRVK
         eVaQ==
X-Gm-Message-State: AAQBX9c1Kq1AiBKu2rSKjh5Vdm3IhuWFbhfsSb8f90x6I5XIGu/6RYuw
        q9Um7xSIhGX8M0tL0NOw0Ik=
X-Google-Smtp-Source: AKy350aVTSyrgX6eWF792rt+PxAH7SoueFJPcVlGOzDRRR/bufK7QqotXuhEXZolIiCBfWR6xPCa2Q==
X-Received: by 2002:a17:906:3a45:b0:949:ab5c:f10c with SMTP id a5-20020a1709063a4500b00949ab5cf10cmr7977332ejf.63.1681211772442;
        Tue, 11 Apr 2023 04:16:12 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id hc38-20020a17090716a600b0094a6a7a56c0sm2619701ejc.18.2023.04.11.04.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:16:12 -0700 (PDT)
Date:   Tue, 11 Apr 2023 14:16:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <20230411111609.jhfcvvxbxbkl47ju@skbuf>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 10:17:47AM +0100, Russell King (Oracle) wrote:
> Since we can't manually control the tx and rx pause enables, I think
> the only sensible way forward with this would be to either globally
> disable pause on the device, and not report support for any pause
> modes,

This implies restarting autoneg on all the other switch ports when one
port's flow control mode is changed?

> or report support for all pause modes, advertise '11' and
> let the hardware control it (which means the ethtool configuration
> for pause would not be functional.)
> 
> This needs to be commented in the driver so that in the future we
> remember why this has been done.
> 
> Maybe Andrew and/or Vladimir also have an opinion to share about the
> best approach here?

I don't object to documenting that manually forcing flow control off is
broken and leaving it at that (and the way to force it off would be to
not advertise any of the 2 bits).

But why advertise only 11 (Asym_Pause | Pause) when the PHYs integrated
here have the advertisement configurable (presumably also through the
micrel.c PHY driver)? They would advertise in accordance with ethtool, no?

I may have missed something.
