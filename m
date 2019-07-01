Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFD35B3D8
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 07:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbfGAFJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 01:09:59 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44708 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfGAFJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 01:09:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id p144so9991142qke.11
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 22:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B/1t7nDDIqU8Ml1jX1eWlyh3XahOoUTBQNAmWpnWJFg=;
        b=oOL9EJCcC43HN4nTaHH5IknDoQPIwkruszRIEJnLUQ4+76nOYd5swtHmMaEOhTO4/9
         fsuDzYjUu7wvTE7rVLClHjSHboceMiGefC1er0DMo0nZo3cVUDD6iAFu7f6TptC7RlTI
         b8oyTNV2oYL7zjB4KiYr/bIZZ7nbBX9+hiOYcwavZvqXJn/z4LLVLt3WfWb9Sg8ySqQY
         GSi0JCU0S8WgaYqpFD5M7xyE1COpVnxW5Utar2uc2MAsxMYYaTYcgBnFRcmN3Q1L/gWO
         cYBc/9MWff0KgEioMjMdBDCfIEowXB1LQO7f/GYaCmW96gglXVf5PQeHnk1GJKUDacgi
         j9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B/1t7nDDIqU8Ml1jX1eWlyh3XahOoUTBQNAmWpnWJFg=;
        b=QcuDADav1M7hGVtKfkSld8zc8at6E8Po7s7B7QCAKsLy2PXr1OO9QzI/D+ig08iOTO
         dY9wbYjDxtk9Qc/8KfpSL82OEXjEF6axFETj7M7VL9rhEqZli/JYkEB1AH2hK4lJnkWY
         TGbIE8BNtuupBtF0vdIpT2af7434ql+u7OSQTUiqAjx8hZdhEzkgAyQnRZfhpMscNsyQ
         DPuEmLpawkzm2V6Pnuay8I+xrYx9YzL9PJdbcEYs3fT4lMTGWJKzUPLEGCzY6vTcVR/6
         cOQ1ouhHdZfNiS/37osN3O/s8+pA+FeSoSE4a8CdV+fIEnIj3+BxrEpr8pRcOMhaYBU2
         ppRQ==
X-Gm-Message-State: APjAAAX3pcS1Sdp31yKP/2wZjZZEhI/opjI5NaMs1ug5gytj7+/xrBN3
        HfeDcvlyrV3v41KDBJg1yDXuD1v0ZaD5ZcVUVCwnRg==
X-Google-Smtp-Source: APXvYqwpedK8Jx9Fk/yuAWLRZ/PQf5qtELXkkdr2762E4twSB6F6rwJT7IUTxb4K9SZvdsd5fH7tX/hKoCm7d0nyxnk=
X-Received: by 2002:ae9:c30e:: with SMTP id n14mr17458032qkg.220.1561957797714;
 Sun, 30 Jun 2019 22:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190617065600.40405-1-chiu@endlessm.com>
