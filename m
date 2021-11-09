Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B53E44ABAD
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 11:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245412AbhKIKm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 05:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245408AbhKIKm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 05:42:26 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E88C061764;
        Tue,  9 Nov 2021 02:39:40 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id j21so74610414edt.11;
        Tue, 09 Nov 2021 02:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q4bdOdLYfsLL7H2ViKAtSs2PP+PMsHatQ/9U1YFvzMg=;
        b=VUt6GtfAcks0r9L9W9Cu1gyEd62lb0BNOvqdQRALzOdM8LB8U1G6W8Llr/4St0Al6N
         xL/S92+mVpglTscuBue9INE0gqDMvLwB202/NSmjOYOy62Sy4mKDfTwOFSkQnG+nI6Cs
         1KnH6dPvve363wTYFsfc/euaeMiewKDM1c5rjg7skKW3KzpYIFR0FtvFWGk1a17yhhYi
         NiELNRRxQpA0eCNCjWv09+olebXBUlWbLDpGYoOAfGWjlHdhUtC6JTtocmRyZ81Y2aWa
         b1+p61fQvvNq2AJ9QYCZSMxsFo0L1yt0Eet+I5s4etet+u0W+8L+ZZFSdROcnp74RjX0
         +AkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q4bdOdLYfsLL7H2ViKAtSs2PP+PMsHatQ/9U1YFvzMg=;
        b=wgISzh2TRS2GjUTeSyheW25EwXAc5RacNugLfHqMydkJnw7z7r9XjzksZLToNVGDc0
         NaEUrBvQHQ5D3Z/gYtgQ/oFL0YGMLIM/HrsSAr+UxyPPexhWQMXRh09XmOEFSzgELDq7
         Jo7gq+TsI6Dy7KMxBP/WY9eRMjAd//IFirpt0pb5UxyEXOhbkePUselVyScGmIjSEgNm
         3zpgxeXCsKqY4L69ctOzvrf7uIfTANOeuxUMPTn0QgS/MR/A7MCpoBPQWVhh5QHwN1+3
         hQdaqWogxhi/wpllu4wE0eZ6Xxq5C/HtAASpnj9dmkF+u8fyWRGdy0CiKi5DrfDGFn9y
         zzJQ==
X-Gm-Message-State: AOAM530uNKrIhqNtUhsmev0IbAd/ZesVXEbcSN3G+IBdUSFM+03aNHCj
        jXfww81YEQPSFMwK6TU2wbQ=
X-Google-Smtp-Source: ABdhPJyGrsxBm4jFMo11CcUR/sr6JPOBskUDwVLGK3LV+mB5T4WcolCtpOv/4vY+o1pyLGuSO27omw==
X-Received: by 2002:a17:906:7304:: with SMTP id di4mr8048708ejc.474.1636454378719;
        Tue, 09 Nov 2021 02:39:38 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id hr17sm586336ejc.57.2021.11.09.02.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 02:39:38 -0800 (PST)
Date:   Tue, 9 Nov 2021 12:39:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Add PTP support for BCM53128 switch
Message-ID: <20211109103936.2wjvvwhihhfqjfot@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109095013.27829-1-martin.kaistra@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 10:50:02AM +0100, Martin Kaistra wrote:
> Ideally, for the B53=m case, I would have liked to include the PTP
> support in the b53_module itself, however I couldn't find a way to do
> that without renaming either the common source file or the module, which
> I didn't want to do.
> 
> Instead, b53_ptp will be allowed as a loadable module, but only if
> b53_common is also a module, otherwise it will be built-in.

Does this not work?

obj-$(CONFIG_B53)		+= b53_common.o

ifdef CONFIG_B53_PTP
b53_common-objs += b53_ptp.o
endif

(haven't tried though)
