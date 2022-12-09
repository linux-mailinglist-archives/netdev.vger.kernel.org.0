Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4CF648747
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiLIRHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiLIRHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:07:25 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCA99D896;
        Fri,  9 Dec 2022 09:05:54 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so12971331ejc.4;
        Fri, 09 Dec 2022 09:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V9HH5/Q/ZXGLIYrLL/jsX1Wvnszqx04FlI27U7A4YSE=;
        b=UkSZa0jip2PCMoAVGzDgsOljXaWxlJUjO6lTqvs7mgU7VsmoNZnbrOuIKw8sJGOrTE
         pmtVyLawCgEdPI2dE5qixKZUnPO2OE0sI7TTiY3kt+yCdE3N9QGHpCSyMTcCJAz8W0xf
         fKisly+ooiMwYB8irHWGMeo6IdSEw5tjFD/jSiuGcCaL5d+detI0Ck4f6YegXCm6Z/Lj
         XfCGeFpqDFpQLE782ypLw0Y4/zW27zweYKsXOn5wP3VwAogdvbzhfaDffJlTQhFat9oo
         pSo1EBZ0+f2nIrRRUNPy32cquRxL27FPRMgxMsVboabv5Mh1vPTSh6JBwmsuJ0srYVVw
         BNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9HH5/Q/ZXGLIYrLL/jsX1Wvnszqx04FlI27U7A4YSE=;
        b=wGo8oZgM4JPOy4QDAA2rBhrofkc7qEmgTSpz6q2fy2M1LyzWwaBPSmGDhpY6ke2S0+
         IY14I2hf819J3M/9JoCwpRCvWDyp0w7qa0R4WLLu2NEQBfzsNG9WJ6Ze5YbQLoT1gPGg
         HFzLZj0dXj3Z+cIgi+7IW8qa8NOkzv/zuA9Fjn19d4At88UK25UjdlG0Jh/kUz2PFh2B
         UqLb1VWTgWcazahyIlaAsrJA78ITqpe8aVKFPNFGrXSu49AjWzgZU5LWF/fhiEacLIzW
         11uxnoR2Is8OhWBwQ62HUtzSSvbrEdevuZ5ZI88Eod6j6uB4aP+Kc42yssWIvVjWP/Fa
         0aKw==
X-Gm-Message-State: ANoB5pnvzVnsxAWahmu2tGF6mJRoBDgrp55S0+siPFGczbdwdw0+O/r9
        XSxKty/NKTHPH9luSZ1twiM=
X-Google-Smtp-Source: AA0mqf68TUBWPm7jzqXobVKWAP1l1AiBtc0brkLA5r92jLwIiYFD9xuYrO9iJsmbARj7C8FTNpkDIQ==
X-Received: by 2002:a17:907:c787:b0:7ae:126a:99b8 with SMTP id tz7-20020a170907c78700b007ae126a99b8mr6459901ejc.61.1670605553268;
        Fri, 09 Dec 2022 09:05:53 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id kw26-20020a170907771a00b007add1c4dadbsm118982ejc.153.2022.12.09.09.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 09:05:52 -0800 (PST)
Date:   Fri, 9 Dec 2022 19:05:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH v2] net: lan9303: Fix read error execution path
Message-ID: <20221209170550.o3pro2tx5n6lh7pa@skbuf>
References: <20221209153502.7429-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209153502.7429-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 09:35:02AM -0600, Jerry Ray wrote:
> This patch fixes an issue where a read failure of a port statistic counter
> will return unknown results.  While it is highly unlikely the read will
> ever fail, it is much cleaner to return a zero for the stat count.
> 
> Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
> v1->v2:
>   corrected email header: net vs net-next, Added 1 maintainer, removed
>   blank line.

Actually it's not "net vs net-next", but rather, "nothing vs net-next".
As you can see, the patchwork CI complains that "Target tree name [is]
not specified in the subject".
https://patchwork.kernel.org/project/netdevbpf/patch/20221209153502.7429-1-jerry.ray@microchip.com/

Anyway, I think it's quite obvious for maintainers that it's a patch
intended for the net.git tree, so there isn't a reason to resend this
patch, just something to know and to do better in the future.

>   No changes to the body of the patch.
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
