Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC5A18A229
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 19:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCRSOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 14:14:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34994 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgCRSOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 14:14:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id 7so14140210pgr.2
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 11:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SYZ5kb1C6E1xMQXcQnCkqlFUJuFwAo+jzrLANbpa4p0=;
        b=o6ZPBbsVD+dTGrlRL1Ut+qa2/ei207PEmTiwnYCUZ+s5L/xOF/vDQO3k4gc9wSwCdy
         PkaJYI9c4QUQErZ7iKhrPxt3nT0uDNLuVX+i76kMso9cXXKlBewOR2Ixiykp9BX1XQV/
         RcJuVa/QnQuNqAiln3QJqQLKPYBHUlWZV89HBQRgyZFY64WDuClSbpUi6HbNu0ShdO3q
         ZDjmoKT1YUKnIetnxipLyA1hTCmO28c3JfBoGzXqm+HenexxkSHqn3mHbe871nrE/Mn6
         idFAXZZvafqB96WmhaXpjuAlD+X+0ofLW0VlCKDGWCex3y+APhswqbGBtaMl6XtPGCT/
         SiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SYZ5kb1C6E1xMQXcQnCkqlFUJuFwAo+jzrLANbpa4p0=;
        b=pJW0qLZtk40jZh16XkriUq4RXLayzmWMtmD1+ZFs6JsmzMEE3y0eRc5eU8nvYlB6S7
         mrtbuabUOJb6GB3t96JR1eb8DATXAWUCU4YR9aBazNjgqJ5cgYU+6go2wbPA746apitN
         59VwFz49k1Q0c7HFcuwag58ic7GaD/K8LRKxOBYR2Jx+LmLRtG6sn+v5LfwzBRODWdQX
         icr5QU4vcFOCnzlPGLFmnoZ8HYlJDCv6rRHqGO7XbAPptAz3EV2BVP+qqemSLdUUn0Wr
         he6oZD8BjZ3jZRh95HHYoHZcqH43RxlGbA2V19LZbE6DSk67cSWRWOYklKpR+CNJmEt8
         7vsA==
X-Gm-Message-State: ANhLgQ13v1KP06XH+nHlqX0LBjz/9razqeN6Synu/L0bE4DlHIxAVu4i
        WL0RE4BxZH5vJL9wwFtyk0M=
X-Google-Smtp-Source: ADFU+vs0KypeWZwBDGo0KfkncT7riWH2rro00evJPPn0Oo9mmn5v0y9CRK1Azxcq49x6LS+5khCVgA==
X-Received: by 2002:a62:2e06:: with SMTP id u6mr5256012pfu.262.1584555281406;
        Wed, 18 Mar 2020 11:14:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g7sm2949252pjl.17.2020.03.18.11.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 11:14:40 -0700 (PDT)
Subject: Re: [RFC mptcp-next] tcp: mptcp: use mptcp receive buffer space to
 select rcv window
To:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
References: <20200318141917.2612-1-fw@strlen.de>
 <48933c49-0889-5dba-29e2-62640e47797a@gmail.com>
 <20200318180526.GJ979@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <95e08be8-9902-f998-6558-e7e574d783b0@gmail.com>
Date:   Wed, 18 Mar 2020 11:14:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200318180526.GJ979@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/20 11:05 AM, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> @@ -2771,6 +2771,11 @@ u32 __tcp_select_window(struct sock *sk)
>>>  	int full_space = min_t(int, tp->window_clamp, allowed_space);
>>>  	int window;
>>>  
>>> +	if (sk_is_mptcp(sk)) {
>>> +		mptcp_space(sk, &free_space, &allowed_space);
>>> +		full_space = min_t(int, tp->window_clamp, allowed_space);
>>> +	}
>>
>> You could move the full_space = min_t(int, tp->window_clamp, allowed_space);
>> after this block factorize it.
> 
> Indeed, will do.
> 
>>> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
>>> index 40ad7995b13b..aefcbb8bb737 100644
>>> --- a/net/mptcp/subflow.c
>>> +++ b/net/mptcp/subflow.c
>>> @@ -745,6 +745,23 @@ bool mptcp_subflow_data_available(struct sock *sk)
>>>  	return subflow->data_avail;
>>>  }
>>>  
>>> +/* If ssk has an mptcp parent socket, use the mptcp rcvbuf occupancy,
>>> + * not the ssk one.
>>> + *
>>> + * In mptcp, rwin is about the mptcp-level connection data.
>>> + *
>>> + * Data that is still on the ssk rx queue can thus be ignored,
>>> + * as far as mptcp peer is concerened that data is still inflight.
>>> + */
>>> +void mptcp_space(const struct sock *ssk, int *space, int *full_space)
>>> +{
>>> +	const struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
>>> +	const struct sock *sk = READ_ONCE(subflow->conn);
>>
>> What are the rules protecting subflow->conn lifetime ?
>>
>> Why dereferencing sk after this line is safe ?
> 
> Subflow sockets hold a reference on the master/parent mptcp-socket.
> 

Presence of READ_ONCE() tells something might happen on
this pointer after you read it.

Can this pointer be set while this thread is owning the socket lock ?

If not, then you do not need READ_ONCE(), this is confusing.

If yes, then it means that whatever changes the pointer might also release the reference
on the old object.

Thanks.
