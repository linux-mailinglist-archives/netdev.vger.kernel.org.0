Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B86122624
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfLQIDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:03:06 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53491 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfLQIDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:03:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id m24so1891349wmc.3
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 00:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=GxAFSM9qrfBqACDVyobZG3sgGdlMNsybGzr6qpdZuFY=;
        b=sneGlw/w17D4z5M6a5bR6Y0d/z3VSpK4ImjvIeXZaztzsV4sKewPmhnDCtmQYaTmlV
         YEqBwbCUZFtj5uIFQsJ21OzjN/E//jv2SfHJwUy/0NR42KPymWIdC/xmAgzf+8A++Yn4
         eEVZOAYagbwnNN9NzZKIXw3wbBs8XCEwEdOFXZ/gi5Rl4atj3f719kXLCGWPV9c7Sacg
         NG3EKXamr8YyxcBkbngr9KLoE066VzOQNwr8QGF5kFyuwBtD9zqKm9xslgq0mwKFt3L3
         gkHo2nde5j/rsRY0YIN9JVN/ebNuqhinr5Ltkp3zVYpUw/SxUBGq1K36V3C2++3LFK2I
         BJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=GxAFSM9qrfBqACDVyobZG3sgGdlMNsybGzr6qpdZuFY=;
        b=ln9q8zM8VkuY/q6W30P6BVlKX1NOgIyyXzxajOmlJZAQW+MXN4r9nUgbBVNt0+wJ/1
         73G7JLRaAxTkc/tO6vs6O3WdalJobpIF+Fr2GiNdjjwuczn1FxQwC6vruhylI4NEWBE9
         50amAmqztLyTAodiMNON+tTWHGbhwGHnq4ZeBxP4/WcW5/vXpH8jruIetItwlLJyfj9O
         2jHEfquFQRExJ0qsxXdNteNJzufKS2UCEYxZhPm/NnpD9nhobCBH+1mKYNBCfM7tZYzt
         1JPvlX/i1VLTFSbGUws6q+oNcMOW0WlrBRsCWmicy1k/L2IRh6cQffSxC2IReDrsPSC8
         mipQ==
X-Gm-Message-State: APjAAAVGLiAwNcHJVbtvh7sHwjuUW7uFR8iYuPbGX2+b0OrUIdUyigZC
        BImkmJ62VTm/lKlEUQSklXEUnQ==
X-Google-Smtp-Source: APXvYqzMTCBlFqbqARJevmlw9QY8QwE36fi/Ore5Eu5RwK95seTip0NwxVQTJa/pqHoFIqktYKfywA==
X-Received: by 2002:a05:600c:d7:: with SMTP id u23mr3568868wmm.145.1576569781740;
        Tue, 17 Dec 2019 00:03:01 -0800 (PST)
Received: from dell (h185-20-99-142.host.redstation.co.uk. [185.20.99.142])
        by smtp.gmail.com with ESMTPSA id c9sm2020290wmc.47.2019.12.17.00.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 00:03:00 -0800 (PST)
Date:   Tue, 17 Dec 2019 08:02:55 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v11 net-next 2/2] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20191217080255.GF18955@dell>
References: <20191213124221.25775-1-tbogendoerfer@suse.de>
 <20191213124221.25775-3-tbogendoerfer@suse.de>
 <20191215122745.219fa951@cakuba.netronome.com>
 <20191216170005.afdbbb3845a87dc835165250@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216170005.afdbbb3845a87dc835165250@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019, Thomas Bogendoerfer wrote:

> On Sun, 15 Dec 2019 12:27:45 -0800
> Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> 
> > On Fri, 13 Dec 2019 13:42:20 +0100, Thomas Bogendoerfer wrote:
> > > SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> > > It also supports connecting a SuperIO chip for serial and parallel
> > > interfaces. IOC3 is used inside various SGI systemboards and add-on
> > > cards with different equipped external interfaces.
> > > 
> > > Support for ethernet and serial interfaces were implemented inside
> > > the network driver. This patchset moves out the not network related
> > > parts to a new MFD driver, which takes care of card detection,
> > > setup of platform devices and interrupt distribution for the subdevices.
> > > 
> > > Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> > > 
> > > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > 
> > For networking:
> > 
> > Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > 
> > I think you wanted this to go via the MIPS tree, so consider this an
> > ack.
> 
> well, it can go to net-next as well. Paul, what's your preference ?

Whomever takes it should send out a pull-request to an immutable
branch for everyone else to pull from (if they so desire).

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
