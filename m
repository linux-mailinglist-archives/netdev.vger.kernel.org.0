Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8DB34F18E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 21:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhC3T0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 15:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhC3T0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 15:26:37 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF31DC061574;
        Tue, 30 Mar 2021 12:26:36 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so9000694wmj.1;
        Tue, 30 Mar 2021 12:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yd9mIYSfyYtaQ80AUfAIBHd3tWlCfBll0IGCKZB64Oc=;
        b=YCdl8xJEp0RU9QNsOSE26OgGlCt+i8taJwzEYkC1y5oSsGOXeZN2atlsRwCHe0ytff
         hKk6pyRicoL7mCRuxyTQXBScfU26IGwmsL9EnkUx0HRLMKHtDEeD2D0821qHHULS07BL
         kv6GjdyF7qy1FmH37PmOIy9JcwVyE+5uCfgjCk3R2Z/pqZX6NJpmLTzo5lIxz9bNrJri
         eRSnS3qB0FqkWnB6hvxTDfnflE16RSTt1MIAlpdB0CZHEek+gsF1vXCUe+2Tzcu0BoDE
         +Ooa31Lolc6nwzdQcOkjRdmgcGj8fT6kUcGrNhlM8WymKr0QUd/zi7LgDs1amoqytzVY
         e7Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yd9mIYSfyYtaQ80AUfAIBHd3tWlCfBll0IGCKZB64Oc=;
        b=BL1bIxw0BY00qxb+c/ONLnsN3gxuWpRR1O9RNrwdfRsp86sIQ4629tI6bCwOWVKD+t
         LqMnyI7XkLnJx+Qe4jOkbNR9HI/qZ9lLx0wqNJcguw2J4pE4WBrebLtsn7D5RIB0bhAL
         C6UCpiKKtSLGX59Chmr+9BfXw+/eQI7CGQXIICXiAMkS8pFzbzyS4wBg5aM3fB2UJRIT
         Ff0GWW629rFbwSmvX9LPqk95WvFIH4ezPxrcZG1qJGUgOIjk4vBxb6oNH/fHsDeHC4gT
         RFraYL8ACITP04pximwnMYbrgytNr+wmPIVanWd1AP0ZBWmfjw/xqlayrqorFnuFUEqv
         3fNA==
X-Gm-Message-State: AOAM532ixLyywmxTmHWXs+iY3PSnfPZv4gmozQ3G50svo0EQuSzWoA74
        zglW1Ub+FLp9TKgZdhh+nVE=
X-Google-Smtp-Source: ABdhPJxNg7obrbrHiuPSlKBwL1YEzcuLxfZuWmxhPzkaN2kGHrfZwcuFF69iqkAFdbWkYFoL9+KHAA==
X-Received: by 2002:a05:600c:4fcb:: with SMTP id o11mr5548754wmq.117.1617132395546;
        Tue, 30 Mar 2021 12:26:35 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.251.74])
        by smtp.gmail.com with ESMTPSA id j16sm7944070wmi.2.2021.03.30.12.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 12:26:34 -0700 (PDT)
Subject: Re: [PATCH v2] wireless/nl80211.c: fix uninitialized variable
To:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
References: <20210330172253.10076-1-alaaemadhossney.ae@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b287e62c-c72e-c12a-c48a-8dad4a48dd49@gmail.com>
Date:   Tue, 30 Mar 2021 21:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210330172253.10076-1-alaaemadhossney.ae@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/21 7:22 PM, Alaa Emad wrote:
> This change fix  KMSAN uninit-value in net/wireless/nl80211.c:225 , That
> because of `fixedlen` variable uninitialized,So I initialized it by zero.
> 
> Reported-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
> Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>
> ---
> Changes in v2:
>   - Make the commit message more clearer.
> ---
>  net/wireless/nl80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 775d0c4d86c3..b87ab67ad33d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -210,7 +210,7 @@ static int validate_beacon_head(const struct nlattr *attr,
>  	const struct element *elem;
>  	const struct ieee80211_mgmt *mgmt = (void *)data;
>  	bool s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
> -	unsigned int fixedlen, hdrlen;
> +	unsigned int fixedlen = 0, hdrlen;
>  
>  	if (s1g_bcn) {
>  		fixedlen = offsetof(struct ieee80211_ext,
> 

What was the report exactly ?

Current code does :

unsigned int fixedlen;

if (s1g_bcn) {
    fixedlen = something1;
    ...
else {
    fixedlen = something2;
    ...
}

So your patch does nothing.

Initial value of @fixedlen is not relevant.

Reading this code (without access to KMSAN report) I suspect the issue
is more like the following :

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 775d0c4d86c3..d815261917ff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -209,9 +209,12 @@ static int validate_beacon_head(const struct nlattr *attr,
        unsigned int len = nla_len(attr);
        const struct element *elem;
        const struct ieee80211_mgmt *mgmt = (void *)data;
-       bool s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
        unsigned int fixedlen, hdrlen;
+       bool s1g_bcn;
 
+       if (len < offsetofend(typeof(*mgmt), frame_control))
+               goto err;
+       s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
        if (s1g_bcn) {
                fixedlen = offsetof(struct ieee80211_ext,
                                    u.s1g_beacon.variable);

