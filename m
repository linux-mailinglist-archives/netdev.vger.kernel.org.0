Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113F144C450
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 16:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhKJP0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 10:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhKJP0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 10:26:32 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEB1C061764;
        Wed, 10 Nov 2021 07:23:45 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id f4so11905328edx.12;
        Wed, 10 Nov 2021 07:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=09YpV3mH/V4aUSTygf2HBQSgzKm63vPNZ7/GlSRpRaA=;
        b=pVmSGuio1VbZI8v+sHDL4H1gMCOiiirg7U4WceDlApjSsnedR8pOsi5aBXkdTh/er1
         Bi6lG3kVe64VzMqKX3LtuLxe8sYBYF/9G6hVJMJD/zL6nM0Kr6I0RuB4xKxUXmRAS/7U
         29pHePG/mmwtuNEy24nlF63Smgv4aFEI0g/cGHboox3Vq5A3qIvr0h+aTNT7Rs8pgZxN
         car2Ck6ZkY6AoKobyLBZTT78r7q45C1fblrqWJJU1P+WIJ9HnJ7oki3c8f4qFt3D66rc
         pgbo82rii8NQzJq7Fnpl2b0lGvQ2jQKD+g7x8IpocnTIwl1Mzb+9EObmK3vxNYAB/B+a
         4qHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=09YpV3mH/V4aUSTygf2HBQSgzKm63vPNZ7/GlSRpRaA=;
        b=SRH1Oeio6ILO0Mm/UL+EHN6nCTLC0JdhvpFwC+gVX/C6K6G/pNtz8q2FIhW6nlK6TB
         uKfwDwz9ywlK4N64XENgcj/6sbXyNu1S6CvbZCIQYSxl0VYLYMMjWvbGKTO1IktBPH9+
         Qvx3DHbpFbn9qEoiYtaFRqUvRCAi4MIxio1j0mIIXXEOfDs9xH6RDX+ZK82V8XAi5lWh
         dq2HI9cJqVTem4fWXB1kKc8hXaK+ffl5LgCg8fPcYjSnoGFn2GKD9i2itxmtxaPSBA/n
         lsZo+LvB3IwRkZBBroRWZIseaNdfzCSbZSlmwAMm48J9au8IXRaCZQCERG567AuiGbb6
         hQpw==
X-Gm-Message-State: AOAM530pQJd61g+5aS66b/euQ4mY9GdvoUYOJIMJBkQk6PI8iW75vN8V
        2jGd1SZo79wnblZvTx27EEY=
X-Google-Smtp-Source: ABdhPJwRsxB/xSaEUe+rRJ0aVoxguCC2Z9aXsVfadE5TAn7zbYQ5PsmDvLVb0UtLbZsfmCjLtkjCjQ==
X-Received: by 2002:a17:907:9156:: with SMTP id l22mr502891ejs.220.1636557823506;
        Wed, 10 Nov 2021 07:23:43 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id ds17sm25643ejc.45.2021.11.10.07.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:23:43 -0800 (PST)
Date:   Wed, 10 Nov 2021 17:23:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] net: dsa: b53: Add logic for TX timestamping
Message-ID: <20211110152341.muap5bu5b2tmnnir@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-7-martin.kaistra@linutronix.de>
 <20211109111213.6vo5swdhxjvgmyjt@skbuf>
 <87ee7o8otj.fsf@kurt>
 <20211110130545.ga7ajracz2vvzotg@skbuf>
 <20211110150855.GD28458@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110150855.GD28458@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 07:08:55AM -0800, Richard Cochran wrote:
> In any case, I agree that the driver should enable the capabilities of
> the HW and not impose artificial limitations.

Which was not my actual point. We were discussing whether the kernel
should attempt to take a 2-step TX timestamp if a different one is
outstanding, be it from the same socket or from a different one.
Whether the hardware supports multiple concurrent TX timestamps is
orthogonal to that.
