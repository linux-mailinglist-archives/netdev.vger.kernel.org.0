Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E47413C21D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgAOM6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:58:00 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42681 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgAOM6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 07:58:00 -0500
Received: by mail-lj1-f195.google.com with SMTP id y4so18436819ljj.9
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 04:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=6DnDCUiyyqJKN2DG70Yq2b93d7JD3y/mTOSX4rA9ZiQ=;
        b=AlXzWKuReozNzqgJ15bDIBqJP7CCqSOPj3AmJjrKNnU+ijffijtyJSM8Qjn9lcwttZ
         MifhDEBjdNR9LgL0+KA+iK5uCJrxVrk6r9v/Ci0O3eU1wZhtQzMTD4fxSln58JGwnsMW
         jFgofrD7tiLgj9CdJ6lMlv55Wg4VVF5tQdKEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=6DnDCUiyyqJKN2DG70Yq2b93d7JD3y/mTOSX4rA9ZiQ=;
        b=i1Dt5pSO0J5NPqoXOBJL1InrWKlstdDL4vFV7DQKzRZJA7EgJyfmVwFlWtklbA0yOp
         vmFdRRaBFYKo/JD3wwltK40rOQmBhByRSzbYK7Mw0VkP7kjba7mLsBmBfxpgLWJ3UPNI
         LJIxp0P+8892OdbuT3Q9nKQRjABo3fC2EsPEKmzCjk4OZbdiH4Wm4E4jYh17N63oFPAr
         QbwtNQGl9ILescyq21VdhmEWp/RcUhPi+UFHTFGPnKYPE8ru+DSAFmMH/dXF6TZzt4JA
         bfK7f/LqSUPEvstU4XL9YKFGvIFaOWD2JxbQnn/AjAdfNjJZ7fsak1NBNUrKnvAgSMb2
         kM4g==
X-Gm-Message-State: APjAAAXHKE3bJnsK+/cX0UoWNMeetD2jZPdDxT0jPLmejGVK+Bf6jBh3
        gWWohrExq9EzCmuNtXzPwa794Q==
X-Google-Smtp-Source: APXvYqxFoptahdtRrQgA64/SXQdiYnOBla3l655akCs8mn+CXvHBDPFxAQiT3JOGakMGMZ6Gnqr3nw==
X-Received: by 2002:a05:651c:1110:: with SMTP id d16mr1718791ljo.86.1579093078213;
        Wed, 15 Jan 2020 04:57:58 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id d24sm9120285lja.82.2020.01.15.04.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 04:57:57 -0800 (PST)
References: <20200110105027.257877-1-jakub@cloudflare.com> <20200110105027.257877-10-jakub@cloudflare.com> <20200113235100.ewx2dviaolg6n6a2@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 09/11] bpf: Allow selecting reuseport socket from a SOCKMAP
In-reply-to: <20200113235100.ewx2dviaolg6n6a2@kafai-mbp.dhcp.thefacebook.com>
Date:   Wed, 15 Jan 2020 13:57:56 +0100
Message-ID: <877e1sswq3.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 12:51 AM CET, Martin Lau wrote:
> On Fri, Jan 10, 2020 at 11:50:25AM +0100, Jakub Sitnicki wrote:
>> SOCKMAP now supports storing references to listening sockets. Nothing keeps
>> us from using it as an array of sockets to select from in SK_REUSEPORT
>> programs.
>>
>> Whitelist the map type with the BPF helper for selecting socket.
>>
>> The restriction that the socket has to be a member of a reuseport group
>> still applies. Socket from a SOCKMAP that does not have sk_reuseport_cb set
>> is not a valid target and we signal it with -EINVAL.
>>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  kernel/bpf/verifier.c |  6 ++++--
>>  net/core/filter.c     | 15 ++++++++++-----
>>  2 files changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index f5af759a8a5f..0ee5f1594b5c 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -3697,7 +3697,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>  		if (func_id != BPF_FUNC_sk_redirect_map &&
>>  		    func_id != BPF_FUNC_sock_map_update &&
>>  		    func_id != BPF_FUNC_map_delete_elem &&
>> -		    func_id != BPF_FUNC_msg_redirect_map)
>> +		    func_id != BPF_FUNC_msg_redirect_map &&
>> +		    func_id != BPF_FUNC_sk_select_reuseport)
>>  			goto error;
>>  		break;
>>  	case BPF_MAP_TYPE_SOCKHASH:
>> @@ -3778,7 +3779,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>  			goto error;
>>  		break;
>>  	case BPF_FUNC_sk_select_reuseport:
>> -		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
>> +		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
>> +		    map->map_type != BPF_MAP_TYPE_SOCKMAP)
>>  			goto error;
>>  		break;
>>  	case BPF_FUNC_map_peek_elem:
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index a702761ef369..c79c62a54167 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -8677,6 +8677,7 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
>>  BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
>>  	   struct bpf_map *, map, void *, key, u32, flags)
>>  {
>> +	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
> A nit.
> Since map_type is tested, reuseport_array_lookup_elem() or sock_map_lookup()
> can directly be called also.  mostly for consideration.  will not
> insist.

sock_map_lookup() isn't global currently.

If I'm following your thinking, you're suggesting an optimization
against retpoline overhead along the lines of INDIRECT_CALL_$n wrappers:

/*
 * INDIRECT_CALL_$NR - wrapper for indirect calls with $NR known builtin
 *  @f: function pointer
 *  @f$NR: builtin functions names, up to $NR of them
 *  @__VA_ARGS__: arguments for @f
 *
 * Avoid retpoline overhead for known builtin, checking @f vs each of them and
 * eventually invoking directly the builtin function. The functions are check
 * in the given order. Fallback to the indirect call.
 */
#define INDIRECT_CALL_1(f, f1, ...)					\
	({								\
		likely(f == f1) ? f1(__VA_ARGS__) : f(__VA_ARGS__);	\
	})
#define INDIRECT_CALL_2(f, f2, f1, ...)					\
	({								\
		likely(f == f2) ? f2(__VA_ARGS__) :			\
				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	\
	})

Will resist the temptation to optimize it as part of this series,
because the indirect call is already there.
