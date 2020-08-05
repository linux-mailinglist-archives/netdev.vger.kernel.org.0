Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF6F23D268
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgHEUMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgHEQZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:25:34 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB76BC001FD8;
        Wed,  5 Aug 2020 09:06:42 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ha11so4534981pjb.1;
        Wed, 05 Aug 2020 09:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=1RReklN1OPJpOK3bhmxMYu557e7Ck1zwMR174u24Gts=;
        b=miECZ0VUhnkDWKgpR7g4zVBeoskcQebacNidqzj4zB7QOgqCaml+GUsmNa9FOdOeXa
         nvDVpqdsf/zUQcwfZwxPkukiMwVFiTlnewicGAa1KL0xw75VyS7yxS3RTTZ76hr/DiQK
         YEmnTd/PAEbdI0OrqBnjML4YFSf7hhM2yMnB33QHozrOpufHKsFOAvLPWEPWfb8N8776
         24gEhh8zJA4F37xG1dOu0k01CSTA6tuq+3OkPy+MOOeL4OhfwF/S6JgMCCMMVbGu9MPj
         3ElUrHnp9TYTcdEwMkYCCdkBMziqYyLL4gieIbiuTmTygYlsvtfMVK6xau2GNQC7jyzX
         gnRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1RReklN1OPJpOK3bhmxMYu557e7Ck1zwMR174u24Gts=;
        b=e4NwZGpm6eTXDtzdKefv2sYfUE5YgcGigGntY+lovByA7ubVUj2diw6S3tL1hnScWK
         u+LrNfXgFhERQ2e/q5uMKzkNnEf8PZnOTxhgRmqpP2xcPnafev5BearUELyB0APEdnyn
         yVD8KwfLsjN4CQCzYUwXcPaMpsI2/Eh2CRe9uBdGwh2v/lF7+HZxYngitVMQGWe5czR9
         E488467zYGSWUX/rO33h2P6edeCdFAPmbJOJh6P9gAJp9xu3EJWdlsEow7dpXok77goY
         DVvxPAMgjPQ8nOAOME2RbA+GLRIBsjcAzfzS0J5fGUo16qfgYBu74WBkTgFiW81KIXWi
         UIGg==
X-Gm-Message-State: AOAM531FixRaGxeB4EI6kK7dKwW0gKqNnRGRjyHsPnB7hfTZ3G9l+hhp
        PHjv0IhW8bxbYB3D4jZkIh2mI3kCs4xEfw==
X-Google-Smtp-Source: ABdhPJxnNGdZknsTEHZjJqACTiGobhg9BdrTrfAiNjdJBgikBsQ5M1G1ExL3Y5UmBh/pYl0NBRzSnw==
X-Received: by 2002:a17:90a:25a9:: with SMTP id k38mr3985688pje.103.1596643602002;
        Wed, 05 Aug 2020 09:06:42 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id 22sm3855920pfh.157.2020.08.05.09.06.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 09:06:41 -0700 (PDT)
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
To:     tytso@mit.edu, Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu> <20200805153432.GE497249@mit.edu>
From:   Marc Plumb <lkml.mplumb@gmail.com>
Message-ID: <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
Date:   Wed, 5 Aug 2020 09:06:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805153432.GE497249@mit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ted,

On 2020-08-05 8:34 a.m., tytso@mit.edu wrote:
> On Wed, Aug 05, 2020 at 04:49:41AM +0200, Willy Tarreau wrote:
>> Not only was this obviously not the goal, but I'd be particularly
>> interested in seeing this reality demonstrated, considering that
>> the whole 128 bits of fast_pool together count as a single bit of
>> entropy, and that as such, even if you were able to figure the
>> value of the 32 bits leaked to net_rand_state, you'd still have to
>> guess the 96 other bits for each single entropy bit :-/
> Not only that, you'd have to figure out which 32-bits in the fast_pool
> actually had gotten leaked to the net_rand_state.

That's 2 bits which are already inputs to the fast_pool, so it doesn't 
even make a brute force any more difficult.

> I agree with Willy that I'd love to see an exploit since it would
> probably give a lot of insights.  Maybe at a Crypto rump session once
> it's safe to have those sorts of things again.  :-)

Just because you or I don't have a working exploit doesn't mean that 
someone else isn't more clever. It pays to be paranoid about 
cryptographic primitives and there is nothing more important than the 
entropy pool.

> So replacing LFSR-based PRnG with
> something stronger which didn't release any bits from the fast_pool
> would certainly be desireable, and I look forward to seeing what Willy
> has in mind.

Isn't get_random_u32 the function you wrote to do that? If this needs to 
be cryptographically secure, that's an existing option that's safe.

The fundamental question is: Why is this attack on net_rand_state 
problem? It's Working as Designed. Why is it a major enough problem to 
risk harming cryptographically important functions?

Do you remember how you resisted making dev/urandom fast for large reads 
for a long time to punish stupid uses of the interface? In this case 
anyone who is using net_rand_state assuming it is a CPRNG should stop 
doing that. Don't enable stupidity in the kernel.

This whole thing is making the fundamental mistake of all amateur 
cryptographers of trying to create your own cryptographic primitive. 
You're trying to invent a secure stream cipher. Either don't try to make 
net_rand_state secure, or use a known secure primitive.


Thanks,

Marc


