Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF2B633113
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 00:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiKUX7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 18:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKUX7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 18:59:36 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAE412754
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 15:59:29 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id q96-20020a17090a1b6900b00218b8f9035cso3640989pjq.5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 15:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jccJ4Bm2honkk55HL5L3ubecWLHTgsBISaT1aAHD2nQ=;
        b=5QhulFzI1G8WHE9oKX4gt1WUeh1Fynoxt5ZWH2vyk7Oo9+FSoHFRaWUZLEr3pywHNF
         nGb0E+jUepD7p20/iTExnyVbiziyc8byaeDw4KWtx5Z+RTbTKJ1cxsZBZCli/lr/yRI+
         cAvro7xKn6Te2WNhjfzLv7u4hLfGfqYiUr5sePWuVMDXVHngVq9HENgpdAB5xVqc1l/x
         BVborIe3koNOM4bggrC9+HzY6mwzYgLUVM1gGVu+2vwcIGjmNToc0rqflPYE4TRgEEpf
         +5lnj9VX1VE3A2MrgNLnCB6v2AdV3wFaQ95in+L+uZ1Qr6Rm9qEemD8a3KJHbFhPBsi9
         T/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jccJ4Bm2honkk55HL5L3ubecWLHTgsBISaT1aAHD2nQ=;
        b=SdoOXPMypEA6yBvNIOo5Ep4/zjN05vE+b7dIfAtRGrLSvzEMndBqVjp9Vb/oo7R+UH
         b0g1IvEZYOZ8LD/hgkRfN7A65I8HLaetH0krbMd7e8FKkIHB6Rj16P9HGS0oRjKGwX9y
         O7/HGuE0khRRzdQvwMvPUwaWAjBtzLPz8DiTetd152AKHVbMOMpAVt7dpuhYpBH1nx6l
         AzGccA7+wY/WjdwgqZRTo+rtqJ3va2JGNJECeENtEkvFMUioeAbUSraenpAFiDpc3mea
         fWLnXtphDibki63I4QUKhADhP94Kd70jwaHRfyny0u75I5ljfTDCHtz3MqtotvXPws//
         HcKQ==
X-Gm-Message-State: ANoB5pmFVF7x5/ePWTnNr/H/UgRdQuKpYCY00GuuyQCPE9/iT09DWdm0
        +lvhcXjXKQs1N0/zAFX18M44EA==
X-Google-Smtp-Source: AA0mqf6Qm/z49ORGSNpdORDWI9uJV5l4u+ZQ0/SajrYhCffr1+7KkL52SrzOdM2ahfQEvSvHL5HLNA==
X-Received: by 2002:a17:903:2144:b0:188:a1eb:9a8a with SMTP id s4-20020a170903214400b00188a1eb9a8amr5571440ple.153.1669075168333;
        Mon, 21 Nov 2022 15:59:28 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t8-20020aa79468000000b005625d6d2999sm9231276pfq.187.2022.11.21.15.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 15:59:27 -0800 (PST)
Message-ID: <74feda24-37fd-11ea-af0e-1eff9ed4941e@kernel.dk>
Date:   Mon, 21 Nov 2022 16:59:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5 1/3] io_uring: add napi busy polling support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
References: <20221121191437.996297-1-shr@devkernel.io>
 <20221121191437.996297-2-shr@devkernel.io>
 <067a22bc-72ba-9035-05da-93c43ce356f2@kernel.dk>
In-Reply-To: <067a22bc-72ba-9035-05da-93c43ce356f2@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 12:45?PM, Jens Axboe wrote:
> On 11/21/22 12:14?PM, Stefan Roesch wrote:
>> +/*
>> + * io_napi_add() - Add napi id to the busy poll list
>> + * @file: file pointer for socket
>> + * @ctx:  io-uring context
>> + *
>> + * Add the napi id of the socket to the napi busy poll list.
>> + */
>> +void io_napi_add(struct file *file, struct io_ring_ctx *ctx)
>> +{
>> +	unsigned int napi_id;
>> +	struct socket *sock;
>> +	struct sock *sk;
>> +	struct io_napi_entry *ne;
>> +
>> +	if (!io_napi_busy_loop_on(ctx))
>> +		return;
>> +
>> +	sock = sock_from_file(file);
>> +	if (!sock)
>> +		return;
>> +
>> +	sk = sock->sk;
>> +	if (!sk)
>> +		return;
>> +
>> +	napi_id = READ_ONCE(sk->sk_napi_id);
>> +
>> +	/* Non-NAPI IDs can be rejected */
>> +	if (napi_id < MIN_NAPI_ID)
>> +		return;
>> +
>> +	spin_lock(&ctx->napi_lock);
>> +	list_for_each_entry(ne, &ctx->napi_list, list) {
>> +		if (ne->napi_id == napi_id) {
>> +			ne->timeout = jiffies + NAPI_TIMEOUT;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	ne = kmalloc(sizeof(*ne), GFP_NOWAIT);
>> +	if (!ne)
>> +		goto out;
>> +
>> +	ne->napi_id = napi_id;
>> +	ne->timeout = jiffies + NAPI_TIMEOUT;
>> +	list_add_tail(&ne->list, &ctx->napi_list);
>> +
>> +out:
>> +	spin_unlock(&ctx->napi_lock);
>> +}
> 
> I think this all looks good now, just one minor comment on the above. Is
> the expectation here that we'll basically always add to the napi list?
> If so, then I think allocating 'ne' outside the spinlock would be a lot
> saner, and then just kfree() it for the unlikely case where we find a
> duplicate.

After thinking about this a bit more, I don't think this is done in the
most optimal fashion. If the list is longer than a few entries, this
check (or check-alloc-insert) is pretty expensive and it'll add
substantial overhead to the poll path for sockets if napi is enabled.

I think we should do something ala:

1) When arming poll AND napi has been enabled for the ring, then
    alloc io_napi_entry upfront and store it in ->async_data.

2) Maintain the state in the io_napi_entry. If we're on the list,
    that can be checked with just list_empty(), for example. If not
    on the list, assign timeout and add.

3) Have regular request cleanup free it.

This could be combined with an alloc cache, I would not do that for the
first iteration though.

This would make io_napi_add() cheap - no more list iteration, and no
more allocations. And that is arguably the most important part, as that
is called everytime the poll is woken up. Particularly for multishot
that makes a big difference.

It's also designed much better imho, moving the more expensive bits to
the setup side.

-- 
Jens Axboe
