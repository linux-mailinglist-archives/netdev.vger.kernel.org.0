Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE0D453EA7
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 03:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhKQCyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 21:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhKQCyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 21:54:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0AD61B73;
        Wed, 17 Nov 2021 02:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637117506;
        bh=DnHVrGE1X8Bru+OWag+cxpQmAf1N6UOQoBQssEVOADg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wr0S2vWJ4HUULoYCnmWxnk2eqNhdr5XoT/Y58XBTkjTKgkKV2PkOxPPszzjBWNjiv
         yEmx8si7sybsFnFKoKXgP9kv5xShm19w2AFhjjus/wL2bbeYS+p2QpfEMDel6K6jBX
         hRIByPBDPSIrqIV6eorxcgBSOC49DOlBtPDbzcA808/YDzNxACMiLv3HtjWlpO/CA8
         nrRROzP6pkUjZuKpkuyhgRWNAz2wl44l2lmsckwQXJiqUh6O5WPx3Jo5wnacq8J42X
         BlMPBr35Q5o/1Cc4hZtKGiEV0+/rmFS9yECBOEHN9OWUpFy7A7041cjIB2nN9DBSre
         9Bbdx7X2RV+5Q==
Date:   Tue, 16 Nov 2021 18:51:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Set __LINK_STATE_NOCARRIER in register_netdevice() ?
Message-ID: <20211116185145.4ee927d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <82793a62-054b-75e1-d302-74375f61ae03@gmail.com>
References: <82793a62-054b-75e1-d302-74375f61ae03@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 21:47:21 +0100 Heiner Kallweit wrote:
> Quite some network drivers call netif_carrier_off() in their probe() function.
> So I'm wondering whether we can/should add a
> set_bit(__LINK_STATE_NOCARRIER, &dev->state)
> to register_netdevice() and remove all these netif_carrier_off() calls.
> 
> Question is whether there's any scenario where a driver would depend on bit
> __LINK_STATE_NOCARRIER being cleared after registering the netdevice
> or where we want to preserve the state of this bit.

I thought that conversely many sw devices never touch carrier, hence
letting it remain up with operstate unknown. We'd be changing that,
dunno if it matters.
