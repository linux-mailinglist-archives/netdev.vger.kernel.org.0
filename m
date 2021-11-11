Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3D644D540
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 11:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhKKKt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 05:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhKKKtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 05:49:53 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7552BC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 02:47:04 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c8so22106106ede.13
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 02:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EiX4KEJ3TIoWxNnEZGvcmrEMHCuGYaQQgNezgzcHhuo=;
        b=PkFdkkxzFfWeDVKyffB+G9w2pso9lrdfGtIEO6ZRvkehBD6WJJXAjLAyLw00tdQFtx
         Y2h3uKyQqY74EUfSyh0lYteqUSOwkvH1EGbr0iRhh4br8mptoEiaq1U3iPoqz4EOzQbN
         qS4fnrRWk1VTquOYAigA/ZNhmAVUNyyfUa0Du6kxMMbEyGmyG7kb610/9BcOKts1w7/Q
         4ubj+aoJoU2pF1kxGyOGBAEAK/ohFn3WbtLVoSv9IOmVC7hbcLAju24lsN+RF6rEFf2O
         hykvPxQn9dnw45wrdSDZICPCfCu52ThcnTFdYdQgLX+ppe6sdG0tqRmOW5X5xe3Rsv5R
         Ll3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EiX4KEJ3TIoWxNnEZGvcmrEMHCuGYaQQgNezgzcHhuo=;
        b=r7mCR2UPGJRzotsofbYroqkn6DVx0TQv7nVGFB7N0U3E30c2DkB+5aD/qyZYeNbSm7
         Sk+R+P06W+1dEciFwq1hL1c5Lbyrt2BBF7wXZ6xfhx6FQEMVeuwzd6TnvyvoNJU6CP/q
         NnzNnBsQugCKmR9Zu4vWDA3FhmO5oo1grpsjBV3E/DBhXN8NWgcN7toecf7j8j31ycBb
         2EEr89PSrQgdJHH8An0Po6DcpMGJGIF5UK0/Vn/cC+q5duNLC29XOHzW4tk9ENyejiCA
         yYCP2Nd9CzjD8E+4gbR3FQhtMXooRSfEKTnzKZFsYxvX/LDIbxsfpdKZkX62UO+ZAjix
         fCwQ==
X-Gm-Message-State: AOAM5339y9/puMwuD/vaB2Vzm7rRTUAooiIz1soue6eNPUhV3XOLqeej
        bLxXXaLjcDdu3VaFB3uYSI08HAat7vw=
X-Google-Smtp-Source: ABdhPJy8BE9ycIIddCIIOLShd8Xa2CL+7hNoXWhIo/oZ9gWAWS/uL92BZRM85xD74K1/F9v5INAEVw==
X-Received: by 2002:a17:907:6291:: with SMTP id nd17mr8241530ejc.194.1636627622857;
        Thu, 11 Nov 2021 02:47:02 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id hx14sm1095464ejc.92.2021.11.11.02.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 02:47:02 -0800 (PST)
Date:   Thu, 11 Nov 2021 12:47:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Some cleanups in remove code
Message-ID: <20211111104701.uzqte6kczfoj57e6@skbuf>
References: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
 <20211109115434.oejplrd7rzmvad34@skbuf>
 <20211109175055.46rytrdejv56hkxv@pengutronix.de>
 <20211110131540.qxxeczi5vtzs277f@skbuf>
 <20211110210346.qthmuarwbuajpcp2@pengutronix.de>
 <20211110225611.h6klnoscntufdsv3@skbuf>
 <20211111075754.wnwtcfun3hjthh4v@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211111075754.wnwtcfun3hjthh4v@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 08:57:54AM +0100, Uwe Kleine-König wrote:
