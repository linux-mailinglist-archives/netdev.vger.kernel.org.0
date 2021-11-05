Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E30844683A
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 19:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhKESDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 14:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbhKESDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 14:03:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA463C061714;
        Fri,  5 Nov 2021 11:00:54 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j21so35657130edt.11;
        Fri, 05 Nov 2021 11:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UF1oQ0/1236bxNOsgA85MSsVSAPwpeJpj7Sn+HNgphA=;
        b=CvQH9JZ7tNVdRKfyV0Z2ismDE/Jgri03slgj/GzbPaP3zL2V7xhpYBHQuBhngqW1xe
         GoAbCuc6h4jCvzpQtFvlnd9gEsfPtGcJMEcfqDGJXrjBjWIIH6Hah7a49Culvptb2YbQ
         RlI4ncLpA0hYD+GgGVnh+7QyzYZMEiRQd+z4Idu6BkOmYmcG79fDCssgmX178vTuRoJL
         2lwd39oW/7gjCIb0GH/QCVv71ZWsKc6qfnSauJmy01rbayt0qe3yCpze3XQrskHHZZYY
         P7y+XUbm1g4UAmqazypTz56t3UweN0NiYjgTLOq3JCEA0aMOPHE+1xPl7y3Iw1haaGbQ
         QFVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UF1oQ0/1236bxNOsgA85MSsVSAPwpeJpj7Sn+HNgphA=;
        b=G3MwzaAiGUWzY8LwZ2eodBqvRHEMWHV4d+XpyCwVt+pQwXoqCPL8MZqmVDB4s/iPNy
         VJBA49RFUOeZb5/rF9CfKWwfrTR4uueZIv/i9WcAn//zJWYiT6E3IOkYyo8/WcG2Ehod
         m/wrH7L9TYJQ1g3LY4jvr4fgGI1OuDUuTNyb+mbS/JfHV02LxoGfI6qnqN5FztZERWt/
         axKFhXsubeR2NkzZUuLoYq33fh5XJacJefZpvxQ54eaVj9hpS8L4U7sycYnxIFp4lWDK
         KOKZNjyu9MLpvA/H3Ij7OT9mTDEjBvYY/Tig3PaQbHPc/uieObwpiGfwzNkL02vm9ZNo
         gYhg==
X-Gm-Message-State: AOAM5335PUAm31QUCjVwYuqmGV+FsqUUJ+d4qr5S5SqA0LAjnluidhM8
        cPAzgy2+2ttc7YBQlG/M8cE=
X-Google-Smtp-Source: ABdhPJyefOKrF/KbwopCg6i9gkD5jk4sLbogleuTMMVcs/Hc3gdQe9p/ity5Z3s0SG63RS8IfEdjZQ==
X-Received: by 2002:a17:907:2bd0:: with SMTP id gv16mr9045479ejc.121.1636135252789;
        Fri, 05 Nov 2021 11:00:52 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:9439:4202:183c:5296? ([2a04:241e:501:3870:9439:4202:183c:5296])
        by smtp.gmail.com with ESMTPSA id sc27sm4220242ejc.125.2021.11.05.11.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 11:00:52 -0700 (PDT)
Subject: Re: [PATCH v2 01/25] tcp: authopt: Initial support and key management
To:     Dmitry Safonov <0x7f454c46@gmail.com>
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
 <bbdf699e-1ab6-8d1e-9d19-466ca662b9b8@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <5cfd1a51-1607-702e-5def-f8affce18db6@gmail.com>
Date:   Fri, 5 Nov 2021 20:00:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <bbdf699e-1ab6-8d1e-9d19-466ca662b9b8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 4:50 PM, Dmitry Safonov wrote:
> On 11/5/21 07:04, Leonard Crestez wrote:
>> On 11/5/21 3:22 AM, Dmitry Safonov wrote:
> [..]
>>> I remember we discussed it in RFC, that removing a key that's currently
>>> in use may result in random MKT to be used.
>>>
>>> I think, it's possible to make this API a bit more predictable if:
>>> - DEL command fails to remove a key that is current/receive_next;
>>> - opt.flags has CURR/NEXT flag that has corresponding `u8 current_key`
>>> and `u8 receive_next` values. As socket lock is held - that makes
>>> current_key/receive_next change atomic with deletion of an existing key
>>> that might have been in use.
>>>
>>> In result user may remove a key that's not in use or has to set new
>>> current/next. Which avoids the issue with random MKT being used to sign
>>> segments.
>>
>> The MKT used to sign segments is already essentially random unless the
>> user makes a deliberate choice. This is what happens if you add two keys
>> an call connect(). But why is this a problem?
> 
> The issue is predictability and less control for a user on how the key
> is selected.
> 
> Let's say as a user I have two MKTs A and B. I want to use A for 6 weeks
> and then change to B. I want to switch to B as soon as the admin of the
> peer adds the key and the peer sends me (rnext_key = B.id).
> 
> With your semantics currently a random key will be used as long as I
> don't "lock" the id which means that rnext_key won't be respected.
> So there's clearly less predictability for a user to select current key
> in use.

