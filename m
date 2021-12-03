Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28044673A0
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351198AbhLCJHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243758AbhLCJHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:07:32 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCA1C06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 01:04:08 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a9so4230300wrr.8
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 01:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YBCz3QIRWRS/fF9iupcTp7hzHAOxr8tmkwrVmszfVIo=;
        b=XCV/m26WoBoIuSrJCfsoaRLw9MpwlifTggvqvLoIijtUZNWkekND/7x8vaCUX8t6G0
         AYmjgRMW68NpwMnRYzrDkLgdf8/wkA6qzQKqQWd+liVMq99PY9M9MyT0N1eRe9lYM41y
         xUGoFV0RIgiNXulq1D7+NONABYViQc+atnNf2rzglr/zUUErFzTW3uhX0JolpujmbN1J
         he4oDxfDhT79V+xMuwGlkwHBQC+fOO2kAxb3yhhtGs4fHyEnMmWylePpC6hbd0+AXy+w
         v0ZFVUqXv0LgpeuhnhbJqbJg2xW7+F3FdGHudYG5zxe2v2mEaZF1w0GPoQmZNTgyeEqE
         LvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YBCz3QIRWRS/fF9iupcTp7hzHAOxr8tmkwrVmszfVIo=;
        b=FSAQGuyIDrJqXdLA6owFFFs8flBf8cWOrK6aTC7XQE0UFt3HHeqB/D/U2NFQVJrdWd
         9AB60fHMkr4F/JLS0Ekp72gwdaNtlZ5YBPei2/10OGa/1buEu9dMz9QJvBcP9U5V7Z08
         FCV3IOsjRsEVf3ybjpNtNDijAtrZqypCy/9BdVmV4cPmwlSb3fAIJuyJixHTqpywCisg
         ZGjwAxJpz++iZ6uE+ahX2iOOKltzFt4/VVUY3l2AoTONPV7tVUipsal1pSOOHsjK9b4x
         0P4a7xhENRsIYKMOb/weApEgr4HcE0ZKHFth3qxI722W3lJdsNnhhTU8AcTR1jjTRqWG
         vkWQ==
X-Gm-Message-State: AOAM531Zowkcr/Z5Pe/7X4AojHonw5cAD+sGUAQgmaoyDtUrLDEzrh3n
        NDvpG4zY0UC6Vnn3A/A4Ow4=
X-Google-Smtp-Source: ABdhPJzlh0B4vxXWhMhLQMPPa5hIvpTozEL5x1L0x2v4hFL1SscbAZvkUYXEB6i8v/TsC4+phmm+Uw==
X-Received: by 2002:a5d:5445:: with SMTP id w5mr20972342wrv.163.1638522246762;
        Fri, 03 Dec 2021 01:04:06 -0800 (PST)
Received: from [192.168.0.108] ([77.124.182.108])
        by smtp.gmail.com with ESMTPSA id d6sm2058906wrx.60.2021.12.03.01.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 01:04:06 -0800 (PST)
Message-ID: <6b38c698-677b-a834-6f59-4134543393ed@gmail.com>
Date:   Fri, 3 Dec 2021 11:04:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH net] inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 consistently
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Cc:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kafai@fb.com" <kafai@fb.com>, "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20211202224218.269441-1-eric.dumazet@gmail.com>
 <20211203002131.14006-1-kuniyu@amazon.co.jp>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20211203002131.14006-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/2021 2:21 AM, Kuniyuki Iwashima wrote:
> From:   Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Thu,  2 Dec 2021 14:42:18 -0800
>> Since commit 4e1beecc3b58 ("net/sock: Add kernel config
>> SOCK_RX_QUEUE_MAPPING"),
>> sk_rx_queue_mapping access is guarded by CONFIG_SOCK_RX_QUEUE_MAPPING.
>>
>> Fixes: 54b92e841937 ("tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> 
> I missed the commit which was added while I was developing the SO_REUSEPORT
> series.
> 
> Thank you, Eric!
> 
> 
>> Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Martin KaFai Lau <kafai@fb.com>
>> Cc: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   net/ipv4/inet_connection_sock.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
>> index f7fea3a7c5e64b92ca9c6b56293628923649e58c..62a67fdc344cd21505a84c905c1e2c05cc0ff866 100644
>> --- a/net/ipv4/inet_connection_sock.c
>> +++ b/net/ipv4/inet_connection_sock.c
>> @@ -721,7 +721,7 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
>>   
>>   	sk_node_init(&nreq_sk->sk_node);
>>   	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
>> -#ifdef CONFIG_XPS
>> +#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
>>   	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
>>   #endif
>>   	nreq_sk->sk_incoming_cpu = req_sk->sk_incoming_cpu;
>> -- 
>> 2.34.1.400.ga245620fadb-goog


Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Thank you
