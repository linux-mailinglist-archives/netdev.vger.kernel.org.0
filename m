Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9F6A6112
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 22:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjB1VO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 16:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjB1VOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 16:14:23 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098EB2B2B1
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 13:13:53 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id a9so1740601plh.11
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 13:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677618832;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQEdGAFcgZzfBNV7ZLC7PhloGq4T5Zd5s/7+fMU23g0=;
        b=ThrhXWZQWKk9qlcZPdRNHaVf+tZ4jL1sduUnv9OdTHnhkXwwmD57QrXMW8Dx08ngxm
         FpS2ZOnsvBjYmFHn1CXJr8D/Nud79SN6zVNurezopUaR4rlygRWqou3c8N/awPsJIgXp
         MgoJJLcZnjK5lmF/158uN76sa0WDRLzOBeeXB+Knk0jUgmcwMZCjMtI1jL4ALpO90Gre
         1XIPHamM0J5rUsjmmZQWpisXJvz96TLZt6pTEaHBDUVHzBzziIuW7wyODH0zrpsFtJ/H
         0w9l5FGbZ9oQf6o2RyWb3ZONlCMkCVs87vBX10N1AzPau1gDh+n7rgHpmNDqqsATpl7w
         6/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677618832;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQEdGAFcgZzfBNV7ZLC7PhloGq4T5Zd5s/7+fMU23g0=;
        b=dKx2NHd9wL+QMz3k0G8bCyume7WGbJazwONSoQPYeNaqSmOvBgI1FGcSRbYOevrYkg
         bUDz4GOghG0iOW9iFTocZIjAJSrqTfzlRw9DPnNfRKYdf7jUCk65v7uBBTobogYx3WZZ
         SkpAN/zL50nykiyh8sQSn2tolvogaHJpjjxl1lCQaTMZFPVLlJt/pnw/r+OjC73d/OYy
         48bePwJPG7Jh7KnAre/r9f3dRIm1P9Be6sAw11OWl6sY13anuP6bBZ7HPdbI8ALF+9tP
         2SRRk6qA2cAKSOK5TxWTwW9mPA9sALC0Jw5SDWmI8QGp1I2f9ETBVyI933qm+nki87GC
         qTtw==
X-Gm-Message-State: AO0yUKX3j4hZQnPxDFUqYsDxlqPqXyIFsfIYL7K9/xbYpS1Jiy+Y7RPg
        0VkFzhCvvo6hKTtvPhu0ipI=
X-Google-Smtp-Source: AK7set982wWXntIItv+Srx55rvvct9eHcDNzW5ZVYOPXPr7OkkEJq9PxtFSUKaF5zciSBXnCbLGRDA==
X-Received: by 2002:a17:90a:6389:b0:237:40a5:77cb with SMTP id f9-20020a17090a638900b0023740a577cbmr3365636pjj.1.1677618832539;
        Tue, 28 Feb 2023 13:13:52 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090aa90600b00239ed0b3414sm1360424pjq.33.2023.02.28.13.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 13:13:52 -0800 (PST)
Date:   Tue, 28 Feb 2023 13:13:48 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/5ujLZyiI6tlKI5@hoboy.vegasvil.org>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
 <Y/4exYkeQF2wOTkD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/4exYkeQF2wOTkD@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 04:33:25PM +0100, Andrew Lunn wrote:
> > 2. Kconfig: Override PHY default at compile time.
> 
> Per MAC/PHY combination? That does not scale.

No, I meant a single, global default that overrides the implicit
default of using the PHY.


> > 3. Module Param: Configure default on kernel command line.
> 
> Module params are consider bad in the networking stack. DaveM always
> NACKs them.

It could be a regular command line option?

Thanks,
Richard
