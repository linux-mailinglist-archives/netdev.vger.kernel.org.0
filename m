Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 266B533902
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfFCTVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:21:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36732 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCTVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:21:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id u22so11170397pfm.3;
        Mon, 03 Jun 2019 12:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pu9hCSqx8PysXiFd4y8tfcVLYuTg76vpiN0buypU1s4=;
        b=LZ6JdUYPvORvpXy9XNPxwkOZCuaMepLoaGd6Ta5FmoLrqsIpNwrFqfyc/MxyEZOgVv
         1KncqltBjEXiO+p2f8VeqEFHFX5EJyNPaJRwdPR/GG/AsZ1/dEc2UcnSLaUovr3iDYxH
         bmQutQhzgZze1quTht2vQ66+eKE4BTTwfraNCOgtgv9Y2PRL4f7V3TYNMFeogDmU5lBD
         GsfYdp03YEJeBUsKCd9IgAVoV+sIvEVcEk1UvrZyxMVYkAcZEaLQmBX7799u2HIOpOZy
         mH4PtEdQu9laJZw/jWFat0gu2QS+d200Ju7OFQhhL1BX3RhiiH7VTgV6R+BxmIp8xoNB
         IHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pu9hCSqx8PysXiFd4y8tfcVLYuTg76vpiN0buypU1s4=;
        b=nDtcfJ8sRogd8g3N7Mr9ehEKNCHL8fV3f66WicuvXsjZNek6fxAqM+fVHV7kHbLm5G
         vKbgQtwePedhtf7Vm3RSKxXAq3OsRIVZzZUJK/lYQOmibB8cgukpaGgObK13x3QqM5tm
         /gIVW7vy7jLA89KDFHv0Hg+57Oryzx+xIhKxu+/IJ9MyP/wi5yFQt1CrRKtotl+1RFTQ
         Rcy2RE9Z1wYjqi0ADgsct0DyhygszrpcKKZdPPnU3ecXTCEaV4nTkFNnWjTxusiu3Cv6
         MrADQra19xdaZkTwyMNtJXf9mLZ+XlyKWLXXr2RZwX7OhrBCTTj1PEKFTYjKGB2xEAd2
         gFIA==
X-Gm-Message-State: APjAAAUKsfmKKyqKZ8oSmlBegEa2H0GbRVWb7g/neJOl3T+jfy1qAhZS
        WLlhwsRCiBOFhJxGjqXzZDdjVPgl
X-Google-Smtp-Source: APXvYqzbOeWo6skLJnisx00Mmulb/Yd+W+8OZoLdcBaHOn2LkfzFx4N8EBusqEki0OCTNkxSMpGnog==
X-Received: by 2002:a17:90a:8d09:: with SMTP id c9mr19032878pjo.131.1559589713628;
        Mon, 03 Jun 2019 12:21:53 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a3:10e0::2ed7? ([2620:10d:c091:500::1:27b5])
        by smtp.gmail.com with ESMTPSA id t187sm16345650pfb.64.2019.06.03.12.21.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 12:21:52 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [RFC PATCH v4] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
References: <20190531091229.93033-1-chiu@endlessm.com>
Message-ID: <f1c54f97-16a5-2618-569b-9101f9657fcb@gmail.com>
Date:   Mon, 3 Jun 2019 15:21:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531091229.93033-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 5:12 AM, Chris Chiu wrote:
> We have 3 laptops which connect the wifi by the same RTL8723BU.
> The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
> They have the same problem with the in-kernel rtl8xxxu driver, the
> iperf (as a client to an ethernet-connected server) gets ~1Mbps.
> Nevertheless, the signal strength is reported as around -40dBm,
> which is quite good. From the wireshark capture, the tx rate for each
> data and qos data packet is only 1Mbps. Compare to the Realtek driver
> at https://github.com/lwfinger/rtl8723bu, the same iperf test gets
> ~12Mbps or better. The signal strength is reported similarly around
> -40dBm. That's why we want to improve.
> 
> After reading the source code of the rtl8xxxu driver and Realtek's, the
> major difference is that Realtek's driver has a watchdog which will keep
> monitoring the signal quality and updating the rate mask just like the
> rtl8xxxu_gen2_update_rate_mask() does if signal quality changes.
> And this kind of watchdog also exists in rtlwifi driver of some specific
> chips, ex rtl8192ee, rtl8188ee, rtl8723ae, rtl8821ae...etc. They have
> the same member function named dm_watchdog and will invoke the
> corresponding dm_refresh_rate_adaptive_mask to adjust the tx rate
> mask.
> 
> With this commit, the tx rate of each data and qos data packet will
> be 39Mbps (MCS4) with the 0xF00000 as the tx rate mask. The 20th bit
> to 23th bit means MCS4 to MCS7. It means that the firmware still picks
> the lowest rate from the rate mask and explains why the tx rate of
> data and qos data is always lowest 1Mbps because the default rate mask
> passed is always 0xFFFFFFF ranges from the basic CCK rate, OFDM rate,
> and MCS rate. However, with Realtek's driver, the tx rate observed from
> wireshark under the same condition is almost 65Mbps or 72Mbps.
> 
> I believe the firmware of RTL8723BU may need fix. And I think we
> can still bring in the dm_watchdog as rtlwifi to improve from the
> driver side. Please leave precious comments for my commits and
> suggest what I can do better. Or suggest if there's any better idea
> to fix this. Thanks.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>

