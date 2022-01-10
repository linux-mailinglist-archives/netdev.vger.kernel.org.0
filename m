Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2232C488D7D
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 01:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiAJAdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 19:33:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44860 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236630AbiAJAdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 19:33:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1E1F61005;
        Mon, 10 Jan 2022 00:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0758C36AEB;
        Mon, 10 Jan 2022 00:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641774810;
        bh=wWT1fu6zu/5275otEoebHlxBFqfJwEiHlelMDWOWul0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXA520KxqRLcdFBZyoka8CczruBS06TmpqOy9d1UK98dGQ98pAXKmlQvGGZDfbLzg
         LgnOTvaT768JvBy+rmz+ETqz9ZePqVRPLNGOfLIGaAiXgXKYyhgsOji6n2rC6SX+fa
         LxofvJSNFfCC/SaP1EiaRmr0Guoy9SPDl8p/E/MYvJ8N7gxtBnt9q52KTjW0F2rwKM
         VNlF9RSPYKnZYxa/izpnKNvVnJqUcdMY9clUZcRdKhscb82f0FCxpVsh9zfhPOKEy4
         A6k9beQFjgpshNWkKHYyCh5KvldpCZXnmObSMia+ASlmFDTet+o3TxWZdMUB/Szpaj
         7uPXLBm5IaNHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     nathan@kernel.org
Cc:     johannes.berg@intel.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()
Date:   Sun,  9 Jan 2022 16:33:26 -0800
Message-Id: <20220110003326.2745615-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211227191757.2354329-1-nathan@kernel.org>
References: <20211227191757.2354329-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When building ARCH=arm allmodconfig:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c: In function ‘iwl_mvm_ftm_rtt_smoothing’:
> ./include/asm-generic/div64.h:222:35: error: comparison of distinct pointer types lacks a cast [-Werror]
>   222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
>       |                                   ^~
> drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:1070:9: note: in expansion of macro ‘do_div’
>  1070 |         do_div(rtt_avg, 100);
>       |         ^~~~~~

Let me take this one directly to net-next, hope that's okay.

Thanks!
