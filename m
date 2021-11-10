Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8583044CD31
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhKJW7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbhKJW7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 17:59:03 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AD4C061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 14:56:14 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id m14so16961997edd.0
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 14:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4jRxanXgQzQ5igqGpeGx+JXJZsyeujamIzNlQg9Y/jk=;
        b=C7daTmhJd85eDxYpdXYtmFISSPoVNBTwzf+3bU11xV1Pf9VFi457wQMKQmxHfQZnOT
         JLOSw81U9owICgviPDHZD+u+eGaE9MLoB/HG0W9Ad/ZAPLoUjQfpPmVduP2n4gVa9SVs
         +IIKVP+bQ/5R3P6EShCgL2oom1XL1QcJgtMmARlj++zssz5Ye1wDrPybbtcdFZ9GrGpB
         g1zLS74VNuQ7UntEYUat5KOd5DoCWMrsoZMQwl3Sae2NW4XNmSRCp5zrnn57/rtrqQz6
         b5ZJ5byA2sx/s+Gc9rPiYvRRemAno8c76PMBrIIU++jhDkN4ZKjXYiPv6/qlKfqN59dY
         v4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4jRxanXgQzQ5igqGpeGx+JXJZsyeujamIzNlQg9Y/jk=;
        b=XkP1Ho68vXgISfs5ztvq7sb8WtQCU3muhKbARvZYds6nG9nJ+VxT0oZH2o0coDTVH3
         mPQqhs+4v6hHKDjeFolHG22XmgSeaQasmLRGW2cVEcyVqBxIwGj/Y848BfzK3CDVgLbx
         7WiJus+vKTKV8TmZiJm83Jj42ys1UpI+Km4RMG7jVYOtx6/1agpu6wcqKg3KpkLPleha
         FGJw/8Wbmu8EN5XAn1+mBtXe6nZl4Uy1kHajiXTwTpbLrKSe6H81GWXZqB2EawumoCgh
         /hu5S6ieBjHxSEzaCy/fpxukkV/sHiAuQ8i7GbGPZ3R5KN8mjrgtPurWV5HMhz5jYQks
         loWw==
X-Gm-Message-State: AOAM531XjMcdkkSBYhyEETZGZQ6qZJjat11Rxla14pPpB2A52C1Zi9WS
        oFny6N59NmbmU5v4JPXxRDc=
X-Google-Smtp-Source: ABdhPJwUlZa/jJ9LqvlOoj9mw8YRNTNjqq7zF36VCVHH9BIW0rbe7rfEzEfJ7/pArMLXjx35Qon9OQ==
X-Received: by 2002:a50:f18c:: with SMTP id x12mr3415293edl.357.1636584973143;
        Wed, 10 Nov 2021 14:56:13 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id b11sm595673ede.52.2021.11.10.14.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 14:56:12 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:56:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: dsa: Some cleanups in remove code
Message-ID: <20211110225611.h6klnoscntufdsv3@skbuf>
References: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
 <20211109115434.oejplrd7rzmvad34@skbuf>
 <20211109175055.46rytrdejv56hkxv@pengutronix.de>
 <20211110131540.qxxeczi5vtzs277f@skbuf>
 <20211110210346.qthmuarwbuajpcp2@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211110210346.qthmuarwbuajpcp2@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 10:03:46PM +0100, Uwe Kleine-König wrote:
> Hello Vladimir,
> 
> On Wed, Nov 10, 2021 at 03:15:40PM +0200, Vladimir Oltean wrote:
> > On Tue, Nov 09, 2021 at 06:50:55PM +0100, Uwe Kleine-König wrote:
> > > On Tue, Nov 09, 2021 at 01:54:34PM +0200, Vladimir Oltean wrote:
> > > > Your commit prefix does not reflect the fact that you are touching the
> > > > vsc73xx driver. Try "net: dsa: vsc73xx: ".
> > > 
> > > Oh, I missed that indeed.
> > > 
> > > > On Tue, Nov 09, 2021 at 12:39:21PM +0100, Uwe Kleine-König wrote:
> > > > > vsc73xx_remove() returns zero unconditionally and no caller checks the
> > > > > returned value. So convert the function to return no value.
> > > > 
> > > > This I agree with.
> > > > 
> > > > > For both the platform and the spi variant ..._get_drvdata() will never
> > > > > return NULL in .remove() because the remove callback is only called after
> > > > > the probe callback returned successfully and in this case driver data was
> > > > > set to a non-NULL value.
> > > > 
> > > > Have you read the commit message of 0650bf52b31f ("net: dsa: be
> > > > compatible with masters which unregister on shutdown")?
> > > 
> > > No. But I did now. I consider it very surprising that .shutdown() calls
> > > the .remove() callback and would recommend to not do this. The commit
> > > log seems to prove this being difficult.
> > 
> > Why do you consider it surprising?
> 
> In my book .shutdown should be minimal and just silence the device, such
> that it e.g. doesn't do any DMA any more.

To me, the more important thing to consider is that many drivers lack
any ->shutdown hook at all, and making their ->shutdown simply call
->remove is often times the least-effort path of doing something
reasonable towards quiescing the hardware. Not to mention the lesser
evil compared to not having a ->shutdown at all.

That's not to say I am not in favor of a minimal shutdown procedure if
possible. Notice how DSA has dsa_switch_shutdown() vs dsa_unregister_switch().
But judging what should go into dsa_switch_shutdown() was definitely not
simple and there might still be corner cases that I missed - although it
works for now, knock on wood.

The reality is that you'll have a very hard time convincing people to
write a dedicated code path for shutdown, if you can convince them to
write one at all. They wouldn't even know if it does all the right
things - it's not like you kexec every day (unless you're using Linux as
a bootloader - but then again, if you do that you're kind of asking for
trouble - the reason why this is the case is exactly because not having
a ->shutdown hook implemented by drivers is an option, and the driver
core doesn't e.g. fall back to calling the ->remove method, even with
all the insanity that might ensue).

