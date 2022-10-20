Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764116060CC
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJTM7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiJTM7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:59:39 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7AE2B273
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 05:59:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id b5so19145039pgb.6
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 05:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Px3F0OTpQiOMR9pViG1tn7PPh9JYF29aRogvbKYxqqg=;
        b=JJo1f2JJaSsouex3+DXOgb55rouwB5x49yUT/XAR5ykKspgc/NcV7ezSDoxMwJ6ZuT
         ctcEfWnR8ybiHUkgljOUHZVlKR8LCfeajreYKtp0Q1HnoiGF1T+qn8UmOc3MieuHkTUg
         lPteJey3pN4MWKiGg6IkY5N1FEBDFCwT9sdJ/soX4bU6uHj4Pg37cuw++M62sohdmE0e
         WkRc4ROrZvncz0gH3JQqjHyqg0sRm7pe4APLzZSFgc4376H8lEUPQyH0O2Ml+go/FaQQ
         23I09L24ltnUF/cJUyU9jipodYcPFmq/3rA2rkjHG8x9Qvu+ehTxCfYzt8MNYG/gtpuJ
         uqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Px3F0OTpQiOMR9pViG1tn7PPh9JYF29aRogvbKYxqqg=;
        b=C4Z4K0DdTCpg8tCUBDWUoiYyM2QYRPq47TTVl/FpLoN9TvsYkvjeNPC5dHyPy2nztp
         Q8txwpf5oya2w2uzK+MmDZbB1iLKTSHeD+3pdVZhxnGDaR5uihTcwNvpoWExQQLiHWAq
         7o0yVy4CsrBWP2g4xbFGvECTnAl02S6ZE5V/X6LOZi+71v1lD2+Kl8dRcIF6yXLrIPfj
         0GBwjDMixThMDGCViEveTsqQeoCQxYNIZQbb8PNJhI2OfnHOBqubhgcvZwxSRuADhbxS
         t89EOcsAYD6VjV5AwcTbWDpNf63jCGlzRGwAbhashYoHN3PgNMqk9PLN9FthNYvQsUho
         kSLA==
X-Gm-Message-State: ACrzQf1EtmUfo8brA9QfhcDJ7jUAIxmt/9XBCx9bERsLCKg+LXVHDRMZ
        /lbecTGAAi9sd3zCTEbhX4NOmw==
X-Google-Smtp-Source: AMsMyM5JtaZBrNENdT8Dk3Wn0YCOfVNJwRzMLfsAXPaY0S7jSCD/9qt7idfaKMo084FA1QMv/SC12w==
X-Received: by 2002:a63:e113:0:b0:439:e032:c879 with SMTP id z19-20020a63e113000000b00439e032c879mr11644863pgh.287.1666270770606;
        Thu, 20 Oct 2022 05:59:30 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i3-20020aa796e3000000b005633a06ad67sm13196716pfq.64.2022.10.20.05.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 05:59:30 -0700 (PDT)
Message-ID: <c31e5b41-2433-e947-c42e-cecb86c1429a@kernel.dk>
Date:   Thu, 20 Oct 2022 05:59:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH for-6.1 1/2] io_uring/net: fail zc send for unsupported
 protocols
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <cover.1666229889.git.asml.silence@gmail.com>
 <ee7c163db8cea65b208d327610a6a96f936c1c6f.1666229889.git.asml.silence@gmail.com>
 <f60d98e7-c798-b4a9-f305-4adc16341eca@samba.org>
 <ed49aa87-5481-ae92-2488-e959121e8869@kernel.dk>
 <2177dc51-ec7d-6065-c320-76fb0f79b542@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2177dc51-ec7d-6065-c320-76fb0f79b542@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/22 5:53 AM, Pavel Begunkov wrote:
> On 10/20/22 13:49, Jens Axboe wrote:
>> On 10/20/22 2:13 AM, Stefan Metzmacher wrote:
>>> Hi Pavel,
>>>
>>>> If a protocol doesn't support zerocopy it will silently fall back to
>>>> copying. This type of behaviour has always been a source of troubles
>>>> so it's better to fail such requests instead. For now explicitly
>>>> whitelist supported protocols in io_uring, which should be turned later
>>>> into a socket flag.
>>>>
>>>> Cc: <stable@vger.kernel.org> # 6.0
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>> ?? io_uring/net.c | 9 +++++++++
>>>> ?? 1 file changed, 9 insertions(+)
>>>>
>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>> index 8c7226b5bf41..28127f1de1f0 100644
>>>> --- a/io_uring/net.c
>>>> +++ b/io_uring/net.c
>>>> @@ -120,6 +120,13 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
>>>> ?????? }
>>>> ?? }
>>>> ?? +static inline bool io_sock_support_zc(struct socket *sock)
>>>> +{
>>>> +??? return likely(sock->sk && sk_fullsock(sock->sk) &&
>>>> +???????????? (sock->sk->sk_protocol == IPPROTO_TCP ||
>>>> +????????????? sock->sk->sk_protocol == IPPROTO_UDP));
>>>> +}
>>>
>>> Can we please make this more generic (at least for 6.1, which is likely be an lts release)
>>>
>>> It means my out of tree smbdirect driver would not be able to provide SENDMSG_ZC.
>>>
>>> Currently sk_setsockopt has this logic:
>>>
>>> ???????? case SO_ZEROCOPY:
>>> ???????????????? if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
>>> ???????????????????????? if (!(sk_is_tcp(sk) ||
>>> ?????????????????????????????? (sk->sk_type == SOCK_DGRAM &&
>>> ??????????????????????????????? sk->sk_protocol == IPPROTO_UDP)))
>>> ???????????????????????????????? ret = -EOPNOTSUPP;
>>> ???????????????? } else if (sk->sk_family != PF_RDS) {
>>> ???????????????????????? ret = -EOPNOTSUPP;
>>> ???????????????? }
>>> ???????????????? if (!ret) {
>>> ???????????????????????? if (val < 0 || val > 1)
>>> ???????????????????????????????? ret = -EINVAL;
>>> ???????????????????????? else
>>> ???????????????????????????????? sock_valbool_flag(sk, SOCK_ZEROCOPY, valbool);
>>> ???????????????? }
>>> ???????????????? break;
>>>
>>> Maybe the socket creation code could set
>>> unsigned char skc_so_zerocopy_supported:1;
>>> and/or
>>> unsigned char skc_zerocopy_msg_ubuf_supported:1;
>>>
>>> In order to avoid the manual complex tests.
>>
>> I agree that would be cleaner, even for 6.1. Let's drop these two
>> for now.
> 
> As I mentioned let's drop, but if not for smb I do think it's
> better as doesn't require changes in multiple /net files.

I do think it's cleaner to do as a socket flag rather than hardcode it
in the caller (and potentially making bad assumptions, even if the
out-of-tree code is a bit of a reach for sure).

-- 
Jens Axboe
