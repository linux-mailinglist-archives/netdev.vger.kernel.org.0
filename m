Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A44B291302
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 18:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438312AbgJQQOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 12:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437495AbgJQQOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 12:14:41 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94786C061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 09:14:39 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e17so6761559wru.12
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 09:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0SatIQlidvZf73L97wjZebmY29C9SdVMqLfd1A/atNQ=;
        b=FZKl26P86+1Molrh6GnQUr/p3/PqEe+v4okLAGBOvz4E2Mhdqy/pXzdb5hBV0nZMuh
         9ZArlMkj9xtw9KdXHuHJ/oSBjRPZTUzpFxThjz96CB9EQnugCd/h1ObJPx/npEdzGxnn
         jBVapRwJxKOZxBCJ0nq9v41WozxGW/ywhHQrOeWzDTE4Lxr4x90oC1D5RDJPvpec8DIv
         yaVnihu7CpoQf47CwDE6588dJVV+5xxH0YxKmVznQwWzN6YEMmpGrWsfMnaS9Jd6+qmi
         TgbnAUCKP4xJiJep6NyBeLG07pHW8JJsKzQpzGQZbU/3keZ4MuQN5Sg87rDykiez2lsN
         n++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0SatIQlidvZf73L97wjZebmY29C9SdVMqLfd1A/atNQ=;
        b=TZa+WH+QE5NlvEgJd93kj923P7onUICPJ8tzWEjzPzv8VDjqDGyTnNoyzfnFHsxOw0
         7Xe7Z/lPyZARRwvSEndB3eEHt31C3DGogu1yRjpxUsldRB/QqqmDSK63IipqN1fPGkT9
         PO9UnaLMUiQJqJ+RalWUqnVWPwLuz359Jx9v6yw/ZD4tld5aQWr7w1nQTnyl4wFUsRkX
         rkhhu0oS69nrRJ5kt6skN2Ga5AORe9LpZLO0H7DX/jcOG5YGrO56WekpvA75vtqiPM6U
         qMDb3jJGOwmmrvINdOqd3uVwZwg1Ur051SPLyBkPdXyOl0xoERCcRuvenv02+lFlGYEq
         zAzQ==
X-Gm-Message-State: AOAM533N1wKtMNrSJtyie6HJ19p52sXQJMSdplS8buYDUcOw5O5DWGVh
        2ocDmA0EiRUDNzHYGP5elbVVqQ==
X-Google-Smtp-Source: ABdhPJxgLm35+p4Ma4qIQ7eXmG2nx5T/oUAJvUvCOqjwAFGgsagw9jyjo4C5pMIBOSBWPqd8FbkD8g==
X-Received: by 2002:a5d:4a06:: with SMTP id m6mr10517827wrq.209.1602951278320;
        Sat, 17 Oct 2020 09:14:38 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id a81sm8426718wmf.32.2020.10.17.09.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 09:14:37 -0700 (PDT)
Date:   Sat, 17 Oct 2020 19:14:35 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201017161435.GA1768480@apalos.home>
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch>
 <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch>
 <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ard, 

On Sat, Oct 17, 2020 at 05:18:16PM +0200, Ard Biesheuvel wrote:
> On Sat, 17 Oct 2020 at 17:11, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sat, Oct 17, 2020 at 04:46:23PM +0200, Ard Biesheuvel wrote:
> > > On Sat, 17 Oct 2020 at 16:44, Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > On Sat, Oct 17, 2020 at 04:20:36PM +0200, Ard Biesheuvel wrote:
> > > > > Hello all,
> > > > >
> > > > > I just upgraded my arm64 SynQuacer box to 5.8.16 and lost all network
> > > > > connectivity.
> > > >
> > > > Hi Ard
> > > >
> > > > Please could you point me at the DT files.
> > > >
> > > > > This box has a on-SoC socionext 'netsec' network controller wired to
> > > > > a Realtek 80211e PHY, and this was working without problems until
> > > > > the following commit was merged
> > > >
> > > > It could be this fix has uncovered a bug in the DT file. Before this
> > > > fix, if there is an phy-mode property in DT, it could of been ignored.
> > > > Now the phy-handle property is correctly implemented. So it could be
> > > > the DT has the wrong value, e.g. it has rgmii-rxid when maybe it
> > > > should have rgmii-id.
> > > >
> > >
> > > This is an ACPI system. The phy-mode device property is set to 'rgmii'
> >
> > Hi Ard
> >
> > Please try rgmii-id.
> >
> > Also, do you have the schematic? Can you see if there are any
> > strapping resistors? It could be, there are strapping resistors to put
> > it into rgmii-id. Now that the phy-mode properties is respected, the
> > reset defaults are being over-written to rgmii, which breaks the link.
> > Or the bootloader has already set the PHY mode to rgmii-id.
> >
> > You can also use '' as the phy-mode, which results in
> > PHY_INTERFACE_MODE_NA, which effectively means, don't touch the PHY
> > mode, something else has already set it up. This might actually be the
> > correct way to go for ACPI. In the DT world, we tend to assume the
> > bootloader has done the absolute minimum and Linux should configure
> > everything. The ACPI takes the opposite view, the firmware will do the
> > basic hardware configuration, and Linux should not touch it, or ask
> > ACPI to modify it.
> >
> 
> Indeed, the firmware should have set this up.

Would EDK2 take care of the RGMII Rx/Tx delays even when configured to 
use a DT instead of ACPI?

> This would mean we could > do this in the driver: it currently uses
> 
> priv->phy_interface = device_get_phy_mode(&pdev->dev);
> 
> Can we just assign that to PHY_INTERFACE_MODE_NA instead?

Thanks
/Ilias
