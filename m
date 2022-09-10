Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B315B4462
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 08:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiIJG1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 02:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIJG1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 02:27:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974E49DFB4;
        Fri,  9 Sep 2022 23:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3196060C66;
        Sat, 10 Sep 2022 06:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730C7C433D7;
        Sat, 10 Sep 2022 06:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662791241;
        bh=GXAqaX6S5isTiZevwTGC5NS6o9x12/MY1+Xsels5fyY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lLL3kBYo9Krm21ps6ucufzFryCtpdVR/tx8NS2P5vV+nm3W5ZYrTFqAb1n5ZayT/N
         2jm1lz6nimtPoVCz7/IzDLBNU+3KmbRwJLnGBipLCcg/wY6qBIH2/qjrt6GSZafnel
         uFgOtR7c5oDco1ht0lLVaZMh6eLkK1d/p1oDhiKG+ttsr8rq4yn27n1uaS5x+Dxmq0
         M5/LvQlzGOBSVzTr3WPBCeVBQfWmdOCNxkTJVlO32Sculj3kwoqFde+j6U9aj2NHxd
         e2QQ3yR31iMJ9xgv6acI3S8H3zeABvEDwW0WK4XgmuhwtiUHkRLmhMoojZ7UygSofl
         jR/WZa+xhla9w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: mhi: fix potential memory leak in
 ath11k_mhi_register()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220907073704.58806-1-niejianglei2021@163.com>
References: <20220907073704.58806-1-niejianglei2021@163.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166279123716.2050.14052144817465731004.kvalo@kernel.org>
Date:   Sat, 10 Sep 2022 06:27:19 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianglei Nie <niejianglei2021@163.com> wrote:

> mhi_alloc_controller() allocates a memory space for mhi_ctrl. When gets
> some error, mhi_ctrl should be freed with mhi_free_controller(). But
> when ath11k_mhi_read_addr_from_dt() fails, the function returns without
> calling mhi_free_controller(), which will lead to a memory leak.
> 
> We can fix it by calling mhi_free_controller() when
> ath11k_mhi_read_addr_from_dt() fails.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

43e7c3505ec7 wifi: ath11k: mhi: fix potential memory leak in ath11k_mhi_register()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220907073704.58806-1-niejianglei2021@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

