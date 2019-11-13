Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18584FB8FA
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKMTiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:38:00 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40095 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKMTiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:38:00 -0500
Received: by mail-io1-f67.google.com with SMTP id p6so3897025iod.7;
        Wed, 13 Nov 2019 11:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qzwujp8rTgTl9+3sAbPrswzrZfz1gfQWPbEg9+4F518=;
        b=ozjH8/ZUfQ2cn2Shup6m3S6r23+l600p3IQKlEwI/WV41WNVyzYTOXRhSmhi9cSaU8
         8C2MfrQNRoEBF2iuxNSsfOWM3FrWzd/0BYYi/DNbr+VvXJ1loO6FOwer0u3b+nTzmYfN
         cliWX/v+W+IB14U2s4Jd+EktLLph+ba1wDP2kT9ZB0l4q/A6EnDfmrqkp24SO8IyCkUH
         Hay6Eq4pLvDpOWl2x8BoFpXSIRSrwuVREz7SUaJy3YsUMRQAZvHjSu+1uV8lbr9vOh6U
         /y+NHQpCoGFhBM4eYxEAM/4H51tXI6O2acTKYOG4YhFF728sXGpqWkMgW5uFQ4tWv2nM
         jkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qzwujp8rTgTl9+3sAbPrswzrZfz1gfQWPbEg9+4F518=;
        b=HDpXz1H4MbZ1fIK+6x/RyX0gb5dGUCiCSg1xpA3TgnZbZFLGcmh1LI84JvdXqABAY4
         /pYcKC9xcSoQz2tQ1yM03fbnVr2rRv79mUZsXCypAfR7eifakB/GqNpt60GE1pel61mY
         XO67lAfRB2XG40pISOGBDqOsmMqzfw4pgARsvU9LK+vwpBaCUNnl6OpcPPiVpwyZVtKf
         MjkUgV4RASxTaGyf3YvyYH5Uvhc36bOhv1xS4NwnExETKUtFv+YZsOfWFl4kVVv6hdGD
         vM0UJtJ4S51z3zfDQkFp21BXm/zkPDgvJNFvL2qZ8XtQMIwFRIHtI82LRdX+SNNDqyEf
         xMXg==
X-Gm-Message-State: APjAAAUtV+Kb13FDEWyVoJi8KXH8y9xeBh9ZMNKatNdziLs8K+ss5lPD
        IESYRVFQlXr8fygvAFenNU3M2VTGVvRPYuB5KCQ=
X-Google-Smtp-Source: APXvYqxni+hm9YE3cMiiBsq+tA2kd4YY3cEWlU1jikSd8uLb3c2eNIA4I/pha8dG2m3lQDNH4a37yhjSSHETvVXpYtI=
X-Received: by 2002:a02:9a02:: with SMTP id b2mr2194449jal.15.1573673877724;
 Wed, 13 Nov 2019 11:37:57 -0800 (PST)
MIME-Version: 1.0
References: <1565903072-3948-1-git-send-email-wenwen@cs.uga.edu> <20191113192821.GA3441686@builder>
In-Reply-To: <20191113192821.GA3441686@builder>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Wed, 13 Nov 2019 12:37:46 -0700
Message-ID: <CAOCk7NpoQ_JEQj61BvU4HLzxSOQtxUuB-nyrXRKQTxjZ7infbQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: add cleanup in ath10k_sta_state()
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Wenwen Wang <wenwen@cs.uga.edu>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:QUALCOMM ATHEROS ATH10K WIRELESS DRIVER" 
        <ath10k@lists.infradead.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        govinds@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 12:28 PM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Thu 15 Aug 14:04 PDT 2019, Wenwen Wang wrote:
>
> > If 'sta->tdls' is false, no cleanup is executed, leading to memory/resource
> > leaks, e.g., 'arsta->tx_stats'. To fix this issue, perform cleanup before
> > go to the 'exit' label.
> >
>
> Unfortunately this patch consistently crashes all my msm8998, sdm845 and
> qcs404 devices (running ath10k_snoc).  Upon trying to join a network the
> WiFi firmware crashes with the following:
>
> [  124.315286] wlan0: authenticate with 70:3a:cb:4d:34:f3
> [  124.334051] wlan0: send auth to 70:3a:cb:4d:34:f3 (try 1/3)
> [  124.338828] wlan0: authenticated
> [  124.342470] wlan0: associate with 70:3a:cb:4d:34:f3 (try 1/3)
> [  124.347223] wlan0: RX AssocResp from 70:3a:cb:4d:34:f3 (capab=0x1011 status=0 aid=2)
> [  124.402535] qcom-q6v5-mss 4080000.remoteproc: fatal error received: err_qdi.c:456:EF:wlan_process:1:cmnos_thread.c:3900:Asserted in wlan_vdev.c:_wlan_vdev_up:3219
>
> Can we please revert it for v5.5?

I observe the same, and concur with this request.

>
> Regards,
> Bjorn
>
> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> > ---
> >  drivers/net/wireless/ath/ath10k/mac.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> > index 0606416..f99e6d2 100644
> > --- a/drivers/net/wireless/ath/ath10k/mac.c
> > +++ b/drivers/net/wireless/ath/ath10k/mac.c
> > @@ -6548,8 +6548,12 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
> >
> >               spin_unlock_bh(&ar->data_lock);
> >
> > -             if (!sta->tdls)
> > +             if (!sta->tdls) {
> > +                     ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
> > +                     ath10k_mac_dec_num_stations(arvif, sta);
> > +                     kfree(arsta->tx_stats);
> >                       goto exit;
> > +             }
> >
> >               ret = ath10k_wmi_update_fw_tdls_state(ar, arvif->vdev_id,
> >                                                     WMI_TDLS_ENABLE_ACTIVE);
> > --
> > 2.7.4
> >
