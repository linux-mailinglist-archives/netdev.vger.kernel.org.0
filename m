Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F736169BD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiKBQwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKBQwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:52:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A186B51;
        Wed,  2 Nov 2022 09:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 286E461A8E;
        Wed,  2 Nov 2022 16:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0CEC433C1;
        Wed,  2 Nov 2022 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667407934;
        bh=sXtRjTK2mDtmiAA5R3kBj+6rdwU5KpPOdCfNoWca9qg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bm6Ph2CbSZpLId2m08s1AGZXc4Zv+INVO7HhiiZYyEYMffFnQbBawkP61O/kUkbmb
         ed0G0bsu+zDggK2zemJQ/n6ByOFeJvbapQxpIF+5lm9+TveK9teTFgwD3vrvLRvGRQ
         AYEQbw6oQNDQHNDGeSsXG33kmrL1NJhXDDDdxkDepZRsR9aqkpi93iyaOx6s7bWPQN
         Uvl7Pf+zJRGKU7scYv3KOa0k/b1/zbEAqjOsNnqBhi6U4MdAE5HhkuweZ2wTmA4cFS
         weMe2iCOn+PlPTYIolsTU+KuFj5DpBb6Do36f3ryY/vL5bWcK3RKS0FG3Sx46Uol6q
         Vpd+qI+w73xrg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k (gcc13): synchronize
 ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221031114341.10377-1-jirislaby@kernel.org>
References: <20221031114341.10377-1-jirislaby@kernel.org>
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166740792692.20386.4779272467939559487.kvalo@kernel.org>
Date:   Wed,  2 Nov 2022 16:52:11 +0000 (UTC)
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jiri Slaby (SUSE)" <jirislaby@kernel.org> wrote:

> ath11k_mac_he_gi_to_nl80211_he_gi() generates a valid warning with gcc-13:
>   drivers/net/wireless/ath/ath11k/mac.c:321:20: error: conflicting types for 'ath11k_mac_he_gi_to_nl80211_he_gi' due to enum/integer mismatch; have 'enum nl80211_he_gi(u8)'
>   drivers/net/wireless/ath/ath11k/mac.h:166:5: note: previous declaration of 'ath11k_mac_he_gi_to_nl80211_he_gi' with type 'u32(u8)'
> 
> I.e. the type of the return value ath11k_mac_he_gi_to_nl80211_he_gi() in
> the declaration is u32, while the definition spells enum nl80211_he_gi.
> Synchronize them to the latter.
> 
> Cc: Martin Liska <mliska@suse.cz>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: ath11k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

dd1c23226945 wifi: ath11k: synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221031114341.10377-1-jirislaby@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

