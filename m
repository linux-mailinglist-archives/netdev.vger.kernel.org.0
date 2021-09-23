Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE07415996
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 09:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbhIWHvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 03:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhIWHv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 03:51:29 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFE3C061756;
        Thu, 23 Sep 2021 00:49:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id dj4so20424671edb.5;
        Thu, 23 Sep 2021 00:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RlhgwksuUm7dWwJH3Rb88cQWw5W+Xn4yAyWyU7jvE54=;
        b=Ay9Rh+fTliF5ZQIByyU7Xrsxhp97ULNyfO7KxfkxXaUVD+uWWDRwCHid+EAA6mqs80
         RodYmRCKORkwtceQ0Kx78YzgCarMJ/QWcsHNVhD2dy+gnskgpdeaQY+oq5b69bWibzmB
         ziJ2hJ30te8zg3xkwOnm4hx8XNdmVAj6dnCO6bu8GhZA1XkvaqXuSE+tzqABWtsHo0ql
         DlOaxG3Uj98xdj6TMg+mIaqHIlAEZj88FVGptt3xQhsrVVa8rX3J+FHyOM+x7DjL5JiX
         WIKyppKzGchh70uUYamHDrJ7o6ygvUww4cXLnDVz9+233rrqTQVwpD52p8LKH3lfCj6G
         1YFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RlhgwksuUm7dWwJH3Rb88cQWw5W+Xn4yAyWyU7jvE54=;
        b=rd1tABzpjprG5plYijtQqSeT+2tHoiZAip1LSRouF4vu4z3HgyG0bIJZeg+PvgBW8e
         LP95IPiWeS34Zb9tEk1l36o3PHuxeVYk8HffKv1DLYHdF2iaLs7WETMgEUH0towMIpfQ
         K2WSuLD26ab2cBNp8jhx+F+h3ddeJexqzUFFG9J/uGo8tN6ci0yAt6VtMTZH9hVknWpX
         JFcDv/uZmk+Y4krCoC1/hEcyg+Jk8twY1AYaY5Y6oa8lWCUEYx0inhlysTzdk3bk919Q
         366vVYS6kp8bvj/2xfnrjvytCd8GOZWwa52KmAHMzmaCp+7goNqfPkKk0xz2QIik9BMi
         27pQ==
X-Gm-Message-State: AOAM532/vU7y2PgWY/a6/SrbuN1lYeyDicrZT4EnMDsRt1DvHAafj86a
        EDM3MvPsOcXJGGKxwvIC/JdoeI6WucW0Oazum7Y=
X-Google-Smtp-Source: ABdhPJxUZ2jSYNqD84zt5ylPGbyACX428FxSv/I4bXsNdNQVXXiV619+aQfuFev5Cjp/yLOmFOCumQ==
X-Received: by 2002:a17:906:4fd6:: with SMTP id i22mr3507629ejw.92.1632383396175;
        Thu, 23 Sep 2021 00:49:56 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:3080:ac6c:f9d1:39b4? ([2a04:241e:501:3870:3080:ac6c:f9d1:39b4])
        by smtp.gmail.com with ESMTPSA id jl12sm2433435ejc.120.2021.09.23.00.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 00:49:55 -0700 (PDT)
Subject: Re: [PATCH 00/19] tcp: Initial support for RFC5925 auth option
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1632240523.git.cdleonard@gmail.com>
 <20210921161327.10b29c88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <f84a32c9-ee7e-6e72-ccb2-69ac0210dc34@gmail.com>
Date:   Thu, 23 Sep 2021 10:49:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210921161327.10b29c88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 2:13 AM, Jakub Kicinski wrote:
> On Tue, 21 Sep 2021 19:14:43 +0300 Leonard Crestez wrote:
>> This is similar to TCP MD5 in functionality but it's sufficiently
>> different that wire formats are incompatible. Compared to TCP-MD5 more
>> algorithms are supported and multiple keys can be used on the same
>> connection but there is still no negotiation mechanism.
> 
> Hopefully there will be some feedback / discussion, but even if
> everyone acks this you'll need to fix all the transient build
> failures, and kdoc warnings added - and repost.
> git rebase --exec='make' and scripts/kernel-doc are your allies.

Hello,

I already went through several round of testing with git rebase 
--exec='$test' but it seems I introduced a few new failures after 
several rounds of squashing fixes. I'll need to check kernel-doc 
comments for source files not referenced in documenation.

Many of the patch splits were artificially created in order to ease 
review, for example "signing packets" doesn't do anything without also 
"hooking in the tcp stack". Some static functions will trigger warnings 
because they're unused until the next patch, not clear what the 
preferred solution would be here. I could remove the "static" marker 
until the next patch or reverse the order and have the initial "tcp 
integration" patches call crypto code that just returns an error and 
fills-in a signature of zeros.

A large amount of the code is just selftests and much of it is not 
completely specific to TCP-AO. Maybe I could try to repost the parts 
that verify handling of timewait corners and resets in a variant that 
only handles "md5" and "unsigned"?

I already tried posting my scapy implementation of TCP-AO and MD5 to 
scapy upstream because it is not specific to linux .

--
Regards,
Leonard
