Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5000A407B43
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 04:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhILBxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 21:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhILBxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 21:53:00 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5696C061574
        for <netdev@vger.kernel.org>; Sat, 11 Sep 2021 18:51:47 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so4048642pjq.1
        for <netdev@vger.kernel.org>; Sat, 11 Sep 2021 18:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=jQaAtvRVJKtD0rkWYmnH2Mzp0TT+CXy5WeRCmpy3Cjc=;
        b=Pa7XEG5ZhyW49C/NTaqJlZVdO4LAPj+Y36D98dcEeINw52obOs6eEa54a65Xip7QHT
         f8Ds0BbD8fyoRFBjDZprvbN48rUimqLYJq5x68A0qKbYjdF4g/vYcAjuT/8Lqk+TIvk+
         v2OBGAFFYlzKyzDWv/jcq+6oHi+yWR21tMoOy/1vq9zARKGpmCFFEdPD+NPMsVS/GCtO
         HhipvywTWQmRPSyFsb0Ef368C+5lJePlVPbN3EWwGBTB62nR9nro9Y4NQGUOGz5fRKXS
         wZh3X8gXtcHDW9p6qqmg8/zor0rPJUIi8XBq/rEOjesEoVBxdmiTCmkHZz/ljjoH4kMz
         A5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=jQaAtvRVJKtD0rkWYmnH2Mzp0TT+CXy5WeRCmpy3Cjc=;
        b=5KsN66m+aOMp9yidy2sizsxO7g1dlS4CXYOIkDD2ezFbaikT8R1Ib77XkprUYOHutX
         tnGhtlxMQQ0Uq9rJb250va/aytuGE283C9oZYy/HLb+Iwt47ExT8PhsKWBzNJ0uYiY7K
         3mrbnw/1xWsRyl0KQUKYZInsFyoxQu4fhc4py2WF/kMURqsJfpTZnQGu3hLRUjN2bYNj
         Fato2RZ8fTTUBIQjRy7en4I6FXpSGV7rAeg7LcSqQMwd93wP5o1I89NfBelO6vAckl2O
         u4SCiLTTkL0wNRNu8Rt597ySBMeE7dicue4RaZ2k7/Maf0axsxiODd5iubWjVQY0hwMG
         K1mA==
X-Gm-Message-State: AOAM531l5aQj6Y1+fJDxvyVnIoPzuz6adPXi5Imrah8Z2uuG12TFtEAW
        03hdaFLoNq/GvwwWFZbIXgMKlw==
X-Google-Smtp-Source: ABdhPJyuJREAJMNh1VtizAwglyDgLrCz2SXYQBlB+8WLKYzOtW1vBCNlIEgc3k7DdACIN2MHqjjQOA==
X-Received: by 2002:a17:902:b18b:b0:13a:354a:3e9d with SMTP id s11-20020a170902b18b00b0013a354a3e9dmr4520692plr.36.1631411507127;
        Sat, 11 Sep 2021 18:51:47 -0700 (PDT)
