Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47BEC18792
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 11:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfEIJRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 05:17:54 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36111 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfEIJRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 05:17:53 -0400
Received: by mail-qk1-f195.google.com with SMTP id c14so1020246qke.3
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 02:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5pv0PHtaywRf0p6FU0Md7Np/podTGV8Ipcy5/zKmG8=;
        b=w3fNPOYmx+UHvoJE+Uf5q/2/xDkD6vaMGbLzSLSkmBHHdHv/8CO2s2LaG4NzAkWSIJ
         gzD8Y8lJteFDuzb/9olpgknOWp20NlQGhq2sAYyzF39jV+DAETWgrORFBFURGT86/V7P
         +6HOxvhwgwYdQjE+PfVGEXtzrEZJeb5NcUASEGtfRR11jc/tWrkfjZKYS1HpSn0dYKGi
         tzuaXnd2hI8yMvGuDDeDaDvzEYV0KYikQCu5vZoc1CFeQcq7tiSliA5szM2WFUjaCDHu
         /fseyL/mN2Zg2g2uzeYzgjcMmaCLFdPxr8gVwblbOcfUJjLDNvG1P2xoR5lYCSHs8UXO
         84dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5pv0PHtaywRf0p6FU0Md7Np/podTGV8Ipcy5/zKmG8=;
        b=PjbDGvkBSpyeX4MTmvEq+WHUvN8hzRKMRx0aKwXfYMHhpB7JhfBHmZgOHNjLZ78I+i
         rL4T4seB7Vd+D/f10MKucK2zInqTJ8pyA5FZTy4WKorUf9RqBCNP9gPwgxgiLhrFrev3
         DpJQ5k8CwbMWvVxwGV1XSOnXtFL0vmfkcW2wq7fm1/w4YrV/GhGHf/trbq0RLmkCoXlN
         Y+RhFqW/hGiV2LJ2M0H8rsOyCzXEnrrkE+FdUecTmcZTw5KrumD1eEU72V7zeXNmerpr
         eiToETnflNzeek/vx3Zds/ZwAitPJcz5PGbmjS9daNAXjMr2jX72iI2JCcF8FlMiRgTM
         nHPg==
X-Gm-Message-State: APjAAAWwuhl+86G4zjed0SUDta6wswJkfapElPP0KgU+jEOjcIjC8gGp
        71uPfciRp4ACxaxGcCLOFfnM+WUnVyGy8WRlB2gu9a1SYlB1Zw==
X-Google-Smtp-Source: APXvYqzXSaJ+63yxUcmxHyPPNY/LITdV3CqoNmrfoXw4tcMUfSziYHEoRQUhXWpqY/ikjgaPiE5JtvVGEJtTd25EVt0=
X-Received: by 2002:a37:8d06:: with SMTP id p6mr2306723qkd.315.1557393472284;
 Thu, 09 May 2019 02:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190503072146.49999-1-chiu@endlessm.com> <20190503072146.49999-3-chiu@endlessm.com>
 <CAD8Lp47_-6d2wCAs5QbuR6Mw2w91TyJ9W3kFiJHH4F_6dXqnHg@mail.gmail.com>
In-Reply-To: <CAD8Lp47_-6d2wCAs5QbuR6Mw2w91TyJ9W3kFiJHH4F_6dXqnHg@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Thu, 9 May 2019 17:17:40 +0800
Message-ID: <CAB4CAweQXz=wQGA5t7BwWYdwbRrHCji+BWc0G52SUcZFGc8Pnw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] rtl8xxxu: Add watchdog to update rate mask by
 signal strength
To:     Daniel Drake <drake@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 9, 2019 at 4:11 PM Daniel Drake <drake@endlessm.com> wrote:
>
> Hi Chris,
>
> Great work on finding this!
>
> On Fri, May 3, 2019 at 3:22 PM Chris Chiu <chiu@endlessm.com> wrote:
> > Introduce watchdog to monitor signal then update the rate mask
> > accordingly. The rate mask update logic comes from the rtlwifi
> > refresh_rate_adaptive_mask() from different chips.
>
> You should expand your commit message here to summarise the key points
> in the cover letter. Specifically that matching this aspect of the
> vendor driver results in a significant TX performance increase which
> was previously stuck at 1mbps.
>
> > ---
> >  .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |   8 +
> >  .../realtek/rtl8xxxu/rtl8xxxu_8723b.c         | 151 ++++++++++++++++++
> >  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |  38 +++++
> >  3 files changed, 197 insertions(+)
> >
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> > index 771f58aa7cae..f97271951053 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> > @@ -1239,6 +1239,11 @@ struct rtl8xxxu_rate_adaptive {
> >         u8 rssi_level;          /* INIT, HIGH, MIDDLE, LOW */
> >  } __packed;
> >
> > +struct rtl8xxxu_watchdog {
> > +       struct ieee80211_vif *vif;
> > +       struct delayed_work ra_wq;
> > +};
>
> Having to store the vif address under the device-specific private
> structure may be a layering violation, but I'm not fully grasping how
> all this fits together. Can anyone from linux-wireless help?
>
> The existing rtl8xxxu_add_interface() code appears to allow multiple
> STA interfaces to be added. Does that imply that the hardware should
> support connecting to multiple APs on different channels? I'm pretty
> sure the hardware doesn't support that; if so we could do something
> similar to ar5523.c where it only allows a single vif, and can easily
> store that pointer in the device-specific structure.
>
> Or if there's a valid reason to support multiple vifs, then we need to
> figure out how to implement this watchdog. As shown below, the
> watchdog needs to know the supported rate info of the AP you are
> connected to, and the RSSI, and that comes from a specific vif. If
> multiple vifs are present, how would we know which one to choose for
> this rate adjustment?
>

