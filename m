Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBFF36A61
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 05:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfFFDLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 23:11:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34269 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFFDLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 23:11:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id c85so578114pfc.1;
        Wed, 05 Jun 2019 20:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=byYiJvNP4AxdA2O/8mxFX8VRov3AhPWtzZd3XGwmlWg=;
        b=lGep7+d0NNYi/YAvvVgwhuv40j6jvzY2L4a4KGYUwhLgxTMlMMwWvkut09fFpbN4tA
         tdT3FNqqXz+MUA5ZnksOUb8Izvmwu6OfKBVGZIBlqodfxernYkrz9/rBo22cHiIl08MW
         tAXaJL+NedxDWUUqdLDruCLCraLV9hhDyUo4wSUH0AfZtYPw4CNymuS7SvaawG9NS8BD
         t/RdKk1JtDrgSvTWNDOpi+dCxhGSigruuxyr8A9nrnOEvcRGSbUp57P8EJUiiBf3MewN
         GwwRjDWpjjCUdW2A/9LoMe0kWQLWlOkJLALE13vrDdL0sGdE5k8RJ8RFJg6gbVpgtfZi
         qj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=byYiJvNP4AxdA2O/8mxFX8VRov3AhPWtzZd3XGwmlWg=;
        b=a+vljzX1UaERm4B/kopE+VBYNrw0+VXRcvUjq1j6QkVNByoN1RmXoyNymV33osjrkI
         m7PMe1Qc3Q23HzMoySBbj2twnrymviW25rnxuWptlkxFuyLwlUGYLIOf3I4smKAjZi4c
         /Hkj3t/oAV+4mxiT/HflEby50BfllaOq1JbibsUI3PAY5F1ByONEIWxItcUYo64StPCQ
         J++C0Asn2YPW/gnmvVnBN2lA1Wj0KnLLq0/Yo/H+0dUyrHPZymMS1UCuUUZ+8+67BmC5
         tf4nUQBEfPW+jWjYfhW9hDEe95UrplHNNY4bBDGZrzONkyaAbt6IhwAWWK0KmdBqv7vz
         Zc9A==
X-Gm-Message-State: APjAAAVGPtosNKLqmq9a+tzQmmn5zFG9PdNIOnZKbWOPYSI4F0FfO0zB
        qKxYFoMkux9DDZSxQQcsG4Q=
X-Google-Smtp-Source: APXvYqy0rvpd15LSjyqjmCQ4NDFc+S4YFjV824Gdn7DHQzju5dPXxF8WJY+++qEgI1EtEvmHWKJ1XQ==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr46756167pjd.112.1559790698793;
        Wed, 05 Jun 2019 20:11:38 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id s2sm346080pfe.105.2019.06.05.20.11.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 20:11:37 -0700 (PDT)
Date:   Wed, 5 Jun 2019 20:11:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
Message-ID: <20190606031135.6lyydjb6hqfeuzt3@localhost>
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com>
 <20190605174547.b4rwbfrzjqzujxno@localhost>
 <CA+h21hqdmu3+YQVMXyvckrUjXW7mstjG1MDafWGy4qFHB9zdtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqdmu3+YQVMXyvckrUjXW7mstjG1MDafWGy4qFHB9zdtg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 09:08:54PM +0300, Vladimir Oltean wrote:
> Currently I'm using a cyclecounter, but I *will* need actual PHC
> manipulations for the time-based shaping and policing features that
> the switch has in hardware.

Okay.

> On the other hand I get much tighter sync
> offset using the free-running counter than with hardware-corrected
> timestamps.

Why?  The time stamps come from the very same counter, don't they?

> So as far as I see it, I'll need to have two sets of
> operations.

I doubt very much that this will work well.

> How should I design such a dual-PHC device driver? Just register two
> separate clocks, one for the timestamping counter, the other for the
> scheduling/policing PTP clock, and have phc2sys keep them in sync
> externally to the driver?

But how would phc2sys do this?  By comparing clock_gettime() values?
That would surely introduce unnecessary time error.

> Or implement the hardware corrections
> alongside the timecounter ones, and expose a single PHC (and for
> clock_gettime, just pick one of the time sources)?

I would implement the hardware clock and drop the timecounter
altogether.

HTH,
Richard
