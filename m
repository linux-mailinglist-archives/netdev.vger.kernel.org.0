Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DE33BAE99
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhGDTKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhGDTKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Jul 2021 15:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88470613E2;
        Sun,  4 Jul 2021 19:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625425699;
        bh=VLiKGR1v+9NnuwU1LjnHuZ6Su0GWomCpRT6OA2j6uFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qiTAXYmDvRFSZ4zinz8MPMNQnVXr4AtbiXkUHkBDWjOEGJ+slrPQMfdzp6h7mX+Ao
         KADweRq9ekxgcqmCe2PhV4qQV1cKm/qgHZXfChr9CcUjmBenf4z+teDmOIf4zX8j9S
         919rdrq7H8t0db/BiLYpq3pf4GVvdnOh6m4eaoZc=
Date:   Sun, 4 Jul 2021 21:08:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Wood <john.wood@gmx.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mt76/mt7915: Fix unsigned compared against zero
Message-ID: <YOIHIC3qLsVdRjdh@kroah.com>
References: <20210704145920.24899-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210704145920.24899-1-john.wood@gmx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 04, 2021 at 04:59:20PM +0200, John Wood wrote:
> The mt7915_dpd_freq_idx() function can return a negative value but this
> value is assigned to an unsigned variable named idx. Then, the code
> tests if this variable is less than zero. This can never happen with an
> unsigned type.
> 
> So, change the idx type to a signed one.
> 
> Addresses-Coverity-ID: 1484753 ("Unsigned compared against 0")
> Fixes: 495184ac91bb8 ("mt76: mt7915: add support for applying pre-calibration data")
> Signed-off-by: John Wood <john.wood@gmx.com>
> ---
> Changelog v1 -> v2
> - Add Cc to stable@vger.kernel.org
> 
>  drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
> index b3f14ff67c5a..764f25a828fa 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
> @@ -3440,8 +3440,9 @@ int mt7915_mcu_apply_tx_dpd(struct mt7915_phy *phy)
>  {
>  	struct mt7915_dev *dev = phy->dev;
>  	struct cfg80211_chan_def *chandef = &phy->mt76->chandef;
> -	u16 total = 2, idx, center_freq = chandef->center_freq1;
> +	u16 total = 2, center_freq = chandef->center_freq1;
>  	u8 *cal = dev->cal, *eep = dev->mt76.eeprom.data;
> +	int idx;
> 
>  	if (!(eep[MT_EE_DO_PRE_CAL] & MT_EE_WIFI_CAL_DPD))
>  		return 0;
> --
> 2.25.1
> 
<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
