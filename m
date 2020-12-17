Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4352DCAFB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgLQCXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgLQCXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:23:20 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642ACC061794;
        Wed, 16 Dec 2020 18:22:40 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q22so18022015pfk.12;
        Wed, 16 Dec 2020 18:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kdgZpH5zhK45f9ONEpP7+71rrjeg6WLO9Q4NzwSPfyA=;
        b=vXecVVRKqSGBP29JUmVEz46Mswwzd6+4DFqEOHeZ19Uw3rEAj0M9Wmp4SbPbzA13+A
         OZ16G6CkgSsW+44JpD+fgbJWJMJYfghNdCAh/HlYK6lTMYqsvypt48JsQPkW308XTf0U
         TY0cKi1aOuA8S6LU9R9y2O+nFpWXDP4GEraU6ZdxFrNCGPY6FYV+uK4TBDdJ0gt9WCYX
         YOWWTWxR7QFWNj90s6AZKPLMUKFkq6UaXipRHyeTIpn2Vskr17GThKxQPbTRHDyeCja4
         7bWnTjRHEGRojydjgPegOYAAs2WRAUiivZZp7ZojtY0avNqnHxa4XJFwDgLF0krWK2xW
         0NFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kdgZpH5zhK45f9ONEpP7+71rrjeg6WLO9Q4NzwSPfyA=;
        b=PmIBQq7rivippGRBGGGgL/CFUi4A0NuzPkAZWr7MFsftNgRO+s7bWpq0RhtmTHHkQm
         0cjHUrtsaxz9QPiKjasYs9+62MM9RcrpYxHmcdjtKNri3NNMPVCGWhDQTUpKPa5T+ChV
         lqSUJl4kldNrJoXMkcxXGQp4gW3Sooahq8SJP1rWE+Hq1tC3r50NALKtWMPYYGjBtYzG
         TOHPgICAkINz49VnsBLMhlWH+yxhHrvLuE9YveSIU5IdCNhAMEDLBe0DZrnMwv2wjJut
         9d7CDKbN4CfwifmUMS2cXhwfJWVPM5ukH2dv1dQXxRo7xsAUsDWiiz2tjN8oOWeKIrJU
         gxlw==
X-Gm-Message-State: AOAM532J5Y4+D8RGfgbOuhmx8G6pEkBJVa2xh6ftEXdksaWyaZAQQwjZ
        UWv1dIRqISzmNZJiHxAovU8=
X-Google-Smtp-Source: ABdhPJwaabE+62JHWNklzDe5UAl8rrxr/LynPFYnVqDEgOEZGzOwbeGLHoCSs54O6VOzjy8p0D1Byg==
X-Received: by 2002:a63:4b1f:: with SMTP id y31mr36353111pga.29.1608171759955;
        Wed, 16 Dec 2020 18:22:39 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w70sm3728551pfd.65.2020.12.16.18.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 18:22:39 -0800 (PST)
Date:   Wed, 16 Dec 2020 18:22:36 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Holger Assmann <h.assmann@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: stmmac: retain PTP-clock at hwtstamp_set
Message-ID: <20201217022236.GA28883@hoboy.vegasvil.org>
References: <20201216113239.2980816-1-h.assmann@pengutronix.de>
 <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 05:13:34PM -0800, Jakub Kicinski wrote:
> On Wed, 16 Dec 2020 12:32:38 +0100 Holger Assmann wrote:
> > As it is, valid SIOCSHWTSTAMP ioctl calls - i.e. enable/disable time
> > stamping or changing filter settings - lead to synchronization of the
> > NIC's hardware clock with CLOCK_REALTIME. This might be necessary
> > during system initialization, but at runtime, when the PTP clock has
> > already been synchronized to a grand master, a reset of the timestamp
> > settings might result in a clock jump.

+1 for keeping the PHC time continuous.

> Please remember to CC Richard, the PTP maintainer.

+1 to that, too!

Thanks,
Richard
