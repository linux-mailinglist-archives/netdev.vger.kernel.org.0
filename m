Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A733552C
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfFECRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:17:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42466 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFECRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 22:17:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so16288596qtk.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 19:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+O1ye8GKOAS8fUY0XWEdF+lucJumzzw2tOu91kXAUwA=;
        b=sRL7dH4cCYRjiuH4SarwKVyFspdeNt8oqdECCFBZ4u+9KJEgVbsUpBNdmcAePQne2C
         cpNOkPvW7Xf+bmEya3LRGDL+HJPNark3bHLp+/WvK/KwY8GjkBeKC2ZhxlcKcwA0/PCj
         ucFZI0ucGlg0iOQbeebThn0X6t26i0+an7jujv3NzoT0chcNeSH1zJGeTSekey+JPI40
         6Dm1fbRfNXrqHUllZl8lhL18eajGjaF5p99REjJpyTBJ9KDYD+uaflKMp6gSnGDfXIRJ
         5nKE7lBmmssy/1rrmvO/Z4+dhzJpfen09Sfnh2s5iENiXSe7ZJmFngz5MiKJwYScDEuU
         75jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+O1ye8GKOAS8fUY0XWEdF+lucJumzzw2tOu91kXAUwA=;
        b=UtOGs/zt9YlT3VbBttuPtwye5gaRQttVOOKsZvYIEdGFaoocQbwuHS7XA7hAAdb64B
         EXqf3aUKNx0RighR7vfz9kwQms9w/5DZLF8Krlgz3nfyegiW6j16kDHyXbHHWuZIEuDa
         Up9U24k1L08Wk2e03h6VhipCD34QgztnwVj1U3ALv+KQEGmAXWFpOZIXyaLycs+HGy8E
         mQab19v0RqYzJpVUx2H4/Nr9vBxgce0W+vecE4iOCbW2OGMUzGIi6Vfq5gJV3R89YXpG
         fyiwU+hpCpFs51eLtcHJm7HfsnjqtzyjsIA7QKqpadYehouTAJmPSEnMMVMoMP60QuV9
         2lTQ==
X-Gm-Message-State: APjAAAX4BGk6yRpo9cpGrzGGA84HEh/RZfL3LEZRBd2mWNTRyEizoi5K
        k4ln0OK/0Vil3oSuQC4uPc0fboyEiv/X7JsorM7XVohD8MWNtg==
X-Google-Smtp-Source: APXvYqwnUSyeya6yZLg+jAm0YHBuLbfiJ6mtK9HP+NfBqlhkJVD0HkUo+FrVbhobn6vRpy8K85Ty56PweatGFAgLNBQ=
X-Received: by 2002:aed:378a:: with SMTP id j10mr31989958qtb.6.1559701037677;
 Tue, 04 Jun 2019 19:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190531091229.93033-1-chiu@endlessm.com> <f1c54f97-16a5-2618-569b-9101f9657fcb@gmail.com>
