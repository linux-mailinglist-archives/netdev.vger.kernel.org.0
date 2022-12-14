Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4A164C7A6
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 12:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbiLNLEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 06:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237689AbiLNLEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 06:04:04 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD20F1006D;
        Wed, 14 Dec 2022 03:04:03 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id i15so21974340edf.2;
        Wed, 14 Dec 2022 03:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tqiLiL6r0fYhcc7k3mcuakS+Gyrq//weEnoaYloGQyU=;
        b=dBHAd1RK0tkqY1tbYPG77IVHv9SnYZu+/1gdvlrdhqEg4xiWP/c3XRnjdNEyEFfJ/a
         PxzO1W69l1uWBtAubQk6Az1RYsZwCfqSDVdIOSpmGcIpAafmav3pMBfAMPRKvtyG1kWY
         SE9Vw5uMQWbF5AJf5tWzSgq/HSaxNTZrtpnTgDWZGLz69Q+MmeX1qFcRXGzJomICGne8
         VGXp5bbDmz3j+fYv6IwnRtQxV8IE71sJUy3U3DTZe3okqYs1IXToOTkqk8OUjH+iTnTK
         S99DX78gDeTKIMi1ze8jVldQt4V1eC2kzI7p8b6e8/EN2glJvuMB0+KNhq3nUznsb4II
         /oyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqiLiL6r0fYhcc7k3mcuakS+Gyrq//weEnoaYloGQyU=;
        b=0Dc5LRzPZ7j5yXn/7rcSLFdalL9GKe+WXVpIj1ssz5zDZpVx//jh9dW38GDMExKmMc
         u/eHEUgvuALlNEzH7l/C5Dz14cDee0w7honqv/vN1h1h//xNGmRWMCpzkpPRG4aWsVz/
         i56Ga3fUG9RCxjTQnvjP5SeJTcjZgujRZQTf+6lZ/lmbFZ0rGxWZdt8IJngkwicQMFFB
         o4er2Kxj/YokyRpCqbUFXgNkOqdOAU6ovsVGbBpUftc/JrfldIpVVl+3Ta+0xtUT+YpS
         RKr7Vtc3/CqrhatD4NTzdrA8stvpW6PYshZOimY75hUj6BZTq1YdkkWNcyUtM0qqdcQ4
         ow5Q==
X-Gm-Message-State: ANoB5pl2hhz4y/0cKFFBLpjGJ/f/MAJrZDWue6ScrtjyYIYXi5r+r36m
        poJrmj5edutXQs9X5KdmcAlER0uLD0k6zw==
X-Google-Smtp-Source: AA0mqf7lyVdq1S7j+sOZCeBTs20GvxCqMAPSx/CqE44yl90v0FNvKkt8qVMvKIY0xoTBfq+2XDVLSw==
X-Received: by 2002:a05:6402:f24:b0:46d:ca42:2e59 with SMTP id i36-20020a0564020f2400b0046dca422e59mr23033833eda.11.1671015842125;
        Wed, 14 Dec 2022 03:04:02 -0800 (PST)
Received: from skbuf ([188.25.231.93])
        by smtp.gmail.com with ESMTPSA id i10-20020a0564020f0a00b004678b543163sm6247538eda.0.2022.12.14.03.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 03:04:01 -0800 (PST)
Date:   Wed, 14 Dec 2022 13:03:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Maksim Kiselev <bigunclemax@gmail.com>
Cc:     fido_max@inbox.ru, mw@semihalf.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Subject: Locking mv88e6xxx_reg_lock twice leads deadlock for
 88E6176 switch
Message-ID: <20221214110359.y4kam23sxby7vpek@skbuf>
References: <20221213225856.1506850-1-bigunclemax@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213225856.1506850-1-bigunclemax@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 01:58:55AM +0300, Maksim Kiselev wrote:
> Hello, friends.

Hello.

> I have a device with Marvell 88E6176 switch. 
> After 'mv88e6xxx: fix speed setting for CPU/DSA ports (cc1049ccee20)'commit was applied to
> mainline kernel I faced with a problem that switch driver stuck at 'mv88e6xxx_probe' function.

Sorry for that.

> I made some investigations and found that 'mv88e6xxx_reg_lock' called twice from the same thread which leads to deadlock.
> 
> I added logs to 'mv88e6xxx_reg_lock' and 'mv88e6xxx_reg_unlock' functions to see what happened.

I hope you didn't spend too much time doing that. If you enable CONFIG_PROVE_LOCKING,
you should automatically get a stack trace with the two threads that
acquired the mutex leading to the deadlock.

I've sent a patch which solves that issue here:
https://patchwork.kernel.org/project/netdevbpf/patch/20221214110120.3368472-1-vladimir.oltean@nxp.com/
I've regression-tested it on 88E6390. Please confirm with a Tested-by:
tag on that patch that it does resolve the deadlock for 88E6176.

Thanks for reporting!
