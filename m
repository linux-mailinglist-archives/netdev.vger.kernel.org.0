Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9AB64C2A8
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 04:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiLNDPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 22:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbiLNDPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 22:15:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9229927B26
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 19:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35887B8163A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 03:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402FEC433EF;
        Wed, 14 Dec 2022 03:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670987729;
        bh=PxLV5VwlxVtw6OSZ3KLbpL+I2EUP7MmcuVvbdO5REos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kYLU8v4v8oQl7rgdZ3v3RZ13tietFegOmUmqs1Fba9KE/OQ/xmecI6SET3pqarcf/
         +RKHemMxsHDzK+s/AEvow7X2zFvOtfvAjmrl8LsXin+geblRhdWQ1x+FOx0Z49Vhlf
         QrxN0r+FAdVzfTphl7ULiAQrTHA5LZmNQ1b7k74D9NZ7hxV59PXSdxfK9NbGNFJK7e
         bU7QbMF5uwdlf07GWwr8rbf1tNsX0SaX0nluCyh5bDDzLsH1loT7ei2GwKnWd1uyhu
         RznF0zh48bYRD0a3xBIDMG5rO7R5NRCM7qONJ9UDEskqsI93rq4cwMmEp4GEt9vFSf
         1V3ItX82k+KVQ==
Date:   Tue, 13 Dec 2022 19:15:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <mcoquelin.stm32@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <boon.leong.ong@intel.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] net: stmmac: fix possible memory leak in
 stmmac_dvr_probe()
Message-ID: <20221213191528.75cd2ff0@kernel.org>
In-Reply-To: <20221212021350.3066631-1-cuigaosheng1@huawei.com>
References: <20221212021350.3066631-1-cuigaosheng1@huawei.com>
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

On Mon, 12 Dec 2022 10:13:50 +0800 Gaosheng Cui wrote:
> The bitmap_free() should be called to free priv->af_xdp_zc_qps
> when create_singlethread_workqueue() fails, otherwise there will
> be a memory leak, so we add the err path error_wq_init to fix it.
> 
> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>

The previous version has already been applied and we can't remove it.
Could you send an incremental change to just add the errno?
