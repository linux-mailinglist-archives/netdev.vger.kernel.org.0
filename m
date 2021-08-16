Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DCA3ED9A0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhHPPNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232237AbhHPPNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 11:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF60C606A5;
        Mon, 16 Aug 2021 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629126795;
        bh=muWpwxiPhJ0hjPwwuNj9+N7/JqofNLtCZB6kojrL6O4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OgBGiX9S+ojRVF6ymbchD+MaZLos9l+7IKvRZukSGyd3xxSB9MIpTac3kT3r7L8gA
         43u5XNEiremTDBTRr859MBB4helMXhLltsEGpbk3Jht07K1qapQmIXnIMovG9oa+Fm
         LNH5Afj2JUYKu9LRhtoah3z2QSJ3LJCBzRKN+FJgZs9AsRMKiCb4itw7y8rzjRU319
         SdY2IyeB4otPtWKRT1j6L7XisG5ni38AoxeIzXDY+3A2UoQo2oOZmx1n9heoGH2UI5
         3J6aNSu02cl+VR5VUDQVZxNHP8V8FYI7oLh77YGE36E6/12syBbHWwwnvWWidLeRP1
         FdvscxNxT+5Gw==
Date:   Mon, 16 Aug 2021 08:13:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression with commit e532a096be0e ("net: usb: asix: ax88772:
 add phylib support")
Message-ID: <20210816081314.3b251d2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3904c728-1ea2-9c2b-ec11-296396fd2f7e@linux.intel.com>
References: <3904c728-1ea2-9c2b-ec11-296396fd2f7e@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 17:55:34 +0300 Jarkko Nikula wrote:
> Hi
> 
> Our ASIX USB ethernet adapter stopped working after v5.14-rc1. It 
> doesn't get an IP from DHCP.
> 
> v5.13 works ok. v5.14-rc1 and today's head 761c6d7ec820 ("Merge tag 
> 'arc-5.14-rc6' of 
> git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc") show the 
> regression.
> 
> I bisected regression into e532a096be0e ("net: usb: asix: ax88772: add 
> phylib support").

Oleksij, any comments?

> Here's the dmesg snippet from working and non-working cases:
> 
> OK:
> [    6.115773] asix 1-8:1.0 eth0: register 'asix' at usb-0000:00:14.0-8, 
> ASIX AX88772 USB 2.0 Ethernet, 00:10:60:31:d5:f8
> [    8.595202] asix 1-8:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0xC1E1
> 
> NOK:
> [    6.511543] asix 1-8:1.0 eth0: register 'asix' at usb-0000:00:14.0-8, 
> ASIX AX88772 USB 2.0 Ethernet, 00:10:60:31:d5:f8
> [    8.518219] asix 1-8:1.0 eth0: Link is Down
> 
> lsusb -d 0b95:7720
> Bus 001 Device 002: ID 0b95:7720 ASIX Electronics Corp. AX88772