> Hello Vladimir,
> 
> On Thu, Nov 11, 2021 at 12:56:11AM +0200, Vladimir Oltean wrote:
> > On Wed, Nov 10, 2021 at 10:03:46PM +0100, Uwe Kleine-König wrote:
> > > Hello Vladimir,
> > > 
> > > On Wed, Nov 10, 2021 at 03:15:40PM +0200, Vladimir Oltean wrote:
> > > > On Tue, Nov 09, 2021 at 06:50:55PM +0100, Uwe Kleine-König wrote:
> > > > > On Tue, Nov 09, 2021 at 01:54:34PM +0200, Vladimir Oltean wrote:
> > > > > > Your commit prefix does not reflect the fact that you are touching the
> > > > > > vsc73xx driver. Try "net: dsa: vsc73xx: ".
> > > > > 
> > > > > Oh, I missed that indeed.
> > > > > 
> > > > > > On Tue, Nov 09, 2021 at 12:39:21PM +0100, Uwe Kleine-König wrote:
> > > > > > > vsc73xx_remove() returns zero unconditionally and no caller checks the
> > > > > > > returned value. So convert the function to return no value.
> > > > > > 
> > > > > > This I agree with.
> > > > > > 
> > > > > > > For both the platform and the spi variant ..._get_drvdata() will never
> > > > > > > return NULL in .remove() because the remove callback is only called after
> > > > > > > the probe callback returned successfully and in this case driver data was
> > > > > > > set to a non-NULL value.
> > > > > > 
> > > > > > Have you read the commit message of 0650bf52b31f ("net: dsa: be
> > > > > > compatible with masters which unregister on shutdown")?
> > > > > 
> > > > > No. But I did now. I consider it very surprising that .shutdown() calls
> > > > > the .remove() callback and would recommend to not do this. The commit
> > > > > log seems to prove this being difficult.
> > > > 
> > > > Why do you consider it surprising?
> > > 
> > > In my book .shutdown should be minimal and just silence the device, such
> > > that it e.g. doesn't do any DMA any more.
> > 
> > To me, the more important thing to consider is that many drivers lack
> > any ->shutdown hook at all, and making their ->shutdown simply call
> > ->remove is often times the least-effort path of doing something
> > reasonable towards quiescing the hardware. Not to mention the lesser
> > evil compared to not having a ->shutdown at all.
> > 
> > That's not to say I am not in favor of a minimal shutdown procedure if
> > possible. Notice how DSA has dsa_switch_shutdown() vs dsa_unregister_switch().
> > But judging what should go into dsa_switch_shutdown() was definitely not
> > simple and there might still be corner cases that I missed - although it
> > works for now, knock on wood.
> > 
> > The reality is that you'll have a very hard time convincing people to
> > write a dedicated code path for shutdown, if you can convince them to
> > write one at all. They wouldn't even know if it does all the right
> > things - it's not like you kexec every day (unless you're using Linux as
> > a bootloader - but then again, if you do that you're kind of asking for
> > trouble - the reason why this is the case is exactly because not having
> > a ->shutdown hook implemented by drivers is an option, and the driver
> > core doesn't e.g. fall back to calling the ->remove method, even with
> > all the insanity that might ensue).
> 
> Maybe I'm missing an important point here, but I thought it to be fine
> for most drivers not to have a .shutdown hook.

Depends on what you mean by "most drivers". One other case of definitely
problematic things that ->shutdown must take care of are shared interrupts.
I don't have a metric at hand, but there are definitely not few drivers
which support IRQF_SHARED. Some of those don't implement ->shutdown.
What I'm saying is that it would definitely go a long way for the
problems caused by these to be solved in one fell swoop by having some
logic to fall back to the ->remove path.

> > > > Many drivers implement ->shutdown by calling ->remove for the simple
> > > > reason that ->remove provides for a well-tested code path already, and
> > > > leaves the hardware in a known state, workable for kexec and others.
> > > > 
> > > > Many drivers have buses beneath them. Those buses go away when these
> > > > drivers unregister, and so do their children.
> > > > 
> > > > ==============================================
> > > > 
> > > > => some drivers do both => children of these buses should expect to be
> > > > potentially unregistered after they've been shut down.
> > > 
> > > Do you know this happens, or do you "only" fear it might happen?
> > 
> > Are you asking whether there are SPI controllers that implement
> > ->shutdown as ->remove?
> 
> No I ask if it happens a lot / sometimes / ever that a driver's remove
> callback is run for a device that was already shut down.

So if a SPI device is connected to one of the 3 SPI controllers
mentioned by me below, it happens with 100% reproduction rate. Otherwise
it happens with 0% reproduction rate. But you don't write a SPI device
driver to work with just one SPI controller, ideally you write it to
work with all.

> > Just search for "\.shutdown" in drivers/spi.
> > 3 out of 3 implementations call ->remove.
> > 
> > If you really have time to waste, here, have fun: Lino Sanfilippo had
> > not one, but two (!!!) reboot problems with his ksz9897 Ethernet switch
> > connected to a Raspberry Pi, both of which were due to other drivers
> > implementing their ->shutdown as ->remove. First driver was the DSA
> > master/host port (bcmgenet), the other was the bcm2835_spi controller.
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210912120932.993440-1-vladimir.oltean@nxp.com/
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210917133436.553995-1-vladimir.oltean@nxp.com/
> > As soon as we implemented ->shutdown in DSA drivers (which we had mostly
> > not done up until that thread) we ran into the surprise that ->remove
> > will get called too. Yay. It wasn't trivial to sort out, but we did it
> > eventually in a more systematic way. Not sure whether there's anything
> > to change at the drivers/base/ level.
> 
> What I wonder is: There are drivers that call .remove from .shutdown. Is
> the right action to make other parts of the kernel robust with this
> behaviour, or should the drivers changed to not call .remove from
> .shutdown?
> 
> IMHO this is a question of promises of/expectations against the core
> device layer. It must be known if for a shut down device there is (and
> should be) a possibility that .remove is called. Depending on that
> device drivers must be ready for this to happen, or can rely on it not
> to happen.
> 
> From a global maintenance POV it would be good if it could not happen,
> because then the complexity is concentrated to a small place (i.e. the
> driver core, or maybe generic code in all subsystems) instead of making
> each and every driver robust to this possible event that a considerable
> part of the driver writers isn't aware of.

IMO, if you can not offer a solid promise but merely a fragile one, then
it is always better to be robust (which DSA now is). How would you
propose that this particular promise could be fulfilled? Simply patch
the known offending drivers today and hope more drivers won't do this in
the future? Patching the device core to keep track of which devices
were shut down, so as to not call into their ->remove method?
Mind you, this issue was reported as a bug and had to be dealt with
locally, for stable kernels, so changing the driver core was not an
option.
