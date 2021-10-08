Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AA4426448
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 07:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhJHFzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 01:55:06 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:37241 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbhJHFzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 01:55:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633672390; h=Content-Type: MIME-Version: Message-ID: Date:
 References: In-Reply-To: Subject: Cc: To: From: Sender;
 bh=rmh6oHI66td0Mu4wXsLqqmfSbirKcTqHHCrPMIVl3o0=; b=isCA25z/o1wZIbdXCCDtn62Vrc8pslkWhwf4aHCqiDi9mijrZVmvpMMXeCckY2k+/Fly2UAr
 uGDIDgz1WrppiZlyMchCJWFsDo4zwkg7yXRnXlM8Jo3jsOFrhFH4X1di2p0lz9zFyvkKStSd
 YSXoDVWjfy6cM7QWNyH19uUQ2Cs=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 615fdcbcf1c6896061454a9e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 08 Oct 2021 05:53:00
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C4D02C43616; Fri,  8 Oct 2021 05:52:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C09DFC43460;
        Fri,  8 Oct 2021 05:52:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C09DFC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
In-Reply-To: <20211008162103.1921a7a7@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 8 Oct 2021 16:21:03 +1100")
References: <20211008162103.1921a7a7@canb.auug.org.au>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 08 Oct 2021 08:52:51 +0300
Message-ID: <87tuhs5ah8.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> After merging the net-next tree, today's linux-next build (xtensa,
> m68k allmodconfig) failed like this:
>
> In file included from <command-line>:0:0:
> In function 'ath11k_peer_assoc_h_smps',
>     inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:2362:2:
> include/linux/compiler_types.h:317:38: error: call to '__compiletime_assert_650' declared with attribute error: FIELD_GET: type of reg too small for mask
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                       ^
> include/linux/compiler_types.h:298:4: note: in definition of macro '__compiletime_assert'
>     prefix ## suffix();    \
>     ^
> include/linux/compiler_types.h:317:2: note: in expansion of macro '_compiletime_assert'
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>   ^
> include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                      ^
> include/linux/bitfield.h:52:3: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>    BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,  \
>    ^
> include/linux/bitfield.h:108:3: note: in expansion of macro '__BF_FIELD_CHECK'
>    __BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: "); \
>    ^
> drivers/net/wireless/ath/ath11k/mac.c:2079:10: note: in expansion of macro 'FIELD_GET'
>    smps = FIELD_GET(IEEE80211_HE_6GHZ_CAP_SM_PS,
>           ^
>
> Caused by commit
>
>   6f4d70308e5e ("ath11k: support SMPS configuration for 6 GHz")

Thanks for the report, weird that I don't see it on x86. I can't look at
this in detail now, maybe later today, but I wonder if the diff below
fixes the issue?

At least it's cleaner than using FIELD_GET(), actually ath11k should be
cleaned up to use xx_get_bits() all over.

Kalle

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index d897020dd52d..3e7e569f284b 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2076,8 +2076,8 @@ static void ath11k_peer_assoc_h_smps(struct ieee80211_sta *sta,
 		smps = ht_cap->cap & IEEE80211_HT_CAP_SM_PS;
 		smps >>= IEEE80211_HT_CAP_SM_PS_SHIFT;
 	} else {
-		smps = FIELD_GET(IEEE80211_HE_6GHZ_CAP_SM_PS,
-				 le16_to_cpu(sta->he_6ghz_capa.capa));
+		smps = le16_get_bits(sta->he_6ghz_capa.capa,
+				     IEEE80211_HE_6GHZ_CAP_SM_PS);
 	}
 
 	switch (smps) {

