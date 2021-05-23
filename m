Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D14D38D93C
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 08:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhEWGII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 02:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhEWGIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 02:08:07 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F00C06138A
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 23:06:41 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u7so4454463plq.4
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 23:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bbVkNXXuvs00kg1wmTW0NePOJ70agDM+7kVTDiM2Rwk=;
        b=EKhN/IEEn8ucPc2kMoCtJMvTI7FFyrCH7TGPMxFYn8KnblpCdKYH3iZ24Bk5AA7g93
         oMKKY7iFhGENTLKCrc1NfV6HbkIk2Ap7gaq5uxaX9xYO+bl69c87lAy8NlvRld+KqXjF
         TF2Eg/S37ZvAV000stQ/oIgFg6b6yy/7YZp3VIe196TqEFTMm8ECF+B/Etl2FAdt0ZM1
         vabwnNsF58zji8ADC99oTEbA/yxZY8HQwh7IdmOuDssyeutxJS0cWzk0uVt2lDE7/E7+
         Cf3unbnsy1Bzq9GDTSMaInhhlEMuXmYUSK05kS2NR9WEUjU5bMApmaGjCgPPZHA957mm
         fQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bbVkNXXuvs00kg1wmTW0NePOJ70agDM+7kVTDiM2Rwk=;
        b=Xanec3dQGqbmulQ7ZxtGJwKT23l9uFtHItQJ9g0VcGB40aeDpAG2AWE4Cv6UcxZ1ky
         zMJrlF37WvuJRCTIGz8fkdUP8AlFwFj81AzzlrSk2vcrRVgDIMByA4Hu9q2w2Eg+SNZs
         5bTryMnwuW0/xcA0Bd6d1vuL3KzyaDNKeJiLGrvewif5+/ms+MwgW8HCvabrMh/k7ZaA
         mO1e6psQ+hA6PatM1lwLiP+wihUvev1LgAia4jDEgOboVi23g8K6kNQsR+gFpHtssOuA
         kVVjbAN04k8HqCyBagf3YjOjDlZv18gwTIMR12I6QR4qFBzW2Os+PG3ok+qGRbzU1LI7
         R2RA==
X-Gm-Message-State: AOAM530NF8ERSr7AkndVNackPnSV0O4Qmh3e/ENymtTpGUjjOQD65wFV
        95c1NJpZGVWS2W95pokFUzLwlg==
X-Google-Smtp-Source: ABdhPJxh6WeuHEv6gwxD9/kjJ2L0haPbr+6jWPGSMs++xnAQGZrM7RPHx8y37vVl06rkgkzX4CpMBA==
X-Received: by 2002:a17:90a:5309:: with SMTP id x9mr8657357pjh.111.1621750001434;
        Sat, 22 May 2021 23:06:41 -0700 (PDT)
Received: from dragon (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id m191sm8367175pga.88.2021.05.22.23.06.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 May 2021 23:06:41 -0700 (PDT)
Date:   Sun, 23 May 2021 14:06:34 +0800
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH v3] brcmfmac: support parse country code map from DT
Message-ID: <20210523060633.GC29015@dragon>
References: <20210417075428.2671-1-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417075428.2671-1-shawn.guo@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 03:54:28PM +0800, Shawn Guo wrote:
> With any regulatory domain requests coming from either user space or
> 802.11 IE (Information Element), the country is coded in ISO3166
> standard.  It needs to be translated to firmware country code and
> revision with the mapping info in settings->country_codes table.
> Support populate country_codes table by parsing the mapping from DT.
> 
> The BRCMF_BUSTYPE_SDIO bus_type check gets separated from general DT
> validation, so that country code can be handled as general part rather
> than SDIO bus specific one.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Changes for v3:
>  - Add missing terminating '\n' in brcmf_dbg(INFO, ...) format string.

Hi Kalle,

Any comments on this version?

Shawn


> 
>  .../wireless/broadcom/brcm80211/brcmfmac/of.c | 57 ++++++++++++++++++-
>  1 file changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index a7554265f95f..2f7bc3a70c65 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -12,12 +12,59 @@
>  #include "common.h"
>  #include "of.h"
>  
> +static int brcmf_of_get_country_codes(struct device *dev,
> +				      struct brcmf_mp_device *settings)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct brcmfmac_pd_cc_entry *cce;
> +	struct brcmfmac_pd_cc *cc;
> +	int count;
> +	int i;
> +
> +	count = of_property_count_strings(np, "brcm,ccode-map");
> +	if (count < 0) {
> +		/* The property is optional, so return success if it doesn't
> +		 * exist. Otherwise propagate the error code.
> +		 */
> +		return (count == -EINVAL) ? 0 : count;
> +	}
> +
> +	cc = devm_kzalloc(dev, sizeof(*cc) + count * sizeof(*cce), GFP_KERNEL);
> +	if (!cc)
> +		return -ENOMEM;
> +
> +	cc->table_size = count;
> +
> +	for (i = 0; i < count; i++) {
> +		const char *map;
> +
> +		cce = &cc->table[i];
> +
> +		if (of_property_read_string_index(np, "brcm,ccode-map",
> +						  i, &map))
> +			continue;
> +
> +		/* String format e.g. US-Q2-86 */
> +		if (sscanf(map, "%2c-%2c-%d", cce->iso3166, cce->cc,
> +			   &cce->rev) != 3)
> +			brcmf_err("failed to read country map %s\n", map);
> +		else
> +			brcmf_dbg(INFO, "%s-%s-%d\n", cce->iso3166, cce->cc,
> +				  cce->rev);
> +	}
> +
> +	settings->country_codes = cc;
> +
> +	return 0;
> +}
> +
>  void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>  		    struct brcmf_mp_device *settings)
>  {
>  	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
>  	struct device_node *root, *np = dev->of_node;
>  	int irq;
> +	int err;
>  	u32 irqf;
>  	u32 val;
>  
> @@ -43,8 +90,14 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>  		of_node_put(root);
>  	}
>  
> -	if (!np || bus_type != BRCMF_BUSTYPE_SDIO ||
> -	    !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
> +	if (!np || !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
> +		return;
> +
> +	err = brcmf_of_get_country_codes(dev, settings);
> +	if (err)
> +		brcmf_err("failed to get OF country code map (err=%d)\n", err);
> +
> +	if (bus_type != BRCMF_BUSTYPE_SDIO)
>  		return;
>  
>  	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
> -- 
> 2.17.1
> 
