Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF846128FB
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 09:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiJ3INx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 04:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiJ3INs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 04:13:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD896C51
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 01:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67F6360B85
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 08:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456C7C433D6;
        Sun, 30 Oct 2022 08:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667117617;
        bh=YNz5TicDPsIf7vJugktzhLI9Gxjh6oIrZmPTEzhGvmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DEooBL2byzih/eHtGIxf4O8Y4Nvn5g+sjVo6vVRcusmEOKJNGASWifE8Tnuku5kUg
         2Rmz/h8Nml7UBR+ElIDYtoMUYmFpnuKEgaQMHKY7Q+ijsqxet/hn2lomb/OJbvmNIB
         gCPU1IFLGqWsoBvAx+gIG8NyNCg80yIi7tGy0y3vVDIb/bU9USegLJmDcNvPEo59ys
         IucRzCJ9+HYuyd5pqIcY7W+igNc30NyHLkSCe9w6yzE2dGmr+C8D+v29etppQf1D88
         uuWHC0gl4Fbw++cZenv/0u3YG9MmiVCF/UFxjQfiRK3DyvbyBvWwX1bu6wPc9AWyyG
         VYCk7MlNsGIQA==
Date:   Sun, 30 Oct 2022 10:13:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2 2/5] macsec: delete new rxsc when offload fails
Message-ID: <Y14yLfoacI314Js2@unreal>
References: <cover.1666793468.git.sd@queasysnail.net>
 <54e5c16b2ffb7db1fac0c1f2360e7a332c115364.1666793468.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e5c16b2ffb7db1fac0c1f2360e7a332c115364.1666793468.git.sd@queasysnail.net>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 11:56:24PM +0200, Sabrina Dubroca wrote:
> Currently we get an inconsistent state:
>  - netlink returns the error to userspace
>  - the RXSC is installed but not offloaded
> 
> Then the device could get confused when we try to add an RXSA, because
> the RXSC isn't supposed to exist.
> 
> Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  drivers/net/macsec.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
