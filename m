Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA182D3C70
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 08:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgLIHma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 02:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgLIHma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 02:42:30 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B1BC0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 23:41:50 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id m19so661255ejj.11
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 23:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m3421Ub0KlIhhH/zoEz+MDKzqnaht2bd8LwblfeqHmw=;
        b=ICE3NXOe2Ko+onyTU092mQ+zJbo+hr4zXukVw7sqz4iiJHl+Sw3YnnRlQKK3jiTcjo
         qn/JJOuvNb7mXW/U8O3ZZ+GA4eGQXquLNs05EkPtzIIAlEc5K44BLxgmjMBG4XIR35Pm
         IJO+d78IYCWthJnPH2q6Jfh8ehzbaMfaqaKRs/1M2AA0A+ELIqxVIXV8d11rJ5fspaAX
         lzHlxXCevgS02kBwiQO/ITZ6JyxlMEdza8v5LxIMNoUw8uH/1APVRSXz5bNJuU7mFd7D
         W35f1TOZRHU90+my9H4Lc/3Va1y1ZSEWxTpSaqkWxMyInW4UlVhMnWc6M6tUAOWjTmzE
         4YEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m3421Ub0KlIhhH/zoEz+MDKzqnaht2bd8LwblfeqHmw=;
        b=mcxGXKqvb0VKP2UmT5x/E+AQg67fkFDE0ZHLQDnzypDKyCR5lQ8UVIKr+aABsWMOOO
         qmeKXx7cwaTwsrGHSnOUeYUfY1BUcOg+hGtbkIAr2B7xqVv9MkkZ4zjUXbfA46Wsxxbt
         hP/8mugzTNOrerC2sxbr5ApBJjnPy1rlyutEVkIyAd0ytYHBvhriMosF9LZmf1eZX8Ew
         AWiiQYQulEtoS0Oi2jzGzfh3B1hkn4WMeGBGQKV2IeRU0YS/jvaSUjYmk/GOduhZFh42
         6bzUF8l0P5QZC23QLD7CpeoSedz4E484WA6JsoYcS+2xeDnfefS3BGRhuF2SbtGZeVLY
         Y9lw==
X-Gm-Message-State: AOAM531lLtfWs3BVH2iQrxvC1G5+PVOofTuFB0vSWkMJKyfUKVqupUc2
        1VsbI1gQZwv7QgUEjdIPUo0=
X-Google-Smtp-Source: ABdhPJw2QBzIT0kIqzNqpVAY/7RNpug8VHJPiMC8/cIPVSIVJm5U7XXWXVwn3BjjuawDspGKpWnYEQ==
X-Received: by 2002:a17:906:5fc9:: with SMTP id k9mr971447ejv.70.1607499708784;
        Tue, 08 Dec 2020 23:41:48 -0800 (PST)
Received: from [132.68.43.153] ([132.68.43.153])
        by smtp.gmail.com with ESMTPSA id w10sm652592ejq.121.2020.12.08.23.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 23:41:48 -0800 (PST)
Subject: Re: [PATCH v1 net-next 04/15] net/tls: expose get_netdev_for_sock
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-5-borisp@mellanox.com>
 <f38e30af-f4c0-9adc-259a-5e54214e16b1@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <104d25c4-d0d3-234d-4d15-8e5d6ef1ce28@gmail.com>
Date:   Wed, 9 Dec 2020 09:41:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <f38e30af-f4c0-9adc-259a-5e54214e16b1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/12/2020 3:06, David Ahern wrote:
> On 12/7/20 2:06 PM, Boris Pismenny wrote:
>> get_netdev_for_sock is a utility that is used to obtain
>> the net_device structure from a connected socket.
>>
>> Later patches will use this for nvme-tcp DDP and DDP CRC offloads.
>>
>> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
>> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
>> ---
>>  include/net/sock.h   | 17 +++++++++++++++++
>>  net/tls/tls_device.c | 20 ++------------------
>>  2 files changed, 19 insertions(+), 18 deletions(-)
>>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 093b51719c69..a8f7393ea433 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -2711,4 +2711,21 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
>>  
>>  int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
>>  
>> +/* Assume that the socket is already connected */
>> +static inline struct net_device *get_netdev_for_sock(struct sock *sk, bool hold)
>> +{
>> +	struct dst_entry *dst = sk_dst_get(sk);
>> +	struct net_device *netdev = NULL;
>> +
>> +	if (likely(dst)) {
>> +		netdev = dst->dev;
> 
> I noticed you grab this once when the offload is configured. The dst
> device could change - e.g., ECMP, routing changes. I'm guessing that
> does not matter much for the use case - you are really wanting to
> configure queues and zc buffers for a flow with the device; the netdev
> is an easy gateway to get to it.
> 
> But, data center deployments tend to have redundant access points --
> either multipath for L3 or bond for L2. For the latter, this offload
> setup won't work - dst->dev will be the bond, the bond does not support
> the offload, so user is out of luck.
> 

You are correct, and bond support is currently under review for TLS,
i.e., search for "TLS TX HW offload for Bond". The same approach that
is applied there is relevant here. More generally, this offload is
very similar in concept to TLS offload (tls_device).
