Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807472D6C2A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389559AbgLJXrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389988AbgLJXqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:46:15 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0AAC0613D3
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:46:00 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 186so6849622qkj.3
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FdFk6ep810SJ3eW2awdN+7fW5jXQeIbyRy+2z7XYefU=;
        b=m2RgoTvpw5loaf0KtfWX8cp58nUVgnzuBNJkY/7UtnXngBvnTzm0Rj1Xq8ndfXwEnw
         LZSwoFTPDzqCG+2Er3sAzTM9XymiGfdwIwusG8S9FmKthELI1qIeiXfECAb+xhpf02gM
         +Rlq4CBxLxLOwak43VEjQbmsEAVlRzSgLfPi6zAcew4ppzMyRjJJYKdG9Hmw568HVZ3d
         OvMWJFpOSfZG6OITILJlsMWkTQP2uYi0osmTahcfRTRqBX0FWZiy7T++giQarZJovwcE
         O8klHa0W/JHCUghBaJBkDlAIMHd4VLk0A1JMGEwUcCDM8hsrTveZ7lwyDaujaV4GWiIH
         UoSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FdFk6ep810SJ3eW2awdN+7fW5jXQeIbyRy+2z7XYefU=;
        b=tkO9t+NxUMABIcLLlWVuM7PYa5Kt1MUKtiVuUExmrpE4DpMpsq+8SAF5NdgdGaX+A1
         wMUgVr5mzY2C50ywnILqrI0j8phQ+QeUokR2yOLEk1XNhmmbglbqvIoANBQ/4bMH0ZLZ
         rYY7jofI7QxSNmdc7F+7s+awuesfSC3A5j4HpPG28zXckb8RQv5keie8PM4JR1J4ZJP2
         JSffoV8qOFtZJLmE7jArCmk40epybzNfXqyeZZN8ubWwavhXDaDFDAVEnMERzOcvtop4
         mGFIvlB6zBaIYuWdZyitvmwuRuoELQRcDW+XeAxPi7cXoWHVcWyUBVONm5ElWZAcnziA
         YVjA==
X-Gm-Message-State: AOAM531nb7hZ1PoP5fjzGXa8tX9GVJEzK9jgTpY4PsskPcbGMJ/+/vlU
        njzfm641LXwUS/XWodyrLbJ5yF1x5MJSbb3BoJQNTg==
X-Google-Smtp-Source: ABdhPJyPcyPva8kLhHNvG5/aDjNCvjE8j7/c7lyiI0R4i5hVxGSwAIeGIl9HPeDWNytkyM3QGPPRufBArhmhOkZ1U74=
X-Received: by 2002:ae9:e855:: with SMTP id a82mr12755017qkg.300.1607643959332;
 Thu, 10 Dec 2020 15:45:59 -0800 (PST)
MIME-Version: 1.0
References: <20201102180326.GA2416734@kroah.com> <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm> <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com> <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <20201210154651.GV1551@shell.armlinux.org.uk> <CAPv3WKdWr0zfuTkK+x6u7C6FpFxkVtRFrEq1FvemVpLYw2+5ng@mail.gmail.com>
 <20201210175619.GW1551@shell.armlinux.org.uk> <CAPv3WKe+2UKedYXgFh++-OLrJwQAyCE1i53oRUgp28z6AbaXLg@mail.gmail.com>
 <20201210202650.GA2654274@lunn.ch>
In-Reply-To: <20201210202650.GA2654274@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 11 Dec 2020 00:45:48 +0100
Message-ID: <CAPv3WKdGH8uVcdraV=oQZ7y68qPvq=XycZrw80MgwfiMpx3==g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 10 gru 2020 o 21:26 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> > +1. As soon as the MDIO+ACPI lands, I plan to do the rework.
>
> Don't hold you breath. It has gone very quiet about ACPI in net
> devices.

I saw the results of the upcoming next revision from NXP, so I'm
rather optimistic.

Best regards,
Marcin
