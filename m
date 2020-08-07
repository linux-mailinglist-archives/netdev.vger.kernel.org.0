Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9923D23F4F4
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 00:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgHGWpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 18:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGWpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 18:45:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA4C061756;
        Fri,  7 Aug 2020 15:45:51 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id r11so1868170pfl.11;
        Fri, 07 Aug 2020 15:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=poy8D0RfWokWADSAUCKOKwj0GQnJ+uEjQppJPHYlh0Y=;
        b=cmQe0s4vxu1wcB/YrapHdfd0fU1fJjfAuZkGaBh6Xk9tfnlIM8MZHXT9ZQ0RfPCmKM
         O+ZZ4V8HQjEC9iFk8IO4amCbFDaQuCnngqKWNxpdcu63oeYyLjUg81UR3Wa+ikWrz8/t
         58w+iRqjFSgqntbqMjnTW2KxLTZjUrcH2ZY70TeOd1qXtYtgyBK3iC994S5tNSKyWqHj
         HiFdSt7nsJwFx3xmIfNyP4Z3NqxHQSUQh7BzBObxTOCTwDqt0zq4OKXU8SEQNiJqIBIC
         azs+vkyAoKPoTNQI8KjOIJ2vekAaHdxc7ktPxougYt4nzYTAGoBluB2Q9uDLS9dJJvba
         R0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=poy8D0RfWokWADSAUCKOKwj0GQnJ+uEjQppJPHYlh0Y=;
        b=Cctg0oLJrSObtQWZGq45G57ZH3b8lHNBQX4i3QgWuX2akeMmc6CYtZOL7vFvVZC7a2
         i1bh11dXTVOZwIvo2VzQQ65T80IXNDs8ABznGHiKTXtG9yocKQhaSUv4oo8Q4s2K5+Nh
         eF3Emfhsp574WrjUEBSJh+3bDhqmzt2N/hOVekmeXl9TOZo04UJ44VTMOAHxm39jHp+B
         GoyyeU2p9SnTnAtPG729ggNp/bV8R9jb2j/EKPpK9uyn3h0ti3eDdKrpJukOqhBuEXJZ
         tH1oygYkxO5wYkc3xx6Ph9UrS8G3VTel29OsDQcVaHB4ZuR7fhrKaehVxpg4Qzuv6pOv
         V3gg==
X-Gm-Message-State: AOAM531iAV2FuIKZSIudlnO9RsVyQDrM1WU3gaVc+TTTP5RoUb6qYsqZ
        hFeqpX49J3BkbhFv8IDYsjUM8OqG9EM=
X-Google-Smtp-Source: ABdhPJwZi2ss/DOFDlFpB3RfUTfD9mdLcNcj5ZRrCZuxBbfd+Naw8QE29DNzrAokCRo/fOkyqC2F1Q==
X-Received: by 2002:a63:db57:: with SMTP id x23mr13341697pgi.178.1596840350496;
        Fri, 07 Aug 2020 15:45:50 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id k4sm12510494pjg.48.2020.08.07.15.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 15:45:49 -0700 (PDT)
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
To:     Willy Tarreau <w@1wt.eu>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
References: <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
 <20200805193824.GA17981@1wt.eu>
 <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
 <20200806063035.GC18515@1wt.eu>
 <50b046ee-d449-8e6c-1267-f4060b527c06@gmail.com>
 <20200807070316.GA6357@1wt.eu>
 <a1833e06-1ce5-9a2b-f518-92e7c6b47d4f@gmail.com>
 <20200807174302.GA6740@1wt.eu>
 <9148811b-64f9-a18c-ddeb-b1ff4b34890e@gmail.com>
 <20200807221913.GA6846@1wt.eu>
From:   Marc Plumb <lkml.mplumb@gmail.com>
Message-ID: <9ae4be33-fdeb-b882-d705-bccfacda1c4e@gmail.com>
Date:   Fri, 7 Aug 2020 15:45:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200807221913.GA6846@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willy,


On 2020-08-07 3:19 p.m., Willy Tarreau wrote:
> On Fri, Aug 07, 2020 at 12:59:48PM -0700, Marc Plumb wrote:
>>
>> If I can figure the state out once,
> Yes but how do you take that as granted ? This state doesn't appear
> without its noise counterpart,

Amit has shown attacks that can deduce the full internal state from 4-5 
packets with a weak PRNG. If the noise is added less often than that, an 
attacker can figure out the entire state at which point the partial 
reseeding doesn't help. If the noise is added more often than that, and 
it's raw timing events, then it's only adding a few bits of entropy so 
its easy to guess (and it weakens dev/random). If the noise is added 
more often, and it's from the output of a CPRNG, then we have all the 
performance/latency problems from the CPRNG itself, so we might as well 
use it directly.

>> I think it might be possible to do a decent CPRNG (that's at
>> least had some cryptanalys of it) with ~20 instructions per word, but if
>> that's not fast enough then I'll think about other options.
> I think that around 20 instructions for a hash would definitely be nice
> (but please be aware that we're speaking about RISC-like instructions,
> not SIMD instructions). And also please be careful not to count only
> with amortized performance that's only good to show nice openssl
> benchmarks, because if that's 1280 instructions for 256 bits that
> result in 20 instructions per 32-bit word, it's not the same anymore
> at all!

Understood.

Marc
