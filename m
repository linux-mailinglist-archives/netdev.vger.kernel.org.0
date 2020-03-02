Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF71752D9
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 05:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgCBEtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 23:49:52 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35912 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgCBEtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 23:49:52 -0500
Received: by mail-pl1-f194.google.com with SMTP id g12so1676134plo.3
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 20:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jSD0w3t8Weqs49SgXI+NsAuOE9TYKq0HlKF735rKl80=;
        b=mECeA5OQ0D+kh0kpQVZ2uGMWvDQNYiFBScuc0O4Aevil9vOqP3RYGvVkshBFe/7eXt
         wCm54Z84QPf8hINBD477cW2U7LihhP9bQrmd1jY6bNYJAQT4Sw6AYlhwdORkeHx6NVvM
         OxKt4OAJ2BCrIzp+zOEmkHMCvMBZ82fVPvB2z+GYsEjlatOXawerghU83DCrziZXJ300
         F5IyOKcy3N0XtLBmfVPSSEWAYZ/QF6qPLkjmcu2/dawBaOHSxwj5ZzfshNrmAMIc/rr6
         MCIomAph+F0c91H1FiVqCfHup40yC6Pw+SAer27k/4wUEVFmdiSB8a4QD6j0Inln9Qwz
         nbYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jSD0w3t8Weqs49SgXI+NsAuOE9TYKq0HlKF735rKl80=;
        b=HWLbxEJfH0RZlcApNqLVCk7ef34D4WXOyJQX73HtEgcZA4fQBEZkJSzY673B/GyHEL
         EduZGF3hRo6CnZoJKn+3uTLnyU/ng+11HaGqDsuvjmoFUFj71xmG/EvNezvz9DACYVre
         3ve0ViFf1bWTQUxGe2fmb/NSlpJjGxSv+9SHpy3TwRgSc3O0t//uCh4IyPJff659qAZn
         djHb2aJ3AopRlTnlzaSUtQVnsnp5RRhEjCdGNQF5ty2oa7kIefXflW3CjDVf6NpDJnoj
         yD+f1LxCZ27xtINME6G5xJ2pQTox0UK+CAr0U+jb+QNv92kxbDQ3zrvs+YmPoNpHj/Fj
         7kFg==
X-Gm-Message-State: ANhLgQ0KrjS/OghUxqV50qbUIRHgbhaE5xYyUUna3c0J6YItzAQp0Q6n
        pb4ERH4K3RzEZfFtG7zV+C8e9Jw0
X-Google-Smtp-Source: ADFU+vubFmZngJhn5Um129TalOxLCtuVFoy9XHRGYjvenjPc72t7dK4cRDCTTi8Inv4JuX9x6iJu8w==
X-Received: by 2002:a17:902:b590:: with SMTP id a16mr4948696pls.176.1583124591360;
        Sun, 01 Mar 2020 20:49:51 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x26sm19310333pfq.55.2020.03.01.20.49.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 20:49:50 -0800 (PST)
Subject: Re: [PATCH v3 net-next 2/4] tcp: bind(addr, 0) remove the
 SO_REUSEADDR restriction when ephemeral ports are exhausted.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, eric.dumazet@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuni1840@gmail.com,
        kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org,
        osa-contribution-log@amazon.com, yoshfuji@linux-ipv6.org
References: <0b9db623-0a69-30e6-1e28-b6acb306c360@gmail.com>
 <20200302043116.19101-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <74eacd0e-5519-3e39-50f3-1add05983ba3@gmail.com>
Date:   Sun, 1 Mar 2020 20:49:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302043116.19101-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 8:31 PM, Kuniyuki Iwashima wrote:
> From:   Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Sun, 1 Mar 2020 19:42:25 -0800
>> On 2/29/20 3:35 AM, Kuniyuki Iwashima wrote:
>>> Commit aacd9289af8b82f5fb01bcdd53d0e3406d1333c7 ("tcp: bind() use stronger
>>> condition for bind_conflict") introduced a restriction to forbid to bind
>>> SO_REUSEADDR enabled sockets to the same (addr, port) tuple in order to
>>> assign ports dispersedly so that we can connect to the same remote host.
>>>
>>> The change results in accelerating port depletion so that we fail to bind
>>> sockets to the same local port even if we want to connect to the different
>>> remote hosts.
>>>
>>> You can reproduce this issue by following instructions below.
>>>   1. # sysctl -w net.ipv4.ip_local_port_range="32768 32768"
>>>   2. set SO_REUSEADDR to two sockets.
>>>   3. bind two sockets to (address, 0) and the latter fails.
>>>
>>> Therefore, when ephemeral ports are exhausted, bind(addr, 0) should
>>> fallback to the legacy behaviour to enable the SO_REUSEADDR option and make
>>> it possible to connect to different remote (addr, port) tuples.
>>>
>>> This patch allows us to bind SO_REUSEADDR enabled sockets to the same
>>> (addr, port) only when all ephemeral ports are exhausted.
>>>
>>> The only notable thing is that if all sockets bound to the same port have
>>> both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
>>> ephemeral port and also do listen().
>>>
>>> Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")
>>>
>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>
>> I am unsure about this, since this could double the time taken by this
>> function, which is already very time consuming.
> 
> This patch doubles the time on choosing a port only when all ephemeral ports
> are exhausted, and this fallback behaviour can eventually decreases the time
> on waiting for ports to be released. We cannot know when the ports are
> released, so we may not be able to reuse ports without this patch. This
> patch gives more chace and raises the probability to succeed to bind().
> 
>> We added years ago IP_BIND_ADDRESS_NO_PORT socket option, so that the kernel
>> has more choices at connect() time (instead of bind()) time to choose a source port.
>>
>> This considerably lowers time taken to find an optimal source port, since
>> the kernel has full information (source address, destination address & port)
> 
> I also think this option is usefull, but it does not allow us to reuse
> ports that is reserved by bind(). This is because connect() can reuse ports
> only when their tb->fastresue and tb->fastreuseport is -1. So we still
> cannot fully utilize 4-tuples.

The thing is : We do not want to allow active connections to use a source port
that is used for passive connections.

Many supervisions use dump commands like "ss -t src :40000" to list all connections
for a 'server' listening on port 40000,
or use ethtool to direct all traffic for this port on a particular RSS queue.

Some firewall setups also would need to be changed, since suddenly the port could
be used by unrelated applications.

Note that sharing ports space has been a long standing problem, this is why
we use one netns per job, so that we no longer worry about applications being
hungry.

