Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7AA6128FD
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 09:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJ3IP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 04:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3IP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 04:15:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AC7BCA7
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 01:15:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45EBB60B85
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 08:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245BEC433C1;
        Sun, 30 Oct 2022 08:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667117723;
        bh=AXLW3VEs10QPoP3+5PMQtqErNj1tbWr7aWFicPnND5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AxUu/9fiI7Fxc2V9iLQgDWytZjF+DwofdWAfpCI8JOzJSXv+XG4XLyoMjkogtodpy
         YE8ATk2RzpRUpSxtCEexWvVaEsb5kugEJSZwYvbCqGfB6mHpO0AWh+iIYHMQNbayrU
         N5ue2UmbEJRuB250Ean0aYFmM69lGfT9sPYiADaBLHQuGTKSKe6cEwJZ1gJGJZmNP2
         i0WeNGxCwYbQNtS7F8/ZrCpOEvmwnkyG4MyDdwxippdYCF3Jibw42yqCfSeGASvMfV
         X3XsNh2D2lJQ0UsVsSfqyz/aOKb3f6HcuqEZ4foxR3T0jO/loAVKwhnnnoLfjyZ64E
         tdjVWLEYk6eZA==
Date:   Sun, 30 Oct 2022 10:15:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2 4/5] macsec: fix detection of RXSCs when toggling
 offloading
Message-ID: <Y14yl0EFhTxuUZKs@unreal>
References: <cover.1666793468.git.sd@queasysnail.net>
 <0f3ab52fc5a5377c02e1f2dfc14a8d087f56124a.1666793468.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f3ab52fc5a5377c02e1f2dfc14a8d087f56124a.1666793468.git.sd@queasysnail.net>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 11:56:26PM +0200, Sabrina Dubroca wrote:
> macsec_is_configured incorrectly uses secy->n_rx_sc to check if some
> RXSCs exist. secy->n_rx_sc only counts the number of active RXSCs, but
> there can also be inactive SCs as well, which may be stored in the
> driver (in case we're disabling offloading), or would have to be
> pushed to the device (in case we're trying to enable offloading).
> 
> As long as RXSCs active on creation and never turned off, the issue is
> not visible.
> 
> Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  drivers/net/macsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
