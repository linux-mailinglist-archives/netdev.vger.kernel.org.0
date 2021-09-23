Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D2141574E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 06:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhIWEPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 00:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhIWEPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 00:15:09 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF0BC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 21:13:38 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso6712462otv.12
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 21:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=msim7IOlD9QMDjiaL8dqk9yrskHNBR6eX3VGRhInoug=;
        b=EFVky6EapFPVmM2fzti0rbI3M6z0QVoQSdyzLW8ED0PFQXGtr1qWMnRIJgUmdi/WyY
         GyOG9Ogct+RHE3oJFQ0TpJ9xEQxqRZ1S4Cg6R0QVs4/vb9Mh0RetJJwFkjIocPYNg702
         qrPLlJBBd+IdVSYX8vIODljgZqiiFsjuJJGvGUuR9OpgjpNjSJ85qXhfaCnRMC5sJc/Z
         kTk/fIFF4kChKJLBmC8Kfdizkngagp/cmX65BSiHIdiL6rlfZyHM29AiUfTyUgeE0eFn
         8elsJwTQduBzkF8xdVC8RJTdMlmC1chzf4x2mI7kCwRoHijTANPaujBEsUBKsYUWP3DW
         Xw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=msim7IOlD9QMDjiaL8dqk9yrskHNBR6eX3VGRhInoug=;
        b=DcBpy4JBXOtgiAu2rrCGwVw6O7s55sDBLLEUIlVvSzQz4pXrwcdw0DWbXfyNb7i3gr
         26XZkyeV4lrYOWlxaMw1bPkjD2sb+7gHZnzH5junz0Zt8R0xKiU1yEP/+nPTExmLMIeK
         yjjlYGKo3HR0y7I1T45ZqXGTuaSaRL3XTZaqZmoko7inh+9+D+VbtE7QWfpdxCEp/lb3
         RTFyfx1ORpQ37TdllD3Gsszl+A/8kHmhsIUmCAjH6uMfvnNlpUCHb/AtACSM7ZIYRAWu
         G5EFD+foC7Pa8QSwawUVlKWHGUYhgen5Q9Qw7h0XPQr+mfkpx9Yx+v9+9JKMTTNwjtDJ
         L7DA==
X-Gm-Message-State: AOAM533I2j86twdRJJCvkka3TYnk4if6t3YZnoLkw2XDaWrTUZnWTlsS
        9Pja7AH1p9CzVeRmNWYg4qo=
X-Google-Smtp-Source: ABdhPJwV65y8lEKwvuIiN5cTFICGEfixiF0kGDa9AhMfinM2dMSNvzTcVKFlagWiFO3JKxaaRL1C1Q==
X-Received: by 2002:a9d:6143:: with SMTP id c3mr1593628otk.124.1632370417685;
        Wed, 22 Sep 2021 21:13:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id f17sm1103743ook.9.2021.09.22.21.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 21:13:37 -0700 (PDT)
Subject: Re: [PATCH net] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
To:     Xiao Liang <shaw.leon@gmail.com>, netdev <netdev@vger.kernel.org>
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        davem@davemloft.net
References: <20210922101654.7775-1-shaw.leon@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <adb4f9a5-6f3d-5aeb-a1e7-9ac04be925d5@gmail.com>
Date:   Wed, 22 Sep 2021 22:13:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210922101654.7775-1-shaw.leon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 4:16 AM, Xiao Liang wrote:
> @@ -1682,10 +1683,17 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
>  	/* length of rtnetlink header + attributes */
>  	rtnh->rtnh_len = nlmsg_get_pos(skb) - (void *)rtnh;
>  
> -	return 0;
> +	return rtnh;
>  
>  nla_put_failure:
> -	return -EMSGSIZE;
> +	return ERR_PTR(-EMSGSIZE);
> +}
> +
> +int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
> +		    int nh_weight, u8 rt_family)

Adding classid as an input to fib_add_nexthop and checking it for non-0
before adding to the message is a better way to resolve this.


