Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8868AFB8CB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKMT2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:28:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41337 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfKMT2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:28:25 -0500
Received: by mail-pg1-f196.google.com with SMTP id h4so1970678pgv.8
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 11:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MAMD8GrM8dHDXrjY8rB11bYG41rlwSHG+RL00OkRN/o=;
        b=kAKj678FOeRgSTgvgGizY5G9JM6SOedytMkY28h49lcSAdCwJa8TigOkgPmwgEAmFl
         7lVRSFwk2qORKcwSLUM1DiKTx71kKurWIMaiBtzw/+zUI6DyVo8nIr54GG+84a7z/N4L
         bJBoL7U57vlio0KtxJPnXPQqNZEmpADcUyz47F1FYT9O2hvMqk1AigAhyOYHwxP8TBqP
         dzNxLUWBNVslIFHB55wEXdMx4sjqo9BLrz3POeQh4iFTei538Q8lIw7AaU8yzPmro5o4
         1mTDOZMeWMLxxLNlCNY4RH10WHgw4Hu8lheD6ExtAfsMPWc5bWNscnVoslU1zFhBQtM5
         VnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MAMD8GrM8dHDXrjY8rB11bYG41rlwSHG+RL00OkRN/o=;
        b=dfAdK/gnrCUIa1SVemFEGWWRl0lCYA+rSToYIQGN6Oob92ssZk0r1tHodYTX8azhnR
         ddIDDuQpKprFF8V+8hWK/S8EcR49MPpHY7K5M25SwX41jXWP2GFey9GMBcAc3MGOiKub
         hbocbG0Q3vv1tk+8hzfgRPAP8vXEiwFSVZF1NrVJtCsKIFZDiHRYQwhsmuObb+oRbvp9
         CmflB+X85xAlnPtZsCExM8GRXMKB63nnXV7MVVGGLn7YssAlBTtqBekqJRndtbwafpEH
         Hmb8cUPi09rnCYGoYCfHekp0nMjzbCla7pkOPEBX07DrOCWHee2wgtUc6vd0IbavU0nR
         pqNA==
X-Gm-Message-State: APjAAAUinnE3ucdWUsjEjdGm7yLGmKSbom9ONVLqBQdXMQSMohit0Joz
        snBjNNCKmJltioVQKuDz46bqeQ==
X-Google-Smtp-Source: APXvYqzVZUY1tsQDfkbM7m/TmFRXF1CAa7JwqkS6wPqF7BuiwbTHdXn0YX0vI9kQk5s72HxPcOWbHg==
X-Received: by 2002:a62:2686:: with SMTP id m128mr6406494pfm.143.1573673304126;
        Wed, 13 Nov 2019 11:28:24 -0800 (PST)
Received: from builder (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id z7sm3437838pgk.10.2019.11.13.11.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 11:28:23 -0800 (PST)
Date:   Wed, 13 Nov 2019 11:28:21 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Wenwen Wang <wenwen@cs.uga.edu>, Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:QUALCOMM ATHEROS ATH10K WIRELESS DRIVER" 
        <ath10k@lists.infradead.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        jeffrey.l.hugo@gmail.com, govinds@codeaurora.org
Subject: Re: [PATCH] ath10k: add cleanup in ath10k_sta_state()
Message-ID: <20191113192821.GA3441686@builder>
References: <1565903072-3948-1-git-send-email-wenwen@cs.uga.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565903072-3948-1-git-send-email-wenwen@cs.uga.edu>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 15 Aug 14:04 PDT 2019, Wenwen Wang wrote:

> If 'sta->tdls' is false, no cleanup is executed, leading to memory/resource
> leaks, e.g., 'arsta->tx_stats'. To fix this issue, perform cleanup before
> go to the 'exit' label.
> 

Unfortunately this patch consistently crashes all my msm8998, sdm845 and
qcs404 devices (running ath10k_snoc).  Upon trying to join a network the
WiFi firmware crashes with the following:

[  124.315286] wlan0: authenticate with 70:3a:cb:4d:34:f3
[  124.334051] wlan0: send auth to 70:3a:cb:4d:34:f3 (try 1/3)
[  124.338828] wlan0: authenticated
[  124.342470] wlan0: associate with 70:3a:cb:4d:34:f3 (try 1/3)
[  124.347223] wlan0: RX AssocResp from 70:3a:cb:4d:34:f3 (capab=0x1011 status=0 aid=2)
[  124.402535] qcom-q6v5-mss 4080000.remoteproc: fatal error received: err_qdi.c:456:EF:wlan_process:1:cmnos_thread.c:3900:Asserted in wlan_vdev.c:_wlan_vdev_up:3219

Can we please revert it for v5.5?

Regards,
Bjorn

> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 0606416..f99e6d2 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -6548,8 +6548,12 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
>  
>  		spin_unlock_bh(&ar->data_lock);
>  
> -		if (!sta->tdls)
> +		if (!sta->tdls) {
> +			ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
> +			ath10k_mac_dec_num_stations(arvif, sta);
> +			kfree(arsta->tx_stats);
>  			goto exit;
> +		}
>  
>  		ret = ath10k_wmi_update_fw_tdls_state(ar, arvif->vdev_id,
>  						      WMI_TDLS_ENABLE_ACTIVE);
> -- 
> 2.7.4
> 
