Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1EE633463
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKVETj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiKVETU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:19:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABBF13CE8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:19:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14D5D61516
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DA4C433D6;
        Tue, 22 Nov 2022 04:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669090759;
        bh=HKlGIK/QEV1/cy7+Qe4uhlLUfMwxk79gwY7ck+rcOlU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kqcUm/rPt22k1sqpVY1uDRnnFZVpQjFfTiR15FfPpB7fmSNS7ZaUzbg6DXjKIvGWb
         b4l9+7ICBMetXkpVdsnauTxQKlgszUQ47wIM3HreEstxHCl/T5jDzTkIi8HehKEu4U
         INJphh+COikZthi4EuknXxUAfXyox10A3AHJgKcnJW9GB5lhx8ry50jzgEUcnxDKht
         0kdEuiiMn/dtWmptpJiGDSwSNsu7zFrqypk/A8FVBS+vuI6Wquoph/DPtwYPP7iurN
         oDE0/HigXmGLCgRmBUhftsVskVDOP5WQwfoySs+qk33oDM2L9PpwLU9PzXNd/kDY7W
         TivgdB94vIPSA==
Date:   Mon, 21 Nov 2022 20:19:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, sujuan.chen@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 5/5] net: ethernet: mtk_wed: add reset to
 tx_ring_setup callback
Message-ID: <20221121201917.080365ce@kernel.org>
In-Reply-To: <Y3vrKcqlmxksq1rC@lore-desk>
References: <cover.1669020847.git.lorenzo@kernel.org>
        <9c4dded2b7a35a8e44b255a74e776a703359797b.1669020847.git.lorenzo@kernel.org>
        <20221121121718.4cc2afe5@kernel.org>
        <Y3vrKcqlmxksq1rC@lore-desk>
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

On Mon, 21 Nov 2022 22:18:33 +0100 Lorenzo Bianconi wrote:
> > On Mon, 21 Nov 2022 09:59:25 +0100 Lorenzo Bianconi wrote:  
> > > +#define mtk_wed_device_tx_ring_setup(_dev, _ring, _regs, _reset) \
> > > +	(_dev)->ops->tx_ring_setup(_dev, _ring, _regs, _reset)  
> > 
> > FWIW I find the "op macros" quite painful when trying to read a driver
> > I'm not familiar with. stmmac does this, too. Just letting you know,
> > it is what it is.  
> 
> ack, fine. I maintained the approach currently used in the driver.
> Do you prefer to run the function pointer directly?

That's a tiny bit better, yes, saves the reader one lookup.

Are the ops here serving as a HAL or a way of breaking the dependency
between the SoC/Eth and the WiFi drivers? 
