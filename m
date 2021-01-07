Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C2A2EE7A9
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbhAGVeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbhAGVeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 16:34:00 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB14C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 13:33:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id h16so9140937edt.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 13:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5OjdHn2fhRr3ygU70f87Y0mRFWXBQ8n7rXnE3We+2iQ=;
        b=IQbn1RemFn7xiTLMSKXCcJgkNlNLMFDAq5MiVIz7R7qbtqgeUUhy6+QbRJmXpVuCUt
         kpu2Kv35cNkEHEbY9tOpo/yUo+H0yxifqVjvqjL24xW6mJFxNO36d2cbHu3jNDaYOP4a
         1oEc7H9IX5LXza6Y2VmxMpEAbn1Ie1Am8BPrdHmquRcOyNuVWc3FpjAzDkU1UKCOyyws
         W3aaZB1dYy2gOzKHgmYW5GlLMppBl/JVAWdBXThUnc9FFUH/sKenS1hguBJKmKsnURDS
         IX71uNNEil7HMl31PlU1MJTWWVTbngSyiY83txrOt3o+4WpTNMUbvXOr3SqpNmtbVn9C
         1EwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5OjdHn2fhRr3ygU70f87Y0mRFWXBQ8n7rXnE3We+2iQ=;
        b=P6+7BUYHZHfRl4vRxOGcZad8n9/XkO9GJcBmm0HvP2X+ILKWAtQOy16Ih3ssAZrdBU
         em9Y3cS0a3lkWW4OdrvZHjRr2qr7N/dkTzXOVsOzAW2KaVtw3pY7s6aNOfVOKuPiegl9
         JyrYECZt3eBUYWBUE1O4ut+THrzhnbfAucBMRWiL81r6c6Um1Z3btCIUxZCpJnWY7IvV
         hqzQupFQA1jt6w5qCkhkT2iTFcELhqID7HeduXnT+IouIoVs9WCre7AWmLS+p9rsUO6E
         PTSe0xxv+ywQFYgZX2IAPF6yw6RrXv4cKj4OgCrfOGC4/OalbBcSm4JZLuh9NIl/0POD
         ZYow==
X-Gm-Message-State: AOAM531Tt7BH2E7/GXNFf+wV7I49q/iQLhp9gW8drv5cx+rJbHUhMSTf
        0KnoEQLHyspcoVYh/juUXrI=
X-Google-Smtp-Source: ABdhPJyPIhzYjZRPeReQypnkrln2SDyOGYEEMh59BMaw+HPOfqWkKATurgIeuB88cjWqrjF0Z0YioA==
X-Received: by 2002:a50:e846:: with SMTP id k6mr3143457edn.245.1610055198160;
        Thu, 07 Jan 2021 13:33:18 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q20sm2912396eju.1.2021.01.07.13.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:33:17 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 7 Jan 2021 23:33:16 +0200
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, laurentiu.tudor@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH 4/6] dpaa2-eth: retry the probe when the MAC is not yet
 discovered on the bus
Message-ID: <20210107213316.774mqzy5pclls44g@skbuf>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
 <20210107153638.753942-5-ciorneiioana@gmail.com>
 <X/d8FkhFsfnlp2hA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/d8FkhFsfnlp2hA@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:24:38PM +0100, Andrew Lunn wrote:
> On Thu, Jan 07, 2021 at 05:36:36PM +0200, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > The fsl_mc_get_endpoint() function now returns -EPROBE_DEFER when the
> > dpmac device was not yet discovered by the fsl-mc bus. When this
> > happens, pass the error code up so that we can retry the probe at a
> > later time.
> > 
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index f3f53e36aa00..3297e390476b 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -4042,6 +4042,10 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
> >  
> >  	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
> >  	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
> > +
> > +	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
> > +		return PTR_ERR(dpmac_dev);
> > +
> >  	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
> 
> Hi Ioana
> 
> Given the previous change, i don't think dpmac_dev can be NULL, so you
> can change this to IS_ERR(). IS_ERR_OR_NULL() often triggers extra
> review work because it is easy to get it wrong, so removing it is nice.
> 

Indeed, fsl_mc_get_endpoint() does no longer return NULL.
I'll change it to IS_ERR() in v2.

Thanks!
