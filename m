Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA4564245E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiLEIUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiLEIUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC7215A1B;
        Mon,  5 Dec 2022 00:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B4F4B80D6E;
        Mon,  5 Dec 2022 08:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31242C433D6;
        Mon,  5 Dec 2022 08:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670228417;
        bh=yVN35cHrzVki0JCU53F4oiW28cwbRdKaotWUuvMjBXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dR3TPQMwaQiMzz7epZwwjLSciKqXvaBoCaOZgh8/6c+13ExQdfK339VbDth304oVV
         ZF5MgGGbGdVtjk2kpF39+oXkSOvFTsd+S33cNYsp1hHbmDYkcP6Aoa1iYv6BXTN+od
         BBKWUt7kai61tBMRhgdmP31ZghswTGS8HVvZpEdzzlJmoE32r4aiJ8nQc+21ayDEfk
         utuHrI3AdWXBgVP3TLbGBeE0TXNN3M3xTIEVpFbgqcFBF/gex4WNo1zKLUGO0awtaI
         jWf9664c3lAtRVp/TgKe9LVVf8sN5Bigf2brFiiIN8ysgG4YF0vCy37VQLqxJy4pLy
         mtRX215O3wfwg==
Date:   Mon, 5 Dec 2022 10:20:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ice: switch: fix potential memleak in
 ice_add_adv_recipe()
Message-ID: <Y42pvM+riGXdG0al@unreal>
References: <1670225902-10923-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670225902-10923-1-git-send-email-zhangchangzhong@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 03:38:22PM +0800, Zhang Changzhong wrote:
> When ice_add_special_words() fails, the 'rm' is not released, which will
> lead to a memory leak. Fix this up by going to 'err_unroll' label.
> 
> Compile tested only.
> 
> Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
