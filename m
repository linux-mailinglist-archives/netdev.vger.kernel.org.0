Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39484182AE
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 16:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245756AbhIYO1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbhIYO1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 10:27:13 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED1BC061570;
        Sat, 25 Sep 2021 07:25:38 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dj4so48165112edb.5;
        Sat, 25 Sep 2021 07:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lU4nVuw7o1r/PfKx8aQqaO6GC4TAE1elqJfGU2aTcGE=;
        b=Rmz2N0jm9/QxLpL2Oly7zCwxsgUgF04PXqkaYqMYe4BWHzH/XSDT5odLQlD/wQjjY7
         1+2RHyHnxaPbM7EU/Qb2NjQiKFE4zFtcAdMpRZEWwgx0qKSnmaFteYJzOlPE3WB7r2Vu
         PB/4egz7LywiX1DqFuTjjJLKHSQ9tVw7/eYKu6ANN5AkzfGjELD2poBwDTn+G/YlMcfK
         denO4SP4AR1m54DRpUiIz3aUJ3bj0rI2yOC0Gf4xggvGGe+2738jv9awsRArP9509nSh
         N/v5dfIqyiEKFF2WFI13owtaNLrgCLLpU6mmN0jNoq15KWJBnZDxKLoEdovnF8cgF1IH
         juiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lU4nVuw7o1r/PfKx8aQqaO6GC4TAE1elqJfGU2aTcGE=;
        b=ZuwI44BvDjiN3q57q7ylF7CIT5lrCRuSzcCIH/WBcJxST0s0uRDQbbXMxljXmsqUAc
         B3lu1NGNibPsRoef1grdu8+O57u17TiHe9luezXhs2Jj8tICBTDOC6ChmmmwQokxnodZ
         9eMrkHXQDuvyFzgq1BI1arkbA1t5k49SPO/6oCQFvjyRB5/k7NOkZOSesgdMnu5y8EjB
         RtcGGH1QHw6PdeEW93F43WpCl4H7jWdeG42x+8sZctvq5jRz2V5S7dstnIVQnlQJ/muL
         99c3oQ7yeeX/FgyvpVhpe6DWilZ7W1Zp3E0pV2z0WZGdNZNmtMTLkb07+Kqpxh42DrqF
         oRXg==
X-Gm-Message-State: AOAM533bymODMa65tUIAeuH/Hdmtp12kEix57xFdXRA7kliCi6dKOl7B
        1Bw7JmVp4WxqfAntdwOXsARZglXE8crWJnc/CsM=
X-Google-Smtp-Source: ABdhPJwRlM2aM6JJl+ufi6fYnlTvRj+JsiiDXQCeD/sOpio9OLevqAIj0qP4GFgcWYgr9jeHaWxN6w==
X-Received: by 2002:a17:906:6b93:: with SMTP id l19mr17569763ejr.26.1632579937355;
        Sat, 25 Sep 2021 07:25:37 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:55c:dc9d:9cc1:2c16? ([2a04:241e:501:3800:55c:dc9d:9cc1:2c16])
        by smtp.gmail.com with ESMTPSA id u19sm7603020edv.40.2021.09.25.07.25.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 07:25:36 -0700 (PDT)
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1632240523.git.cdleonard@gmail.com>
 <20210921161327.10b29c88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f84a32c9-ee7e-6e72-ccb2-69ac0210dc34@gmail.com>
 <20210923065803.744485ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <f8e1d59f-5473-df7c-ee23-4c0a7a4d6f11@gmail.com>
Date:   Sat, 25 Sep 2021 17:25:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923065803.744485ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/21 4:58 PM, Jakub Kicinski wrote:
> On Thu, 23 Sep 2021 10:49:53 +0300 Leonard Crestez wrote:
>> Many of the patch splits were artificially created in order to ease
>> review, for example "signing packets" doesn't do anything without also
>> "hooking in the tcp stack". Some static functions will trigger warnings
>> because they're unused until the next patch, not clear what the
>> preferred solution would be here. I could remove the "static" marker
>> until the next patch or reverse the order and have the initial "tcp
>> integration" patches call crypto code that just returns an error and
>> fills-in a signature of zeros.
> 
> Ease of review is important, so although discouraged transient warnings
> are acceptable if the code is much easier to read that way. The problem
> here was that the build was also broken, but looking at it again I
> think you're just missing exports, please make sure to build test with
> IPV6 compiled as a module:
> 
> ERROR: modpost: "tcp_authopt_hash" [net/ipv6/ipv6.ko] undefined!
> ERROR: modpost: "__tcp_authopt_select_key" [net/ipv6/ipv6.ko] undefined!

The kernel build robot sent me an email regarding IPv6=m last time, I 
fixed that issue but introduced another. I check for IPv6=m specifically 
but only did "make net/ipv4/ net/ipv6/" and missed the error.

I went through the series and solved checkpatch, kernel-doc and 
compilation issues in a more systematic fashion, I will repost later.

--
Regards,
Leonard
