Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2B563911C
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 22:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiKYVdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 16:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiKYVdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 16:33:09 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7F211A15;
        Fri, 25 Nov 2022 13:33:08 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z18so7886417edb.9;
        Fri, 25 Nov 2022 13:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aO55jyEdMSTtw8U+yr63CHpGrdAD1Rit2ONAPjiW5Qw=;
        b=QW2d1AVi+NfKC9YrK0+rbkYVChYugDDFeRmAj83EglDi2HC1IWHq49Z9dCbaLZ7QLU
         rHq+sQkym2CIBlg9wYVEIN6URS7Mg+2K0IyhDlBeOr1bLc5UvsqHTWK3meeKlQIddvTr
         habnJaT6nMny9c/E1yiqMCk2n4FoxeZanQR6zHASrgLglBu5E3hpXCnv7hxHxeoaFIIh
         dYaPi3Po1Mf3d1H/euC3QXvZdARZ8j1c3CQp9/Yyx7CAeqAOWhj0MAlW82XAqxZ6OyM0
         9zKU0ePT60RKumoo7SztBur8cthbouRx0AOOzntv/lGrJGRoJWEEU+dVDh5oNO7U1UK4
         7Amg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aO55jyEdMSTtw8U+yr63CHpGrdAD1Rit2ONAPjiW5Qw=;
        b=lMbkrKosVxJjh2393mXRYeF7pxRPpUIly5ZE6RB5b02s5u54qchV3lVhe/OyfhT3LP
         FZ25gGBkMxLWZEbZTMMjeKiJ0OKGLNKmyp7zC1+6kJi8+w5C5Hg+xALzkUU82xgY0h8e
         bDVprtB0dxkxB9Oam/yWAlgX8TIxx7Ruw/JAC14JQYHNbZsM5R9uWEDpoTKM/O45Jxva
         4Is2zyxu9NhWXJ2JTelFI4+IGxK0v78eRFTb+UbQpj2oQyOKJdlQM08mOs8bf/cOYNsd
         HBHGTEEvnBH/MNH59tDetMkmGNlu460nFOvPOVgWjbtRMbXmT/R/Rlq38dTB2gUguCGf
         cgpQ==
X-Gm-Message-State: ANoB5plJYAUzrkoiFMtIYtIMk1eOr+alm7QmsBG98m9IF5X1ib7J7TyG
        KaYtFoYcs/pcKCyafF7b/nA=
X-Google-Smtp-Source: AA0mqf6FF2sPZjSDPFQlGRKQw40RR9OZKdTi5eQL1m2Lx6dz2aLgHwHBI09AltBSTbhVyOpwg1gLcw==
X-Received: by 2002:aa7:c84d:0:b0:468:354b:280d with SMTP id g13-20020aa7c84d000000b00468354b280dmr37830074edt.178.1669411986993;
        Fri, 25 Nov 2022 13:33:06 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id a26-20020a17090640da00b007aec44edcfcsm1972118ejk.75.2022.11.25.13.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 13:33:05 -0800 (PST)
Date:   Fri, 25 Nov 2022 23:33:02 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA
 configurations to one location
Message-ID: <20221125213302.ac5fwxrnn2sl7sls@skbuf>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
 <20221124101458.3353902-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124101458.3353902-7-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 11:14:58AM +0100, Oleksij Rempel wrote:
> To make the code more comparable to KSZ9477 code, move DSA
> configurations to the same location.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
