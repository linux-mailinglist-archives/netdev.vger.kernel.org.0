Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6AF291FD3
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 22:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgJRUcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 16:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgJRUcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 16:32:31 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F21C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 13:32:29 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e17so9088053wru.12
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 13:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sAI3551ANWmDeAOBBAsmei3ufVqPNL4Mbt9ru6oPku4=;
        b=vmEMI2ojS7Lx2KpUhKMUyghwJQYP3cxm/vDaeoFQxrnud11vgSeMatWNdTqEGO4tPX
         T9sz5KrmX4ntYab/tbblW0hyUHoDPdK3mD33y3BUF6pOHZ0u83yo6iUNNuu6L8DDz59E
         UwZB1eI01NU5y27xF08vfujA2HBjP97px2WlqFah24AQZ3Us5RYb7+cxQ+5D5MFB3/t/
         zSXqPRGuB0IbXg/WS3/6px8LB1+nVI1quYDryRVFc1jRQq45/zjiVn9FsRb20YD0Elc0
         MujHV+FV/eqH/MTC2kMT3dokATfrAi/Kr+8L0u7I/DHJ4ImCz7rzRJc3Ct6U8XYjkteo
         48mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sAI3551ANWmDeAOBBAsmei3ufVqPNL4Mbt9ru6oPku4=;
        b=eHao8zfRPsMkGKqHc/0QqQtW84QC9MbYOZm67bnCaXYzBJWEWw3JiYmCs5fn022OkQ
         PpiE3lW526/61GjawwxdzN28iKTD8eOU2i6RSzkId6Ql2a0bsZsbsZmXruLlKRwgq9Td
         mWrzOfuAHF4EB9CKJ8RxOsW9SCc1cp8rxPEMxVPh5dJGUB1Q9Yjmm+K6JvCLHGOTHDvm
         oBoM0VRbVvOBY44+hXiBEeWVmEcI5eEnBtlCz3bHdaWFnD1WIv3iDkGMFonx+awMhfZ6
         bPSkrGwyQnkMJUYWJb76HH3GG0umBum0VThj0/M3Y9rKvDhJo9ynhAs7eauy5zCOOsvd
         OD0w==
X-Gm-Message-State: AOAM5302d1xc3UK6vZfe1SQieA1z96RuSDYuhDNIrhiRhB/lOyMU5wxn
        MmDp/t74fi+p6WgLMtPhAt58AG4oXcf3Ag==
X-Google-Smtp-Source: ABdhPJyjRzaObcF+GDRwZE8ZTTamSa7crXTcCCg1V87nB2YwmUT2UwkJFitml3zlthkJyqcyOlLi5Q==
X-Received: by 2002:adf:f584:: with SMTP id f4mr15652012wro.383.1603053148344;
        Sun, 18 Oct 2020 13:32:28 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id b5sm13842733wrs.97.2020.10.18.13.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 13:32:27 -0700 (PDT)
Date:   Sun, 18 Oct 2020 23:32:25 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ard Biesheuvel <ardb@kernel.org>, netdev@vger.kernel.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH net] netsec: ignore 'phy-mode' device property on ACPI
 systems
Message-ID: <20201018203225.GA1790657@apalos.home>
References: <20201018163625.2392-1-ardb@kernel.org>
 <20201018175218.GG456889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018175218.GG456889@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 07:52:18PM +0200, Andrew Lunn wrote:
> > --- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
> > +++ b/Documentation/devicetree/bindings/net/socionext-netsec.txt
> > @@ -30,7 +30,9 @@ Optional properties: (See ethernet.txt file in the same directory)
> >  - max-frame-size: See ethernet.txt in the same directory.
> >  
> >  The MAC address will be determined using the optional properties
> > -defined in ethernet.txt.
> > +defined in ethernet.txt. The 'phy-mode' property is required, but may
> > +be set to the empty string if the PHY configuration is programmed by
> > +the firmware or set by hardware straps, and needs to be preserved.
> 
> In general, phy-mode is not mandatory. of_get_phy_mode() does the
> right thing if it is not found, it sets &priv->phy_interface to
> PHY_INTERFACE_MODE_NA, but returns -ENODEV. Also, it does not break
> backwards compatibility to convert a mandatory property to
> optional. So you could just do
> 
> 	of_get_phy_mode(pdev->dev.of_node, &priv->phy_interface);
> 
> skip all the error checking, and document it as optional.

Why ?
The patch as is will not affect systems built on any firmware implementations 
that use ACPI and somehow configure the hardware. 
Although the only firmware implementations I am aware of on upsteream are based
on EDK2, I prefer the explicit error as is now, in case a firmware does on 
initialize the PHY properly (and is using a DT).

Cheers
/Ilias

> 
>      Andrew
