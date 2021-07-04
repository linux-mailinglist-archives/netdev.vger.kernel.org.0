Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380993BAD1C
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 15:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhGDNgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 09:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGDNgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 09:36:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AEDC061574;
        Sun,  4 Jul 2021 06:33:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y2so846535pff.11;
        Sun, 04 Jul 2021 06:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kmTHLKYe7uN/HHD833T9elNqKTkZ445a6iSqpPqctYI=;
        b=WmkvO46u0eH3efciHLO00/eGk4YxD9EiZzsUVUhJi+zF8htkowH3u5rWRteWzW4Y4O
         jLaRbQh4E0O3kR1mumNtQwRngGslHtSFT56Rr/R0ONOJ5rhgle3ELXnK+JA4jO3xjEUV
         wPLaGLpRCRKr8l5Wjkp4tUAxCyFvIKOovMWjhVVHqNNP8nOg6xrE1/9ZanwGPygtZ5N/
         GzCH3wpclWgXN0b5hPSdK0GDumopXYYo52AQCIhHsxJMNTiQrWUBBA3ObMqBfzMyJlDb
         PRn09Wb2d6UL83vIg/04RuMIkW7R/JjB3nbJUvC2amWsSYKPPyiBQHYIEIDbFi2XRCut
         rcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kmTHLKYe7uN/HHD833T9elNqKTkZ445a6iSqpPqctYI=;
        b=Iezc0F36b4gWW+UjKncmf9+Ak6shMdhQ92kfbCqC3qeqwxzPU1p+TARdLRKm1smwfz
         Qo/3gm3ywm3SXegt0cCDGgIwYKBr5kxiK2tRL6Wa8NgDrC8CdMoLBCnMkSdvGzAU/DQp
         GdpQAoT/ZPIycZT33YSveLZLIlEcefB6+1+0Ba7F/Fx0Stss7Fssw+fCUORz8R14FLgb
         t5Tenb5HvXRFkxtzX4oH/aLTxmPlc+1GRWV/A49/habApvKs8kixjIYijbJDRDnjnOA7
         PVlyoPTc6vTr7DkwLgLWlSRcSw58eIsnH5BOraI1CpAjY3Fwb06h24I0mCNqZSqrgx8J
         5A/g==
X-Gm-Message-State: AOAM530yO6SaW46Mj0Dk0Gbh13LGSJkDwPMmE2X88rhxXI0BAU0JIQBA
        Ol2FO5jU7kjwQ46tsx2lEh0kgp3YqrI=
X-Google-Smtp-Source: ABdhPJz0udZB2GaWgVkA667w2T9OAr9Ou+h7u+QEeVNoOzuY405q+y4T4O+jlAoQ/+l/JVCs+Y5cgg==
X-Received: by 2002:a63:5912:: with SMTP id n18mr10513858pgb.108.1625405615365;
        Sun, 04 Jul 2021 06:33:35 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id e1sm9572761pfd.16.2021.07.04.06.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 06:33:34 -0700 (PDT)
Date:   Sun, 4 Jul 2021 06:33:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v5, 08/11] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Message-ID: <20210704133331.GA4268@hoboy.vegasvil.org>
References: <20210630081202.4423-1-yangbo.lu@nxp.com>
 <20210630081202.4423-9-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630081202.4423-9-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 04:11:59PM +0800, Yangbo Lu wrote:
> Since PTP virtual clock support is added, there can be
> several PTP virtual clocks based on one PTP physical
> clock for timestamping.
> 
> This patch is to extend SO_TIMESTAMPING API to support
> PHC (PTP Hardware Clock) binding by adding a new flag
> SOF_TIMESTAMPING_BIND_PHC. When PTP virtual clocks are
> in use, user space can configure to bind one for
> timestamping, but PTP physical clock is not supported
> and not needed to bind.

Would it not be better to simply bind automatically?

Like this pseudo code:

	if (hw_timestamping_requested() && interface_is_vclock()) {
		bind_vclock();
	}

It would be great to avoid forcing user space to use a new option.

Especially because NOT setting the option makes no sense.  Or maybe
there is a use case for omitting the option?


Thoughts?

Thanks,
Richard
