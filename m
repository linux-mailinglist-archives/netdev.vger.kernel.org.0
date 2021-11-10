Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CC644C1F9
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhKJNSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhKJNSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:18:32 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C6CC061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 05:15:44 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f8so10467383edy.4
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 05:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=0EtuIP7Rz82KP0kqJvXeoOTwVIddivBzcmX8C6k0OYQ=;
        b=O1e8IV+gz7i+dJJdgzBJGFXA4NwG8HVUbcdXRGmVCfgeQz+YnsLEeaEX747CXIQw03
         833Z4rXoTQ56us6uo83hkU0lqRGsot4bmZSnCVFx0YtozGFm2K1Iy+FYhRFj+ikBvUpJ
         /7R4qZmg59ZmoMzDoVWLx+vBqj0dAfK+1ffL5imZiuDpOH/JQo0VamgbeSlKBpAdcCPh
         01phpHG+o9gyPM3AMJmUu2LIyr6kFvoBACsHuZlcOn1OIdSAyJNH3sYdz3P2rwJO/W86
         9TXGCWxEMt4mZz1XMr1AfRKJIND+JLKXaY7Us7cd/XbwJgiFUT9pUOMhJmSgfqO41D1i
         +msg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0EtuIP7Rz82KP0kqJvXeoOTwVIddivBzcmX8C6k0OYQ=;
        b=yudlk5qBuy3XKjr3VyQT2v7rj1lMuQhyJ1x3ZwxWUa7lRLZEVtT1F1FgUIfKWNy9MS
         SCpvotlCGQdBLj66o/srSQfj/QiHNBI2bg8zE9RBROL6SB9KOs5CHEDrMITTYA0vYEUu
         N1lLWHp/aCoD+agHDd8NBV4iRKdmWgNfW+VEFzIsPKFRrnjc5C2kcPnahIhSHVgIirgm
         tgaLa4n4yi+B1UYuLKQtnFIIwTkvpeDA0MsWcEan+L5CeUbTb9L74NFZ5NOU4QkQhVea
         skUNlb+IWSheWqDJcbq/cM1ew+VNXufpNGayaF1nSN87WeIH7/GwywY+xaI6TZEVx0s4
         KYxw==
X-Gm-Message-State: AOAM532vrAhAnIBBRevqKcdGO8p01J0hXW5FdTFWHRaI89U7ycDvHrMH
        EMGFZS5CSe3tujWjvE6yaLU=
X-Google-Smtp-Source: ABdhPJxDSu1RPopYWr4fNQbu8qMG8UNnRGgK9y7fLbsnqJhu0IwCegCcx/FIIZ5jLKmVVGuJNiTaTQ==
X-Received: by 2002:a05:6402:34d0:: with SMTP id w16mr20911607edc.360.1636550143193;
        Wed, 10 Nov 2021 05:15:43 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id g21sm12900066edw.86.2021.11.10.05.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 05:15:42 -0800 (PST)
Date:   Wed, 10 Nov 2021 15:15:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next] net: dsa: Some cleanups in remove code
Message-ID: <20211110131540.qxxeczi5vtzs277f@skbuf>
References: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
 <20211109115434.oejplrd7rzmvad34@skbuf>
 <20211109175055.46rytrdejv56hkxv@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109175055.46rytrdejv56hkxv@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 06:50:55PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> Cc += gregkh, maybe he has something to say on this matter
> 
> On Tue, Nov 09, 2021 at 01:54:34PM +0200, Vladimir Oltean wrote:
> > Your commit prefix does not reflect the fact that you are touching the
> > vsc73xx driver. Try "net: dsa: vsc73xx: ".
> 
> Oh, I missed that indeed.
> 
> > On Tue, Nov 09, 2021 at 12:39:21PM +0100, Uwe Kleine-König wrote:
> > > vsc73xx_remove() returns zero unconditionally and no caller checks the
> > > returned value. So convert the function to return no value.
> > 
> > This I agree with.
> > 
> > > For both the platform and the spi variant ..._get_drvdata() will never
> > > return NULL in .remove() because the remove callback is only called after
> > > the probe callback returned successfully and in this case driver data was
> > > set to a non-NULL value.
> > 
> > Have you read the commit message of 0650bf52b31f ("net: dsa: be
> > compatible with masters which unregister on shutdown")?
> 
> No. But I did now. I consider it very surprising that .shutdown() calls
> the .remove() callback and would recommend to not do this. The commit
> log seems to prove this being difficult.

Why do you consider it surprising?

Many drivers implement ->shutdown by calling ->remove for the simple
reason that ->remove provides for a well-tested code path already, and
leaves the hardware in a known state, workable for kexec and others.

Many drivers have buses beneath them. Those buses go away when these
drivers unregister, and so do their children.

==============================================

=> some drivers do both => children of these buses should expect to be
potentially unregistered after they've been shut down.

> > To remove the check for dev_get_drvdata == NULL in ->remove, you need to
> > prove that ->remove will never be called after ->shutdown. For platform
> > devices this is pretty easy to prove, for SPI devices not so much.
> > I intentionally kept the code structure the same because code gets
> > copied around a lot, it is easy to copy from the wrong place.
> 
> Alternatively remove spi_set_drvdata(spi, NULL); from
> vsc73xx_spi_shutdown()?

What is the end goal exactly?

> Also I'm not aware how platform devices are
> different to spi devices that the ordering of .remove and shutdown() is
> more or less obvious than on the other bus?!

Not sure what you mean. See the explanation above. For the "platform"
bus, there simply isn't any code path that unregisters children on the
->shutdown callback. For other buses, there is.

> > > Also setting driver data to NULL is not necessary, this is already done
> > > in the driver core in __device_release_driver(), so drop this from the
> > > remove callback, too.
> > 
> > And this was also intentional, for visibility more or less. I would like
> > you to ack that you understand the problems surrounding ->remove/->shutdown
> > ordering for devices on buses, prior to making seemingly trivial cleanups.
> 
> I see that the change is not so obviously correct as I thought. I'll
> have to think about this and will respin if and when I find a sane way
> forward.

A way forward towards what? This is literally a cosmetic patch that
would happen to break some stuff, were it to be applied.
