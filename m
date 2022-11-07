Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D956A61EC70
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiKGHwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiKGHwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:52:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EB7B7E1
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:52:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB3FD60EF5
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9FBC433C1;
        Mon,  7 Nov 2022 07:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667807523;
        bh=qa7eMr3Yl3VN1PTN4UfsxhGKs3s8EAokx5uZMa35Skw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WZ8AZwiREI71YmIu95QPN3RIn8aSQD+VM3s+M9IlBM2BaL+FpmzvuY3NVOimOyakc
         MZIxbAHrKkDoBc4dhNlF/APUNyRHhSsrmH0emQ/e4w6aF1bnKDeSqGkjZZtJEC59M3
         o6B0F0ckTiee+09nZDvFeEmk1fkJxUE3R9lIP/6W/q+qBFG9DkbghktPCakRf1OVp9
         MJ6Q8TVDAjZHyG+XAK3xD/ySp+gztLkfZLXs7hxmwQXts2jYpOXs/JopoudrG/Fgol
         Yh5ZFI8XfX9RzyUoFsc7L53iPyZWu4UKwVX4hlgquo8+R+huG761x7C6SPAY9k6OS6
         tyX82UBfb7yLA==
Date:   Mon, 7 Nov 2022 09:51:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        pavan.chebbi@broadcom.com
Subject: Re: [PATCH net-next 3/3] bnxt_en: Add a non-real time mode to access
 NIC clock
Message-ID: <Y2i5HrY31PSMb/xC@unreal>
References: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
 <1667780192-3700-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1667780192-3700-4-git-send-email-michael.chan@broadcom.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 07:16:32PM -0500, Michael Chan wrote:
> From: Pavan Chebbi <pavan.chebbi@broadcom.com>
> 
> When using a PHC that is shared between multiple hosts,
> in order to achieve consistent timestamps across all hosts,
> we need to isolate the PHC from any host making frequency
> adjustments.
> 
> This patch adds a non-real time mode for this purpose.
> The implementation is based on a free running NIC hardware timer
> which is used as the timestamper time-base. Each host implements
> individual adjustments to a local timecounter based on the NIC free
> running timer.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 45 ++++++++++++++-----
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  7 ++-
>  3 files changed, 42 insertions(+), 15 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
