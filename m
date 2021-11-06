Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02817446B9C
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 01:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhKFAiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 20:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhKFAiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 20:38:50 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F42C061570;
        Fri,  5 Nov 2021 17:36:10 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w1so38870165edd.10;
        Fri, 05 Nov 2021 17:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FbwbGKblgBhOG3BYzuRuycuZHQL+jUXDeOyT5sd4/fU=;
        b=mcRgRPvHK6dxMJPFXUhT2SMIqowmiKrXi5fbaA3udRd8s8HqQh5vFEDF6ISBL0SCBs
         +vmEQXVAX8AdhC3tS5fwGjn2fy7n6m85F6iAacIdt3+IsEKt/nQJhCdJR5c6pWbmxuoP
         3fGFFcsrtJCajXTqTXCFc4qXW4mn7MhqXrl9hD9Y5vj7Y76jFfT8dwidwsygJ1QOsSJs
         MeEL4T53mQvOETive45QuAhESe15HLzw8leStCQhN56WvL/PIUDW13J5zuZK3txf4Lk2
         9FdUig5oT8Kk+yMdJBHaeUX+RkVDrmrdaguB+R60/IID21LONcrpvRU9y1xbe96PUcu+
         k08g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FbwbGKblgBhOG3BYzuRuycuZHQL+jUXDeOyT5sd4/fU=;
        b=q9Xg11nZVzstkm5IJde9Kim/m8DtFEC3+9lGVUcSR9E+m3Q3GtS1w6twfDHDoVcvoe
         cgO7V5e7J9IIK+FM0LJ6Jq3gCYL18iVsjMRSo9LOc9lhoBOMsUc7K97jrSiInaJ8fLt1
         KCCZv3C0p1EvbDkDaVlcQ/v6MYHcySFanP7Ste1nQV2lTLBXpAeS/5V7GiZJ9HWSjwJF
         7tJyQocXYz78RK6J9yEWMBdgCRNMhu0UemBddIlD9ZDt015VBkCf2GeMvHU5xRiEVaep
         RHJ4bId7v/G037cZAtkG5meiK9O4yr9mUusLeWtH2GEbVD6cRFAE/1/cb5nAffzk9JIw
         559g==
X-Gm-Message-State: AOAM533io7lsg4U5vgTCe1AL668WLpPZSSp6IUCMhAj1cbPHg/FDA6tn
        jqWoDQI5uRFCPLmFlF0X3xiQBcURr/A=
X-Google-Smtp-Source: ABdhPJyy+1r5Zt8KExDrgG06FasMN7Oy+m4q6KTfyPWH4L+f8Nx8wIrzPfQCBZVKrFqbRcjEkqSlgQ==
X-Received: by 2002:a05:6402:41a:: with SMTP id q26mr37984600edv.387.1636158969034;
        Fri, 05 Nov 2021 17:36:09 -0700 (PDT)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id 25sm5294268edw.19.2021.11.05.17.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 17:36:08 -0700 (PDT)
Date:   Sat, 6 Nov 2021 02:36:06 +0200
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
Message-ID: <20211106003606.qvfkitgyzoutznlw@skbuf>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106001804.GA24062@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 05:18:04PM -0700, Richard Cochran wrote:
> On Fri, Nov 05, 2021 at 04:28:33PM +0200, Vladimir Oltean wrote:
> > What is the expected convention exactly? There are other drivers that
> > downgrade the user application's request to what they support, and at
> > least ptp4l does not error out, it just prints a warning.
> 
> Drivers may upgrade, but they may not downgrade.
> 
> Which drivers downgrade?  We need to fix those buggy drivers.
> 
> Thanks,
> Richard

Just a quick example
https://elixir.bootlin.com/linux/v5.15/source/drivers/net/ethernet/mscc/ocelot.c#L1178
I haven't studied the whole tree, but I'm sure there are many more.
