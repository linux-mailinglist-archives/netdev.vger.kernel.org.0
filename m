Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B77940438A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 04:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349967AbhIICV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 22:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348853AbhIICVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 22:21:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2293AC061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 19:20:47 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d17so82472plr.12
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 19:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IAfEpqoGn5FhStESKZaKaDUjCrQlR5OZFuiaBUrglls=;
        b=jJmJTCtfPAKF991YiwhZ2iuFcRvrCaPxQ1lZfOk1extXuMMmVAhSL90s/OVbdW8Sxn
         DhrNhzgi4cKOEUCONL3oi4UGm3kjzozY07CHS+4zQlFwCOf2mshbsVeL5swtaFYTPNFW
         upX559upPQOsY09pAoXcsyBWBCJG8h9hzOFcIoAA9BX14BVYj5IMQwhJ+8KZMRyXuhLB
         kUWSGt1gZuXwPLj3r+J6rdUga3MJL5NhGRF4+Db74BIOuWdodfGhpjnw224u+rC99ypI
         8vL/bIR3o/qXf/SDkQGIfCAEk+mRX6atIqo0Dvv9QY0ULM3rhRg/Ur8tMuTG/gOOfj0B
         FjFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IAfEpqoGn5FhStESKZaKaDUjCrQlR5OZFuiaBUrglls=;
        b=UFHCGW4YugkcuoSpjuKu93NY5h7pYVcS+YlJ13x74Qe7MT+1paPHNmptY3Ue1Sp7rt
         K+Rnu02RPX+HN1lUnJJHbCViokrzr9c9qJzPF7vCS9+z1gDhP7P79/GZUaNJ3PTFezYF
         erooMR1FUKeU1wvRaYTZDyWwUIl2gMuzJNWb/ImHhR0fiehs96XWczHwaF9I0QtCtmHl
         2CR3VQ/TOYiu9hhTdkDq7iFGI/my4KaDGq+J80IEdZ1PxF+0/O7VKs7WjrqYsqFY8drN
         I+d3j4RoB0az9CzUkuXTWCoDRglcdQEgODbqv12/jvcDrCwBfpFnBFU4RxsFp5MuUjoE
         ZnLA==
X-Gm-Message-State: AOAM531S8gqrT6aCMIK7RZAvnxOg2pG5kguk4bqx49cp72oT9KCefciU
        +cXF4gx2Y9b4xbnJKNUjp0rrSg==
X-Google-Smtp-Source: ABdhPJwYF4Xh93yfTGLpHTHkwGPubew671yHD4XOKaor4DCc/1m70ThjbGoaTcW7EHsW5Ds41hu40w==
X-Received: by 2002:a17:902:778a:b0:13a:bfd:94ed with SMTP id o10-20020a170902778a00b0013a0bfd94edmr511368pll.24.1631154046606;
        Wed, 08 Sep 2021 19:20:46 -0700 (PDT)
Received: from dragon (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id v25sm183290pfm.202.2021.09.08.19.20.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Sep 2021 19:20:45 -0700 (PDT)
Date:   Thu, 9 Sep 2021 10:20:37 +0800
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Soeren Moch <smoch@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Subject: Re: [BUG] Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev
 as fallback
Message-ID: <20210909022033.GC25255@dragon>
References: <20210425110200.3050-1-shawn.guo@linaro.org>
 <cb7ac252-3356-8ef7-fcf9-eb017f5f161f@web.de>
 <20210908010057.GB25255@dragon>
 <100f5bef-936c-43f1-9b3e-a477a0640d84@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <100f5bef-936c-43f1-9b3e-a477a0640d84@web.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 07:08:06AM +0200, Soeren Moch wrote:
> Hi Shawn,
> 
> On 08.09.21 03:00, Shawn Guo wrote:
> > Hi Soeren,
> >
> > On Tue, Sep 07, 2021 at 09:22:52PM +0200, Soeren Moch wrote:
> >> On 25.04.21 13:02, Shawn Guo wrote:
> >>> Instead of aborting country code setup in firmware, use ISO3166 country
> >>> code and 0 rev as fallback, when country_codes mapping table is not
> >>> configured.  This fallback saves the country_codes table setup for recent
> >>> brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
> >>> revision number.
> >> This patch breaks wireless support on RockPro64. At least the access
> >> point is not usable, station mode not tested.
> >>
> >> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4359/9 wl0: Mar  6 2017
> >> 10:16:06 version 9.87.51.7 (r686312) FWID 01-4dcc75d9
> >>
> >> Reverting this patch makes the access point show up again with linux-5.14 .
> > Sorry for breaking your device!
> >
> > So it sounds like you do not have country_codes configured for your
> > BCM4359/9 device, while it needs particular `rev` setup for the ccode
> > you are testing with.  It was "working" likely because you have a static
> > `ccode` and `regrev` setting in nvram file.
> It always has been a mystery to me how country codes are configured for
> this device. Before I read your patch I did not even know that a
> translation table is required. Is there some documentation how this is
> supposed to work? Not sure if this makes a difference, BCM4359/9 is a
> Cypress device I think, I added mainline support for it some time ago.

One way to add the translation table is using DT.  You can find more
info and example in following commits:

b41936227078 ("dt-bindings: bcm4329-fmac: add optional brcm,ccode-map")
1a3ac5c651a0 ("brcmfmac: support parse country code map from DT")

> 
> I have installed different firmware files, brcmfmac4359-sdio.clm_blob,
> brcmfmac4359-sdio.bin, brcmfmac4359-sdio.txt, the latter also linked as
> brcmfmac4359-sdio.pine64,rockpro64-2.1.txt. This probably is the nvram
> file. ccode and regrev are set to zero, which probably means
> 'international save settings".

I'm not sure how this 'international save settings' works for brcmfmac
devices.  Do you have more info or any pointers?

> > But roaming to a different
> > region will mostly get you a broken WiFi support.  Is it possible to set
> > up the country_codes for your device to get it work properly?
> In linux-5.13 it worked, probably with save settings (not all channels
> selectable, limited tx power), with linux-5.14 it stopped working, so it
> is a regression.
> I personally would like to learn how all this is configured properly.
> For general use I think save settings are better than no wifi at all
> with this patch. This fallback to ISO CC seams to work with newer
> (Synaptics?) devices only.

I do not mind you send a reverting if you have problem to add a proper
translation table for your device.  But that would mean I have to add
a pretty "meaningless" translation table for my devices :(

Shawn
