Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024EB4644CC
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhLACTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:19:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48020 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhLACTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:19:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DEBEB817B3
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 02:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62BFC53FCB;
        Wed,  1 Dec 2021 02:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638324943;
        bh=9CoCpmP2xcr9ach2tDUxopmD9l01ww/Ysm/ERKwEpDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TCMCZfoG89EU4OntrWqv0TgWGS6Z70klgL5ViQtZFgfVzi/42/FtmvwqtvEDrh90J
         A56Mm7T5V6xqK5zVP1mgam8dEEjk8euOb6XbbCjrkXLMBjG0+luIf4VTZdITzj19IT
         rpHoRAqIVV0zHvcF4lkv+cRbGQoSTHk8jfgpE5Kqixu5CSgfDsqzfcuAyslQVfToAv
         3R4IaYoEHG9Ewd0Gk8F/UHba3VcJlYpKk+HUBOFoxjf3OisxCSze3o2lTXoeqciXPb
         1f2zkYYM9tBPPfrCQbGfZNdWBEUj00/El0XP8SeWemA2eN97VUfoX18ymNt9cmr0tG
         2aBuMobGuwD2w==
Date:   Tue, 30 Nov 2021 18:15:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Finn Thain <fthain@telegraphics.com.au>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/2 -net] natsemi: xtensa: fix section mismatch warnings
Message-ID: <20211130181541.2407bea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130063947.7529-1-rdunlap@infradead.org>
References: <20211130063947.7529-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 22:39:47 -0800 Randy Dunlap wrote:
> Fix section mismatch warnings in xtsonic. The first one appears to be
> bogus and after fixing the second one, the first one is gone.
> 
> WARNING: modpost: vmlinux.o(.text+0x529adc): Section mismatch in reference from the function sonic_get_stats() to the function .init.text:set_reset_devices()
> The function sonic_get_stats() references
> the function __init set_reset_devices().
> This is often because sonic_get_stats lacks a __init 
> annotation or the annotation of set_reset_devices is wrong.
> 
> WARNING: modpost: vmlinux.o(.text+0x529b3b): Section mismatch in reference from the function xtsonic_probe() to the function .init.text:sonic_probe1()
> The function xtsonic_probe() references
> the function __init sonic_probe1().
> This is often because xtsonic_probe lacks a __init 
> annotation or the annotation of sonic_probe1 is wrong.
> 
> Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>

Applied this one to net and I'll take Max's patch for dev_addr 
to net-next. Thanks!
