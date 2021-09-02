Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3D23FF7D3
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344598AbhIBX1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhIBX1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:27:09 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963B1C061575;
        Thu,  2 Sep 2021 16:26:10 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s25so5405567edw.0;
        Thu, 02 Sep 2021 16:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FNx7Sjs58HqrySL8o4+QAe25L07gbXmuCz3/vApGk7Y=;
        b=lBiICCZRjBf/OK7sQs6cVKMmw/fUWFI1zrzgaaT1YuVEoR18CCz8mCCHmnHnJYyl1Y
         yb+5JPy17dcSk1eQlWTQEqfkDKth2iGOaNaZSh7XoIJ9iCxfq2ni5BmvE/3ZnOVG9vHL
         olRznZ+PIkR7suR5NM/WRirhSFMyKmyUKh6esj1HlxkQV5/b41m+vecS4IHh88w+Cpxu
         PMorH6Mz1PhAqRzb1gpt8uLBsIssdB3u5qGw4Yy1cyeqrhQBkFTc/MAEaaVno3YWJY14
         GvbrdgrAmglBJyOoiVvqLDdZ6MphTXVbsIWZziadsi/RHE0MtpkGou+KcmEiBv4D8EIl
         wi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FNx7Sjs58HqrySL8o4+QAe25L07gbXmuCz3/vApGk7Y=;
        b=B7eErm2HGHAYqOPPcMIxacnlYmCEFxCU4/BNlhmE+Y6DgIbDV+16x+gtsmN49RhsC/
         CkM3Q6t0AErGaB7kJdlf6iAOdp0nbiuwb+WABJNpE0u+UxRA5RUUxD//9YChPyR+n4Gx
         B/DXxcsgKBioC4fvItOLzfctiI1gCQ0u7mhpjNlNKUv8jL/loxwwtTH1EPQb50KC8nqD
         3er+mGVkoJ84E+7IrRpAKte+Ue9UmOg0hVVJkzK2kDCd69Kl+IyPzzFNEjDJDDFaFv/A
         waOY6dG7E5IIkgG2ZYs7DRxFx0Pj62GTVcC0RofkzFlxyM2NQAmROVyQqloBtIGgppSA
         8SPw==
X-Gm-Message-State: AOAM532098iGIsnj01L0/3jB6iXpp099MZuHmSy09Bpc6ke2PABoR/zn
        JwzQyrSwOQazqm2QXhX/n1s=
X-Google-Smtp-Source: ABdhPJwAjB3wGno7sNnnL7yj4CJFAdUZG2asfBfue0epMW6iAOydidI+q+DwDfHR+FfKsY7ISKjNwg==
X-Received: by 2002:a05:6402:8c6:: with SMTP id d6mr876206edz.30.1630625169182;
        Thu, 02 Sep 2021 16:26:09 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id c10sm1858710eje.37.2021.09.02.16.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 16:26:08 -0700 (PDT)
Date:   Fri, 3 Sep 2021 02:26:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210902232607.v7uglvpqi5hyoudq@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
 <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
 <20210902213949.r3q5764wykqgjm4z@skbuf>
 <20210902222439.GQ22278@shell.armlinux.org.uk>
 <20210902224506.5h7bnybjbljs5uxz@skbuf>
 <YTFX7n9qj2cUh0Ap@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTFX7n9qj2cUh0Ap@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 01:02:06AM +0200, Andrew Lunn wrote:
> We should try to keep phylink_create and phylink_destroy symmetrical:
> 
> /**
>  * phylink_create() - create a phylink instance
>  * @config: a pointer to the target &struct phylink_config
>  * @fwnode: a pointer to a &struct fwnode_handle describing the network
>  *      interface
>  * @iface: the desired link mode defined by &typedef phy_interface_t
>  * @mac_ops: a pointer to a &struct phylink_mac_ops for the MAC.
>  *
>  * Create a new phylink instance, and parse the link parameters found in @np.
>  * This will parse in-band modes, fixed-link or SFP configuration.
>  *
>  * Note: the rtnl lock must not be held when calling this function.
> 
> Having different locking requirements will catch people out.
> 
> Interestingly, there is no ASSERT_NO_RTNL(). Maybe we should add such
> a macro.

In this case, the easiest might be to just take a different mutex in
dpaa2 which serializes all places that access the priv->mac references.
I don't know exactly why the SFP bus needs the rtnl_mutex, I've removed
those locks and will see what fails tomorrow, but I don't think dpaa2
has a good enough justification to take the rtnl_mutex just so that it
can connect and disconnect to the MAC freely at runtime.
