Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34246633D66
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiKVNTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbiKVNTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:19:04 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1A013DC2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:19:03 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 6so14050100pgm.6
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=70ZAKTIUuA9YZcsgy083aOCzRGeKQXa1ItWrXhx5S5w=;
        b=MIv7PhUCQTJ/fvr0WS6ibpUE7jF5LIR48clJkTlKU+JBtWtqmvc02LbfysiIiGy2+t
         YGOCao37S+jQwJVWeYAASnvt2izKv1Y/eCqU9wxy9CMIKbhNheAdSgELhvwg1j6Ek/pd
         qMx2Wb9CUctgbtzF8HXlg1N0iSW9Nk7xCRVqpxQNo489MU9Xv6RDLKsWTR/dI5Ljd/6v
         /ZMl+aYS0shHtmR124OpU72+PvWQP+vPsNovoaPMUKLbytV6ibv6ecst1N70kRnmBL+9
         apRglcWpnkYQgaZIRkLDYFgfrCTL0UUP5niz0OmtnF1SOfIIvE+YM9O5OdQ8YZqyE1UE
         P48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=70ZAKTIUuA9YZcsgy083aOCzRGeKQXa1ItWrXhx5S5w=;
        b=eP1T32M7MlS1TMXVDq6xoH5V5uea0avXA1VaUVoKeBCBDO0dMPcJXDbElrlreKXhum
         uu/5Amb+x+KbyVWjvENAdtFRxITAXfM/Be1zafe5SekqrYLoreyrlLfxTSDX4iz1A8PO
         Pcc86txIvL4IS49qUg1ycdPk8vgKpfWtQDQlce+MfxOACZplBu4DCISRZf0ZRbEp21SZ
         qYbega2JOlP23oIEarV36CouAmYwDzQm2uNu6otUSmttnHbMFlBwDD/CA76MdpTlGSGq
         ADp4s0XfLPOalr/zDyT5ZLz8bRVC35ydj6Y3zGCmYOUW2KHOh2EVAEOq2giRGFAuPVmX
         Bwjw==
X-Gm-Message-State: ANoB5pkavkeZGQSlv/4+bVYOduoRILhcqJLmnCksbPxGaY8WOsr6sNF1
        eQAgySh9rELlL845chqIyzC0tQ==
X-Google-Smtp-Source: AA0mqf6no6RcjD96qeYFL2BP6tcfJGycPT1JQALf9uuds2j8FHqtS5pFRXH/ti+ZQhJ7JYGPuP82Ng==
X-Received: by 2002:a65:4d43:0:b0:470:8e8a:e7fe with SMTP id j3-20020a654d43000000b004708e8ae7femr7561362pgt.215.1669123143085;
        Tue, 22 Nov 2022 05:19:03 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l14-20020a17090a49ce00b0020d9df9610bsm12110105pjm.19.2022.11.22.05.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 05:19:02 -0800 (PST)
Message-ID: <06973f73-16c9-1e21-3416-bc624b8675e4@kernel.dk>
Date:   Tue, 22 Nov 2022 06:19:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5 2/3] io_uring: add api to set / get napi configuration.
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221121191437.996297-1-shr@devkernel.io>
 <20221121191437.996297-3-shr@devkernel.io>
 <35168b29-a81c-e1b2-7ec9-b5f0b896ee74@kernel.dk>
 <0bb0734c-5c3e-3f2c-1163-a9bfa720bf26@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0bb0734c-5c3e-3f2c-1163-a9bfa720bf26@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/22 6:13 AM, Ammar Faizi wrote:
> On 11/22/22 2:46 AM, Jens Axboe wrote:
>> On 11/21/22 12:14?PM, Stefan Roesch wrote:
>>> +static int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>>> +{
>>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>>> +    const struct io_uring_napi curr = {
>>> +        .busy_poll_to = ctx->napi_busy_poll_to,
>>> +    };
>>> +
>>> +    if (copy_to_user(arg, &curr, sizeof(curr)))
>>> +        return -EFAULT;
>>> +
>>> +    WRITE_ONCE(ctx->napi_busy_poll_to, 0);
>>> +    return 0;
>>> +#else
>>> +    return -EINVAL;
>>> +#endif
>>> +}
>>
>> Should probably check resv/pad here as well, maybe even the
>> 'busy_poll_to' being zero?
> 
> Jens, this function doesn't read from __user memory, it writes to
> __user memory.
> 
> @curr.resv and @curr.pad are on the kernel's stack. Both are already
> implicitly initialized to zero by the partial struct initializer.

Oh yes, guess I totally missed that we don't care about the value
at all (just zero the target) and copy back the old values.

-- 
Jens Axboe


