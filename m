Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3073A32E9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhFJSUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJSUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:20:20 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE27DC061760;
        Thu, 10 Jun 2021 11:18:08 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ci15so588838ejc.10;
        Thu, 10 Jun 2021 11:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ddkMOrU72AYUM53Ybp4/qMMNjLFPCiMpCnph8t5gs0c=;
        b=OsNugS7dh+vxYSmZk4cyGBinxIS6MlfaFn3nrlIlbVdCtQwoXJOc+FtZkwwh+nVLSi
         iQ5fmBjT1iTgmvCk/O3W4nGS1FqhZklUMXTI0iMNcm3b0rMaCgLtkElGgOxqIo1xDVXj
         7NirYD8r2V2r7bXlbP2fji+ocwvhoGI94aihg7cq+6Bqlfpz1qrD2XvqJRdt3uJgaS4q
         lfG1sHa4xb+IYU6CgwWazplxyG6JQkH7CwY6LTgETZdyqDyRLmKttnuzG/Lbaod26wGi
         xyM1+M9OLFcvKtMgJxyTTlo+RnHNYYwHxH+CWzApZzd1+DqHelUySA0LnOvrzDPqB+aY
         ACnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ddkMOrU72AYUM53Ybp4/qMMNjLFPCiMpCnph8t5gs0c=;
        b=JnqV/OVRS21+GBqcFQBgoStCZLEzSgqlz52Jqlefom8p249FrHGWdUrB7GzEXfWLya
         b+9oQOgBNzcWOB6jVMPUUoTVsYWQklcbximI2tk9jU5Z3tfOHtkAQlMaSxGC+WhXt8mX
         eXKMJbOl0eCTdf1Ta+r6Pkkmi1BN7Pjtt8h0HIPwBRpc8MH6Uc20O/vwHoe22UmRd3xO
         nEAE+aVmqAzOvyGnZRwbcqbFZK67XpeOGum+E3Ze/bZu/Gsp0WSO6plzaFhfFrB7ooE8
         4runASuW1+926bhr7D25GJm0Y41DFncyO/oIVkfz+xCRSer2ia8ni/ogvytB72gZaDhy
         gqiw==
X-Gm-Message-State: AOAM531N6roUe2dMC1wiaURggIjsTHuWOiVPcv+QlzX3VvwFCEkjcvYk
        S0zjfb7kTHRtmylXyfiCaiI=
X-Google-Smtp-Source: ABdhPJzja1YvgQANCb3NHskptQhcPJ2aCYu7SRvTxOGJTCRnFCOq+irWeDpyPVkPpNFgfOvvnZ+Jbw==
X-Received: by 2002:a17:906:b7d7:: with SMTP id fy23mr863618ejb.49.1623349087474;
        Thu, 10 Jun 2021 11:18:07 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id p5sm1278266ejm.115.2021.06.10.11.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:18:04 -0700 (PDT)
Date:   Thu, 10 Jun 2021 21:18:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 4/9] net: phy: micrel: apply resume errata
 workaround for ksz8873 and ksz8863
Message-ID: <20210610181803.cnfwrqh2lorwqlbp@skbuf>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-5-o.rempel@pengutronix.de>
 <20210526224329.raaxr6b2s2uid4dw@skbuf>
 <20210610114920.w5xyijxe62svzdfp@pengutronix.de>
 <20210610130445.l5iiswxpzpez25cv@skbuf>
 <20210610132505.wgv6454sfahqmd27@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610132505.wgv6454sfahqmd27@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 03:25:05PM +0200, Oleksij Rempel wrote:
> Yes, this issue was seen  at some early point of development (back in 2019)
> reproducible on system start. Where switch was in some default state or
> on a state configured by the bootloader. I didn't tried to reproduce it
> now. With other words, there is no need to provide global power
> management by the DSA driver to trigger it.

If you're sure about that then add it to the commit message or comments,
since this is not what the ERR description says.
