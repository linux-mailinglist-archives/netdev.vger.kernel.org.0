Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9E9606093
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiJTMtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJTMtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:49:43 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0C04B4AF
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 05:49:38 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q71so2251400pgq.8
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 05:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=di3k7ZXs2ulCpAoq0c3NSWb98UIBdkRcz8HRQg9i2aw=;
        b=EmZxB9joE8AgTZ788zcsMltZwVJCZT1TE/NuxPF4a6fhlBgLcyvBNh1VnGFadfTKZx
         TGdiqK0VqyW2EjOAz5lS6Un8kAnza0hCcjvzZsSJQyqnQzdCoMPTOz4cVNjxrtHge0Ke
         RzBKpcsvTPCbdSQYssilqMwU9YTv6oiIcC6ZDv9T8TAmpVn/AsJCgS4jdtX8+G0w6ByJ
         t4Q1df90S3yG7eXBsj0nLfCvFtAj6yqY3nwYjcikR3FW+U2oGjN9KIYGPqYFgi8uZSvi
         Fw3C0VfcIm0/IS1UPCbBp0evr7rnmghJBL7DWr4wGc8yxC3uTENfFm525tItaoh08QL8
         deSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=di3k7ZXs2ulCpAoq0c3NSWb98UIBdkRcz8HRQg9i2aw=;
        b=LFHtsEAwxOG8L3M626ovencaAzEYgCKcScjm8PcpSRLq2ATOUgR1PaTGOPq0HHY0W3
         llaIM0DQkupFKZ0FO737J5nV8KoCVxg61sTW+TN314HBUu8jMLpJr4P7GOG9xY6LWPz4
         omHi1x5AmvkI/lorG/epu11BHo95km6iQ0rTwkmDDK+Frsd3FBxFMrxYXxyc6W/AcDVm
         UespqzRSt5NsOVTlbAOzCK/GDyq+Toiz1MStFkD8liLBmymsaPOdl0rvDFNps4XMq2kV
         vzUKRyY2D2/jPrUbWQQW3IbEyxjKQSibLt7gl+b1ehztelNMlU8ZghuouqUPtWnAlO2f
         oL8A==
X-Gm-Message-State: ACrzQf3Q0CFuZHt5J35EJCdfvBV1VFTDhj0HP9VScmg4cysMtDzjOHik
        P2H1ocw4mKFfw3DrunAH43HOia5GySSJfxkO
X-Google-Smtp-Source: AMsMyM467CXmdjZQFpC9x1YoFBejqfM3sQOcOrqhUOIEPLhHI9QFzLhCjWRXeYnOCCBOKobDaN3v8g==
X-Received: by 2002:a05:6a00:178a:b0:563:7ada:f70 with SMTP id s10-20020a056a00178a00b005637ada0f70mr13763657pfg.69.1666270177782;
        Thu, 20 Oct 2022 05:49:37 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id d18-20020a170902ced200b0017eea4a3979sm12763195plg.154.2022.10.20.05.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 05:49:36 -0700 (PDT)
Message-ID: <ed49aa87-5481-ae92-2488-e959121e8869@kernel.dk>
Date:   Thu, 20 Oct 2022 05:49:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH for-6.1 1/2] io_uring/net: fail zc send for unsupported
 protocols
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <cover.1666229889.git.asml.silence@gmail.com>
 <ee7c163db8cea65b208d327610a6a96f936c1c6f.1666229889.git.asml.silence@gmail.com>
 <f60d98e7-c798-b4a9-f305-4adc16341eca@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f60d98e7-c798-b4a9-f305-4adc16341eca@samba.org>
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

On 10/20/22 2:13 AM, Stefan Metzmacher wrote:
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
>>   +static inline bool io_sock_support_zc(struct socket *sock)
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
>         case SO_ZEROCOPY:
>                 if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
>                         if (!(sk_is_tcp(sk) ||
>                               (sk->sk_type == SOCK_DGRAM &&
>                                sk->sk_protocol == IPPROTO_UDP)))
>                                 ret = -EOPNOTSUPP;
>                 } else if (sk->sk_family != PF_RDS) {
>                         ret = -EOPNOTSUPP;
>                 }
>                 if (!ret) {
>                         if (val < 0 || val > 1)
>                                 ret = -EINVAL;
>                         else
>                                 sock_valbool_flag(sk, SOCK_ZEROCOPY, valbool);
>                 }
>                 break;
> 
> Maybe the socket creation code could set
> unsigned char skc_so_zerocopy_supported:1;
> and/or
> unsigned char skc_zerocopy_msg_ubuf_supported:1;
> 
> In order to avoid the manual complex tests.

I agree that would be cleaner, even for 6.1. Let's drop these two
for now.

-- 
Jens Axboe