> > Many drivers implement ->shutdown by calling ->remove for the simple
> > reason that ->remove provides for a well-tested code path already, and
> > leaves the hardware in a known state, workable for kexec and others.
> > 
> > Many drivers have buses beneath them. Those buses go away when these
> > drivers unregister, and so do their children.
> > 
> > ==============================================
> > 
> > => some drivers do both => children of these buses should expect to be
> > potentially unregistered after they've been shut down.
> 
> Do you know this happens, or do you "only" fear it might happen?

Are you asking whether there are SPI controllers that implement
->shutdown as ->remove? Just search for "\.shutdown" in drivers/spi.
3 out of 3 implementations call ->remove.

If you really have time to waste, here, have fun: Lino Sanfilippo had
not one, but two (!!!) reboot problems with his ksz9897 Ethernet switch
connected to a Raspberry Pi, both of which were due to other drivers
implementing their ->shutdown as ->remove. First driver was the DSA
master/host port (bcmgenet), the other was the bcm2835_spi controller.
https://patchwork.kernel.org/project/netdevbpf/cover/20210909095324.12978-1-LinoSanfilippo@gmx.de/
https://patchwork.kernel.org/project/netdevbpf/cover/20210912120932.993440-1-vladimir.oltean@nxp.com/
https://patchwork.kernel.org/project/netdevbpf/cover/20210917133436.553995-1-vladimir.oltean@nxp.com/
As soon as we implemented ->shutdown in DSA drivers (which we had mostly
not done up until that thread) we ran into the surprise that ->remove
will get called too. Yay. It wasn't trivial to sort out, but we did it
eventually in a more systematic way. Not sure whether there's anything
to change at the drivers/base/ level.

Since any SPI-controlled DSA switch can fundamentally be connected to
mostly any SPI controller, then yes, I have no doubt at all that the
same can happen even with the vsc73xx driver you're patching here.

> > > > To remove the check for dev_get_drvdata == NULL in ->remove, you need to
> > > > prove that ->remove will never be called after ->shutdown. For platform
> > > > devices this is pretty easy to prove, for SPI devices not so much.
> > > > I intentionally kept the code structure the same because code gets
> > > > copied around a lot, it is easy to copy from the wrong place.
> > > 
> > > Alternatively remove spi_set_drvdata(spi, NULL); from
> > > vsc73xx_spi_shutdown()?
> > 
> > What is the end goal exactly?
> 
> My end goal is:
> 
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index eb7ac8a1e03c..183cf15fbdd2 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -280,7 +280,7 @@ struct spi_message;
>  struct spi_driver {
>         const struct spi_device_id *id_table;
>         int                     (*probe)(struct spi_device *spi);
> -       int                     (*remove)(struct spi_device *spi);
> +       void                    (*remove)(struct spi_device *spi);
>         void                    (*shutdown)(struct spi_device *spi);
>         struct device_driver    driver;
>  };
> 
> As (nearly) all spi drivers must be touched in the same commit, the
> preparing goal is to have these remove callbacks simple, such that I
> only have to replace their "return 0;" by "return;" (or nothing if it's
> at the end of the function). Looking at vsc73xx's remove function I
> didn't stop at this minimal goal and simplified the stuff that I thought
> to be superflous.

Yeah, well I guess you can stop at the minimal goal.

> > > Also I'm not aware how platform devices are
> > > different to spi devices that the ordering of .remove and shutdown() is
> > > more or less obvious than on the other bus?!
> > 
> > Not sure what you mean. See the explanation above. For the "platform"
> > bus, there simply isn't any code path that unregisters children on the
> > ->shutdown callback. For other buses, there is.
> 
> OK, with your last mail I understood that now, thanks.
> 
> Best regards
> Uwe
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | https://www.pengutronix.de/ |
