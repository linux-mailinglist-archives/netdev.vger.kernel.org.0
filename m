Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810C8663245
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbjAIVID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237681AbjAIVHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:07:42 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E75A2A9F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 13:00:03 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k26-20020a05600c1c9a00b003d972646a7dso10141728wms.5
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 13:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UzZy04Ic2aUdzTgSub/+D+guuDt6qN2zJBC1MOCj0FE=;
        b=PqmeRotaVpMJ4ujbDvAsrYaWBCkhC6Jo70nSAeNd9xslWsIzbDzbW0yNfoaF5r0yy9
         F+MucbQxhBNAcGKweocHMmo5+KVIWsTmMv1VyPryn3dmpjL0F2VYdwCfyesz+ZpCFaGi
         KEk4mw/VMVZZPxy4aVfVw8r3evMBAusP+9egBmEdInB+Gv95brlZUof60RG9aUl7JPRk
         x72PxbuvIEETojjxnoPpsGNznAT3PvrJz8w4RfYe6jAOQlqiWrlxJHkkEA5/WRSZaG7E
         VvP3ive0Pw6jKLya2jeoZuM6mKqhC41IZVpmOJxbxkvp2b9YWDbrTzZWNPuvbrrzITwM
         BRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UzZy04Ic2aUdzTgSub/+D+guuDt6qN2zJBC1MOCj0FE=;
        b=43BRxQFeAQac8pye1kizX8gBw9rrcjrHqdmv+6fBvuTP18np1Q8Vly4a5bR2FFvXc7
         G0W4hYXso+sVn7CXqodEUpBIzdAaDZr3/TBlikvkihdJJxDyJlAVRd1B6SCCIBwebIls
         Qa2AgnSWe0RlqSFUkv/lEhPdGUPZ4JIGRm92DkYAn8asdoyjjJ+blv5cOInEt+swNWPU
         B1XclbMFge+wSjHap4+XYTQY1btlBEdjVno+4ZBcKUH2gGdYk/6Ah7QGAQr6LaKUXPJz
         eU7qQgwXVEvcGh2qnf8cDiTzEGij53mxqyo4hELjJJPmsObDXB2bZz/Yukymwo95Ymhj
         dNGw==
X-Gm-Message-State: AFqh2komHE8LGN5n462YjyLLce1aIZc7RZ4uBsUk+XQv8XHIMBjx75lS
        d0r3uw2wlgHHZSCin7EMO1zbBQ==
X-Google-Smtp-Source: AMrXdXu07Z6MDFh4ZEgcrX9Q3LqIJ4zJVrDOP82VKKfk8W315cyXZsXXbi88iyE0M9V8CvQMVxKb/Q==
X-Received: by 2002:a05:600c:1d28:b0:3d2:1d51:246e with SMTP id l40-20020a05600c1d2800b003d21d51246emr50762581wms.9.1673298002065;
        Mon, 09 Jan 2023 13:00:02 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id p21-20020a7bcc95000000b003c65c9a36dfsm12229340wma.48.2023.01.09.13.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 13:00:01 -0800 (PST)
Message-ID: <00e43ac2-6238-79a2-d9cb-8c42208594d8@arista.com>
Date:   Mon, 9 Jan 2023 20:59:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/5] crypto: Introduce crypto_pool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20230103184257.118069-1-dima@arista.com>
 <20230103184257.118069-2-dima@arista.com>
 <20230106175326.2d6a4dcd@kernel.org>
Content-Language: en-US
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20230106175326.2d6a4dcd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thanks for taking a look and your review,

On 1/7/23 01:53, Jakub Kicinski wrote:
[..]
>> +config CRYPTO_POOL
>> +	tristate "Per-CPU crypto pool"
>> +	default n
>> +	help
>> +	  Per-CPU pool of crypto requests ready for usage in atomic contexts.
> 
> Let's make it a hidden symbol? It seems like a low-level library
> which gets select'ed, so no point bothering users with questions.
> 
> config CRYPTO_POOL
> 	tristate
> 
> that's it.

Sounds good

