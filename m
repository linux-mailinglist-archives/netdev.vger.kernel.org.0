Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241A8427495
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243982AbhJIASe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243818AbhJIASb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 20:18:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EBEC061570;
        Fri,  8 Oct 2021 17:16:35 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so42277486edt.7;
        Fri, 08 Oct 2021 17:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zsushKItico0ZEJaSnp8Ow4XZrSnt1M0EB9dgx2CPoA=;
        b=GlLPMSYFstebNrNY8SqWmHQdkBsvBl09+yYHtbgUmHsPOCjPzsAbhNix9q9YauZ8qC
         NU5OMoS5OwcLiEbtzK08ylq3M3xvmOjO9Ylf1yh7ef/tEg81QNHF69j08+NFvXwuUk4L
         i9QKBGANVhCPFAYYw0tJlQTyxMhZJ//cNQWYO7WorcWpyeVfL2e/u/FAXZ5oDV+mM0ob
         WwuPkVDh/jLfyo+VkYDq0wRZ5gd6Sn9c/ynbd6A/zMGC5OXuNxDk7QaH781Q7V9a3b7/
         f0RZXsVUvn/lDWMoflPaA3AVuYiKuaEm++XufRHzmKCEv+JCEmmLAfZWysJ9s128lumn
         7VCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zsushKItico0ZEJaSnp8Ow4XZrSnt1M0EB9dgx2CPoA=;
        b=bhOeEwSU1wLHSQQl9g1rpkL0B5GkC2DPonxv1MB/tQRki9TvPkb9XBIwjucOF15I8g
         w8QwHV5Ep1qYzU2sv2ZYdxOu4NPY7Eir68E9vVf6PnyK09Bd8TygWVYmY0b4xIXdPSMb
         Zxr4g3sdxG0slvlXkonvJAAF2yg60C2iEyfz74JIh0kLzLqqsOe566N3saAFjylDE1u7
         TQh13Ms7vC9PBjMN0QIuHg84zGIhjk3yRerpeFpmh84CXSkVzmdK8rFMuwQYOH3Nz0uC
         CpozBTzKzB6dzHuGlSnx2TqBssDvl9iBgFWbLVy2hYwf6onB765NbVl56cJxPOSbKxKr
         WOnw==
X-Gm-Message-State: AOAM531long2bRKEtfW09NQQr/RdPH/pFwbMmaZ6MTxod05zzKNGPLkU
        L5IyeDPMkxgboStpgguPkN69X7Z4wuU=
X-Google-Smtp-Source: ABdhPJz992UIiUyJGpqnaCYF1JKxr7B/MvsrPlVx6R2Th1qUEDUKtdymMhB9UeVsyaIH5stXAaVH3g==
X-Received: by 2002:a05:6402:40d0:: with SMTP id z16mr19908287edb.220.1633738594226;
        Fri, 08 Oct 2021 17:16:34 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id v13sm332382edl.69.2021.10.08.17.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 17:16:33 -0700 (PDT)
Date:   Sat, 9 Oct 2021 02:16:31 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <YWDfXyuvmFYwywJW@Ansuel-xps.localdomain>
References: <20211008233426.1088-1-ansuelsmth@gmail.com>
 <20211008164750.4007f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YWDZPfWOe+C2abWz@Ansuel-xps.localdomain>
 <20211008171355.74ea6295@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008171355.74ea6295@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 05:13:55PM -0700, Jakub Kicinski wrote:
> On Sat, 9 Oct 2021 01:50:21 +0200 Ansuel Smith wrote:
> > On Fri, Oct 08, 2021 at 04:47:50PM -0700, Jakub Kicinski wrote:
> > > On Sat,  9 Oct 2021 01:34:25 +0200 Ansuel Smith wrote:  
> > > > From Documentation phy resume triggers phy reset and restart
> > > > auto-negotiation. Add a dedicated function to wait reset to finish as
> > > > it was notice a regression where port sometime are not reliable after a
> > > > suspend/resume session. The reset wait logic is copied from phy_poll_reset.
> > > > Add dedicated suspend function to use genphy_suspend only with QCA8337
> > > > phy and set only additional debug settings for QCA8327. With more test
> > > > it was reported that QCA8327 doesn't proprely support this mode and
> > > > using this cause the unreliability of the switch ports, especially the
> > > > malfunction of the port0.
> > > > 
> > > > Fixes: 15b9df4ece17 ("net: phy: at803x: add resume/suspend function to qca83xx phy")  
> > > 
> > > Hm, there's some confusion here. This commit does not exist in net,
> > > and neither does the one from patch 2.
> > > 
> > > We should be fine with these going into net-next, right Andrew?  
> > 
> > Took the hash from linux-next. Think this is the reason they are not in
> > net?
> 
> Yup, just to be sure you understand the process please take a look at
> 
>  - How do the changes posted to netdev make their way into Linux?
>  - How often do changes from these trees make it to the mainline Linus
>    tree?
> 
> here:
> 
> https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#how-do-the-changes-posted-to-netdev-make-their-way-into-linux
> 
> But yeah, I think we can go back to posting all 15 patches as one
> series. Let's see if Andrew has any feedback on the v2.
> 
> Sorry for the confusion!

It's ok. We got all confused with the Fixes tag. Pushing stuff too
quickly... I should have notice they were not present in net and
reporting that. Sorry for the mess.

-- 
	Ansuel
