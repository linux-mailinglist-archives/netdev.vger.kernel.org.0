Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E514458F1
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhKDRw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhKDRwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:52:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A9DC061714;
        Thu,  4 Nov 2021 10:49:47 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id h74so6600710pfe.0;
        Thu, 04 Nov 2021 10:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Er+ttp0UKGdAr3bm8pX3+iTWGGsJD3H0D2S+9yKdazs=;
        b=TnwaPd/poAV3uEmYRjV0rvoQudulAmE/zGKiWZpD2o7bhVBFGCXb+jYuEP/mmUicFn
         iylfttG038izYN1UutxAhIN2R4esCOYCEUSPZqlGZ0+U5mvF09p2Ov0trQQqAC1sZTxo
         cQN+1HQ4AyUkY43BdOhCAC5HUOGb+YbNZ37WvOmq3XDYpMOmz9iEUUb0btmCRw92dhjU
         x1qJzk2ra0xmOUSUILB3VBvmYp7krKNZcuZWLO+JGb08/zoOO+1JBo33LY2QTOGifhyf
         9qoqKiby02DVRBbHBw04ZqNt+3XU8oXf4hB67LfsCODJcGaVDCEGVmaH3TT0ARsFp2S3
         lBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Er+ttp0UKGdAr3bm8pX3+iTWGGsJD3H0D2S+9yKdazs=;
        b=vdG6WeXMs2ORtjw1VBmyTrCnJA7VUzYiPAxwb5f2skDswf2qEvbd69i62VQU8ueK02
         CQYRmx1r/6+QGsw0kbw1vRsxJ6y1Z3tK54ZF6Fn/F/6LsScdUdFgLxbbEaPHcURqIZcZ
         BQ5UXpM586ZE3E+2sXzQ1ZRQXHcHq1nfRFMa29k0uOkzTEK7fWTeVzb1crAJHmH394Z+
         +5W2PsQ4VRZ+fNeSxVGFurm04uZ3hMrS4tVfOXEHauSxlyLatQp0ylroMySLjppvKrKw
         p1LwU7xG94cTHt2rAmhW7JWKEn7fxAtM0sbA7HXZUyDWhHdLPFy67tT/TB4A9BhIcV04
         zxmQ==
X-Gm-Message-State: AOAM533X+QTlf8TvbUoV6nXopPqC/ekcDZ209FfyPEbdp75EBl+Ba+JR
        P6WC4A+vo0q1weRDnK9Pnyo=
X-Google-Smtp-Source: ABdhPJzA2ubj3mwJbGlNTyL+N44DiBjUSAXGw7ZwvD0zAlq16bIgMOC1NLckktcT7jsV6p8NzIosLA==
X-Received: by 2002:a62:e514:0:b0:47c:12f6:3aae with SMTP id n20-20020a62e514000000b0047c12f63aaemr54048996pff.26.1636048186937;
        Thu, 04 Nov 2021 10:49:46 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p7sm4307095pgn.52.2021.11.04.10.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 10:49:46 -0700 (PDT)
Date:   Thu, 4 Nov 2021 10:49:44 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] net: dsa: b53: Add PHC clock support
Message-ID: <20211104174944.GC32548@hoboy.vegasvil.org>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-5-martin.kaistra@linutronix.de>
 <20211104172843.GA32548@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104172843.GA32548@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 10:28:43AM -0700, Richard Cochran wrote:
> Instead of generic work, consider implementing
> ptp_clock_info::do_aux_work instead.
> 
> The advantage is that you get a named kernel thread that can be given
> scheduling priority administratively.

I see you are using do_aux_work in Patch 6.  You could use the kthread
for both overflow avoidance and transmit time stamps.

> Thanks,
> Richard
