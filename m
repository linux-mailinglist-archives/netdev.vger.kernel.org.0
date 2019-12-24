Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF96129E4D
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 07:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfLXG4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 01:56:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33960 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfLXG4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 01:56:51 -0500
Received: by mail-pg1-f196.google.com with SMTP id r11so10001397pgf.1;
        Mon, 23 Dec 2019 22:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1CyQSBhVS/8RJiNCLwZXcBfNssZFyZO/f15gG/kQ3+0=;
        b=YXfpGeFl+ihFaHTjtPmHVcCzVU5ZXOxJ8kzJH8AM7KhC90RWt2v59HEjLZ7JkojS5m
         qbp47bgd0S1Lhyt8Gq7NJrxcRngYJDgyG6736nLy9Knl2dv8MoyEWPKb5Bv60wK/C6Gv
         S9/OOpliziORiO36wFJzAJbC1oedAvn18Ak0CBZ2WesSBI2YUJGCvceYiKzeN+9Sje6N
         jqZu/y7nJWT0rDmBnt3xRHsVPTxR4SMndg/8q5jR8GIBPFABYsmI/3f0vIF0XU4FkjGC
         ZnT3rIsUMBKsjtu+yg7+UCHU/mD4yug17gVKnkxQAu8AhL6Smbo24UlgRukKRNRjhe5z
         s9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1CyQSBhVS/8RJiNCLwZXcBfNssZFyZO/f15gG/kQ3+0=;
        b=t1xFNq8HMAW9j1kYeuTd+fH1OFilNz5QAhLVktwTGX8iDy+9EuEOkcWfEv9Pc/CPnV
         dqx1xeyX8nISWZ/A1MnvG8Etda0i9+nnNGwJWJ1tSTln8eOH8XMEsOphxwU3IaqjnYAu
         x6rnrkaHOmz+ubyhkMurHiUWsywQxP1d/upwQ6Gi5Py4W4l1iqkpYwPxaw20Uc6fIVqO
         0Y6yVVrzbWku0XupfY9GjWuVRq5RG0MUBG8FAulu5TFH6eGLAajIO36lSsIGi2WWrxJw
         K3MWPnZlpBDMUe6NUUQmSadGyNOznK//FsRRV0eiR7+lsmgEEeZtL0Wr7jhhMAKp3iyU
         n0Vg==
X-Gm-Message-State: APjAAAUr6hxPtIF+iDyFC/cIC5WUXqP8DS1zTsDfgoSON2UJsAWvg9t1
        D/rKIlB6+zmrwn3CaqcanRl66viFSB3eRQ==
X-Google-Smtp-Source: APXvYqyVMpUEMOjroP7PS5Ty8tELicY25iSnynlgqT6GR7apmQC/Gr3C2x1YdJVi2dshpJKv0iu23Q==
X-Received: by 2002:a63:ce55:: with SMTP id r21mr20685275pgi.156.1577170610208;
        Mon, 23 Dec 2019 22:56:50 -0800 (PST)
Received: from ?IPv6:2408:84e4:413:c13d:86f:e176:bbe6:b09b? ([2408:84e4:413:c13d:86f:e176:bbe6:b09b])
        by smtp.gmail.com with ESMTPSA id e2sm27248524pfh.84.2019.12.23.22.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 22:56:49 -0800 (PST)
Subject: Re: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191220044703.88-1-qdkevin.kou@gmail.com>
 <20191220161756.GE5058@localhost.localdomain>
 <1ec267f2-1172-32c0-baee-0d4ebcbfb380@gmail.com>
 <20191223132611.GF5058@localhost.localdomain>
From:   Kevin Kou <qdkevin.kou@gmail.com>
Message-ID: <53550819-1f80-b4cc-9016-b53fc7de9369@gmail.com>
Date:   Tue, 24 Dec 2019 14:56:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101
 Thunderbird/72.0
