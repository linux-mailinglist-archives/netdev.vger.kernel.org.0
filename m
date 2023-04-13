Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9B66E1296
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjDMQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDMQnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:43:49 -0400
Received: from h1.cmg2.smtp.forpsi.com (h1.cmg2.smtp.forpsi.com [81.2.195.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241849026
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:43:44 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id n02wpkHNBv5uIn02xp3ccv; Thu, 13 Apr 2023 18:43:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681404223; bh=tZSnvJh6UjNKzMdhLUO1i7a3iBlxGKgZAfwCnUgid7I=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=Y5AkgfBC+UhDNgXkIhdJ4QocN5rzeUMk1Epc0BRSD9HJP4BBvQeTLfPm/q9FWRY11
         kyNyQyE4BCEn7uqZRSXY2qhH9AirgGAxxc2rQpBVv5dXWJx0gxwyXsRWrJdv4JgG1y
         u8Ot3HFqpDmRueAzCXJqI5sIl4vRNRi2hsaeLvewcgTJ9GPglY8IiwQBtKlKDlEkoh
         bt3lhkkHI2b578sBaglNlVOOWKQjaGgywdkKxgeNIgbq5SousfTpIjiuD6dhYcJghs
         ddpmMJTcljPEw3hbafL5hqb30fq+oBYsbPgfcNJ0NhD4ksRK83yzYpgb7J6U5laBL9
         JcIF7iJAr80AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681404223; bh=tZSnvJh6UjNKzMdhLUO1i7a3iBlxGKgZAfwCnUgid7I=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=Y5AkgfBC+UhDNgXkIhdJ4QocN5rzeUMk1Epc0BRSD9HJP4BBvQeTLfPm/q9FWRY11
         kyNyQyE4BCEn7uqZRSXY2qhH9AirgGAxxc2rQpBVv5dXWJx0gxwyXsRWrJdv4JgG1y
         u8Ot3HFqpDmRueAzCXJqI5sIl4vRNRi2hsaeLvewcgTJ9GPglY8IiwQBtKlKDlEkoh
         bt3lhkkHI2b578sBaglNlVOOWKQjaGgywdkKxgeNIgbq5SousfTpIjiuD6dhYcJghs
         ddpmMJTcljPEw3hbafL5hqb30fq+oBYsbPgfcNJ0NhD4ksRK83yzYpgb7J6U5laBL9
         JcIF7iJAr80AA==
Date:   Thu, 13 Apr 2023 18:43:41 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] staging: octeon: avoid needless device allocation
Message-ID: <ZDgxPet9RIDC9Oz1@lenoch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgOLHw1IkmWVU79@lenoch>
 <543bfbb6-af60-4b5d-abf8-0274ab0b713f@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543bfbb6-af60-4b5d-abf8-0274ab0b713f@lunn.ch>
X-CMAE-Envelope: MS4wfGCrf+xpqrJHgtQHug1TOA3Rs9sHBGIWIj67s2C9fIRcghXOyg2DceaaW6MxxZJ8tKiS/mLSGG3klMI9iHNPzaTAUVFNsu6dA+HqYSaY5+lRfUaBiaKV
 egWv7xhWaPkR7B3fW83pGRypUqcz0oIPk4J/xgWRCBs31l78VhxX5Vkkt+eyrM3hnZv2deCeZFAMiNsLilxWK0fizUIY8FLfxkoXf7/ZK562rr8GGXIm5TmT
 f3s8f7z1nV3q6J/q9Ptvn8NXW0qshhh5EcvG7vk8x39zGbz+Is5yxERao65DEhYZGTwq1YmlBbi+ySAoxoO0Fg==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Apr 13, 2023 at 06:12:28PM +0200, Andrew Lunn wrote:
> >  	num_interfaces = cvmx_helper_get_number_of_interfaces();
> >  	for (interface = 0; interface < num_interfaces; interface++) {
> > +		int num_ports, port_index;
> > +		const struct net_device_ops *ops;
> > +		const char *name;
> > +		phy_interface_t phy_mode = PHY_INTERFACE_MODE_NA;
> >  		cvmx_helper_interface_mode_t imode =
> > -		    cvmx_helper_interface_get_mode(interface);
> > -		int num_ports = cvmx_helper_ports_on_interface(interface);
> > -		int port_index;
> > +			cvmx_helper_interface_get_mode(interface);
> > +
> > +		switch (imode) {
> > +		case CVMX_HELPER_INTERFACE_MODE_NPI:
> > +			ops = &cvm_oct_npi_netdev_ops;
> > +			name = "npi%d";
> 
> In general, the kernel does not give the interface names other than
> ethX. userspace can rename them, e.g. systemd with its persistent
> names. So as part of getting this driver out of staging, i would throw
> this naming code away.

That would break all userspace (which is often running vendor's kernel).
But since driver is in staging and noone cares about vendor's kernel
I guess it is okay...

> > +		num_ports = cvmx_helper_ports_on_interface(interface);
> >  		for (port_index = 0,
> >  		     port = cvmx_helper_get_ipd_port(interface, 0);
> >  		     port < cvmx_helper_get_ipd_port(interface, num_ports);
> >  		     port_index++, port++) {
> >  			struct octeon_ethernet *priv;
> >  			struct net_device *dev =
> > -			    alloc_etherdev(sizeof(struct octeon_ethernet));
> > +				alloc_etherdev(sizeof(struct octeon_ethernet));
> 
> Please try to avoid white space changed. Put such white space changes
> into a patch of their own, with a commit message saying it just
> contains whitespace cleanup.

Sorry, I overlooked this.

> >  			if (!dev) {
> >  				pr_err("Failed to allocate ethernet device for port %d\n",
> >  				       port);
> > @@ -830,7 +875,12 @@ static int cvm_oct_probe(struct platform_device *pdev)
> >  			priv->port = port;
> >  			priv->queue = cvmx_pko_get_base_queue(priv->port);
> >  			priv->fau = fau - cvmx_pko_get_num_queues(port) * 4;
> > -			priv->phy_mode = PHY_INTERFACE_MODE_NA;
> > +			priv->phy_mode = phy_mode;
> 
> You should be getting phy_mode from DT.
> 
> Ideally, you want lots of small patches which are obviously
> correct. So i would try to break this up into smaller changes.
> 
> I also wounder if you are addresses issues in the correct order. This
> driver is in staging for a reason. It needs a lot of work. You might
> be better off first cleaning it up. And then consider moving it to
> phylink.

I was asking this question myself and then came to this:
Converting driver to phylink makes separating different macs easier as
this driver is splitted between staging and arch/mips/cavium-octeon/executive/
However I'll provide changes spotted previously as separate preparational
patches. Would that work for you?

> 	 Andrew

Thank you,
	ladis
