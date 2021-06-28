Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D333B5BD9
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 11:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhF1KAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhF1KAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:00:13 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C80CC061574;
        Mon, 28 Jun 2021 02:57:47 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w17so9463518edd.10;
        Mon, 28 Jun 2021 02:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e+9kaDM3HhtP8KWHAFI+SxFAMjAw0vko71CUZnvXp2k=;
        b=PHK/IO+/Zw8aRHQhTJrG0CyxKfLxqnbDfhVcuuGq7k0yqLIDSDB2R5/DvItfco7zM9
         hRdynGR61u5V5aMkXnFu1dM9VmXGFiIO+6a5hinTfr83zNTD+BcsRzowIizswSH3DW1f
         ItbsmWY5++jM7p8NIGZ7H0VbcK6QvEAYADDeWn8yIDszuyO+D3FK+hdG+lFsORuBiMni
         g2U4rH57wis5AyKOEnAiSJmaw48bBaM86ot7jUuEribnHUSV+2AC8GqP3dkD05ApviD3
         q3nRxviYCPtDaIHguTGFa2wkeQ7PAx3t4t26ABbL1IYesR0WSJRq6xcMgR9oeiWzqJkA
         KZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e+9kaDM3HhtP8KWHAFI+SxFAMjAw0vko71CUZnvXp2k=;
        b=Kq/Ds5ojKBeKCI1gKX628gom5UOoLILCe1ctfRB3eldkR0R4eNH96cIA3fCT/Smhds
         N+4E0Rv0TKbGPx27c0gaClHkafdbQHWPFQ9/2i8Ay/0SMS2f+WVBMLjAn1zqI1+clrB5
         n3YFuDor78qLfl76lEk8kjryU0Rkz+3KQwIVPu6Y4KFfK024N7enSfiGzd0qImXjcHIi
         DfydSXLqUirfDTNB957703UnyElJ1LEg/tzoS7guejSehkdkqnyab7mOoXcpC+My+r+L
         urlTolUlTZE3UoctxNZ9zcWdK3cO+Hl6pIiRRQXHyh+FR3EcwYYZxx6E0/AEHPUYhz0R
         UW0A==
X-Gm-Message-State: AOAM532oTE29a9ZCrzZLZ37rWVYprZRVtfbdYUg/Z8SPx/5g6dKFbKwY
        u8htZWLZkC+OLLpNIr8TL4c=
X-Google-Smtp-Source: ABdhPJz2QPDPz5W0mtaAxWIDbNZiYiGbHW29D1G2FnYu7l2dRuXghrwYbFlmUNRV8i4TuOv30bG6Lg==
X-Received: by 2002:aa7:cd85:: with SMTP id x5mr2227897edv.115.1624874265892;
        Mon, 28 Jun 2021 02:57:45 -0700 (PDT)
Received: from BV030612LT ([188.24.178.25])
        by smtp.gmail.com with ESMTPSA id l26sm9373264edt.40.2021.06.28.02.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 02:57:45 -0700 (PDT)
Date:   Mon, 28 Jun 2021 12:57:42 +0300
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     Amit Tomer <amittomer25@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <20210628095742.GA2261718@BV030612LT>
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
 <ab25bd143589d3c1894cdb3189670efa62ed1440.1616368101.git.cristian.ciocaltea@gmail.com>
 <17876c6e-4688-59e6-216f-445f91a8b884@gmail.com>
 <20210322084420.GA1503756@BV030612LT>
 <CABHD4K_r_ixtBXH_v82S62onYr-=fbh8cHJsdz0oo6MN-i5tVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABHD4K_r_ixtBXH_v82S62onYr-=fbh8cHJsdz0oo6MN-i5tVg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Amit,

On Mon, Jun 28, 2021 at 01:55:40PM +0530, Amit Tomer wrote:
> Hi,
> 
> > > Do you know the story behind this Ethernet controller?
> >
> > I just happened to get a board based on the S500 SoC, so I took this
> > opportunity to help improving the mainline kernel support, but other
> > than that I do not really know much about the hardware history.
> >
> > > The various
> > > receive/transmit descriptor definitions are 99% those defined in
> > > drivers/net/ethernet/stmmicro/stmmac/descs.h for the normal descriptor.
> >
> > That's an interesting observation. I could only assume the vendor did
> > not want to reinvent the wheel here, but I cannot say if this is a
> > common design scheme or is something specific to STMicroelectronics
> > only.
> 
> I am not entirely sure about it but it looks like it *may* only need
> to have a glue driver to
> connect to DWMAC.

From the RX/TX descriptors perspective, this looks like a Synopsys IP,
but the MAC register layout is not similar at all.

Thanks to Mani, a request for clarification has been also sent to Actions,
but they could not confirm. Hence, at the moment, we do not have clear
evidences that it is based on Designware.

> For instance, on the U-boot[1] side (S700 is one of 64bit OWL SoC from
> actions), we kind of re-uses already
> existing DWMAC and provide a glue code, and on the Linux side as well
> have some similar implementation (locally).

The S700 SoC provides Gigabit ethernet capabilities and I assume the
controller is quite different from the 10/100 variant present on S500.
As a matter of fact, Actions has confirmed that in the case of S700, the
licensing was obtained from a third party IP company, although they were
not certain if the provider had previous agreements with Synopsys.

Regards,
Cristi

> Thanks
> -Amit.
> 
> [1]: https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/net/dwmac_s700.c
