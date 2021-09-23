Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC0E415932
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 09:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbhIWHka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 03:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhIWHkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 03:40:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28650C061574;
        Thu, 23 Sep 2021 00:38:54 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v24so20227912eda.3;
        Thu, 23 Sep 2021 00:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rDC5PC+a0NllCEpjH7mFGoqlO3Pfx2bUG7RA79+/FLw=;
        b=m2i5+hexQJVilRRhFLWcncgCHBgJvNoFBnXpbuM/mncHeX51TWSF/F20729JVlNEAr
         V45pr+tYK7IZgHHi+4F4GMl7Nh00Mykgj3ISPyGlYXNGXBKpt+h1vijAdTTCMasQof7P
         /gGA1pil25WjMTbu1BMpnuaP97S9KCmKTPWFwS1k3Pq5o35W+i0VX4boNMmSntdeTBzH
         6Ksjt3e2OPnWpVLsVXIqM5k8BUzRuBk5lM81TBtrv45bg81NbpVdA1qEi6BkHcRrny0N
         br1t93AYgltzYlPTgbAe8uPUbwdVJYCxA4qwdMb3eUCGbsrZgVz3aI80bB8Rhpggi73A
         8/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rDC5PC+a0NllCEpjH7mFGoqlO3Pfx2bUG7RA79+/FLw=;
        b=vVfnRsZqQLGZP84N5Ffnm+cXKXXKxej9EIMz5PRuGTOYG1LikLIayL8RtaID5bJedV
         olTt0Jy+QYc6m44LXohBX4Kfa/k7wp/+QzapI/BMqz7AqU3yEmPETGxUM0GzrfkAlLNI
         v6k2+EmaMPYhPmFaw6IftRp42606u8w4fmNVa7/2mySqQT6enuHJbQLLYbLWLkvEzl8O
         0BaWBAFcW39isS396CtKIbjo8RvDg5ArwbnkSo2JcuDQeTbT2lsWfu1B7QtHoL1PtWui
         gx3l3XqHhmQhWDrqGq48a5bbgwmEKDYt68onR4Z/+pv18tVyqlBKejO3r+LVkAA0P6RF
         5bYQ==
X-Gm-Message-State: AOAM530qZSdvD9TrHhxq7an69osZ+qR8HUpERbCGgDT6NzPz96xMmuog
        yEy9buhnZAYMAvbnXP23IpT0m/mfsmA9snudfqg=
X-Google-Smtp-Source: ABdhPJyjzgHJDh+Fs64RdNZbvuzzH3I7YTJrBgLlFYJ+90fM3o+BJpkdJnZ7Olj0kmds1AjaloWBuA==
X-Received: by 2002:a17:906:9401:: with SMTP id q1mr3493373ejx.313.1632382732580;
        Thu, 23 Sep 2021 00:38:52 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:3080:ac6c:f9d1:39b4? ([2a04:241e:501:3870:3080:ac6c:f9d1:39b4])
        by smtp.gmail.com with ESMTPSA id b14sm2817949edy.56.2021.09.23.00.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 00:38:52 -0700 (PDT)
Subject: Re: [PATCH 00/19] tcp: Initial support for RFC5925 auth option
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1632240523.git.cdleonard@gmail.com>
 <CA+HUmGjQWwDJSYRJPix3xBw8yMwqLcgYO7hBWxXT9eYmJttKgQ@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <6505b7d2-7792-429d-42a6-d41711de0dc1@gmail.com>
Date:   Thu, 23 Sep 2021 10:38:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CA+HUmGjQWwDJSYRJPix3xBw8yMwqLcgYO7hBWxXT9eYmJttKgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 11:23 PM, Francesco Ruggeri wrote:
> On Tue, Sep 21, 2021 at 9:15 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>> * Sequence Number Extension not implemented so connections will flap
>> every ~4G of traffic.
> 
> Could you expand on this?
> What exactly do you mean by flap? Will the connection be terminated?
> I assume that depending on the initial sequence numbers the first flaps
> may occur well before 4G.
> Do you use a SNE of 0 in the hash computation, or do you just not include
> the SNE in it?

SNE is hardcoded to zero, with the logical consequence of incorrect 
signatures on sequence number wrapping. The SNE has to be included 
because otherwise all signatures would be invalid.

You are correct that this can break much sooner than 4G of traffic, but 
still in the GB range on average. I didn't test the exact behavior (not 
clear how) but if signatures don't validate the connection will likely 
timeout.

My plan is to use TCP_REPAIR to control sequence numbers and test this 
reliably in an isolated environment (not interop with a cisco VM or 
similar). I want to implement TCP_REPAIR support for TCP-AO anyway.

It was skipped because the patch series is already quite large.

--
Regards,
Leonard
