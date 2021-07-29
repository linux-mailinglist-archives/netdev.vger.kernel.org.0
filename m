Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681C83DA6AF
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbhG2Ol6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbhG2OlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 10:41:23 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB49DC061765;
        Thu, 29 Jul 2021 07:41:19 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i39-20020a9d17270000b02904cf73f54f4bso6113453ota.2;
        Thu, 29 Jul 2021 07:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FPq9UnKVcU4kfCZLJNlpegR0xa6ct4O4koLbgdWD4mQ=;
        b=cBLsSxg7emiU57PRaLgGFkBKp+9tX2FpCAewe/ej4ucoKac0M7vtwcSsfbgbQkFe0K
         yvTTr4Md3XROGREifNti6dvrHwC+JRTnL5mUPKYH/PtrNRdxozTbyYPPw2mnZvQqcc1I
         vBbeRNT/FlKIqiCJeLALw8oEB0d5vwfJ/kYLKO2Oc1O6XtVXwgKpFNxW1gGnBdAJE+H2
         MgnOH+mldYPftLCSGFPhGlznENlozNZngjSwd2gwTU1XfjvlYVUE9B+IZOkqxDwTtYGH
         W3A1zx/NsSHBsyQcUg7Zxw/GaTX63J96u7+JW0iEj8uqZG+AfH/O//Evz6+MBmR213u1
         tySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FPq9UnKVcU4kfCZLJNlpegR0xa6ct4O4koLbgdWD4mQ=;
        b=L9nNqoXfaSkbO5W9nLOCWFlqKJUefblKoTRmAjLwViBtiyj9WJgBR/KgUZ/yvkQZm6
         15WOHfQ1etxrWGyl6CxeNzjN9QLyc9zdOTp4Dwto8ZOkIqWeHlvWwLnVvKfk+aph1+bW
         lGYe5XmzNob1ABPUVwpfNIPbHuqvAji6ojjtgcXdbhoT/Gnmq8jxuTJbs451yH4Tvops
         1kNSt5iMV1e+IVVJRwfPZklRRRhcsv//2oeQT+Y2ZD5ew8FR/5uEm9jBN3E+u4f17NB2
         78sDeUtmy6n5HfScuMAqTdTTEvW4NmMR+lkiwcfx/MBv8jzooanHqCeFq4srKSXuyrzD
         dP7Q==
X-Gm-Message-State: AOAM530/3PTSLsOpO9/VxHu8YmunJVDxXNggZJ+3DyFm5Fsvt6YCjpTb
        aBDV1ovLsfKXLTIQEYuvBEI=
X-Google-Smtp-Source: ABdhPJwU0Evtf3qU/3HFjq/6at57j3lQJc6/jHgfrc1Z2hQjAvtCqtjbxb3Nz982mtFrMD7LIMr1nw==
X-Received: by 2002:a9d:6d8d:: with SMTP id x13mr3571864otp.192.1627569679341;
        Thu, 29 Jul 2021 07:41:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id v13sm421ook.40.2021.07.29.07.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 07:41:18 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipv6: add IFLA_RA_MTU to expose mtu value
 in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com, chao.song@mediatek.com,
        zhuoliang.zhang@mediatek.com
References: <20210729090206.11138-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c4099beb-1c22-ac71-ae05-e3f9a8ab69e2@gmail.com>
Date:   Thu, 29 Jul 2021 08:41:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729090206.11138-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/21 3:02 AM, Rocco Yue wrote:
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 4882e81514b6..ea6c872c5f2c 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -347,7 +347,7 @@ enum {
>  	 */
>  	IFLA_PARENT_DEV_NAME,
>  	IFLA_PARENT_DEV_BUS_NAME,
> -
> +	IFLA_RA_MTU,
>  	__IFLA_MAX
>  };
>  
> diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
> index 70603775fe91..3dbcf212b766 100644
> --- a/include/uapi/linux/ipv6.h
> +++ b/include/uapi/linux/ipv6.h
> @@ -190,6 +190,7 @@ enum {
>  	DEVCONF_NDISC_TCLASS,
>  	DEVCONF_RPL_SEG_ENABLED,
>  	DEVCONF_RA_DEFRTR_METRIC,
> +	DEVCONF_RA_MTU,
>  	DEVCONF_MAX
>  };
>  

you do not need both IFLA and DEVCONF. Drop the DEVCONF completely. IFLA
attribute can be used for both inspection and notification on change.