In-Reply-To: <f1c54f97-16a5-2618-569b-9101f9657fcb@gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Wed, 5 Jun 2019 10:17:06 +0800
Message-ID: <CAB4CAwf3Mi2iuR7nAj1U4EoyU5ZnvY9xoLrv7QT2X-tc_1ex3g@mail.gmail.com>
Subject: Re: [RFC PATCH v4] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 3:21 AM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>
> On 5/31/19 5:12 AM, Chris Chiu wrote:
> > We have 3 laptops which connect the wifi by the same RTL8723BU.
> > The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
> > They have the same problem with the in-kernel rtl8xxxu driver, the
> > iperf (as a client to an ethernet-connected server) gets ~1Mbps.
> > Nevertheless, the signal strength is reported as around -40dBm,
> > which is quite good. From the wireshark capture, the tx rate for each
> > data and qos data packet is only 1Mbps. Compare to the Realtek driver
> > at https://github.com/lwfinger/rtl8723bu, the same iperf test gets
> > ~12Mbps or better. The signal strength is reported similarly around
> > -40dBm. That's why we want to improve.
> >
> > After reading the source code of the rtl8xxxu driver and Realtek's, the
> > major difference is that Realtek's driver has a watchdog which will keep
> > monitoring the signal quality and updating the rate mask just like the
> > rtl8xxxu_gen2_update_rate_mask() does if signal quality changes.
> > And this kind of watchdog also exists in rtlwifi driver of some specific
> > chips, ex rtl8192ee, rtl8188ee, rtl8723ae, rtl8821ae...etc. They have
> > the same member function named dm_watchdog and will invoke the
> > corresponding dm_refresh_rate_adaptive_mask to adjust the tx rate
> > mask.
> >
> > With this commit, the tx rate of each data and qos data packet will
> > be 39Mbps (MCS4) with the 0xF00000 as the tx rate mask. The 20th bit
> > to 23th bit means MCS4 to MCS7. It means that the firmware still picks
> > the lowest rate from the rate mask and explains why the tx rate of
> > data and qos data is always lowest 1Mbps because the default rate mask
> > passed is always 0xFFFFFFF ranges from the basic CCK rate, OFDM rate,
> > and MCS rate. However, with Realtek's driver, the tx rate observed from
> > wireshark under the same condition is almost 65Mbps or 72Mbps.
> >
> > I believe the firmware of RTL8723BU may need fix. And I think we
> > can still bring in the dm_watchdog as rtlwifi to improve from the
> > driver side. Please leave precious comments for my commits and
> > suggest what I can do better. Or suggest if there's any better idea
> > to fix this. Thanks.
> >
> > Signed-off-by: Chris Chiu <chiu@endlessm.com>
>
> I am really pleased to see you're investigating some of these issues,
> since I've been pretty swamped and not had time to work on this driver
> for a long time.
>
> The firmware should allow for two rate modes, either firmware handled or
> controlled by the driver. Ideally we would want the driver to handle it,
> but I never was able to make that work reliable.
>
> This fix should at least improve the situation, and it may explain some
> of the performance issues with the 8192eu as well?
>
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> > index 8828baf26e7b..216f603827a8 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> > @@ -1195,6 +1195,44 @@ struct rtl8723bu_c2h {
> >
> >  struct rtl8xxxu_fileops;
> >
> > +/*mlme related.*/
> > +enum wireless_mode {
> > +     WIRELESS_MODE_UNKNOWN = 0,
> > +     /* Sub-Element */
> > +     WIRELESS_MODE_B = BIT(0),
> > +     WIRELESS_MODE_G = BIT(1),
> > +     WIRELESS_MODE_A = BIT(2),
> > +     WIRELESS_MODE_N_24G = BIT(3),
> > +     WIRELESS_MODE_N_5G = BIT(4),
> > +     WIRELESS_AUTO = BIT(5),
> > +     WIRELESS_MODE_AC = BIT(6),
> > +     WIRELESS_MODE_MAX = 0x7F,
> > +};
> > +
> > +/* from rtlwifi/wifi.h */
> > +enum ratr_table_mode_new {
> > +     RATEID_IDX_BGN_40M_2SS = 0,
> > +     RATEID_IDX_BGN_40M_1SS = 1,
> > +     RATEID_IDX_BGN_20M_2SS_BN = 2,
> > +     RATEID_IDX_BGN_20M_1SS_BN = 3,
> > +     RATEID_IDX_GN_N2SS = 4,
> > +     RATEID_IDX_GN_N1SS = 5,
> > +     RATEID_IDX_BG = 6,
> > +     RATEID_IDX_G = 7,
> > +     RATEID_IDX_B = 8,
> > +     RATEID_IDX_VHT_2SS = 9,
> > +     RATEID_IDX_VHT_1SS = 10,
> > +     RATEID_IDX_MIX1 = 11,
> > +     RATEID_IDX_MIX2 = 12,
> > +     RATEID_IDX_VHT_3SS = 13,
> > +     RATEID_IDX_BGN_3SS = 14,
> > +};
> > +
> > +#define RTL8XXXU_RATR_STA_INIT 0
> > +#define RTL8XXXU_RATR_STA_HIGH 1
> > +#define RTL8XXXU_RATR_STA_MID  2
> > +#define RTL8XXXU_RATR_STA_LOW  3
> > +
>
> >  extern struct rtl8xxxu_fileops rtl8192cu_fops;
> >  extern struct rtl8xxxu_fileops rtl8192eu_fops;
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > index 26b674aca125..2071ab9fd001 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > @@ -1645,6 +1645,148 @@ static void rtl8723bu_init_statistics(struct rtl8xxxu_priv *priv)
> >       rtl8xxxu_write32(priv, REG_OFDM0_FA_RSTC, val32);
> >  }
> >
> > +static u8 rtl8723b_signal_to_rssi(int signal)
> > +{
> > +     if (signal < -95)
> > +             signal = -95;
> > +     return (u8)(signal + 95);
> > +}
>
> Could you make this more generic so it can be used by the other sub-drivers?
>
Sure. I'll do that.

