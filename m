Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FB4417F1B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 03:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346930AbhIYB66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 21:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhIYB64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 21:58:56 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4590C061571;
        Fri, 24 Sep 2021 18:57:22 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so15648675otq.7;
        Fri, 24 Sep 2021 18:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3oB2P8meLlVrfmIZtbndjTCD4KmuRTjJ2hmbKASMUB4=;
        b=IrZ6ZJ8b4KRP8xmtLbLY46XPCf+70+su1EP90eoGPivamJ3Trkj1Q7ybYOyYta49Z4
         15aup9LXk+auWBKHbDsbGEhNZIJ2Zbmv6F3qqsDpny+8Cq/n/XuZ1IpnWv9Xvors1GOh
         KwMn3awb5zk73nClanSTy1iPo2WSk+hDkPkLFuDF+ZZHKYfFYuokOLcwXUzlR+Lw7iMr
         O5L8NZ1Kxyzh4w2k/80AgfWIx2mmgyX2WZfM7NvCn+s0fs31GV6bOe7taerIMY9yv/uD
         +FeGOA7/EQJ2h+yOtJefjtFxZkgvofccPF+1GhuDbGhepZ8NOYy9ROou4FszVRrNzPYi
         wAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3oB2P8meLlVrfmIZtbndjTCD4KmuRTjJ2hmbKASMUB4=;
        b=mNqgaqcignJ8OhkFC5/x3L+OB8DNlvhSF+EgG9DSeQ/1quktJ1WpJnv+i7Pc3uJ3Ct
         KIRtiYhxwEq2DUnv5SnfM6joKJ6x9H5wJW7b3gamroKBhyL1IuHhSg+DeZcSWXONvP1D
         W6Rw1CdkWyRUKBNKviCZb9KQkcLWhY8VC5n6WF11m1hZq/0L7wfNB2VPscSZ4P2isqaA
         BQQTe51n09LboQczU5bECcw+cFYiSSyh7AO15yGxOE34o+amyyiVWXyKTiK8Yrp/Kt6A
         tm0n876mghLuZD2UFYgKtizFqeZjBiROVIUG/RN6D1CgrtqKa6n0tF6cZG7mY0RZdFM4
         Ckrw==
X-Gm-Message-State: AOAM5314B1aOjtdWCU3zZu5EfXshrwSFGGWPQFblgJZJmPJDvZFiEg7I
        B+XYCF8oyEm4mqQjwWHErz9fSq86btT5aQ==
X-Google-Smtp-Source: ABdhPJzw5hs8Plmcg4aKEYpIFApUbHYCJtvJA92CU50L7sFHWekBiFKdIJL4kbqfIBfm2rmUhfcUkw==
X-Received: by 2002:a9d:7cd3:: with SMTP id r19mr1316974otn.214.1632535041879;
        Fri, 24 Sep 2021 18:57:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id b4sm1449396ooi.17.2021.09.24.18.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 18:57:21 -0700 (PDT)
Subject: Re: [PATCH 08/19] tcp: authopt: Disable via sysctl by default
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
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
 <b0abf2b789220708011a862a892c37b0fd76dc25.1632240523.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cafecbeb-7d4d-489c-177d-29fff78eb4d1@gmail.com>
Date:   Fri, 24 Sep 2021 19:57:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <b0abf2b789220708011a862a892c37b0fd76dc25.1632240523.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/21 10:14 AM, Leonard Crestez wrote:
> This is mainly intended to protect against local privilege escalations
> through a rarely used feature so it is deliberately not namespaced.
> 
> Enforcement is only at the setsockopt level, this should be enough to
> ensure that the tcp_authopt_needed static key never turns on.
> 
> No effort is made to handle disabling when the feature is already in
> use.
> 

MD5 does not require a sysctl to use it, so why should this auth mechanism?
