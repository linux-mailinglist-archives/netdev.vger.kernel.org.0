Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A19D57AD99
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 04:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbiGTCIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 22:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240848AbiGTCH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 22:07:59 -0400
X-Greylist: delayed 556 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Jul 2022 19:07:56 PDT
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A385C371;
        Tue, 19 Jul 2022 19:07:56 -0700 (PDT)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6D3C530919;
        Wed, 20 Jul 2022 01:58:41 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.134])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 85A471C0063;
        Wed, 20 Jul 2022 01:58:38 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 626E168007D;
        Wed, 20 Jul 2022 01:58:37 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.34.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 8091A13C2B0;
        Tue, 19 Jul 2022 18:58:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8091A13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1658282316;
        bh=Kts07RRMr5BVF7N98vAikq2EyUJOp6RVGah6b3RtQyo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=eHnn+UmYFGz3Nv2yDKpbRlJjYqurpHmkJhlioi5u9GAOt2+h+CaKhYIoxFZneGo/K
         V0tZiULLHYQKDRYw20otUh5R1S/bbXVtYuvqo2oiYhAc12fHBoOyQDrrMV5D0Hey0C
         ER5/4Ou6llXqxdMKD0Xq+7WUfQquSAQmpsYZxQAU=
Subject: Re: [PATCH AUTOSEL 5.4 06/16] wifi: mac80211: do not wake queues on a
 vif that is being stopped
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20220720011730.1025099-1-sashal@kernel.org>
 <20220720011730.1025099-6-sashal@kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <b43cfde3-7f33-9153-42ca-9e1ecf409d2a@candelatech.com>
Date:   Tue, 19 Jul 2022 18:58:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220720011730.1025099-6-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
X-MDID: 1658282319-8yJg6szINy6k
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think this one had a regression and needs another init-lock-early patch to keep from causing
problems?

It certainly broke my 5.17-ish kernel...

Thanks,
Ben

On 7/19/22 6:17 PM, Sasha Levin wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> [ Upstream commit f856373e2f31ffd340e47e2b00027bd4070f74b3 ]
> 
> When a vif is being removed and sdata->bss is cleared, __ieee80211_wake_txqs
> can still be called on it, which crashes as soon as sdata->bss is being
> dereferenced.
> To fix this properly, check for SDATA_STATE_RUNNING before waking queues,
> and take the fq lock when setting it (to ensure that __ieee80211_wake_txqs
> observes the change when running on a different CPU)
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Acked-by: Toke Høiland-Jørgensen <toke@kernel.org>
> Link: https://lore.kernel.org/r/20220531190824.60019-1-nbd@nbd.name
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/mac80211/iface.c | 2 ++
>   net/mac80211/util.c  | 3 +++
>   2 files changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index ddc001ad9055..48bda8aaa90a 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -803,7 +803,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>   	bool cancel_scan;
>   	struct cfg80211_nan_func *func;
>   
> +	spin_lock_bh(&local->fq.lock);
>   	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
> +	spin_unlock_bh(&local->fq.lock);
>   
>   	cancel_scan = rcu_access_pointer(local->scan_sdata) == sdata;
>   	if (cancel_scan)
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index c1c117fdf318..8ae0186091b6 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -250,6 +250,9 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
>   	local_bh_disable();
>   	spin_lock(&fq->lock);
>   
> +	if (!test_bit(SDATA_STATE_RUNNING, &sdata->state))
> +		goto out;
> +
>   	if (sdata->vif.type == NL80211_IFTYPE_AP)
>   		ps = &sdata->bss->ps;
>   
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