> > +static void rtl8723b_refresh_rate_mask(struct rtl8xxxu_priv *priv,
> > +                                    int signal, struct ieee80211_sta *sta)
> > +{
> > +     struct ieee80211_hw *hw = priv->hw;
> > +     u16 wireless_mode;
> > +     u8 rssi_level, ratr_idx;
> > +     u8 txbw_40mhz;
> > +     u8 rssi, rssi_thresh_high, rssi_thresh_low;
> > +
> > +     rssi_level = priv->rssi_level;
> > +     rssi = rtl8723b_signal_to_rssi(signal);
> > +     txbw_40mhz = (hw->conf.chandef.width == NL80211_CHAN_WIDTH_40) ? 1 : 0;
> > +
> > +     switch (rssi_level) {
> > +     case RTL8XXXU_RATR_STA_HIGH:
> > +             rssi_thresh_high = 50;
> > +             rssi_thresh_low = 20;
> > +             break;
> > +     case RTL8XXXU_RATR_STA_MID:
> > +             rssi_thresh_high = 55;
> > +             rssi_thresh_low = 20;
> > +             break;
> > +     case RTL8XXXU_RATR_STA_LOW:
> > +             rssi_thresh_high = 60;
> > +             rssi_thresh_low = 25;
> > +             break;
> > +     default:
> > +             rssi_thresh_high = 50;
> > +             rssi_thresh_low = 20;
> > +             break;
> > +     }
>
> Can we make this use defined values with some explanation rather than
> hard coded values?
>

I also thought about this. So I refer to the same refresh_rateadaotive_mask
in rtlwifi/rtl8192se/dm.c, rtlwifi/rtl8723ae/dm.c, and rtl8188ee...etc. They
don't give a better explanation. And I also don't know if these values can be
generally applied to other subdrivers or specifically for 8723b series, for
example, the rtl8192se use different values for the threshold. It maybe due
to different noise floor for different chip?  I'm not sure. I took these values
from vendor driver and rtl8188ee. I can simply use defined values to replace
but I have to admit it's hard to find a good explanation.

> > +     if (rssi > rssi_thresh_high)
> > +             rssi_level = RTL8XXXU_RATR_STA_HIGH;
> > +     else if (rssi > rssi_thresh_low)
> > +             rssi_level = RTL8XXXU_RATR_STA_MID;
> > +     else
> > +             rssi_level = RTL8XXXU_RATR_STA_LOW;
> > +
> > +     if (rssi_level != priv->rssi_level) {
> > +             int sgi = 0;
> > +             u32 rate_bitmap = 0;
> > +
> > +             rcu_read_lock();
> > +             rate_bitmap = (sta->supp_rates[0] & 0xfff) |
> > +                             (sta->ht_cap.mcs.rx_mask[0] << 12) |
> > +                             (sta->ht_cap.mcs.rx_mask[1] << 20);
> > +             if (sta->ht_cap.cap &
> > +                 (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))
> > +                     sgi = 1;
> > +             rcu_read_unlock();
> > +
> > +             wireless_mode = rtl8xxxu_wireless_mode(hw, sta);
> > +             switch (wireless_mode) {
> > +             case WIRELESS_MODE_B:
> > +                     ratr_idx = RATEID_IDX_B;
> > +                     if (rate_bitmap & 0x0000000c)
> > +                             rate_bitmap &= 0x0000000d;
> > +                     else
> > +                             rate_bitmap &= 0x0000000f;
> > +                     break;
> > +             case WIRELESS_MODE_A:
> > +             case WIRELESS_MODE_G:
> > +                     ratr_idx = RATEID_IDX_G;
> > +                     if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> > +                             rate_bitmap &= 0x00000f00;
> > +                     else
> > +                             rate_bitmap &= 0x00000ff0;
> > +                     break;
> > +             case (WIRELESS_MODE_B | WIRELESS_MODE_G):
> > +                     ratr_idx = RATEID_IDX_BG;
> > +                     if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> > +                             rate_bitmap &= 0x00000f00;
> > +                     else if (rssi_level == RTL8XXXU_RATR_STA_MID)
> > +                             rate_bitmap &= 0x00000ff0;
> > +                     else
> > +                             rate_bitmap &= 0x00000ff5;
> > +                     break;
>
> It would be nice as well to get all these masks into generic names.
>

I also take these mask values from the update_hal_rate_mask of the
vendor driver and other realtek drivers under rtlwifi. I thought about to
define the lower 12 bits like RTL8XXXU_BG_RATE_MASK, 13~20 bits
as RTL8XXXU_MCS0_7_RATE_MASK. But it's still hard to express
all the combinations here. So I just leave it as it is. I can try to add
explanations for the rate mapping of each bit. It would be a lot easier.

> > +             case WIRELESS_MODE_N_24G:
> > +             case WIRELESS_MODE_N_5G:
> > +             case (WIRELESS_MODE_G | WIRELESS_MODE_N_24G):
> > +             case (WIRELESS_MODE_A | WIRELESS_MODE_N_5G):
> > +                     if (priv->tx_paths == 2 && priv->rx_paths == 2)
> > +                             ratr_idx = RATEID_IDX_GN_N2SS;
> > +                     else
> > +                             ratr_idx = RATEID_IDX_GN_N1SS;
> > +             case (WIRELESS_MODE_B | WIRELESS_MODE_G | WIRELESS_MODE_N_24G):
> > +             case (WIRELESS_MODE_B | WIRELESS_MODE_N_24G):
> > +                     if (txbw_40mhz) {
> > +                             if (priv->tx_paths == 2 && priv->rx_paths == 2)
> > +                                     ratr_idx = RATEID_IDX_BGN_40M_2SS;
> > +                             else
> > +                                     ratr_idx = RATEID_IDX_BGN_40M_1SS;
> > +                     } else {
> > +                             if (priv->tx_paths == 2 && priv->rx_paths == 2)
> > +                                     ratr_idx = RATEID_IDX_BGN_20M_2SS_BN;
> > +                             else
> > +                                     ratr_idx = RATEID_IDX_BGN_20M_1SS_BN;
> > +                     }
> > +
> > +                     if (priv->tx_paths == 2 && priv->rx_paths == 2) {
> > +                             if (rssi_level == RTL8XXXU_RATR_STA_HIGH) {
> > +                                     rate_bitmap &= 0x0f8f0000;
> > +                             } else if (rssi_level == RTL8XXXU_RATR_STA_MID) {
> > +                                     rate_bitmap &= 0x0f8ff000;
> > +                             } else {
> > +                                     if (txbw_40mhz)
> > +                                             rate_bitmap &= 0x0f8ff015;
> > +                                     else
> > +                                             rate_bitmap &= 0x0f8ff005;
> > +                             }
> > +                     } else {
> > +                             if (rssi_level == RTL8XXXU_RATR_STA_HIGH) {
> > +                                     rate_bitmap &= 0x000f0000;
> > +                             } else if (rssi_level == RTL8XXXU_RATR_STA_MID) {
> > +                                     rate_bitmap &= 0x000ff000;
> > +                             } else {
> > +                                     if (txbw_40mhz)
> > +                                             rate_bitmap &= 0x000ff015;
> > +                                     else
> > +                                             rate_bitmap &= 0x000ff005;
> > +                             }
> > +                     }
> > +                     break;
> > +             default:
> > +                     ratr_idx = RATEID_IDX_BGN_40M_2SS;
> > +                     rate_bitmap &= 0x0fffffff;
> > +                     break;
> > +             }
> > +
> > +             priv->rssi_level = rssi_level;
> > +             priv->fops->update_rate_mask(priv, rate_bitmap, ratr_idx, sgi);
> > +     }
> > +}
> > +
>
> In general I think all of this should be fairly generic and the other
> subdrivers should be able to benefit from it?
>
>
I agree. Mabe separates the rssi level judgement function to be chip specific,
and move the whole refresh_rate_mask thing generic?