I am really pleased to see you're investigating some of these issues,
since I've been pretty swamped and not had time to work on this driver
for a long time.

The firmware should allow for two rate modes, either firmware handled or
controlled by the driver. Ideally we would want the driver to handle it,
but I never was able to make that work reliable.

This fix should at least improve the situation, and it may explain some
of the performance issues with the 8192eu as well?

> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 8828baf26e7b..216f603827a8 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1195,6 +1195,44 @@ struct rtl8723bu_c2h {
>  
>  struct rtl8xxxu_fileops;
>  
> +/*mlme related.*/
> +enum wireless_mode {
> +	WIRELESS_MODE_UNKNOWN = 0,
> +	/* Sub-Element */
> +	WIRELESS_MODE_B = BIT(0),
> +	WIRELESS_MODE_G = BIT(1),
> +	WIRELESS_MODE_A = BIT(2),
> +	WIRELESS_MODE_N_24G = BIT(3),
> +	WIRELESS_MODE_N_5G = BIT(4),
> +	WIRELESS_AUTO = BIT(5),
> +	WIRELESS_MODE_AC = BIT(6),
> +	WIRELESS_MODE_MAX = 0x7F,
> +};
> +
> +/* from rtlwifi/wifi.h */
> +enum ratr_table_mode_new {
> +	RATEID_IDX_BGN_40M_2SS = 0,
> +	RATEID_IDX_BGN_40M_1SS = 1,
> +	RATEID_IDX_BGN_20M_2SS_BN = 2,
> +	RATEID_IDX_BGN_20M_1SS_BN = 3,
> +	RATEID_IDX_GN_N2SS = 4,
> +	RATEID_IDX_GN_N1SS = 5,
> +	RATEID_IDX_BG = 6,
> +	RATEID_IDX_G = 7,
> +	RATEID_IDX_B = 8,
> +	RATEID_IDX_VHT_2SS = 9,
> +	RATEID_IDX_VHT_1SS = 10,
> +	RATEID_IDX_MIX1 = 11,
> +	RATEID_IDX_MIX2 = 12,
> +	RATEID_IDX_VHT_3SS = 13,
> +	RATEID_IDX_BGN_3SS = 14,
> +};
> +
> +#define RTL8XXXU_RATR_STA_INIT 0
> +#define RTL8XXXU_RATR_STA_HIGH 1
> +#define RTL8XXXU_RATR_STA_MID  2
> +#define RTL8XXXU_RATR_STA_LOW  3
> +

>  extern struct rtl8xxxu_fileops rtl8192cu_fops;
>  extern struct rtl8xxxu_fileops rtl8192eu_fops;
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> index 26b674aca125..2071ab9fd001 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> @@ -1645,6 +1645,148 @@ static void rtl8723bu_init_statistics(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write32(priv, REG_OFDM0_FA_RSTC, val32);
>  }
>  
> +static u8 rtl8723b_signal_to_rssi(int signal)
> +{
> +	if (signal < -95)
> +		signal = -95;
> +	return (u8)(signal + 95);
> +}

Could you make this more generic so it can be used by the other sub-drivers?

> +static void rtl8723b_refresh_rate_mask(struct rtl8xxxu_priv *priv,
> +				       int signal, struct ieee80211_sta *sta)
> +{
> +	struct ieee80211_hw *hw = priv->hw;
> +	u16 wireless_mode;
> +	u8 rssi_level, ratr_idx;
> +	u8 txbw_40mhz;
> +	u8 rssi, rssi_thresh_high, rssi_thresh_low;
> +
> +	rssi_level = priv->rssi_level;
> +	rssi = rtl8723b_signal_to_rssi(signal);
> +	txbw_40mhz = (hw->conf.chandef.width == NL80211_CHAN_WIDTH_40) ? 1 : 0;
> +
> +	switch (rssi_level) {
> +	case RTL8XXXU_RATR_STA_HIGH:
> +		rssi_thresh_high = 50;
> +		rssi_thresh_low = 20;
> +		break;
> +	case RTL8XXXU_RATR_STA_MID:
> +		rssi_thresh_high = 55;
> +		rssi_thresh_low = 20;
> +		break;
> +	case RTL8XXXU_RATR_STA_LOW:
> +		rssi_thresh_high = 60;
> +		rssi_thresh_low = 25;
> +		break;
> +	default:
> +		rssi_thresh_high = 50;
> +		rssi_thresh_low = 20;
> +		break;
> +	}

Can we make this use defined values with some explanation rather than
hard coded values?

> +	if (rssi > rssi_thresh_high)
> +		rssi_level = RTL8XXXU_RATR_STA_HIGH;
> +	else if (rssi > rssi_thresh_low)
> +		rssi_level = RTL8XXXU_RATR_STA_MID;
> +	else
> +		rssi_level = RTL8XXXU_RATR_STA_LOW;
> +
> +	if (rssi_level != priv->rssi_level) {
> +		int sgi = 0;
> +		u32 rate_bitmap = 0;
> +
> +		rcu_read_lock();
> +		rate_bitmap = (sta->supp_rates[0] & 0xfff) |
> +				(sta->ht_cap.mcs.rx_mask[0] << 12) |
> +				(sta->ht_cap.mcs.rx_mask[1] << 20);
> +		if (sta->ht_cap.cap &
> +		    (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))
> +			sgi = 1;
> +		rcu_read_unlock();
> +
> +		wireless_mode = rtl8xxxu_wireless_mode(hw, sta);
> +		switch (wireless_mode) {
> +		case WIRELESS_MODE_B:
> +			ratr_idx = RATEID_IDX_B;
> +			if (rate_bitmap & 0x0000000c)
> +				rate_bitmap &= 0x0000000d;
> +			else
> +				rate_bitmap &= 0x0000000f;
> +			break;
> +		case WIRELESS_MODE_A:
> +		case WIRELESS_MODE_G:
> +			ratr_idx = RATEID_IDX_G;
> +			if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> +				rate_bitmap &= 0x00000f00;
> +			else
> +				rate_bitmap &= 0x00000ff0;
> +			break;
> +		case (WIRELESS_MODE_B | WIRELESS_MODE_G):
> +			ratr_idx = RATEID_IDX_BG;
> +			if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> +				rate_bitmap &= 0x00000f00;
> +			else if (rssi_level == RTL8XXXU_RATR_STA_MID)
> +				rate_bitmap &= 0x00000ff0;
> +			else
> +				rate_bitmap &= 0x00000ff5;
> +			break;

It would be nice as well to get all these masks into generic names.

> +		case WIRELESS_MODE_N_24G:
> +		case WIRELESS_MODE_N_5G:
> +		case (WIRELESS_MODE_G | WIRELESS_MODE_N_24G):
> +		case (WIRELESS_MODE_A | WIRELESS_MODE_N_5G):
> +			if (priv->tx_paths == 2 && priv->rx_paths == 2)
> +				ratr_idx = RATEID_IDX_GN_N2SS;
> +			else
> +				ratr_idx = RATEID_IDX_GN_N1SS;
> +		case (WIRELESS_MODE_B | WIRELESS_MODE_G | WIRELESS_MODE_N_24G):
> +		case (WIRELESS_MODE_B | WIRELESS_MODE_N_24G):
> +			if (txbw_40mhz) {
> +				if (priv->tx_paths == 2 && priv->rx_paths == 2)
> +					ratr_idx = RATEID_IDX_BGN_40M_2SS;
> +				else
> +					ratr_idx = RATEID_IDX_BGN_40M_1SS;
> +			} else {
> +				if (priv->tx_paths == 2 && priv->rx_paths == 2)
> +					ratr_idx = RATEID_IDX_BGN_20M_2SS_BN;
> +				else
> +					ratr_idx = RATEID_IDX_BGN_20M_1SS_BN;
> +			}
> +
> +			if (priv->tx_paths == 2 && priv->rx_paths == 2) {
> +				if (rssi_level == RTL8XXXU_RATR_STA_HIGH) {
> +					rate_bitmap &= 0x0f8f0000;
> +				} else if (rssi_level == RTL8XXXU_RATR_STA_MID) {
> +					rate_bitmap &= 0x0f8ff000;
> +				} else {
> +					if (txbw_40mhz)
> +						rate_bitmap &= 0x0f8ff015;
> +					else
> +						rate_bitmap &= 0x0f8ff005;
> +				}
> +			} else {
> +				if (rssi_level == RTL8XXXU_RATR_STA_HIGH) {
> +					rate_bitmap &= 0x000f0000;
> +				} else if (rssi_level == RTL8XXXU_RATR_STA_MID) {
> +					rate_bitmap &= 0x000ff000;
> +				} else {
> +					if (txbw_40mhz)
> +						rate_bitmap &= 0x000ff015;
> +					else
> +						rate_bitmap &= 0x000ff005;
> +				}
> +			}
> +			break;
> +		default:
> +			ratr_idx = RATEID_IDX_BGN_40M_2SS;
> +			rate_bitmap &= 0x0fffffff;
> +			break;
> +		}
> +
> +		priv->rssi_level = rssi_level;
> +		priv->fops->update_rate_mask(priv, rate_bitmap, ratr_idx, sgi);
> +	}
> +}
> +

In general I think all of this should be fairly generic and the other
subdrivers should be able to benefit from it?


>  struct rtl8xxxu_fileops rtl8723bu_fops = {
>  	.parse_efuse = rtl8723bu_parse_efuse,
>  	.load_firmware = rtl8723bu_load_firmware,
> @@ -1665,6 +1807,7 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
>  	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
>  	.set_tx_power = rtl8723b_set_tx_power,
>  	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
> +	.refresh_rate_mask = rtl8723b_refresh_rate_mask,
>  	.report_connect = rtl8xxxu_gen2_report_connect,
>  	.fill_txdesc = rtl8xxxu_fill_txdesc_v2,
>  	.writeN_block_size = 1024,
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 039e5ca9d2e4..be322402ca01 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -4311,7 +4311,8 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
>  	rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
>  }
>  
> -void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
> +void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
> +			       u32 ramask, u8 rateid, int sgi)
>  {
>  	struct h2c_cmd h2c;
>  
> @@ -4331,7 +4332,7 @@ void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
>  }
>  
>  void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
> -				    u32 ramask, int sgi)
> +				    u32 ramask, u8 rateid, int sgi)
>  {
>  	struct h2c_cmd h2c;
>  	u8 bw = 0;
> @@ -4345,7 +4346,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
>  	h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
>  
>  	h2c.ramask.arg = 0x80;
> -	h2c.b_macid_cfg.data1 = 0;
> +	h2c.b_macid_cfg.data1 = rateid;
>  	if (sgi)
>  		h2c.b_macid_cfg.data1 |= BIT(7);
>  
> @@ -4485,6 +4486,40 @@ static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
>  	rtl8xxxu_write8(priv, REG_INIRTS_RATE_SEL, rate_idx);
>  }
>  
> +u16
> +rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
> +{
> +	u16 network_type = WIRELESS_MODE_UNKNOWN;
> +	u32 rate_mask;
> +
> +	rate_mask = (sta->supp_rates[0] & 0xfff) |
> +		    (sta->ht_cap.mcs.rx_mask[0] << 12) |
> +		    (sta->ht_cap.mcs.rx_mask[0] << 20);
> +
> +	if (hw->conf.chandef.chan->band == NL80211_BAND_5GHZ) {
> +		if (sta->vht_cap.vht_supported)
> +			network_type = WIRELESS_MODE_AC;
> +		else if (sta->ht_cap.ht_supported)
> +			network_type = WIRELESS_MODE_N_5G;
> +
> +		network_type |= WIRELESS_MODE_A;
> +	} else {
> +		if (sta->vht_cap.vht_supported)
> +			network_type = WIRELESS_MODE_AC;
> +		else if (sta->ht_cap.ht_supported)
> +			network_type = WIRELESS_MODE_N_24G;
> +
> +		if (sta->supp_rates[0] <= 0xf)
> +			network_type |= WIRELESS_MODE_B;
> +		else if (sta->supp_rates[0] & 0xf)
> +			network_type |= (WIRELESS_MODE_B | WIRELESS_MODE_G);
> +		else
> +			network_type |= WIRELESS_MODE_G;
> +	}
> +
> +	return network_type;
> +}

I always hated the wireless_mode nonsense in the realtek driver, but
maybe we cannot avoid it :(

Cheers,
Jes
