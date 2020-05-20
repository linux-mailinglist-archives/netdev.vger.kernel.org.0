Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B21DBB62
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgETR1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETR1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:27:05 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E735DC061A0E;
        Wed, 20 May 2020 10:27:04 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 69so3147993otv.2;
        Wed, 20 May 2020 10:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TIdxtTnUgO6aZDU4rUzN+MxaoaGI5auvg4NGS+KtfVI=;
        b=H1TfS203qLstiBad7w4w4x5s/NZRO6u1JiyLu6YTE5qpP3qWrcid4Knf9zmmybv67z
         JIgyUx7wZwQb9hW3+I82kYkyomvAHSD3eMm+XcsZBIM2ZlTBCtBSuDqKiD03PvFWPCvX
         3nKH3vQAvEBFeulhswTQQ/lXhodlUQ/iEjLJoz4ZP+09e5SaFHUgKTPtxaSSFuTMYtWu
         gAiSFoVLUjeENMZDu4NTSntgRE/yDbcOluB4VkegHbzH1cgMsX22yjK/tdSw3TK+vzMP
         nX52zDSWdUuqzjaSfFU/QG57NwWn+Z1qXSJE7FT+CqCpXAWHKuClrSrLYd1bJe4UMONp
         /zAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TIdxtTnUgO6aZDU4rUzN+MxaoaGI5auvg4NGS+KtfVI=;
        b=iJDHdZn8IJmZH04ROj2fNy/zlNk4HS+J39NXCt/QcIMFuwYJgcsMEJe85dO0G+xf5B
         vEFuErrWJ5jEzxLsaAY1MvOnDRJJ83gz71uPMJxs0Zzcv6OjsP4dK2BZHne8qDmqwhYS
         YRV810DJIBYQTX9xfjMW5vj3rcnjE4cK0xLiVAArA4rE7E23xSg8B/7kFqRWk0WQ1KDO
         D4wF3euTPGJjwTLFztRozhwjNd3QhQYwITEAzQ4I3dWuXMOzqYFMjkSqd+exdJiPNtFQ
         7NrJtCBF/Fj2lghV7R/nq4shfyrTNH/Ffd5M/Plokd5dCmmilWVvt387ETf2KjSzKlb9
         +ujg==
X-Gm-Message-State: AOAM532CmnOARg2Nb+1ShYpi+AlBMepgZpScW0biPko7tMmvDiyqjyAv
        Iv6BTX6QfIz3X3tfUUir7zJCELvF
X-Google-Smtp-Source: ABdhPJx/7ljZX61LteZoqy3vrhiksvJT31pn9ZLt+0CrEEZoZNVjYhdFCa3ImExjuCRFXA7B4T+MZQ==
X-Received: by 2002:a9d:2927:: with SMTP id d36mr4145661otb.317.1589995624055;
        Wed, 20 May 2020 10:27:04 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d5aa:9958:3110:547b? ([2601:282:803:7700:d5aa:9958:3110:547b])
        by smtp.googlemail.com with ESMTPSA id t24sm875948otp.69.2020.05.20.10.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 10:27:03 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6/route: inherit max_sizes from current netns
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200520145806.3746944-1-christian.brauner@ubuntu.com>
 <4b22a3bc-9dae-3f49-6748-ec45deb09a01@gmail.com>
 <20200520172417.4m7pyalpftdd2xrm@wittgenstein>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd09bef6-61c4-5217-4448-e58cd39dbad9@gmail.com>
Date:   Wed, 20 May 2020 11:27:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520172417.4m7pyalpftdd2xrm@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/20 11:24 AM, Christian Brauner wrote:
> On Wed, May 20, 2020 at 10:54:21AM -0600, David Ahern wrote:
>> On 5/20/20 8:58 AM, Christian Brauner wrote:
>>> During NorthSec (cf. [1]) a very large number of unprivileged
>>> containers and nested containers are run during the competition to
>>> provide a safe environment for the various teams during the event. Every
>>> year a range of feature requests or bug reports come out of this and
>>> this year's no different.
>>> One of the containers was running a simple VPN server. There were about
>>> 1.5k users connected to this VPN over ipv6 and the container was setup
>>> with about 100 custom routing tables when it hit the max_sizes routing
>>> limit. After this no new connections could be established anymore,
>>> pinging didn't work anymore; you get the idea.
>>>
>>
>> should have been addressed by:
>>
>> commit d8882935fcae28bceb5f6f56f09cded8d36d85e6
>> Author: Eric Dumazet <edumazet@google.com>
>> Date:   Fri May 8 07:34:14 2020 -0700
>>     ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
>>     We currently have to adjust ipv6 route gc_thresh/max_size depending
>>     on number of cpus on a server, this makes very little sense.
>>
>>
>> Did your tests include this patch?
> 
> No, it's also pretty hard to trigger. The conference was pretty good for
> this.
> I tested on top of rc6. I'm probably missing the big picture here, could
> you briefy explain how this commit fixes the problem we ran into?
> 

ipv6 still has limits on the number of dst_entry's that can be created.
Eric traced the overflow to per-cpu caches in each FIB entry.

Larger systems (lots of cpus) x lots of unique connections = overflow

Eric's change removes the per-cpu dst caches from the counting, so only
exceptions (mtu, redirect) are now counted towards the limit.
