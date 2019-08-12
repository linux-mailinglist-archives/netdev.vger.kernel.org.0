Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8895D89FD3
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbfHLNi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:38:57 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34944 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfHLNi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:38:56 -0400
Received: by mail-qt1-f194.google.com with SMTP id u34so3479612qte.2;
        Mon, 12 Aug 2019 06:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YE4CmjNV/jFd0p9aNsKH9lv4QlFQGm6mAlqmwvBGbEU=;
        b=qlf0qkhSUn+d/Pqf0gJENZVnWXibqjXTbpXH52CUYqhVFBhltjUwobowyV7RPOZs6x
         F93a9pXujxi4LgMoj+KmrPc7S96XjrTaqU4ZHhcL0Vv0w2bJ1lFoSo6kUEEHFK7B1GZ5
         YXs4nNOlv3nrWyTJ7pCs4m5ho3nrGExBc6zIldvAmmMHQY+hiy8B7o2V7Qflbm/ZMnpd
         8pXrJVL6GdFcozxqOcN9cOg8ms7DSiJC0aDgXpTs6u8VfiODGwdddecY5NLpn8sIpnmq
         9uAX3wIGb/dvOg+eSKbtgSdmPZJmqmO4ovN/C9AvtGFT6GZsdKCHIMFUn2BHPuSiYbM7
         s9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YE4CmjNV/jFd0p9aNsKH9lv4QlFQGm6mAlqmwvBGbEU=;
        b=iTnHDyzFs8hJe67AcAcxK7PTlBpGBPvFxqjsjXmKNo87M4fTMXuqe1m8udC0YsJyff
         C1d/CiM2WYoW+ZZBTGXcvhl9EGUWWnetUKgxq6oxqRwZsss19jlg4DPqhmzlOvPLPAMw
         2pYVE8/YpEuYOBWr/AyQI5a4cTzWzR8bnly/xWA3ntdfNzU3KJXkoxmV5a1j20gXo4GY
         oB+NEBFBGx9QIVQl1vAAlqMlMaxwfxQHjX4zQznLWBiwMvDF6AjBTOC4svPt5tSCAPo4
         BQJkQ6suQQMMkHGorASg7PLOvqsTEYKizXKUacAxqlUylHogHj3iigZmaQzR5VzYGEmO
         320Q==
X-Gm-Message-State: APjAAAUnWejolIXSVwPfl2X0SWdLWqiTUVDvI18slVCJL1joeb2liF2k
        K5SwQi8/G7o5sWcl+QvqjSQ=
X-Google-Smtp-Source: APXvYqxdGmGWcuEAvjTFhwHHVlB8df/c5juuoj+Az5/Dw0CRuMS9H+hnGBQcKbYPbZHlVH/nX0HJPg==
X-Received: by 2002:ac8:5343:: with SMTP id d3mr7492877qto.50.1565617134892;
        Mon, 12 Aug 2019 06:38:54 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11c9::1085? ([2620:10d:c091:480::d0c4])
        by smtp.gmail.com with ESMTPSA id v192sm9407728qka.74.2019.08.12.06.38.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 06:38:53 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [RFC PATCH v7] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>
References: <20190805131452.13257-1-chiu@endlessm.com>
Message-ID: <d0047834-957d-0cf3-5792-31faa5315ad1@gmail.com>
Date:   Mon, 12 Aug 2019 09:38:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190805131452.13257-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/19 9:14 AM, Chris Chiu wrote:
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
> wireshark under the same condition is almost 65Mbps or 72Mbps, which
> indicating that rtl8xxxu could still be further improved.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> Reviewed-by: Daniel Drake <drake@endlessm.com>
> ---

Looks good to me! Nice work! I am actually very curious if this will
improve performance 8192eu as well.

Ideally I'd like to figure out how to make host controlled rates work,
but in all my experiments with that, I never really got it to work well.

Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Jes


