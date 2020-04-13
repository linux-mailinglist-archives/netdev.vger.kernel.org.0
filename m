Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D51A62BA
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 07:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgDMFqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 01:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgDMFqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 01:46:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA989C0A3BE0;
        Sun, 12 Apr 2020 22:07:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C46A5127B6241;
        Sun, 12 Apr 2020 22:07:42 -0700 (PDT)
Date:   Sun, 12 Apr 2020 22:07:39 -0700 (PDT)
Message-Id: <20200412.220739.516022706077351913.davem@davemloft.net>
To:     leon@kernel.org
Cc:     bp@alien8.de, kuba@kernel.org, thomas.lendacky@amd.com,
        keyur@os.amperecomputing.com, pcnet32@frontier.com,
        vfalico@gmail.com, j.vosburgh@gmail.com, linux-acenic@sunsite.dk,
        mripard@kernel.org, heiko@sntech.de, mark.einon@gmail.com,
        chris.snook@gmail.com, linux-rockchip@lists.infradead.org,
        iyappan@os.amperecomputing.com, irusskikh@marvell.com,
        dave@thedillows.org, netanel@amazon.com,
        quan@os.amperecomputing.com, jcliburn@gmail.com,
        LinoSanfilippo@gmx.de, linux-arm-kernel@lists.infradead.org,
        andreas@gaisler.com, andy@greyhouse.net, netdev@vger.kernel.org,
        thor.thayer@linux.intel.com, linux-kernel@vger.kernel.org,
        ionut@badula.org, akiyano@amazon.com, jes@trained-monkey.org,
        nios2-dev@lists.rocketboards.org, wens@csie.org
Subject: Re: [PATCH] net/3com/3c515: Fix MODULE_ARCH_VERMAGIC redefinition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200413045555.GE334007@unreal>
References: <20200411155623.GA22175@zn.tnic>
        <20200412.210341.1711540878857604145.davem@davemloft.net>
        <20200413045555.GE334007@unreal>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Apr 2020 22:07:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 13 Apr 2020 07:55:55 +0300

> On Sun, Apr 12, 2020 at 09:03:41PM -0700, David Miller wrote:
>> From: Borislav Petkov <bp@alien8.de>
>> Date: Sat, 11 Apr 2020 17:56:23 +0200
>>
>> > From: Borislav Petkov <bp@suse.de>
>> >
>> > Change the include order so that MODULE_ARCH_VERMAGIC from the arch
>> > header arch/x86/include/asm/module.h gets used instead of the fallback
>> > from include/linux/vermagic.h and thus fix:
>> >
>> >   In file included from ./include/linux/module.h:30,
>> >                    from drivers/net/ethernet/3com/3c515.c:56:
>> >   ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC" redefined
>> >      73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
>> >         |
>> >   In file included from drivers/net/ethernet/3com/3c515.c:25:
>> >   ./include/linux/vermagic.h:28: note: this is the location of the previous definition
>> >      28 | #define MODULE_ARCH_VERMAGIC ""
>> >         |
>> >
>> > Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
>> > Signed-off-by: Borislav Petkov <bp@suse.de>
>>
>> I'm so confused, that commit in the Fixes: tag is _removing_ code but adding
>> new #include directives?!?!
>>
>> Is vermagic.h really needed in these files?
> 
> You are completely right, it is not needed at all in those files.

Ok let's just remove it to fix this.
