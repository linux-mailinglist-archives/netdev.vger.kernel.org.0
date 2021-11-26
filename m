Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BD545F2E4
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhKZRcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbhKZRaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:30:52 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D10C061D78;
        Fri, 26 Nov 2021 09:03:51 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r5so8681527pgi.6;
        Fri, 26 Nov 2021 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K4U7wVtQAkx/xl+mdh09LcLr7VI/ZNsLD5RObEOuOk8=;
        b=TGt20UlGLgsQId00yc04mquzwp5ghmCBf1/3pkfNdQRUgmfssYwOfDhvDnJLH2fpFh
         I2uhDd+gxu/Txi9/Ri9nOzHdAcL7xuA5BR/u0tiJ/ORq87Kon50XuQdkwLNpMMaX3OEu
         wf55GNcqcRQryyzaSBiClL/W1qQKln2eyEi/2ArK4Bgh+x86pMHn70kFU18f6H8HNNC9
         s+7GtQ/T8x9irHprlkvDuTf3l3mviPK67/QFNpvpdQgENTQgCc32jHTQ4i3Uhj0wyQYS
         Yk/kBrKRdOlWmjwpaU6dFppggZSVuHSk3V52yCSqEPYkQelyH5sALlHwNwUrPZZVVFjo
         IFfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K4U7wVtQAkx/xl+mdh09LcLr7VI/ZNsLD5RObEOuOk8=;
        b=ExST+wYOWuqnFzlNqEbF/VF6rGaLsLuE0dshs4hM0u8Q9p/ODa9JfqSeYN1HyXCTqS
         97xQdEedr2fuCzCwWbbKYwb/MvGBbVYDPqaFZQ0yuU+Vs27dsKuXQBfJQxWcU8Fc8/sf
         mDNSF5xnD/pJEO9o/WLfmrQXo3nPbTZ8RefGG6Lj/+J4bVFjh7eQL4Bw6rPNaTWN1r7o
         NgXXfsn+K0OUj1zeZdazX1Zi3KdBN2EtRJzXllej2FPTCYokRLKfsIibN9I2zBA2+Ah8
         hTEaTNJJYffMg0NommBOiKRfkCjyFJM8eEg9fDN4CQASlHIL71LieewYN+0os8a10iJt
         IxNA==
X-Gm-Message-State: AOAM531R7yhKmAXQfdnZp2ymArPursVFOUmsPkW3yfFJwWX1vr2KxAr8
        zGbld+/Jgx1a6J5MicX8rYc=
X-Google-Smtp-Source: ABdhPJxxcdhCb5/Vc3CUdPsTK946Hp0wBe/Hp0oWz42VKqd0TIT27IWUuB9c7hBH8+sa1xWUYH2/Lg==
X-Received: by 2002:a65:4cc7:: with SMTP id n7mr20909952pgt.179.1637946230655;
        Fri, 26 Nov 2021 09:03:50 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ml24sm6151216pjb.16.2021.11.26.09.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 09:03:50 -0800 (PST)
Date:   Fri, 26 Nov 2021 09:03:48 -0800
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
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Message-ID: <20211126170348.GE27081@hoboy.vegasvil.org>
References: <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org>
 <20211106003606.qvfkitgyzoutznlw@skbuf>
 <20211107140534.GB18693@hoboy.vegasvil.org>
 <20211107142703.tid4l4onr6y2gxic@skbuf>
 <20211108144824.GD7170@hoboy.vegasvil.org>
 <20211125170518.socgptqrhrds2vl3@skbuf>
 <87r1b3nw93.fsf@kurt>
 <20211126163108.GA27081@hoboy.vegasvil.org>
 <CA+h21hq=6eMrCJ=TS+zdrxHhuxcmVFLU0hzGmhLXUGFU-vLhPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hq=6eMrCJ=TS+zdrxHhuxcmVFLU0hzGmhLXUGFU-vLhPg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 06:42:57PM +0200, Vladimir Oltean wrote:
> I'm still missing something obvious, aren't I?

You said there are "many more" drivers with this bug, but I'm saying
that most drivers correctly upgrade the ioctl request.

So far we have b53 and ocelot doing the buggy downgrade.  I guess it
will require a tree wide audit to discover the "many more"...

Thanks,
Richard
