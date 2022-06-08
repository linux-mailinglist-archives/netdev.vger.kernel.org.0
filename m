Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D64543B02
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiFHSB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbiFHSBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DD51D08A4;
        Wed,  8 Jun 2022 11:01:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A312C61B4C;
        Wed,  8 Jun 2022 18:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85A6C3411D;
        Wed,  8 Jun 2022 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654711278;
        bh=ouTWCQV2FJOU0tYVG2Vo0naFeodFz3HUPrKg1MuC5Bg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oo+Y0vtluQ9zhBDQRiYPK1PY6K9gpG9m57+wdsaCpDwNZJwF7YRyA7qhRJGIRcuYd
         TSHDTZhAPWju7PPejSRgTgi63T4Y4Q1B/MpfYEmZ9CC46R1vSpwRKOsPQLl/B3rCuI
         fj2JxK9UYKXzQdZDCLQ+OlXXLeCgXi1/l87xowxwnJmjUFL5GUB+0dIkNoarkGK1Cp
         PwY1f6ZB/2FDa4Ou8b0XNwPeglOFeTY4RIk5DNOq/JVLpgoXLmRewREwpERjUbyeWq
         jnq1lg+TY9MEiPN8iP5hVHrbZIt4MuAlcoZFfPT0BB/155ryrYdL7Ee7KhD+ybxviD
         gB4wDejHSCpcQ==
Date:   Wed, 8 Jun 2022 11:01:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Manuel Lauss <manuel.lauss@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] au1000_eth: stop using virt_to_bus()
Message-ID: <20220608110116.12e5c2e6@kernel.org>
In-Reply-To: <20220607090206.19830-1-arnd@kernel.org>
References: <20220607090206.19830-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jun 2022 11:01:46 +0200 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The conversion to the dma-mapping API in linux-2.6.11 was incomplete
> and left a virt_to_bus() call around. There have been a number of
> fixes for DMA mapping API abuse in this driver, but this one always
> slipped through.
> 
> Change it to just use the existing dma_addr_t pointer, and make it
> use the correct types throughout the driver to make it easier to
> understand the virtual vs dma address spaces.
> 
> Cc: Manuel Lauss <manuel.lauss@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Hi Arnd, this can go via net-next, right? The changes are simple
enough, we can try to slip them into -rc2 if necessary.
