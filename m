Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE1826258D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgIIDB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgIIDB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:01:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9164C061573;
        Tue,  8 Sep 2020 20:01:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 198A911E3E4C3;
        Tue,  8 Sep 2020 19:45:09 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:01:55 -0700 (PDT)
Message-Id: <20200908.200155.947354902085868278.davem@davemloft.net>
To:     yoshihiro.shimoda.uh@renesas.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, Jisheng.Zhang@synaptics.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] net: phy: call phy_disable_interrupts() in
 phy_attach_direct() instead
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1599564440-8158-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1599564440-8158-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:45:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Tue,  8 Sep 2020 20:27:20 +0900

> @@ -1423,6 +1419,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  	if (err)
>  		goto error;
>  
> +	ret = phy_disable_interrupts(phydev);
> +	if (ret)
> +		return ret;
> +

How did you test this?

I am very serious.

There is no 'ret' variable in this function, you do not add one, and
therefore this does not even compile.

If you are patching against a different tree than the networking GIT
tree, that is a major mistake as well.

That also is why it is very important to specify the destination GIT
tree in your subject line such as "[PATCH net]" or "[PATCH net-next]".

Thank you.
