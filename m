Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7948358A28
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhDHQwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDHQwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 12:52:42 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9116C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 09:52:30 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so3533977pjh.1
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 09:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WqqqwkLOfCRl875fdfkuq1m+FN8h7ZOmheOUlv625bA=;
        b=tiZGMQua9VIvpsm7HVYgK8ftpZIHdgHfiA3P2PYs6P7mr292Yxg4iIeJl3ZkeOFBug
         Qo3oh8gs50Sir4jCp56smUOu/rL81lE0MkwCX7Lun2f2Oew4HFVtRc1sLMRbLtT3KbTD
         EsOYJWqY+lEB/CWudnD1hFh24PglpTD0IHZLT6PMuclziMDfcOSyZGis6Jcye4E7gyCo
         wkfQfZfMVAgbecZ/rkt8IG8V9saPhMl1qZDZdWvXpi7ZjhGsWDOd1IZEmulAz7ggMPSf
         8xKvBF/1d1vozq7/4gkh5qSxqLZqhKQIXbj1/ri9WnWTxi4+LM0k6mQQA9GiLtzzCvns
         WMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WqqqwkLOfCRl875fdfkuq1m+FN8h7ZOmheOUlv625bA=;
        b=iC1QvOG3LFckrcNFYM9XN36InQyvh5SbjqR+rzgbGoDpAjhYvT4RDNelj8s+B2TRUX
         +2KPbssGyi/K9vYiy9d1YcwxNmRcO4M5mOYsPi5Bqo3vzfbWeu3VFm5AXaZwCHJWfc6I
         ReH8A0eV12vN116r/iAkkIAm2AvF95ymbwnbYF94G9s+HvMJj8uDDxiyVdnp+TbyWF4Z
         e5NJ0/VoFcQtAVhmZC41tW4PLGF7w4ihTyFTbLT/j4iyWyB+PmteyeLxFdgTKjjrzMxB
         a9GqGDS4I+PrTBcq5NhdHOsnwmVKS+p8MX48wufyBXYPYDShR85RXVhnQppXn2V+u0rl
         nKaA==
X-Gm-Message-State: AOAM532fkKj8u0mOTk18CYRwjB7RY6Zdkj1QH/thraieeJicxCoJwjSu
        bwytWBTpSGIB2IvxNKTAAi1bgw==
X-Google-Smtp-Source: ABdhPJxuz9gP91XS8/PUeXXqBQBhP4MXiiMrL8L3BGaHVarhHbXmEM98R7kXiK8SkLW/JbU+5phlXw==
X-Received: by 2002:a17:902:6f10:b029:e9:7fdf:4902 with SMTP id w16-20020a1709026f10b02900e97fdf4902mr5660032plk.41.1617900750441;
        Thu, 08 Apr 2021 09:52:30 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id g3sm23910pfk.186.2021.04.08.09.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 09:52:30 -0700 (PDT)
Date:   Thu, 8 Apr 2021 09:52:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     decui@microsoft.com, davem@davemloft.net, kuba@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, liuwe@microsoft.com, netdev@vger.kernel.org,
        leon@kernel.org, andrew@lunn.ch, bernd@petrovitsch.priv.at,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210408095222.058022d0@hermes.local>
In-Reply-To: <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
References: <20210408091543.22369-1-decui@microsoft.com>
        <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Apr 2021 09:22:57 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 4/8/21 2:15 AM, Dexuan Cui wrote:
> > diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
> > new file mode 100644
> > index 000000000000..12ef6b581566
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microsoft/Kconfig
> > @@ -0,0 +1,30 @@
> > +#
> > +# Microsoft Azure network device configuration
> > +#
> > +
> > +config NET_VENDOR_MICROSOFT
> > +	bool "Microsoft Azure Network Device"  
> 
> Seems to me that should be generalized, more like:
> 
> 	bool "Microsoft Network Devices"

Yes, that is what it should be at this level.

> 
> 
> > +	default y

This follows the existing policy for network vendor level

> > +	help
> > +	  If you have a network (Ethernet) device belonging to this class, say Y.
> > +
> > +	  Note that the answer to this question doesn't directly affect the
> > +	  kernel: saying N will just cause the configurator to skip the
> > +	  question about Microsoft Azure network device. If you say Y, you  
> 
> 	           about Microsoft networking devices.
> 
> > +	  will be asked for your specific device in the following question.
> > +
> > +if NET_VENDOR_MICROSOFT
> > +
> > +config MICROSOFT_MANA
> > +	tristate "Microsoft Azure Network Adapter (MANA) support"
> > +	default m  
> 
> Please drop the default m. We don't randomly add drivers to be built.

Yes, it should be no (or no default which is the default for default)

> Or leave this as is and change NET_VENDOR_MICROSOFT to be default n.
> 
> 
> > +	depends on PCI_MSI && X86_64
> > +	select PCI_HYPERV
> > +	help
> > +	  This driver supports Microsoft Azure Network Adapter (MANA).
> > +	  So far, the driver is only validated on X86_64.  
> 
> validated how?

Maybe change validated to supported?


