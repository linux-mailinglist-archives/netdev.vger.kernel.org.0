Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27D131186
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfEaPpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:45:50 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38961 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfEaPpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:45:50 -0400
Received: by mail-pl1-f196.google.com with SMTP id g9so4167753plm.6
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 08:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OgvlI1t7LMlwtUr8X/GbuD8yoUbsEpVR4ujnMaN5/A0=;
        b=j8Eqrv2lC5tUa1rIZi4eYX08ZbAPCpIgNcOuZU3TnrP2gwZB84IFzjbq0foGRvnbYP
         nu/M8hOnARbGQrL7cxe4ms8rl89PJEfzmI29RGrdgUKKmPyyRb2XlAhdEbMl4nWEcF28
         aQ16fKa7+q35Xew3Ql3uJaSPzT0weDvZAvAh+6oHTL9tDpEXXUF0IKThuORrQrsEbbM2
         W9grDQATmXpoeNzWdrhXzqS1Ow1V1Epq3vB8EWKAQah6SwtkIu2l9FFHGhY2eAUU7Yk+
         5pc1S4+JoG9H7TQu6p9Of7Mr5lPvt9uGY87eUKsf/GATtUGpfU5O9w6xIBiWO7TCGaTw
         9eCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OgvlI1t7LMlwtUr8X/GbuD8yoUbsEpVR4ujnMaN5/A0=;
        b=Aj+3l8O0GPwvd76TdeEXCJzasq2QcHN0DTN7HMmR0PQtackR5YdLehDZChGYI9+AX1
         YjTMYCG6wRiODgl5t+Zcbsb8Bp8dowCH0vjmyvjBIw/kL1J03ONtS8IU6X0HHsSwbRrt
         riziZRO5LEueh/sjRsQI7rjThyuJ+5Galdi2s8W2tvjAQ4fVc1LXcovDnNZeAU2MJyNc
         IxSd7kvo/ZKJqmx4+ZqnM/A2IFM+7q0NDq7IfLAmUWZwbxQ4MzNYgeXZqSjyOhdevWfD
         ABVgXM3OVBS5JLnjJnN2a2r7hO9xKok/T7T1GxW3jBRsraW8UZ7PZ1m7P7NcaJ8iaefR
         Pwng==
X-Gm-Message-State: APjAAAVF82C0jeDRC+WExx9xmd4HcCA0yi4pg+JJRzTDtLkWVC5TrGI/
        ydC1CpYuCZ8RGXGWnxY7RjE=
X-Google-Smtp-Source: APXvYqyLM4tq8M8Y1YzcZJFuUEVtA4xYeu5gZAv32cck2G2r+BP/LR7iILnzq9+nXt7S2B/m3XSftg==
X-Received: by 2002:a17:902:3183:: with SMTP id x3mr10429508plb.321.1559317549929;
        Fri, 31 May 2019 08:45:49 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id j20sm6605255pfi.138.2019.05.31.08.45.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 08:45:48 -0700 (PDT)
Subject: Re: [PATCH] inet: frags: Remove unnecessary
 smp_store_release/READ_ONCE
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20190524160340.169521-12-edumazet@google.com>
 <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
 <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
 <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au>
 <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
 <20190531144549.uiyht5hcy7lfgoge@gondor.apana.org.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4e2f7f20-5b7f-131f-4d8b-09cfc6e087d4@gmail.com>
Date:   Fri, 31 May 2019 08:45:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531144549.uiyht5hcy7lfgoge@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/19 7:45 AM, Herbert Xu wrote:
> On Fri, May 31, 2019 at 10:24:08AM +0200, Dmitry Vyukov wrote:
>>
>> OK, let's call it barrier. But we need more than a barrier here then.
> 
> READ_ONCE/WRITE_ONCE is not some magical dust that you sprinkle
> around in your code to make it work without locks.  You need to
> understand exactly why you need them and why the code would be
> buggy if you don't use them.
> 
> In this case the code doesn't need them because an implicit
> barrier() (which is *stronger* than READ_ONCE/WRITE_ONCE) already
> exists in both places.
>

More over, adding READ_ONCE() while not really needed prevents some compiler
optimizations.

( Not in this particular case, since fqdir->dead is read exactly once, but we could
have had a loop )

I have already explained that the READ_ONCE() was a leftover of the first version
of the patch, that I refined later, adding correct (and slightly more complex) RCU
barriers and rules.

Dmitry, the self-documentation argument is perfectly good, but Herbert
put much nicer ad hoc comments.

