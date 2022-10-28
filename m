Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597E06113AD
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiJ1Nz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJ1Nz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:55:27 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C5D6A52D
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:55:25 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s196so4905403pgs.3
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YVMVqTGOtEFUHvqLzW8u7KKYzrHA8X4JX2ZW5RMOIHs=;
        b=Bp0DLeoTr9tqQmw/a/KoubFjaxYq19PYGoJWFjby26jtJKi9vgwzBhZhAIH5XqdPnD
         4mCFSrYkSIDjeMet4ephkHWRRtTYSk0Lo02NmS6hAsdVsq98btwlI6BEEEc699CcqmqW
         iy392WaMkuJ7DuY/j4txn3bad/wUgQ0bd0wecl3gm1PR8RWy3Xuz6sIkgCzp0ldUgvIr
         EDwneOT8oy7lZ/FHi9nHqwWMr0Bo6hTEH1oJQQ32b/eJ7fXdqKRukdN2MQZ5NFF/mfNA
         ma1thjx1Ngl1lVVANvP1TWWBfmG3rPAXsDludhXbtflz7qz2opZqx1tOBk/Xhibkg1vV
         swCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YVMVqTGOtEFUHvqLzW8u7KKYzrHA8X4JX2ZW5RMOIHs=;
        b=mM3i5NPz2asK9lB9lPI+Q3J6g4UtoL+Gv5sCyAgtbP7TLIWVYXXKaB1H5B2I/yjTW8
         6ZP8cx+aLnd6F+CBr7hnGk7OfmwfRmxGd956srJYNeA7oLFcJ4TntpFwWDyss7kc5M0a
         OVtvz2eCHaHZvqlGWqFtn5ZNVPP33B6QEh1aylyEaSUOILYwYZtlZdoNkyYNVrVX7xOX
         6xWHY5hAb03b7QWsfDJS8bOz31Mrrs1Ww9luGO4EgLHfub8iCSjHwbqZt9LOj4q3NM9m
         Smx2D2CZP2ykqPI8/s6syiIaGvhUiagir8ZGhGlsa2UbCi88yig0aVYFC964yS1C9hD9
         8Iuw==
X-Gm-Message-State: ACrzQf2G760/I9h+lzNKJ3PqbX+bwYtf/RK/MxcrFieTuwWE6RUAxiat
        vCweA3WQK4kiILAorwK8Cs4I7/y1nFlJXWqdCEb1ieDn
X-Google-Smtp-Source: AMsMyM5G8wMVbjwmysrefZHdp4bh9hxpCbi/RQBFgMl5nzxOXn+bh15bMqd1SPmnJR3j0J3xg3tm4uEXos5MPTFVOog=
X-Received: by 2002:a17:902:d2cf:b0:17f:7b65:862f with SMTP id
 n15-20020a170902d2cf00b0017f7b65862fmr54818964plc.168.1666965313680; Fri, 28
 Oct 2022 06:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221028120654.90508-1-festevam@gmail.com> <Y1vJ3Y7ZpHuJA+Sc@lunn.ch>
In-Reply-To: <Y1vJ3Y7ZpHuJA+Sc@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 28 Oct 2022 10:55:02 -0300
Message-ID: <CAOMZO5CqiWM1_UsfUVqb+0ZcCe0Us1-87=h-Z_t+59b21voZew@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Add .port_set_rgmii_delay to 88E6320
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, olteanv@gmail.com, netdev@vger.kernel.org,
        =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Oct 28, 2022 at 9:23 AM Andrew Lunn <andrew@lunn.ch> wrote:

> Hi Fabio
>
> Thanks for the patch. The 88E6320 family contains both the 88E6320 and
> the 88E6321. Could you check the datasheet if this same change works
> for the 88E6321. It probably does.

Yes, the same change is valid for 88E6321 as well. Steffen confirmed
it and I have
sent a v2 with an improved commit log that explains this.

Thanks,

Fabio Estevam
