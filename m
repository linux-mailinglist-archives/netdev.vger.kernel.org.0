Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C07A4B7BFC
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245140AbiBPAgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:36:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242156AbiBPAf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:35:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C2F27B33
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2F8C616A6
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9A8C340EB;
        Wed, 16 Feb 2022 00:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644971747;
        bh=3H6V2xmg5Wyun0Mib/YWU6Gz017vV/Ayea3Jum5uqQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YjrLn8h1oL3F7JAXKNjSRpgH3EQjB3dhY07zF9Vxw5sgVqrthc6T/6Tjw5GkbSXiC
         C4/NyApy7wqBklq7aGxLxJQbNBAFTXsV8m4X4XR/Jp+YSj4PUQdDOIuP3aD/8Yocwm
         Bap42JhzkuIyn2yTWpMGUTtouMgYA/5OeCfXCODNBBgmyz1jjc4CjMule/GmcaviP3
         mSkuThP890n/b+6SLm7sKnORZRJkEicv5Dqs3DT7sTCdc4tZ52meP/BMT30JYV/HG9
         c7qhNfT1K/gHcza1VwqN8WhgEA7uKMX8QaGIK1Vo0J9+sUkoUnDITjtnz+CDw5mB+M
         H0LzgciuRO5MA==
Date:   Tue, 15 Feb 2022 16:35:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [Bug 215610] New: eth0 not working after upgrade from 5.16.8 to
 5.16.9
Message-ID: <20220215163545.0a421b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220215152233.2c15de26@hermes.local>
References: <20220215152233.2c15de26@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 15:22:33 -0800 Stephen Hemminger wrote:
> Begin forwarded message:
> 
> Date: Tue, 15 Feb 2022 16:24:06 +0000
> From: bugzilla-daemon@kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 215610] New: eth0 not working after upgrade from 5.16.8 to 5.16.9
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=215610
> 
>             Bug ID: 215610
>            Summary: eth0 not working after upgrade from 5.16.8 to 5.16.9
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.16.9
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: joerg.sigle@jsigle.com
>         Regression: No
> 
> After rebooting with kernel 5.16.9, the eth0 connection did not work any more.
> 
> The interface is shown in ifconfig, but ping or other services don't reach any
> machines in the LAN or in the internet.
> 
> I've not done much research but went back to 5.16.8 which works well again.
> 
> In 5.16.8, lspci shows:
> 
> 00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I217-LM (rev
> 04)
>         Subsystem: Lenovo Ethernet Connection I217-LM
>         Flags: bus master, fast devsel, latency 0, IRQ 33
>         Memory at b4a00000 (32-bit, non-prefetchable) [size=128K]
>         Memory at b4a3e000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at 5080 [size=32]
>         Capabilities: [c8] Power Management version 2
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [e0] PCI Advanced Features
>         Kernel driver in use: e1000e

There's nothing in there:

$ git log v5.16.8..v5.16.9 -- drivers/net/ethernet/intel/
$ git log v5.16.8..v5.16.9 -- net/
commit 59ff7514f8c56f166aadca49bcecfa028e0ad50f
Author: Jon Maloy <jmaloy@redhat.com>
Date:   Sat Feb 5 14:11:18 2022 -0500

    tipc: improve size validations for received domain records
    
    commit 9aa422ad326634b76309e8ff342c246800621216 upstream.
    
    The function tipc_mon_rcv() allows a node to receive and process
    domain_record structs from peer nodes to track their views of the
    network topology.
    
    This patch verifies that the number of members in a received domain
    record does not exceed the limit defined by MAX_MON_DOMAIN, something
    that may otherwise lead to a stack overflow.
    
    tipc_mon_rcv() is called from the function tipc_link_proto_rcv(), where
    we are reading a 32 bit message data length field into a uint16.  To
    avert any risk of bit overflow, we add an extra sanity check for this in
    that function.  We cannot see that happen with the current code, but
    future designers being unaware of this risk, may introduce it by
    allowing delivery of very large (> 64k) sk buffers from the bearer
    layer.  This potential problem was identified by Eric Dumazet.
    
    This fixes CVE-2022-0435
    
    Reported-by: Samuel Page <samuel.page@appgate.com>
    Reported-by: Eric Dumazet <edumazet@google.com>
    Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
    Signed-off-by: Jon Maloy <jmaloy@redhat.com>
    Reviewed-by: Xin Long <lucien.xin@gmail.com>
    Reviewed-by: Samuel Page <samuel.page@appgate.com>
    Reviewed-by: Eric Dumazet <edumazet@google.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
