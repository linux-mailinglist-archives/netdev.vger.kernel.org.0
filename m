Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65EC181E33
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 17:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgCKQpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 12:45:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37386 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729809AbgCKQpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 12:45:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id p14so1650062pfn.4
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 09:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=JtWCa/vxMOZhzXhtRsuYP1P9rUW4iKHdUbE1rBXcLto=;
        b=q8fFVuJrua53YGXo9stI6aD8d3mh8YKjkKPBVgpChUhVe+zHzC5I0DJEdegYpCQ61Q
         +xC+Ta2XSggkg3xas7wCQodpI2uVizauX3ZVsRbkOQhucr4Na4Okp85R3YzVfu/FdhZX
         B8+jDjlDNFh7uiTSd0yR7YICltjqu62yZ/DPXUDDwUG/K1kIf3yU3I/jT0LFcx3xQDgZ
         iVcUC2mRVrzWU7stDF0QutnHOYrRJuuYE64aLW/wisfvuByaPmpoTLUNDhPSnMEZWFLG
         n8IYIhT1wwoV/7TvvOQH9O6TXQj6F5xQt+OHnUNQ06M8LHTm9UsttMfkZwrT4BsyjtSc
         iqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JtWCa/vxMOZhzXhtRsuYP1P9rUW4iKHdUbE1rBXcLto=;
        b=MhIhuLznI8pSo8J2cxszl5sToAqp4nNvSCElY+7z8e819P5t8k8njJZcQEmlFbxC68
         EVD5FfCdD9yTRcEH6AVwoqef9vSgdyCVZGphEO9s3lZUF5mS5j7TR284sItJe55J2z3g
         Z6eUORV4UvIEn6KmvTiTnVi4Z0FRvXUt/d+FvsaWb3ez0WOad7Jh4xh2EmmJM8uq+dff
         DK3kPZwfM/IZLBYRpV0dD4sqBxBCq2WOFbToTFU6CKw7XoBV3/1vNGaWBJNiuKnjKlnU
         Y9zECFt0yNmxxJDeeQWFBJhA5uhWvuerK9Sk/Fk6aYt9kdZiIbqioFuiyiBJVrYkwfXT
         fwyA==
X-Gm-Message-State: ANhLgQ0IwimKq7ORnhLpyOg2MIxce1WBWvLM/AQuXKsHUd4hDHYKdUO4
        XiOUYCHznsf9yTtdm+dTpPXra7L1DkQ=
X-Google-Smtp-Source: ADFU+vsXXeTxirEDSSltSjmd6TkQnozaBNjQKPhhad6g8T0PteTYpgr+YTfZV+AJpf0BRrESNS97DQ==
X-Received: by 2002:a63:6841:: with SMTP id d62mr3567949pgc.86.1583945123984;
        Wed, 11 Mar 2020 09:45:23 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x14sm1095852pfn.191.2020.03.11.09.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 09:45:23 -0700 (PDT)
Subject: Re: [PATCH 5/7] ionic: Use scnprintf() for avoiding potential buffer
 overflow
To:     Takashi Iwai <tiwai@suse.de>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oss-drivers@netronome.com
References: <20200311083745.17328-1-tiwai@suse.de>
 <20200311083745.17328-6-tiwai@suse.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <46dd9e87-d34c-9adc-62f0-55c1074d0835@pensando.io>
Date:   Wed, 11 Mar 2020 09:45:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200311083745.17328-6-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/20 1:37 AM, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: oss-drivers@netronome.com
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

For ionic:
Acked-by: Shannon Nelson <snelson@pensando.io>


> ---
>   drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c |  2 +-
>   drivers/net/ethernet/pensando/ionic/ionic_lif.c           | 12 ++++++------
>   2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
> index cc311989e3d7..7d518999250d 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
> @@ -616,7 +616,7 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
>   	if (bar->iomem) {
>   		int pf;
>   
> -		msg += scnprintf(msg, end - msg,	"0.0: General/MSI-X SRAM, ");
> +		msg += scnprintf(msg, end - msg, "0.0: General/MSI-X SRAM, ");
>   		atomic_inc(&bar->refcnt);
>   		bars_free--;
>   
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index c2f5b691e0fa..09c776191edd 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -948,18 +948,18 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
>   	int i;
>   #define REMAIN(__x) (sizeof(buf) - (__x))
>   
> -	i = snprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
> +	i = scnprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
>   		     lif->rx_mode, rx_mode);
>   	if (rx_mode & IONIC_RX_MODE_F_UNICAST)
> -		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
> +		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
>   	if (rx_mode & IONIC_RX_MODE_F_MULTICAST)
> -		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
> +		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
>   	if (rx_mode & IONIC_RX_MODE_F_BROADCAST)
> -		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
> +		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
>   	if (rx_mode & IONIC_RX_MODE_F_PROMISC)
> -		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
> +		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
>   	if (rx_mode & IONIC_RX_MODE_F_ALLMULTI)
> -		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
> +		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
>   	netdev_dbg(lif->netdev, "lif%d %s\n", lif->index, buf);
>   
>   	err = ionic_adminq_post_wait(lif, &ctx);

