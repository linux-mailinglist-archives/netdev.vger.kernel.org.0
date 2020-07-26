Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD9322DDD1
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 11:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGZJv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 05:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGZJvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 05:51:55 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1336AC0619D4
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 02:51:54 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g8so317847wmk.3
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 02:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oEbIDSC1rXRtLVhm/ydu++g4Gbu31ygS4ObIAOgDsuI=;
        b=TjHzSRO0qj8pH/Ell4cZdrTHTTT5Pcn79M/VP86Na/C1ezMCDK3B4F+JTDwxvSxXqq
         WLLFrVc1W7pEskjeilBNLtWE3X+CPqzgp+OeDXDh80OCrH6GbGFL2t8QBEXhAyEU8vEz
         6e1VrBWy9N2YFIw996WWrKAmMvxLmJPBg9+vKf9HoaUZHQwP0jGm732zARsQ7Yct1mNp
         NCVnR1Pts9tFOXA+hAAshZqLHNW0OXrFGbjTkvzgj0HvVPLFbU2jrOPxereE/lgBrdEO
         IIUi7ZJ7Pn9+wzgsQLkRLenfgwCuXDpMe/fDsEqZHqP716COFzjIjmCPwZRQGHErfLPG
         0GiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oEbIDSC1rXRtLVhm/ydu++g4Gbu31ygS4ObIAOgDsuI=;
        b=WqUk1Y+Pv72TbEJFMDrx92WnmKxLbePiMNYCKCK4XGtQI59T1uk92kp9DeXWACEjPu
         SHDVACKbSJEn9KoXcqZbNrywwbmH1jrYI25SkIbJyhS1z7AWQcSczmeVS/R7HAl/AM1s
         +mXmBIFlLuTIAFdxyuncAuyPp7/n4qh0EbafJllZXjdE1bvnMd4Sc0WGpIkdb3xuu56V
         IuJuc55fY3vLVpqON0ydHEq2L5OOWFKUKgHyXDx0jTRaOAYs0iHOPIFUxdCr82Y6Us6y
         cuA3gRnY68oIFG5XUi5dOb1spce4r+3GA9Iq2E6OhE2Ex39J8oZv/LzOqgldwWCN/A5B
         vjEA==
X-Gm-Message-State: AOAM533mY/hkUWu2jGthCZiF/pfRWlZiiPpy1SBF3G69RDNZzR9qC0vB
        bQ0Xzxaj2HWCKZAbhE2K47ckWw==
X-Google-Smtp-Source: ABdhPJyd2i2prFENiOohjTGObmcV1kDbVuCsR8PDtL8TH2kqkeX4yAQxHQRi1z1oMxYhKTU9ApArvQ==
X-Received: by 2002:a1c:e244:: with SMTP id z65mr8187502wmg.34.1595757112204;
        Sun, 26 Jul 2020 02:51:52 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t2sm13192830wma.43.2020.07.26.02.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 02:51:51 -0700 (PDT)
Date:   Sun, 26 Jul 2020 11:51:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v3 2/6] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200726095150.GH2216@nanopsycho>
References: <20200725150651.17029-1-vadym.kochan@plvision.eu>
 <20200725150651.17029-3-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725150651.17029-3-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 25, 2020 at 05:06:47PM CEST, vadym.kochan@plvision.eu wrote:
>Add PCI interface driver for Prestera Switch ASICs family devices, which
>provides:
>
>    - Firmware loading mechanism
>    - Requests & events handling to/from the firmware
>    - Access to the firmware on the bus level
>
>The firmware has to be loaded each time device is reset. The driver is
>loading it from:
>
>    /lib/firmware/marvell/prestera_fw-v{MAJOR}.{MINOR}.img
>
>The full firmware image version is located within internal header and
>consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
>hard-coded minimum supported firmware version which it can work with:
>
>    MAJOR - reflects the support on ABI level between driver and loaded
>            firmware, this number should be the same for driver and loaded
>            firmware.
>
>    MINOR - this is the minimum supported version between driver and the
>            firmware.
>
>    PATCH - indicates only fixes, firmware ABI is not changed.
>
>Firmware image file name contains only MAJOR and MINOR numbers to make
>driver be compatible with any PATCH version.
>
>Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
>Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>

Looks fine.
Acked-by: Jiri Pirko <jiri@mellanox.com>