MIME-Version: 1.0
In-Reply-To: <20191223132611.GF5058@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/12/23 21:26, Marcelo Ricardo Leitner wrote:
> On Sun, Dec 22, 2019 at 12:22:24PM +0800, Kevin Kou wrote:
>> On 2019/12/21 0:17, Marcelo Ricardo Leitner wrote:
>>> On Fri, Dec 20, 2019 at 04:47:03AM +0000, Kevin Kou wrote:
>>>> The function sctp_sf_eat_sack_6_2 now performs
>>>> the Verification Tag validation, Chunk length validation, Bogu check,
>>>> and also the detection of out-of-order SACK based on the RFC2960
>>>> Section 6.2 at the beginning, and finally performs the further
>>>> processing of SACK. The trace_sctp_probe now triggered before
>>>> the above necessary validation and check.
>>>>
>>>> This patch is to do the trace_sctp_probe after the necessary check
>>>> and validation to SACK.
>>>>
>>>> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
>>>> ---
>>>>    net/sctp/sm_statefuns.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
>>>> index 42558fa..b4a54df 100644
>>>> --- a/net/sctp/sm_statefuns.c
>>>> +++ b/net/sctp/sm_statefuns.c
>>>> @@ -3281,7 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>>>>    	struct sctp_sackhdr *sackh;
>>>>    	__u32 ctsn;
>>>> -	trace_sctp_probe(ep, asoc, chunk);
>>>>    	if (!sctp_vtag_verify(chunk, asoc))
>>>>    		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>>>> @@ -3319,6 +3318,8 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>>>>    	if (!TSN_lt(ctsn, asoc->next_tsn))
>>>>    		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
>>>> +	trace_sctp_probe(ep, asoc, chunk);
>>>> +
>>>
>>> Moving it here will be after the check against ctsn_ack_point, which
>>> could cause duplicated SACKs to be missed from the log.
>>
>>
>> As this SCTP trace used to trace the changes of SCTP association state in
>> response to incoming packets(SACK). It is used for debugging SCTP congestion
>> control algorithms, so according to the code in include/trace/events/sctp.h,
>> the trace event mainly focus on congestion related information, and there is
>> no SACK Chunk related information printed. So it is hard to point out
>> whether the SACK is duplicate one or not based on this trace event.
> 
> I see. Yet, it's quite odd to do debugging of congestion control
> algorithms without knowing how many TSNs/bytes are being acked by this
> ack, but let's keep that aside for now.
> 
> I still can't agree with filtering out based the out-of-order SACK check
> (the TSN_lt(ctsn, asoc->ctsn_ack_point) check. That is valuable to
> congestion control debugging, because it will likely mean that the
> sender is working with fewer acks than it would like/expect.
> 
> If you need to filter out them and have a "clean" list of what got in,
> then the fix it needs lies in adding support for logging the ctsn in
> the trace point itself (similarly to the pr_debug in there) and filter
> it on post-processing of the logs.
> 
> I don't know how much of UAPI cover probe points. Hopefully we can add
> that information without having to create new probe points.
> 
Thanks for your comments, In order to avoid affecting the UAPI, let's 
keep the existing print fields at present.

> PS: You can invert the check in
>          if (!TSN_lt(ctsn, asoc->next_tsn))
> to
>          if (TSN_lte(asoc->next_tsn, ctsn))
> and move it above, so it is done before the out-of-order check, and
> the trace point in between them.
> 

I will make this change and commit another patch.

>>
>> include/trace/events/sctp.h
>> 1. TRACE_EVENT(sctp_probe,
>>
>> TP_printk("asoc=%#llx mark=%#x bind_port=%d peer_port=%d pathmtu=%d "
>> 		  "rwnd=%u unack_data=%d",
>> 		  __entry->asoc, __entry->mark, __entry->bind_port,
>> 		  __entry->peer_port, __entry->pathmtu, __entry->rwnd,
>> 		  __entry->unack_data)
>>
>> 2. TRACE_EVENT(sctp_probe_path,
>>
>> TP_printk("asoc=%#llx%s ipaddr=%pISpc state=%u cwnd=%u ssthresh=%u "
>> 		  "flight_size=%u partial_bytes_acked=%u pathmtu=%u",
>> 		  __entry->asoc, __entry->primary ? "(*)" : "",
>> 		  __entry->ipaddr, __entry->state, __entry->cwnd,
>> 		  __entry->ssthresh, __entry->flight_size,
>> 		  __entry->partial_bytes_acked, __entry->pathmtu)
>>
>>>
>>> Yes, from the sender-side CC we don't care about it (yet), but it
>>> helps to spot probably avoidable retransmissions.
>>>
>>> I think this is cleaning up the noise too much. I can agree with
>>> moving it to after the chunk sanity tests, though.
>>>
>>>>    	/* Return this SACK for further processing.  */
>>>>    	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
>>>> -- 
>>>> 1.8.3.1
>>>>
>>
