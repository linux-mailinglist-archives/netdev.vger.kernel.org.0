Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280784D2D4A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiCIKnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiCIKmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:42:45 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D2AA0BDC
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 02:41:46 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id r13so3983926ejd.5
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 02:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m4VrXG1u9PSPi29/nnX9W+bO/TRsNh6XDIYIk2mU1Js=;
        b=jXfg3KHiEOvY1F9oec7uwFAPDDwZ1a9yed5s+CV5dezf+LQ48hrfz7kc4NJg/nXd9n
         oXMYmoMSvlYegv3DyTzw21rMv5j5RzvLJ7nUOL1d6+aGp7WcoWfE8kS5l8mN1w7KZC/D
         9w2vvSymrkgxZsTGZotZHFxCgcc+ikT1h15rKt+qbIRmnamc6g6fkCCYIemYPTuk8Jgv
         m5wooof0UBNQA9gXzELsqcI33xQYxxV3Ggjq5P7EpZkJnJV29RnGWre7XeUdQ76ijf3a
         UvJAymozoKqvJm+lCOirH5VTp/DkhG5M2/bEhAdSy7i7Y0d17NVKPIsuVpFsXh4EUr4/
         ZmEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m4VrXG1u9PSPi29/nnX9W+bO/TRsNh6XDIYIk2mU1Js=;
        b=LAWNQPTvm/kHgLEnVLrrXOuSA5QInzZZqCGKX7DplDzN6I/op+mEWQuL3vCb/q5fSL
         5uFQJsbTSiTgDDVZm68+oiQ97XD2Q5k5kn/rB7f65IeVCO4h60gnXea0E2JXVHU9kE8p
         c4bibgEx2wdqjZfo2mWOuu9j+0BMtR2V3MYCzniluXzKDYdPXDi/GEEy8m2LuA2E04kX
         pVMal/Msr3KXLKrzieXMg0cxXHAnblVNMGrDDSPATHqCHMISbpSCbhSoycdfWNI5Cw/G
         DOX/1e8El5Lf1WH4dCIOEx+8M7DlD+P4mBsa/mtCEKWT0okhlM6jNyvPqFSusB/ZOgdX
         PT6Q==
X-Gm-Message-State: AOAM532M9QVQPc6dygHXW2KKR0zpT13Do6/DWKlN/cgwFn/wXY63dU5I
        e2XJzRCqMc/AkNeEUWeMFkSVkcwg3LQ=
X-Google-Smtp-Source: ABdhPJyD7AdSirVWS2UAM8ZvnbZJLDmGZqI2HNy9EridV3MYhVFhEZH3t6hAW6P9aDI5nRxEKijsyg==
X-Received: by 2002:a17:906:b288:b0:6da:825e:a2ee with SMTP id q8-20020a170906b28800b006da825ea2eemr16656277ejz.254.1646822505140;
        Wed, 09 Mar 2022 02:41:45 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id jl2-20020a17090775c200b006dabe8887b8sm573296ejc.21.2022.03.09.02.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 02:41:44 -0800 (PST)
Date:   Wed, 9 Mar 2022 12:41:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net: dsa: silence fdb errors when unsupported
Message-ID: <20220309104143.gmoks5aceq3dtmci@skbuf>
References: <E1nRtfI-00EnmD-I8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nRtfI-00EnmD-I8@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Wed, Mar 09, 2022 at 10:35:32AM +0000, Russell King (Oracle) wrote:
> When booting with a Marvell 88e6xxx switch, the kernel spits out a
> load of:
> 
> [    7.820996] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> [    7.835717] mv88e6085 f1072004.mdio-mii:04: port 2 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> [    7.851090] mv88e6085 f1072004.mdio-mii:04: port 1 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> [    7.968594] mv88e6085 f1072004.mdio-mii:04: port 0 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> [    8.035408] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ3 to fdb: -95
> 
> while the switch is being setup. Comments in the Marvell DSA driver
> indicate that "switchdev expects -EOPNOTSUPP to honor software VLANs"
> in mv88e6xxx_port_db_load_purge() so this error code should not be
> treated as an error.
> 
> Fixes: 3dc80afc5098 ("net: dsa: introduce a separate cross-chip notifier type for host FDBs")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> Hi,
> 
> I noticed these errors booting 5.16 on my Clearfog platforms with a
> Marvell DSA switch. It appears that the switch continues to work
> even though these errors are logged in the kernel log, so this patch
> merely silences the errors, but I'm unsure this is the right thing
> to do.

Can you please confirm that these errors have disappeared on net-next?

> 
>  net/dsa/slave.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 22241afcac81..e8f4a59022a8 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2411,7 +2411,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
>  		else
>  			err = dsa_port_fdb_add(dp, switchdev_work->addr,
>  					       switchdev_work->vid);
> -		if (err) {
> +		if (err && err != -EOPNOTSUPP) {
>  			dev_err(ds->dev,
>  				"port %d failed to add %pM vid %d to fdb: %d\n",
>  				dp->index, switchdev_work->addr,
> @@ -2428,7 +2428,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
>  		else
>  			err = dsa_port_fdb_del(dp, switchdev_work->addr,
>  					       switchdev_work->vid);
> -		if (err) {
> +		if (err && err != -EOPNOTSUPP) {
>  			dev_err(ds->dev,
>  				"port %d failed to delete %pM vid %d from fdb: %d\n",
>  				dp->index, switchdev_work->addr,
> -- 
> 2.30.2
> 

