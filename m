Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59FD695FF9
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjBNJ5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjBNJ4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:56:35 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFBDC644
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:56:31 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id h24so16906201qtr.0
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TGyuHibaM3No1UMjgpCUG2OZS15Xjv6DL/Ux73DFqms=;
        b=TmtDMPqeqkYuEFAk6zM6i/QHGvS2wV8iP78UUy0FEvEOCAJQBh0LPEMhSa1BFllI9B
         XzjjoGEzHXKIq3ZF+MqnUBpWvmY4jaAb8vhQD/vM5yEHmSqFdKZmk724LOeDnxzLA3gq
         djNHUOfmEyknJksuIKYEguy/Mz4rltDdSj++E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGyuHibaM3No1UMjgpCUG2OZS15Xjv6DL/Ux73DFqms=;
        b=dHx6fUHMjwBpqZma/hmnnONJkvkhxX+LMgN7yfHsZWs/9yrbP9WmSMbIAttKmmqMmh
         90hAMvOHasIjSoicVN9WGNoyguIzcbKsPv6IDnqFhLaky9DQFTtiyQG1uv0MyPcP0kcP
         EL1t6dQQHBzDb1OY05xos5F7W8LrJqvLgdCF4d0ygORVmeovSP7kJtGhFugkCKg1vtsQ
         dwZSNssC6szdwGSIsCR3j3ckejIy8OGM21oUUqR+svK+Botp59hw/98viPMDag3EmKuU
         7n2NamOQ2wsXdxVDNsic+c6+NspOi/AlIX1purgSrN2qqEV7buUHi7MiZ46B5GEDW3Le
         /wlQ==
X-Gm-Message-State: AO0yUKUsLiFtuh3dsP6kxFj1myROIBVYPWLBZ8+NoSR/z1JtVUvIu98U
        lgruVzqAse7tN14StWYVYr1wlA==
X-Google-Smtp-Source: AK7set9BdNERVuy3swNTAgzXesrYzeOqqd2uR0yMXq5yEsNA2Unt0BW7pgWAJJGpqH1v/IxlKD4ZLg==
X-Received: by 2002:ac8:5816:0:b0:3b8:ea00:7021 with SMTP id g22-20020ac85816000000b003b8ea007021mr2836330qtg.28.1676368590423;
        Tue, 14 Feb 2023 01:56:30 -0800 (PST)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id u1-20020ac83d41000000b003b643951117sm10983851qtf.38.2023.02.14.01.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 01:56:29 -0800 (PST)
Message-ID: <ae62d079-94e8-3c1d-7ac9-5e1b3a3b4614@broadcom.com>
Date:   Tue, 14 Feb 2023 10:56:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 03/10] brcmfmac: cfg80211: Add support for scan params v2
To:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214091651.10178-1-marcan@marcan.st>
 <20230214092423.15175-3-marcan@marcan.st>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20230214092423.15175-3-marcan@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005dcf7405f4a5faca"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005dcf7405f4a5faca
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/2023 10:24 AM, Hector Martin wrote:
> This new API version is required for at least the BCM4387 firmware. Add
> support for it, with a fallback to the v1 API.

This one is on my TODO list because both WCC and BCA chips have a 
scanv2, but they are different. Anyway, I will have to sort that out 
afterwards ;-)

Thanks,
Arend

> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>   .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 245 +++++++++++-------
>   .../broadcom/brcm80211/brcmfmac/feature.c     |   1 +
>   .../broadcom/brcm80211/brcmfmac/feature.h     |   4 +-
>   .../broadcom/brcm80211/brcmfmac/fwil_types.h  |  49 +++-
>   4 files changed, 209 insertions(+), 90 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index a9690ec4c850..3e006b783f3f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -1039,12 +1039,134 @@ void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
>   	}
>   }
>   
> +static void brcmf_scan_params_v2_to_v1(struct brcmf_scan_params_v2_le *params_v2_le,
> +				       struct brcmf_scan_params_le *params_le)
> +{
> +	size_t params_size;
> +	u32 ch;
> +	int n_channels, n_ssids;
> +
> +	memcpy(&params_le->ssid_le, &params_v2_le->ssid_le,
> +	       sizeof(params_le->ssid_le));
> +	memcpy(&params_le->bssid, &params_v2_le->bssid,
> +	       sizeof(params_le->bssid));
> +
> +	params_le->bss_type = params_v2_le->bss_type;
> +	params_le->scan_type = le32_to_cpu(params_v2_le->scan_type);
> +	params_le->nprobes = params_v2_le->nprobes;
> +	params_le->active_time = params_v2_le->active_time;
> +	params_le->passive_time = params_v2_le->passive_time;
> +	params_le->home_time = params_v2_le->home_time;
> +	params_le->channel_num = params_v2_le->channel_num;
> +
> +	ch = le32_to_cpu(params_v2_le->channel_num);
> +	n_channels = ch & BRCMF_SCAN_PARAMS_COUNT_MASK;
> +	n_ssids = ch >> BRCMF_SCAN_PARAMS_NSSID_SHIFT;
> +
> +	params_size = sizeof(u16) * n_channels;
> +	if (n_ssids > 0) {
> +		params_size = roundup(params_size, sizeof(u32));
> +		params_size += sizeof(struct brcmf_ssid_le) * n_ssids;
> +	}
> +
> +	memcpy(&params_le->channel_list[0],
> +	       &params_v2_le->channel_list[0], params_size);
> +}
> +
> +static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
> +			     struct brcmf_scan_params_v2_le *params_le,
> +			     struct cfg80211_scan_request *request)
> +{
> +	u32 n_ssids;
> +	u32 n_channels;
> +	s32 i;
> +	s32 offset;
> +	u16 chanspec;
> +	char *ptr;
> +	int length;
> +	struct brcmf_ssid_le ssid_le;
> +
> +	eth_broadcast_addr(params_le->bssid);
> +
> +	length = BRCMF_SCAN_PARAMS_V2_FIXED_SIZE;
> +
> +	params_le->version = cpu_to_le16(BRCMF_SCAN_PARAMS_VERSION_V2);
> +	params_le->bss_type = DOT11_BSSTYPE_ANY;
> +	params_le->scan_type = cpu_to_le32(BRCMF_SCANTYPE_ACTIVE);
> +	params_le->channel_num = 0;
> +	params_le->nprobes = cpu_to_le32(-1);
> +	params_le->active_time = cpu_to_le32(-1);
> +	params_le->passive_time = cpu_to_le32(-1);
> +	params_le->home_time = cpu_to_le32(-1);
> +	memset(&params_le->ssid_le, 0, sizeof(params_le->ssid_le));
> +
> +	/* Scan abort */
> +	if (!request) {
> +		length += sizeof(u16);
> +		params_le->channel_num = cpu_to_le32(1);
> +		params_le->channel_list[0] = cpu_to_le16(-1);
> +		params_le->length = cpu_to_le16(length);
> +		return;
> +	}
> +
> +	n_ssids = request->n_ssids;
> +	n_channels = request->n_channels;
> +
> +	/* Copy channel array if applicable */
> +	brcmf_dbg(SCAN, "### List of channelspecs to scan ### %d\n",
> +		  n_channels);
> +	if (n_channels > 0) {
> +		length += roundup(sizeof(u16) * n_channels, sizeof(u32));
> +		for (i = 0; i < n_channels; i++) {
> +			chanspec = channel_to_chanspec(&cfg->d11inf,
> +						       request->channels[i]);
> +			brcmf_dbg(SCAN, "Chan : %d, Channel spec: %x\n",
> +				  request->channels[i]->hw_value, chanspec);
> +			params_le->channel_list[i] = cpu_to_le16(chanspec);
> +		}
> +	} else {
> +		brcmf_dbg(SCAN, "Scanning all channels\n");
> +	}
> +
> +	/* Copy ssid array if applicable */
> +	brcmf_dbg(SCAN, "### List of SSIDs to scan ### %d\n", n_ssids);
> +	if (n_ssids > 0) {
> +		offset = offsetof(struct brcmf_scan_params_v2_le, channel_list) +
> +				n_channels * sizeof(u16);
> +		offset = roundup(offset, sizeof(u32));
> +		length += sizeof(ssid_le) * n_ssids,
> +		ptr = (char *)params_le + offset;
> +		for (i = 0; i < n_ssids; i++) {
> +			memset(&ssid_le, 0, sizeof(ssid_le));
> +			ssid_le.SSID_len =
> +					cpu_to_le32(request->ssids[i].ssid_len);
> +			memcpy(ssid_le.SSID, request->ssids[i].ssid,
> +			       request->ssids[i].ssid_len);
> +			if (!ssid_le.SSID_len)
> +				brcmf_dbg(SCAN, "%d: Broadcast scan\n", i);
> +			else
> +				brcmf_dbg(SCAN, "%d: scan for  %.32s size=%d\n",
> +					  i, ssid_le.SSID, ssid_le.SSID_len);
> +			memcpy(ptr, &ssid_le, sizeof(ssid_le));
> +			ptr += sizeof(ssid_le);
> +		}
> +	} else {
> +		brcmf_dbg(SCAN, "Performing passive scan\n");
> +		params_le->scan_type = cpu_to_le32(BRCMF_SCANTYPE_PASSIVE);
> +	}
> +	params_le->length = cpu_to_le16(length);
> +	/* Adding mask to channel numbers */
> +	params_le->channel_num =
> +		cpu_to_le32((n_ssids << BRCMF_SCAN_PARAMS_NSSID_SHIFT) |
> +			(n_channels & BRCMF_SCAN_PARAMS_COUNT_MASK));
> +}
> +
>   s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
>   				struct brcmf_if *ifp, bool aborted,
>   				bool fw_abort)
>   {
>   	struct brcmf_pub *drvr = cfg->pub;
> -	struct brcmf_scan_params_le params_le;
> +	struct brcmf_scan_params_v2_le params_v2_le;
>   	struct cfg80211_scan_request *scan_request;
>   	u64 reqid;
>   	u32 bucket;
> @@ -1063,20 +1185,23 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
>   	if (fw_abort) {
>   		/* Do a scan abort to stop the driver's scan engine */
>   		brcmf_dbg(SCAN, "ABORT scan in firmware\n");
> -		memset(&params_le, 0, sizeof(params_le));
> -		eth_broadcast_addr(params_le.bssid);
> -		params_le.bss_type = DOT11_BSSTYPE_ANY;
> -		params_le.scan_type = 0;
> -		params_le.channel_num = cpu_to_le32(1);
> -		params_le.nprobes = cpu_to_le32(1);
> -		params_le.active_time = cpu_to_le32(-1);
> -		params_le.passive_time = cpu_to_le32(-1);
> -		params_le.home_time = cpu_to_le32(-1);
> -		/* Scan is aborted by setting channel_list[0] to -1 */
> -		params_le.channel_list[0] = cpu_to_le16(-1);
> +
> +		brcmf_escan_prep(cfg, &params_v2_le, NULL);
> +
>   		/* E-Scan (or anyother type) can be aborted by SCAN */
> -		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
> -					     &params_le, sizeof(params_le));
> +		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SCAN_V2)) {
> +			err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
> +						     &params_v2_le,
> +						     sizeof(params_v2_le));
> +		} else {
> +			struct brcmf_scan_params_le params_le;
> +
> +			brcmf_scan_params_v2_to_v1(&params_v2_le, &params_le);
> +			err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
> +						     &params_le,
> +						     sizeof(params_le));
> +		}
> +
>   		if (err)
>   			bphy_err(drvr, "Scan abort failed\n");
>   	}
> @@ -1295,83 +1420,13 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
>   	return err;
>   }
>   
> -static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
> -			     struct brcmf_scan_params_le *params_le,
> -			     struct cfg80211_scan_request *request)
> -{
> -	u32 n_ssids;
> -	u32 n_channels;
> -	s32 i;
> -	s32 offset;
> -	u16 chanspec;
> -	char *ptr;
> -	struct brcmf_ssid_le ssid_le;
> -
> -	eth_broadcast_addr(params_le->bssid);
> -	params_le->bss_type = DOT11_BSSTYPE_ANY;
> -	params_le->scan_type = BRCMF_SCANTYPE_ACTIVE;
> -	params_le->channel_num = 0;
> -	params_le->nprobes = cpu_to_le32(-1);
> -	params_le->active_time = cpu_to_le32(-1);
> -	params_le->passive_time = cpu_to_le32(-1);
> -	params_le->home_time = cpu_to_le32(-1);
> -	memset(&params_le->ssid_le, 0, sizeof(params_le->ssid_le));
> -
> -	n_ssids = request->n_ssids;
> -	n_channels = request->n_channels;
> -
> -	/* Copy channel array if applicable */
> -	brcmf_dbg(SCAN, "### List of channelspecs to scan ### %d\n",
> -		  n_channels);
> -	if (n_channels > 0) {
> -		for (i = 0; i < n_channels; i++) {
> -			chanspec = channel_to_chanspec(&cfg->d11inf,
> -						       request->channels[i]);
> -			brcmf_dbg(SCAN, "Chan : %d, Channel spec: %x\n",
> -				  request->channels[i]->hw_value, chanspec);
> -			params_le->channel_list[i] = cpu_to_le16(chanspec);
> -		}
> -	} else {
> -		brcmf_dbg(SCAN, "Scanning all channels\n");
> -	}
> -	/* Copy ssid array if applicable */
> -	brcmf_dbg(SCAN, "### List of SSIDs to scan ### %d\n", n_ssids);
> -	if (n_ssids > 0) {
> -		offset = offsetof(struct brcmf_scan_params_le, channel_list) +
> -				n_channels * sizeof(u16);
> -		offset = roundup(offset, sizeof(u32));
> -		ptr = (char *)params_le + offset;
> -		for (i = 0; i < n_ssids; i++) {
> -			memset(&ssid_le, 0, sizeof(ssid_le));
> -			ssid_le.SSID_len =
> -					cpu_to_le32(request->ssids[i].ssid_len);
> -			memcpy(ssid_le.SSID, request->ssids[i].ssid,
> -			       request->ssids[i].ssid_len);
> -			if (!ssid_le.SSID_len)
> -				brcmf_dbg(SCAN, "%d: Broadcast scan\n", i);
> -			else
> -				brcmf_dbg(SCAN, "%d: scan for  %.32s size=%d\n",
> -					  i, ssid_le.SSID, ssid_le.SSID_len);
> -			memcpy(ptr, &ssid_le, sizeof(ssid_le));
> -			ptr += sizeof(ssid_le);
> -		}
> -	} else {
> -		brcmf_dbg(SCAN, "Performing passive scan\n");
> -		params_le->scan_type = BRCMF_SCANTYPE_PASSIVE;
> -	}
> -	/* Adding mask to channel numbers */
> -	params_le->channel_num =
> -		cpu_to_le32((n_ssids << BRCMF_SCAN_PARAMS_NSSID_SHIFT) |
> -			(n_channels & BRCMF_SCAN_PARAMS_COUNT_MASK));
> -}
> -
>   static s32
>   brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
>   		struct cfg80211_scan_request *request)
>   {
>   	struct brcmf_pub *drvr = cfg->pub;
> -	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
> -			  offsetof(struct brcmf_escan_params_le, params_le);
> +	s32 params_size = BRCMF_SCAN_PARAMS_V2_FIXED_SIZE +
> +			  offsetof(struct brcmf_escan_params_le, params_v2_le);
>   	struct brcmf_escan_params_le *params;
>   	s32 err = 0;
>   
> @@ -1391,8 +1446,22 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
>   		goto exit;
>   	}
>   	BUG_ON(params_size + sizeof("escan") >= BRCMF_DCMD_MEDLEN);
> -	brcmf_escan_prep(cfg, &params->params_le, request);
> -	params->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
> +	brcmf_escan_prep(cfg, &params->params_v2_le, request);
> +
> +	params->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION_V2);
> +
> +	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SCAN_V2)) {
> +		struct brcmf_escan_params_le *params_v1;
> +
> +		params_size -= BRCMF_SCAN_PARAMS_V2_FIXED_SIZE;
> +		params_size += BRCMF_SCAN_PARAMS_FIXED_SIZE;
> +		params_v1 = kzalloc(params_size, GFP_KERNEL);
> +		params_v1->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
> +		brcmf_scan_params_v2_to_v1(&params->params_v2_le, &params_v1->params_le);
> +		kfree(params);
> +		params = params_v1;
> +	}
> +
>   	params->action = cpu_to_le16(WL_ESCAN_ACTION_START);
>   	params->sync_id = cpu_to_le16(0x1234);
>   
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> index 10bac865d724..b6797f800e55 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> @@ -290,6 +290,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
>   		ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_SCAN_RANDOM_MAC);
>   
>   	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
> +	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_SCAN_V2, "scan_ver");
>   
>   	if (drvr->settings->feature_disable) {
>   		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> index f1b086a69d73..549298c55b55 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> @@ -30,6 +30,7 @@
>    * SAE: simultaneous authentication of equals
>    * FWAUTH: Firmware authenticator
>    * DUMP_OBSS: Firmware has capable to dump obss info to support ACS
> + * SCAN_V2: Version 2 scan params
>    */
>   #define BRCMF_FEAT_LIST \
>   	BRCMF_FEAT_DEF(MBSS) \
> @@ -53,7 +54,8 @@
>   	BRCMF_FEAT_DEF(DOT11H) \
>   	BRCMF_FEAT_DEF(SAE) \
>   	BRCMF_FEAT_DEF(FWAUTH) \
> -	BRCMF_FEAT_DEF(DUMP_OBSS)
> +	BRCMF_FEAT_DEF(DUMP_OBSS) \
> +	BRCMF_FEAT_DEF(SCAN_V2)
>   
>   /*
>    * Quirks:
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> index 04e1beedfd81..b3844d0d1adb 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> @@ -48,6 +48,10 @@
>   
>   /* size of brcmf_scan_params not including variable length array */
>   #define BRCMF_SCAN_PARAMS_FIXED_SIZE	64
> +#define BRCMF_SCAN_PARAMS_V2_FIXED_SIZE	72
> +
> +/* version of brcmf_scan_params structure */
> +#define BRCMF_SCAN_PARAMS_VERSION_V2	2
>   
>   /* masks for channel and ssid count */
>   #define BRCMF_SCAN_PARAMS_COUNT_MASK	0x0000ffff
> @@ -67,6 +71,7 @@
>   #define BRCMF_PRIMARY_KEY		(1 << 1)
>   #define DOT11_BSSTYPE_ANY		2
>   #define BRCMF_ESCAN_REQ_VERSION		1
> +#define BRCMF_ESCAN_REQ_VERSION_V2	2
>   
>   #define BRCMF_MAXRATES_IN_SET		16	/* max # of rates in rateset */
>   
> @@ -386,6 +391,45 @@ struct brcmf_scan_params_le {
>   	__le16 channel_list[1];	/* list of chanspecs */
>   };
>   
> +struct brcmf_scan_params_v2_le {
> +	__le16 version;		/* structure version */
> +	__le16 length;		/* structure length */
> +	struct brcmf_ssid_le ssid_le;	/* default: {0, ""} */
> +	u8 bssid[ETH_ALEN];	/* default: bcast */
> +	s8 bss_type;		/* default: any,
> +				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
> +				 */
> +	u8 pad;
> +	__le32 scan_type;	/* flags, 0 use default */
> +	__le32 nprobes;		/* -1 use default, number of probes per channel */
> +	__le32 active_time;	/* -1 use default, dwell time per channel for
> +				 * active scanning
> +				 */
> +	__le32 passive_time;	/* -1 use default, dwell time per channel
> +				 * for passive scanning
> +				 */
> +	__le32 home_time;	/* -1 use default, dwell time for the
> +				 * home channel between channel scans
> +				 */
> +	__le32 channel_num;	/* count of channels and ssids that follow
> +				 *
> +				 * low half is count of channels in
> +				 * channel_list, 0 means default (use all
> +				 * available channels)
> +				 *
> +				 * high half is entries in struct brcmf_ssid
> +				 * array that follows channel_list, aligned for
> +				 * s32 (4 bytes) meaning an odd channel count
> +				 * implies a 2-byte pad between end of
> +				 * channel_list and first ssid
> +				 *
> +				 * if ssid count is zero, single ssid in the
> +				 * fixed parameter portion is assumed, otherwise
> +				 * ssid in the fixed portion is ignored
> +				 */
> +	__le16 channel_list[1];	/* list of chanspecs */
> +};
> +
>   struct brcmf_scan_results {
>   	u32 buflen;
>   	u32 version;
> @@ -397,7 +441,10 @@ struct brcmf_escan_params_le {
>   	__le32 version;
>   	__le16 action;
>   	__le16 sync_id;
> -	struct brcmf_scan_params_le params_le;
> +	union {
> +		struct brcmf_scan_params_le params_le;
> +		struct brcmf_scan_params_v2_le params_v2_le;
> +	};
>   };
>   
>   struct brcmf_escan_result_le {

--0000000000005dcf7405f4a5faca
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2Gzj3QNJRLsZu1TLyOyBBIr/BE7UiY3RabgRzknBGAPmzhS+fmyM8OtM5BYBsFBrSUFtZZO2p/tf
Nbc24J2zf2peoZ8MK+7WQqummYlOnz+FyDkA9EybeNMcS5C+xi/PAgMBAAGjggHdMIIB2TAOBgNV
HQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYI
KwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24y
Y2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqG
OGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3Js
MCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYB
BQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFIikAXd8CEtv
ZbDflDRnf3tuStPuMA0GCSqGSIb3DQEBCwUAA4IBAQCdS5XCYx6k2GGZui9DlFsFm75khkqAU7rT
zBX04sJU1+B1wtgmWTVIzW7ugdtDZ4gzaV0S9xRhpDErjJaltxPbCylb1DEsLj+AIvBR34caW6ZG
sQk444t0HPb29HnWYj+OllIGMbdJWr0/P95ZrKk2bP24ub3ZP/8SyzrohfIba9WZKMq6g2nTLZE3
BtkeSGJx/8dy0h8YmRn+adOrxKXHxhSL8BNn8wsmIZyYWe6fRcBtO3Ks2DOLyHCdkoFlN8x9VUQF
N2ulEgqCbRKkx+qNirW86eF138lr1gRxzclu/38ko//MmkAYR/+hP3WnBll7zbpIt0jc9wyFkSqH
p8a1MYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1z
YTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIMTv1t
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCBtJMHbKNofjN+pYfnq
M6OwsxiOHrL8Dm7TV0/V1VIc0DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMzAyMTQwOTU2MzBaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEA4XpZvTmy7U0gEdcivjg4sVaNGik7EdopnI94
+TW+MQrd2CepZpyH1TNmuANRznsUPlMB1uy2+PCm6k2ZbOFrgBxQvqIW8tutCelSQ2e92K6HsbtH
+fq2FaYT+TBcgiQdc4/9IJFrfZwl1dfsafizPTrPDMy/j6sTKmGC+PbA/U5ax3JtJ7P1eEixrh/o
qNO88dqzqEMqraP6DDWoHyakZ0FFTzjRWe1HTQ1RX0JIvNfOMIayoD6MRMoUGr2UtavgHarFWdld
uDABlLewSIBU/ysHGcoNkRbwsWlWyU+4rQVtOQoQ96pCdnih868KrYZfxC0V5ES+NwIVQKJ2bNkl
aA==
--0000000000005dcf7405f4a5faca--
