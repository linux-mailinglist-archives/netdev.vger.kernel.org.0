Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57E0446B84
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 01:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhKFAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 20:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhKFAUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 20:20:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BB9C061570;
        Fri,  5 Nov 2021 17:18:09 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id b4so9597764pgh.10;
        Fri, 05 Nov 2021 17:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oYgqGbvCvuiJMjGiyHCIz3J2fZWstZc2Sdb/7yNb2aw=;
        b=WQWp1qNBT+SD2gK16Eu7aCpqEcugs9Esoc4YWwfCFfzEHEbVuXMiISu8s5le4YSImo
         /qTTN7d5MGUc54XbHcD/dAMX8O6Kjmb7Qh1GHCbzjDryxeQReDch4OVGpIaAL7/3NI+L
         gKTNlZnJoVmyP3GPtVei4cEnZ79QLI6w5NL0BtiFVEgoMfZRd/Q3aekI7PXF9QXw623j
         w4btKT6RHawHn6SkEa4du1I6IYb3F33V5gIvyZFz1hMn3Oz5hHTt3d/ou1ovBvpxb8mn
         4Z8yQYNBG6vnEeVbdx2imuBr7ELtOWWzd6g0ANq84opoFcdsL6Ym0s7qOxuIfBfr6hI9
         W/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oYgqGbvCvuiJMjGiyHCIz3J2fZWstZc2Sdb/7yNb2aw=;
        b=gD79yED5RUJlBq/MFvL/MJHlM46GpNHLnT1yuvaRorgXM3/dExuVwWWEPPzMe6QjCe
         Ws76p6Fng0HJAzx2MdXzxi2CkgOHNaoLakePWoFC+yC0dPhq5/LMdjCMM0z1pG2Ermio
         2FbZNlP39UQqLYmkgSzvTm/GfASF6nPRFtqj0AtKG489rp9NyTCKg2XWUgobzqvBTE+n
         jHx7+CTtMjD5RMnm97kz/Z0CvUM75QHC9P8XW1f4rGj2ow0HiHhi6QdegLBVNbPX1ufk
         dSkFQ32E+L4rlly/uuXHUAPVNLjWucfKlhn+Re5sSBzVL9SywScaVG8qz/TdpBCkLOJd
         /OhQ==
X-Gm-Message-State: AOAM533Wb5Kru/Z5pqZBExOi34N7MvlzGewJofxTHL7+3kTj0i9eQ3mj
        BRtQUgvM88ZcMDthhoRgyRA=
X-Google-Smtp-Source: ABdhPJyZnpuACGKkcyMYrlyaMYto/L9veUyAaYmBCzh0TYdlMhL/JW5kfwVTqfYQN+WmXKLfXpetPA==
X-Received: by 2002:a63:f62:: with SMTP id 34mr46335822pgp.159.1636157887817;
        Fri, 05 Nov 2021 17:18:07 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w7sm549395pgt.37.2021.11.05.17.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 17:18:07 -0700 (PDT)
Date:   Fri, 5 Nov 2021 17:18:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
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
Message-ID: <20211106001804.GA24062@hoboy.vegasvil.org>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105142833.nv56zd5bqrkyjepd@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 04:28:33PM +0200, Vladimir Oltean wrote:
> What is the expected convention exactly? There are other drivers that
> downgrade the user application's request to what they support, and at
> least ptp4l does not error out, it just prints a warning.

Drivers may upgrade, but they may not downgrade.

Which drivers downgrade?  We need to fix those buggy drivers.

Thanks,
Richard