I need the vif because there's seems no easy way to get RSSI. Please
suggest if there's any better idea for this. I believe multiple vifs is for AP
mode (with more than 1 virtual AP/SSIDs) and the Station+AP coexist
mode. But the rtl8xxxu driver basically supports only Station mode. So
the vif helps get the RSSI. Or I will need to record the RSSI in
rtl8xxxu_rx_parse_phystats() and store in rtl8xxxu_priv. That's a little
nasty. Maybe someone can point out how to retrieve the RSSI from
specific register or which part of code in rtlwifi I can use to get the
undecorated signal strength.

> >  struct rtl8xxxu_priv {
> >         struct ieee80211_hw *hw;
> >         struct usb_device *udev;
> > @@ -1344,6 +1349,7 @@ struct rtl8xxxu_priv {
> >         u8 no_pape:1;
> >         u8 int_buf[USB_INTR_CONTENT_LENGTH];
> >         struct rtl8xxxu_rate_adaptive ra_info;
> > +       struct rtl8xxxu_watchdog watchdog;
> >  };
> >
> >  struct rtl8xxxu_rx_urb {
> > @@ -1380,6 +1386,8 @@ struct rtl8xxxu_fileops {
> >                               bool ht40);
> >         void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
> >                                   u32 ramask, int sgi);
> > +       void (*refresh_rate_mask) (struct rtl8xxxu_priv *priv, int signal,
> > +                                  struct ieee80211_sta *sta);
> >         void (*report_connect) (struct rtl8xxxu_priv *priv,
> >                                 u8 macid, bool connect);
> >         void (*fill_txdesc) (struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > index 26b674aca125..92c35afecae0 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > @@ -1645,6 +1645,156 @@ static void rtl8723bu_init_statistics(struct rtl8xxxu_priv *priv)
> >         rtl8xxxu_write32(priv, REG_OFDM0_FA_RSTC, val32);
> >  }
> >
> > +static u8 rtl8723b_signal_to_rssi(int signal)
> > +{
> > +       if (signal < -95)
> > +               signal = -95;
> > +       return (u8)(signal + 95);
> > +}
> > +
> > +static void rtl8723b_refresh_rate_mask(struct rtl8xxxu_priv *priv,
> > +                                      int signal, struct ieee80211_sta *sta)
> > +{
> > +       struct rtl8xxxu_rate_adaptive *ra;
> > +       struct ieee80211_hw *hw = priv->hw;
> > +       u16 wireless_mode;
> > +       u8 rssi_level, ratr_index;
> > +       u8 txbw_40mhz;
> > +       u8 rssi, rssi_thresh_high, rssi_thresh_low;
> > +
> > +       ra = &priv->ra_info;
> > +       wireless_mode = ra->wireless_mode;
> > +       rssi_level = ra->rssi_level;
> > +       rssi = rtl8723b_signal_to_rssi(signal);
> > +       ratr_index = ra->ratr_index;
> > +       txbw_40mhz = (hw->conf.chandef.width == NL80211_CHAN_WIDTH_40)? 1 : 0;
> > +
> > +       switch (rssi_level) {
> > +       case RTL8XXXU_RATR_STA_HIGH:
> > +               rssi_thresh_high = 50;
> > +               rssi_thresh_low = 20;
> > +               break;
> > +       case RTL8XXXU_RATR_STA_MID:
> > +               rssi_thresh_high = 55;
> > +               rssi_thresh_low = 20;
> > +               break;
> > +       case RTL8XXXU_RATR_STA_LOW:
> > +               rssi_thresh_high = 60;
> > +               rssi_thresh_low = 25;
> > +               break;
> > +       default:
> > +               rssi_thresh_high = 50;
> > +               rssi_thresh_low = 20;
> > +               break;
> > +       }
> > +
> > +       if (rssi > rssi_thresh_high)
> > +               rssi_level = RTL8XXXU_RATR_STA_HIGH;
> > +       else if (rssi > rssi_thresh_low)
> > +               rssi_level = RTL8XXXU_RATR_STA_MID;
> > +       else
> > +               rssi_level = RTL8XXXU_RATR_STA_LOW;
> > +
> > +       if (rssi_level != ra->rssi_level) {
> > +               int sgi = 0;
> > +               u32 rate_bitmap = 0;
> > +
> > +               rcu_read_lock();
> > +               rate_bitmap = (sta->supp_rates[0] & 0xfff) |
> > +                             sta->ht_cap.mcs.rx_mask[0] << 12 |
> > +                              sta->ht_cap.mcs.rx_mask[1] << 20;
> > +               if (sta->ht_cap.cap &
> > +                   (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))
> > +                       sgi = 1;
> > +               rcu_read_unlock();
> > +
> > +               switch (wireless_mode) {
> > +               case WIRELESS_MODE_B:
> > +                       ratr_index = RATEID_IDX_B;
> > +                       if (rate_bitmap & 0x0000000c)
> > +                               rate_bitmap &= 0x0000000d;
> > +                       else
> > +                               rate_bitmap &= 0x0000000f;
> > +                       break;
> > +               case WIRELESS_MODE_A:
> > +               case WIRELESS_MODE_G:
> > +                       ratr_index = RATEID_IDX_G;
> > +                       if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> > +                               rate_bitmap &= 0x00000f00;
> > +                       else
> > +                               rate_bitmap &= 0x00000ff0;
> > +                       break;
> > +               case (WIRELESS_MODE_B|WIRELESS_MODE_G):
> > +                       ratr_index = RATEID_IDX_BG;
> > +                       if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> > +                               rate_bitmap &= 0x00000f00;
> > +                       else if (rssi_level == RTL8XXXU_RATR_STA_MID)
> > +                               rate_bitmap &= 0x00000ff0;
> > +                       else
> > +                               rate_bitmap &= 0x00000ff5;
> > +                       break;
> > +               case WIRELESS_MODE_N_24G:
> > +               case WIRELESS_MODE_N_5G:
> > +               case (WIRELESS_MODE_G|WIRELESS_MODE_N_24G):
> > +               case (WIRELESS_MODE_A|WIRELESS_MODE_N_5G):
> > +                       if (priv->tx_paths == 2 && priv->rx_paths == 2)
> > +                               ratr_index = RATEID_IDX_GN_N2SS;
> > +                       else
> > +                               ratr_index = RATEID_IDX_GN_N1SS;
> > +               case (WIRELESS_MODE_B|WIRELESS_MODE_G|WIRELESS_MODE_N_24G):
> > +               case (WIRELESS_MODE_B|WIRELESS_MODE_N_24G):
> > +                       if (txbw_40mhz) {
> > +                               if (priv->tx_paths == 2 && priv->rx_paths == 2)
> > +                                       ratr_index = RATEID_IDX_BGN_40M_2SS;
> > +                               else
> > +                                       ratr_index = RATEID_IDX_BGN_40M_1SS;
> > +                       }
> > +                       else {
> > +                               if (priv->tx_paths == 2 && priv->rx_paths == 2)
> > +                                       ratr_index = RATEID_IDX_BGN_20M_2SS_BN;
> > +                               else
> > +                                       ratr_index = RATEID_IDX_BGN_20M_1SS_BN;
> > +                       }
> > +
> > +                       if (priv->tx_paths == 2 && priv->rx_paths == 2) {
> > +                               if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> > +                                       rate_bitmap &= 0x0f8f0000;
> > +                               else if (rssi_level == RTL8XXXU_RATR_STA_MID)
> > +                                       rate_bitmap &= 0x0f8ff000;
> > +                               else {
> > +                                       if (txbw_40mhz)
> > +                                               rate_bitmap &= 0x0f8ff015;
> > +                                       else
> > +                                               rate_bitmap &= 0x0f8ff005;
> > +                               }
> > +                       }
> > +                       else {
> > +                               if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
> > +                                       rate_bitmap &= 0x000f0000;
> > +                               else if (rssi_level == RTL8XXXU_RATR_STA_MID)
> > +                                       rate_bitmap &= 0x000ff000;
> > +                               else {
> > +                                       if (txbw_40mhz)
> > +                                               rate_bitmap &= 0x000ff015;
> > +                                       else
> > +                                               rate_bitmap &= 0x000ff005;
> > +                               }
> > +                       }
> > +                       break;
> > +               default:
> > +                       ratr_index = RATEID_IDX_BGN_40M_2SS;
> > +                       rate_bitmap &= 0x0fffffff;
> > +                       break;
> > +               }
> > +
> > +               ra->ratr_index = ratr_index;
> > +               ra->rssi_level = rssi_level;
> > +               priv->fops->update_rate_mask(priv, rate_bitmap, sgi);
> > +       }
> > +
> > +       return;
> > +}
> > +
> >  struct rtl8xxxu_fileops rtl8723bu_fops = {
> >         .parse_efuse = rtl8723bu_parse_efuse,
> >         .load_firmware = rtl8723bu_load_firmware,
> > @@ -1665,6 +1815,7 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
> >         .usb_quirks = rtl8xxxu_gen2_usb_quirks,
> >         .set_tx_power = rtl8723b_set_tx_power,
> >         .update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
> > +       .refresh_rate_mask = rtl8723b_refresh_rate_mask,
> >         .report_connect = rtl8xxxu_gen2_report_connect,
> >         .fill_txdesc = rtl8xxxu_fill_txdesc_v2,
> >         .writeN_block_size = 1024,
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > index 360e9bd837e5..8db479986e97 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > @@ -4565,6 +4565,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> >                                 sgi = 1;
> >                         rcu_read_unlock();
> >
> > +                       priv->watchdog.vif = vif;
> >                         ra = &priv->ra_info;
> >                         ra->wireless_mode = rtl8xxxu_wireless_mode(hw, sta);
> >                         ra->ratr_index = RATEID_IDX_BGN_40M_2SS;
> > @@ -5822,6 +5823,38 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> >         return 0;
> >  }
> >
> > +static void rtl8xxxu_watchdog_callback(struct work_struct *work)
> > +{
> > +       struct ieee80211_vif *vif;
> > +       struct rtl8xxxu_watchdog *wdog;
> > +       struct rtl8xxxu_priv *priv;
> > +
> > +       wdog = container_of(work, struct rtl8xxxu_watchdog, ra_wq.work);
> > +       priv = container_of(wdog, struct rtl8xxxu_priv, watchdog);
> > +       vif = wdog->vif;
> > +
> > +       if (vif) {
> > +               int signal;
> > +               struct ieee80211_sta *sta;
> > +
> > +               rcu_read_lock();
>
> Can you explain the lock/unlock here?
>

Actually it may not be mandatory because the sta_info_get_bss()
will do this inside ieee80211_find_sta().

> > +               sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
> > +               if (!sta) {
> > +                       struct device *dev = &priv->udev->dev;
> > +                       dev_info(dev, "%s: no sta found\n", __func__);
>
> Does this result in a kernel log message every 2 seconds when the wifi
> interface is not associated to an AP?

Yes. It prints every 2 seconds if not associated.

>
> > +                       rcu_read_unlock();
> > +                       return;
> > +               }
> > +               rcu_read_unlock();
> > +
> > +               signal = ieee80211_ave_rssi(vif);
> > +               if (priv->fops->refresh_rate_mask)
> > +                       priv->fops->refresh_rate_mask(priv, signal, sta);
> > +       }
> > +
> > +       schedule_delayed_work(&priv->watchdog.ra_wq, 2 * HZ);
> > +}
> > +
> >  static int rtl8xxxu_start(struct ieee80211_hw *hw)
> >  {
> >         struct rtl8xxxu_priv *priv = hw->priv;
> > @@ -5878,6 +5911,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
> >
> >                 ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
> >         }
> > +
> > +       schedule_delayed_work(&priv->watchdog.ra_wq, 2* HZ);
> >  exit:
> >         /*
> >          * Accept all data and mgmt frames
> > @@ -6101,6 +6136,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
> >         INIT_LIST_HEAD(&priv->rx_urb_pending_list);
> >         spin_lock_init(&priv->rx_urb_lock);
> >         INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
> > +       INIT_DELAYED_WORK(&priv->watchdog.ra_wq, rtl8xxxu_watchdog_callback);
> >
> >         usb_set_intfdata(interface, hw);
> >
> > @@ -6226,6 +6262,8 @@ static void rtl8xxxu_disconnect(struct usb_interface *interface)
> >         mutex_destroy(&priv->usb_buf_mutex);
> >         mutex_destroy(&priv->h2c_mutex);
> >
> > +       cancel_delayed_work_sync(&priv->watchdog.ra_wq);
> > +
> >         if (priv->udev->state != USB_STATE_NOTATTACHED) {
> >                 dev_info(&priv->udev->dev,
> >                          "Device still attached, trying to reset\n");
> > --
> > 2.21.0
> >
