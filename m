Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473A96B1C67
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCIHda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCIHc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:32:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB0C62845;
        Wed,  8 Mar 2023 23:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 192E060989;
        Thu,  9 Mar 2023 07:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159ECC4339E;
        Thu,  9 Mar 2023 07:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347157;
        bh=qfxFR1LeU7oUcjdQOV31yRXlpmRSxvC7HGBT2wxUQ00=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f+80O32z03E2wzsou1RC3VdVj1sYldoCIDaLWASjWX7gs4AMjKbsOkK+8mbrtlKHx
         q7CH+5K/vfsa7WpwUqEeVr+tF1wPSI3buHXtPdqJFKPV1z8GrxnUe+0eEdfEhjPIP0
         c+dZjmI4b1QsEJpx3P9dBE9PR4q/IxG6iLk1cwcOOqkizzIlVK/5ODqX9ySeX1i1Aq
         436CFZzFdDTY6xim9iS0s2Ts9dTQ2bzc9I4ag9mNz/ul2mwsRlx2LzyxGhz2xzQZyl
         d1p1PUJaqD42JSQ38JSaj2ceb4Z2EQh5LwkbdLbPTVCOyO91bsEpGEtBd4hpakc7cP
         KWUhzHNreACXQ==
Date:   Wed, 8 Mar 2023 23:32:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, sgoutham@marvell.com, toke@redhat.com,
        teknoraver@meta.com, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <20230308233236.41ff3fd2@kernel.org>
In-Reply-To: <03095151-3659-0b1b-8e67-a416b8eafa2b@gmail.com>
References: <cover.1678200041.git.lorenzo@kernel.org>
        <8857cb8138b33c8938782e2154a56b095d611d18.1678200041.git.lorenzo@kernel.org>
        <c2d13e84-2c30-d930-37a4-4e984b85a0e4@gmail.com>
        <ZAiuKRDqQ+1cQb2J@lore-desk>
        <03095151-3659-0b1b-8e67-a416b8eafa2b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Mar 2023 09:23:10 +0200 Tariq Toukan wrote:
> > Hi Tariq,
> > 
> > I am fine to repost this series for net instead of net-next. Any downsides about
> > it?  
> 
> Let's repost to net.
> It's a fixes series, and 6.3 is still in its RCs.
> If you don't post it to net then the xdp-features in 6.3 will be broken.

minor heads up - patch 2 will now apply to lib/nlspec.py
I just moved the enum classes there as part of another fix
but the code and the changes should be identical
