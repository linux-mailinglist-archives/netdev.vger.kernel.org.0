Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA37637741
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiKXLMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiKXLMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:12:12 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029AC6F0CD
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 03:12:10 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2AOBC3ko1138226;
        Thu, 24 Nov 2022 12:12:03 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2AOBC3ko1138226
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1669288323;
        bh=COaQaBpQPB4lFYCDp3h463KKL+fDBXURxPrDXxX/XrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aaXdnRvQQZ2E1i8u/SLttGJZLASbt++ZDmo7Ryf10jNSgDfNef0jy4g8LNQ0IYmDU
         NIP0mb2AfSq4KIG2KDJdXWQzouIKi5K2/4a9p+NnLXKv8lf5MyUS8dV+WiH7n52652
         pjJNjInA6YlMDde4uS4xOgvfXn4GhnetwUJHgr2M=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2AOBC3Te1138225;
        Thu, 24 Nov 2022 12:12:03 +0100
Date:   Thu, 24 Nov 2022 12:12:03 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Ioannis Barkas <jnyb.de@gmail.com>
Cc:     netdev@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>
Subject: Re: BCM4401 LAN
Message-ID: <Y39Rg+zgpUh0AIwB@electric-eye.fr.zoreil.com>
References: <CADUzMVYi2no7rH9Va3SjWCJr-OhH3_s0fO0oZKo2FbT2g8aKyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUzMVYi2no7rH9Va3SjWCJr-OhH3_s0fO0oZKo2FbT2g8aKyA@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,SUBJ_ALL_CAPS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(MAINTAINERS file suggests to Cc: Michael Chan Cced as b44 maintainer)

Ioannis Barkas <jnyb.de@gmail.com> :
[...]
> I resurrected some old PCs at job and found one with BCM4401 LAN. This
> LAN had some issues as I read in various OSes so I gave it a try using
> live Ubuntu 22.10. It worked fine though I got this when I plugged in
> the Ethernet cable:
> [  517.928052] b44 ssb0:0 eth0: Link is up at 100 Mbps, full duplex
> [  517.928066] b44 ssb0:0 eth0: Flow control is off for TX and off for RX
> [  517.928246] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [  520.697405] ------------[ cut here ]------------
> [  520.697417] b44 0000:0a:0b.0: DMA addr 0x00000000766d9402+42
> overflow (mask 3fffffff, bus limit 0).
> [  520.697438] WARNING: CPU: 1 PID: 1187 at kernel/dma/direct.h:97
> dma_direct_map_page+0x1f1/0x200
> [  520.697456] Modules linked in: ntfs3 snd_seq_dummy snd_hrtimer
> binfmt_misc zfs(PO) zunicode(PO) zzstd(O) zlua(O) zavl(PO) icp(PO)
> zcommon(PO) znvpair(PO) spl(O) snd_intel8x0 snd_ac97_codec ac97_bus
[...]
> This is the LAN device:
> 0a:0b.0 Ethernet controller [0200]: Broadcom Inc. and subsidiaries
> BCM4401-B0 100Base-TX [14e4:170c] (rev 02)
>     Subsystem: Lenovo BCM4401-B0 100Base-TX [17aa:1004]
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 32
>     Interrupt: pin A routed to IRQ 23
>     Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=8K]
>     Capabilities: [40] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
>     Kernel driver in use: b44
>     Kernel modules: b44
[...]
> Does anything look awfully wrong in the trace?

See kernel/dma/direct.c::dma_direct_map_resource for a WARN_ON_ONCE
message related to the comment below in drivers/net/ethernet/broadcom/b44.c

static netdev_tx_t b44_start_xmit(struct sk_buff *skb, struct net_device *dev)
[...]
        mapping = dma_map_single(bp->sdev->dma_dev, skb->data, len, DMA_TO_DEVICE);
        if (dma_mapping_error(bp->sdev->dma_dev, mapping) || mapping + len > DMA_BIT_MASK(30)) {
                struct sk_buff *bounce_skb;

                /* Chip can't handle DMA to/from >1GB, use bounce buffer */
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
                        dma_unmap_single(bp->sdev->dma_dev, mapping, len, 
                                             DMA_TO_DEVICE);

It's a bit less than optimal performance-wise but it is expected to work.

This one was rather trivial but please avoid requests related to giant
out-of-tree (zfs) module tainted kernel in the future.

-- 
Ueimor
