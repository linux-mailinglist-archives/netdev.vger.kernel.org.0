Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD8A77371
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfGZV25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:28:57 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56852 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfGZV25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:28:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2E9bno7xNc/HHdQG3LhbJ/60rliX27eGgYVlnlV1kpg=; b=Re65h+ViZhk0DACmQWyvRH/Wi
        FiT6b3YRmvaFV+oYr2gn8Wp5MZnbRu4LESB7Iq0sPdkxGdjPW8OlXVac9fBPCrIP3/QJ2cLVFnXjQ
        J2UjgRoFC9lJVzpjwqJlPzdYE0WrlMFEhXdTgvDef+oGbKV0Gw9VNjRC0ogq8uq+69eQH9aooPyF5
        EdyvC7FPRehQYohF92F3QctXxf01NFc/U5e7+A3Ur1wUvUleT6hjl9qtzM6wO+B70ItUmeArVeV0J
        mpmYrqCg5Z+nW0deljpVCK0dtpOrOLYl2pAJ5sxuuiME3rpRuq6mabNt0cy5D9KLbe1KqpASkvvXV
        lV5BYa3Ww==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:37402)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hr7li-0008Uf-H2; Fri, 26 Jul 2019 22:28:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hr7lh-00075s-Kx; Fri, 26 Jul 2019 22:28:49 +0100
Date:   Fri, 26 Jul 2019 22:28:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     netdev@vger.kernel.org
Subject: Re: phylink: flow control on fixed-link not working.
Message-ID: <20190726212849.GR1330@shell.armlinux.org.uk>
References: <20190717213111.Horde.nir2D5kAJww569fjh8BZgZm@www.vdorst.com>
 <20190717215150.tk3gvq7lqc56scac@shell.armlinux.org.uk>
 <20190717225816.Horde.Lym7vHLMewe-3L_Elk45WIQ@www.vdorst.com>
 <20190719195226.Horde.MpIE5TFL_P5-pUU6V-K6R9J@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190719195226.Horde.MpIE5TFL_P5-pUU6V-K6R9J@www.vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 07:52:26PM +0000, René van Dorst wrote:
> Hi Russel,
> 
> If I use this patch below:
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 5d0af041b8f9..a6aebaa14338 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -216,6 +216,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
>                                pl->supported, true);
>         linkmode_zero(pl->supported);
>         phylink_set(pl->supported, MII);
> +       phylink_set(pl->supported, Pause);
> +       phylink_set(pl->supported, Asym_Pause);
>         if (s) {
>                 __set_bit(s->bit, pl->supported);
>         } else {
> 
> Which is similar thing also done in phylink_parse_mode().

Yep, that's what should be there - please submit as a fix patch, thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
