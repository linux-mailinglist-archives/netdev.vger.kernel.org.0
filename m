Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534C21DEC99
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgEVP6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730197AbgEVP57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:57:59 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B92C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:57:59 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e11so4420639pfn.3
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SZFWHJ0Ak7OTSGza9XGTv0JJSA8sEZkbcXPiym7mWSA=;
        b=h9dYhglb7vlR84a2po9G6eFhv/kIw/eTHv5fiy8m7nlYXn9Gny87JthCs/yqvBV0E7
         mdzSWoYZPKBU/PRK1vRTPiKSeihs9i4UY7LAeuaBsbFpsFg7xti+Y9hhRaR490frlcz1
         4X4lOePxB/saM/QA6/xWd+f4LlTnNHc/B1SLUzkRAXnTikhHB6F8XzoYODRi7LBjIWQH
         iBMEgXmSfqY7xhyDbUHsdogXF0IFD6fK+LCn9xVKPy3JynefiyqWa0tPXE0J8dPBlEmt
         T5ePmaVjqvlPNQbjldreLQgCGTxDWKp0W2p/6zzQ6c/dMMwvFQ2+SzighWe21JfC4xdP
         xlxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SZFWHJ0Ak7OTSGza9XGTv0JJSA8sEZkbcXPiym7mWSA=;
        b=FUccU/1ynePSU8oicdkqxHd8C12kpzS+ub66eVJYdHuvh3XvRHcOIXyvi1EDOlcMD1
         7FcoQ1ef8IksMFgXkFdJa0cyivzQrajSOmGUSqtm3ik7NrNmJtJ/r13ljbGvfWUMgokb
         fI5TmXXK29+IpBOMJw3AUz8wru4fbD2Nged4jYXz16kjcz1Q+iTYatJdCrOfelbUcsOh
         Z9ffiiFEOQqNvzFFdjv4S+X9rGE9I3ZhKgBxqAaP5fmSWeArEQfOeaLxoGgEJXFMD6fD
         r8qHPrUMkWNpcwh64juZFUxOhXzcUM/S4K69mzORTXob8CTtbdddqnV3sOrxJ26D/Mlt
         BO8A==
X-Gm-Message-State: AOAM5337kaHWYZIxhwTk03AyLKaxWqb9nspw7GniZbM88xjovQxM74nd
        4+f3YuFtEQ4YUP4AjMd4jCQ=
X-Google-Smtp-Source: ABdhPJzlL0VUJyIbRDICBHOJQGEYYeOhykvYmdnGYGh02GzVWdP1Q40mzCm2Q5QP1Q6urwOsWkfWKA==
X-Received: by 2002:a63:e60b:: with SMTP id g11mr15060356pgh.120.1590163079170;
        Fri, 22 May 2020 08:57:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u69sm7493178pjb.40.2020.05.22.08.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 08:57:58 -0700 (PDT)
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Jon Maloy <jmaloy@redhat.com>, Xin Long <lucien.xin@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net
References: <20200521182958.163436-1-edumazet@google.com>
 <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
 <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com>
 <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
 <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
 <76d02a44-91dd-ded6-c3dc-f86685ae1436@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <217375c0-d49d-63b1-0628-9aaf7e4e42d0@gmail.com>
Date:   Fri, 22 May 2020 08:57:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <76d02a44-91dd-ded6-c3dc-f86685ae1436@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/20 8:01 AM, Jon Maloy wrote:
> 
> 
> On 5/22/20 2:18 AM, Xin Long wrote:
>> On Fri, May 22, 2020 at 1:55 PM Eric Dumazet <edumazet@google.com> wrote:
>>> Resend to the list in non HTML form
>>>
>>>
>>> On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>
>>>>
>>>> On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>>> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
>>>>>> dst_cache_get() documents it must be used with BH disabled.
>>>>> Interesting, I thought under rcu_read_lock() is enough, which calls
>>>>> preempt_disable().
>>>>
>>>> rcu_read_lock() does not disable BH, never.
>>>>
>>>> And rcu_read_lock() does not necessarily disable preemption.
>> Then I need to think again if it's really worth using dst_cache here.
>>
>> Also add tipc-discussion and Jon to CC list.
> The suggested solution will affect all bearers, not only UDP, so it is not a good.
> Is there anything preventing us from disabling preemtion inside the scope of the rcu lock?
> 
> ///jon
>

BH is disabled any way few nano seconds later, disabling it a bit earlier wont make any difference.

Also, if you intend to make dst_cache BH reentrant, you will have to make that for net-next, not net tree.

Please carefully read include/net/dst_cache.h

It is very clear about BH requirements.


