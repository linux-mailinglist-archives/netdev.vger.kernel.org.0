Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977AB606095
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiJTMuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiJTMuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:50:05 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A5AA59A5;
        Thu, 20 Oct 2022 05:50:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bv10so34180704wrb.4;
        Thu, 20 Oct 2022 05:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aJYEkwkUk+rdScG5sDf+MTUme3atMrdD7pys6ZbE0sk=;
        b=ZpgPF8gsB/RYH+8vrAKwvFmKUuAwuP8fjZG04ZBT8tiT+zWlB1/nDiUZGx5ia0Y4D9
         zCE/qNQOOolhSo8uPEzvoUsgYe4ltoNaYjKKts//kxuAob4/9rBNYB0ohgAMK3RIAeej
         xGnY8C5GfYpmq1lHgrGy7Bg2UlOri5j2k/yABBEqrBVSgpGIu7JyDU9UIxmfKdhOfCxZ
         NWjgn3x1TClUQuOy31YILu8ZRa4SeiNN9+n+7bNKvObbM4PbJWeDLZVfXWohQPAtu8T3
         RBuT7BCZddw9ZIyUyo7lhEA067AWPsLxABcDp0avHzeoxcb3w3VeJ6381fa17TRpivz5
         uisw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aJYEkwkUk+rdScG5sDf+MTUme3atMrdD7pys6ZbE0sk=;
        b=AHNoiJGrubjrBRzvRt7bS38I4FCmcFtNDQvvNGc34a3uASjFkPlaRS9ioXhB7xfMyl
         QUzCyhoUW9n9KrOoyvBjOYvQnb2x4vZDzqtQoDTXbvn6xwp6uWHEFGCvqqPvNwSaSMQr
         GAFGmVUtkcP7HAXhDbkut72EXmjvQxkMMIizRUzCLNhFaHyzG8vY5UQ1y3J4j0PNScbI
         AFlj6GWhuXuwML28eNmnJoZMR874oJ9Gh8Y+nIuCrT+lNR0VzsOnHuxZhG0uak4y3xeb
         uu4Q549lD3tXCgMG52HW3empwjLAo4Cc32bZvbbMY0sDp8g2LdeS/O29C3lqu20JtyGD
         OcNg==
X-Gm-Message-State: ACrzQf3kl2MJBrO1iH5DW/HNhK4QVTDMjay10j38r3ApeyCjr6Zjum7b
        1lO15P1uz4gTBMWNAYDc/sErguoX8Gc=
X-Google-Smtp-Source: AMsMyM7Na04f4Lg0ByjVUtFgFHBlIczX1VXS15YEL362trJjoNeXoiuZAC0MuPZgBZ55lywkTSo4aQ==
X-Received: by 2002:a5d:4451:0:b0:236:58:b88f with SMTP id x17-20020a5d4451000000b002360058b88fmr1807130wrr.181.1666270201633;
        Thu, 20 Oct 2022 05:50:01 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:93dd])
        by smtp.gmail.com with ESMTPSA id q2-20020adff502000000b0022cc0a2cbecsm16758469wro.15.2022.10.20.05.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 05:50:01 -0700 (PDT)
Message-ID: <d2eb10cb-3cce-429c-7a72-7153b5442377@gmail.com>
Date:   Thu, 20 Oct 2022 13:48:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-6.1 1/2] io_uring/net: fail zc send for unsupported
 protocols
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org
References: <cover.1666229889.git.asml.silence@gmail.com>
 <ee7c163db8cea65b208d327610a6a96f936c1c6f.1666229889.git.asml.silence@gmail.com>
 <f60d98e7-c798-b4a9-f305-4adc16341eca@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f60d98e7-c798-b4a9-f305-4adc16341eca@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/22 10:13, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>> If a protocol doesn't support zerocopy it will silently fall back to
>> copying. This type of behaviour has always been a source of troubles
>> so it's better to fail such requests instead. For now explicitly
>> whitelist supported protocols in io_uring, which should be turned later
>> into a socket flag.
>>
>> Cc: <stable@vger.kernel.org> # 6.0
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/net.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 8c7226b5bf41..28127f1de1f0 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -120,6 +120,13 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
>>       }
>>   }
>> +static inline bool io_sock_support_zc(struct socket *sock)
>> +{
>> +    return likely(sock->sk && sk_fullsock(sock->sk) &&
>> +             (sock->sk->sk_protocol == IPPROTO_TCP ||
>> +              sock->sk->sk_protocol == IPPROTO_UDP));
>> +}
> 
> Can we please make this more generic (at least for 6.1, which is likely be an lts release)
> 
> It means my out of tree smbdirect driver would not be able to provide SENDMSG_ZC.
> 
> Currently sk_setsockopt has this logic:
> 
>          case SO_ZEROCOPY:
>                  if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
>                          if (!(sk_is_tcp(sk) ||
>                                (sk->sk_type == SOCK_DGRAM &&
>                                 sk->sk_protocol == IPPROTO_UDP)))
>                                  ret = -EOPNOTSUPP;
>                  } else if (sk->sk_family != PF_RDS) {
>                          ret = -EOPNOTSUPP;
>                  }
>                  if (!ret) {
>                          if (val < 0 || val > 1)
>                                  ret = -EINVAL;
>                          else
>                                  sock_valbool_flag(sk, SOCK_ZEROCOPY, valbool);
>                  }
>                  break;
> 
> Maybe the socket creation code could set
> unsigned char skc_so_zerocopy_supported:1;
> and/or
> unsigned char skc_zerocopy_msg_ubuf_supported:1;
> 
> In order to avoid the manual complex tests.
> 
> What do you think?

Ok, wanted to do it rather later but let me to try fiddle with it.

btw, what's happening with smbdirect? Do you plan upstream it one day
and it's just maturing out of tree?

-- 
Pavel Begunkov
