Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5FF3E99AC
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhHKU0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhHKU0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:26:43 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676E4C061798;
        Wed, 11 Aug 2021 13:26:19 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id e13-20020a9d63cd0000b02904fa42f9d275so4907078otl.1;
        Wed, 11 Aug 2021 13:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=atRMPRk585kmp44EvPA3njvOqwijO8Eqicy1Yu6AAtQ=;
        b=Q97XczwR/juRLDn9dwsMuPhyHXhXU0rvySK5IWGPhmUxJ4qSMK7LuQPOom4f7rGpHO
         +25MIyMB5aLbcGhCfKhdya07r2jMdCb0lCk66o61c4yMiCUKOy5fQzjXdhf+uT8txTlx
         UGS7kszAbFCtVkyRDbTzDOT9aVhQH+CXxJ0d+WhFJ3Cs9Aju3WKdNcebCSM9Z4zk3oTG
         RUqetLF9CmOZmB840TXmbQpbORSeXhc629ZOmqmyQ/mBRnuG9xLk/IbsIeHRoBIoXd3g
         li3ZULq2luitfh90XD43tNXyHRoPzpRHTpPWkRu4AX/pwKXYhIeR66pxBIpLE5NKG56R
         ldfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=atRMPRk585kmp44EvPA3njvOqwijO8Eqicy1Yu6AAtQ=;
        b=qGomJlXc2Nxyvzf0YmTyJAMsRvlcxirsXtrc8b9/1VDKvA5OCsHehc8YWOXPi07s2M
         iGqyUoYFKHsQUll0ahRU76BHHD/xUAO8dL6OD6btOA54/IBF7qT2kDv9lkjd2Cb6k9bU
         xBlJ09mZ80jDl4JtVjAKNYFllXp1lUqoV2i6XEoLlWUJ4ez8bCaenVfodvvItQyuSDIj
         p1RPOimYPAB6k//J+JHHqTwmscn+6lRLL5CGZyLpChf7zXvz/Rk/Gzr0bKB0BkzcD5hS
         8j+DMxJ1v4uvrBirDpzDOtCIh2uf05ALKgltkDlrRIuYskLeQG6x2rYMOmwi5IOvSWiN
         nJMQ==
X-Gm-Message-State: AOAM530qaKkXCgAG1dzIVJOWEbFqDjHSYaxbftN939SGwcHOv9G429UN
        jGwL91qRajJIjBv9KXEJPCk=
X-Google-Smtp-Source: ABdhPJxsJ2wTOZZoyxVZgWNPbr2iVGNKDqDKvoq9Kv4gQWd/CTC0v3dXn2SEbTBkZA8S9BezlSsNxQ==
X-Received: by 2002:a9d:1c85:: with SMTP id l5mr607195ota.5.1628713578770;
        Wed, 11 Aug 2021 13:26:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id t1sm48279ooa.42.2021.08.11.13.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 13:26:18 -0700 (PDT)
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Dmitry Safonov <dima@arista.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
 <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
 <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
 <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
 <8d656f85-6f66-6c40-c4af-b05c6639b9ab@gmail.com>
 <18235a42-72ad-8471-c940-c70b476cf0e0@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c268842b-c699-8d83-6b48-a2205fbf8f21@gmail.com>
Date:   Wed, 11 Aug 2021 14:26:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <18235a42-72ad-8471-c940-c70b476cf0e0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 1:11 PM, Leonard Crestez wrote:
> On 11.08.2021 16:42, David Ahern wrote:
>> On 8/11/21 2:29 AM, Leonard Crestez wrote:
>>> On 8/10/21 11:41 PM, Dmitry Safonov wrote:
>>>> Hi Leonard,
>>>>
>>>> On Tue, 10 Aug 2021 at 02:50, Leonard Crestez <cdleonard@gmail.com>
>>>> wrote:
>>>> [..]
>>>>> +/* Representation of a Master Key Tuple as per RFC5925 */
>>>>> +struct tcp_authopt_key_info {
>>>>> +       struct hlist_node node;
>>>>> +       /* Local identifier */
>>>>> +       u32 local_id;
>>>>
>>>> There is no local_id in RFC5925, what's that?
>>>> An MKT is identified by (send_id, recv_id), together with
>>>> (src_addr/src_port, dst_addr/dst_port).
>>>> Why introducing something new to already complicated RFC?
>>>
>>> It was there to simplify user interface and initial implementation.
>>>
>>> But it seems that BGP listeners already needs to support multiple
>>> keychains for different peers so identifying the key by (send_id,
>>> recv_id, binding) is easier for userspace to work with. Otherwise they
>>> need to create their own local_id mapping internally.
>>>
>>
>> any proposed simplification needs to be well explained and how it
>> relates to the RFC spec.
> 
> The local_id only exists between userspace and kernel so it's not really
> covered by the RFC.

My point is that you need to document the uapi (however it ends up) and
how it is used to achieve the intent of the RFC.

> 
> There are objections to this and it seems to be unhelpful for userspace
> zo I will replace it with match by binding.
> 
> BTW: another somewhat dubious simplification is that I offloaded the RFC
> requirement to never add overlapping keys to userspace. So if userspace
> adds keys with same recvid that match the same TCP 4-tuple then
> connections will just start failing.
> 
> It's arguably fine to allow userspace misconfiguration to cause failures.
> 
> -- 
> Regards,
> Leonard