RFC makes two requirements regarding keyid selection:
A) 7.2: TCP SEND [..] MUST be augmented so that the preferred outgoing 
MKT (current_key) can be indicated.
B) 7.5.2.e: Key must be switch to rnextkeyid if that key is available.

These requirements are in conflict so I added a flag 
TCP_AUTHOPT_LOCK_KEYID to determine if keyid is determined by local 
userspace or based on the peer's rnextkeyid.

Without a "locking" bit any key selections made from userspace would get 
flipped by incoming traffic. Indeed together with your suggestion of not 
allowing the current key to be deleted it would be possible for delete 
to fail repeatedly because the peer keeps sending us valid packets!

The expectation is that complex applications will use the "locking" 
functionality and handle the switch to recv_rnextkeyid themselves. 
Alternatively it's also possible for peers to only control rnextkeyid 
and perform key switch that way.

In your scenario the key will switch automatically as soon as the peer 
sends "B.send_id" in the rnextkeyid field.

Please note that key selection is only fully implemented in PATCH 19, 
without it the behavior is indeed more random. That patch was separated 
for ease of review and because detailed behavior is worth a separate 
discussion.

Entirely different key selections mechanisms are possible, for example 
each key could have a "preference" score. The most detailed discussion 
of key rollover I found is from Cisco:

https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_pi/configuration/xe-16-12/iri-xe-16-12-book/tcp-ao.html#concept_mtn_h4n_j3b

That document describes key rollover based on lifetime intervals for 
each key. I believe my patches provide sufficient control to implement 
the same but that it is a concern for userspace.

>> Applications which want to deliberately control the send key can do so
>> with TCP_AUTHOPT_FLAG_LOCK_KEYID. If that flag is not set then the key
>> with send_id == recv_rnextkeyid is preffered as suggested by the RFC, or
>> a random one on connect.
>>
>> I think your suggestion would force additional complexity on all
>> applications for no clear gain.
> 
> I disagree. From RFC (3.1):
> 
> "It is presumed that an MKT affecting a particular connection cannot be
> destroyed during an active connection -- or, equivalently, that its
> parameters are copied to an area local to the connection (i.e.,
> instantiated) and so changes would affect only new connections."
> 
> which means that the user shouldn't be able to remove a key in use.
> So, by default you should return an error if the key in use being deleted.

I believe this behavior belongs in application software.

> The only use-case to delete a key that is in use is if it has been
> compromised RFC(6.1):
> 
> "Deciding when to start using a key is a performance issue. Deciding
> when to remove an MKT is a security issue. Invalid MKTs are expected to
> be removed. TCP-AO provides no mechanism to coordinate their removal, as
> we consider this a key management operation."
> 
> I might misread the RFC, but it seems that shouldn't happen in an
> ordinary usage scenario (as long as the user don't --force removal of
> the compromised key in an exceptional case).
> 
> So, if you allow a user to set current_key/rnext_key atomically with
> removal - it seems to fit this --force use-case and let user more
> control over which key is in use.

Control is available: user can "lock" a different key before removing 
the current one.

The kernel just doesn't make this mandatory.

>> Key selection controls are only added much later in the series, this is
>> also part of the effort to split the code into readable patches. See
>> this patch:
>>
>> https://lore.kernel.org/netdev/2dc569c0d60c80c26aafcaa201ba5b5ec53ce6bd.1635784253.git.cdleonard@gmail.com/
> 
> A separate issue with that one (if I'm not misreading) seems to be that
> you're going to send segments with info->send_rnextkeyid if the deleted
> key was TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID one.
> And won't be able to verify the peer inbound segments/replies.

I'm not sure I understand this.

If TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID is set then the rnextkeyid byte in 
output packets is controlled by user directly, this behavior is kept 
deliberately simple.

Otherwise we send the recv_id of the current key, this attempts to 
ensure symmetry.

Userspace is expected to use the recv_id of a valid key with 
TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID, otherwise the connection will indeed 
break. The kernel could enforce that this value is valid but it does not 
attempt to prevent userspace bugs.

>> Removing a key while traffic is happening shouldn't cause failures in
>> recv or send code; this takes some effort but is also required to
>> prevent auth failures when a socket is closed and transitions to
>> timewait. I attempted to ensure this by only doing rcu_dereference for
>> tcp_authopt_info and tcp_authopt_key_info once per packet.
