Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432BF533091
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbiEXSjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiEXSjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:39:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23C3590AF
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 11:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9608361521
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 18:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97C6C34100;
        Tue, 24 May 2022 18:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653417542;
        bh=2flM1Zz7Z8Xbxe2lBPsYMmkT60CbAV2rF0WuKna0gm8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tOtSrXAor+iJWPNchbR26TLzKJXTLsBrSnIrLp1YwROIJbEyMxah0ltiUfHM6irLN
         uCupE8okGWwZm2hRX1s2Jos5WZxc2mmb98aU0K8TJI2ZFxHH1t+I7qYvJmvmiP6Ksp
         4n512AdtCJg2o8cJABC6S+SD9S7VxPzS8H6lJP3ywwi6e5zMy6ngxCIyn91oj6y8J8
         6HT0sc1eoXwX9HPwva1pA3SwQY2IHzaGVxhLpW/o7yLdcnZhxCOUB0PkydMmZy0YaC
         Jbq2c07aNDMdBfmcR48/f2qb1m6BIetxzICrReJupRv51VcwtdGHoJiTexsCztIbU0
         PzUmQtMYevWpQ==
Date:   Tue, 24 May 2022 11:39:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net 0/3] dpaa2-eth: software TSO fixes
Message-ID: <20220524113900.0412e086@kernel.org>
In-Reply-To: <20220522125251.444477-1-ioana.ciornei@nxp.com>
References: <20220522125251.444477-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 May 2022 15:52:48 +0300 Ioana Ciornei wrote:
> This patch fixes the software TSO feature in dpaa2-eth.
> 
> There are multiple errors that I made in the initial submission of the
> code, which I didn't caught since I was always running with passthough
> IOMMU.
> 
> The bug report came in bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=215886
> 
> The bugs are in the Tx confirmation path, where I was trying to retrieve
> a virtual address after DMA unmapping the area. Besides that, another
> dma_unmap call was made with the wrong size.

Thanks for the fixes! FTR it's been applied as commit 7e4d1c237592
("Merge branch 'dpaa2-swtso-fixes'") to net on Sunday.
