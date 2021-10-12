Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D275A42A926
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhJLQQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLQQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:16:17 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA92C061570;
        Tue, 12 Oct 2021 09:14:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id t15so4258465pfl.13;
        Tue, 12 Oct 2021 09:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DkY3d68uoQT/okBEYrnEsVBCDmQNMvY8dhS5IKFlRTU=;
        b=kGgWzHK0uzH05mt1X/x6MfCjjvPbnY2EOS3P8i3wNXiB2F2K1IC1Ui/m5fpzeCnFkw
         7ZB+j6QN7UaZL/0AoiMCIpRXqRzhj4gKb0NYwQFlcAsahUYQPgTwaSiY024SbONR7oBE
         euT5olU3BhJepr1k4B5kj3zACnZhAIQk/mM46/jQbMu7fPsdTip9130GSW0LsDnlafa6
         D/8TagezDg8h3Gy9JAnEG4m/ITC4kCycpn+gwRzLaKcGx7I6NuSJgvNjYCVUR4cj+eXl
         wljFkoEPRXq53jCC9wDbn+tqdEGZ4DQAckLJmFSgiU2o6V/5m0nfQxHq8DUKtqTlkBxO
         PZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DkY3d68uoQT/okBEYrnEsVBCDmQNMvY8dhS5IKFlRTU=;
        b=jjuzhBee1O2gLVpczmmXEMovQM/ZnrHQOeLKM3hJa9AD4WCmDsWOedzzfk879daKbH
         Orp5azw9yEMyAbiTRnLn6tw1nbc1YAXRRhsjIs+SXnPp81qCGD68UQCAz8FgMUNVKOzm
         6fulhFMSC7+c22hv6kdeFspi5+Kczh2FLAHG0ljbl41O8ZQsFeyFFUpjZ4EH5zU23vaB
         Im9ZC/3k1/Yr32xwwJUyUmA/8K7IJpv0hKAW+8nNjPl3OSTR4ESQC9sYSyjv60XkMDM9
         npBCF3HGww31O77mxfnFy83lMcJ4/9oVsjVpojMHgw6h8/qhhHro1qCVCsYuwZr2eeRr
         TSfw==
X-Gm-Message-State: AOAM532jcTuagvEcEnAoaR1urcS921P0tdG+uId++3ctF0ysTIkG1/3w
        IWGeJTbTTTM6t9hovQv8isk=
X-Google-Smtp-Source: ABdhPJzkh/fQYkJRJ/CfPSQX3POyo5suzULCJTwx08Me+ri9nF9OeoE9F7cT9m+lagCZ5yfckXmSWg==
X-Received: by 2002:a63:3588:: with SMTP id c130mr22169717pga.23.1634055254981;
        Tue, 12 Oct 2021 09:14:14 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h1sm2967434pfh.183.2021.10.12.09.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 09:14:14 -0700 (PDT)
Date:   Tue, 12 Oct 2021 09:14:12 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20211012161412.GB5338@hoboy.vegasvil.org>
References: <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
 <20210927202304.GC11172@hoboy.vegasvil.org>
 <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
 <20210928133100.GB28632@hoboy.vegasvil.org>
 <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
 <20210930143527.GA14158@hoboy.vegasvil.org>
 <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
 <20211007201927.GA9326@hoboy.vegasvil.org>
 <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
 <20211011125815.GC14317@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011125815.GC14317@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 05:58:15AM -0700, Richard Cochran wrote:
> On Fri, Oct 08, 2021 at 09:13:58AM +0200, Sebastien Laveze wrote:
> > Of course, so what tests and measurements can we bring on the table to
> > convince you that it doesn't lead to chaos ?

> - However, this particular physical clock uses a RMW pattern to
>   program the offset correction.
> 
> - Boom.  Now the duration of the RMW becomes an offset error in the
>   virtual clock.  The magnitude may be microseconds or even
>   milliseconds for devices behind slow MDIO buses, for example.

Come to think of it, even just calling clock_settime() on the physical
clock will cause trouble for the virtual clocks, and that on all
drivers.

The code would have to call gettime and figure the difference to the
new settime value, then apply the difference to the virtual clocks.  I
expect that that would cause a phase error in the microseconds for
PCIe devices.

Thanks,
Richard
