Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A13B3FEC42
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244598AbhIBKkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbhIBKkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 06:40:11 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC9DC061575;
        Thu,  2 Sep 2021 03:39:13 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E59C44D976A56;
        Thu,  2 Sep 2021 03:39:09 -0700 (PDT)
Date:   Thu, 02 Sep 2021 11:39:08 +0100 (BST)
Message-Id: <20210902.113908.1070444215922235089.davem@davemloft.net>
To:     luca@coelho.fi
Cc:     torvalds@linux-foundation.org, johannes@sipsolutions.net,
        kuba@kernel.org, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        miriam.rachel.korenblitz@intel.com
Subject: Re: [PATCH] iwlwifi: mvm: add rtnl_lock() in
 iwl_mvm_start_get_nvm()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210902101101.383243-1-luca@coelho.fi>
References: <635201a071bb6940ac9c1f381efef6abeed13f70.camel@intel.com>
        <20210902101101.383243-1-luca@coelho.fi>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 02 Sep 2021 03:39:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luca@coelho.fi>
Date: Thu,  2 Sep 2021 13:11:01 +0300

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Due to a rebase damage, we lost the rtnl_lock() when the patch was
> sent out.  This causes an RTNL imbalance and failed assertions, due to
> missing RTNL protection, for instance:
> 
>   RTNL: assertion failed at net/wireless/reg.c (4025)
>   WARNING: CPU: 60 PID: 1720 at net/wireless/reg.c:4025 regulatory_set_wiphy_regd_sync+0x7f/0x90 [cfg80211]
>   Call Trace:
>    iwl_mvm_init_mcc+0x170/0x190 [iwlmvm]
>    iwl_op_mode_mvm_start+0x824/0xa60 [iwlmvm]
>    iwl_opmode_register+0xd0/0x130 [iwlwifi]
>    init_module+0x23/0x1000 [iwlmvm]
> 
> Fix this by adding the missing rtnl_lock() back to the code.
> 
> Fixes: eb09ae93dabf ("iwlwifi: mvm: load regdomain at INIT stage")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Linus, please just take this directly, thanks.

Acked-by: David S. Miller <davem@davemloft.net>
