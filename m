Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D35643F78
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbiLFJK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiLFJKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:10:35 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3045820F52
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:10:07 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id g7so22682433lfv.5
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a8/S6ykdg/g49/FLME8o1MfbsUhOagdLOH5bnruHpgc=;
        b=tVOT/KX5QXizryslSdAePiV+U23GGylwtj7MDpkRxFUOUoMhhe1p3yLmektj+AscQ2
         plN8nnb4Ym6VVSr6WxMHAoLi2RaU8EGLQEjm2u5zDVrj6T77eC6cXLpKquV8Vr3lCDgc
         1JGwzmHC/rCgv1xMhbqQXawa+66F3y72uXPM02vPxqGqT9yXADXZUGQOmo8MJ97zY4Gs
         9fiAxVMubMdmmrXQrWBUKHvLz3sY0Bo33nq3eIWY8qYOD9929BjoKFRMuRNCOrluApiZ
         fgcJSFMYfGXnmaK+Wq9kcLipzTOCxrP10zVzqXcPjMVLJJLCzGTGM8R9O6nUNn29AQ8y
         dJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8/S6ykdg/g49/FLME8o1MfbsUhOagdLOH5bnruHpgc=;
        b=NOzPelDwgK5oLtnXgjwqeKwi1cE1Hhe15jZR6nqgxwX1BiYsEzMGmTYnBnUhAvtGbU
         JKWcG1OqUNlrkidkWflTXmJVp9JXEC0Yrn/MaknL/1glNd31Nf2ZnoVCW/M1Z/0l9FwQ
         0CHxppIK5YwezecNmdXbiHd7q7YVUpmOhuBZqSkfi1Z70j24Z4UbyjplWG4xRjwaIoJE
         8NxXXiCxqHtkIMJrUnJK8qBxIzWcYSqLNbEZqO0OP4w5h8UbSOVTLtopfIQBVXSG++3Z
         mUe1Qp8HYunLbm4y+9tKqxPvWlAIMMnAyz8XCYnMZA+RCOP6p4PPOxAfrhnCA5SurdPq
         mgwA==
X-Gm-Message-State: ANoB5pn6Lsg4mmdfZEtYaJGRirzcj09PPoHpJjmNDoHdyCsTADKyTtjC
        H32nfYe8a0xzKTIzBEL3dMr6S/p0vuimrCmk86N4bQ==
X-Google-Smtp-Source: AA0mqf6D1FFx/swbUQRcuEkx7dLWfLvxXSQHuO+R/SXjyGe6LsEjbp8hORG9ZzHThisS+7u4R16tTw==
X-Received: by 2002:a17:907:8b06:b0:7c0:8e3a:9a54 with SMTP id sz6-20020a1709078b0600b007c08e3a9a54mr25454851ejc.619.1670317794846;
        Tue, 06 Dec 2022 01:09:54 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v6-20020a170906180600b007c0c679ca2fsm4744150eje.26.2022.12.06.01.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 01:09:54 -0800 (PST)
Date:   Tue, 6 Dec 2022 10:09:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 net-next 1/2] net: phy: micrel: Fixed error related to
 uninitialized symbol ret
Message-ID: <Y48G4etaxXnmJJLF@nanopsycho>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
 <20221206073511.4772-2-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206073511.4772-2-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 08:35:10AM CET, Divya.Koppera@microchip.com wrote:
>Initialized return variable

Not only here, but in the patch/patchset subject, you should be
imperative to the codebase and tell it what to do.


>
>Fixes Old smatch warnings:
>drivers/net/phy/micrel.c:1750 ksz886x_cable_test_get_status() error:
>uninitialized symbol 'ret'.
>
>Reported-by: kernel test robot <lkp@intel.com>
>Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>Fixes: 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814 phy")
>Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
>---
>v4 -> v5:
>- No changes, added reviewed by tag.
>
>v3 -> v4:
>- Split the patch for different warnings.
>
>v1 -> v3:
>- No changes
>---
> drivers/net/phy/micrel.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>index 26ce0c5defcd..1bcdb828db56 100644
>--- a/drivers/net/phy/micrel.c
>+++ b/drivers/net/phy/micrel.c
>@@ -2088,7 +2088,8 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
> 	const struct kszphy_type *type = phydev->drv->driver_data;
> 	unsigned long pair_mask = type->pair_mask;
> 	int retries = 20;
>-	int pair, ret;
>+	int ret = 0;
>+	int pair;
> 
> 	*finished = false;
> 
>-- 
>2.17.1
>
