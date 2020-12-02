Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593762CC504
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389223AbgLBSZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbgLBSZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:25:18 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24284C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 10:24:38 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id t8so2926517iov.8
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 10:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wNtVQpT+d1FPaM3FxBuOiQi3KAS/ERsGZY1cVNFyCfQ=;
        b=j9ECH7iR8hNj2h4qih4HDTfprKKlLAsHvSN8PRmwy68EoKJSduhP/Z/BZKrS/3NrDA
         3f1ma9r98qpUX1NsuuzQiN11/gwan3dWYu7L53Yh18I81NkzGmJSmnDtK2lc1V8fsc3q
         +X5RtKAbyvBW6fG/GXB4z9HylEfufjSg1ehrRMM3vjMjxSLCayZhLlX84Lyxu76MgrKh
         x9o5Fm/kMJyoHqVMcy5QF9REiyYcwvNSTWLGLBkxKmljmyi/oFmaHnC2NmaXqNqi8f1h
         nrk/m63JfuJBdq4Ej3d7iVzpo5ckSgkQuvmHyj/z902W6Yb0B3k3xoSs5ZAt6+shxubP
         L7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wNtVQpT+d1FPaM3FxBuOiQi3KAS/ERsGZY1cVNFyCfQ=;
        b=LQyriTI9VhVjasCOn4G2AgkcqG0qUksM3L1CPrQmtQ4C3W6dSbTjM12Rjvi0piX3/E
         XLuonFPDuSs5K61oeJjrC5RIh5hOdBylXXF6FPE2gjjtNt43Q/uH7sri4pdQmtZeYymU
         Bj7p8lGyndX5Kl9ifKlfT9rogks6KheKSV+xQ7Q1MczPNszC3r6LY4VqxaOxXewfel1t
         6kbwI7mvMD8hzl/1tz51vUa+5McPxFh3VKOKQG8qPfX4JlUGqZUGiBQ2J0xr+K47rLpW
         CzNMw71ZG3YH1HsAtwuLjd7b9t2VGXslsHZulxmIXpBmdJkIXsAafnODS2IGa3lDgwyO
         eStw==
X-Gm-Message-State: AOAM533sDgFdG9UPHW3XibMAimfcYggN0PTdtGtjgmJZI8R8cu4hL6TY
        /gqI35V5VYmTX29QhTQ+Tv8=
X-Google-Smtp-Source: ABdhPJyBw+2TdW7o/pcF/uKf1uB52UEx8fcSxAMd3Rh2CYYEp8hIaNAWzCMy6lRpgvH84UNQdQQMxQ==
X-Received: by 2002:a5d:8356:: with SMTP id q22mr2997820ior.50.1606933477411;
        Wed, 02 Dec 2020 10:24:37 -0800 (PST)
Received: from localhost (c-68-46-86-141.hsd1.mn.comcast.net. [68.46.86.141])
        by smtp.gmail.com with ESMTPSA id m7sm1124445iow.46.2020.12.02.10.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:24:36 -0800 (PST)
Date:   Wed, 2 Dec 2020 12:24:35 -0600
From:   Grant Edwards <grant.b.edwards@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <X8fb4zGoxcS6gFsc@grante>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Sorry for sending my previous message twice, it was rejected by the
list server the first time because it contained both plaintext and
HTML alternatives].

On Wed, Dec 02, 2020 at 10:10:37AM -0800, Florian Fainelli wrote:
> On 12/2/2020 9:50 AM, Grant Edwards wrote:
>
> > I know this thread is a couple years old, but I finally got around
> > to working with a newer kernel (5.4) that has the "fixed phy"
> > support.  Unfortunately, the existing "fixed phy" support is
> > unusable for us. It doesn't just present a fake, fixed, PHY. It
> > replaces the entire mii (mdio/mdc) bus with a fake bus. That means
> > our code loses the ability to talk to the devices that /are/
> > attached to the macb's mdio management bus.
> 
> You did not indicate this was a requirement.

Indeed, I should have done so. It didn't occur to me since I was
discussing adding a fake PHY, not a fake bus.

>> So, I ended up porting my hack from the 2.6.33 macb.c driver to the
>> 5.4 macb.c driver. [...]
> 
> That should be unnecessary see below.

> &eth0 {
> 	fixed-link {
> 		speed = <1000>;
> 		full-duplex;
> 	};
> 	mdio {
> 		phy0: phy@0 {
> 			reg = <0>;
> 		};
> 	};
> };

Thanks! I may try that if we can resolve the performance issues with
the newer kernels.

When using the SIOC[SG]MIIREG ioctl() call, how does one control
whether the fake fixed-link bus is accessed or the real macb-mdio bus
is accessed? Do different phy_ids automatically get mapped to the two
busses? That requires that a particular id can only exist on one bus
(which isn't a problem).

> The key thing here is to support a "mdio" bus container node which is
> optional and is used as a hint that you need to register the MACB MDIO
> bus controller regardless of MII probing having found devices or not.

How does the macb driver decide which bus/id combination to use as
"the phy" that controls the link duplex/speed settting the the MAC?

[Feel free to point me at appropriat documentation for this.]

--
Grant
