Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0416A2FEE0B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732459AbhAUPHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732384AbhAUPGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:06:55 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71942C061756
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:06:15 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id g15so1508456pgu.9
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hL7J8YKTRLEzgnpaGJ0N3kNySkQ5d8GGKAxwdpk6W5g=;
        b=uqQb+UFQRvfH2YLDOygPX+7u6SOiIHSOlVww4mw5KE/hfdieHEo10Ng8vQsYp2jOZ6
         RQBPKyVmPCllch6raVbt4YOX9Y54rztIFIQTN0m5LhJ8hTkwX7BsMGOh2qIyAp2CEgRq
         K72fJnp7FpA0z1hQ3xGblyWERfIhZebBUR2w0Obk6DhdFyN7V1PzrV3szG3G3ED/yV0k
         qMJfm5m7aPNxTNooa+rtJ7cxW8PVSxuGFx1tPEAM71ZXRNTtSTpmK3MVnyIAl/CY3N02
         Wv1+xkEB0dlP1orX+z/kFsu24MpGZfLfhSW1qvKoGn5QJdnCNjtMz77UxbAaXNdieYOR
         QrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hL7J8YKTRLEzgnpaGJ0N3kNySkQ5d8GGKAxwdpk6W5g=;
        b=Nfluc9hYeLGib7oTcMYNqPdGzzgNT+qhKMDbEo4ooQ9FNcTE9YbiNVaYO7U1l5wvgo
         9Y4mWFTUBjxUz4wmnuVlBdQS3TfacJ9TXJq+A4AXhglXRFuTNWxA/QmFPNPBvWx14IvR
         79Usxs9IIN0pL1ZDfjPpSSsUuc7p1AOOAoA4fWwZAyEUWqYVTvb4zapSDi0sQ+SHY0Qt
         bV5JLNsjnugQv90nqVOzTXH2R+GofqsaBo0xxng0oMLLWUwrT3M7EgGraLWDjzYgkNZE
         fuI1I14rQ5ZrKywjBsuG45lyoybKPIiNCOQ4+4T7ROXvg9y90zdm7NurOMib8SR3V97z
         wEzA==
X-Gm-Message-State: AOAM5316ESVcJbYkt6E/uYQNE8VL+bgbuToXOH4IH+wcdtMIgaIC8YS7
        DyzAheJ1djJ08z/ia5BIOQs=
X-Google-Smtp-Source: ABdhPJwOLAbrg+rQJPOS0hHwW6+Ro+dHI4VUPjcADVhiuMFokA0dwhm6qfAYW2ylN34ytD3PM2Ud5g==
X-Received: by 2002:a63:1707:: with SMTP id x7mr14614468pgl.266.1611241575012;
        Thu, 21 Jan 2021 07:06:15 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m1sm6429342pjz.16.2021.01.21.07.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 07:06:14 -0800 (PST)
Date:   Thu, 21 Jan 2021 07:06:11 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210121150611.GA20321@hoboy.vegasvil.org>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
 <20210114223800.GR1605@shell.armlinux.org.uk>
 <20210121040451.GB14465@hoboy.vegasvil.org>
 <20210121102738.GN1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121102738.GN1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 10:27:38AM +0000, Russell King - ARM Linux admin wrote:
> As I already explained to you, you can *NOT* use kernel configuration
> to make the choice.  ARM is a multi-platform kernel, and we will not
> stand for platform choices dictated by kernel configuration options.

This has nothing to do with ARM as a platform.  The same limitation
applies to x86 and all the rest.

The networking stack does not support simultaneous PHY and MAC time
stamping.

If you enable both MAC and PHY time stamping, then only one will be
reported, and that one is the PHY.

Thanks,
Richard
