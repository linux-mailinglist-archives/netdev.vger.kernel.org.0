Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E41445DA4
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhKEB4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhKEB4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:56:13 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BA9C061714;
        Thu,  4 Nov 2021 18:53:34 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso5539050wmf.0;
        Thu, 04 Nov 2021 18:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4CjTDS7XmZyHu4AFPq6nvsk3QBZ5u4iMo3sZwE0ixCE=;
        b=RXbeI0akSQ8QNRTOzIPZwzNA3RzCzV8CH6572hS18+y2nYefY8Jembn+jF/MwXWf70
         L3qXsDMV4okYcLPInHULpM7J3GVfkVQWth5BposOZR85q3HbOzK2+oWaE9IY+eKvW9M/
         U55DTjKH/pK49w9c67aoaYzAPStCeqPF7Aas65Y5MVNUDHPSSVFMGsQxTSo0JWwNwcVl
         I1F7L59/Uoj16wVWa95xMH00Qy5IS83AXXEjHU69vn21lfWpqACtxEssySgpI/REfixs
         Tecy+kihmrPwDM9p0Hk5kNqTBqkR1/KH34L91pyccObZ+SUdmLNqgRDu1lgQQjo/6cZt
         wZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4CjTDS7XmZyHu4AFPq6nvsk3QBZ5u4iMo3sZwE0ixCE=;
        b=KomNRKJDJr1z2z7u1NypBWenIn7gDFTl47h7vuS+BQCG0FBzOWwo948tDKFo+WXp/z
         xyZydQc4vKASSvO5qDqzUibZ1gWLZheaq+odDh8xk6Vxt+jI/NM6zx8lInZ3O3zGlnnQ
         E3kkPPncT/DIB404yJS3NPqFYXw+f0m8TfHad2C2x3agKHnx9YHIGVU5tccEqN6oLFkR
         YivyOX+61Dg37dlYNB3IiGiffh0MW0/lHbdKGPW+zl/NxlbdyOlWyOknUlad9BsPcTHh
         OX1kH0bccd+FUl2YOll1CMIt/aLf+wsbL4pE3EkhFPwG7tgeBxmOcJBZp5GaXgic+UoF
         q24A==
X-Gm-Message-State: AOAM5322hH6dk+pVJwDuO8t7kys0hKz1bx/i3qP7v/4Jy5lLl0TIIgLW
        +Kx5rUEmWQEIJEW+AxvSAXs41vkNiXA=
X-Google-Smtp-Source: ABdhPJzkW9MTe8BMo/2EXnUg2dY52F+rvoMgo3Ysf2L/Zw9bY2C0wiWQ2UyYAhOresKNm9h9FMR1JQ==
X-Received: by 2002:a05:600c:a45:: with SMTP id c5mr27123377wmq.79.1636077213048;
        Thu, 04 Nov 2021 18:53:33 -0700 (PDT)
Received: from ?IPV6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id q4sm6597595wrs.56.2021.11.04.18.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 18:53:32 -0700 (PDT)
Message-ID: <816d5018-6cc5-78c4-4c13-f92927ad23f7@gmail.com>
Date:   Fri, 5 Nov 2021 01:53:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 06/25] tcp: authopt: Compute packet signatures
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <5245f35901015acc6a41d1da92deb96f3e593b7c.1635784253.git.cdleonard@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <5245f35901015acc6a41d1da92deb96f3e593b7c.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 16:34, Leonard Crestez wrote:
[..]
> +static int skb_shash_frags(struct shash_desc *desc,
> +			   struct sk_buff *skb)
> +{
> +	struct sk_buff *frag_iter;
> +	int err, i;
> +
> +	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
> +		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
> +		u32 p_off, p_len, copied;
> +		struct page *p;
> +		u8 *vaddr;
> +
> +		skb_frag_foreach_page(f, skb_frag_off(f), skb_frag_size(f),
> +				      p, p_off, p_len, copied) {
> +			vaddr = kmap_atomic(p);
> +			err = crypto_shash_update(desc, vaddr + p_off, p_len);
> +			kunmap_atomic(vaddr);
> +			if (err)
> +				return err;
> +		}
> +	}
> +
> +	skb_walk_frags(skb, frag_iter) {
> +		err = skb_shash_frags(desc, frag_iter);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}

This seems quite sub-optimal: IIUC, shash should only be used for small
amount of hashing. That's why tcp-md5 uses ahash with scatterlists.
Which drives me to the question: why not reuse tcp_md5sig_pool code?

And it seems that you can avoid TCP_AUTHOPT_ALG_* enum and just supply
to crypto the string from socket option (like xfrm does).

Here is my idea:
https://lore.kernel.org/all/20211105014953.972946-6-dima@arista.com/T/#u

Thanks,
          Dmitry
