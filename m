Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1743633B77
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiKVLfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiKVLec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:34:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB126314D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFEB9B81A29
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DA8C433D6;
        Tue, 22 Nov 2022 11:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669116548;
        bh=HIeb1miepSI+2beteNcMmbvxY+NUbGb7OayzFNRvk8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qSfpoiK0S0+gEk71RX7WkY5clz3eVLnwTUPcsIuHT1VYVArwa8BMCSmUSVEdIWQrE
         VAIumdXSJSAX7yiJD751qF4VfoKLASXF42GJ5r8gq02NYqZjrPjwnlpgtBile+cnoP
         jYQVslCOeNAn701sy9F7bou3tsEGMd6U4VqWsH5hqqXrvqUFSeug6js6eIJkZCWuP4
         /M+Pl9BtmGFN64bc2ezeBHlWgbfhebeT2ve+q02xaPmnUcxO8YAwl9DhXeWgH/YKbk
         alv1q3XBbzttwsI0MEIaM5ej4nS1x4DgHSRdsHYxH7BVrXjqjsQ9RQI3GnZkMndXdx
         HYx9TCJZVsoqQ==
Date:   Tue, 22 Nov 2022 13:29:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>
Subject: Re: [PATCH net-next 0/5] Remove uses of kmap_atomic()
Message-ID: <Y3yyf+mxwEfIi8Xm@unreal>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 02:25:52PM -0800, Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated. This little series replaces the last
> few uses of kmap_atomic() in ethernet drivers with either page_address()
> or kmap_local_page().
> 
> Anirudh Venkataramanan (5):
>   ch_ktls: Use kmap_local_page() instead of kmap_atomic()
>   sfc: Use kmap_local_page() instead of kmap_atomic()
>   cassini: Remove unnecessary use of kmap_atomic()
>   cassini: Use kmap_local_page() instead of kmap_atomic()
>   sunvnet: Use kmap_local_page() instead of kmap_atomic()
> 
>  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 ++---
>  drivers/net/ethernet/sfc/tx.c                 |  4 +-


>  drivers/net/ethernet/sun/cassini.c            | 40 ++++++-------------
>  drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-

Dave, Jakub, Paolo
I wonder if these drivers can be simply deleted.

Thanks

>  4 files changed, 22 insertions(+), 36 deletions(-)
> 
> 
> base-commit: b4b221bd79a1c698d9653e3ae2c3cb61cdc9aee7
> -- 
> 2.37.2
> 
