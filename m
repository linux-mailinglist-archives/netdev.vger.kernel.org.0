Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD963B29BC
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 09:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhFXHxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 03:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhFXHxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 03:53:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B18C061574;
        Thu, 24 Jun 2021 00:51:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lwK8f-00AtWB-CA; Thu, 24 Jun 2021 09:51:05 +0200
Message-ID: <63d3f8ec9095031d5d6b1374f304a76c64a036f2.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: add dependency for MAC80211_LEDS
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Liwei Song <liwei.song@windriver.com>, David <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 24 Jun 2021 09:51:04 +0200
In-Reply-To: <20210624074956.37298-1-liwei.song@windriver.com>
References: <20210624074956.37298-1-liwei.song@windriver.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 15:49 +0800, Liwei Song wrote:
> Let MAC80211_LEDS depends on LEDS_CLASS=IWLWIFI to fix the below warning:
> 
> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
>   Selected by [m]:
>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])
> 
> Signed-off-by: Liwei Song <liwei.song@windriver.com>
> ---
>  net/mac80211/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 51ec8256b7fa..918a11fed563 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -69,7 +69,7 @@ config MAC80211_MESH
>  config MAC80211_LEDS
>  	bool "Enable LED triggers"
>  	depends on MAC80211
> -	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
> +	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211 || LEDS_CLASS=IWLWIFI

Eh, no. this is the wrong way around. If anything needs to be fixed,
then it must be in iwlwifi, not the generic core part.

johannes

