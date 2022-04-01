Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1632A4EF64D
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350003AbiDAPdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349958AbiDAPQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 11:16:40 -0400
X-Greylist: delayed 343 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Apr 2022 07:58:28 PDT
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8C913D0E;
        Fri,  1 Apr 2022 07:58:27 -0700 (PDT)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 209AC2D110;
        Fri,  1 Apr 2022 14:52:45 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.135])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 70EBE1C0089;
        Fri,  1 Apr 2022 14:52:42 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 26BB74C0138;
        Fri,  1 Apr 2022 14:52:41 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.67.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B183713C2B0;
        Fri,  1 Apr 2022 07:52:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B183713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1648824760;
        bh=bGvvD9BfJY61T2tMT42tvSMjUobjVyvZHsDXQYcWU5c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=h0hGLcKz7uKulGDKu2m2t/4/y6z/TyXPR60UndP5pEFmDmEbl+PPiUY1M7QMw236U
         ufn6pA+iciwax222UkFD0Lagl04cGBT9rcOlwVg9u4Nv4gJCV3Iz9pC8JxUPETno30
         uZyc+GQC/9nhcadVMK8pzXRLEUsGTmqLHK8CbhxM=
Subject: Re: [PATCH AUTOSEL 5.17 079/149] iwlwifi: mvm: Passively scan non PSC
 channels only when requested so
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, avraham.stern@intel.com,
        ayala.beker@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220401142536.1948161-1-sashal@kernel.org>
 <20220401142536.1948161-79-sashal@kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <acabc18a-79ff-9080-232e-532c321bdbae@candelatech.com>
Date:   Fri, 1 Apr 2022 07:52:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220401142536.1948161-79-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1648824763-xZYaCzvdYZn0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I had to revert this patch in my 5.17+ kernel (with 5.18-ish iwlwifi patches backported)
to get the station to properly scan and connect to a vendor's AP.

I got zero response to my earlier email about that regression.

I think this is not something that should be added to stable builds at this time.

Thanks,
Ben

On 4/1/22 7:24 AM, Sasha Levin wrote:
> From: Ilan Peer <ilan.peer@intel.com>
> 
> [ Upstream commit 9966904e9472703a05861f343157cd78f47514fd ]
> 
> Non PSC channels should generally be scanned based on information about
> collocated APs obtained during scan on legacy bands, and otherwise
> should not be scanned unless specifically requested so (as there are
> relatively many non PSC channels, scanning them passively is time consuming
> and interferes with regular data traffic).
> 
> Thus, modify the scan logic to avoid passively scanning PSC channels
> if there is no information about collocated APs and the scan is not
> a passive scan.
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Link: https://lore.kernel.org/r/iwlwifi.20220204122220.457da4cc95eb.Ic98472bab5f5475f1e102547644caaae89ce4c4a@changeid
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 42 ++++++++++++++-----
>   1 file changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> index 4cd507cb412d..630cfb64c6b1 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> @@ -1735,27 +1735,37 @@ iwl_mvm_umac_scan_fill_6g_chan_list(struct iwl_mvm *mvm,
>   }
>   
>   /* TODO: this function can be merged with iwl_mvm_scan_umac_fill_ch_p_v6 */
> -static void
> -iwl_mvm_umac_scan_cfg_channels_v6_6g(struct iwl_mvm_scan_params *params,
> +static u32
> +iwl_mvm_umac_scan_cfg_channels_v6_6g(struct iwl_mvm *mvm,
> +				     struct iwl_mvm_scan_params *params,
>   				     u32 n_channels,
>   				     struct iwl_scan_probe_params_v4 *pp,
>   				     struct iwl_scan_channel_params_v6 *cp,
>   				     enum nl80211_iftype vif_type)
>   {
> -	struct iwl_scan_channel_cfg_umac *channel_cfg = cp->channel_config;
>   	int i;
>   	struct cfg80211_scan_6ghz_params *scan_6ghz_params =
>   		params->scan_6ghz_params;
> +	u32 ch_cnt;
>   
> -	for (i = 0; i < params->n_channels; i++) {
> +	for (i = 0, ch_cnt = 0; i < params->n_channels; i++) {
>   		struct iwl_scan_channel_cfg_umac *cfg =
> -			&cp->channel_config[i];
> +			&cp->channel_config[ch_cnt];
>   
>   		u32 s_ssid_bitmap = 0, bssid_bitmap = 0, flags = 0;
>   		u8 j, k, s_max = 0, b_max = 0, n_used_bssid_entries;
>   		bool force_passive, found = false, allow_passive = true,
>   		     unsolicited_probe_on_chan = false, psc_no_listen = false;
>   
> +		/*
> +		 * Avoid performing passive scan on non PSC channels unless the
> +		 * scan is specifically a passive scan, i.e., no SSIDs
> +		 * configured in the scan command.
> +		 */
> +		if (!cfg80211_channel_is_psc(params->channels[i]) &&
> +		    !params->n_6ghz_params && params->n_ssids)
> +			continue;
> +
>   		cfg->v1.channel_num = params->channels[i]->hw_value;
>   		cfg->v2.band = 2;
>   		cfg->v2.iter_count = 1;
> @@ -1875,8 +1885,16 @@ iwl_mvm_umac_scan_cfg_channels_v6_6g(struct iwl_mvm_scan_params *params,
>   		else
>   			flags |= bssid_bitmap | (s_ssid_bitmap << 16);
>   
> -		channel_cfg[i].flags |= cpu_to_le32(flags);
> +		cfg->flags |= cpu_to_le32(flags);
> +		ch_cnt++;
>   	}
> +
> +	if (params->n_channels > ch_cnt)
> +		IWL_DEBUG_SCAN(mvm,
> +			       "6GHz: reducing number channels: (%u->%u)\n",
> +			       params->n_channels, ch_cnt);
> +
> +	return ch_cnt;
>   }
>   
>   static u8 iwl_mvm_scan_umac_chan_flags_v2(struct iwl_mvm *mvm,
> @@ -2424,10 +2442,14 @@ static int iwl_mvm_scan_umac_v14_and_above(struct iwl_mvm *mvm,
>   	if (ret)
>   		return ret;
>   
> -	iwl_mvm_umac_scan_cfg_channels_v6_6g(params,
> -					     params->n_channels,
> -					     pb, cp, vif->type);
> -	cp->count = params->n_channels;
> +	cp->count = iwl_mvm_umac_scan_cfg_channels_v6_6g(mvm, params,
> +							 params->n_channels,
> +							 pb, cp, vif->type);
> +	if (!cp->count) {
> +		mvm->scan_uid_status[uid] = 0;
> +		return -EINVAL;
> +	}
> +
>   	if (!params->n_ssids ||
>   	    (params->n_ssids == 1 && !params->ssids[0].ssid_len))
>   		cp->flags |= IWL_SCAN_CHANNEL_FLAG_6G_PSC_NO_FILTER;
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
