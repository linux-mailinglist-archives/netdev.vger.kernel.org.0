Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F063746A6E3
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349718AbhLFUck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349732AbhLFUce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:32:34 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F53C061354
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 12:29:05 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g14so47435788edb.8
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 12:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c7ipq5dqUWgAluMxl65oPewuuKQDfUtT65vWZVr7uK4=;
        b=T+Y6LYFBbPrEyXpn/wgnKdM5rACxXMd3RPffJwsCaInkOD//odKx/zjd1MZTLcKIR0
         /T7LlSiDEg4CIv2cGjaHuo9pamuvPlL2cxH0fi1maH2dEMKa0jJCzfA8QeHbppruJBpw
         iFBUkA0ApckhrpwiAvh6mQ+bdOGkFwj1hGCQaxRv693qb+CYjWCWCDaHJ8FGfRY4n/JD
         a1RegELutEq2HQsDohhhXVlECKvThfhYguqv2P4zUn3O7BVSqhVsX7ZYMG1kg1AHrW3n
         fHbLCY3Yt66tEJlrj+RRkAlqsIO2MGmtDHBTFyD5wweCs69BFB32Vr6AZhNqjPOFTkev
         Vsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c7ipq5dqUWgAluMxl65oPewuuKQDfUtT65vWZVr7uK4=;
        b=n/+6H/bswDOYA7KC0l7r8E988Uh5T31Ph80Jk/v8HGTc63sYsTXG6uVDqJreoMo3J1
         otH6Wtn/t8xKzn/QH43jJjhZnNgMuLKeLPa4AZ4UkIvAaO+cxJbdHjlGKVQRTUuZCimR
         U1IUlc3whLjhIwWrMjRPa8IA92nUUmrtnP7EV/o+aaN9tLK7OKUS843u73B/1v9GqKvh
         hWlqllg8eP5bnmLyccqRRgO8kw6m/cK1S+7JU4UUjPYjK5DCUnvPEHLCRF7vOevohCrz
         YuT4Jfj+g3JRcOw/8mAyWVFoyaVmEo/RPJQmZp0662SlDJH/oHYIvsYWKaKHJqZGvATf
         RZ3g==
X-Gm-Message-State: AOAM532nEl1QWelcjdruORot8du1Biy36+sHp+xUQSjBxFJrm+qrTxU3
        k4acuVj7A2caLLK27q2/Zt0=
X-Google-Smtp-Source: ABdhPJwm8KVBW24dJBdL4nOVsZiI7adLYnxcEWSnDwEgE1BxygcpR3+yU3i26ZEniZmSrqmSbhX4qg==
X-Received: by 2002:a50:f18a:: with SMTP id x10mr1954320edl.193.1638822544039;
        Mon, 06 Dec 2021 12:29:04 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id yc16sm7233660ejb.122.2021.12.06.12.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:29:03 -0800 (PST)
Date:   Mon, 6 Dec 2021 22:29:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206202902.u4h6gn7epjysd7re@skbuf>
References: <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5qSoNhJRiSif/U@lunn.ch>
 <20211206200111.3n4mtfz25fglhw4y@skbuf>
 <Ya5wFvijUQVwvat7@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya5wFvijUQVwvat7@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 08:18:30PM +0000, Russell King (Oracle) wrote:
> Phylink does *not* guarantee that a call to mac_link_up() or
> mac_config() will have the same "mode" as a preceeding call to
> mac_link_down(), in the same way that "interface" is not guaranteed.
> This has been true for as long as we've had SFPs that need to switch
> between MLO_AN_INBAND and MLO_AN_PHY - e.g. because the PHY doesn't
> supply in-band information.
> 
> So, this has uncovered a latent bug in the Marvell DSA code - and
> that is that mac_config() needs to take care of the forcing state
> after completing its configuration as I suggested in my previous
> reply.

I can understand between MLO_AN_INBAND and MLO_AN_PHY, but isn't it
reasonable that a "fixed" link is "fixed" and doesn't change?
After all, it's in the name. The mv88e6xxx code doesn't appear
necessarily problematic. This issue could crop up again and again with
other drivers.
