Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BB66060AA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiJTMzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJTMzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:55:01 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C2E5FDEB;
        Thu, 20 Oct 2022 05:54:59 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id t4so14818679wmj.5;
        Thu, 20 Oct 2022 05:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YBZJonzf1XLogYS0Wa2BgXxp00eFJ0JYYJrQwNbUKMQ=;
        b=STXIpwY/oPKLcVOBEjhVp0oBIPCfgGBgV6as5qjqbjX00ZZE3Vyy8t4pPERRwEqGfw
         aRsGrLMF39Xs/qMXuolOKAPO/ZghD7GJKHIs4U3uYjkevA7+EKd/4ADaiEJYjh4PDmep
         +9gnP+CFKgD7KNt2l7mfT6nMsGoEH7D8b+tdBgSc62zHIqBm0IOUnMAWYejGG93lwK7W
         l72rbjnhUmZ3sy3JLT3PXGGBG0qkLPlPP1Lc1KTGHhJ6EwkfbYSs0aa6CzlWU+s84iEy
         R8UP2E/U5KI8m50H7Ig6YCgWk4M8ukOpU/INJkcaDxDVzhuAB0El3s2o3m0xGjeXH6oH
         SRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YBZJonzf1XLogYS0Wa2BgXxp00eFJ0JYYJrQwNbUKMQ=;
        b=qWlSGslclhhG30t/ZZ55oW7HGDM8eaaIcSdus38Jkgvz4MnOI4MDIRjYDhBDPk1g3t
         AhL+bMX/GjSa6dUAcwHDkQfQzQ8ToXfvRaxngKYtfyL4mMnP4gFRF9lPHek6N2FVeJwD
         XqwQ1Juu/sVwpZjB6ao1qZmi+dfer0iiDuSxDCntrTYdon+wp0npM65Sj2eG0GfvVDST
         dLJHzvQ0A2S1Hh+bU3fh6n6l0TKRs2PNKx2779AS7UPX8FaG/yTjsWS9zVv6mZC7LqZR
         sQWFj+fKzhOixg5u7YQjwUasz6im0D+t2fzfRD0jsn/BYopn60O3EY+T7fGfVDGfW1Bh
         78Cw==
X-Gm-Message-State: ACrzQf2L3h9sgb1xgvq1XIeSGMACYWsuEy28fpxHwbWxBbTb//dkgJwl
        +g3hCiziiSQwLxtX1qRYqCI=
X-Google-Smtp-Source: AMsMyM5ijnyK93HWv/eGpst0mpAUCxpLrpVEX2Rr3CscVb25HZeLZ/+292Mmk4BXTs2g5Dbqz1hRPA==
X-Received: by 2002:a05:600c:198a:b0:3c6:f6b4:68d5 with SMTP id t10-20020a05600c198a00b003c6f6b468d5mr8774067wmq.14.1666270498285;
        Thu, 20 Oct 2022 05:54:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:93dd])
        by smtp.gmail.com with ESMTPSA id s1-20020adfeb01000000b0022cc3e67fc5sm16420702wrn.65.2022.10.20.05.54.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 05:54:57 -0700 (PDT)
Message-ID: <2177dc51-ec7d-6065-c320-76fb0f79b542@gmail.com>
Date:   Thu, 20 Oct 2022 13:53:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-6.1 1/2] io_uring/net: fail zc send for unsupported
 protocols
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <cover.1666229889.git.asml.silence@gmail.com>
 <ee7c163db8cea65b208d327610a6a96f936c1c6f.1666229889.git.asml.silence@gmail.com>
 <f60d98e7-c798-b4a9-f305-4adc16341eca@samba.org>
 <ed49aa87-5481-ae92-2488-e959121e8869@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ed49aa87-5481-ae92-2488-e959121e8869@kernel.dk>
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

On 10/20/22 13:49, Jens Axboe wrote:
> On 10/20/22 2:13 AM, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>>> If a protocol doesn't support zerocopy it will silently fall back to
>>> copying. This type of behaviour has always been a source of troubles
>>> so it's better to fail such requests instead. For now explicitly
>>> whitelist supported protocols in io_uring, which should be turned later
>>> into a socket flag.
>>>
>>> Cc: <stable@vger.kernel.org> # 6.0
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>    io_uring/net.c | 9 +++++++++
>>>    1 file changed, 9 insertions(+)
>>>
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index 8c7226b5bf41..28127f1de1f0 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -120,6 +120,13 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
>>>        }
>>>    }
>>>    +static inline bool io_sock_support_zc(struct socket *sock)
>>> +{
>>> +    return likely(sock->sk && sk_fullsock(sock->sk) &&
>>> +             (sock->sk->sk_protocol == IPPROTO_TCP ||
>>> +              sock->sk->sk_protocol == IPPROTO_UDP));
>>> +}
>>
>> Can we please make this more generic (at least for 6.1, which is likely be an lts release)
>>
>> It means my out of tree smbdirect driver would not be able to provide SENDMSG_ZC.
>>
>> Currently sk_setsockopt has this logic:
>>
>>          case SO_ZEROCOPY:
>>                  if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
>>                          if (!(sk_is_tcp(sk) ||
>>                                (sk->sk_type == SOCK_DGRAM &&
>>                                 sk->sk_protocol == IPPROTO_UDP)))
>>                                  ret = -EOPNOTSUPP;
>>                  } else if (sk->sk_family != PF_RDS) {
>>                          ret = -EOPNOTSUPP;
>>                  }
>>                  if (!ret) {
>>                          if (val < 0 || val > 1)
>>                                  ret = -EINVAL;
>>                          else
>>                                  sock_valbool_flag(sk, SOCK_ZEROCOPY, valbool);
>>                  }
>>                  break;
>>
>> Maybe the socket creation code could set
>> unsigned char skc_so_zerocopy_supported:1;
>> and/or
>> unsigned char skc_zerocopy_msg_ubuf_supported:1;
>>
>> In order to avoid the manual complex tests.
> 
> I agree that would be cleaner, even for 6.1. Let's drop these two
> for now.

As I mentioned let's drop, but if not for smb I do think it's
better as doesn't require changes in multiple /net files.

-- 
Pavel Begunkov
