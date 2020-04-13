Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11701A61DE
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 06:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgDMEDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 00:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgDMEDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 00:03:45 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Apr 2020 21:03:46 PDT
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EBBC0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 21:03:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F04C6127AE20A;
        Sun, 12 Apr 2020 21:03:42 -0700 (PDT)
Date:   Sun, 12 Apr 2020 21:03:41 -0700 (PDT)
Message-Id: <20200412.210341.1711540878857604145.davem@davemloft.net>
To:     bp@alien8.de
Cc:     leon@kernel.org, kuba@kernel.org, leonro@mellanox.com,
        thomas.lendacky@amd.com, keyur@os.amperecomputing.com,
        pcnet32@frontier.com, vfalico@gmail.com, j.vosburgh@gmail.com,
        linux-acenic@sunsite.dk, mripard@kernel.org, heiko@sntech.de,
        mark.einon@gmail.com, chris.snook@gmail.com,
        linux-rockchip@lists.infradead.org, iyappan@os.amperecomputing.com,
        irusskikh@marvell.com, dave@thedillows.org, netanel@amazon.com,
        quan@os.amperecomputing.com, jcliburn@gmail.com,
        LinoSanfilippo@gmx.de, linux-arm-kernel@lists.infradead.org,
        andreas@gaisler.com, andy@greyhouse.net, netdev@vger.kernel.org,
        thor.thayer@linux.intel.com, linux-kernel@vger.kernel.org,
        ionut@badula.org, akiyano@amazon.com, jes@trained-monkey.org,
        nios2-dev@lists.rocketboards.org, wens@csie.org
Subject: Re: [PATCH] net/3com/3c515: Fix MODULE_ARCH_VERMAGIC redefinition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200411155623.GA22175@zn.tnic>
References: <20200224085311.460338-1-leon@kernel.org>
        <20200224085311.460338-4-leon@kernel.org>
        <20200411155623.GA22175@zn.tnic>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Apr 2020 21:03:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Sat, 11 Apr 2020 17:56:23 +0200

> From: Borislav Petkov <bp@suse.de>
> 
> Change the include order so that MODULE_ARCH_VERMAGIC from the arch
> header arch/x86/include/asm/module.h gets used instead of the fallback
> from include/linux/vermagic.h and thus fix:
> 
>   In file included from ./include/linux/module.h:30,
>                    from drivers/net/ethernet/3com/3c515.c:56:
>   ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC" redefined
>      73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
>         |
>   In file included from drivers/net/ethernet/3com/3c515.c:25:
>   ./include/linux/vermagic.h:28: note: this is the location of the previous definition
>      28 | #define MODULE_ARCH_VERMAGIC ""
>         |
> 
> Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
> Signed-off-by: Borislav Petkov <bp@suse.de>

I'm so confused, that commit in the Fixes: tag is _removing_ code but adding
new #include directives?!?!

Is vermagic.h really needed in these files?
