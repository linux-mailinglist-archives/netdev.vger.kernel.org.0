Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFC06E871A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjDTBC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjDTBCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2BB2735
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1615E64432
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F778C433EF;
        Thu, 20 Apr 2023 01:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681952543;
        bh=ICTvquqhs6Dt4oK6/56GKOISWfGaqNwu7NKcDmDW6x4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U2CiCddM6WYcrFYT0kXcNmhbzGtyK44SjYPPq4GJiy2WIEppJ4YbyKgKhsZ+S+wTv
         xXYPKsjpxGwo9tRhG+/emtxV2QfBHVcHcB0Tt3qROcgQlulJ92wUJu+kfH8Cm3F++L
         JGXpdusmm/pI0nYJVgsmOXgy5Cvp7dz3YfziCASlmx2yJS3p7QXTaaBZrjytK5SXKo
         PkdkJ+cz0CZmc4VVnN0iHsRYQ6LopeTicp4EYt7r1KntY1c5ndS/4wX3J/N7QA+9MM
         mCIw5//CjxdTUecq48FFy9IDzQR3rBiUSxVzuwch3B+9EJwT/TelPYAehUNOJb+2y2
         e44v78yoqiJtQ==
Date:   Wed, 19 Apr 2023 18:02:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     daire.mcnamara@microchip.com, nicholas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        conor.dooley@microchip.com
Subject: Re: [PATCH v2 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on
 mpfs
Message-ID: <20230419180222.07d78b8a@kernel.org>
In-Reply-To: <ZD6pCdvKdGAJsN3x@corigine.com>
References: <20230417140041.2254022-1-daire.mcnamara@microchip.com>
        <20230417140041.2254022-2-daire.mcnamara@microchip.com>
        <ZD6pCdvKdGAJsN3x@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 16:28:25 +0200 Simon Horman wrote:
> no need to refresh the patch on my account.
> But can the above be simplified as:
> 
>                if (macb_is_gem(bp) && hw_is_gem(bp->regs, bp->native_io))
>                        bp->max_tx_length = macb_config->max_tx_length;
>                else
>                        bp->max_tx_length = MACB_MAX_TX_LEN;

I suspect that DaveM agreed, because patch is set to Changes Requested
in patchwork :) 

Daire, please respin with Simon's suggestion.
