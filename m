Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A18582716
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiG0MxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiG0MxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:53:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D542613F;
        Wed, 27 Jul 2022 05:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81502B82152;
        Wed, 27 Jul 2022 12:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A15FC433D6;
        Wed, 27 Jul 2022 12:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926385;
        bh=+wk/iD23OQoGzlHMNq9DEFcCFa9An1jEwAkFDkSfuVA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pX5PYO52hwCIautGqjqtNnxv8uGBSBWBxOSfOoNrMkcNOG4C8LeQbxynaMhx6iYEs
         6Tecke7nveMtgT9YXPgt4Hl/BP5GQCYgH+cd7nPxiGWRj77imju3oub8tI/COOvwp1
         3UriojXaA4tcLBNFWJ1Zi5h1eYRSxkEvcIj8+1Xeo72H0Yy4fNdcUv0hiYE4Ltcujc
         aFXWOFjtQQM4Zjig21NCha3nhDBMIeIwNvsZJ8GLKy3kXauPLHWKZXM+1tLBjnhsm8
         wURjQUA7bMM1E5xAKesh+6cD52hcPMg7wYDqFaJz4lBwwxcxIpzU22dOzz3+jSKLQG
         lUhDfw6q98Icg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtl8xxxu: Fix the error handling of the probe function
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220716130444.2950690-1-zheyuma97@gmail.com>
References: <20220716130444.2950690-1-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892638117.11639.15108682372355290807.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 12:53:02 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheyu Ma <zheyuma97@gmail.com> wrote:

> When the driver fails at ieee80211_alloc_hw() at the probe time, the
> driver will free the 'hw' which is not allocated, causing a bug.
> 
> The following log can reveal it:
> 
> [   15.981294] BUG: KASAN: user-memory-access in mutex_is_locked+0xe/0x40
> [   15.981558] Read of size 8 at addr 0000000000001ab0 by task modprobe/373
> [   15.982583] Call Trace:
> [   15.984282]  ieee80211_free_hw+0x22/0x390
> [   15.984446]  rtl8xxxu_probe+0x3a1/0xab30 [rtl8xxxu]
> 
> Fix the bug by changing the order of the error handling.
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>

Patch applied to wireless-next.git, thanks.

13876f2a087a wifi: rtl8xxxu: Fix the error handling of the probe function

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220716130444.2950690-1-zheyuma97@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

