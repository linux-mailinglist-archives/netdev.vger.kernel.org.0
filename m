Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF72D68754E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBBFkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBBFkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:40:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87C12D71
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 21:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53A9B60D33
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84016C433EF;
        Thu,  2 Feb 2023 05:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675316387;
        bh=Y6eJPCtx6YQw5jimIHtKFfV7yTDQnikN0x1NO9Dh7dc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HTGYTxyu/t2Pd9o85nPuVdBbbJQOR5WujA+GaU6p7BkfUS1SqhpPuoYBaTdvKj3yQ
         xEf6wholvioAJEwHAk3eEncW0AbpWkMu60JcUzCsuHJYnmmBovZYYahw178rWICd9W
         1AyPvOlv+W6SFiy96ZjdqwYw4YqZ9wgpUmvc7zXuzx9OsELpb/iGgpfd9k8ZaG1Lnq
         Q/SPvajLz/hSOjDFLSXabie+7mxxXfaIsq4l/LHNGwafllOSLt3tpz7/HKjltFWI+x
         IviD+ioBUIN62uOy2n0zTWjH0PLxzzfHzlnyicaAQhxHUAvs0tDJP1737qzcVJCfDp
         4EwAkL3MCj/0Q==
Date:   Wed, 1 Feb 2023 21:39:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v2 01/10] net: libwx: Add irq flow functions
Message-ID: <20230201213946.7b044507@kernel.org>
In-Reply-To: <20230131100541.73757-2-mengyuanlou@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
        <20230131100541.73757-2-mengyuanlou@net-swift.com>
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

On Tue, 31 Jan 2023 18:05:32 +0800 Mengyuan Lou wrote:
> +	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
> +		wr32(wx, WX_PX_ISB_ADDR_H, wx->isb_dma >> 32);

The compilers may still warn about this on 32bit systems,
please use lower_32_bits().
