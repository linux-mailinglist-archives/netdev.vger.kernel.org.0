Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B830D6A8B9C
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 23:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCBWTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 17:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCBWTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 17:19:37 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0C1B744
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 14:19:28 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id w23so966263qtn.6
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 14:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677795568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J6VnOrULyvJrjoGxWJKUjdKLKs4X5svGtSfEry7FNhw=;
        b=ATMLoVTmwELEUcDSJbKRXEU5btKRb9shTU9/rcM/LPmp2xQ3iy94BciybvKx2OiqBQ
         PC/4F3M23Ooj3cJTmLNToFc4wj14YP5WoXl1Aoy/aQSPxP0JXWdaueHXQBZlny2zxr/P
         cjvuySapvxt/l5l+c/GWlh0YXBmZ0JEwuXQtMWJIkQMqsHYNLe1jzekr4fDFfENomyKd
         +6HRVrfd00bEyBkC2OjAEQFYX6nSuDaO27hkDPkYhUlC/6yY6cI5O43xmNGFgYYpTSvH
         fHO4tKm9y/egJ2Qppwb5K3b8vYv27Dop2m79yj/3b9iCRG8CO7ddFsBAsxL+uAEBzI9u
         oCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677795568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6VnOrULyvJrjoGxWJKUjdKLKs4X5svGtSfEry7FNhw=;
        b=iHrkZtCJ8N/R8ytOfd2ekf1BBsjSI9CDcaVT+ABkiAOJ7qNynHQsD0Pcx2RkrJyqul
         y5JYP/Scl19l1Qo4jHJHnFVEscPhEDkA07oMWcNcDY+Uu4U62hK1cv8IHdSXOS8Rj/SQ
         NCOfcAM/fjXM2cNlO8Y3NWx9WyMIxfN/NiKUC+bpKggdT4iuPjqB5edJjONAfHvW+TNt
         vHG7hAqVgeYBpWR0tht2artMg0SFefdfGv1VeUOmNv0KVSE+hAmErr3G1CDXwfYJSVI1
         BYDBs4qaOGIgxPhJU9iIOnHTvZqc5RaV5Xob6xksBzRCnaAn6pI+TPtcfCf6ANrfz4aU
         lRAQ==
X-Gm-Message-State: AO0yUKXrk1qSiikrkYYpDh8TWtNgNhNiAfi04ah2b3ifLCz0/6vkSkYm
        vfDeAa04KLNfo2276krSxyXTIxD62mo=
X-Google-Smtp-Source: AK7set/IVTkv3+0FAR3NCfiGkPiQLu5/W9dUDKGPZfc3AM+p4d2HgOtSeWTCjMcA4ANZrxNcb1y8IA==
X-Received: by 2002:a05:6a00:1da7:b0:5e4:f141:568b with SMTP id z39-20020a056a001da700b005e4f141568bmr10375656pfw.3.1677791981786;
        Thu, 02 Mar 2023 13:19:41 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h16-20020aa786d0000000b005921c46cbadsm139683pfo.99.2023.03.02.13.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 13:19:41 -0800 (PST)
Date:   Thu, 2 Mar 2023 13:19:38 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZAES6t7p5/jFl+Gv@hoboy.vegasvil.org>
References: <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
 <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228142648.408f26c4@kernel.org>
 <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
 <20230228145911.2df60a9f@kernel.org>
 <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
 <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
 <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 11:49:26AM +0000, Russell King (Oracle) wrote:

> Therefore, I believe that the Marvell PHY PTP implementation is all
> round inferior to that found in the Marvell PP2 MAC, and hence why I
> believe that the PP2 MAC implementation should be used by default over
> the PHY.

Yeah, that phy sure sounds like a lemon.

> (In essence, because of all the noise when trying the Marvell PHY with
> ptp4l, I came to the conlusion that NTP was a far better solution to
> time synchronisation between machines than PTP would ever be due to
> the nose induced by MDIO access. However, I should also state that I
> basically gave up with PTP in the end because hardware support is
> overall poor, and NTP just works - and I'd still have to run NTP for
> the machines that have no PTP capabilities. PTP probably only makes
> sense if one has a nice expensive grand master PTP clock on ones
> network, and all the machines one wants to synchronise have decent
> PTP implementations.)

Yes, NTP is really what most people need, and with PTP you really must
carefully select the hardware.  There is lots of PTP junk on the
market.

Thanks,
Richard
