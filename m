Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38831FD3
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 17:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfFAPqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 11:46:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47608 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfFAPqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 11:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Le7XEY/SG60C8ZFYKif432rlXzz1A6DNCSTm2EuTYKE=; b=H7FejLlTQd6Lnqwv2VY874sdM7
        t83e4yHooepAu0t7iQnpIcZSeCB6WEowsDpBeefEn5kZUeoQs7otj3lsNa4IDD7c541lQwM1CU37f
        3TqCtm6cjDnoZGySUCB7hZH1aqlsH/2+4WJAORFZ/aziqo5yh5eQfuEWy8vSHlaooupM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hX6DM-000527-Ey; Sat, 01 Jun 2019 17:46:36 +0200
Date:   Sat, 1 Jun 2019 17:46:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     hancock@sedsystems.ca
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: phy: Ensure scheduled work is cancelled
 during removal
Message-ID: <20190601154636.GA19081@lunn.ch>
References: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
 <1559330150-30099-2-git-send-email-hancock@sedsystems.ca>
 <20190531205421.GC3154@lunn.ch>
 <49e18fde-5ac4-22ad-90ec-0cbad64d743a@gmail.com>
 <8fc39ed123aede7ab23954ba06ff4cd5.squirrel@intranet.sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fc39ed123aede7ab23954ba06ff4cd5.squirrel@intranet.sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 09:22:16PM -0600, hancock@sedsystems.ca wrote:
> > On 31.05.2019 22:54, Andrew Lunn wrote:
> >>> It is possible that scheduled work started by the PHY driver is still
> >>> outstanding when phy_device_remove is called if the PHY was initially
> >>> started but never connected, and therefore phy_disconnect is never
> >>> called. phy_stop does not guarantee that the scheduled work is stopped
> >>> because it is called under rtnl_lock. This can cause an oops due to
> >>> use-after-free if the delayed work fires after freeing the PHY device.
> >>>
> > The patch itself at least shouldn't do any harm. However the justification
> > isn't fully convincing yet.
> > PHY drivers don't start any scheduled work. This queue is used by the
> > phylib state machine. phy_stop usually isn't called under rtnl_lock,
> > and it calls phy_stop_machine that cancels pending work.
> > Did you experience such an oops? Can you provide a call chain where
> > your described scenario could happen?
> 
> Upon further investigation, it appears that this change is no longer
> needed in the mainline. Previously (such as in 4.19 kernels as we are
> using),

Hi Robert

Please do all your testing on net-next. 4.19 is dead, in terms of
development. There is no point in developing and testing on it patches
intended for mainline.

     Andrew
