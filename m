Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8B7128C8D
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 05:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLVEWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 23:22:35 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43721 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfLVEWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 23:22:35 -0500
Received: by mail-pg1-f193.google.com with SMTP id k197so7052654pga.10;
        Sat, 21 Dec 2019 20:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dx98QsdZUoPzKbdbcrNZ5JQNRpmDDBptX5vZGqpjMls=;
        b=SxAsuvoK0bYVbcU6YyB5YD6nJXtB2qrM+4hSxDX0tdZ8Rg+SsI1fVumMtiqOy8Mj3r
         6KYXVUm1poFU1C77NNBxWnA73JkL3Y8fuZnws/P8+8Eqxc4qn1kn9k9d0WIBzkjDInhQ
         3iTX2NPSn7kLd6A46EaYxWpjEMsBh6jvmlsermbsyYFOmrr81OeW6FsFLlkrUgmCC3Fk
         tBOLUU4j3XUWByetV2Az9NRP14ggCgvm1UE56rjoPh9JLTAmsNoTx6kYgVc38JrD37Hd
         W47wZ0pDBGP3f2kORGygZLry7fIHtdZO+Ko8it0CtiXWUipraChmzagi0g6nOIXkx8ky
         LmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dx98QsdZUoPzKbdbcrNZ5JQNRpmDDBptX5vZGqpjMls=;
        b=PPCqhPD2C12sVfpVI0K5ua5QPYemYrLfHBVLYRjAi+BCY3OJzbbrFPrrV9p8QO0pf2
         JUaEUcjS9ZpglYmfvwLCjqzOrFXr2NZWJHYjubNmZWdcgYmiKzYxAgRirOzYVG3e0a4M
         A3At6PjVnAmxgL2PRcx4c2PUi8yeycrSObXiB4ul54c7fLNlbdtyIILGvVNDcQjgZGML
         Hl+I61sa+2LQ3cBU4BVxqzFCnQwTG2gBmyeIIvvBwcHg4NZRVsqxxUzuq/idJGOFvkqM
         A7J8/k9oMAIE6rI1J6vG/B/drrIQuQKdvUuWL5bepFfAb4mF4FYMxBpjGLdzOhr5iId1
         pQdw==
X-Gm-Message-State: APjAAAWd4QXyirsUQaOwZbKHfrQa70b2ZvptHI5u4B+GpaWrYwMqRNWm
        R3zTxC/73vONakr6Pdv/33ZVdWTznOWDsA==
X-Google-Smtp-Source: APXvYqwgqiGWHpsUh2KR2DFGXC1Uy+Dxa84lh+WNDlwwXHRuvOoqwK7GiaCrL7jVVD/6ZY+hsxT0EQ==
X-Received: by 2002:a63:cd06:: with SMTP id i6mr24831048pgg.48.1576988553961;
        Sat, 21 Dec 2019 20:22:33 -0800 (PST)
Received: from ?IPv6:2408:84e4:550:379:806:12ee:39a4:bde? ([2408:84e4:550:379:806:12ee:39a4:bde])
        by smtp.gmail.com with ESMTPSA id m6sm10066370pjn.21.2019.12.21.20.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 20:22:33 -0800 (PST)
Subject: Re: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191220044703.88-1-qdkevin.kou@gmail.com>
 <20191220161756.GE5058@localhost.localdomain>
From:   Kevin Kou <qdkevin.kou@gmail.com>
Message-ID: <1ec267f2-1172-32c0-baee-0d4ebcbfb380@gmail.com>
Date:   Sun, 22 Dec 2019 12:22:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101
 Thunderbird/72.0
MIME-Version: 1.0
In-Reply-To: <20191220161756.GE5058@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/12/21 0:17, Marcelo Ricardo Leitner wrote:
> On Fri, Dec 20, 2019 at 04:47:03AM +0000, Kevin Kou wrote:
>> The function sctp_sf_eat_sack_6_2 now performs
>> the Verification Tag validation, Chunk length validation, Bogu check,
>> and also the detection of out-of-order SACK based on the RFC2960
>> Section 6.2 at the beginning, and finally performs the further
>> processing of SACK. The trace_sctp_probe now triggered before
>> the above necessary validation and check.
>>
>> This patch is to do the trace_sctp_probe after the necessary check
>> and validation to SACK.
>>
>> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
>> ---
>>   net/sctp/sm_statefuns.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
>> index 42558fa..b4a54df 100644
>> --- a/net/sctp/sm_statefuns.c
>> +++ b/net/sctp/sm_statefuns.c
>> @@ -3281,7 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>>   	struct sctp_sackhdr *sackh;
>>   	__u32 ctsn;
>>   
>> -	trace_sctp_probe(ep, asoc, chunk);
>>   
>>   	if (!sctp_vtag_verify(chunk, asoc))
>>   		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>> @@ -3319,6 +3318,8 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>>   	if (!TSN_lt(ctsn, asoc->next_tsn))
>>   		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
>>   
>> +	trace_sctp_probe(ep, asoc, chunk);
>> +
> 
> Moving it here will be after the check against ctsn_ack_point, which
> could cause duplicated SACKs to be missed from the log.


As this SCTP trace used to trace the changes of SCTP association state 
in response to incoming packets(SACK). It is used for debugging SCTP 
congestion control algorithms, so according to the code in 
include/trace/events/sctp.h, the trace event mainly focus on congestion 
related information, and there is no SACK Chunk related information 
printed. So it is hard to point out whether the SACK is duplicate one or 
not based on this trace event.

include/trace/events/sctp.h
1. TRACE_EVENT(sctp_probe,

TP_printk("asoc=%#llx mark=%#x bind_port=%d peer_port=%d pathmtu=%d "
		  "rwnd=%u unack_data=%d",
		  __entry->asoc, __entry->mark, __entry->bind_port,
		  __entry->peer_port, __entry->pathmtu, __entry->rwnd,
		  __entry->unack_data)

2. TRACE_EVENT(sctp_probe_path,

TP_printk("asoc=%#llx%s ipaddr=%pISpc state=%u cwnd=%u ssthresh=%u "
		  "flight_size=%u partial_bytes_acked=%u pathmtu=%u",
		  __entry->asoc, __entry->primary ? "(*)" : "",
		  __entry->ipaddr, __entry->state, __entry->cwnd,
		  __entry->ssthresh, __entry->flight_size,
		  __entry->partial_bytes_acked, __entry->pathmtu)

> 
> Yes, from the sender-side CC we don't care about it (yet), but it
> helps to spot probably avoidable retransmissions.
> 
> I think this is cleaning up the noise too much. I can agree with
> moving it to after the chunk sanity tests, though.
> 
>>   	/* Return this SACK for further processing.  */
>>   	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
>>   
>> -- 
>> 1.8.3.1
>>
