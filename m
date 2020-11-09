Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2594E2AC73C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgKIV3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIV3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:29:31 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1B6C0613CF;
        Mon,  9 Nov 2020 13:29:30 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id f7so5817051vsh.10;
        Mon, 09 Nov 2020 13:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0snqdUWJAImLsI6ypyZ+jUnUoVgkKOwIbtj8OCbJpA=;
        b=jZy+o5MmRdmjf/sti//j6b+hsAh+y7JTNT0SRP7uh0k1NN9aEe/JWSQ+owXpGc6UUv
         UVIl5UjzFL8iVpjXTnMlQDy+BcMzzOddGKpioyy5ghfJBReJca9YRwLb/TnMgfl0syP7
         5E1zaD1I1pFu88QCEy/WA9dta2MWIqbNuBVu/TIwfu1757cEN3kIueWff7QE79Wk09a4
         iSf+Ffmc2JDzsC2xB8hP7zJUpascj7c2EY4O7eyYnw6S0vcfGyEpY+7nJxlnDb3jASb0
         pf22GyoI0NHAmA2dG9eAjGqAnGQBgoYhDIQL3Mbu2yatm1WtM+q95mr8CiHVCXpawlJI
         WKtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0snqdUWJAImLsI6ypyZ+jUnUoVgkKOwIbtj8OCbJpA=;
        b=KuL128Wra0JuHPCJJ7N+wm4nrmDddChrO1AvxnpuZB4r8xTiTvPUBkN58ExHSJh4Ca
         Uj25xpkEluGrUIfZxSlIfd1LxNnBsJVuGHuwRTe74SLBhU7ducC/Cf+aBDUT8jzJ9gu3
         g3pMUoO+peT7NkClJjvUklXceK2+A27b9ocOKXUxeCX3OL5rMXsNBIeBqwuqw25tMtHB
         V9va5vG7YlNK6aly8B2W0jh21mf0eAZ3Bq3F4+6KctLvK/JEFSDFaZzGRR5j1FK2FyYS
         x2d03apeLyK5iI+RFtwm1CBcr6xbD9V8TktKyth9pOAXkY00uB8hgOTJxodkvQ0zyCtY
         ZLsw==
X-Gm-Message-State: AOAM531CaRnGu6m/rR0fh3u5KC0LB0XAbAV5ctnaH5p6P4Ck+OuOfZbB
        dlYVhvSqhPbSLVNrpZellsx1ymFd5R8rxn7Cslk=
X-Google-Smtp-Source: ABdhPJxOv4zQJfdGukwx0Rw0+4sC3os5ODixePCklLU4JcudFhydJRmWJUO9kqU9p8k+JUcKW7rdE+KqZ+8N5LSPqa0=
X-Received: by 2002:a67:ff10:: with SMTP id v16mr9378523vsp.40.1604957369917;
 Mon, 09 Nov 2020 13:29:29 -0800 (PST)
MIME-Version: 1.0
References: <20201109193117.2017-1-TheSven73@gmail.com> <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com> <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 16:29:19 -0500
Message-ID: <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 4:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> the commit
> which introduced the assignment in the client driver.

That's the commit which adds the initial driver to the tree, back in 2011.
Should I use that for Fixes?
