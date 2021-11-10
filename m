Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792FB44C416
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 16:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhKJPLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 10:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbhKJPLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 10:11:47 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05E5C061764;
        Wed, 10 Nov 2021 07:08:58 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id m14so2888804pfc.9;
        Wed, 10 Nov 2021 07:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=odGTnK8OK8r3z3b40pT32upAxG17hXJdJNDrUm3eoyg=;
        b=RLh3FtXsv6t7xehRHzTeN8HZpcPX7JzXYZ5T8TZGOq5SG4I+zVb/6CDp/euoeWys+g
         74DEjof6QBoeBhPzIj+E6PNVqq2ntmd3I9EtNm07sNRQQexpo6XDYGoipF0UgmnM9p9K
         yuDxPbLwiR4R2Tp17ysicxz7M2WTZzsV39t6U6TwpLkBLi47KohVyvjQwCY7rDxS6bn7
         Jo0KgpNuXTThBc8QVacpKRrX+pXRots+WaCPMN1HAZiBBemBVstuP4L/0HZbyp3CskU4
         5ydWXKZzgoTcNDxJuUTblnDVAqyWYPAjGddQ9rIp6Axrf2x/BrnXywjW8goDu1jj3XXR
         EuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=odGTnK8OK8r3z3b40pT32upAxG17hXJdJNDrUm3eoyg=;
        b=XFlvak6HB+gy7nkaMWnRmF3HhC0XH+GlG2FJ4KTNY039I2ytT+3CuDXZEWJTCTQweX
         ItcuzZNyMWQG5Di5KXal5FZKwOki5X9MqO7v/a4iOmc9nhp8QTAy8NAwY+138rNTcC9o
         jzZvZwIp8vRAcOEZTtWy0Bqtw1YMakmy3blsY1RwZYrOzg4eCkznVU1M+DxfBrKIduhn
         Bfln0qHq6Crj//oPXEsbuqrfbFVs+kZTnb/wmb0fs8YMR3VoYwEUbt75EtDfB9plMl5R
         Qi9oqmqrpepLUUyR/3v5KsnBFMWLSuWSsf4XtasTNJRr8y1ouOLIVCbvF0cuZ+VdtMNb
         PeuA==
X-Gm-Message-State: AOAM5331s/bZg9bT15qnTHF5oa9yzTrTXLWe3W8AyQoyZR6JQvndLOB8
        Xozbv95uslLB9ik9hoNzU1/6i5m7dTo=
X-Google-Smtp-Source: ABdhPJw1XRGEE93HNGg1VdLi0tEx0u9Y4Gn5Cviu7Eeaqdyk7728x0FUh7eokWhu2BOF2f2YUXuGgQ==
X-Received: by 2002:a63:86c8:: with SMTP id x191mr333552pgd.153.1636556938091;
        Wed, 10 Nov 2021 07:08:58 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t13sm28375pfl.98.2021.11.10.07.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:08:57 -0800 (PST)
Date:   Wed, 10 Nov 2021 07:08:55 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
Message-ID: <20211110150855.GD28458@hoboy.vegasvil.org>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-7-martin.kaistra@linutronix.de>
 <20211109111213.6vo5swdhxjvgmyjt@skbuf>
 <87ee7o8otj.fsf@kurt>
 <20211110130545.ga7ajracz2vvzotg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110130545.ga7ajracz2vvzotg@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 03:05:45PM +0200, Vladimir Oltean wrote:

> So it is true that ptp4l is single threaded and always polls
> synchronously for the reception of a TX timestamp on the error queue
> before proceeding to do anything else. But writing a kernel driver to
> the specification of a single user space program is questionable.

There are a number of HW devices on the market that only support one
outstanding Tx time stamp.  The implementation of ptp4l follows this
limitation because a) it allows ptp4l to "just work" with most HW, and
b) there is as yet no practical advantage to asynchronous Tx time
stamping.

The premise of (b) might change if you had a GM serving hundreds or
thousands of unicast clients, for example.

In any case, I agree that the driver should enable the capabilities of
the HW and not impose artificial limitations.

Thanks,
Richard

