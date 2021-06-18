Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856D13AD3D1
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhFRUrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhFRUrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 16:47:04 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50992C061574;
        Fri, 18 Jun 2021 13:44:53 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id d13so15638468ljg.12;
        Fri, 18 Jun 2021 13:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G7kQ9Jg07LG2cipeMCkOjvLhXj1OqGqGhs6/niYo2sE=;
        b=rUPPbiE83cwd7tTiSehNqA8CI2sNrxBpHQFuswK+VRov1p+eg+CJ5DnUrmOArgyl6Y
         5TcXAuUihn+CfqtvXXQieviRDakTtmGde7nj2ZhKkp4fV2PExBsceL04XleuowQGSHiH
         ZN3w29CtIRvh9s/9DDV9p05iU+QZLNBhytEu9YHovAH03WCM7F5hrApj/E/WE07ObOdF
         KtgrdcQzdQ0pWCydZic+JxJZJNvQ35fpGQ8JwU1Qru5485eItbzv7fJ7wTUvr6uBzWfY
         RenlY2do9iScQmSNoqcgnZy+iznZ+nK2ARfYY1ZyIY4DrmbZy95bXmzc/26K1MDBair3
         yNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G7kQ9Jg07LG2cipeMCkOjvLhXj1OqGqGhs6/niYo2sE=;
        b=Kg5KcwplHzUSzhU1sD5aXUsYqEZ+TbNEqYE0SPCvxXOP2HL1JsntPv2KaLkrde001I
         I/WoJ17r63TlRm+gNZnPmGu1kbW1BEmc19b1c10VbrQtcVkDGznIjPQ+jo68yWZO4nn2
         JuRB7FmGT+XZrjNT5Wdra1LYdGz64Aw0zQvkoNECJ8xejwDsx3TZ+YYtN/l7+IgJ7XMl
         dOCqafWBj2jgdE8OURv1pSHKWTJ7Nb1V2aECxyDrZQeW85QrbNbXG1dwo/VT3W3MedCH
         cTPsXr0KJo976bjTIlIjEbFH8+kAKWw6WWe1ThcnqH0dkYQD11HErC8oYq1A5f65h/EP
         zTGA==
X-Gm-Message-State: AOAM532oJKBDkYvR/QuWlL84mhfbzluvmovtPgbdtKn7X12+DuJEyJ+j
        qVMDlZo4ga//63h3VNf3Vbg=
X-Google-Smtp-Source: ABdhPJwGezIn9r9dCJJ9XwZgoUH6axsl+RAoLTHwj8WdM/zJVRxrCkq3KnAu/MX33paSLKIbH3r7Ig==
X-Received: by 2002:a2e:7a16:: with SMTP id v22mr11062453ljc.101.1624049091690;
        Fri, 18 Jun 2021 13:44:51 -0700 (PDT)
Received: from [192.168.2.145] (94-29-29-31.dynamic.spd-mgts.ru. [94.29.29.31])
        by smtp.googlemail.com with ESMTPSA id z8sm1008690lfg.243.2021.06.18.13.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 13:44:51 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] cfg80211: Add wiphy_info_once()
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20210511211549.30571-1-digetx@gmail.com>
Message-ID: <e7495304-d62c-fd20-fab3-3930735f2076@gmail.com>
Date:   Fri, 18 Jun 2021 23:44:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210511211549.30571-1-digetx@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

12.05.2021 00:15, Dmitry Osipenko пишет:
> Add wiphy_info_once() helper that prints info message only once.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
> 
> Changelog:
> 
> v2: - New patch added in v2.
> 
>  include/net/cfg80211.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 5224f885a99a..3b19e03509b3 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -8154,6 +8154,8 @@ bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
>  	dev_notice(&(wiphy)->dev, format, ##args)
>  #define wiphy_info(wiphy, format, args...)			\
>  	dev_info(&(wiphy)->dev, format, ##args)
> +#define wiphy_info_once(wiphy, format, args...)			\
> +	dev_info_once(&(wiphy)->dev, format, ##args)
>  
>  #define wiphy_err_ratelimited(wiphy, format, args...)		\
>  	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
> 

Ping?

Arend, is this series good to you? I assume Kalle could pick it up if
you'll give ack. Thanks in advance.
