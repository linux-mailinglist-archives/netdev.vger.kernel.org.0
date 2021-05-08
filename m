Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7CE37716B
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 13:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhEHLcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 07:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhEHLcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 07:32:00 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280DBC061574;
        Sat,  8 May 2021 04:30:58 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l24-20020a7bc4580000b029014ac3b80020so8529421wmi.1;
        Sat, 08 May 2021 04:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zUk+jg5OhF+NLyFoPNte76EBxSQqD0g76UwRkMl1bsc=;
        b=LtZSMZnZifUzpPhVco2X+ZdKf64i/aWDiNnZln237Rqye1/w64BWaaMnhKwTBm03SG
         8OUE42je8icQQC0ScMiMDFTfXF8Z+lSWVjsRa2HWW/X0VV94qMgxAIMSUQ2+vNpTg6A/
         Dk9o/Cn6asM6n4Ck1U6SXR6aPV7XoyLI+uz3Drm/Dci8shxypqicRTWJazKz2H64aQ73
         vjBkItCqbeiEf7PjK1X8CckGGm5HyL/dzAmkend8c1vGzzTF23D00KpK/I6UBWvz7sii
         02gVIyye86DrOAGjqtKIJgBVNaIxGGtzvaYVKVDvG/Cv8Q1qpa7DEG/R3b1BDdXwLgxt
         9tfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zUk+jg5OhF+NLyFoPNte76EBxSQqD0g76UwRkMl1bsc=;
        b=UYithTtShF4oG3hOdsUroOey/Gp4807KiICl2uDcPXDSnxcOU30r17Uo/aqGCza4LC
         7TENUU5bHfYKC8K16RSOp3hmuGoPJ7redVmq3HowFScEnDc7vuAiqPqYzC1T3axLuB1w
         LR3huwOBx82TCSFUd+12hqTXziI9DEdDF7SWXO8DJCmeEpIErPAhQ+viR/f9woKu50DV
         FeBPZEbejAGWSp+OaHnKhGSdwhXRbRJyxnfN2f090CbnLktk1oLT8TSYwwgi9N7mi/JF
         UubfcKpbwLVw6fJRVvgrESMV6DxTEsdlfT5yRJXbb3RN3AFIE10UmVyqCDWO261nfIAO
         QFTA==
X-Gm-Message-State: AOAM530oXAhW2ugbRlOaUl/K66ilAaQLLygBJ0c8rPMVSTe7H2jmyGwa
        QZd6UsNj7gIi2seEJimPvhw=
X-Google-Smtp-Source: ABdhPJwKwsRAbE3KJF4Y2rhERwaT9Y9AaHdR22IIKAgwNE/FdGsKGEL6O+3WexVPbBwli+KjDaviSQ==
X-Received: by 2002:a05:600c:4ba3:: with SMTP id e35mr27113754wmp.16.1620473456409;
        Sat, 08 May 2021 04:30:56 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id i3sm14598110wrb.46.2021.05.08.04.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 04:30:56 -0700 (PDT)
Date:   Sat, 8 May 2021 13:30:52 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 28/28] net: phy: add qca8k driver for
 qca8k switch internal PHY
Message-ID: <YJZ2bE8j+nqnCEp8@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-28-ansuelsmth@gmail.com>
 <20210508043535.18520-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508043535.18520-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 12:35:35PM +0800, DENG Qingfang wrote:
> On Sat, May 08, 2021 at 02:29:18AM +0200, Ansuel Smith wrote:
> > Add initial support for qca8k internal PHYs. The internal PHYs requires
> > special mmd and debug values to be set based on the switch revision
> > passwd using the dev_flags. Supports output of idle, receive and eee_wake
> > errors stats.
> > Some debug values sets can't be translated as the documentation lacks any
> > reference about them.
> 
> I think this can be merged into at803x.c, as they have almost the same
> registers, and some features such as interrupt handler and cable test
> can be reused.
>

Wouldn't this be a little bit confusing? But actually yes... interrupt
handler and cable test have the same regs. My main concern is about the
phy_dev flags and the dbg regs that I think are different and would
create some confusion. If this It's not a proble, sure I can rework this
a put in the at803x.c phy driver.

> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
