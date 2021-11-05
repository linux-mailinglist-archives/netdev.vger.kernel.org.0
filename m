Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8F4464ED
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 15:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhKEObR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbhKEObQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 10:31:16 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189D7C061714;
        Fri,  5 Nov 2021 07:28:37 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w1so33988028edd.10;
        Fri, 05 Nov 2021 07:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4wnFihb9FXtR0j6s/uHUquZ5b5gAn6PDUylWYZcjqls=;
        b=Fa8cnWlbD+FnsaVmc4oZuliRtAF2sAimCkPYZgkPfLWzR1sVJEzyBnMWn7xH4KPXRQ
         nqUrFV3GAL2IiZrccmCnHGpmpQebHOiwGj3YewDXD8yRf70wk1zzkRRHMcQVTBDvehjU
         9JHdETwTUarCRH3tbqiJ6Po8uSMXDNANppF+1JXFlgDguApnhIQZvOH73hy9XHlWcwPM
         PPoi3wN0nEMPFiFpd742jd0hIswMbOuNzFo7P0s52hm4pnFE/qzuWsSAHK53VJ8fMsKh
         CVz8LOPwpeUrt4K7KXYvVwHMn74IxnrwSxRAOXw7lDfrjjsVhiMB+me5dlAQBZoDVRjP
         ROAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4wnFihb9FXtR0j6s/uHUquZ5b5gAn6PDUylWYZcjqls=;
        b=NmurOGwjp8x9pgs8BRkme9tTKVeJLXI2LW2vuLEorXyp3befuUjVQ7GducvFGaUl3J
         SD4Z77NtRyZl5fe8QMo4njGwynR9ZWkXU8HfAme6yWCbFv9QzlxOlGQOwwrmo4lmarrd
         PxU8mhP7lIlIxndbnk4ovpbVrfuIYqaciQTl/feI9WdqkDTRQM+Kh95wwn0aK7kjzJn0
         3Vk0d6U26Pg+KEqSW6BiLDy/L1wJcy2AHQ82Njcu7tFspgwZZkoYwwnPT1EWBP3hAsyR
         QmLhl9i4qnwpLgQsXcZZAlj/u7zaEBKPRgXoXURFH3EvgkNRe70tBiK+C1pjhKqci81Z
         CwTg==
X-Gm-Message-State: AOAM530hJgAm9wrSzmvfXq85p4j3fKy/+IxyNihTbDJjyukF4eyAiX5g
        n5uPE/McsicQTVhosSZJyys=
X-Google-Smtp-Source: ABdhPJxB531x5JjUQVyT9+b7131JLPeLHSABBwIeCQDnVOFWNXYCzdi8U9ZKt9u4U267GJfGioprsw==
X-Received: by 2002:a17:907:720d:: with SMTP id dr13mr45995011ejc.153.1636122515666;
        Fri, 05 Nov 2021 07:28:35 -0700 (PDT)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id m9sm4100187eje.102.2021.11.05.07.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 07:28:35 -0700 (PDT)
Date:   Fri, 5 Nov 2021 16:28:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
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
Message-ID: <20211105142833.nv56zd5bqrkyjepd@skbuf>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105141319.GA16456@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 07:13:19AM -0700, Richard Cochran wrote:
> On Fri, Nov 05, 2021 at 02:38:01PM +0100, Martin Kaistra wrote:
> > Ok, then I will remove HWTSTAMP_FILTER_PTP_V2_(EVENT|SYNC|DELAY_REQ) from
> > this list, what about HWTSTAMP_FILTER_ALL?
> 
> AKK means time stamp every received frame, so your driver should
> return an error in this case as well.

What is the expected convention exactly? There are other drivers that
downgrade the user application's request to what they support, and at
least ptp4l does not error out, it just prints a warning.
