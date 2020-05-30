Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ACF1E944D
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 00:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgE3Wgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 18:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgE3Wgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 18:36:44 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA67C03E969;
        Sat, 30 May 2020 15:36:44 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id q19so362996eja.7;
        Sat, 30 May 2020 15:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b1diGIdCnUX0xk90eoc3fedrV2Zs1+bnZQMox0v+x2U=;
        b=W87P5ZykKj2lmTG9c1DgnD63PbZwXtmEfQ98xH8ZZHpWsk5e4WyH/pvHOAGxW3U5RW
         Usi5PkcwDbAtKcV9HRwW7EhW5HG7F57xJLta9mH672MF95ISYuJVHMkVUQV58K2pz6Yn
         HoGlohFnyH6rkndDMAa/Tyr4BhhQDPUK/yMwiyo35iqufk6gimTbj84oourgWz/teOUn
         rADrsVgoC22ArhrG8tMEqV4nkifD/6RTgJwx2D8LYwMAng1KS8PsRm22tBGsIT0rdCX1
         eLg8JNR0U6zgnNdmuil4K1ZYCct53FcYNqXeF4dYr5o0HXo86nd7aNO0bDE4J135DMBe
         Y3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b1diGIdCnUX0xk90eoc3fedrV2Zs1+bnZQMox0v+x2U=;
        b=I3y+xfcmzYRBy4YhGamqcSaZAsZ5agy0KVv1uL5o9lzLue81llqfiR1A7+F/AW00+L
         5J4mbg+AdE8dT51QfJnOqm7fFAN4qty3pSH3oNTdwU5j4Ow7e0kkGUiZOui43CNmpq0G
         2cKLeRQxHPR4GCLP886xZt28FvLM+Zb1Sq/qFlUFplvgALm1LP/9PdYW5yEVUjIZFwJ+
         5wYr7p0DP0sb1d+5XQtd6hvR324oNhL5tqo9zcHEJDQ0a3r4/mgDm90sAxTl7S8Z2aSU
         fdLA3umqeGkGshfL6kTlCugMkgDqji7FKpp30qpbJZtB4XT8+es334fOTBieGNsJQp+v
         54/w==
X-Gm-Message-State: AOAM533J0Zj+Y1wKEfi5nxYQZ+iIwdyRM5ReAw5l/sRuPNbdxW8P/Efg
        S1WNJbU8ULMZ6In/njGs5BMlxpN4
X-Google-Smtp-Source: ABdhPJzozWLOh73I68VLe0ERPwT1P4IJI5zSyTO/Ixg9i1u2jou1KNY65yuBfjz6E8E3Y7y/2XvYAg==
X-Received: by 2002:a17:906:60d3:: with SMTP id f19mr11886040ejk.478.1590878202942;
        Sat, 30 May 2020 15:36:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0? (p200300ea8f2357008c7380e5b6bad8b0.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0])
        by smtp.googlemail.com with ESMTPSA id m21sm4767814edj.74.2020.05.30.15.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 15:36:42 -0700 (PDT)
Subject: Re: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN
 has not completed in PHY_AN state
To:     Vladimir Oltean <olteanv@gmail.com>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200530214315.1051358-1-olteanv@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <fdf0074a-2572-5914-6f3e-77202cbf96de@gmail.com>
Date:   Sun, 31 May 2020 00:36:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530214315.1051358-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.05.2020 23:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In kernel 4.19 (and probably earlier too) there are issues surrounding
> the PHY_AN state.
> 
> For example, if a PHY is in PHY_AN state and AN has not finished, then
> what is supposed to happen is that the state machine gets rescheduled
> until it is, or until the link_timeout reaches zero which triggers an
> autoneg restart process.
> 
> But actually the rescheduling never works if the PHY uses interrupts,
> because the condition under which rescheduling occurs is just if
> phy_polling_mode() is true. So basically, this whole rescheduling
> functionality works for AN-not-yet-complete just by mistake. Let me
> explain.
> 
> Most of the time the AN process manages to finish by the time the
> interrupt has triggered. One might say "that should always be the case,
> otherwise the PHY wouldn't raise the interrupt, right?".
> Well, some PHYs implement an .aneg_done method which allows them to tell
> the state machine when the AN is really complete.
> The AR8031/AR8033 driver (at803x.c) is one such example. Even when
> copper autoneg completes, the driver still keeps the "aneg_done"
> variable unset until in-band SGMII autoneg finishes too (there is no
> interrupt for that). So we have the premises of a race condition.
> 
That's not nice from the PHY:
It signals "link up", and if the system asks the PHY for link details,
then it sheepishly says "well, link is *almost* up".

Question would be whether the same happens with other SGMII-capable
PHY's so that we need to cater for this scenario in phylib.
Or whether we consider it a chip quirk. In the latter case a custom
read_status() handler might do the trick too: if link is reported
as up then wait until aneg is signaled as done too before reading
further link details.

And it's interesting that nobody else stumbled across this problem
before. I mean the PHY we talk about isn't really new. Or is your
use case so special?

> In practice, what really happens depends on the log level of the serial
> console. If the log level is verbose enough that kernel messages related
> to the Ethernet link state are printed to the console, then this gives
> in-band AN enough time to complete, which means the link will come up
> and everyone will be happy. But if the console is not that verbose, the
> link will sometimes come up, and sometimes will be forced down by the
> .aneg_done of the PHY driver (forever, since we are not rescheduling).
> 
> The conclusion is that an extra condition needs to be explicitly added,
> so that the state machine can be rescheduled properly. Otherwise PHY
> devices in interrupt mode will never work properly if they have an
> .aneg_done callback.
> 
> In more recent kernels, the whole PHY_AN state was removed by Heiner
> Kallweit in the "[net-next,0/5] net: phy: improve and simplify phylib
> state machine" series here:
> 
> https://patchwork.ozlabs.org/cover/994464/
> 
> and the problem was just masked away instead of being addressed with a
> punctual patch.
> 
> Fixes: 76a423a3f8f1 ("net: phy: allow driver to implement their own aneg_done")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> I'm not sure the procedure I'm following is correct, sending this
> directly to Greg. The patch doesn't apply on net.
> 
>  drivers/net/phy/phy.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index cc454b8c032c..ca4fd74fd2c8 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -934,7 +934,7 @@ void phy_state_machine(struct work_struct *work)
>  	struct delayed_work *dwork = to_delayed_work(work);
>  	struct phy_device *phydev =
>  			container_of(dwork, struct phy_device, state_queue);
> -	bool needs_aneg = false, do_suspend = false;
> +	bool recheck = false, needs_aneg = false, do_suspend = false;
>  	enum phy_state old_state;
>  	int err = 0;
>  	int old_link;
> @@ -981,6 +981,8 @@ void phy_state_machine(struct work_struct *work)
>  			phy_link_up(phydev);
>  		} else if (0 == phydev->link_timeout--)
>  			needs_aneg = true;
> +		else
> +			recheck = true;
>  		break;
>  	case PHY_NOLINK:
>  		if (!phy_polling_mode(phydev))
> @@ -1123,7 +1125,7 @@ void phy_state_machine(struct work_struct *work)
>  	 * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
>  	 * between states from phy_mac_interrupt()
>  	 */
> -	if (phy_polling_mode(phydev))
> +	if (phy_polling_mode(phydev) || recheck)
>  		queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
>  				   PHY_STATE_TIME * HZ);
>  }
> 

