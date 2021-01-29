Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ADC308D4A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhA2TWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233100AbhA2TUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 14:20:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2022164DE3;
        Fri, 29 Jan 2021 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611947978;
        bh=Iei5nYM93WgnIp3b94zKZr/0qgpe3BbzHPtZ0tL13gY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MJj609qnUJkMZd09J6FxiAwBYUTpQ2gUT2+sp04RzhSEXb5IuR83ELVBz0LBZx76u
         iJ0ZHR3qqGDS3xcaqSr8DjO+oDySL1EO0JiRAd8HH/iaqazYCXKJvO1t2cCetAc/LH
         DHkxTAHIJl7zJKPD5HRwnIMWQThxeZkkZ4a0ViFvCnpFkw416BH79z77LY9Lc3LQJQ
         AFlPoa0lt98V4Vpf8D+5rPxFFnE0/tQBjJ0yEY/hv4eqtNUFfnfro+KKEgiBM9T5ko
         VpCrJ2gBLuwqFRZtGRTtwWtbek6fvZXCUGm1OGOQsBPLz9iTbZ73grOOsOfO43xJyC
         JCZmE4+jRXPNQ==
Date:   Fri, 29 Jan 2021 11:19:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3 net-next] net: core: devlink: add 'dropped' stats field
 for DROP trap action
Message-ID: <20210129111937.4e7e17d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM0P190MB0738FC4657CCB0E435C40B24E4B99@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210125123856.1746-1-oleksandr.mazur@plvision.eu>
        <20210125132317.418a4e35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0P190MB0738FC4657CCB0E435C40B24E4B99@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 11:15:43 +0000 Oleksandr Mazur wrote:
> > Thinking about it again - if the action can be changed wouldn't it 
> > be best for the user to actually get a "HW condition hit" counter,
> > which would increment regardless of SW config (incl. policers)?  
> 
> > Otherwise if admin logs onto the box and temporarily enables a trap 
> > for debug this count would disappear.  
> 
> But still this counter makes sense only for 'drop' action.

Okay, well, "dropped while trap was disabled" seems a lot less useful
of a definition than "number of times this trap would trigger" but if
that's all the HW can provide then it is what it is.

Does the HW also count packets dropped because of overload / overflow
or some other event, or purely dropped because disabled?
