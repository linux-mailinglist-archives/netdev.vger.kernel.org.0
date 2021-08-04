Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4D63DFF96
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbhHDKqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbhHDKqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:46:50 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141FCC06179A;
        Wed,  4 Aug 2021 03:46:29 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x90so2900503ede.8;
        Wed, 04 Aug 2021 03:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9L3cJVVQelb8mm3bgvaYDE9PsBnoX1UyWVMN0IYtsbg=;
        b=NBny/vMTDTtnR/MqVltdbk8YQBK7UATDXKe4NhF5RHBmiGNczry0Wl0gF8rQjiuRLL
         k6WifVUDx/jrjpK6WOaWudPfD3CV6xS1mJst4fgeP3hjYzok5LzXncx3SH5kifHwjezu
         jXKrg+jzuhkUdA06PfK/0sWoy1HgJ9VnX71UAoy122nmcXLd01DeNMzYkGeg5iZJcZ+w
         1F+9NhTXeEAPoRmZz75MBqHgva4e8uLmXyiS+UtO5DrlztlcG/tspLd4BaIHBKn9EAXt
         3r2kZpFUbUG/GOKZzD8m7kdcJVz7HPi5eMvsI0AtXcPLKCW+xZquaOGNaToI4eQGPsq/
         ivyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9L3cJVVQelb8mm3bgvaYDE9PsBnoX1UyWVMN0IYtsbg=;
        b=dLzq6phhILTyTpg28df4eTxvO2O7O12tCFO/JxlBFDh6uAX3GxUdM+plHWXyAaVauV
         40edASR+VYYAmsP2+7iQl9c415B8LHfr37PSSOqxXm2xWIL+hKDelmxIjQ071ITaZsD1
         YhqoV89Z6TczDsF7XxvPComTQCiIOE89Kspzv6ywLEyL+Sj2chTAVaEsIDcJ1unpuj7b
         ITUHydB7FI9B+84IbYvK344WZFGhgYUKtUVRPUf6IBY4JKvCOsgyiYkLF4iLqCnpogny
         MkbUBuM0zQI3Xj1ynMaeuG/0cAzJHipvdFMmJgkM/HFyjNw+Wuj8TrSYbG6gN/p8Tno/
         IFwg==
X-Gm-Message-State: AOAM532DP+tAN6UDjylq6dvftlapIuguipWAsimyo/NAit1bxbJ5rrY8
        zV9eZt4kK8LmzzsK1ke7lNQ=
X-Google-Smtp-Source: ABdhPJxtqEkqeUbFsR3RS38YsZ6tDI+1xKcJnNcplUtU5+8wbZaFG7McFGCiR8SaUQJVAXT0O/HfSA==
X-Received: by 2002:a05:6402:348c:: with SMTP id v12mr20246029edc.159.1628073987636;
        Wed, 04 Aug 2021 03:46:27 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id i11sm779208edu.97.2021.08.04.03.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 03:46:27 -0700 (PDT)
Date:   Wed, 4 Aug 2021 13:46:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210804104625.d2qw3gr7algzppz5@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
 <20210804095954.GN22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804095954.GN22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 10:59:54AM +0100, Russell King (Oracle) wrote:
> This is why we need to have a clear definition of what the various
> RGMII interface types are, how and where they are applied, and make
> sure everyone sticks to that. We have this documented in
> Documentation/networking/phy.rst.

The problem is that I have no clear migration path for the drivers I
maintain, like sja1105, and I suspect that others might be in the exact
same situation.

Currently, if the sja1105 needs to add internal delays in a MAC-to-MAC
(fixed-link) setup, it does that based on the phy-mode string. So
"rgmii-id" + "fixed-link" means for sja1105 "add RX and TX RGMII
internal delays", even though the documentation now says "the MAC should
not add the RX or TX delays in this case".

There are 2 cases to think about, old driver with new DT blob and new
driver with old DT blob. If breakage is involved, I am not actually very
interested in doing the migration, because even though the interpretation
of the phy-mode string is inconsistent between the phy-handle and fixed-link
case (which was deliberate), at least it currently does all that I need it to.

I am not even clear what is the expected canonical behavior for a MAC
driver. It parses rx-internal-delay-ps and tx-internal-delay-ps, and
then what? It treats all "rgmii*" phy-mode strings identically? Or is it
an error to have "rgmii-rxid" for phy-mode and non-zero rx-internal-delay-ps?
If it is an error, should all MAC drivers check for it? And if it is an
error, does it not make migration even more difficult (adding an
rx-internal-delay-ps property to a MAC OF node which already uses
"rgmii-id" would be preferable to also having to change the "rgmii-id"
to "rgmii", because an old kernel might also need to work with that DT
blob, and that will ignore the new rx-internal-delay-ps property).

Does qca8k_setup_of_rgmii_delay(), a very recent function, even do the
right thing with rx-internal-delay-ps, or is it doing the exact opposite
of the right thing (it applies rx-internal-delay-ps when in rgmii-id or
rgmii-rxid mode).
