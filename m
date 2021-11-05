Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D812544653D
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 15:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhKEOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbhKEOxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 10:53:05 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20513C061714;
        Fri,  5 Nov 2021 07:50:25 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d24so14174603wra.0;
        Fri, 05 Nov 2021 07:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=d20ualGiILXRccvudwhtmro0dAm3UTml8W0VVn4OD6E=;
        b=KeEcO8xQh7sgkNhzekQfUSvDzhaJd/N8NwH1a9mjc5FWARb8TgSq9MjxSYU3vIokwP
         9dYM+ODX4yjOKAhnJQZFN48r4oBv7jyZhzPXaTS4A1sFswYha/UzWNxuZb5xFRKLq3U9
         0wDy3VEQbAOXTaFWIoUAElmLujG7W4dnJqJfUJj8RrgNbYMjDOfeocWNyi25xGSQEtsI
         mjhnZd09mG3g+faeMv4zOEz/NnIOjrRj4JjqR+fDQUItr4Ep2A3sSfK+W1/oqPB/w3xE
         Uhk+wB08/A8BSeNggtjktrb6ALiJ4+QEcMbSGuj+5MzG97txXEQ0NaB0SY0A2QC9iPhU
         NGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d20ualGiILXRccvudwhtmro0dAm3UTml8W0VVn4OD6E=;
        b=MQ8zN2Q22jIvHh/vqCSTV/O7prHeuj3u597k+vzh7Pwc3WlGoiZ/RNy5YIo6cuBgTQ
         9JsjhKm2XpbqPHD0GrRL5bgZ6ILDqx5sAabdRcobD2zAjMIQdF1MWZ84PzBMuu3RRPvs
         biDKXB7rOjiZ1CnSXH8TTNu2Vgy/iqKvW7e/RumER5Kpt6M4ein8DJ4YqO6rsh6avr8c
         dHBSM/S/7Lh40UYXGNW+PBrib7BLSrqbR/7X4ZBRsfRMptLHKJTSsccgSKTtK+fszOOR
         ILnwlMVIH9EITHoXR7LC9YGWFZG61TAdfKCv6TmUImb1yTh5/gG6y9IwvEOpmCWfmxxG
         iZRQ==
X-Gm-Message-State: AOAM530txr5cuJFRk6JHxZxdnYIuDlSgtoSmb6QOWZE5IIh7DW2ejNmt
        c+et5q2oNvRzDstHLy/31Kk=
X-Google-Smtp-Source: ABdhPJygsqCLfjgIGAR+X9CpgfYs2hALAeUmqvW0jHOUUPI8BmrCRsKajiYKKMcEe21Of2jFW/6JUw==
X-Received: by 2002:adf:dec9:: with SMTP id i9mr55253748wrn.18.1636123823673;
        Fri, 05 Nov 2021 07:50:23 -0700 (PDT)
Received: from ?IPV6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id a9sm8077772wrt.66.2021.11.05.07.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 07:50:23 -0700 (PDT)
Message-ID: <bbdf699e-1ab6-8d1e-9d19-466ca662b9b8@gmail.com>
Date:   Fri, 5 Nov 2021 14:50:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 01/25] tcp: authopt: Initial support and key management
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <51044c39f2e4331f2609484d28c756e2a9db5144.1635784253.git.cdleonard@gmail.com>
 <e7f0449a-2bad-99ad-4737-016a0e6b8b84@gmail.com>
 <4e4e7337-dbd7-b857-b164-960b75b1e21b@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <4e4e7337-dbd7-b857-b164-960b75b1e21b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 07:04, Leonard Crestez wrote:
> On 11/5/21 3:22 AM, Dmitry Safonov wrote:
[..]
>> I remember we discussed it in RFC, that removing a key that's currently
>> in use may result in random MKT to be used.
>>
>> I think, it's possible to make this API a bit more predictable if:
>> - DEL command fails to remove a key that is current/receive_next;
>> - opt.flags has CURR/NEXT flag that has corresponding `u8 current_key`
>> and `u8 receive_next` values. As socket lock is held - that makes
>> current_key/receive_next change atomic with deletion of an existing key
>> that might have been in use.
>>
>> In result user may remove a key that's not in use or has to set new
>> current/next. Which avoids the issue with random MKT being used to sign
>> segments.
> 
> The MKT used to sign segments is already essentially random unless the
> user makes a deliberate choice. This is what happens if you add two keys
> an call connect(). But why is this a problem?

The issue is predictability and less control for a user on how the key
is selected.

Let's say as a user I have two MKTs A and B. I want to use A for 6 weeks
and then change to B. I want to switch to B as soon as the admin of the
peer adds the key and the peer sends me (rnext_key = B.id).

With your semantics currently a random key will be used as long as I
don't "lock" the id which means that rnext_key won't be respected.
So there's clearly less predictability for a user to select current key
in use.

> Applications which want to deliberately control the send key can do so
> with TCP_AUTHOPT_FLAG_LOCK_KEYID. If that flag is not set then the key
> with send_id == recv_rnextkeyid is preffered as suggested by the RFC, or
> a random one on connect.
> 
> I think your suggestion would force additional complexity on all
> applications for no clear gain.

I disagree. From RFC (3.1):

"It is presumed that an MKT affecting a particular connection cannot be
destroyed during an active connection -- or, equivalently, that its
parameters are copied to an area local to the connection (i.e.,
instantiated) and so changes would affect only new connections."

which means that the user shouldn't be able to remove a key in use.
So, by default you should return an error if the key in use being deleted.

The only use-case to delete a key that is in use is if it has been
compromised RFC(6.1):

"Deciding when to start using a key is a performance issue. Deciding
when to remove an MKT is a security issue. Invalid MKTs are expected to
be removed. TCP-AO provides no mechanism to coordinate their removal, as
we consider this a key management operation."

I might misread the RFC, but it seems that shouldn't happen in an
ordinary usage scenario (as long as the user don't --force removal of
the compromised key in an exceptional case).

So, if you allow a user to set current_key/rnext_key atomically with
removal - it seems to fit this --force use-case and let user more
control over which key is in use.

> Key selection controls are only added much later in the series, this is
> also part of the effort to split the code into readable patches. See
> this patch:
> 
> https://lore.kernel.org/netdev/2dc569c0d60c80c26aafcaa201ba5b5ec53ce6bd.1635784253.git.cdleonard@gmail.com/

A separate issue with that one (if I'm not misreading) seems to be that
you're going to send segments with info->send_rnextkeyid if the deleted
key was TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID one.
And won't be able to verify the peer inbound segments/replies.

> Removing a key while traffic is happening shouldn't cause failures in
> recv or send code; this takes some effort but is also required to
> prevent auth failures when a socket is closed and transitions to
> timewait. I attempted to ensure this by only doing rcu_dereference for
> tcp_authopt_info and tcp_authopt_key_info once per packet.


Thanks,
          Dmitry
