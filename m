Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5F255CE40
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239146AbiF0Ruw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiF0Ruv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:50:51 -0400
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F990767A;
        Mon, 27 Jun 2022 10:50:50 -0700 (PDT)
Received: by mail-il1-f171.google.com with SMTP id a16so6533333ilr.6;
        Mon, 27 Jun 2022 10:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JMvotdxdopiZeRt2411RNmh3EgUkyNTiH64o+qllFfk=;
        b=0VT1/m3r2bhQdtpFgOf9s5W4EEhcMapw+0GPLa+Q9mIbcE5Bsq4Fkav7Z2P5B2G7uI
         hqIzvh8+P8HsgiSRKi5VU2Fb1ggEpY1L0OhtIvEO7aJAxaLGHHV3SVqPMRReI3IH4CRM
         tP7hbzhM+ySVsruSSGhCWU6TmUaaXZ/S/+OU+CArDGIEHgSApGe6KXDUop3UWJ7HCDxO
         NI7bOWopt6wVAK48wV7hkrOGZyw6uiY50FRyczxq2nBrNFOyzNooEghEa9fGrOUU81HG
         jachA6AaqUJ7mpYO2F09/Jr8//Qf0j/I0RZcTsbOox1/almbDHVe5GgdDMk/pXqwVZ2F
         +N3Q==
X-Gm-Message-State: AJIora+JxJCLJ0+ECh0OGEtph3WN1CGgAIke5FFrM43HxK7lmqKXiFTz
        SygcHEtmouIp5yAi0TURnQ==
X-Google-Smtp-Source: AGRyM1vMlh69p3t3S82TZu1a3E/OZD68e6gmsrb96DKcUUIvaZw/486niMVTaLeFL863dLlg1DbVCA==
X-Received: by 2002:a92:da4c:0:b0:2d5:4942:151c with SMTP id p12-20020a92da4c000000b002d54942151cmr7774824ilq.54.1656352249605;
        Mon, 27 Jun 2022 10:50:49 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id f9-20020a02a109000000b00339e3a22dbbsm5056008jag.21.2022.06.27.10.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 10:50:49 -0700 (PDT)
Received: (nullmailer pid 2661321 invoked by uid 1000);
        Mon, 27 Jun 2022 17:50:46 -0000
Date:   Mon, 27 Jun 2022 11:50:46 -0600
From:   Rob Herring <robh@kernel.org>
To:     sascha hauer <sha@pengutronix.de>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        russell king <linux@armlinux.org.uk>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when
 fw_devlink.strict=1
Message-ID: <20220627175046.GA2644138-robh@kernel.org>
References: <20220623080344.783549-1-saravanak@google.com>
 <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623100421.GY1615@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 12:04:21PM +0200, sascha hauer wrote:
> On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
> > Commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> > enabled iommus and dmas dependency enforcement by default. On some
> > systems, this caused the console device's probe to get delayed until the
> > deferred_probe_timeout expires.
> > 
> > We need consoles to work as soon as possible, so mark the console device
> > node with FWNODE_FLAG_BEST_EFFORT so that fw_delink knows not to delay
> > the probe of the console device for suppliers without drivers. The
> > driver can then make the decision on where it can probe without those
> > suppliers or defer its probe.
> > 
> > Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> > Reported-by: Sascha Hauer <sha@pengutronix.de>
> > Reported-by: Peng Fan <peng.fan@nxp.com>
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > Tested-by: Peng Fan <peng.fan@nxp.com>
> > ---
> >  drivers/of/base.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index d4f98c8469ed..a19cd0c73644 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1919,6 +1919,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
> >  			of_property_read_string(of_aliases, "stdout", &name);
> >  		if (name)
> >  			of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
> > +		if (of_stdout)
> > +			of_stdout->fwnode.flags |= FWNODE_FLAG_BEST_EFFORT;
> 
> The device given in the stdout-path property doesn't necessarily have to
> be consistent with the console= parameter. The former is usually
> statically set in the device trees contained in the kernel while the
> latter is dynamically set by the bootloader. So if you change the
> console uart in the bootloader then you'll still run into this trap.
> 
> It's problematic to consult only the device tree for dependencies. I
> found several examples of drivers in the tree for which dma support
> is optional. They use it if they can, but continue without it when
> not available. "hwlock" is another property which consider several
> drivers as optional. Also consider SoCs in early upstreaming phases
> when the device tree is merged with "dmas" or "hwlock" properties,
> but the corresponding drivers are not yet upstreamed. It's not nice
> to defer probing of all these devices for a long time.
> 
> I wonder if it wouldn't be a better approach to just probe all devices
> and record the device(node) they are waiting on. Then you know that you
> don't need to probe them again until the device they are waiting for
> is available.

Can't we have a driver flag 'I have optional dependencies' that will 
trigger probe without all dependencies and then the driver can defer 
probe if required dependencies are not yet met.

Rob
