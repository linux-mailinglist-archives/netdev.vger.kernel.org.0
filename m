Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1EA2BBC9A
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgKUDNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:13:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgKUDNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 22:13:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C87E9221FE;
        Sat, 21 Nov 2020 03:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605928380;
        bh=ZISbLObTtcdQpdOYcIgsn9FZhK4G4Pz1hjSqgyDW+R4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P1lcFv1KgsjZyc8gk7U2iip66sytABKCsaqU/Od5P64fTTF3zqzYXtQ587b1lN0ym
         qA5LENOWUSuAjwFlIszXfiOwXlvxkj2Q3grqMs+bNddVFMrIY4fbod5RIHdPzc64gK
         fGmCAEKInf0JjnrRRE+FLX9to73F/zQW2tHuFfFk=
Date:   Fri, 20 Nov 2020 19:12:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
Message-ID: <20201120191258.5c645fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119203446.20857-1-grygorii.strashko@ti.com>
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 22:34:46 +0200 Grygorii Strashko wrote:
> The mdio_bus may have dependencies from GPIO controller and so got
> deferred. Now it will print error message every time -EPROBE_DEFER is
> returned which from:
> __mdiobus_register()
>  |-devm_gpiod_get_optional()
> without actually identifying error code.
> 
> "mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"
> 
> Hence, suppress error message for devm_gpiod_get_optional() returning
> -EPROBE_DEFER case by using dev_err_probe().
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied (with the line wrapped), thanks!
