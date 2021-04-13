Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6311335D8D6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbhDMH2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhDMH2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:28:46 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2C6C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:28:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 10so1988365pfl.1
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Th8DLSdO2vvzDGZNvM1EiNQqBiiC+GmcxeXMizucGzE=;
        b=a02KKelz8nmBQ6Q/ZySI9iRYnHg4uPjz1jdtG/Xp+FCAd23bAAOpqIp/6DgFkPlhSq
         prNDwyKTQfxM9SP/k28AdVMDlpz1zCuHF64xyWZpCb1qlH0pRWLZrz4wgLrdnj0u1Sl1
         1/m4Zqc4kZwgo5mBNlyWn0kd67R5A4DCAnTZpYCMbM00aKQLKeafXAF2yY0VDAMv2NkU
         2AHbc1lJ4xvZkmUtGyF5viQAdrork6huoW8zmSwQDUcCJYzFBlwKv3caoaggI71n05Wq
         gB4+e8UxMaJ8sgylOh7jcfe10qmm1SNTE7bizE1n+I8WY5q2wQcgZUQhjIy0+urvRmwP
         5IEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Th8DLSdO2vvzDGZNvM1EiNQqBiiC+GmcxeXMizucGzE=;
        b=MgEOfoSY2qjYXU4z5jzOXcT5gjKZYoNgPHNHNAdxrqThuEe7W45XZ09CKGXk/a5LV+
         Dg/DCucO+jcvTuMfoPn1YX6fB0RzqlYOYSJrud2yLwY0m8uIijtWn/dEDBaJsHusyFQb
         sFU1VABpkKc8NHRvcXbw7m4zXpMb75qG8QppflJAqYWIoEj8qzLVXtDzgcLq0nqmlvFn
         KLf282sU5fpyYApVVxvmP8X2tZROP4jcGfm2p4A3JE7hhFEuZ5XQ+qQBAI7tPapvnGEa
         UgW5gsFyptwbLobVyeYocFlP68WCAXSlMZl2FhQkJPpkTV7WtJOmhK33e3l102ZSY5g4
         JxKw==
X-Gm-Message-State: AOAM531GI68PQF8ssfT+rv1G/QaOGCqsHywohtAP9RWz2HRsQd5i9Ok0
        mk5n04Y3cYL4SOgWP3/vuww86Q==
X-Google-Smtp-Source: ABdhPJyemRNGKQj8Nqb3ZOMz+T1cHVd7ePowMYtFCGLiIg9aIdqYrYZQUwiIkhN0ojT1b9rbJkH2+w==
X-Received: by 2002:a63:2507:: with SMTP id l7mr30951603pgl.198.1618298907404;
        Tue, 13 Apr 2021 00:28:27 -0700 (PDT)
Received: from dragon (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id n21sm1422205pjo.25.2021.04.13.00.28.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Apr 2021 00:28:26 -0700 (PDT)
Date:   Tue, 13 Apr 2021 15:28:19 +0800
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH 1/2] dt-binding: bcm43xx-fmac: add optional brcm,ccode-map
Message-ID: <20210413072818.GC15093@dragon>
References: <20210408113022.18180-1-shawn.guo@linaro.org>
 <20210408113022.18180-2-shawn.guo@linaro.org>
 <87k0p9mewt.fsf@codeaurora.org>
 <20210412012528.GB15093@dragon>
 <87im4rlnuh.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87im4rlnuh.fsf@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 02:54:46PM +0300, Kalle Valo wrote:
> Shawn Guo <shawn.guo@linaro.org> writes:
> 
> > On Sun, Apr 11, 2021 at 10:57:54AM +0300, Kalle Valo wrote:
> >> Shawn Guo <shawn.guo@linaro.org> writes:
> >> 
> >> > Add optional brcm,ccode-map property to support translation from ISO3166
> >> > country code to brcmfmac firmware country code and revision.
> >> >
> >> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> >> > ---
> >> >  .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 7 +++++++
> >> >  1 file changed, 7 insertions(+)
> >> >
> >> > diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> >> > index cffb2d6876e3..a65ac4384c04 100644
> >> > --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> >> > +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> >> > @@ -15,6 +15,12 @@ Optional properties:
> >> >  	When not specified the device will use in-band SDIO interrupts.
> >> >   - interrupt-names : name of the out-of-band interrupt, which must be set
> >> >  	to "host-wake".
> >> > + - brcm,ccode-map : multiple strings for translating ISO3166 country code to
> >> > +	brcmfmac firmware country code and revision.  Each string must be in
> >> > +	format "AA-BB-num" where:
> >> > +	  AA is the ISO3166 country code which must be 2 characters.
> >> > +	  BB is the firmware country code which must be 2 characters.
> >> > +	  num is the revision number which must fit into signed integer.
> >> >  
> >> >  Example:
> >> >  
> >> > @@ -34,5 +40,6 @@ mmc3: mmc@1c12000 {
> >> >  		interrupt-parent = <&pio>;
> >> >  		interrupts = <10 8>; /* PH10 / EINT10 */
> >> >  		interrupt-names = "host-wake";
> >> > +		brcm,ccode-map = "JP-JP-78", "US-Q2-86";
> >> 
> >> The commit log does not answer "Why?". Why this needs to be in device
> >> tree and, for example, not hard coded in the driver?
> >
> > Thanks for the comment, Kalle.  Actually, this is something I need some
> > input from driver maintainers.  I can see this country code mapping
> > table is chipset specific, and can be hard coded in driver per chip id
> > and revision.  But on the other hand, it makes some sense to have this
> > table in device tree, as the country code that need to be supported
> > could be a device specific configuration.
> 
> Could be? Does such a use case exist at the moment or are just guessing
> future needs?

I hope that the patch [1] from Rafał (copied) is one use case.  And
also, the device I'm working on only needs to support some of the
countries in the mapping table. 

> 
> From what I have learned so far I think this kind of data should be in
> the driver, but of course I might be missing something.

I agree with you that such data are chipset specific and should ideally
be in the driver.  However, the brcmfmac driver implementation has been
taking the mapping table from platform_data [2][3], which is a logical
equivalent of DT data in case of booting with device tree.

Shawn

[1] https://gitlab.dai-labor.de/nadim/powquty-coap/-/blob/563b2bd658822375dcfa8e87707304b94de9901c/kernel/mac80211/patches/863-brcmfmac-add-in-driver-tables-with-country-codes.patch
[2] https://elixir.bootlin.com/linux/v5.12-rc7/source/include/linux/platform_data/brcmfmac.h#L154
[3] https://elixir.bootlin.com/linux/v5.12-rc7/source/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c#L433
