Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E8B588F82
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiHCPh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiHCPh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:37:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5501E17E26;
        Wed,  3 Aug 2022 08:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14CB4B822F6;
        Wed,  3 Aug 2022 15:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D397C433D6;
        Wed,  3 Aug 2022 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659541072;
        bh=GHmzcEzls5klyKLwUyWObZhTtEcXbiA85OnD3ToG7BU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a7J/j/Gp8n9WPXKinkJws/kSgedaN+9ZBGYF622x25hXe/9zNDVWJSMHHB0i2Hve4
         mhgsa7jfBVEqUEFx8nRLnxwAoi81NZRgjHTRTqgf6UGEWwmTC1Iblwu/gK99Zs2xWP
         V5MCVntkDA25m6mMSAlqpSGqh+fETN/zP9YGsiLRhXhvSlhJmevlWs2ULZm2gmVE2q
         XlInTZAmWwZHshWXYBirz5V/rxz1ugSp8zYFMqom/ylWkM31rL5Rjh5N2dsHOSeRYO
         GUhBhBtv5E9YsBQ0HeXH5izYLyxAtr94sD4gWZWlG3gekdFX4L22/OtbFUL2yEohKq
         h4fV+hBtjHmug==
Date:   Wed, 3 Aug 2022 08:37:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bruno Goncalves <bgoncalv@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Subject: Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
Message-ID: <20220803083751.40b6ee93@kernel.org>
In-Reply-To: <CA+QYu4ob4cbh3Vnh9DWgaPpyw8nTLFG__TbBpBsYg1tWJPxygg@mail.gmail.com>
References: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
        <20220802122356.6f163a79@kernel.org>
        <CA+QYu4ob4cbh3Vnh9DWgaPpyw8nTLFG__TbBpBsYg1tWJPxygg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Aug 2022 14:13:00 +0200 Bruno Goncalves wrote:
> Got this from the most recent failure (kernel built using commit 0805c6fb39f6):
> 
> the tarball is https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/603714145/build%20x86_64%20debug/2807738987/artifacts/kernel-mainline.kernel.org-redhat_603714145_x86_64_debug.tar.gz
> and the call trace from
> https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/08/02/redhat:603123526/build_x86_64_redhat:603123526_x86_64_debug/tests/1/results_0001/console.log/console.log
> 
> [   69.876513] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> [   69.888521] Hardware name: HPE ProLiant DL325 Gen10 Plus/ProLiant
> DL325 Gen10 Plus, BIOS A43 08/09/2021
> [   69.897971] RIP: 0010:qede_load.cold
> (/builds/2807738987/workdir/./include/linux/spinlock.h:389
> /builds/2807738987/workdir/./include/linux/netdevice.h:4294
> /builds/2807738987/workdir/./include/linux/netdevice.h:4385
> /builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_main.c:2594
> /builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_main.c:2575)

Thanks a lot! That seems to point the finger at commit 3aa6bce9af0e
("net: watchdog: hold device global xmit lock during tx disable") but
frankly IDK why... The driver must be fully initialized to get to
ndo_open() so how is the tx_global_lock busted?!

Would you be able to re-run with CONFIG_KASAN=y ?
Perhaps KASAN can tell us what's messing up the lock.
