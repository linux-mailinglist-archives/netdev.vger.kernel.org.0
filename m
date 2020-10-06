Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D344428482D
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgJFINo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFINo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:13:44 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885EFC061755;
        Tue,  6 Oct 2020 01:13:42 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h7so8749728wre.4;
        Tue, 06 Oct 2020 01:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fMYP+cTwncpTLOVztv8nSpCnCd5UH8/ESLmq24XFpfc=;
        b=UJk/CbBM9YT1AvhOT4flOc9Rqcu4jiDsq1OkLSKDM9M4RZaL3qbNXXRVGGRw7wa2RH
         sEZCpyyc5rH9/w9ehJqsxTRmcMZE/mlrZbc2IROIr5kfLi9krph3F0DRKQn1j4iBfTD/
         AeJ6U5wOtgcdwz0wEt/UltVPYE6bbipXc9/1oeIEN5NvTC35qZPR4HktzAEy2kxBNA0C
         hZ9uc9XBV5ceLgqdX93uFoKzMEQGXc2h8SvLZO+oPC6VR65DuOmSMJ6V6V8uMyKO4XJy
         AwKzSbMQikWijNl3RE3SDv0vODGrqElNIcXDaKg20BMKXh36nNpOsTNPrpJBlA6Vy1z8
         RLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fMYP+cTwncpTLOVztv8nSpCnCd5UH8/ESLmq24XFpfc=;
        b=kkCw6Twv38/9C7YtmU8xm/HfYxJVMH2mCTgXBIVB/6Lo2bzViYJCkF3XLML88wqhuS
         FU0KkCed+KnHdJoQdQPbp5GE/SGzZHkFP2V+Qrsn7jqX1fATeObJ362ifho9lj4rDsmx
         CtivhGhCpjcX3/HtJpy37tlXk74H0rq/IXEcTrrtF2WNX+SruXPMqvElRngyNYYzSFJy
         p+EcQPWnLg0XAO9BklCKwoZWrmppBWmatrs09S8xvCJl8MzOx1mP/S5NP0IorN2nzw/q
         A3/u9PkZCFQuxoUg2B6ApsQT2RoDF+UYB5REvq1RzpJZdnScUVjHDXrkG8+ofOFu15PN
         eWVw==
X-Gm-Message-State: AOAM531BgithPGVmL/+nTtN15T3vGsgMK8xUogK/vK1S4amL4oHWxjJO
        lBd+dE96/02lGK6k331DPr0scjbydH1BsA==
X-Google-Smtp-Source: ABdhPJyYS3hLjZfwQwPfc0URX2t5CTl5+XXZ8ogjf78i7Ntm9CEf2LwDcK7QBClYu15RAOPPBTmGig==
X-Received: by 2002:adf:8030:: with SMTP id 45mr3510936wrk.177.1601972021228;
        Tue, 06 Oct 2020 01:13:41 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id b8sm2823523wmb.4.2020.10.06.01.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 01:13:40 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Tue, 6 Oct 2020 09:13:21 +0100
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath11k: Handle errors if peer creation fails
Message-ID: <20201006081321.e2tf5xrdhnk4j3nq@medion>
References: <20201004100218.311653-1-alex.dewar90@gmail.com>
 <87blhfbysb.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blhfbysb.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 10:26:28AM +0300, Kalle Valo wrote:
> Alex Dewar <alex.dewar90@gmail.com> writes:
> 
> > ath11k_peer_create() is called without its return value being checked,
> > meaning errors will be unhandled. Add missing check and, as the mutex is
> > unconditionally unlocked on leaving this function, simplify the exit
> > path.
> >
> > Addresses-Coverity-ID: 1497531 ("Code maintainability issues")
> > Fixes: 701e48a43e15 ("ath11k: add packet log support for QCA6390")
> > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ath11k/mac.c | 21 +++++++++------------
> >  1 file changed, 9 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> > index 7f8dd47d2333..58db1b57b941 100644
> > --- a/drivers/net/wireless/ath/ath11k/mac.c
> > +++ b/drivers/net/wireless/ath/ath11k/mac.c
> > @@ -5211,7 +5211,7 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
> >  	struct ath11k *ar = hw->priv;
> >  	struct ath11k_base *ab = ar->ab;
> >  	struct ath11k_vif *arvif = (void *)vif->drv_priv;
> > -	int ret;
> > +	int ret = 0;
> 
> I prefer not to initialise the ret variable.
> 
> >  	arvif->is_started = true;
> >  
> >  	/* TODO: Setup ps and cts/rts protection */
> >  
> > -	mutex_unlock(&ar->conf_mutex);
> > -
> > -	return 0;
> > -
> > -err:
> > +unlock:
> >  	mutex_unlock(&ar->conf_mutex);
> >  
> >  	return ret;
> 
> So in the pending branch I changed this to:
> 
> 	ret = 0;
> 
> out:
> 	mutex_unlock(&ar->conf_mutex);
> 
> 	return ret;
> 
> Please check.

Hi Kalle,

I'm afraid you've introduced a bug ;). The body of the first if-statement
in the function doesn't set ret because no error has occurred. So now
it'll jump to the label and the function will return ret uninitialized.

With the gcc extension, ret will be initialised to zero anyway, so we're
not saving anything by explicitly assigning to ret later in the
function.

Best,
Alex

> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
