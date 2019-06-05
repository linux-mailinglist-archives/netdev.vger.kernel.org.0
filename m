Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2FE35816
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 09:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfFEHy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 03:54:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42422 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfFEHy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 03:54:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id go2so9387957plb.9
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 00:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aiue8tHWiumr4g0nytcyTjYaJHwPhuqRgFXgCDSDwM0=;
        b=KGG4kw7mp5EISlgpPMNpn5iOHG3+VLhZMDhZ+778rosnxJtQ2DdjdZ5tkcWiWRFGGX
         13t7oW58cPGQVxfvPViY7GfglNUiaobpnuA5U9Lhk/zaJJvJa8iiwJxVGhf39no86EP+
         tHTVDIzoVY5+6E11qiOyJvAD7RzmosldNH4nY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aiue8tHWiumr4g0nytcyTjYaJHwPhuqRgFXgCDSDwM0=;
        b=IRKtHcbC3Ehez5exwnnmN4AXGMEVv5+7d9p7Zq5xogTcPj5hkf2tGegkVCKicx2MD2
         9y8GX+P8jRX6xkNClYKvkMlOTdo5n7pkTLt/cnWEoGljQGxROEIYeOCqfYArxxYiCPOW
         SZlIfadh7cjDPVYvlTcAR3PhHcft7AmGCcTYWuKZE0HHG1huefU6oWjKoD7kkhvss/UQ
         nWfuTCZcEcgQ3WfLlEG2kpCw40nAvqrv7ZgPU5UPfLeQ3ht7gYkywLuz+7LLP+m1MrqB
         /V1iPR7kR3KerZ+NpTQTxQsPfnpxL/8LBEnjrrpXJDfNbFmYvJHzB2FncKLKs3ziX6vx
         Zl+Q==
X-Gm-Message-State: APjAAAU5pLjxhopG7Fzw7Rw9R78g8qHmBga4CSw0UquK0aXaNSztVIsA
        3LznjuLuXi8z9VIa4sv+75VreQ==
X-Google-Smtp-Source: APXvYqx1Gbz9qsU2PuuHu8YloVvKfIX0ptj4e8Hzpp+GXSquNY3RQsHEhI2ABswO9YBHJkaCFOSHnA==
X-Received: by 2002:a17:902:8a87:: with SMTP id p7mr25322779plo.124.1559721294846;
        Wed, 05 Jun 2019 00:54:54 -0700 (PDT)
Received: from [10.230.40.234] ([192.19.215.250])
        by smtp.gmail.com with ESMTPSA id 11sm28366590pfu.155.2019.06.05.00.54.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 00:54:54 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] mmc: core: API for temporarily disabling
 auto-retuning due to errors
To:     Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20190603183740.239031-1-dianders@chromium.org>
 <20190603183740.239031-3-dianders@chromium.org>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <25fe1725-76fa-2739-1427-b0e8823ea4ae@broadcom.com>
Date:   Wed, 5 Jun 2019 09:54:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603183740.239031-3-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/2019 8:37 PM, Douglas Anderson wrote:
> Normally when the MMC core sees an "-EILSEQ" error returned by a host
> controller then it will trigger a retuning of the card.  This is
> generally a good idea.
> 
> However, if a command is expected to sometimes cause transfer errors
> then these transfer errors shouldn't cause a re-tuning.  This
> re-tuning will be a needless waste of time.  One example case where a
> transfer is expected to cause errors is when transitioning between
> idle (sometimes referred to as "sleep" in Broadcom code) and active
> state on certain Broadcom WiFi cards.  Specifically if the card was
> already transitioning between states when the command was sent it
> could cause an error on the SDIO bus.
> 
> Let's add an API that the SDIO card drivers can call that will
> temporarily disable the auto-tuning functionality.  Then we can add a
> call to this in the Broadcom WiFi driver and any other driver that
> might have similar needs.
> 
> NOTE: this makes the assumption that the card is already tuned well
> enough that it's OK to disable the auto-retuning during one of these
> error-prone situations.  Presumably the driver code performing the
> error-prone transfer knows how to recover / retry from errors.  ...and
> after we can get back to a state where transfers are no longer
> error-prone then we can enable the auto-retuning again.  If we truly
> find ourselves in a case where the card needs to be retuned sometimes
> to handle one of these error-prone transfers then we can always try a
> few transfers first without auto-retuning and then re-try with
> auto-retuning if the first few fail.
> 
> Without this change on rk3288-veyron-minnie I periodically see this in
> the logs of a machine just sitting there idle:
>    dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ
> 
> Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> Note that are are a whole boatload of different ways that we could
> provide an API for the Broadcom WiFi SDIO driver.  This patch
> illustrates one way but if maintainers feel strongly that this is too
> ugly and have a better idea then I can give it a shot too.  From a
> purist point of view I kinda felt that the "expect errors" really
> belonged as part of the mmc_request structure, but getting it into
> there meant changing a whole pile of core SD/MMC APIs.  Simply adding
> it to the host seemed to match the current style better and was a less
> intrusive change.

Hi Doug,

Sorry for bringing this up, but there used to be an issue with retuning 
in general, ie. the device handled tuning command 19 only once after 
startup. I guess that is no longer an issue given your results. I guess 
the problem goes away when you disable device sleep functionality. No 
what you want in terms of power consumption, but would be good to know. 
You can disable it with below patch.

Regards,
Arend
---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c 
b/drivers
index 15a40fd..18e90bd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -307,7 +307,7 @@ struct rte_console {
  #define BRCMF_IDLE_ACTIVE      0       /* Do not request any SD clock 
change
                                          * when idle
                                          */
-#define BRCMF_IDLE_INTERVAL    1
+#define BRCMF_IDLE_INTERVAL    0

  #define KSO_WAIT_US 50
  #define MAX_KSO_ATTEMPTS (PMU_MAX_TRANSITION_DLY/KSO_WAIT_US)

