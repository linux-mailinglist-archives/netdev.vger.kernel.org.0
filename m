Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D7C5379EE
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiE3LcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiE3LcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:32:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3031580E6;
        Mon, 30 May 2022 04:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60B8FB80D82;
        Mon, 30 May 2022 11:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04862C385B8;
        Mon, 30 May 2022 11:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653910328;
        bh=LVrwAmQkYHzGF8RQ7QeyXmZ9t3aKlO9mRE+QvNW53IA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VfOPh+Au3x9aMhtuZcCtk8jUZfm8qggVdYpMbjJUqjJCvS2rgviPCaeHWJGFZaAJr
         tLCF+sgNbUjbxOezs5Rn8fX3VZ7wKvXeMQZAuRM+xVr3AFNCLarnB18vAZ2VgDVyVm
         2vhb6OqUCoXVCoSfQV4EwcJkSaevqNYhVlV9Sx0CPq5gZQQaVXvg3dSV+3FBD+f+ac
         rphhKFos6PoCmkrWMEt7Ca0ygIPwz5l3IZI+bAC2YxVVGaeXHH6FnUoHrzR0fAvjU8
         i1E51GZChD3rmT7wxDdbJPn3o45lzDvndjtTDdLIRtMlS4DZtqLk9JsBmN3BK/QXhg
         rNgeVJLhS2ovA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath11k: mhi: fix potential memory leak in
 ath11k_mhi_register()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220530080610.143925-1-niejianglei2021@163.com>
References: <20220530080610.143925-1-niejianglei2021@163.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165391032080.5601.13315150837208103728.kvalo@kernel.org>
Date:   Mon, 30 May 2022 11:32:05 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianglei Nie <niejianglei2021@163.com> wrote:

> mhi_alloc_controller() allocates a memory space for mhi_ctrl. When some
> errors occur, mhi_ctrl should be freed by mhi_free_controller() and set
> ab_pci->mhi_ctrl = NULL because ab_pci->mhi_ctrl has a dangling pointer
> to the freed memory. But when ath11k_mhi_read_addr_from_dt() fails, the
> function returns without calling mhi_free_controller(), which will lead
> to a memory leak.
> 
> We can fix it by calling mhi_free_controller() when
> ath11k_mhi_read_addr_from_dt() fails and set ab_pci->mhi_ctrl = NULL in
> all of the places where we call mhi_free_controller().
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

Please always include a changelog from previous version:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

No need to resend because of this, a reply to this email is sufficient.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220530080610.143925-1-niejianglei2021@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

