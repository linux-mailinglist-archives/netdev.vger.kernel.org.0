Return-Path: <netdev+bounces-10358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB3D72E11A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B013D280F51
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7003294D9;
	Tue, 13 Jun 2023 11:16:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC8D3C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:16:27 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38792118;
	Tue, 13 Jun 2023 04:16:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-30af159b433so5149913f8f.3;
        Tue, 13 Jun 2023 04:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686654908; x=1689246908;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R4kd+y1uwKfRP7e93ZE/WKZWkAA+D5Ut1RT3+7c7Onw=;
        b=sef3YbXzr7MvxGXHaRQdMd+IM+wAPQBtg+CKkvRPn7PmFW+E/bx0clC72RYYbWcdMt
         y171cIXU4EfkHrqXVqOMxVz8CRv6k5d06AngpR01J8izEa8Yf4+d0mBOYGuotmzUuBbP
         XCv9X9gDUDRq2KI8NBVmd5W4C6B1pjq5GINjOmX3egn/E+7GMbpZNW4M2SD3QSMPNiu2
         aR2vN95sLlugbPZg+V34pB5muiMCNpt1X/6696C22rnQ1myg8ZcnG5U7idVZqZxpLdrf
         D7fWbcb8H/uchGj9tghtN7wwYYR+kc9ejChx7SZHNrc5BWc2y3Y0A+sBriVp+LlArHGX
         tSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686654908; x=1689246908;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4kd+y1uwKfRP7e93ZE/WKZWkAA+D5Ut1RT3+7c7Onw=;
        b=XS1KJFE+MB7cmeJO1QEA//EsGoDAbLLAW2OGPvb97hLCzgErzK90UGVIEyLQrstKqL
         VKzzGxTIAF2ptKJ9Rz6bqLRO2lxkr11w53Lza47ziNOfDpwT+3/dW0//uwDJf9kyt7as
         rDm2dxeG7P3QIxN5Bc1YjAaOQDBP3CmEembr2SLxHM1sizJOGKPCcLfROToMOs1WeAjX
         ipXjYuUBVjulTyfNHrYwH3G6r1wKNpKxBzzN6cH9HDX/Ze/u2Q5uJb+fBLPv94kgGfvB
         jxt5QRuV9PZWYbdFlpFTFfqTF1W7n1DipQFMzdYlcHnuH8b8pHewv1bCDIJ8JLVqLhLW
         WGNA==
X-Gm-Message-State: AC+VfDzaQUwmqFkU6jz/N8O8X8ZLGm4izTqXQOys3M+hSqcFYOYZ+7fL
	l6Cx6iis+o/40c/rRZ3o7ok=
X-Google-Smtp-Source: ACHHUZ6ZNvQZlX7H3HzuRZ0k2J5gJdr2u9+UMZo3nIqlVJaBUQmWwBFxq9Dje1Cdfb+3MmMX8iF4IA==
X-Received: by 2002:adf:e544:0:b0:30f:bcfd:c690 with SMTP id z4-20020adfe544000000b0030fbcfdc690mr5868435wrm.38.1686654907663;
        Tue, 13 Jun 2023 04:15:07 -0700 (PDT)
Received: from [192.168.0.107] ([77.126.161.239])
        by smtp.gmail.com with ESMTPSA id m12-20020a7bca4c000000b003f4290720d0sm14009675wml.47.2023.06.13.04.15.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 04:15:07 -0700 (PDT)
Message-ID: <5a9d4ffb-a569-3f60-6ac8-070ab5e5f5ad@gmail.com>
Date: Tue, 13 Jun 2023 14:15:03 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net-next v10 08/16] tls: Inline do_tcp_sendpages()
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
 Christian Brauner <brauner@kernel.org>,
 Chuck Lever III <chuck.lever@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, Gal Pressman <gal@nvidia.com>,
 ranro@nvidia.com, samiram@nvidia.com, drort@nvidia.com,
 Tariq Toukan <tariqt@nvidia.com>
References: <4c49176f-147a-4283-f1b1-32aac7b4b996@gmail.com>
 <20230522121125.2595254-1-dhowells@redhat.com>
 <20230522121125.2595254-9-dhowells@redhat.com>
 <2267272.1686150217@warthog.procyon.org.uk>
Content-Language: en-US
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <2267272.1686150217@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 07/06/2023 18:03, David Howells wrote:
> Tariq Toukan <ttoukan.linux@gmail.com> wrote:
> 
>> My team spotted a new degradation in TLS TX device offload, bisected to this
>> patch.
> 
> I presume you're using some hardware (I'm guessing Mellanox?) that can
> actually do TLS offload?  Unfortunately, I don't have any hardware that can do
> this, so I can't test the tls_device stuff.
> 
>>  From a quick look at the patch, it's not clear to me what's going wrong.
>> Please let us know of any helpful information that we can provide to help in
>> the debug.
> 
> Can you find out what source line this corresponds to?
> 
> 	RIP: 0010:skb_splice_from_iter+0x102/0x300
> 
> Assuming you're building your own kernel, something like the following might
> do the trick:
> 
> 	echo "RIP: 0010:skb_splice_from_iter+0x102/0x300" |
> 	./scripts/decode_stacktrace.sh /my/built/vmlinux /my/build/tree
> 

Hi,

It's:
RIP: 0010:skb_splice_from_iter (/usr/linux/net/core/skbuff.c:6957)

which coresponds to this line:
                         if (WARN_ON_ONCE(!sendpage_ok(page)))

> if you run it in the kernel source tree you're using and substitute the
> paths to vmlinux and the build tree for modules.
> 
> David
> 