> 
> Notes:
>   v2:
>    - Fix errors and warnings complained by checkpatch.pl
>    - Replace data structure rate_adaptive by 2 member variables
>    - Make rtl8xxxu_wireless_mode non-static
>    - Runs refresh_rate_mask() only in station mode
>   v3:
>    - Remove ugly rtl8xxxu_watchdog data structure
>    - Make sure only one vif exists
>   v4:
>    - Move cancel_delayed_work from rtl8xxxu_disconnect to rtl8xxxu_stop
>    - Clear priv->vif in rtl8xxxu_remove_interface
>    - Add rateid as the function argument of update_rate_mask
>    - Rephrase the comment for priv->vif more explicit.
>   v5:
>    - Make refresh_rate_mask() generic for all sub-drivers.
>    - Add definitions for SNR related to help determine rssi_level
>   v6: 
>    - Fix typo of the comment for priv->vif
>   v7:
>    - Fix reported bug of watchdog stop 
>    - refer to the RxPWDBAll in vendor driver for SNR calculation
> 
> 
>  .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  55 ++++-
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 229 +++++++++++++++++-
>  2 files changed, 277 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index ade057d868f7..582c2a346cec 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1187,6 +1187,48 @@ struct rtl8723bu_c2h {
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
> +#define RTL8XXXU_NOISE_FLOOR_MIN	-100
> +#define RTL8XXXU_SNR_THRESH_HIGH	50
> +#define RTL8XXXU_SNR_THRESH_LOW	20
> +
>  struct rtl8xxxu_priv {
>  	struct ieee80211_hw *hw;
>  	struct usb_device *udev;
> @@ -1291,6 +1333,13 @@ struct rtl8xxxu_priv {
>  	u8 pi_enabled:1;
>  	u8 no_pape:1;
>  	u8 int_buf[USB_INTR_CONTENT_LENGTH];
> +	u8 rssi_level;
> +	/*
> +	 * Only one virtual interface permitted because only STA mode
> +	 * is supported and no iface_combinations are provided.
> +	 */
> +	struct ieee80211_vif *vif;
> +	struct delayed_work ra_watchdog;
>  };
>  
>  struct rtl8xxxu_rx_urb {
> @@ -1326,7 +1375,7 @@ struct rtl8xxxu_fileops {
>  	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
>  			      bool ht40);
>  	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
> -				  u32 ramask, int sgi);
> +				  u32 ramask, u8 rateid, int sgi);
>  	void (*report_connect) (struct rtl8xxxu_priv *priv,
>  				u8 macid, bool connect);
>  	void (*fill_txdesc) (struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
> @@ -1411,9 +1460,9 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw);
>  void rtl8xxxu_gen1_usb_quirks(struct rtl8xxxu_priv *priv);
>  void rtl8xxxu_gen2_usb_quirks(struct rtl8xxxu_priv *priv);
>  void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
> -			       u32 ramask, int sgi);
> +			       u32 ramask, u8 rateid, int sgi);
>  void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
> -				    u32 ramask, int sgi);
> +				    u32 ramask, u8 rateid, int sgi);
>  void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
>  				  u8 macid, bool connect);
>  void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index c6c41fb962ff..a6f358b9e447 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -4304,7 +4304,8 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
>  	rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
>  }
>  
> -void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
> +void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
> +			       u32 ramask, u8 rateid, int sgi)
>  {
>  	struct h2c_cmd h2c;
>  
> @@ -4324,7 +4325,7 @@ void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
>  }
>  
>  void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
> -				    u32 ramask, int sgi)
> +				    u32 ramask, u8 rateid, int sgi)
>  {
>  	struct h2c_cmd h2c;
>  	u8 bw = 0;
> @@ -4338,7 +4339,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
>  	h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
>  
>  	h2c.ramask.arg = 0x80;
> -	h2c.b_macid_cfg.data1 = 0;
> +	h2c.b_macid_cfg.data1 = rateid;
>  	if (sgi)
>  		h2c.b_macid_cfg.data1 |= BIT(7);
>  
> @@ -4478,6 +4479,40 @@ static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
>  	rtl8xxxu_write8(priv, REG_INIRTS_RATE_SEL, rate_idx);
>  }
>  
> +static u16
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
> +
>  static void
>  rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  			  struct ieee80211_bss_conf *bss_conf, u32 changed)
> @@ -4520,7 +4555,10 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  				sgi = 1;
>  			rcu_read_unlock();
>  
> -			priv->fops->update_rate_mask(priv, ramask, sgi);
> +			priv->vif = vif;
> +			priv->rssi_level = RTL8XXXU_RATR_STA_INIT;
> +
> +			priv->fops->update_rate_mask(priv, ramask, 0, sgi);
>  
>  			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
>  
> @@ -5464,6 +5502,10 @@ static int rtl8xxxu_add_interface(struct ieee80211_hw *hw,
>  
>  	switch (vif->type) {
>  	case NL80211_IFTYPE_STATION:
> +		if (!priv->vif)
> +			priv->vif = vif;
> +		else
> +			return -EOPNOTSUPP;
>  		rtl8xxxu_stop_tx_beacon(priv);
>  
>  		val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
> @@ -5487,6 +5529,9 @@ static void rtl8xxxu_remove_interface(struct ieee80211_hw *hw,
>  	struct rtl8xxxu_priv *priv = hw->priv;
>  
>  	dev_dbg(&priv->udev->dev, "%s\n", __func__);
> +
> +	if (priv->vif)
> +		priv->vif = NULL;
>  }
>  
>  static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
> @@ -5772,6 +5817,177 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  	return 0;
>  }
>  
> +static u8 rtl8xxxu_signal_to_snr(int signal)
> +{
> +	if (signal < RTL8XXXU_NOISE_FLOOR_MIN)
> +		signal = RTL8XXXU_NOISE_FLOOR_MIN;
> +	else if (signal > 0)
> +		signal = 0;
> +	return (u8)(signal - RTL8XXXU_NOISE_FLOOR_MIN);
> +}
> +
> +static void rtl8xxxu_refresh_rate_mask(struct rtl8xxxu_priv *priv,
> +				       int signal, struct ieee80211_sta *sta)
> +{
> +	struct ieee80211_hw *hw = priv->hw;
> +	u16 wireless_mode;
> +	u8 rssi_level, ratr_idx;
> +	u8 txbw_40mhz;
> +	u8 snr, snr_thresh_high, snr_thresh_low;
> +	u8 go_up_gap = 5;
> +
> +	rssi_level = priv->rssi_level;
> +	snr = rtl8xxxu_signal_to_snr(signal);
> +	snr_thresh_high = RTL8XXXU_SNR_THRESH_HIGH;
> +	snr_thresh_low = RTL8XXXU_SNR_THRESH_LOW;
> +	txbw_40mhz = (hw->conf.chandef.width == NL80211_CHAN_WIDTH_40) ? 1 : 0;
> +
> +	switch (rssi_level) {
> +	case RTL8XXXU_RATR_STA_MID:
> +		snr_thresh_high += go_up_gap;
> +		break;
> +	case RTL8XXXU_RATR_STA_LOW:
> +		snr_thresh_high += go_up_gap;
> +		snr_thresh_low += go_up_gap;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (snr > snr_thresh_high)
> +		rssi_level = RTL8XXXU_RATR_STA_HIGH;
> +	else if (snr > snr_thresh_low)
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
> +static void rtl8xxxu_watchdog_callback(struct work_struct *work)
> +{
> +	struct ieee80211_vif *vif;
> +	struct rtl8xxxu_priv *priv;
> +
> +	priv = container_of(work, struct rtl8xxxu_priv, ra_watchdog.work);
> +	vif = priv->vif;
> +
> +	if (vif && vif->type == NL80211_IFTYPE_STATION) {
> +		int signal;
> +		struct ieee80211_sta *sta;
> +
> +		rcu_read_lock();
> +		sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
> +		if (!sta) {
> +			struct device *dev = &priv->udev->dev;
> +
> +			dev_info(dev, "%s: no sta found\n", __func__);
> +			rcu_read_unlock();
> +			goto out;
> +		}
> +		rcu_read_unlock();
> +
> +		signal = ieee80211_ave_rssi(vif);
> +		rtl8xxxu_refresh_rate_mask(priv, signal, sta);
> +	}
> +
> +out:
> +	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
> +}
> +
>  static int rtl8xxxu_start(struct ieee80211_hw *hw)
>  {
>  	struct rtl8xxxu_priv *priv = hw->priv;
> @@ -5828,6 +6044,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
>  
>  		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
>  	}
> +
> +	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
>  exit:
>  	/*
>  	 * Accept all data and mgmt frames
> @@ -5879,6 +6097,8 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw)
>  	if (priv->usb_interrupts)
>  		rtl8xxxu_write32(priv, REG_USB_HIMR, 0);
>  
> +	cancel_delayed_work_sync(&priv->ra_watchdog);
> +
>  	rtl8xxxu_free_rx_resources(priv);
>  	rtl8xxxu_free_tx_resources(priv);
>  }
> @@ -6051,6 +6271,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>  	INIT_LIST_HEAD(&priv->rx_urb_pending_list);
>  	spin_lock_init(&priv->rx_urb_lock);
>  	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
> +	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
>  
>  	usb_set_intfdata(interface, hw);
>  
> 

