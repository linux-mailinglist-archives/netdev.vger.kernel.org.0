Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4025C403204
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 03:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346153AbhIHBCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 21:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345859AbhIHBCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 21:02:14 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7107C06175F
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 18:01:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k17so283271pls.0
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 18:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=fL7IHHdZ/gzoOTGUPxPDxAU1KAMX+gAeeQ7IEIgS92I=;
        b=fUGYNrjWnrb3I1eaPcRpBHa5uCveys5QZgedEq6FkqjUD4OZbSwa4C3wVTN3Ea0J1E
         NEeFEDtPtBpxrAKvOWTnaDwo2B2v/P/5kd5YLX/XwbKcaO8nplHt67j6ZHZVQpMteY+4
         0eAtp+P3YO9W747F5K61gMUrXOoE1IA72GO8EM4UhZ02fP45WR68o9G/TsFy4xh+tT6j
         8Gh/i3SW9y/vNeQtT6qSMbCQ9H+zzZF6E2bhHT6OyoUZ3m6dfTL3zikE4O0/Fj8Ue6Rj
         Bh5cOEbzVLnmPBaFdSs4A1+vikjxpd4fQt9bHyJ402yyWqWjZTTapx4aTi1GtG/PfSRF
         MbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=fL7IHHdZ/gzoOTGUPxPDxAU1KAMX+gAeeQ7IEIgS92I=;
        b=URRI/hd2l4NgLaSsLqm4MxHPkD9/Y7tQejI2uhjamn4lai4cxXK7zaD/1tagA8TsIu
         VzcvMSzyQROQjFIHePM3dzWomwgZ3k1GciZYpFOErUvLQbYXeIPz63s6FhXCjKGC6QfY
         /T/eEyvWZLTiRlvhJCp2mp7sp3jc7kYxtsryZSkMwypoU2NB2lXe7SQR2WyQexJOFYGo
         1cLCBk70l876NcwEPinbUEzoiVtn9JJprGpNg8porT8kcEkD60C/NzYT0UlXF/c6JdHJ
         0XfaPiEBkU6xGFgxtGHXt7Rtziwkygi2iylB3wPHSQr4blIRkBgdoQEBTI/YJX5fGcX2
         3P5g==
X-Gm-Message-State: AOAM532Ai3Y5rgQPY7irTprBYBmFB6iWyGwOioqnw0wttP1HrmvXT+90
        WWZNDURC4EnkRRt+j36BuX8YMw==
X-Google-Smtp-Source: ABdhPJzn6dDaPFPvD6xD3dX6BMiDBYlT3VapdFvc9aR8lJIc1mWPZRw21Ia813useTb+MqcxrF740A==
X-Received: by 2002:a17:90b:33c8:: with SMTP id lk8mr1221312pjb.241.1631062867247;
        Tue, 07 Sep 2021 18:01:07 -0700 (PDT)
Received: from dragon (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id g2sm239957pfo.154.2021.09.07.18.01.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Sep 2021 18:01:06 -0700 (PDT)
Date:   Wed, 8 Sep 2021 09:00:58 +0800
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Soeren Moch <smoch@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Subject: Re: [BUG] Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev
 as fallback
Message-ID: <20210908010057.GB25255@dragon>
References: <20210425110200.3050-1-shawn.guo@linaro.org>
 <cb7ac252-3356-8ef7-fcf9-eb017f5f161f@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb7ac252-3356-8ef7-fcf9-eb017f5f161f@web.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Soeren,

On Tue, Sep 07, 2021 at 09:22:52PM +0200, Soeren Moch wrote:
> On 25.04.21 13:02, Shawn Guo wrote:
> > Instead of aborting country code setup in firmware, use ISO3166 country
> > code and 0 rev as fallback, when country_codes mapping table is not
> > configured.  This fallback saves the country_codes table setup for recent
> > brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
> > revision number.
> This patch breaks wireless support on RockPro64. At least the access
> point is not usable, station mode not tested.
> 
> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4359/9 wl0: Mar  6 2017
> 10:16:06 version 9.87.51.7 (r686312) FWID 01-4dcc75d9
> 
> Reverting this patch makes the access point show up again with linux-5.14 .

Sorry for breaking your device!

So it sounds like you do not have country_codes configured for your
BCM4359/9 device, while it needs particular `rev` setup for the ccode
you are testing with.  It was "working" likely because you have a static
`ccode` and `regrev` setting in nvram file.  But roaming to a different
region will mostly get you a broken WiFi support.  Is it possible to set
up the country_codes for your device to get it work properly?

Shawn

> 
> Regards,
> Soeren
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> >  .../broadcom/brcm80211/brcmfmac/cfg80211.c      | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> > index f4405d7861b6..6cb09c7c37b6 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> > @@ -7442,18 +7442,23 @@ static s32 brcmf_translate_country_code(struct brcmf_pub *drvr, char alpha2[2],
> >  	s32 found_index;
> >  	int i;
> >
> > -	country_codes = drvr->settings->country_codes;
> > -	if (!country_codes) {
> > -		brcmf_dbg(TRACE, "No country codes configured for device\n");
> > -		return -EINVAL;
> > -	}
> > -
> >  	if ((alpha2[0] == ccreq->country_abbrev[0]) &&
> >  	    (alpha2[1] == ccreq->country_abbrev[1])) {
> >  		brcmf_dbg(TRACE, "Country code already set\n");
> >  		return -EAGAIN;
> >  	}
> >
> > +	country_codes = drvr->settings->country_codes;
> > +	if (!country_codes) {
> > +		brcmf_dbg(TRACE, "No country codes configured for device, using ISO3166 code and 0 rev\n");
> > +		memset(ccreq, 0, sizeof(*ccreq));
> > +		ccreq->country_abbrev[0] = alpha2[0];
> > +		ccreq->country_abbrev[1] = alpha2[1];
> > +		ccreq->ccode[0] = alpha2[0];
> > +		ccreq->ccode[1] = alpha2[1];
> > +		return 0;
> > +	}
> > +
> >  	found_index = -1;
> >  	for (i = 0; i < country_codes->table_size; i++) {
> >  		cc = &country_codes->table[i];
> 
