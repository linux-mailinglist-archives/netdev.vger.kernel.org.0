Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A645165BD06
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbjACJVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjACJVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:21:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18873A4;
        Tue,  3 Jan 2023 01:21:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6141B80E54;
        Tue,  3 Jan 2023 09:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A5EC433F0;
        Tue,  3 Jan 2023 09:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672737689;
        bh=UeojPqccHQLunvAMGJSsAkbqVgpgQ+tfNxLVQSSNOZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b/RBp64HRv1JBVg9NRj1UOMrS5fir3u7Q+K58ib+ylvFOOXJsuWyU2+IGBMV6Z/+b
         quQxCkBLya6xWIS64yUUg56K2vkATqNPHGhnyOsqecTGakav8KH6hf1E8q/RJmrCZP
         hT+i/RXPZ+oSKwlMZgECssdeP8DwM/DvTzYj6EcvL6fIMhCRw4noK0Vsk0udVM6d4Y
         7uwbEfeK4CoZGEwQzHMYWI5E7y6h9TVC2ZwWQ76Jwj3U6NUIKdm1WyYxmKQ5I1W7qQ
         pcRuf3R3zhuTO2HaUXb0q42ZG6b2rdvO3II93dv/eXxed+nA6bLh2Ba97E8dQHdqqx
         qZCgNjrQpJMMA==
Date:   Tue, 3 Jan 2023 11:21:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wifi: ath11k: Fix memory leak in
 ath11k_peer_rx_frag_setup
Message-ID: <Y7PzlY3S0B1OBtmE@unreal>
References: <20230102081142.3937570-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102081142.3937570-1-linmq006@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 12:11:42PM +0400, Miaoqian Lin wrote:
> crypto_alloc_shash() allocates resources, which should be released by
> crypto_free_shash(). When ath11k_peer_find() fails, there has memory
> leak. Add missing crypto_free_shash() to fix this.
> 
> Fixes: 243874c64c81 ("ath11k: handle RX fragments")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
> change in v2:
> - add crypto_free_shash() in the error path instead of move
> crypto_alloc_shash().
> ---
>  drivers/net/wireless/ath/ath11k/dp_rx.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
