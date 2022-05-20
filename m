Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F8152E161
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344132AbiETAvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiETAvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:51:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31A1F5A2;
        Thu, 19 May 2022 17:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D32461AEA;
        Fri, 20 May 2022 00:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9369C385AA;
        Fri, 20 May 2022 00:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653007872;
        bh=ybmK5vsBhlES0JQuKQdtOj2k1nxl0e7pxO4zZYFt4c4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f+mbYMfkxPgaYuF5sUjvGL4Y1HMh5u5o5cIljLI2rqArSVcyr+16LSKDenAMaO1oR
         T7eX4KTrnrtZnKRWK6FftRxOSsXMcrhlrCvrFde0YQjCK2tJtDNAqoeTaQrCKTomS7
         VA/NS/Zs/b0cec7dd//ykvDkv1UfGtbEiSdQ41KJXAVmFKKwxFuPlEurs+SB84E9p5
         q8S71xfUgqwRK9OIEsrG0exQs0tL/OINXS1LmcEEoupa3mhNUpYdGx/tfUQHN4n2NQ
         o0B9E8tIwIsuatrIU/T5PuhnKHu2HXFidzF66VTQyfiVnUCVRlzdja8au3I2LY5iAb
         HDACK+9q29lfw==
Date:   Thu, 19 May 2022 17:51:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolaus Vladutescu-Zopp <nikolaus@vladutescu-zopp.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, blairuk@gmail.com,
        kai.heng.feng@canonical.com
Subject: Re: [PATCH] net: atlantic: Avoid out-of-bounds indexing
Message-ID: <20220519175110.4b9c0a45@kernel.org>
In-Reply-To: <f9fab445-e4f4-88c1-c9a3-0129af1ccf27@vladutescu-zopp.com>
References: <f9fab445-e4f4-88c1-c9a3-0129af1ccf27@vladutescu-zopp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 03:09:50 +0200 Nikolaus Vladutescu-Zopp wrote:
> A UBSAN warning is observed on atlantic driver:
> 
> [ 16.257086] UBSAN: array-index-out-of-bounds in 
> drivers/net/ethernet/aquantia/atlantic/aq_nic.c:1268:48
> [ 16.257090] index 8 is out of range for type 'aq_vec_s *[8]'
> 
> The index is assigned right before breaking out the loop, so there's no
> actual deferencing happening.
> So only use the index inside the loop to fix the issue.
> 
> Same issue was observed and corrected in two other places.
> 
> BugLink: https://bugs.launchpad.net/bugs/1958770
> Suggested-by: bsdz <blairuk@gmail.com>
> Suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Tested-by: Nikolaus Vladutescu-Zopp <nikolaus@vladutescu-zopp.com>
> Signed-off-by: Nikolaus Vladutescu-Zopp <nikolaus@vladutescu-zopp.com>

The patch does not apply, please rebase on net/master:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

and repost. Please use [PATCH net] as the subject prefix. Please add 
a Fixes tag, if possible. Please replace "bsdz" with the person's name
or remove that tag.
