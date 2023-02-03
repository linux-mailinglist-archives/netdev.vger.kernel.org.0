Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4605068A329
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 20:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbjBCTm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 14:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjBCTm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 14:42:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748D69D076
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 11:42:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF3761FDE
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 19:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D408C4339B;
        Fri,  3 Feb 2023 19:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675453346;
        bh=TZJ34dFgqRWVTdpaFD2AC0EUub6GKCVUamtG1qVSiFo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ppQj4Yr0+nNApXMoioToRQEfDV9gBMfViUTdA1khmNF204dJvOyrRT3ReUD4THoXM
         uBN74c13VXRemhd9IBh7G4TT4TUD9uLK6lTjxgyiCGIuieEIZiDeI/btDHQv2SVlTT
         kUkdqv0oGK+mzNtFnCY1Lhtz2LHL+EOuV3cN88M212XKbPvhikpyUef0FgCnxEyVMm
         spnunTqtE2XP07uXYG6NI683pdb2qOs1R5U90SnRSL7lN5+jnsduXyvEj4f0oZvjo3
         WQ+zuM66IJEFmjTm9ytFKOZ2pxR1IgqAcNrWGOFuGLKfQGr7KjFskG39kvr0P6wB3L
         deL4jgQ+9SsJg==
Date:   Fri, 3 Feb 2023 11:42:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
Message-ID: <20230203114225.22ee17da@kernel.org>
In-Reply-To: <202302040329.E10xZHbY-lkp@intel.com>
References: <20230202185801.4179599-5-edumazet@google.com>
        <202302040329.E10xZHbY-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 Feb 2023 03:37:10 +0800 kernel test robot wrote:
> All errors (new ones prefixed by >>):
> 
>    net/core/skbuff.c: In function 'kmalloc_reserve':
> >> net/core/skbuff.c:503:23: error: 'KMALLOC_NOT_NORMAL_BITS' undeclared (first use in this function)  
>      503 |             !(flags & KMALLOC_NOT_NORMAL_BITS)) {
>          |                       ^~~~~~~~~~~~~~~~~~~~~~~
>    net/core/skbuff.c:503:23: note: each undeclared identifier is reported only once for each function it appears in

diff --git a/net/Kconfig b/net/Kconfig
index 27bc49c7ad73..41e27a4805a8 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -8,6 +8,7 @@ menuconfig NET
        select NLATTR
        select GENERIC_NET_UTILS
        select BPF
+       depends on !SLOB
        help
          Unless you really know what you are doing, you should say Y here.
          The reason is that some programs need kernel networking support even

? :)
