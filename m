Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8186431385E
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhBHPoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbhBHPoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:44:15 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FE6C061786;
        Mon,  8 Feb 2021 07:43:35 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id k25so15984066oik.13;
        Mon, 08 Feb 2021 07:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mrOgBXGvykD1boiJzHrnnWd5O3NLmXeKkU6TWI9sEeU=;
        b=YXMu8Zxa0V/BkwinblBPSVuYytIjmfY9mn9YaU8UWzBkm/gDG9afmxNuhJrehArMWI
         PTg8uSJFS5LCJmXe2Lqau2wKIFK/6B9bjcg9A5ZGCPMp5cjeCPWsGtsXp2TcHHc1um6E
         b6zrhF3nRr0dRtxMQAc5BM7MKkPW5UH1nZbB7FeZaCcNMIaYrv94ArKG8RdjOtf5Sk0e
         48DIvjxwDnoBnZ4WfF86NEB/VWhOkTOcfO8iNxT7Aj0+6atRAyBmyq0alpjA8ZS+x1SL
         7TlHh0ynYR0FyYGyKx4tgTi4jip1jxCXLq+KgCT/W+NiqBn4i+5lBS5ViNvDpw06UbAf
         XI8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mrOgBXGvykD1boiJzHrnnWd5O3NLmXeKkU6TWI9sEeU=;
        b=l6Ej7D0pIaNXKxtzRjHpqEKPs+zE/k7/8dhxT+AZUA8YP/Xn6y2srmpQQD54lIo5Pn
         mjEwRauSoT430SSCL/J4T7tD8tvGHnraluG4HmBtaMpR585LKeJwro+evG48xz2yNS/G
         9hQz6cXyxgEXrMLjL8vpoFxc58LxdXuRxdJ0nPi8zMX9Nw7MNGtFltRjnpXzoH72BZk5
         4hg2qNT+eDAbm6F0UrXDDmaEePHJzAjGQCto9FQFBdW4b/WK4cs+QG/+3+o3GASgcaRe
         3/f6EjTHPTcJ3KbZfjlSjQo5/NUUlgs5B7t0pHAfrSr0p6j7YDdCQYvhglqucZFiq6MK
         TQGw==
X-Gm-Message-State: AOAM532JScn7bNJiv50RAFmOXLX2CfdNb4wXcaOujoliSY+oBjJQ57a2
        KXnWKO+tFtq9vXcf/tgXKv4=
X-Google-Smtp-Source: ABdhPJwST4tEAPX7gfwckwPjokgM6XBwon9IuegiTtpOPYuJdQEWVoUojho/BfaGKHuDHUiNaKQSow==
X-Received: by 2002:aca:5c54:: with SMTP id q81mr11146156oib.163.1612799014455;
        Mon, 08 Feb 2021 07:43:34 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a1sm3105126oti.21.2021.02.08.07.43.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Feb 2021 07:43:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 8 Feb 2021 07:43:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
Message-ID: <20210208154332.GA20186@roeck-us.net>
References: <20201215172352.5311-1-youghand@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215172352.5311-1-youghand@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:53:52PM +0530, Youghandhar Chintala wrote:
> Currently in case of target hardware restart, we just reconfig and
> re-enable the security keys and enable the network queues to start
> data traffic back from where it was interrupted.
> 
> Many ath10k wifi chipsets have sequence numbers for the data
> packets assigned by firmware and the mac sequence number will
> restart from zero after target hardware restart leading to mismatch
> in the sequence number expected by the remote peer vs the sequence
> number of the frame sent by the target firmware.
> 
> This mismatch in sequence number will cause out-of-order packets
> on the remote peer and all the frames sent by the device are dropped
> until we reach the sequence number which was sent before we restarted
> the target hardware
> 
> In order to fix this, we trigger a sta disconnect, for the targets
> which expose this corresponding wiphy flag, in case of target hw
> restart. After this there will be a fresh connection and thereby
> avoiding the dropping of frames by remote peer.
> 
> The right fix would be to pull the entire data path into the host
> which is not feasible or would need lots of complex changes and
> will still be inefficient.
> 
> Tested on ath10k using WCN3990, QCA6174
> 
> Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
> Reviewed-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
>  net/mac80211/ieee80211_i.h |  3 +++
>  net/mac80211/mlme.c        |  9 +++++++++
>  net/mac80211/util.c        | 22 +++++++++++++++++++---
>  3 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index cde2e3f..8cbeb5f 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -748,6 +748,8 @@ struct ieee80211_if_mesh {
>   *	back to wireless media and to the local net stack.
>   * @IEEE80211_SDATA_DISCONNECT_RESUME: Disconnect after resume.
>   * @IEEE80211_SDATA_IN_DRIVER: indicates interface was added to driver
> + * @IEEE80211_SDATA_DISCONNECT_HW_RESTART: Disconnect after hardware restart
> + *	recovery
>   */
>  enum ieee80211_sub_if_data_flags {
>  	IEEE80211_SDATA_ALLMULTI		= BIT(0),
> @@ -755,6 +757,7 @@ enum ieee80211_sub_if_data_flags {
>  	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
>  	IEEE80211_SDATA_DISCONNECT_RESUME	= BIT(4),
>  	IEEE80211_SDATA_IN_DRIVER		= BIT(5),
> +	IEEE80211_SDATA_DISCONNECT_HW_RESTART	= BIT(6),
>  };
>  
>  /**
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 6adfcb9..e4d0d16 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -4769,6 +4769,15 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
>  					      true);
>  		sdata_unlock(sdata);
>  		return;
> +	} else if (sdata->flags & IEEE80211_SDATA_DISCONNECT_HW_RESTART) {
> +		sdata->flags &= ~IEEE80211_SDATA_DISCONNECT_HW_RESTART;
> +		mlme_dbg(sdata, "driver requested disconnect after hardware restart\n");
> +		ieee80211_sta_connection_lost(sdata,
> +					      ifmgd->associated->bssid,
> +					      WLAN_REASON_UNSPECIFIED,
> +					      true);
> +		sdata_unlock(sdata);
> +		return;
>  	}
>  	sdata_unlock(sdata);
>  }
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 8c3c01a..98567a3 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -2567,9 +2567,12 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  	}
>  	mutex_unlock(&local->sta_mtx);
>  
> -	/* add back keys */
> -	list_for_each_entry(sdata, &local->interfaces, list)
> -		ieee80211_reenable_keys(sdata);
> +
> +	if (!(hw->wiphy->flags & WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART)) {
> +		/* add back keys */
> +		list_for_each_entry(sdata, &local->interfaces, list)
> +			ieee80211_reenable_keys(sdata);
> +	}
>  
>  	/* Reconfigure sched scan if it was interrupted by FW restart */
>  	mutex_lock(&local->mtx);
> @@ -2643,6 +2646,19 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
>  					false);
>  
> +	if ((hw->wiphy->flags & WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART) &&
> +	    !reconfig_due_to_wowlan) {
> +		list_for_each_entry(sdata, &local->interfaces, list) {
> +			if (!ieee80211_sdata_running(sdata))
> +				continue;
> +			if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> +				sdata->flags |=
> +					IEEE80211_SDATA_DISCONNECT_HW_RESTART;
> +				ieee80211_sta_restart(sdata);

If CONFIG_PM=n:

ERROR: "ieee80211_sta_restart" [net/mac80211/mac80211.ko] undefined!

Guenter

> +			}
> +		}
> +	}
> +
>  	/*
>  	 * If this is for hw restart things are still running.
>  	 * We may want to change that later, however.
