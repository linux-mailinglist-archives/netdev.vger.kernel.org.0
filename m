Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161F35BD644
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiISVVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiISVVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3922DEDE;
        Mon, 19 Sep 2022 14:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 504EE61A4D;
        Mon, 19 Sep 2022 21:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533B6C433D6;
        Mon, 19 Sep 2022 21:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663622480;
        bh=OBH0AVFBPynesU/eettqD20mm5t3sWvYKQ6W7wlnQ9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eNRi0EMFRJU0I346wH0LMFVZhTxli+Nl13a0g+pyw5j0SGf+zldf7yKdOaPfHv32T
         gg9oii2w/9qgUteA+clLI8GYydFpiRPfOwBDT11EfUouvaH1odCR7EGweR5ezThYpO
         lKfHXBQwkzBHC4dYTHMc3JwVq4y/l2I1KO2CUOI5UI2YlO9K0RmNqYFWf+KeZimBP3
         /xkFWz/NtJTIWzmz9gfx+WFamVGexQsK/5Upc8JsS6xDOmZQ+kinw4KKQrcbpN/K34
         9/k5TcGxrAV0mBe2OjWrIIIzwEh/9fEovTMkz07C6ae+mUyDnqdKVsm54u7gq2Kdke
         D+VUZZKT9Ny5w==
Date:   Mon, 19 Sep 2022 14:21:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: fix potential memory leak in bnx2x_tpa_stop()
Message-ID: <20220919142119.5b473800@kernel.org>
In-Reply-To: <20220907065128.55190-1-niejianglei2021@163.com>
References: <20220907065128.55190-1-niejianglei2021@163.com>
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

On Wed,  7 Sep 2022 14:51:28 +0800 Jianglei Nie wrote:
> bnx2x_tpa_stop() allocates a memory chunk from new_data with
> bnx2x_frag_alloc(). The new_data should be freed when gets some error.
> But when "pad + len > fp->rx_buf_size" is true, bnx2x_tpa_stop() returns
> without releasing the new_data, which will lead to a memory leak.
> 
> We should free the new_data with bnx2x_frag_free() when "pad + len >
> fp->rx_buf_size" is true.

Please add a Fixes tag and repost.
