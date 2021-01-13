Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8022F48AC
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbhAMK1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbhAMK1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 05:27:43 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA16C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 02:27:02 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id e18so2254599ejt.12
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 02:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iOwb7SmnQwE5TwRZOlddvK31ui+5eacu1VdQkFdqtyE=;
        b=tIrI83uP0aoWUdUbjn+uKwxfPobIxFafnhjFwXi1OLbiIHGDMAXTMAY+qOtu8XrVys
         LFbZwF/kUHAFHNg4vY1rtiCaM8/VjfqXhUgJg4R+g3CteWkAKVIYS0tqehNCvRCLZV0H
         1mn1bLsPjApeBbYL9Zw63zawdY1/2oKFlLAyhFoA6SaVFWTtzuExuwCqyJ2h7IoUzCWN
         EXtWtPgUBFtflirLs13YEk1h/sjpS5M0vy2FdDn6aEWoXJgu8nsaw4m/RkW5ai0IFQSg
         18Gxt2i027xMgkzMgoI4bqmugJ1zeR/FwQWLEEh4ghBU8AZTQadhdunZ1qbfeM5UzABw
         KOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iOwb7SmnQwE5TwRZOlddvK31ui+5eacu1VdQkFdqtyE=;
        b=PZZR7hj3cdvYMcOePF+yx1U4Y3WkHL6F7m1/d+WWlxVQlxR92dQtLWcUFCdeUwUa3A
         aefJT17/jJ7r5oKWvYgjeJhf53PyMImMsJ8EW0pmKud8+xKqglG+DoO4uGby73FIB/LL
         yNoGslcYuIC63+ZTXBQz0EygMtcxX7C0A8gs7DYLT1YuBwYfpPhOQTrrxODxyS+/RVES
         HshQERlN9qEVnvnLNlqCcEYDzXhjqfoUtwYFA8GyMHXPPqnvGBGE/e5cxG6uR3M81za1
         wQ3sfrx1vATYjV6Xipq9gietJalHhbxTzyDudIBpRPL3t0CR28LgnOa8+ClEzbIyE6Sr
         LIDg==
X-Gm-Message-State: AOAM530Tyy5fTicEaM7+4hthcGi7K8JfEFmC+u9Q13LqjdHNjaefOk1U
        MVhHbAR4Puvv4K7M9qT3ENDBg8SIbg0=
X-Google-Smtp-Source: ABdhPJxDxU3LGWxwsXK0qTRREVjM7Vw7sf9NWYPAmSk/ExCr3XiLjvOsEW1WWioAFy8sjLnhaFYEbw==
X-Received: by 2002:a17:906:52c1:: with SMTP id w1mr1094249ejn.214.1610533621638;
        Wed, 13 Jan 2021 02:27:01 -0800 (PST)
Received: from [192.168.1.101] ([37.165.157.144])
        by smtp.gmail.com with ESMTPSA id fi14sm542676ejb.53.2021.01.13.02.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 02:27:00 -0800 (PST)
Subject: Re: [PATCH net 2/2] mptcp: better msk-level shutdown.
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1610471474.git.pabeni@redhat.com>
 <4cd18371d7caa6ee4a4e7ef988b50b45e362e177.1610471474.git.pabeni@redhat.com>
 <a42a3c10-0183-a232-aec6-b1e6bbfaa800@gmail.com>
Message-ID: <c863efca-6574-582b-6779-deb9c81dd900@gmail.com>
Date:   Wed, 13 Jan 2021 11:26:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <a42a3c10-0183-a232-aec6-b1e6bbfaa800@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/21 11:21 AM, Eric Dumazet wrote:
> 
> 
> On 1/12/21 6:25 PM, Paolo Abeni wrote:
>> Instead of re-implementing most of inet_shutdown, re-use
>> such helper, and implement the MPTCP-specific bits at the
>> 'proto' level.
>>
>> The msk-level disconnect() can now be invoked, lets provide a
>> suitable implementation.
>>
>> As a side effect, this fixes bad state management for listener
>> sockets. The latter could lead to division by 0 oops since
>> commit ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling").
>>
>> Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
>> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> ---
>>  net/mptcp/protocol.c | 62 ++++++++++++--------------------------------
>>  1 file changed, 17 insertions(+), 45 deletions(-)
>>
>> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
>> index 2ff8c7caf74f..81faeff8f3bb 100644
>> --- a/net/mptcp/protocol.c
>> +++ b/net/mptcp/protocol.c
>> @@ -2642,11 +2642,12 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
>>  
>>  static int mptcp_disconnect(struct sock *sk, int flags)
>>  {
>> -	/* Should never be called.
>> -	 * inet_stream_connect() calls ->disconnect, but that
>> -	 * refers to the subflow socket, not the mptcp one.
>> -	 */
>> -	WARN_ON_ONCE(1);
>> +	struct mptcp_subflow_context *subflow;
>> +	struct mptcp_sock *msk = mptcp_sk(sk);
>> +
>> +	__mptcp_flush_join_list(msk);
>> +	mptcp_for_each_subflow(msk, subflow)
>> +		tcp_disconnect(mptcp_subflow_tcp_sock(subflow), flags);
> 
> Ouch.
> 
> tcp_disconnect() is supposed to be called with socket lock being held.
> 
> Really, CONFIG_LOCKDEP=y should have warned you :/

Or maybe CONFIG_PROVE_RCU=y is needed to catch the bug.


