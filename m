Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0FC55FB32
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbiF2I6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiF2I6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:58:33 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EBCB7E5;
        Wed, 29 Jun 2022 01:58:32 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so8300730wmp.3;
        Wed, 29 Jun 2022 01:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=umDz2mWCfuNGKxLZgsu5rbBZtAx6nyuFjdxun9aV4xE=;
        b=igeEuASPkzX9RW9eFzx69DtY/S3fjzeuSgzNJNE6ccmJcJJhlh79HvQAVu5fG0xyYk
         B80qQSeQNGfGFRdUh17FT6q7R+rhrW8EICQncoFtzs2RdqqlN8B7OzJsoyW8M4fKvc9X
         6zK1u+SS9ClBWd8f6TfvM+IhwKOlqZUTFlSdAm3RZ2EEt+cydcQxkNWYZv0be70Np4ES
         anp602Z8/bjkG+gxcpj4zBDGirAeoPTQrI52pitPQYDGwKHIPlCIYJ+Dshod8BSGlcSw
         h1sUZu745mXDc5d/7A1UDZnDUuArlJSYHjuzbwwSvTkeiZ081plLMNL2hVhNOnMBVs7P
         pL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=umDz2mWCfuNGKxLZgsu5rbBZtAx6nyuFjdxun9aV4xE=;
        b=UT1pUo+lNqGUic+NtAyZgtbBuDrIPOZ3hsZ1l154cH9y4WyCMP7Ng8Nbatp3IXXkh8
         JoZ2uBksKIc9GonlKjK0njURKPWCWQXqRacz+rRt4Pyv+O0bRTT9UnB2I/ScNTBn+Rz9
         bpcbTEvnQzOP4K44InrqQBFRbP1Cm2pA3OHpWjZmbjeJBoaoWs7m9QSgPHHVdhscRKNq
         B6WXkNKwO9epFE7gLiAeOmXEsmhLh98A98AINL3/UzjoiZWFmEkbSl8j5xNQw+tbGKZa
         aoBjiiYWeFRjrwFXDwjy8bWl7LIbh2MvnyTh3oIupSeRi3CR3bkhPfcpxH9bN7mPupfe
         xWmQ==
X-Gm-Message-State: AJIora9OSYjAFxfDZqQvkB+nfRow9WdTidp7kLqf/0Yf9l9+MoAss3b1
        pmMRL3j0j8H7wYrA1A5DYo8=
X-Google-Smtp-Source: AGRyM1sGgXlu2mq97AaBmcjcLiVYJodcP0N+RBgSwukn4QqiE3rB4AkOFVsQ1fafsW11m3pvdmOjhQ==
X-Received: by 2002:a05:600c:2290:b0:3a0:3e42:4f9a with SMTP id 16-20020a05600c229000b003a03e424f9amr4174898wmf.28.1656493111164;
        Wed, 29 Jun 2022 01:58:31 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:2a7:be0:64e9:b8c:15e9:ebb? ([2a01:e0a:2a7:be0:64e9:b8c:15e9:ebb])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d42d2000000b0021a56cda047sm15533141wrr.60.2022.06.29.01.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 01:58:30 -0700 (PDT)
Message-ID: <25de5ab0-551e-7304-9715-558ee0a5c501@gmail.com>
Date:   Wed, 29 Jun 2022 10:58:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] net: tls: fix tls with sk_redirect using a BPF verdict.
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Marc Vertes <mvertes@free.fr>
References: <20220628152505.298790-1-julien.salleyron@gmail.com>
 <20220628103424.5330e046@kernel.org> <62bbf87f16223_2181420853@john.notmuch>
From:   Julien Salleyron <julien.salleyron@gmail.com>
In-Reply-To: <62bbf87f16223_2181420853@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your quick response.

 > It's because kTLS does a very expensive reallocation and copy for the
 > non-zerocopy case (which currently means all of TLS 1.3). I have
 > code almost ready to fix that (just needs to be reshuffled into
 > upstreamable patches). Brings us up from 5.9 Gbps to 8.4 Gbps per CPU
 > on my test box with 16k records. Probably much more than that with
 > smaller records.

Happy to hear that, it seems an impressive improvement!

 > You'll also need a signed-off-by.

We will do it.

 >
 > > IDK what this is trying to do but I certainly depends on the fact
 > > we run skb_cow_data() and is not "generally correct" :S
 >
 > Ah also we are not handling partially consumed correctly either.
 > Seems we might pop off the skb even when we need to continue;
 >
 > Maybe look at how skb_copy_datagram_msg() goes below because it
 > fixes the skb copy up with the rxm->offset. But, also we need to
 > do this repair before sk_psock_tls_strp_read I think so that
 > the BPF program reads the correct data in all cases? I guess
 > your sample program (and selftests for that matter) just did
 > the redirect without reading the data?

Even if our sample program doesn't read data, we can confirm that the 
data in the BPF Program are incorrect (no rxm applied).
We will make a change to handle this.
