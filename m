Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CB61BD60F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 09:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgD2HaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 03:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgD2HaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 03:30:09 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF74C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 00:30:09 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s20so532375plp.6
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 00:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daemons-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UO/fhO+poDmbn1JfFxZG+nR2c8Gsi+KbKEykhiLRZHg=;
        b=hddACICWxJ59STwMM1rsyRUzZgmDjyGAmjxzezwzmaxkrCeZhzCFLVyVbKx6IrDK13
         fkt1DH7OglubfpXhuFIJW+Zn0nAplRHeouXUS+tcOMlfPzN/k6rdtizw+T+BJYF1eRQ/
         djdD8KwBSoawvbnXVu1bU/8RreVwL40dyeHLg1GeyxbjoOqDwNpR8HBLXpf+gWWZxFz/
         5Tk/2BdWDuKhW6NT9JJ0LHJnzXmN26di28uF0my6ouVYmsIWPPhEPUuXLb25R2TEeat5
         WlrIzI8xaFz1wgmlYEako+fqdFNMtl5Hi58876NcVXq9KfQCvpts9ql9xNUBV500C7D4
         JxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UO/fhO+poDmbn1JfFxZG+nR2c8Gsi+KbKEykhiLRZHg=;
        b=CADt7LrQO6shAu+5JzQaaMo/gcGklKTf062Hg4L+NhwMtr0Xc8SreDWClqsW2b+n30
         CYl4QcLkYGMa2duZbY/MlnAuWjwmZHf/CzH0bBeqKwBRlQg6SqiKLLSE7CNMGnQPVrQw
         bJSNIXxnbpQFV41a5BaavPccqRTJVcgidY52WWZAao7xqC5c2jU3csdBmsAzrkopdDXY
         YJmJxnhf5pH2N/9bEPR8ZGJA6nS8e0PG3ZuBmIvrOA44p3RNtDYCXeiO/7MH/ciKBwop
         qBa3BaRXZ67kKl9Cmpvdpgw+QyntdVmPcpIUbZDVXD5kTTmJJXLyzXZ9v/MWavVFg5b3
         spBg==
X-Gm-Message-State: AGi0PuYA/kikpCpHPeEFmdo6+MZTfRY1C/wfvH8j4TOLWtWzGpz5D0t0
        L/zu0pFSacqKYSECyUJQa6Rp
X-Google-Smtp-Source: APiQypJF+/ToLVaFL7/2/pa+Jv0MNE2iJlyxoZVkzQn+f9OFQgbktjyflwVKpIX3BitoNBRAgvVKFg==
X-Received: by 2002:a17:902:9a8a:: with SMTP id w10mr34010442plp.259.1588145409130;
        Wed, 29 Apr 2020 00:30:09 -0700 (PDT)
Received: from arctic-shiba-lx ([47.156.151.166])
        by smtp.gmail.com with ESMTPSA id 189sm390149pfd.55.2020.04.29.00.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 00:30:08 -0700 (PDT)
Date:   Wed, 29 Apr 2020 00:29:59 -0700
From:   Clay McClure <clay@daemons.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Mao Wenan <maowenan@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Josh Triplett <josh@joshtriplett.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Select PTP_1588_CLOCK in PTP-specific drivers
Message-ID: <20200429072959.GA10194@arctic-shiba-lx>
References: <20200428090749.31983-1-clay@daemons.net>
 <CAMuHMdXhVcp3j4Sq_4fsqavw1eH_DksN-yjajqC_8pRKnjM0zA@mail.gmail.com>
 <CAK8P3a2rG-A6_qhU9vrcadZqq2r1FdCDFMVPhSzPEAO83WrA9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2rG-A6_qhU9vrcadZqq2r1FdCDFMVPhSzPEAO83WrA9A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 06:07:45PM +0200, Arnd Bergmann wrote:
> On Tue, Apr 28, 2020 at 11:21 AM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Tue, Apr 28, 2020 at 11:14 AM Clay McClure <clay@daemons.net> wrote:
> > > Change these drivers back [2] to `select PTP_1588_CLOCK`. Note that this
> > > requires also selecting POSIX_TIMERS, a transitive dependency of
> > > PTP_1588_CLOCK.
> >
> > If these drivers have a hard dependency on PTP_1588_CLOCK, IMHO they
> > should depend on PTP_1588_CLOCK, not select PTP_1588_CLOCK.
> 
> Agreed.

Thanks for reviewing the patch. I'll post v2 using `depends on` shortly.

> Note that for drivers that only optionally use the PTP_1588_CLOCK
> support, we probably want 'depends on PTP_1588_CLOCK ||
> !PTP_1588_CLOCK' (or the syntax replacing it eventually), to avoid the
> case where a built-in driver fails to use a modular ptp implementation.

I see some drivers are starting to do just that, e.g.:

commit 96c34151d157 ("net/mlx5: Kconfig: convert imply usage to weak dependency")

I can post a patch this weekend converting the rest of the drivers.

-- 
Clay
