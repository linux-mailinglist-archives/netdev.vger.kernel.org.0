Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993A13F808B
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 04:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbhHZChZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 22:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhHZChW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 22:37:22 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62A0C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 19:36:34 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e16so973651pfc.6
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 19:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NlaspxbPA+2xchr3WW96QURnF4el1IXYtFV14lm+uSU=;
        b=OWRUuhIZ+X2E6ePc9AlOJ19qQj2M1x5dD+nG1w6h1JW08rdtuhupaQ4Zv8raKvaG+T
         naonlYQqNZFM963ab1zRg5KHYCO0vbASsrN5SvPmsOY7AxPkm5VwyQsDj2p8uqiVURZh
         XLwTFDvJZCWvsYI9j2tJNaoJA0UvM7thc8zmI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NlaspxbPA+2xchr3WW96QURnF4el1IXYtFV14lm+uSU=;
        b=UwFViwE+rBxbKaj2ovygoWxy8WFzlVIIEwh2vTzHPS+0hWiq9xrZZQip3RKSKxv7sn
         Y9UDBEZkLJ7yVklyFzznDGbiLJSWZXw7eLLZ1bwO9gKO8RScBENKsM8KKfGpYOmK+/Fc
         TaOl5OJlEAV6jYAQ7aqEEDm4jJDGXIKRVeygOcMJIjfGqhO3hr1x3JqctXi+U0B5XJvX
         SPjTwZdLeAbtjz4N0ZFTYlsIz+nK5QMdSYBUgDqIqXejwp2XcG7MMWDcIoB1OEfEk9hq
         KfPUPmviLSByXOIVOZ38jHyPLSVBF2ViuoTFNx8sYkdhI6B2CJKwXuTIwYuXnChAw2pU
         p0ag==
X-Gm-Message-State: AOAM530Zy2IHoSnQkjhcacbWAf9w+VIMSP4hPM/3WZ38YYekVD5q8N7Q
        mcQji7iixzW2XfIU50i9UK3/Xg==
X-Google-Smtp-Source: ABdhPJzw5UOs61WXzwKUSeAXEQ17BphHue61nICDRU/o23PcN8dyze6W+nqZ26M2dwaMNuqHBJvdCA==
X-Received: by 2002:a05:6a00:230e:b029:3c4:24ff:969d with SMTP id h14-20020a056a00230eb02903c424ff969dmr1491558pfh.44.1629945394200;
        Wed, 25 Aug 2021 19:36:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b5sm773155pjq.2.2021.08.25.19.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 19:36:33 -0700 (PDT)
Date:   Wed, 25 Aug 2021 19:36:32 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Colin Ian King <colin.king@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        llvm@lists.linux.dev
Subject: Re: [PATCH] rtlwifi: rtl8192de: Fix initialization of place in
 _rtl92c_phy_get_rightchnlplace()
Message-ID: <202108251936.42A0780E3@keescook>
References: <20210823222014.764557-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823222014.764557-1-nathan@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 03:20:14PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:901:6: warning:
> variable 'place' is used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>         if (chnl > 14) {
>             ^~~~~~~~~
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:909:9: note:
> uninitialized use occurs here
>         return place;
>                ^~~~~
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:901:2: note: remove
> the 'if' if its condition is always true
>         if (chnl > 14) {
>         ^~~~~~~~~~~~~~~
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:899:10: note:
> initialize the variable 'place' to silence this warning
>         u8 place;
>                 ^
>                  = '\0'
> 1 warning generated.
> 
> Commit 369956ae5720 ("rtlwifi: rtl8192de: Remove redundant variable
> initializations") removed the initialization of place but it appears
> that this removal was in the wrong function.
> 
> _rtl92c_phy_get_rightchnlplace() returns place's value at the end of the
> function so now if the if statement is false, place never gets
> initialized. Add that initialization back to address the warning.
> 
> place's initialization is not necessary in
> rtl92d_get_rightchnlplace_for_iqk() as place is only used within the if
> statement so it can be removed, which is likely what was intended in the
> first place.
> 
> Fixes: 369956ae5720 ("rtlwifi: rtl8192de: Remove redundant variable initializations")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks, I tripped over this too.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> index 8ae69d914312..9b83c710c9b8 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> @@ -896,7 +896,7 @@ static void _rtl92d_ccxpower_index_check(struct ieee80211_hw *hw,
>  
>  static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
>  {
> -	u8 place;
> +	u8 place = chnl;
>  
>  	if (chnl > 14) {
>  		for (place = 14; place < sizeof(channel5g); place++) {
> @@ -1363,7 +1363,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
>  
>  u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
>  {
> -	u8 place = chnl;
> +	u8 place;
>  
>  	if (chnl > 14) {
>  		for (place = 14; place < sizeof(channel_all); place++) {
> 
> base-commit: 609c1308fbc6446fd6d8fec42b80e157768a5362
> -- 
> 2.33.0
> 

-- 
Kees Cook
