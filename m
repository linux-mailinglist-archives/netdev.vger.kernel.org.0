Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C2045F317
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhKZRoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhKZRmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:42:01 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0108C06137E;
        Fri, 26 Nov 2021 09:18:21 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x6so41484206edr.5;
        Fri, 26 Nov 2021 09:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YszGERDeECoMOZaP29/5y/59DxPqeaNztlt3/qz1DSQ=;
        b=YURDCbcg2Zi2uj6U53+fUclZRJ+Z6QuyvcHC8U2BW+t3nuWnO1YVaLZ6tmaxtHMjcP
         lN9SUJu0DqaBoPJ+UIDuC8cxEgLPEh8V2VnKsNXJSED5KaAaUp3rG8rpge+Eg4RZsVg5
         /jjZEKrS+xWMvT2iSi4EETruqrrcFkMctYzpyTgXORfIo1lsuvZcmVX97Gs9oy/5Bo75
         5SQ281z5DYXXn7TUQWak8+NCNnorbvo5Oh0eSkmBEaiej62Uc7AJjAOIGUfACHWFDSQw
         QOy3Vim6eycMIxunHc9iPGzRzaHjLP4zBjo8CcKkI35DEOqG+2dmNAIfPPosfuCECaLt
         PQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YszGERDeECoMOZaP29/5y/59DxPqeaNztlt3/qz1DSQ=;
        b=IUHeJ0XnRVTawNSrnayr2uN/6u0+kq7x7iVJYbumCtdLfX1TjJg4fD+9Q5kcw6hP0/
         vy04J6dSP0aO6zqzU9Ly2xgC47NB10DYLPORUO+wWwkTBjhBMmCWrWygXwglNY9SmmMm
         hR0Sxn79ZfM1DTn6kBat+43IUkQvqXsrMMNEEesEFonElBDcOZvT8w3E2vEMHBJmkkyu
         Wdk35KSDCIPzDQku1k8y8jFngzymFeqrCf27Jf2+bVKeOSlsAgfKz5U8d5x4s7LxsH/j
         jXbVgygR84uYMUC93/BtjkODghypYvTs5ae4yPLEHmuXisX5vweuDL4yuo46wA3iE0Ng
         PNDQ==
X-Gm-Message-State: AOAM531z2ocEY44gAtV+rjF5+lkpNPJlBtJWXvzekiQezNgWYwT2VTdC
        wQZAthvf0relmgF3hKiFWic=
X-Google-Smtp-Source: ABdhPJyqvxtKrHddLLi/xtSEJmBvf/jHJglJSqpUHfu4TNZIhPrFrC2N7hDDaAJQlNbbFeRHDmO1aA==
X-Received: by 2002:a05:6402:11cb:: with SMTP id j11mr51131484edw.38.1637947100439;
        Fri, 26 Nov 2021 09:18:20 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id hp3sm3565638ejc.61.2021.11.26.09.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 09:18:19 -0800 (PST)
Date:   Fri, 26 Nov 2021 19:18:18 +0200
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
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Message-ID: <20211126171818.bvlxjoz7hu5w7bi5@skbuf>
References: <20211106001804.GA24062@hoboy.vegasvil.org>
 <20211106003606.qvfkitgyzoutznlw@skbuf>
 <20211107140534.GB18693@hoboy.vegasvil.org>
 <20211107142703.tid4l4onr6y2gxic@skbuf>
 <20211108144824.GD7170@hoboy.vegasvil.org>
 <20211125170518.socgptqrhrds2vl3@skbuf>
 <87r1b3nw93.fsf@kurt>
 <20211126163108.GA27081@hoboy.vegasvil.org>
 <CA+h21hq=6eMrCJ=TS+zdrxHhuxcmVFLU0hzGmhLXUGFU-vLhPg@mail.gmail.com>
 <20211126170348.GE27081@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126170348.GE27081@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 09:03:48AM -0800, Richard Cochran wrote:
> On Fri, Nov 26, 2021 at 06:42:57PM +0200, Vladimir Oltean wrote:
> > I'm still missing something obvious, aren't I?
> 
> You said there are "many more" drivers with this bug, but I'm saying
> that most drivers correctly upgrade the ioctl request.
> 
> So far we have b53 and ocelot doing the buggy downgrade.  I guess it
> will require a tree wide audit to discover the "many more"...

Ah, yes, I assure you that there are many more drivers doing wacky
stuff, for example sja1105 will take any RX filter that isn't NONE, and
then reports it back as PTP_V2_L2_EVENT.
https://elixir.bootlin.com/linux/latest/source/drivers/net/dsa/sja1105/sja1105_ptp.c#L89

Somehow at this stage I don't even want to know about any other drivers,
since I might feel the urge to patch them and I don't really have the
necessary free time for that right now :D
