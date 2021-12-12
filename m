Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32741471DB3
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 22:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhLLVV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 16:21:57 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:35674 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhLLVVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 16:21:46 -0500
Received: by mail-io1-f54.google.com with SMTP id 14so16432858ioe.2
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 13:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=+9OcGuDpkoMeBODhn8Tb5ApOZvJageVw35+/zZnQ1+s=;
        b=N8VVxvbV2xs1p4PI0kzLC6pLOO8UDMjFoKxHG1rvpciOCeYYNzsi3dNgr8cb2kzMoi
         0rhwqD+d9eUkZTbBtnLZjQRVVu0AAMkpOp+aY4ZAtachUQH+cLf8g+1x7XPl0OfcnCzg
         8Sl+Y16Tun1n9FQttKNrlm7L/jIygTBRBH4oQchRsTP0379UYGF5S37M+7nsKvoctPB1
         gSMwF1PMveONKJGD1MDKWcBuxbW0SvkDDcOV7QBHu8IpFZKFHzjCqEhqfXmEGyRvd3eL
         r6PfOFKUcPi39BRxLT0VTFRhkX3qy/kJsDmPspCuKF9PlAPd39OzD3j1L/nDFUdj7HSN
         AHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=+9OcGuDpkoMeBODhn8Tb5ApOZvJageVw35+/zZnQ1+s=;
        b=T5FdoFC7Trcn4hOJxOd11DiknMfXYROzSSm+UdViuOmHMvU5DW4IzyKP27s3eiXbxv
         YoWP3NX4YhIqA4zlep4b+CZ8min7ANrorF4w5vRS99dnf0DIgwnW+OkAAFqVSJKPCaZY
         +7Yh86RKmw2AdX38DSD5aX/ijXGWHrFrhpjWc61PM2bD59K4+qTIijVZJu+E0lJqbWBj
         YPa0Yl5aWzAAyskY67N1eJke0OM8y20qpAvlhctkXq9/zdr9OvMtrnNcZPpUWuaCrtcU
         yGQ1tME+oU7NtoJ+lxB8H/63CbnwVX3zngA+PBssVU7NdSmeCuTgCEbF7hSrmOATWwQJ
         pq3A==
X-Gm-Message-State: AOAM531M7fZVKGMt/J3QoNvOWmkWZQLonsH68ymFlceTy7IEuaWzc176
        3Q/e2pU/cib1hw3RmUwEh7qi
X-Google-Smtp-Source: ABdhPJw5Sbr65syF//Kt7IMdnzq6KcuMBwZ0H9xgIXOCMx+iDGjEOS3V/uOHIvAz2Lu5nSRUzyBO1A==
X-Received: by 2002:a05:6638:14ca:: with SMTP id l10mr29866295jak.107.1639344045464;
        Sun, 12 Dec 2021 13:20:45 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id o22sm7976635iow.52.2021.12.12.13.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 13:20:44 -0800 (PST)
Message-ID: <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
Subject: Re: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 12 Dec 2021 14:20:29 -0700
In-Reply-To: <20211212011835.3719001-1-davidm@egauge.net>
References: <20211212011835.3719001-1-davidm@egauge.net>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately, this patch doesn't seem to be sufficient.  From what I
can tell, if power-save mode is turned on before a station is
associated with an access-point, there is no actual power savings.  If
I issue the command after the station is associated, it works perfectly
fine.

Ajay, does this make sense to you?

Best regards,

  --david

On Sun, 2021-12-12 at 01:18 +0000, David Mosberger-Tang wrote:
> Without this patch, trying to use:
> 
> 	iw dev wlan0 set power_save on
> 
> before the driver is initialized results in an EIO error.  It is more
> useful to simply remember the desired setting and establish it when
> the driver is initialized.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
> ---
>  drivers/net/wireless/microchip/wilc1000/cfg80211.c | 3 ---
>  drivers/net/wireless/microchip/wilc1000/hif.c      | 8 ++++++++
>  drivers/net/wireless/microchip/wilc1000/netdev.c   | 3 ++-
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
> index dc4bfe7be378..01d607fa2ded 100644
> --- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
> +++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
> @@ -1280,9 +1280,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
>  	struct wilc_vif *vif = netdev_priv(dev);
>  	struct wilc_priv *priv = &vif->priv;
>  
> -	if (!priv->hif_drv)
> -		return -EIO;
> -
>  	wilc_set_power_mgmt(vif, enabled, timeout);
>  
>  	return 0;
> diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
> index 29a42bc47017..66fd77c816f7 100644
> --- a/drivers/net/wireless/microchip/wilc1000/hif.c
> +++ b/drivers/net/wireless/microchip/wilc1000/hif.c
> @@ -1934,6 +1934,14 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
>  	int result;
>  	s8 power_mode;
>  
> +	if (!wilc->initialized) {
> +		/* Simply remember the desired setting for now; will be
> +		 * established by wilc_init_fw_config().
> +		 */
> +		wilc->power_save_mode = enabled;
> +		return 0;
> +	}
> +
>  	if (enabled)
>  		power_mode = WILC_FW_MIN_FAST_PS;
>  	else
> diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
> index 4712cd7dff9f..082bed26a981 100644
> --- a/drivers/net/wireless/microchip/wilc1000/netdev.c
> +++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
> @@ -244,6 +244,7 @@ static int wilc1000_firmware_download(struct net_device *dev)
>  static int wilc_init_fw_config(struct net_device *dev, struct wilc_vif *vif)
>  {
>  	struct wilc_priv *priv = &vif->priv;
> +	struct wilc *wilc = vif->wilc;
>  	struct host_if_drv *hif_drv;
>  	u8 b;
>  	u16 hw;
> @@ -305,7 +306,7 @@ static int wilc_init_fw_config(struct net_device *dev, struct wilc_vif *vif)
>  	if (!wilc_wlan_cfg_set(vif, 0, WID_QOS_ENABLE, &b, 1, 0, 0))
>  		goto fail;
>  
> -	b = WILC_FW_NO_POWERSAVE;
> +	b = wilc->power_save_mode ? WILC_FW_MIN_FAST_PS : WILC_FW_NO_POWERSAVE;
>  	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, &b, 1, 0, 0))
>  		goto fail;
>  