> >  struct rtl8xxxu_fileops rtl8723bu_fops = {
> >       .parse_efuse = rtl8723bu_parse_efuse,
> >       .load_firmware = rtl8723bu_load_firmware,
> > @@ -1665,6 +1807,7 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
> >       .usb_quirks = rtl8xxxu_gen2_usb_quirks,
> >       .set_tx_power = rtl8723b_set_tx_power,
> >       .update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
> > +     .refresh_rate_mask = rtl8723b_refresh_rate_mask,
> >       .report_connect = rtl8xxxu_gen2_report_connect,
> >       .fill_txdesc = rtl8xxxu_fill_txdesc_v2,
> >       .writeN_block_size = 1024,
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > index 039e5ca9d2e4..be322402ca01 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > @@ -4311,7 +4311,8 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
> >       rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
> >  }
> >
> > -void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
> > +void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
> > +                            u32 ramask, u8 rateid, int sgi)
> >  {
> >       struct h2c_cmd h2c;
> >
> > @@ -4331,7 +4332,7 @@ void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
> >  }
> >
> >  void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
> > -                                 u32 ramask, int sgi)
> > +                                 u32 ramask, u8 rateid, int sgi)
> >  {
> >       struct h2c_cmd h2c;
> >       u8 bw = 0;
> > @@ -4345,7 +4346,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
> >       h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
> >
> >       h2c.ramask.arg = 0x80;
> > -     h2c.b_macid_cfg.data1 = 0;
> > +     h2c.b_macid_cfg.data1 = rateid;
> >       if (sgi)
> >               h2c.b_macid_cfg.data1 |= BIT(7);
> >
> > @@ -4485,6 +4486,40 @@ static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
> >       rtl8xxxu_write8(priv, REG_INIRTS_RATE_SEL, rate_idx);
> >  }
> >
> > +u16
> > +rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
> > +{
> > +     u16 network_type = WIRELESS_MODE_UNKNOWN;
> > +     u32 rate_mask;
> > +
> > +     rate_mask = (sta->supp_rates[0] & 0xfff) |
> > +                 (sta->ht_cap.mcs.rx_mask[0] << 12) |
> > +                 (sta->ht_cap.mcs.rx_mask[0] << 20);
> > +
> > +     if (hw->conf.chandef.chan->band == NL80211_BAND_5GHZ) {
> > +             if (sta->vht_cap.vht_supported)
> > +                     network_type = WIRELESS_MODE_AC;
> > +             else if (sta->ht_cap.ht_supported)
> > +                     network_type = WIRELESS_MODE_N_5G;
> > +
> > +             network_type |= WIRELESS_MODE_A;
> > +     } else {
> > +             if (sta->vht_cap.vht_supported)
> > +                     network_type = WIRELESS_MODE_AC;
> > +             else if (sta->ht_cap.ht_supported)
> > +                     network_type = WIRELESS_MODE_N_24G;
> > +
> > +             if (sta->supp_rates[0] <= 0xf)
> > +                     network_type |= WIRELESS_MODE_B;
> > +             else if (sta->supp_rates[0] & 0xf)
> > +                     network_type |= (WIRELESS_MODE_B | WIRELESS_MODE_G);
> > +             else
> > +                     network_type |= WIRELESS_MODE_G;
> > +     }
> > +
> > +     return network_type;
> > +}
>
> I always hated the wireless_mode nonsense in the realtek driver, but
> maybe we cannot avoid it :(
>
> Cheers,
> Jes
