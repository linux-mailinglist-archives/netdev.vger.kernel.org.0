Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26C7644987
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiLFQlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiLFQki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:40:38 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8E0B7CF;
        Tue,  6 Dec 2022 08:39:46 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id u5so5592360pjy.5;
        Tue, 06 Dec 2022 08:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kov06sKyNwxaDSpUfxT+OD2Jl0ekEIWDjUktRMkzTrc=;
        b=ZL2BZH5agJAQfXXhfMB2LUVaR39EDgFZb11QmkVdcFtK30doUIThN9Lx4/S3U+8qxh
         9WjE0Ig6m0Nc/FroEyQdq2Q1GhIk8YRkNxhRx4TWVdhn6dBE4VBxDSLTm2SfkgYkbwSa
         Dy8LpHtJ270zRzRYl9F5tuMr84myBnzcobuSHHxctUX0ot7c46CDsUuXhjQO6FoLaUzA
         AP570wU8zc4bWO5g2QIt/nR9VycLz72DfJPkxNzAbWB/DfYmJJwo/iRbzH566zQlH3uj
         583ufhFpgmUwQ/5vUE2E2QkmNPfCtUt8EasAPHYPWxL910tHrgja6vkWlMB3CJKjUbC+
         pmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kov06sKyNwxaDSpUfxT+OD2Jl0ekEIWDjUktRMkzTrc=;
        b=Fd1PJRJO5ceqCtDUkVG1NGXJzQh9fU+iShDVJR+VniXZdMRxqtvHUy9Z2qJTwHDWlc
         FpgDlJuENszJ+6dwa1Ro647cVq99FG8pWuxQ/RHnw5dy+gMC21k31wmu2bLGmlvVnJ5x
         iMThjaTXfhbQkJXnC4RdO2eM0E57UISLpl7oBdRWw6xx0RYCblWvmG4C/DiFT4U4YjkQ
         WPuHxmOO8KdP1Ps0RfVfctwQyaNFwWfz3NpMvdGPawStdfh22b65k6DBdCe/QuUEdUxs
         POLduvjW3j4zpxo2bqGYrj5Q6njItrdH7XXAfee5wm8dfBsR39lkCSSYW+DS+qT1zHkq
         Dvug==
X-Gm-Message-State: ANoB5plTB9PFKjALDcTuRMO+ibqSHFCytase+FqFsBq8W7YE/CphgX6o
        Bp1AbTmtnGO0OwEQguq1SpI=
X-Google-Smtp-Source: AA0mqf7rIytJPGa3CSsV5g4MMEX0xr7LP4XjpE9vZG5ZxVsE5uPGAKGFVXVn1vJ47mT+/E73r4LY3w==
X-Received: by 2002:a17:902:ab89:b0:185:3659:1ce9 with SMTP id f9-20020a170902ab8900b0018536591ce9mr67695715plr.26.1670344785718;
        Tue, 06 Dec 2022 08:39:45 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w13-20020aa7954d000000b00574ee8d8779sm1520812pfq.65.2022.12.06.08.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:39:45 -0800 (PST)
Date:   Tue, 6 Dec 2022 08:39:42 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Divya.Koppera@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Message-ID: <Y49wTlpRyYsweM7u@hoboy.vegasvil.org>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
 <20221206073511.4772-3-Divya.Koppera@microchip.com>
 <Y48+rLpF7Gre/s1P@lunn.ch>
 <CO1PR11MB47713C125F3D0E08B7A6A132E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Y49M++waEHLm0hEA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49M++waEHLm0hEA@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 03:08:59PM +0100, Andrew Lunn wrote:
> > > > -     if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > > > -         !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > > > -             return 0;
> > > > -
> > > 
> > > Why are you removing this ?
> > > 
> > 
> > I got review comment from Richard in v2 as below, making it as consistent by checking ptp_clock. So removed it in next revision.
> > 
> > " > static int lan8814_ptp_probe_once(struct phy_device *phydev)
> > > {
> > >         struct lan8814_shared_priv *shared = phydev->shared->priv;
> > > 
> > >         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > >             !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > >                 return 0;
> > 
> > It is weird to use macros here, but not before calling ptp_clock_register.
> > Make it consistent by checking shared->ptp_clock instead.
> > That is also better form."
> 
> O.K. If Richard said this fine.

I just want to avoid drivers will #ifdef|IS_ENABLED all over the place.

Thanks,
Richard
