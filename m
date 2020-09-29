Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEB427D48B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgI2RdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgI2RdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:33:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149E12075F;
        Tue, 29 Sep 2020 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601400802;
        bh=m6oxV0zqVazhzz7aoElFzmOzlt668dRt923DNwCJ80c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TxUJoqd+k5FcQJhyRT4FgG+76xxaOvCl9SduEcF7mAqgF9MobFuEcuPLrr7UOD+Jy
         aS+a/C3Vvhx1OqemGqPFfrCHpkQjCVHFjgli+H1XswDviEuqUPumc0QRkY1/nGajLH
         AOls9MwldnoaFLQrbVlSTfhXIZT37Bh0tEIS5sLM=
Date:   Tue, 29 Sep 2020 10:33:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] net: atlantic: phy tunables from mac
 driver
Message-ID: <20200929103320.6a5de6f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929170413.GA3996795@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
        <20200929170413.GA3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 19:04:13 +0200 Andrew Lunn wrote:
> On Tue, Sep 29, 2020 at 07:13:04PM +0300, Igor Russkikh wrote:
> > This series implements phy tunables settings via MAC driver callbacks.
> > 
> > AQC 10G devices use integrated MAC+PHY solution, where PHY is fully controlled
> > by MAC firmware. Therefore, it is not possible to implement separate phy driver
> > for these.
> > 
> > We use ethtool ops callbacks to implement downshift and EDPC tunables.  
> 
> Hi Michal
> 
> Do you have any code to implement tunables via netlink?
> 
> This code is defining new ethtool calls. It seems like now would be a
> good time to plumb in extack, so the driver can report back the valid
> range of a tunable when given an unsupported value.

Do you mean report supported range via extack? Perhaps we should have 
a real API for that kind of info? We can plumb it through to the core
for now and expose to user space once netlink comes.
