Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC663F8087
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 04:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbhHZCgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 22:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236341AbhHZCgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 22:36:50 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A88C0613D9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 19:36:04 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 18so1389511pfh.9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 19:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IXO6cD9qv38TQfbOvxWr/m2geWj4FreytS+JNpwkx8w=;
        b=K1t7iF2AcmyyogIeOvC3ucqCp4sLqlV0R8pbH9o8qD8r7RL38sbVIseJb7YglhwADK
         kcSVvEqhDcdxnNlmec5NmZs6aMo4W2WUwVYv1kQNWhACaXzHN9alVVVFdjd2ttZEmgzH
         cnzSEbraQbTH0Pgtn8xXWauL1oOEzNnbaQAGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IXO6cD9qv38TQfbOvxWr/m2geWj4FreytS+JNpwkx8w=;
        b=gtp9FPNhf8ToioemWSqUpZyV7qe5FzNz0Bskz2qi+sp+aq47L9VHM54Rwx4+7Hqq92
         BJ7EQp9if0v9+e6i3XW+cat7h/Qly5g2WiuMOinZerk1VU18c0Xtq0RVfNDkajDMkd7I
         4h11EqEhRtOpJ6i594Pevn8uJbgEl0JmMOfTyvTie3viaZodlZjfkMo55UMY/2tFk5L4
         DY15je97Nrk6BaO+N4XAZp6sJvE+mCxKYWvtQh5YedeMS1zfJ6Jr2kyRjk8KT32OTk26
         tBPdGQpA771ZacG+3/Litl6KzORiBMbZpz6hbhQxmWf5hZIuHPXYf7H3Nkr1oIBsv9wZ
         karA==
X-Gm-Message-State: AOAM531Othq73t3tyfnVHq3nB7bjB4x0OHMLI3Z99A7+I/eEqc7vO/1u
        lvq4BICOyellQrspzE2vRtZDMA==
X-Google-Smtp-Source: ABdhPJw/7CPlCMG4N6PUqnUSHgWcqLxQ6vljwyuDycBVODx8bW7jK8agCvoDhSNEQf7CAXz/QntPvA==
X-Received: by 2002:a63:111f:: with SMTP id g31mr1294087pgl.80.1629945363702;
        Wed, 25 Aug 2021 19:36:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t42sm923412pfg.30.2021.08.25.19.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 19:36:03 -0700 (PDT)
Date:   Wed, 25 Aug 2021 19:36:02 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        Joe Perches <joe@perches.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192de: Restore channel index initialization
Message-ID: <202108251935.1F1CBBD3@keescook>
References: <20210825183103.1142909-1-keescook@chromium.org>
 <0f63064fd9f4464a87d9358e874c6b84@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f63064fd9f4464a87d9358e874c6b84@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:45:53AM +0000, Pkshih wrote:
> 
> 
> > -----Original Message-----
> > From: Kees Cook [mailto:keescook@chromium.org]
> > Sent: Thursday, August 26, 2021 2:31 AM
> > To: Pkshih
> > Cc: Kees Cook; Kalle Valo; David S. Miller; Jakub Kicinski; Larry Finger; Colin Ian King; Kaixu Xia;
> > Joe Perches; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-hardening@vger.kernel.org
> > Subject: [PATCH] rtlwifi: rtl8192de: Restore channel index initialization
> > 
> > 2G channel indexes still need "place" to be initialized, since it is
> > returned from this function when channel is less than 14.
> > 
> > Fixes: 369956ae5720 ("rtlwifi: rtl8192de: Remove redundant variable initializations")
> 
> Like the patch "rtlwifi: rtl8192de: Fix initialization of place in _rtl92c_phy_get_rightchnlplace()"
> you sent before, please help to correct the removal of the commit 369956ae5720.
> I think we can add following into this patch.
> 
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> @@ -1363,7 +1363,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
> 
>  u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
>  {
> -       u8 place = chnl;
> +       u8 place;
> 
>         if (chnl > 14) {
>                 for (place = 14; place < sizeof(channel_all); place++) {

Oh, er, it looks like Nathan found this before me, yes. I think
https://lore.kernel.org/linux-wireless/20210823222014.764557-1-nathan@kernel.org/
is the complete patch.

-Kees

> 
> > Cc: Ping-Ke Shih <pkshih@realtek.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Colin Ian King <colin.king@canonical.com>
> > Cc: Kaixu Xia <kaixuxia@tencent.com>
> > Cc: Joe Perches <joe@perches.com>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > index 8ae69d914312..b32fa7a75f17 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > @@ -896,7 +896,7 @@ static void _rtl92d_ccxpower_index_check(struct ieee80211_hw *hw,
> > 
> >  static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
> >  {
> > -	u8 place;
> > +	u8 place = chnl;
> > 
> >  	if (chnl > 14) {
> >  		for (place = 14; place < sizeof(channel5g); place++) {
> 
> --
> Ping-Ke
> 

-- 
Kees Cook
