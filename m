Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FE22AA590
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgKGNuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgKGNuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:50:00 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C877FC0613CF;
        Sat,  7 Nov 2020 05:49:58 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 33so4148382wrl.7;
        Sat, 07 Nov 2020 05:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nj2JtUJmFHpe07y5jjEoZy68QUQ8AyUEQF5EdLJkofs=;
        b=scINATImyjbFT1SRMBhtHASoe4YFJRjQcBST+6yUDQHA36PpkoNUy4b/BDp1peHr/G
         YjN4m5kJLrFC/y/od3zdzTGF8jZwHFR2L6NAxdTOFE4JKixqX/Sew6lMbiCLy+9cwlXm
         cSRq/XfZ0miuOY/pCM7/sXx+LYyNaVEYigqVqmGptMvpR3h7cj3arCouluKGGps59laS
         sn1o0X6/F8eF+haM0AuMiIK4UNuyRTu7PklYhl1WlfzxPG3pNv+72mKY1BbX6obNmo1Y
         1isF9S3HYDYKTo6g0NBuVs0dZFylLn0inUXR7fGGewaoAvzBKE/Arzt7luOcuRWqGFtk
         /Jow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nj2JtUJmFHpe07y5jjEoZy68QUQ8AyUEQF5EdLJkofs=;
        b=qLbx6zhIyWWysHqNhIStU+yS5SpuvBUwvS+3Q8gwKs5VpeiCJIOz0QxfHEnDaXSj2F
         iwzkszCJXLqt/NZvrYhkTi8v1lHPyJtJgDP5Z9N73rralkayWLSISbUqIRQzeGvKrqx3
         1Zi9MIpOgMueHCyZLmcbEFQMGzMpFdTu4AnQGVkOrnIbFIZN8XRIXMSPOz8WXcdov07T
         dyGAGCcpZSAJywKRDp9IwUL1G5FWpFn4f4+fOCfLvYheecMUQczutOPHyw2xwqBgNrBH
         BZiWJ5UIY9EnZOm6g89yfX31aSCGT9xKh3Fx7j1NJfMi4yT5D1pGqmedlN+l3/HCyiGk
         I8Xw==
X-Gm-Message-State: AOAM532VhTOivBSkvhXjl2sTQ3kS1VR9ulXlB/UjRAVXwIeUQiqaP9qO
        8ykseaP4hahOavsA9B7UB5g=
X-Google-Smtp-Source: ABdhPJyn1291BcADiHwatY9ZFKBKBK4BYU+Oc7aSCNYCiYzWBEjse487TWmXKiPjOsv29aKRZdeh7w==
X-Received: by 2002:a5d:6cc5:: with SMTP id c5mr6971236wrc.301.1604756997485;
        Sat, 07 Nov 2020 05:49:57 -0800 (PST)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id k81sm8117722wma.2.2020.11.07.05.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 05:49:56 -0800 (PST)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Sat, 7 Nov 2020 13:49:08 +0000
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alex Dewar <alex.dewar90@gmail.com>, netdev@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        ath11k@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] ath11k: Handle errors if peer creation fails
Message-ID: <20201107134908.ncne6nm7yyibp3qt@medion>
References: <20201004100218.311653-1-alex.dewar90@gmail.com>
 <87blhfbysb.fsf@codeaurora.org>
 <20201006081321.e2tf5xrdhnk4j3nq@medion>
 <87pn4pfm19.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn4pfm19.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 07, 2020 at 01:23:30PM +0200, Kalle Valo wrote:
> Alex Dewar <alex.dewar90@gmail.com> writes:
> 
> > On Tue, Oct 06, 2020 at 10:26:28AM +0300, Kalle Valo wrote:
> >> Alex Dewar <alex.dewar90@gmail.com> writes:
> >> 
> >> > ath11k_peer_create() is called without its return value being checked,
> >> > meaning errors will be unhandled. Add missing check and, as the mutex is
> >> > unconditionally unlocked on leaving this function, simplify the exit
> >> > path.
> >> >
> >> > Addresses-Coverity-ID: 1497531 ("Code maintainability issues")
> >> > Fixes: 701e48a43e15 ("ath11k: add packet log support for QCA6390")
> >> > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> >> > ---
> >> >  drivers/net/wireless/ath/ath11k/mac.c | 21 +++++++++------------
> >> >  1 file changed, 9 insertions(+), 12 deletions(-)
> >> >
> >> > diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> >> > index 7f8dd47d2333..58db1b57b941 100644
> >> > --- a/drivers/net/wireless/ath/ath11k/mac.c
> >> > +++ b/drivers/net/wireless/ath/ath11k/mac.c
> >> > @@ -5211,7 +5211,7 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
> >> >  	struct ath11k *ar = hw->priv;
> >> >  	struct ath11k_base *ab = ar->ab;
> >> >  	struct ath11k_vif *arvif = (void *)vif->drv_priv;
> >> > -	int ret;
> >> > +	int ret = 0;
> >> 
> >> I prefer not to initialise the ret variable.
> >> 
> >> >  	arvif->is_started = true;
> >> >  
> >> >  	/* TODO: Setup ps and cts/rts protection */
> >> >  
> >> > -	mutex_unlock(&ar->conf_mutex);
> >> > -
> >> > -	return 0;
> >> > -
> >> > -err:
> >> > +unlock:
> >> >  	mutex_unlock(&ar->conf_mutex);
> >> >  
> >> >  	return ret;
> >> 
> >> So in the pending branch I changed this to:
> >> 
> >> 	ret = 0;
> >> 
> >> out:
> >> 	mutex_unlock(&ar->conf_mutex);
> >> 
> >> 	return ret;
> >> 
> >> Please check.
> >
> > I'm afraid you've introduced a bug ;). The body of the first if-statement
> > in the function doesn't set ret because no error has occurred. So now
> > it'll jump to the label and the function will return ret uninitialized.
> 
> Ouch, so I did. Good catch! I would have hoped that GCC warns about that
> but it didn't.
> 
> I fixed the bug and added also a warning messages if peer_create()
> fails:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=e3e7b8072fa6bb0928b9066cf76e19e6bd2ec663
> 
> Does this look better now? :)

LGTM!

> 
> > With the gcc extension, ret will be initialised to zero anyway, so we're
> > not saving anything by explicitly assigning to ret later in the
> > function.
> 
> I prefer not to initialise ret in the beginning of the function and I
> try to maintain that style in ath11k. I think it's more readable that
> the error value is assigned just before the goto.

Fair enough. I appreciate that it's a style issue.

> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
