Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C28637168A
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhECOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhECOZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 10:25:41 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462C5C06174A;
        Mon,  3 May 2021 07:24:47 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id w3so8162721ejc.4;
        Mon, 03 May 2021 07:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xbzdo0xQrv+Gso8bLCGszfVBnbWoOh5vAueEY2DluCw=;
        b=VK/8GNWAIF37AudSMpo30lHFvwxiVVMM5Sm5KLTiqznrxNT5sY/fBOst11uCo9SR0m
         n16X8CSuM4m0WWJT/JNaHN/4KzbYZe2qEODTouO1NFoXfaXj40R7rft7GeioIU+ixByf
         BV3+Rz+BDtWU/If8xsnt9ztLfMtNIfz2sSYDq2kYi17nF8eojFHoD85gqeZpkg/fuw3+
         qrNHwBGhYvuNxzh+AsSPGUiDlH858L8RqMKXxNgpo8x0hachoQuZLhzL4NCgZntzGwjq
         GzyrIHWqFaQ4TOkrrcbV9JflpzRwZS5QMOSSpGkgDNn43t8muYBk6wXRfRXhOiGBjfqF
         hFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xbzdo0xQrv+Gso8bLCGszfVBnbWoOh5vAueEY2DluCw=;
        b=eOVsQfPDRUZL2Ng3kTnLUrWIpXamscnikKXBTOYKWA75AUeEz6Mr8pRfE8Uec0QvMC
         qdOTn57UUnTONn9q4sx1JXekEbm92xbE8EAbucs5FbKIQXBe/mMFaUxx+5QjUwr7BU6J
         FOWLiCXqUFN/NGvArwZ9WmKr5Ic1JTgwp/BRihscgmLrp/Q2VqACM++5OG5W2W1cfXg9
         bhEyC3C9BWrMrESnSss8CFatpw5o/1evIe16IOslWHRK93iBr9NOICZm3VZtCS2DA+ep
         4wUEJYEZ823NMR6k0aONQ8RvY7jD1ovQa8goqMoaNCB1nKO0bk9dQVlRvJfTfQA9HBMt
         7gew==
X-Gm-Message-State: AOAM530GWOQEGrc/lorIx8x3zwVnbTIB90snNYpNwXpoWNuque9t3IW3
        RuMvKFLKFBz7AAOIArcJCoQ=
X-Google-Smtp-Source: ABdhPJzRtdede5z2G71iOU16CUdLqNb5dAIMb2erJdj45aQAMZWL0pT/pvQ1tAH8TNOBLOVgGAybxA==
X-Received: by 2002:a17:906:abcc:: with SMTP id kq12mr369950ejb.97.1620051885866;
        Mon, 03 May 2021 07:24:45 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id pw11sm10867114ejb.88.2021.05.03.07.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 07:24:45 -0700 (PDT)
Date:   Mon, 3 May 2021 16:24:15 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v2 02/17] net: mdio: ipq8064: switch to
 write/readl function
Message-ID: <YJAHj/IWZLEZeDmL@Ansuel-xps.localdomain>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
 <20210502230710.30676-2-ansuelsmth@gmail.com>
 <YI/xXuWbq7npocCS@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YI/xXuWbq7npocCS@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 02:49:34PM +0200, Andrew Lunn wrote:
> On Mon, May 03, 2021 at 01:06:54AM +0200, Ansuel Smith wrote:
> > Use readl/writel function instead of regmap function to make sure no
> > value is cached and align to other similar mdio driver.
> 
> regmap is O.K. to use, so long as you tell it not to cache. Look at
> how to use volatile in regmap.
> 
> You might be able to follow what lan9303_mdio.c is doing.
> 
>     Andrew

Was thinking more about the overhead of using regmap instead of plain
writel. Or is it minimal?

