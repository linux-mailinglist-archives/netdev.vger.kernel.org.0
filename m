Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAB5622157
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiKIB1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiKIB1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:27:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B0657F8
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 17:27:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45F8F6179F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D175C433D6;
        Wed,  9 Nov 2022 01:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667957228;
        bh=C5LRXlUsP8rJJkKzQSpO2FGyPL2rGWFrOlsoWHQTQCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FW1Kec03N9LmtANbFprhUESmaJsdn8ayJZkeElr3BUPTZsV532ll98L9V89GhrgPJ
         x82rk8PLYADV8eYZPH/zE04jOiTcMdVHCqvH1bJoECqT67tH1XHs19hbv4rovStoH4
         W0zFTfyj0bnrnhyXONwnmSZyNQaBwTui8xMEF5eWjv1VCevgCt5gga/l8p9uczOSED
         mqk8JVERnnHZWb7ceFA14jGLWNYXy7LwvA3XWk+YGkxVakrrWNzB5Ewpw82mOYeySn
         A9CeCRu1goiFg9LOlR/EErHicFCKK6Zbhtbb2zqAo2Kt0Y50aP+1+2wWyNP6QVieRM
         zWNYhs5Np6KZA==
Date:   Tue, 8 Nov 2022 17:27:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jeffrey.t.kirsher@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
Subject: Re: [PATCH net] net: mv643xx_eth: disable napi when init rxq or txq
 failed in mv643xx_eth_open()
Message-ID: <20221108172707.732325ce@kernel.org>
In-Reply-To: <20221108025156.327279-1-shaozhengchao@huawei.com>
References: <20221108025156.327279-1-shaozhengchao@huawei.com>
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

On Tue, 8 Nov 2022 10:51:56 +0800 Zhengchao Shao wrote:
> When failed to init rxq or txq in mv643xx_eth_open() for opening device,
> napi isn't disabled. When open mv643xx_eth device next time, it will
> report a invalid opcode issue.

It will trigger a BUG_ON() in napi_enable()

> Fix it. Only be compiled, not be tested.

Please replace "Fix it. Only be compiled, not be tested."
with "Compile tested only."

> Fixes: 527a626601de ("skge/sky2/mv643xx/pxa168: Move the Marvell Ethernet drivers")

This is not the commit which added this code, please find out where 
the code was added.
