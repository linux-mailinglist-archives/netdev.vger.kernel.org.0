Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF0B1E199D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 04:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388478AbgEZCmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 22:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388428AbgEZCmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 22:42:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC261C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 19:42:48 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 124so3135877pgi.9
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 19:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jvKcXu0xh6OZnLyrlc66Tji5jLkwe6Qy9lvrfcbFuUQ=;
        b=GScjiVUp2XGE2ALu0EHy3teWy7+DZ7HKqcjcV1pEWEYWVTJCpqSzvOn5Ul/cJmdM0S
         Tt+9a7yv0J0tyUXfQDHPo/H1e3t/i9nxxhMkqghPSmKx3E9gnxxln9fYLs1IHSFNTpdz
         8g2y42fW2ShegLwLwm00w7t/CIfOK+ZL1xZV3+LtXKSoNm9he53SK0Ca379O0pmv1AqX
         h/lrZar8qsMZUpCcAb/6rcOfDZhT8lfUnn7HBNo/h/xAf+wxxujSZFVktkaB//n2Vk6m
         PJdATymEKCNCkhtptKGqvXyazBJE7fVrvqwy1AMXNZgn92wA0NHa5Ih0hu4q/ZTi0NGb
         A0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jvKcXu0xh6OZnLyrlc66Tji5jLkwe6Qy9lvrfcbFuUQ=;
        b=CD56QgnfEnR+DxeTW/fIzgFm5sx/c8i9i3Yzh6ojvQ0GoYYAq7zv9HAXxm3mhj47AT
         zoxZYGf0gSt2JH4SvsZCElrq03mRt1Y/aLtiDZ/aCTEVADlNBltsR22mgfduz6fHbfgv
         iVLvZMq/AtgAP70FnNfeIynRTy6sVkdRrx1uDlO1t94EoIHodDIc83VgCbFBK1TqoFyD
         xLy+cLVE4yM14+7qSDI+jYL9uzFX+c12lHq7BuBTAesRsD3za0+pVM4CDzCtMEtUYtcN
         e59gq+tntPniO5apKIXL081UEz6xkUbhhDCzLP7T5hYpjTXsxh6dArwzXAKza0vJxldw
         bQ6g==
X-Gm-Message-State: AOAM530iwX1jPDq7atet3rrTqJJCOqEEHKrhC7asNvt08Cj/Gl5FmeVE
        mHMFRBlfN92M4F1B6yCeM0zn8crJ
X-Google-Smtp-Source: ABdhPJzQgMpCKT2w/liXNptBCDLIsImwk8BrX5werYsc58+dbe65rddMDxUR5A1Mn0L0vDZgESV+uA==
X-Received: by 2002:a62:2707:: with SMTP id n7mr20696212pfn.209.1590460968254;
        Mon, 25 May 2020 19:42:48 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q28sm31538pfg.180.2020.05.25.19.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 19:42:47 -0700 (PDT)
Subject: Re: [PATCH net-next] tcp: allow traceroute -Mtcp for unpriv users
To:     David Miller <davem@davemloft.net>, edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, maze@google.com,
        willemb@google.com
References: <20200524180002.148619-1-edumazet@google.com>
 <20200525.175435.627428313116549298.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d0280b5f-dbf2-a7db-9137-2f795aa81819@gmail.com>
Date:   Mon, 25 May 2020 19:42:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200525.175435.627428313116549298.davem@davemloft.net>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/25/20 5:54 PM, David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Sun, 24 May 2020 11:00:02 -0700
> 
>> Unpriv users can use traceroute over plain UDP sockets, but not TCP ones.
>>
>> $ traceroute -Mtcp 8.8.8.8
>> You do not have enough privileges to use this traceroute method.
>>
>> $ traceroute -n -Mudp 8.8.8.8
>> traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
>>  1  192.168.86.1  3.631 ms  3.512 ms  3.405 ms
>>  2  10.1.10.1  4.183 ms  4.125 ms  4.072 ms
>>  3  96.120.88.125  20.621 ms  19.462 ms  20.553 ms
>>  4  96.110.177.65  24.271 ms  25.351 ms  25.250 ms
>>  5  69.139.199.197  44.492 ms  43.075 ms  44.346 ms
>>  6  68.86.143.93  27.969 ms  25.184 ms  25.092 ms
>>  7  96.112.146.18  25.323 ms 96.112.146.22  25.583 ms 96.112.146.26  24.502 ms
>>  8  72.14.239.204  24.405 ms 74.125.37.224  16.326 ms  17.194 ms
>>  9  209.85.251.9  18.154 ms 209.85.247.55  14.449 ms 209.85.251.9  26.296 ms^C
>>
>> We can easily support traceroute over TCP, by queueing an error message
>> into socket error queue.
>>
>> Note that applications need to set IP_RECVERR/IPV6_RECVERR option to
>> enable this feature, and that the error message is only queued
>> while in SYN_SNT state.
>>
>> socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
>> setsockopt(3, SOL_IPV6, IPV6_RECVERR, [1], 4) = 0
>> setsockopt(3, SOL_SOCKET, SO_TIMESTAMP_OLD, [1], 4) = 0
>> setsockopt(3, SOL_IPV6, IPV6_UNICAST_HOPS, [5], 4) = 0
>> connect(3, {sa_family=AF_INET6, sin6_port=htons(8787), sin6_flowinfo=htonl(0),
>>         inet_pton(AF_INET6, "2002:a05:6608:297::", &sin6_addr), sin6_scope_id=0}, 28) = -1 EHOSTUNREACH (No route to host)
>> recvmsg(3, {msg_name={sa_family=AF_INET6, sin6_port=htons(8787), sin6_flowinfo=htonl(0),
>>         inet_pton(AF_INET6, "2002:a05:6608:297::", &sin6_addr), sin6_scope_id=0},
>>         msg_namelen=1024->28, msg_iov=[{iov_base="`\r\337\320\0004\6\1&\7\370\260\200\231\16\27\0\0\0\0\0\0\0\0 \2\n\5f\10\2\227"..., iov_len=1024}],
>>         msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SO_TIMESTAMP_OLD, cmsg_data={tv_sec=1590340680, tv_usec=272424}},
>>                                    {cmsg_len=60, cmsg_level=SOL_IPV6, cmsg_type=IPV6_RECVERR}],
>>         msg_controllen=96, msg_flags=MSG_ERRQUEUE}, MSG_ERRQUEUE) = 144
>>
>> Suggested-by: Maciej ¯enczykowski <maze@google.com
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> Applied, thanks Eric.
> 

I will send a fix, it appears tcp_v4_err() has two sk_buff variables,
one named icmp_skb, and another one :/

