Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0004822A1C2
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbgGVWGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgGVWGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:06:54 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC50C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:06:54 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so2921039edq.8
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tvTWqhZ1RO0FbKoCUVFH5hKbJA9JdiiX64b6XL49w4I=;
        b=NuAFsktt70m4S801i5Jx25MR75G+EPCvHqDUaow1VEjJph06P57u3L5q0DCUN49+1l
         T+GGmkxGTp77eQOaLnLoaI7mxhEHVM72l9CPdzSQuohjLNdSrV0lkSnjvcLSbo/xJPTn
         FemJPf+4m2BaL1QUdaW+XhKOkzdfAEFnhgB2hhyXLBhR9GVRBSZ/xBAuPgNApVlCvmHQ
         hgQoLFXDcU40p1FISfz8n326ReCImpXrfrVbGtbOGfD3eUEjrG7GW79wvvtnp21bXckP
         74Q2H2IquVtny6LjI1F6DmJ3WVpe5A4P53oGagGWpudIZAu3tphi2nvXVmC3IReG85Ec
         77WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tvTWqhZ1RO0FbKoCUVFH5hKbJA9JdiiX64b6XL49w4I=;
        b=TKs0ofKLtwjHn4H0XVn7DsmP8OEubuTvtCqTy1NY/5iKo/5OpFfRbwpxvS3IVHM8K7
         KwwGk4crjLnxoGfd4NngHOHmHB3oBvwXuLlOzAdjn11SZdprX3rpWYFBgMV7NUwampbb
         lTN1nnTCzttmEhdS9bCxHMqB1LdRcQ69FWjJgMpj5sGlDIBSqVr0WhZvgVKs7O80OyDS
         PPWx07eBCOtXKjGATRJj+Q31J0mJ42ycJNu6oxvmSiZjXQjTNPsIuuUI+U46s5ZMREjl
         3EHJz2PJhRFcW434VKJXMo/8TAP1OAaFLrJEBx3xrLLW0CWItFxTtlSiV7Pn7j7UmQdl
         Z62g==
X-Gm-Message-State: AOAM533mBKz9Nspro/Ckz3EwJFJCs5NKXyvfiTbi4pe0qKCotsykmtW3
        PkChvwFjATI6RFItCtilQJU=
X-Google-Smtp-Source: ABdhPJyhkwvP8+0ZVG42JC0eUzFClDhN/ljcvpJdZTLClmW3/Uy3TBlATcLFY4+qmK/T6RQBnr5nDQ==
X-Received: by 2002:a50:fd12:: with SMTP id i18mr1459404eds.371.1595455612947;
        Wed, 22 Jul 2020 15:06:52 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x18sm653998ejs.23.2020.07.22.15.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 15:06:52 -0700 (PDT)
Date:   Thu, 23 Jul 2020 01:06:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, jiri@mellanox.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        maximmi@mellanox.com, mkubecek@suse.cz, richardcochran@gmail.com
Subject: Re: [PATCH net-next] net: restore DSA behavior of not overriding
 ndo_get_phys_port_name if present
Message-ID: <20200722220650.dobse2zniylfyhs6@skbuf>
References: <20200722205348.2688142-1-olteanv@gmail.com>
 <98325906-b8a5-fb0c-294d-b03c448ba596@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98325906-b8a5-fb0c-294d-b03c448ba596@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 02:53:28PM -0700, Florian Fainelli wrote:
> On 7/22/20 1:53 PM, Vladimir Oltean wrote:
> > Prior to the commit below, dsa_master_ndo_setup() used to avoid
> > overriding .ndo_get_phys_port_name() unless the callback was empty.
> > 
> > https://elixir.bootlin.com/linux/v5.7.7/source/net/dsa/master.c#L269
> > 
> > Now, it overrides it unconditionally.
> > 
> > This matters for boards where DSA switches are hanging off of other DSA
> > switches, or switchdev interfaces.
> > Say a user has these udev rules for the top-level switch:
> > 
> > ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p0", NAME="swp0"
> > ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p1", NAME="swp1"
> > ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p2", NAME="swp2"
> > ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p3", NAME="swp3"
> > ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p4", NAME="swp4"
> > ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p5", NAME="swp5"
> > 
> > If the DSA switches below start randomly overriding
> > ndo_get_phys_port_name with their own CPU port, bad things can happen.
> > Not only may the CPU port number be not unique among different
> > downstream DSA switches, but one of the upstream switchdev interfaces
> > may also happen to have a port with the same number. So, we may even end
> > up in a situation where all interfaces of the top-level switch end up
> > having a phys_port_name attribute of "p0". Clearly not ok if the purpose
> > of the udev rules is to assign unique names.
> > 
> > Fix this by restoring the old behavior, which did not overlay this
> > operation on top of the DSA master logic, if there was one in place
> > already.
> > 
> > Fixes: 3369afba1e46 ("net: Call into DSA netdevice_ops wrappers")
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> > This is brain-dead, please consider killing this and retrieving the CPU
> > port number from "devlink port"...
> 
> That is fair enough. Do you want to submit such a change while you are
> at it?
> 

If I'm getting you right, you mean I should be dropping this patch, and
send another one that deletes dsa_ndo_get_phys_port_name()?
I would expect that to be so - the problem is the fact that we're
retrieving the number of the CPU port through an ndo of the master
interface, it's not something we can fix by just calling into devlink
from kernel side. The user has to call into devlink.

> > 
> > pci/0000:00:00.5/0: type eth netdev swp0 flavour physical port 0
> > pci/0000:00:00.5/2: type eth netdev swp2 flavour physical port 2
> > pci/0000:00:00.5/4: type notset flavour cpu port 4
> > spi/spi2.0/0: type eth netdev sw0p0 flavour physical port 0
> > spi/spi2.0/1: type eth netdev sw0p1 flavour physical port 1
> > spi/spi2.0/2: type eth netdev sw0p2 flavour physical port 2
> > spi/spi2.0/4: type notset flavour cpu port 4
> > spi/spi2.1/0: type eth netdev sw1p0 flavour physical port 0
> > spi/spi2.1/1: type eth netdev sw1p1 flavour physical port 1
> > spi/spi2.1/2: type eth netdev sw1p2 flavour physical port 2
> > spi/spi2.1/3: type eth netdev sw1p3 flavour physical port 3
> > spi/spi2.1/4: type notset flavour cpu port 4
> > 
> >  net/core/dev.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 19f1abc26fcd..60778bd8c3b1 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8603,15 +8603,20 @@ int dev_get_phys_port_name(struct net_device *dev,
> >  	const struct net_device_ops *ops = dev->netdev_ops;
> >  	int err;
> >  
> > -	err  = dsa_ndo_get_phys_port_name(dev, name, len);
> > -	if (err == 0 || err != -EOPNOTSUPP)
> > -		return err;
> > -
> >  	if (ops->ndo_get_phys_port_name) {
> >  		err = ops->ndo_get_phys_port_name(dev, name, len);
> >  		if (err != -EOPNOTSUPP)
> >  			return err;
> > +	} else {
> > +		/* DSA may override this operation, but only if the master
> > +		 * isn't a switchdev or another DSA, in that case it breaks
> > +		 * their port numbering.
> > +		 */
> > +		err  = dsa_ndo_get_phys_port_name(dev, name, len);
> 
> Extraneous space here.
> 

I understand what you mean, but I was just moving it...
I wouldn't exactly respin for a whitespace. Although I might end up
dropping this patch if I understand your first comment correctly.

> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> -- 
> Florian

Thanks,
-Vladimir