Received: from dragon (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id i21sm3268321pgn.93.2021.09.11.18.51.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 11 Sep 2021 18:51:46 -0700 (PDT)
Date:   Sun, 12 Sep 2021 09:51:38 +0800
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
Message-ID: <20210912015137.GD25255@dragon>
References: <20210425110200.3050-1-shawn.guo@linaro.org>
 <cb7ac252-3356-8ef7-fcf9-eb017f5f161f@web.de>
 <20210908010057.GB25255@dragon>
 <100f5bef-936c-43f1-9b3e-a477a0640d84@web.de>
 <20210909022033.GC25255@dragon>
 <56e9a81a-4e05-cf5e-a8df-782ac75fdbe6@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56e9a81a-4e05-cf5e-a8df-782ac75fdbe6@web.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 10:39:58AM +0200, Soeren Moch wrote:
> Hi Shawn,
> 
> On 09.09.21 04:20, Shawn Guo wrote:
> > On Wed, Sep 08, 2021 at 07:08:06AM +0200, Soeren Moch wrote:
> >> Hi Shawn,
> >>
> >> On 08.09.21 03:00, Shawn Guo wrote:
> >>> Hi Soeren,
> >>>
> >>> On Tue, Sep 07, 2021 at 09:22:52PM +0200, Soeren Moch wrote:
> >>>> On 25.04.21 13:02, Shawn Guo wrote:
> >>>>> Instead of aborting country code setup in firmware, use ISO3166 country
> >>>>> code and 0 rev as fallback, when country_codes mapping table is not
> >>>>> configured.  This fallback saves the country_codes table setup for recent
> >>>>> brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
> >>>>> revision number.
> >>>> This patch breaks wireless support on RockPro64. At least the access
> >>>> point is not usable, station mode not tested.
> >>>>
> >>>> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4359/9 wl0: Mar  6 2017
> >>>> 10:16:06 version 9.87.51.7 (r686312) FWID 01-4dcc75d9
> >>>>
> >>>> Reverting this patch makes the access point show up again with linux-5.14 .
> >>> Sorry for breaking your device!
> >>>
> >>> So it sounds like you do not have country_codes configured for your
> >>> BCM4359/9 device, while it needs particular `rev` setup for the ccode
> >>> you are testing with.  It was "working" likely because you have a static
> >>> `ccode` and `regrev` setting in nvram file.
> >> It always has been a mystery to me how country codes are configured for
> >> this device. Before I read your patch I did not even know that a
> >> translation table is required. Is there some documentation how this is
> >> supposed to work? Not sure if this makes a difference, BCM4359/9 is a
> >> Cypress device I think, I added mainline support for it some time ago.
> > One way to add the translation table is using DT.  You can find more
> > info and example in following commits:
> >
> > b41936227078 ("dt-bindings: bcm4329-fmac: add optional brcm,ccode-map")
> > 1a3ac5c651a0 ("brcmfmac: support parse country code map from DT")
> OK, thanks.
> When one way is to use DT, what is the 'traditional way' to add such table?

To be honest, I don't know what the 'traditional way' is, because I
haven't seen how `country_codes` is used before I add DT support of it.

> And maybe the more interesting question, where can these settings be
> obtained from? The tweaked device specific settings probably from the
> device vendor, good luck!
> But the general country specific settings, as you are obviously
> interested in with your trivial mapping, shouldn't they go into driver
> directly? Only to be overruled when device specific settings are
> available via DT? And of course only for device/firmware combinations
> that support this general mapping, so that other devices with 'unknown
> mapping' are not broken by this enhancement?

The patch was accepted based on Arend's assumption[1] that every
chipset/firmware include a rev 0 for each country code , but
it's never been officially confirmed.  And from what you report here,
it doesn't seem to stand unfortunately.

[1] https://lore.kernel.org/netdev/17998013ac0.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com/

> >> I have installed different firmware files, brcmfmac4359-sdio.clm_blob,
> >> brcmfmac4359-sdio.bin, brcmfmac4359-sdio.txt, the latter also linked as
> >> brcmfmac4359-sdio.pine64,rockpro64-2.1.txt. This probably is the nvram
> >> file. ccode and regrev are set to zero, which probably means
> >> 'international save settings".
> > I'm not sure how this 'international save settings' works for brcmfmac
> > devices.  Do you have more info or any pointers?
> The correct term in this context probably is 'world regulatory domain',
> the most restrictive wifi settings that can be used all over the world.
> This usually is taken as default by cfg80211, apparently also for
> (some?) brcmfmac devices/firmwares.
> 
> These 'world' settings can be replaced by more permissive country
> specific regulatory domain settings, but for brcmfmac devices this seems
> to be firmware specific and requires this country mapping.
> 
> I have seen a country code "00" for the world regulatory domain in the
> past, not sure if this is standard or a device/driver/software specific
> hack and if this can be used for brcmfmac (mapping from string "00" to
> country_code=0 ?). For sure here are more experienced wifi developers
> who know better.

Yeah, it would be nice if someone can help clarify what both `ccode` and
`regrev` in nvram file being zero means, like what should be working and
what's not.

> >>> But roaming to a different
> >>> region will mostly get you a broken WiFi support.  Is it possible to set
> >>> up the country_codes for your device to get it work properly?
> >> In linux-5.13 it worked, probably with save settings (not all channels
> >> selectable, limited tx power), with linux-5.14 it stopped working, so it
> >> is a regression.
> >> I personally would like to learn how all this is configured properly.
> >> For general use I think save settings are better than no wifi at all
> >> with this patch. This fallback to ISO CC seams to work with newer
> >> (Synaptics?) devices only.
> > I do not mind you send a reverting if you have problem to add a proper
> > translation table for your device.  But that would mean I have to add
> > a pretty "meaningless" translation table for my devices :(
> >
> Is this not the usual DT policy, that missing optional properties should
> not prevent a device to work, that old dtbs should still work when new
> properties are added?
> 
> I'm not sure what's the best way forward. A plain revert of this patch
> would at least bring back wifi support for RockPro64 devices with
> existing dtbs. Maybe someone else has a better proposal how to proceed.

Go ahead to revert if we do not hear a better solution, I would say.

Shawn
