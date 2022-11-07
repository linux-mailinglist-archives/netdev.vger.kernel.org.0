Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1626C61EC6D
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiKGHvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKGHva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:51:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C575111E
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82DA4B80E19
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A17FC433C1;
        Mon,  7 Nov 2022 07:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667807487;
        bh=Bb/zsbwgFRgGEihwIYInEo76l09yNmCnXP2HTwFYj24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0D4A/H38FWvRXUMnPgJmtK6UTLuZUuRwZScX+Ay/rb0Sx6OHhtYXnqW9tUzORgUV
         qpX4LfRSu+qbwRVijDJl4dcBLZjTarlBjP73KOEWDL83gnIZ9LFqxnRMtV45r5CVqJ
         sJYasKIlnhbwTZMqJhAxe92Ma5ak0Uk3yDxW55reJA7va3kISJeODt25aoJZs+GR4q
         RyGcshuqfcV41Bj9IU8wCPgAvgN+UKICkkXOnmuJ8bdCtElbpi9zVF0t/yi1PFb45d
         0Z3Mqw9gLrTMVTqfZhP490WMeNfk60tqzWurHB6NhQ6vVw7Sopiqr5LZayaPq1cIeB
         1HvMSWyS8L2tg==
Date:   Mon, 7 Nov 2022 09:51:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        pavan.chebbi@broadcom.com
Subject: Re: [PATCH net-next 1/3] bnxt_en: refactor VNIC RSS update functions
Message-ID: <Y2i4+vudfY71/yn3@unreal>
References: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
 <1667780192-3700-2-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1667780192-3700-2-git-send-email-michael.chan@broadcom.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 07:16:30PM -0500, Michael Chan wrote:
> From: Edwin Peer <edwin.peer@broadcom.com>
> 
> Extract common code into a new function. This will avoid duplication
> in the next patch, which changes the update algorithm for both the P5
> and legacy code paths.
> 
> No functional changes.
> 
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 34 +++++++++++------------
>  1 file changed, 16 insertions(+), 18 deletions(-)

<...>

> +static void
> +__bnxt_hwrm_vnic_set_rss(struct bnxt *bp, struct hwrm_vnic_rss_cfg_input *req,
> +			 struct bnxt_vnic_info *vnic)

The "__" prefix in __func_name() usually means in kernel that this function
is locked externally.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
