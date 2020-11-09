Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76B2AC712
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgKIVU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbgKIVU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:20:58 -0500
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB32FC0613CF;
        Mon,  9 Nov 2020 13:20:58 -0800 (PST)
Received: by mail-ua1-x942.google.com with SMTP id r23so3260151uak.0;
        Mon, 09 Nov 2020 13:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7DBQ7bhRqZ6AzXHPOPfjQrb2gmOafLUkLl/Zq//thao=;
        b=GA363FLEmGvNcaOVPu+1Mx5y3TLNI5//6oCy5bWoo1iZiwGklBUnwb+wFwpKngn/+i
         tJdq4DaxJBo0LVuL8qc2OTj9r4UCbUhqJKksMdwtPfwPHyOVcO+I1a4sNCfD0jC+NhwU
         KNVJECPSTUbj2oi92PtKciyzBbQEgUoqqnX8Pvw2RFzfYjIGH584j5W0V7ZEXAjD8x3N
         gSokH9HjyJunlX8LrDsBxJ5tu3/iloELgwSj/GqWK4Fz1Bupjuf0+jikEgWw2inrIQTm
         CE0JsPQwWY4E4tKza34j9gxF0r4+5u8q6SVe0y+pfzYakc/NLQeuHuCXP8O1RI1SEiRy
         4FCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7DBQ7bhRqZ6AzXHPOPfjQrb2gmOafLUkLl/Zq//thao=;
        b=e/sCQcBLUv/pMtqnL4wISGClCAeQx2pU+ycVQCBSaNbJfRLHzZmY4CYMEpBkeQLa+G
         EHEP9OVdiF619ICM7YsQqPICg1kdy1xmJn2m7RTXV6NNoIO3UlNGCPyur5xxHBEPCo6b
         e+jtUR5v7DP1Z9G+nT764221t+5e7tNkGDoCflOTMl0dgfANA6XPr3ERK18Ml9wUziDW
         2LUyrhUjg0q4W9DNeGl5RtWdEk7D48cR8tHJ2tlMluaQx6l22zkAVhsE2Ks24dmN+3qd
         16ZXZJBa0STiYHIKMsu02ww2dfD4fwI7R+IBEsHSONjQwWRjgjc8WO04+BF007+pAK2o
         t2RA==
X-Gm-Message-State: AOAM533wIUr8T73CiJfzPn0TwHT7d6/dUk4ROycK2nRMDJU8Au4Rthx0
        4WnPvA7veghjuqyegVUsSWJ/l4k4aToLkT+YS9o=
X-Google-Smtp-Source: ABdhPJwXUPIdnj6YB1V/GNwWxnUY4pO3NEM2p7J2W2vASZGEqUdFeObcdtl+nMyqYcYc8EZRDJDZ0e24xOJyYFnTksA=
X-Received: by 2002:a9f:2c92:: with SMTP id w18mr8408184uaj.58.1604956857746;
 Mon, 09 Nov 2020 13:20:57 -0800 (PST)
MIME-Version: 1.0
References: <20201109193117.2017-1-TheSven73@gmail.com> <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 16:20:46 -0500
Message-ID: <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
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

On Mon, Nov 9, 2020 at 4:09 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> This is a fix right? You seem to be targeting net-next and there is no
> Fixes tag but it sounds like a bug.

I'm not sure. The original code used to work for me, until the spi bus
driver I'm using to communicate to this chip was changed to always
require SPI_CS_HIGH. The current ks8995 driver will now plow over
this flag, and spi communication breaks.

Is this a bug? If so, what should its Fixes commit be? The spi commit
upstream that enables SPI_CS_HIGH on my platform?
