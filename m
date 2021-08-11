Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1FD3E95A8
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhHKQOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 12:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhHKQOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 12:14:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1083FC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 09:14:11 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b11so3842673wrx.6
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 09:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CGiZ94qAlcTwKTJSlwkI+NTv+u0kYtm6eFxBBXeJGT0=;
        b=cE7rgLNezmd/igRyVlN6zPlFrASUdrFxy+1o7hmLlcB39Gmo1f8ouGk0/uMHfBKCdn
         gOj8XaKHa6ukZZwUpbhxWZPeaHJPlYHq92GMrDlfl4lEH/78RbZzR/KdFUj15wQeX2Dq
         /zwtSSQf/5hASZpOIC+VtZrTBp9AAPJZulLJGVnr3jAE1TPAp9McxmaWO2s5Ak0JO+77
         7Lq75Icqb3zG8ejCFpg3pgIFkgPmo6f9lgTqc7cExYieJVmdkvT3zn1tUhCeiBO4haOS
         /IHqXHHPDf21DIyrtN1ujwE8Y2XDnXOohqY3d5sTNdMMYFmopzk51wD5zCUinM27jfoq
         jNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CGiZ94qAlcTwKTJSlwkI+NTv+u0kYtm6eFxBBXeJGT0=;
        b=hhxcn/2p4CzzRzqBOsnJNQ869G4bMJCJvv25vj5wOplkRvc/MUI+hM7GNRptlIAk9Y
         dEgNQ9X+SrUpmaXKXTTxkL5fup/IElNmaQwFx775uQX5GRA4qcoLv6cWmkfy2vjosGIw
         h5MYqbR6HVS660d9W3IuOfejTwDXFK8HgP7zTPhDwGJUP13RcwgKEwcrr6g/ktxme1Dg
         crJTVymdypeXB8UtEgE4guxRYb8hxKdbFDXron4NMvl/z1SNHFHR41TX0LHUZd/Zxa4E
         6vcuXQcgK5KnkgjNHTLrSlrRsek1eFJWJUFbq+DPcixexTbDt5y/CFFtJ8ZdSg3mzfwu
         TPQg==
X-Gm-Message-State: AOAM5328Rt+aspLg6vLXXth8QYDSORFehQnd5neJ3xfBl6BljZOAFBO/
        qiGiWwC/axSzWhY74d3YHJXcVk+EcVQ3xA==
X-Google-Smtp-Source: ABdhPJyWUZjb46oQIuWJDFddGaT8NycTSMkuothck8JcfAY36iIEZv8qsngsPeSw9IUJ3UyEarJmNw==
X-Received: by 2002:adf:fc45:: with SMTP id e5mr23227064wrs.127.1628698449658;
        Wed, 11 Aug 2021 09:14:09 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:a120:810a:2aba:99fe? ([2a01:e0a:410:bb00:a120:810a:2aba:99fe])
        by smtp.gmail.com with ESMTPSA id r12sm28532561wrn.31.2021.08.11.09.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 09:14:09 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 ipsec-next] xfrm: Add possibility to set the default to
 block if we have no policy
To:     antony.antony@secunet.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Christian Langrock <christian.langrock@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210331144843.GA25749@moon.secunet.de>
 <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <e0c347a0-f7d4-e1ef-51a8-2d8b65bccbbc@6wind.com>
Date:   Wed, 11 Aug 2021 18:14:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 18/07/2021 à 09:11, Antony Antony a écrit :
> From: Steffen Klassert <steffen.klassert@secunet.com>
Sorry for my late reply, I was off.

> 
> As the default we assume the traffic to pass, if we have no
> matching IPsec policy. With this patch, we have a possibility to
> change this default from allow to block. It can be configured
> via netlink. Each direction (input/output/forward) can be
> configured separately. With the default to block configuered,
> we need allow policies for all packet flows we accept.
> We do not use default policy lookup for the loopback device.
> 

[snip]

> diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
> index e946366e8ba5..88c647302977 100644
> --- a/include/net/netns/xfrm.h
> +++ b/include/net/netns/xfrm.h
> @@ -65,6 +65,13 @@ struct netns_xfrm {
>  	u32			sysctl_aevent_rseqth;
>  	int			sysctl_larval_drop;
>  	u32			sysctl_acq_expires;
> +
> +	u8			policy_default;
> +#define XFRM_POL_DEFAULT_IN	1
> +#define XFRM_POL_DEFAULT_OUT	2
> +#define XFRM_POL_DEFAULT_FWD	4
> +#define XFRM_POL_DEFAULT_MASK	7
> +

[snip]

> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> index ffc6a5391bb7..6e8095106192 100644
> --- a/include/uapi/linux/xfrm.h
> +++ b/include/uapi/linux/xfrm.h
> @@ -213,6 +213,11 @@ enum {
>  	XFRM_MSG_GETSPDINFO,
>  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
> 
> +	XFRM_MSG_SETDEFAULT,
> +#define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
> +	XFRM_MSG_GETDEFAULT,
> +#define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
> +
>  	XFRM_MSG_MAPPING,
>  #define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
>  	__XFRM_MSG_MAX
> @@ -508,6 +513,11 @@ struct xfrm_user_offload {
>  #define XFRM_OFFLOAD_IPV6	1
>  #define XFRM_OFFLOAD_INBOUND	2
> 
> +struct xfrm_userpolicy_default {
> +	__u8				dirmask;
> +	__u8				action;
> +};
> +
Should XFRM_POL_DEFAULT_* be moved in the uapi?
How can a user knows what value is expected in dirmask?

Same question for action. We should avoid magic values. 0 means drop or accept?
Maybe renaming this field to 'drop' is enough.


Regards,
Nicolas
