Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5A64CC281
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbiCCQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbiCCQTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:19:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C942C199D67;
        Thu,  3 Mar 2022 08:19:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 604A86134C;
        Thu,  3 Mar 2022 16:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2D0C340E9;
        Thu,  3 Mar 2022 16:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646324343;
        bh=EHSnoQ9T2eNfI5kHK09JKtgNuw2uBGQFRsAu4RJhSFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y/d8lp4CUTzQK9Y9Z9QtLrZ15sAaHD/vaftwePtHXuaVvkzvwpokXx2enAeI1cqk9
         MI5GpNyIafLj8bpb19IwH3b7lf37VyN0uJFGwzExvmHtP3e4dvSxadg9bpRp1L5qUV
         ofYylYk+uRk7vjUjb7U6A30qulP6f4MZ1vTf0K/NQaejAH7DFx6hcpAZN1zCgeafuh
         UGkXVydeRGu/lslxdCoviWJOVBRZwnD1MH7rYNQMtdOQXbSzcurISHkkgwj9EC+oVX
         TFWdTvOsISJAEJ78I+q1MjSzY37YBk3lnr4AFpDera/PC18M7MwLnevxeWP1wZIIVe
         qXeOQxQYm5vmg==
Date:   Thu, 3 Mar 2022 08:19:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org, andrii@kernel.org, kpsingh@kernel.org,
        kafai@fb.com, yhs@fb.com, songliubraving@fb.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: Re: [PATCH net 2/2] ice: avoid XDP checks in ice_clean_tx_irq()
Message-ID: <20220303081901.3e811507@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220302175928.4129098-3-anthony.l.nguyen@intel.com>
References: <20220302175928.4129098-1-anthony.l.nguyen@intel.com>
        <20220302175928.4129098-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Mar 2022 09:59:28 -0800 Tony Nguyen wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Commit 9610bd988df9 ("ice: optimize XDP_TX workloads") introduced Tx IRQ
> cleaning routine dedicated for XDP rings. Currently it is impossible to
> call ice_clean_tx_irq() against XDP ring, so it is safe to drop
> ice_ring_is_xdp() calls in there.
> 
> Fixes: 1c96c16858ba ("ice: update to newer kernel API")
> Fixes: cc14db11c8a4 ("ice: use prefetch methods")
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  (A Contingent Worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Is this really a fix?
