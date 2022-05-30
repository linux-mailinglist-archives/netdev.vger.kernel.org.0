Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157EE5379FC
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbiE3Lfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiE3Lfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:35:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B156813CA;
        Mon, 30 May 2022 04:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C216117E;
        Mon, 30 May 2022 11:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBADC34119;
        Mon, 30 May 2022 11:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653910519;
        bh=26Kux3PyarW6Nbrz6s4UxEYoay2f7CdauW6UqGckS+k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hesDoJ9mh+BacantMkXObjjJEpRvskiv0cxJk74iEc86IjtFhT4Rsn/zt4CSXNSXp
         mH/RT02CmIf1Ov0vZFaQbPp5PFkN4KZxRCgD+ADT8eV6+LHZihOtl3EaOxkeLqlnbA
         1uSV1F0g4UmVQ5C9EPjjS0Wn3HhoKHUyz78TkjVJy+jL7zFBJW83oSyE/U4nBGiw00
         jaI/AVsSv4XEdtJhTeS6TGKgKwk817SyMy6HUvCoVUeHObw5KzU1kTQrNSYm7Q+z2B
         eavxX2Dc3JLqRZ1d7+l44EN6ygjK/Kvd1BpgS1v8FoxwPpdPD+Uoc6l4kgSBfu4+p1
         LUw7VJJg6qvpw==
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
Message-ID: <165391051496.5601.1908067980296464087.kvalo@kernel.org>
Date:   Mon, 30 May 2022 11:35:17 +0000 (UTC)
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

Fails to apply, please rebase on top of ath.git master branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/

error: patch failed: drivers/net/wireless/ath/ath11k/mhi.c:367
error: drivers/net/wireless/ath/ath11k/mhi.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220530080610.143925-1-niejianglei2021@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

