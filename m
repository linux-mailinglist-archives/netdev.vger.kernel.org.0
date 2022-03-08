Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9358C4D21D4
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 20:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349651AbiCHTrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 14:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbiCHTrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 14:47:08 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F674FC61
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 11:46:08 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z3so35386plg.8
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 11:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=bHQS21fo7rJF8A8D9YsCm/nb3uEruXx6UdaugBD/6Lo=;
        b=OOvRCvAQU0PZwsr/DCMpdtfEjRxI9y3rMSDOceFJklWIfHv76w+j8r95EB5TSWnyxd
         88J9R0SDhMVHnGNc4KcweWjfpD+vmQ+QUQrV9FDGJkAz+AOPtSLba+R3jA8CuAkGFB5E
         jQYQcDaW++IOaFIJ3l0p2xew8PflSUAhnTs3e0ICl4Nyhn2IrTu6u8tlUoWYfjchLLMo
         D52ukvQRjK7uhXUXe9MqU8nanoom8O4OsEF0xW/lR8FAtDIXiZ10vup4RxQuVil7gtVv
         BaCSB4CKXGpi9W2FUWm1i9UoxZuTzrTNdpMOn6T/nr6LCxusqbg+ssL5atLU8OFzcoFF
         mSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=bHQS21fo7rJF8A8D9YsCm/nb3uEruXx6UdaugBD/6Lo=;
        b=GYIPd3OlpBcZyAmaU5F+T8ctnKjGRhWgzhfFl0+s/rge0l0lwTE2sW+DdxmV1p1z/G
         6JolKy6xgtdhBxvve1m3NYycB0bgvoEFMx2GiGrFEbiFPLIEGJZ4yClXYZ57RfX2s8mb
         JFJaSldQjXT1VZgNwRxC0E6vzptHdzg1uirmoqdJi19++sV13v3ZZ7s3wr1/VYBFTDye
         ulEgZUjh+BpMKMET+y0HboG9Iq0koRmgCkh3HWNppfjFMuqpuJo1vPbi3m5CJ+Re82Xw
         qy38sQKIZ8SyjEONBKfgyRZBg2PUO8qp9tuVpv5xVt+TmCCoUA3yhGnZnlYMRrOKKkAe
         qMbQ==
X-Gm-Message-State: AOAM531dx9uK5tS20xjt5QLM2nN9hyP5DACkw+GfmqWBguUcwr5RKSkd
        20gDxjgAt+7N7iaiymHhTT5OHQ==
X-Google-Smtp-Source: ABdhPJz1DbY6O4TiI5ONKEG8sUN+o3Jvyass91mWX6uYAaX5chzhem7M++HMnSD5+kHppJfGsqMuVw==
X-Received: by 2002:a17:90a:5302:b0:1b9:ba0a:27e5 with SMTP id x2-20020a17090a530200b001b9ba0a27e5mr6280388pjh.91.1646768768301;
        Tue, 08 Mar 2022 11:46:08 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id i15-20020a63b30f000000b003803aee35a2sm7644895pgf.31.2022.03.08.11.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 11:46:08 -0800 (PST)
Message-ID: <45522c89-a3b4-4b98-232b-9c69470124a3@linaro.org>
Date:   Tue, 8 Mar 2022 11:46:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>
References: <20220308000146.534935-1-tadeusz.struk@linaro.org>
 <14626165dad64bbaabed58ba7d59e523@AcuMS.aculab.com>
 <6155b68c-161b-0745-b303-f7e037b56e28@linaro.org>
 <66463e26-8564-9f58-ce41-9a2843891d1a@kernel.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
In-Reply-To: <66463e26-8564-9f58-ce41-9a2843891d1a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 10:18, David Ahern wrote:
>> alloclen = 1480
>> alloc_extra = 136
>> datalen = 64095
>> fragheaderlen = 1480
>> fraglen = 65575
>> transhdrlen = 0
>> mtu = 1480
>>
> Does this solve the problem (whitespace damaged on paste, but it is just
> a code move and removing fraglen getting set twice):
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index e69fac576970..59f036241f1b 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1589,6 +1589,15 @@ static int __ip6_append_data(struct sock *sk,
> 
>                          if (datalen > (cork->length <= mtu &&
> !(cork->flags & IPCORK_ALLFRAG) ? mtu : maxfraglen) - fragheaderlen)
>                                  datalen = maxfraglen - fragheaderlen -
> rt->dst.trailer_len;
> +
> +                       if (datalen != length + fraggap) {
> +                               /*
> +                                * this is not the last fragment, the
> trailer
> +                                * space is regarded as data space.
> +                                */
> +                               datalen += rt->dst.trailer_len;
> +                       }
> +
>                          fraglen = datalen + fragheaderlen;
>                          pagedlen = 0;
> 
> @@ -1615,16 +1624,6 @@ static int __ip6_append_data(struct sock *sk,
>                          }
>                          alloclen += alloc_extra;
> 
> -                       if (datalen != length + fraggap) {
> -                               /*
> -                                * this is not the last fragment, the
> trailer
> -                                * space is regarded as data space.
> -                                */
> -                               datalen += rt->dst.trailer_len;
> -                       }
> -
> -                       fraglen = datalen + fragheaderlen;
> -
>                          copy = datalen - transhdrlen - fraggap - pagedlen;
>                          if (copy < 0) {
>                                  err = -EINVAL;

That fails in the same way:

skbuff: skb_over_panic: text:ffffffff83e7b48b len:65575 put:65575 
head:ffff888101f8a000 data:ffff888101f8a088 tail:0x100af end:0x6c0 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:113!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 1852 Comm: repro Not tainted 5.17.0-rc7-00020-gea4424be1688-dirty #19
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
RIP: 0010:skb_panic+0x173/0x175

I'm not sure how it supposed to help since it doesn't change the alloclen at all.
I think the problem here is that the size of the allocated skb is too small.

-- 
Thanks,
Tadeusz
