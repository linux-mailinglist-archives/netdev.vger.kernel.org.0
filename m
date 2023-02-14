Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846166964B6
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbjBNN3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjBNN3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:29:08 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCEC25B8C;
        Tue, 14 Feb 2023 05:29:01 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6A77A21F75;
        Tue, 14 Feb 2023 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676381340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VhjPpKcebesguOG6Ou3hG3A4Vp+9D1RLYmGPf7f6hcw=;
        b=id/NzceucG1QxBw5TALYJgC2/sT2BPspSmI7zJ/IcfJmOuo4Vfi8IP/qCI2mvdS8S4bodI
        3WeaKeB6uOdBIDAB+idpedBEgl+Dgc3HKsaKHRPWS6T9ZzQA7QcjvYQOxhKmHWcjThrh4T
        N56DvLLq/bIyoXLHF8IuhVy6J2w7fk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676381340;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VhjPpKcebesguOG6Ou3hG3A4Vp+9D1RLYmGPf7f6hcw=;
        b=HxnuPzPY5VisQUj9CHjOif5DZ3Du4ydPvaXhMR68CQb7PzK3a1dgKIk12z0GOVue+UHs/A
        WG8TnBaXG6Kon6Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B4C34138E3;
        Tue, 14 Feb 2023 13:28:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t4z5KJuM62MLNwAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Tue, 14 Feb 2023 13:28:59 +0000
Message-ID: <13e8e0bb-b2a2-e138-75c0-54e61a5d679e@suse.de>
Date:   Tue, 14 Feb 2023 16:27:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4] Set ssid when authenticating
Content-Language: en-US
To:     Marc Bornand <dev.mbornand@systemb.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
References: <20230214132009.1011452-1-dev.mbornand@systemb.ch>
From:   Denis Kirjanov <dkirjanov@suse.de>
In-Reply-To: <20230214132009.1011452-1-dev.mbornand@systemb.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/23 16:20, Marc Bornand wrote:
> changes since v3:
> - add missing NULL check
> - add missing break
> 
> changes since v2:
> - The code was tottaly rewritten based on the disscution of the
>   v2 patch.
> - the ssid is set in __cfg80211_connect_result() and only if the ssid is
>   not already set.
> - Do not add an other ssid reset path since it is already done in
>   __cfg80211_disconnected()
> 
> When a connexion was established without going through
> NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
> Now we set it in __cfg80211_connect_result() when it is not already set.

A couple of small nits

> 
> Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
> Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
Please add a test description to the fixes tag

> Cc: linux-wireless@vger.kernel.org
> Cc: stable@vger.kernel.org
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216711
> Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
> ---
>  net/wireless/sme.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 4b5b6ee0fe01..b552d6c20a26 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -723,6 +723,7 @@ void __cfg80211_connect_result(struct net_device *dev,
>  			       bool wextev)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	const struct element *ssid;

Please use reverse xmas tree

>  	const struct element *country_elem = NULL;
>  	const u8 *country_data;
>  	u8 country_datalen;
> @@ -883,6 +884,22 @@ void __cfg80211_connect_result(struct net_device *dev,
>  				   country_data, country_datalen);
>  	kfree(country_data);
> 
> +	if (wdev->u.client.ssid_len == 0) {
> +		rcu_read_lock();
> +		for_each_valid_link(cr, link) {
> +			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
> +						      WLAN_EID_SSID);
> +
> +			if (!ssid || ssid->datalen == 0)
> +				continue;
> +
> +			memcpy(wdev->u.client.ssid, ssid->data, ssid->datalen);
> +			wdev->u.client.ssid_len = ssid->datalen;
> +			break;
> +		}
> +		rcu_read_unlock();
> +	}
> +
>  	return;
>  out:
>  	for_each_valid_link(cr, link)
> --
> 2.39.1
> 
> 