In-Reply-To: <20190617065600.40405-1-chiu@endlessm.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Mon, 1 Jul 2019 13:09:46 +0800
Message-ID: <CAB4CAwe+OTsf3_hf0=GdT3iN99dttHts0hzn03LVJsVuPuLxJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 2:56 PM Chris Chiu <chiu@endlessm.com> wrote:
>
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
> ---
>
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
>
>
>  .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  55 ++++-
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 226 +++++++++++++++++-
>  2 files changed, 274 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 8828baf26e7b..1498a8c94d5f 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1195,6 +1195,48 @@ struct rtl8723bu_c2h {
>
>  struct rtl8xxxu_fileops;
>
> +/*mlme related.*/
> +enum wireless_mode {
> +       WIRELESS_MODE_UNKNOWN = 0,
> +       /* Sub-Element */
> +       WIRELESS_MODE_B = BIT(0),
> +       WIRELESS_MODE_G = BIT(1),
> +       WIRELESS_MODE_A = BIT(2),
> +       WIRELESS_MODE_N_24G = BIT(3),
> +       WIRELESS_MODE_N_5G = BIT(4),
> +       WIRELESS_AUTO = BIT(5),
> +       WIRELESS_MODE_AC = BIT(6),
> +       WIRELESS_MODE_MAX = 0x7F,
> +};
> +
> +/* from rtlwifi/wifi.h */
> +enum ratr_table_mode_new {
> +       RATEID_IDX_BGN_40M_2SS = 0,
> +       RATEID_IDX_BGN_40M_1SS = 1,
> +       RATEID_IDX_BGN_20M_2SS_BN = 2,
> +       RATEID_IDX_BGN_20M_1SS_BN = 3,
> +       RATEID_IDX_GN_N2SS = 4,
> +       RATEID_IDX_GN_N1SS = 5,
> +       RATEID_IDX_BG = 6,
> +       RATEID_IDX_G = 7,
> +       RATEID_IDX_B = 8,
> +       RATEID_IDX_VHT_2SS = 9,
> +       RATEID_IDX_VHT_1SS = 10,
> +       RATEID_IDX_MIX1 = 11,
> +       RATEID_IDX_MIX2 = 12,
> +       RATEID_IDX_VHT_3SS = 13,
> +       RATEID_IDX_BGN_3SS = 14,
> +};
> +
> +#define RTL8XXXU_RATR_STA_INIT 0
> +#define RTL8XXXU_RATR_STA_HIGH 1
> +#define RTL8XXXU_RATR_STA_MID  2
> +#define RTL8XXXU_RATR_STA_LOW  3
> +
> +#define RTL8XXXU_NOISE_FLOOR_MIN       -95
> +#define RTL8XXXU_SNR_THRESH_HIGH       50
> +#define RTL8XXXU_SNR_THRESH_LOW        20
> +
>  struct rtl8xxxu_priv {
>         struct ieee80211_hw *hw;
>         struct usb_device *udev;
> @@ -1299,6 +1341,13 @@ struct rtl8xxxu_priv {
>         u8 pi_enabled:1;
>         u8 no_pape:1;
>         u8 int_buf[USB_INTR_CONTENT_LENGTH];
> +       u8 rssi_level;
> +       /*
> +        * Only one virtual interface permitted because only STA mode
> +        * is supported and no iface_combinations are providec.
> +        */
> +       struct ieee80211_vif *vif;
> +       struct delayed_work ra_watchdog;
>  };
>
>  struct rtl8xxxu_rx_urb {
> @@ -1334,7 +1383,7 @@ struct rtl8xxxu_fileops {
>         void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
>                               bool ht40);
>         void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
> -                                 u32 ramask, int sgi);
> +                                 u32 ramask, u8 rateid, int sgi);
>         void (*report_connect) (struct rtl8xxxu_priv *priv,
>                                 u8 macid, bool connect);
>         void (*fill_txdesc) (struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
> @@ -1419,9 +1468,9 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw);
>  void rtl8xxxu_gen1_usb_quirks(struct rtl8xxxu_priv *priv);
>  void rtl8xxxu_gen2_usb_quirks(struct rtl8xxxu_priv *priv);
>  void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
> -                              u32 ramask, int sgi);
> +                              u32 ramask, u8 rateid, int sgi);
>  void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
> -                                   u32 ramask, int sgi);
> +                                   u32 ramask, u8 rateid, int sgi);
>  void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
>                                   u8 macid, bool connect);
>  void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 039e5ca9d2e4..474dea2291a9 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -4311,7 +4311,8 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
>         rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
>  }
>
> -void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
> +void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
> +                              u32 ramask, u8 rateid, int sgi)
>  {
>         struct h2c_cmd h2c;
>
> @@ -4331,7 +4332,7 @@ void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
>  }
>
>  void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
> -                                   u32 ramask, int sgi)
> +                                   u32 ramask, u8 rateid, int sgi)
>  {
>         struct h2c_cmd h2c;
>         u8 bw = 0;
> @@ -4345,7 +4346,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
>         h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
>
>         h2c.ramask.arg = 0x80;
> -       h2c.b_macid_cfg.data1 = 0;
> +       h2c.b_macid_cfg.data1 = rateid;
>         if (sgi)
>                 h2c.b_macid_cfg.data1 |= BIT(7);
>
> @@ -4485,6 +4486,40 @@ static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
>         rtl8xxxu_write8(priv, REG_INIRTS_RATE_SEL, rate_idx);
>  }
>
> +static u16
> +rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
> +{
> +       u16 network_type = WIRELESS_MODE_UNKNOWN;
> +       u32 rate_mask;
> +
> +       rate_mask = (sta->supp_rates[0] & 0xfff) |
> +                   (sta->ht_cap.mcs.rx_mask[0] << 12) |
> +                   (sta->ht_cap.mcs.rx_mask[0] << 20);
> +
> +       if (hw->conf.chandef.chan->band == NL80211_BAND_5GHZ) {
> +               if (sta->vht_cap.vht_supported)
> +                       network_type = WIRELESS_MODE_AC;
> +               else if (sta->ht_cap.ht_supported)
> +                       network_type = WIRELESS_MODE_N_5G;
> +
> +               network_type |= WIRELESS_MODE_A;
> +       } else {
> +               if (sta->vht_cap.vht_supported)
> +                       network_type = WIRELESS_MODE_AC;
> +               else if (sta->ht_cap.ht_supported)
> +                       network_type = WIRELESS_MODE_N_24G;
> +
> +               if (sta->supp_rates[0] <= 0xf)
> +                       network_type |= WIRELESS_MODE_B;
> +               else if (sta->supp_rates[0] & 0xf)
> +                       network_type |= (WIRELESS_MODE_B | WIRELESS_MODE_G);
> +               else
> +                       network_type |= WIRELESS_MODE_G;
> +       }
> +
> +       return network_type;
> +}
> +
>  static void
>  rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>                           struct ieee80211_bss_conf *bss_conf, u32 changed)
> @@ -4527,7 +4562,10 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>                                 sgi = 1;
>                         rcu_read_unlock();
>
> -                       priv->fops->update_rate_mask(priv, ramask, sgi);
> +                       priv->vif = vif;
> +                       priv->rssi_level = RTL8XXXU_RATR_STA_INIT;
> +
> +                       priv->fops->update_rate_mask(priv, ramask, 0, sgi);
>
>                         rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
>
> @@ -5471,6 +5509,10 @@ static int rtl8xxxu_add_interface(struct ieee80211_hw *hw,
>
>         switch (vif->type) {
>         case NL80211_IFTYPE_STATION:
> +               if (!priv->vif)
> +                       priv->vif = vif;
> +               else
> +                       return -EOPNOTSUPP;
>                 rtl8xxxu_stop_tx_beacon(priv);
>
>                 val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
> @@ -5494,6 +5536,9 @@ static void rtl8xxxu_remove_interface(struct ieee80211_hw *hw,
>         struct rtl8xxxu_priv *priv = hw->priv;
>
>         dev_dbg(&priv->udev->dev, "%s\n", __func__);
> +
> +       if (priv->vif)
> +               priv->vif = NULL;
>  }
>
>  static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
> @@ -5779,6 +5824,174 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>         return 0;
>  }
>
> +static u8 rtl8xxxu_signal_to_snr(int signal)
> +{
> +       if (signal < RTL8XXXU_NOISE_FLOOR_MIN)
> +               signal = RTL8XXXU_NOISE_FLOOR_MIN;
> +       return (u8)(signal - RTL8XXXU_NOISE_FLOOR_MIN);
> +}
> +
> +static void rtl8xxxu_refresh_rate_mask(struct rtl8xxxu_priv *priv,
> +                                      int signal, struct ieee80211_sta *sta)
> +{
> +       struct ieee80211_hw *hw = priv->hw;
> +       u16 wireless_mode;
> +       u8 rssi_level, ratr_idx;
> +       u8 txbw_40mhz;
> +       u8 snr, snr_thresh_high, snr_thresh_low;
> +       u8 go_up_gap = 5;
> +
> +       rssi_level = priv->rssi_level;
> +       snr = rtl8xxxu_signal_to_snr(signal);
> +       snr_thresh_high = RTL8XXXU_SNR_THRESH_HIGH;
> +       snr_thresh_low = RTL8XXXU_SNR_THRESH_LOW;
> +       txbw_40mhz = (hw->conf.chandef.width == NL80211_CHAN_WIDTH_40) ? 1 : 0;
> +
> +       switch (rssi_level) {
> +       case RTL8XXXU_RATR_STA_MID:
> +               snr_thresh_high += go_up_gap;
> +               break;
> +       case RTL8XXXU_RATR_STA_LOW:
> +               snr_thresh_high += go_up_gap;
> +               snr_thresh_low += go_up_gap;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       if (snr > snr_thresh_high)
> +               rssi_level = RTL8XXXU_RATR_STA_HIGH;
> +       else if (snr > snr_thresh_low)
> +               rssi_level = RTL8XXXU_RATR_STA_MID;
> +       else
> +               rssi_level = RTL8XXXU_RATR_STA_LOW;
> +
> +       if (rssi_level != priv->rssi_level) {
> +               int sgi = 0;
> +               u32 rate_bitmap = 0;
> +
> +               rcu_read_lock();
> +               rate_bitmap = (sta->supp_rates[0] & 0xfff) |
> +                               (sta->ht_cap.mcs.rx_mask[0] << 12) |
> +                               (sta->ht_cap.mcs.rx_mask[1] << 20);
> +               if (sta->ht_cap.cap &
> +                   (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))
> +                       sgi = 1;
> +               rcu_read_unlock();
> +
> +               wireless_mode = rtl8xxxu_wireless_mode(hw, sta);
> +               switch (wireless_mode) {
> +               case WIRELESS_MODE_B:
> +                       ratr_idx = RATEID_IDX_B;
> +                       if (rate_bitmap & 0x0000000c)
> +                               rate_bitmap &= 0x0000000d;
> +                       else
> +                               rate_bitmap &= 0x0000000f;
> +                       break;
> +               case WIRELESS_MODE_A:
> +               case WIRELESS_MODE_G:
> +                       ratr_idx = RATEID_IDX_G;
> +                       if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> +                               rate_bitmap &= 0x00000f00;
> +                       else
> +                               rate_bitmap &= 0x00000ff0;
> +                       break;
> +               case (WIRELESS_MODE_B | WIRELESS_MODE_G):
> +                       ratr_idx = RATEID_IDX_BG;
> +                       if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> +                               rate_bitmap &= 0x00000f00;
> +                       else if (rssi_level == RTL8XXXU_RATR_STA_MID)
> +                               rate_bitmap &= 0x00000ff0;
> +                       else
> +                               rate_bitmap &= 0x00000ff5;
> +                       break;
> +               case WIRELESS_MODE_N_24G:
> +               case WIRELESS_MODE_N_5G:
> +               case (WIRELESS_MODE_G | WIRELESS_MODE_N_24G):
> +               case (WIRELESS_MODE_A | WIRELESS_MODE_N_5G):
> +                       if (priv->tx_paths == 2 && priv->rx_paths == 2)
> +                               ratr_idx = RATEID_IDX_GN_N2SS;
> +                       else
> +                               ratr_idx = RATEID_IDX_GN_N1SS;
> +               case (WIRELESS_MODE_B | WIRELESS_MODE_G | WIRELESS_MODE_N_24G):
> +               case (WIRELESS_MODE_B | WIRELESS_MODE_N_24G):
> +                       if (txbw_40mhz) {
> +                               if (priv->tx_paths == 2 && priv->rx_paths == 2)
> +                                       ratr_idx = RATEID_IDX_BGN_40M_2SS;
> +                               else
> +                                       ratr_idx = RATEID_IDX_BGN_40M_1SS;
> +                       } else {
> +                               if (priv->tx_paths == 2 && priv->rx_paths == 2)
> +                                       ratr_idx = RATEID_IDX_BGN_20M_2SS_BN;
> +                               else
> +                                       ratr_idx = RATEID_IDX_BGN_20M_1SS_BN;
> +                       }
> +
> +                       if (priv->tx_paths == 2 && priv->rx_paths == 2) {
> +                               if (rssi_level == RTL8XXXU_RATR_STA_HIGH) {
> +                                       rate_bitmap &= 0x0f8f0000;
> +                               } else if (rssi_level == RTL8XXXU_RATR_STA_MID) {
> +                                       rate_bitmap &= 0x0f8ff000;
> +                               } else {
> +                                       if (txbw_40mhz)
> +                                               rate_bitmap &= 0x0f8ff015;
> +                                       else
> +                                               rate_bitmap &= 0x0f8ff005;
> +                               }
> +                       } else {
> +                               if (rssi_level == RTL8XXXU_RATR_STA_HIGH) {
> +                                       rate_bitmap &= 0x000f0000;
> +                               } else if (rssi_level == RTL8XXXU_RATR_STA_MID) {
> +                                       rate_bitmap &= 0x000ff000;
> +                               } else {
> +                                       if (txbw_40mhz)
> +                                               rate_bitmap &= 0x000ff015;
> +                                       else
> +                                               rate_bitmap &= 0x000ff005;
> +                               }
> +                       }
> +                       break;
> +               default:
> +                       ratr_idx = RATEID_IDX_BGN_40M_2SS;
> +                       rate_bitmap &= 0x0fffffff;
> +                       break;
> +               }
> +
> +               priv->rssi_level = rssi_level;
> +               priv->fops->update_rate_mask(priv, rate_bitmap, ratr_idx, sgi);
> +       }
> +}
> +
> +static void rtl8xxxu_watchdog_callback(struct work_struct *work)
> +{
> +       struct ieee80211_vif *vif;
> +       struct rtl8xxxu_priv *priv;
> +
> +       priv = container_of(work, struct rtl8xxxu_priv, ra_watchdog.work);
> +       vif = priv->vif;
> +
> +       if (vif && vif->type == NL80211_IFTYPE_STATION) {
> +               int signal;
> +               struct ieee80211_sta *sta;
> +
> +               rcu_read_lock();
> +               sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
> +               if (!sta) {
> +                       struct device *dev = &priv->udev->dev;
> +
> +                       dev_info(dev, "%s: no sta found\n", __func__);
> +                       rcu_read_unlock();
> +                       return;
> +               }
> +               rcu_read_unlock();
> +
> +               signal = ieee80211_ave_rssi(vif);
> +               rtl8xxxu_refresh_rate_mask(priv, signal, sta);
> +       }
> +
> +       schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
> +}
> +
>  static int rtl8xxxu_start(struct ieee80211_hw *hw)
>  {
>         struct rtl8xxxu_priv *priv = hw->priv;
> @@ -5835,6 +6048,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
>
>                 ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
>         }
> +
> +       schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
>  exit:
>         /*
>          * Accept all data and mgmt frames
> @@ -5886,6 +6101,8 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw)
>         if (priv->usb_interrupts)
>                 rtl8xxxu_write32(priv, REG_USB_HIMR, 0);
>
> +       cancel_delayed_work_sync(&priv->ra_watchdog);
> +
>         rtl8xxxu_free_rx_resources(priv);
>         rtl8xxxu_free_tx_resources(priv);
>  }
> @@ -6058,6 +6275,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>         INIT_LIST_HEAD(&priv->rx_urb_pending_list);
>         spin_lock_init(&priv->rx_urb_lock);
>         INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
> +       INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
>
>         usb_set_intfdata(interface, hw);
>
> --
> 2.21.0
>

Gentle ping. Cheers.

Chris