>> +static int crypto_pool_scratch_alloc(void)
> 
> This isn't called by anything in this patch..
> crypto_pool_alloc_ahash() should call it I'm guessing?

Ah, this is little historical left-over: in the beginning, I used
constant-sized area as "scratch" buffer, the way TCP-MD5 does it.
Later, while converting users to crypto_pool, I found that it would be
helpful to support simple resizing as users have different size
requirement to the temporary buffer, i.e. looking at xfrm_ipcomp, if
later it would be converted to use the same API, rather than its own:
IPCOMP_SCRATCH_SIZE is huge (which may help to save quite some memory if
shared with other crypto_pool users: as the buffer is as well protected
by bh-disabled section, the usage pattern is quite the same).

In patch 2 I rewrote it for crypto_pool_reserve_scratch(). The purpose
of patch 2 was to only add dynamic up-sizing of this buffer to make it
easier to review the change. So, here are 2 options:
- I can move scratch area allocation/resizing/freeing to patch2 for v3
- Or I can keep patch 2 for only adding the resizing functionality, but
in patch 1 make crypto_pool_scratch_alloc() non-static and to the header
API.

What would you prefer?

[..]
>> +out_free:
>> +	if (!IS_ERR_OR_NULL(hash) && e->needs_key)
>> +		crypto_free_ahash(hash);
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		if (*per_cpu_ptr(e->req, cpu) == NULL)
>> +			break;
>> +		hash = crypto_ahash_reqtfm(*per_cpu_ptr(e->req, cpu));
> 
> Could you use a local variable here instead of @hash?
> That way you won't need the two separate free_ahash()
> one before and one after the loop..

Good idea, will do

> 
>> +		ahash_request_free(*per_cpu_ptr(e->req, cpu));
> 
> I think using @req here would be beneficial as well :S
> 
>> +		if (e->needs_key) {
>> +			crypto_free_ahash(hash);
>> +			hash = NULL;
>> +		}
>> +	}
>> +
>> +	if (hash)
>> +		crypto_free_ahash(hash);
> 
> This error handling is tricky as hell, please just add a separate
> variable to hold the 

Agree, will do for v3

>> +out_free_req:
>> +	free_percpu(e->req);
>> +out_free_alg:
>> +	kfree(e->alg);
>> +	e->alg = NULL;
>> +	return ret;
>> +}
>> +
>> +/**
>> + * crypto_pool_alloc_ahash - allocates pool for ahash requests
>> + * @alg: name of async hash algorithm
>> + */
>> +int crypto_pool_alloc_ahash(const char *alg)
>> +{
>> +	int i, ret;
>> +
>> +	/* slow-path */
>> +	mutex_lock(&cpool_mutex);
>> +
>> +	for (i = 0; i < cpool_populated; i++) {
>> +		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
>> +			if (kref_read(&cpool[i].kref) > 0) {
> 
> In the current design we can as well resurrect a pool waiting to 
> be destroyed, right? Just reinit the ref and we're good.
> 
> Otherwise the read() + get() looks quite suspicious to a reader.

Yes, unsure why I haven't done it from the beginning

[..]
>> +/**
>> + * crypto_pool_add - increases number of users (refcounter) for a pool
>> + * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
>> + */
>> +void crypto_pool_add(unsigned int id)
>> +{
>> +	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
>> +		return;
>> +	kref_get(&cpool[id].kref);
>> +}
>> +EXPORT_SYMBOL_GPL(crypto_pool_add);
>> +
>> +/**
>> + * crypto_pool_get - disable bh and start using crypto_pool
>> + * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
>> + * @c: returned crypto_pool for usage (uninitialized on failure)
>> + */
>> +int crypto_pool_get(unsigned int id, struct crypto_pool *c)
> 
> Is there a precedent somewhere for the _add() and _get() semantics
> you're using here? I don't think I've seen _add() for taking a
> reference, maybe _get() -> start(), _add() -> _get()?

Yeah, I presume I took not the best-fitting naming from
tcp_get_md5sig_pool()/tcp_put_md5sig_pool().
Will do the renaming.

Thanks,
          Dmitry

