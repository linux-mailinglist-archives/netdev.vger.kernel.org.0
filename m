Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377526758E6
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjATPlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 10:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjATPlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 10:41:01 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74125594
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 07:40:42 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id b7so5213852wrt.3
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 07:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9JzME2Q7VkDOLpF4JQ1hrZ8wE56oxQKxVDaqorxZec4=;
        b=FvHbMlG/1bRQoEz4CeDrw+rcPlAJhdER23d6oCumRERVZoEA1UC+PQRlrmi6F7y9uv
         Kz8W/NiWkw1QhbWoSC76lvpRJO85yR1YYUoM8K0PUEEVDfdHCt5Xh5+Z62C0TyqGwoa3
         Kl6x0QRManO+Sr8UD1rmpXcu3XZCGjasxGk4vFGQhTy+eyxoVivhDD3Il3KlKxesdAkB
         oiYo/qPyQbUiWcIhKsHPz5SaCTF4vJ/T5yhCZN4PMabs5RqCvZQ3/+4jTOO0utz8iYNy
         uAu0aJJMD/FB5gl/tpANKfUxV5H038qG6A4PvS9VJQL7SM0ISrucBiWsGB1FWZZXd3WU
         JpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JzME2Q7VkDOLpF4JQ1hrZ8wE56oxQKxVDaqorxZec4=;
        b=tmGVf/yPH9CazkVD/lR1Vu95GsZKxDZP6HviRJDIwf05iXBLLzdCOZIPwOw/ubLWLA
         N4DhT2RESFKLGEsw+eGZRUyIXzTcHHmYlheGi4uoS4JUceVAzQ0ZxOtzskSD7U1EXM7b
         b4KY8n8HxDd58cA078fdHoIukd27ZV/QDfF8Vbj7GPb8CcYRyG1NAw77uRmFL6JD/YBR
         JHjZkladT+ZFWjG5cfTzESctRlkeSbUX2IxlgLvAxIa5xo/E1qvwB3gE3mx/5ThlSj3k
         /uVh+eQo7N/TmhsRfwGxjt6b37sMwu31RdctPAMtWidvwQFsr5tjSlZcmTiljm1hpOqk
         ZsYQ==
X-Gm-Message-State: AFqh2kq9E5sL9kPOU+ScwdrrMcgeFGBcGfdFAeF+ZECm1cvc2+cntLys
        y68R9KfheBZ1lCuWJCjU8xOW+g==
X-Google-Smtp-Source: AMrXdXsXVxW/01n3h+E2f9J/8ROdWh0C/1GMn7rucUmuEKAICjP1E8iSz2ZwlIZXBUvfBPu9fIxzBQ==
X-Received: by 2002:adf:cd0a:0:b0:242:1f46:fb8c with SMTP id w10-20020adfcd0a000000b002421f46fb8cmr13026896wrm.41.1674229241174;
        Fri, 20 Jan 2023 07:40:41 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n13-20020a5d67cd000000b002bdcce37d31sm26169619wrw.99.2023.01.20.07.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 07:40:40 -0800 (PST)
Message-ID: <0428a83b-e457-d0bb-10d0-b856d61ba7ae@arista.com>
Date:   Fri, 20 Jan 2023 15:40:39 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] xfrm/compat: prevent potential spectre v1 gadget in
 xfrm_xlate32_attr()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230120130249.3507411-1-edumazet@google.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20230120130249.3507411-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/23 13:02, Eric Dumazet wrote:
>   int type = nla_type(nla);
> 
>   if (type > XFRMA_MAX) {
>             return -EOPNOTSUPP;
>   }
> 
> @type is then used as an array index and can be used
> as a Spectre v1 gadget.
> 
>   if (nla_len(nla) < compat_policy[type].len) {
> 
> array_index_nospec() can be used to prevent leaking
> content of kernel memory to malicious users.
> 
> Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Dmitry Safonov <dima@arista.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>

Reviewed-by: Dmitry Safonov <dima@arista.com>

Thanks, Eric!

> ---
>  net/xfrm/xfrm_compat.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
> index a0f62fa02e06e0aa97901aaf226dc84895f6a8ec..46bb239e4f06d56abbf3deecd89ac26625efb560 100644
> --- a/net/xfrm/xfrm_compat.c
> +++ b/net/xfrm/xfrm_compat.c
> @@ -5,6 +5,7 @@
>   * Based on code and translator idea by: Florian Westphal <fw@strlen.de>
>   */
>  #include <linux/compat.h>
> +#include <linux/nospec.h>
>  #include <linux/xfrm.h>
>  #include <net/xfrm.h>
>  
> @@ -437,6 +438,7 @@ static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
>  		NL_SET_ERR_MSG(extack, "Bad attribute");
>  		return -EOPNOTSUPP;
>  	}
> +	type = array_index_nospec(type, XFRMA_MAX + 1);
>  	if (nla_len(nla) < compat_policy[type].len) {
>  		NL_SET_ERR_MSG(extack, "Attribute bad length");
>  		return -EOPNOTSUPP;

-- 
          Dmitry

