Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6636337B1F8
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhEKW5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKW5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 18:57:49 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA634C061574;
        Tue, 11 May 2021 15:56:42 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g38so28453388ybi.12;
        Tue, 11 May 2021 15:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xyJsr5+GU6OwmtbK8l0br93cj/vlkcS6F2ecLZDOOUw=;
        b=rWUpmSmO26Ym2+SrQlRqIz2mpWdRvsw/gaBtPdipg5SId8RboUQCy8TKew5ARWnnO4
         MRhqXDJ7GQFISDXt0yEF9HlAQlHqya8CPZa/s8TUwJRYT9NGPyodcTenVHxaZPylISXu
         MYiBfVktTjdS18KL/MlJx92mPeG8mLTLY9AwNKn4087o2l3zemO/lXP4qomLmgB3dJXv
         OtakumQPDJkapyMmqfE5jsj8CNL6Q7NrwLyf0Zi19hIXZ1/2WdgCuqKOE5XUl8gzv32x
         f5ss0HfomCSV+b3WxIkrFGo8FbeVXxJKjb7y5p0vmWbzhp4zHdGgoVgPp8Q/iSZD3WiS
         eujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xyJsr5+GU6OwmtbK8l0br93cj/vlkcS6F2ecLZDOOUw=;
        b=P5J+WVR53runzxrGPvqcxZtFCeg7Sdueu8b1zCpzUj/yRvFMMuSBk93GYlQC2Sg/K7
         ENKR7V4n3ZPYv2zwBcVxO6x9DUO+ZuYbzapL3DQ1R/sbszWYOwNCcaxYuDkE+wi4Iu9b
         Fv1c9HviPZh63k0l7PwHqcNScCU4+zvEMJzAdGr+JljhtMYNJ3lg+B12rMOAGer52HYt
         fRDheHu6Xw15j2fcl9+ihJ/ZT2S0ldqfnwGZKBdTOeXj29xXwPzkdnMdtqO8AnoPRl5b
         881pUjFg3k8iQJytG4eh0Wz/WtKOxJgFHgCqGff2DC6g3kdOeapDar6V2kBKHsd02Gw4
         pBjg==
X-Gm-Message-State: AOAM533pwRXY+DX7cKHkhJJm8NWMNU9Gu5ZC/VjqtZJukizygCoL0BWb
        z5PahX571jOZtK5TdXpaIWR0JBnZxJ3DQ5fAsO0=
X-Google-Smtp-Source: ABdhPJxOJZq72lv83XITy6KKMDBkZMUV1JsOyUKmrwI3/5stYIVXL+jKGpVgHRkOvEq4dklqzJSD5C6XiyPth1TW3Gk=
X-Received: by 2002:a5b:3c2:: with SMTP id t2mr43272548ybp.39.1620773802086;
 Tue, 11 May 2021 15:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210511214605.2937099-1-pgwipeout@gmail.com> <20210511215644.GO1336@shell.armlinux.org.uk>
In-Reply-To: <20210511215644.GO1336@shell.armlinux.org.uk>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Tue, 11 May 2021 18:56:31 -0400
Message-ID: <CAMdYzYon+uscEXS=ntmQWD-ROr4owvbQwuWdb2DLmh74Gri1mA@mail.gmail.com>
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 5:56 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> Hi,
>
> On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
> > +static int yt8511_config_init(struct phy_device *phydev)
> > +{
> > +     int ret, val, oldpage;
> > +
> > +     /* set clock mode to 125mhz */
> > +     oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
> > +     if (oldpage < 0)
> > +             goto err_restore_page;
> > +
> > +     val = __phy_read(phydev, YT8511_PAGE);
> > +     val |= (YT8511_CLK_125M);
> > +     ret = __phy_write(phydev, YT8511_PAGE, val);
>
> Please consider __phy_modify(), and handle any error it returns.

Hey that's really neat, thanks!

>
> > +
> > +     /* disable auto sleep */
> > +     ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_SLEEP_CTRL);
>
> Please consider handling a failure to write here.

Will do.

>
> > +     val = __phy_read(phydev, YT8511_PAGE);
> > +     val &= (~BIT(15));
> > +     ret = __phy_write(phydev, YT8511_PAGE, val);
>
> Also a use for __phy_modify().
>
> > +
> > +err_restore_page:
> > +     return phy_restore_page(phydev, oldpage, ret);
> > +}
> > +
> > +static struct phy_driver motorcomm_phy_drvs[] = {
> > +     {
> > +             PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
> > +             .name           = "YT8511 Gigabit Ethernet",
> > +             .config_init    = &yt8511_config_init,
>
> Please drop the '&' here, it's unnecessary.

Will do, thank you.

>
> Thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
