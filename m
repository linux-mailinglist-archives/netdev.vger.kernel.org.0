Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA820D888B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 08:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbfJPGTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 02:19:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46015 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfJPGTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 02:19:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so26451034wrm.12
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=YRhrTB62D4V/UFoC3f7Dy9VxNzwea0kYw4JJIDyNnSU=;
        b=gffNxPX59uLp8d/gUW5M7E6+ht3fLmLfSJgrgYUe1tI7Afeyq6CzJQ+74I6+AmU/z/
         LCxua/tgSJOllX2PjdMVZeJvnP0ag9dr/fxDqwqp/VddGOOGCVTOTcUt0EU2EnzWOTqU
         RxXnz4wgoSk81+fFaU14kCZSCs3zePHw0unCHMU0JPUBY5lIPVNvqiZnZ04YBtvQKgDQ
         HpdVT8WRcKE9oDhNiAVcKWTT0LS3Yqc1Ultg55vUfNYknQMR/m9KWI0GKJlDKkLdc9rj
         OdjIf4UnX2hBqQMJACFydhYY7OgZIs841Bu3TJXMwsNzfUGHuD6/H97Ls+FNG+P7MyTQ
         zYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YRhrTB62D4V/UFoC3f7Dy9VxNzwea0kYw4JJIDyNnSU=;
        b=pSLmOb2pwNKSUaf/VryWMPAxWYNxHi838J8mlzBVqnY3ZHjmGf1d9yXchaXBgcdjy/
         OhKVfjj82GP0NS0t7pljV2hL2am0NBVBz/PXRBFMhM2SdqZaJpOoa5QkOIc/sjjqXG6w
         s2Lg3r4bnNY4bCHZXuh2KvckQvhjQxN5GcNdWgcnVPu9QlU5yFq2EBnxTwYQaGNF1Q6U
         UATr3t1RJZXwxf58mY+I8L0L9hGwA2PufDcF82X+IzLG4NjfOi2VrunZfWDTM4EpqevX
         /Q/r0XEo9tjr87y1r7NCzGI9+XJbb5Zjd88tt7X3YoGQyRBG/t3ObCyrl7lmpocSzNlP
         SKYw==
X-Gm-Message-State: APjAAAXDc510aIuoibeQeGCDMfOSR2U5J4G2b4wwt+vr8KXoCpd9ZOXR
        hPfvBSGol2oh/fVv4m4UUNuGMA==
X-Google-Smtp-Source: APXvYqyKm24zfNyAXdbf8pS+DsTWKRvLuNz2vGQv6C7u2rAu4IGWRBvmbdVbgFvVvDmpGDOwl7yD5w==
X-Received: by 2002:adf:c98b:: with SMTP id f11mr1155362wrh.274.1571206738605;
        Tue, 15 Oct 2019 23:18:58 -0700 (PDT)
Received: from dell ([95.149.164.86])
        by smtp.gmail.com with ESMTPSA id a3sm3004392wmc.3.2019.10.15.23.18.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Oct 2019 23:18:57 -0700 (PDT)
Date:   Wed, 16 Oct 2019 07:18:56 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v10 4/6] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20191016061856.GA4365@dell>
References: <20191015120953.2597-1-tbogendoerfer@suse.de>
 <20191015120953.2597-5-tbogendoerfer@suse.de>
 <20191015122349.612a230b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191015122349.612a230b@cakuba.netronome.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019, Jakub Kicinski wrote:

> On Tue, 15 Oct 2019 14:09:49 +0200, Thomas Bogendoerfer wrote:
> > SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> > It also supports connecting a SuperIO chip for serial and parallel
> > interfaces. IOC3 is used inside various SGI systemboards and add-on
> > cards with different equipped external interfaces.
> > 
> > Support for ethernet and serial interfaces were implemented inside
> > the network driver. This patchset moves out the not network related
> > parts to a new MFD driver, which takes care of card detection,
> > setup of platform devices and interrupt distribution for the subdevices.
> > 
> > Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> 
> Looks good, I think.

Is that a Reviewed-by?

If so, it doesn't sound like a very convincing one?

If not, it's probably not worth replying at all.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
