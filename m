Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8CF68A724
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 01:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbjBDANj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 19:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBDANi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 19:13:38 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AE973058;
        Fri,  3 Feb 2023 16:13:36 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id p26so19649981ejx.13;
        Fri, 03 Feb 2023 16:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1RPD08p4//HERkdGmEsi6ZpAb1Ehupu6jKa9Bwx4Ug=;
        b=g5SvMM3zIU/+ckWnrzKvg5/zyGhwmuEv6Ul+tNEW7pzJHxHnGYwg8CQ+3LlZf0lNrz
         L8zVAJvCGvwRFC8ye8tXIPXIfNOcgMP4fGqR1t2yncKzp8PcHw/Ni0DxZGwNEQbFoIjS
         z2qx7Rf0LMFwPSLWrpw6g2ZQFrnSvdMnlDEX7N/I7E2RWvZzlq7EscSVZ4By7ECDVT1V
         gTlILh8ghX60vwGlYiTxON7e82kbUV9+fHCSW5LNNc4osMCopmzrI0NHXNjhREFh+cCX
         icGay4oJijIhf4c6giu8rVU4CUHkx7osyjwN4qDwEP1tV+5DL9/y+L9WE+AVL2uLimNY
         5Wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1RPD08p4//HERkdGmEsi6ZpAb1Ehupu6jKa9Bwx4Ug=;
        b=I76tY8AQYhqXWkzDZODSyGeXIis3POMT50vjumFSDUHwogwHtl/sdZzROa1gIEGffF
         v6kU947D9U6kp2BhNnceYsVo3Yq852kl3opGF5hAONKCjvHXSUi6GGT8EGdPX5wNrLbC
         Xu8fQqze476UCm95Nf4CG8sMNpvwcc0ynw9r/r96uzxKWDLepOq06WmkrR5z1TTKQIt5
         sia6lCHxTORDyNl6p5ffmoUakA8Wr6QqA6Hk++Xp3h8y4u/1uxaxYVzn72aH9mr2ChMv
         uIeCx9559yRqvXcUQlstBmL/aqcZJdADCO8wK94o3HKRvaJDaEvrmCVqhx/J7KbL7F9/
         6C1w==
X-Gm-Message-State: AO0yUKW5vcdc0/DnhP6rlS/fgkubloMsgnXviMmZbrGpju5Ma1W9IxHH
        pNb/KLRhKjpNR5OfPsAArt9iIyHwnpTaIA==
X-Google-Smtp-Source: AK7set+KxCM0lI9jnGRvm6zsQmIKJorETTfiHEM/5QkXuia/mY2b9Vu2uszHP7DXs0RvqE0ivfpQEQ==
X-Received: by 2002:a17:906:5390:b0:878:5524:e92d with SMTP id g16-20020a170906539000b008785524e92dmr11768931ejo.33.1675469614875;
        Fri, 03 Feb 2023 16:13:34 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id s24-20020a1709060c1800b0088a0d645a5asm2095514ejf.99.2023.02.03.16.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 16:13:34 -0800 (PST)
Date:   Sat, 4 Feb 2023 02:13:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 00/23] net: add EEE support for KSZ9477 and
 AR8035 with i.MX6
Message-ID: <20230204001332.dd4oq4nxqzmuhmb2@skbuf>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201145845.2312060-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:58:22PM +0100, Oleksij Rempel wrote:
> With this patch series we provide EEE control for KSZ9477 family of switches and
> AR8035 with i.MX6 configuration.
> According to my tests, on a system with KSZ8563 switch and 100Mbit idle link,
> we consume 0,192W less power per port if EEE is enabled.

What is the code flow through the kernel with EEE? I wasn't able to find
a good explanation about it.

Is it advertised by default, if supported? I guess phy_advertise_supported()
does that.

But is that desirable? Doesn't EEE cause undesired latency for MAC-level
PTP timestamping on an otherwise idle link?
