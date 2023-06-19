Return-Path: <netdev+bounces-11850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C38E734D82
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CD3A1C2093D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254FF7492;
	Mon, 19 Jun 2023 08:23:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159BB6ABD
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:23:28 +0000 (UTC)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3EA110;
	Mon, 19 Jun 2023 01:23:27 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3112c11fdc9so1323386f8f.3;
        Mon, 19 Jun 2023 01:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687163006; x=1689755006;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sSBDd1/f6xXmLpw9z/ese37NiOW7x5KUx8osjqdGUnM=;
        b=Lsl9EsX4jszeG2zvJgvVKjDAR4ejPIDTxSfqQw+n1L8gF+f7OgxW8IkzEQptJqo3jv
         3f+ywIeXHzCLnN0BoQSzh140TYGbvtlQxK/WgKGmeNw5JVjmePsBpRc/5edy2o+A6K4e
         xKbkbq4gGu1DhMfFjrYklap/6XWzpXgxGliXuvoPQVpsRAJWgm94xVVfGJ9BpMkUgxUk
         VRC7iOeu1H2s4wj6R7f9m3VkuG5nOKdFVuL4rAX8gCJpS7QXFsDSL6zOUNjme/F2KwVY
         qpTmxDZhXR9U4EmlqJnuWTgGn7HiKIssbn/9KC7Lc3wQ6vF4BFh1IhIM7br3SEmVKnG+
         3kHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687163006; x=1689755006;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sSBDd1/f6xXmLpw9z/ese37NiOW7x5KUx8osjqdGUnM=;
        b=bqcnJUftHIQ3+r099798U31RNTb3kTy5C5C09aZB8kMpZwDHPBEa4LerxE8yNMRK6e
         wqC9PmOk53RtAKhPoIU46TLV1tJQf0d/DiWUfjyEZAfl68SFbrHROn/D0RN9f7Qee0fG
         1LZ/jV5JYpCdyanFpL9DA1RM7cHhuGDrhLCNfo6o0pXE+xvPnQvGQQ8vU/wG8GGEyrZ3
         7WIb16HM/IXkE/nBHryNc6Nk1X6MVR95ug1JZIMWTvgvuz3gKBVdtSSNKE1NakMmoUu/
         0oURujZA+gu6PhrIRK8yHYHxoLAZb2FJaAlQNTPan+LYCkuTcGIubNz8d1UsbYx/j5T5
         80BQ==
X-Gm-Message-State: AC+VfDyfMvKd4HD2+WzzE61WT/PTRUREWdmITyBOl4HVkDlwXkGWRCv9
	jXc/PciiepjJZr84w0dITJr1x/3/csc=
X-Google-Smtp-Source: ACHHUZ7EeWzzK8WgDL/QMovggKVNr0k/fH9meoPoVMqoAtP4sO1FreA9c6hWXDPwYHtwf9V0pzIqIg==
X-Received: by 2002:a5d:568a:0:b0:311:1497:a002 with SMTP id f10-20020a5d568a000000b003111497a002mr5516686wrv.3.1687163005624;
        Mon, 19 Jun 2023 01:23:25 -0700 (PDT)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id e3-20020a056000194300b0030ae901bc54sm30867342wry.62.2023.06.19.01.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 01:23:25 -0700 (PDT)
Message-ID: <ecbb5d7e-7238-28e2-1a17-686325e2bb50@gmail.com>
Date: Mon, 19 Jun 2023 11:23:22 +0300
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
 <5a9d4ffb-a569-3f60-6ac8-070ab5e5f5ad@gmail.com>
Content-Language: en-US
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <5a9d4ffb-a569-3f60-6ac8-070ab5e5f5ad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 13/06/2023 14:15, Tariq Toukan wrote:
> 
> 
> On 07/06/2023 18:03, David Howells wrote:
>> Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>
>>> My team spotted a new degradation in TLS TX device offload, bisected 
>>> to this
>>> patch.
>>
>> I presume you're using some hardware (I'm guessing Mellanox?) that can
>> actually do TLS offload?  Unfortunately, I don't have any hardware 
>> that can do
>> this, so I can't test the tls_device stuff.
>>
>>>  From a quick look at the patch, it's not clear to me what's going 
>>> wrong.
>>> Please let us know of any helpful information that we can provide to 
>>> help in
>>> the debug.
>>
>> Can you find out what source line this corresponds to?
>>
>>     RIP: 0010:skb_splice_from_iter+0x102/0x300
>>
>> Assuming you're building your own kernel, something like the following 
>> might
>> do the trick:
>>
>>     echo "RIP: 0010:skb_splice_from_iter+0x102/0x300" |
>>     ./scripts/decode_stacktrace.sh /my/built/vmlinux /my/build/tree
>>
> 
> Hi,
> 
> It's:
> RIP: 0010:skb_splice_from_iter (/usr/linux/net/core/skbuff.c:6957)
> 
> which coresponds to this line:
>                          if (WARN_ON_ONCE(!sendpage_ok(page)))
> 

Hi David,
Any other debug information that we can provide to progress with the 
analysis?

