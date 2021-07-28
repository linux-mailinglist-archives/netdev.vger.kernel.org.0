Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E1C3D883C
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhG1GuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbhG1GuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:50:00 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1177C061757;
        Tue, 27 Jul 2021 23:49:17 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b9so1126508wrx.12;
        Tue, 27 Jul 2021 23:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4QAhzd/W0r8TJvQ/tpkZasgmlrwwDur43nPhrGFrRIA=;
        b=pyzMPjnpqh3TLRmWRVavu271u1CyT3f5MOJE+UznBFg6IY1mrVCqsx+lG6YhkOzobg
         0aLRr9cMLbK675LA3c3mke+hrsbK6nUE1VQzyjBZiQw/j/UooMA2AtjR8M0riPgwkZBG
         aaAsY5TbuSLFjCJ1Bsx+g7Yrm8ag2ffq42OnNN30W/nuz/g/y5CmMnmJn18Zhb9WNhjI
         vGFTYCq4P8iCW+xzjHgjwvmG0vbwOBHBLjunmtnVY+brR+5So/oya/k4g41IEkYp/ZGk
         z8L8MhEe62BFPUYA/rZvCrNG2kL6eXNg58rkl0xz1WK0Jy7g++FhyHYI6KY0KXe0xfDj
         KIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4QAhzd/W0r8TJvQ/tpkZasgmlrwwDur43nPhrGFrRIA=;
        b=QjKoI0nDpJdFWLZaIHpqg3mXIaW+FpYKH3xsjV7WJSHLG9qUKZnPk/fUx80zflfV9J
         TAiRl3lcQY3a6uXpgq6G/ROzMjBGPc61tvnRl1tcaNS3LN4a6y5YEceiMG9IPSsMNduX
         kUJ4Mj6bSi/w0r5TLdYuIfLfZfS1bjBuGD0/bEBsOxhzgSZkOiigSi6EejF5xvAUuRc3
         E6ErpCSlMB24KhDOQo6bZlaS64lnCOEfYsHzkIWE+6cJTavCWjggWDiyE1jhLyjYNgCK
         pCr7Do3Dx+Z3znN1JAYIVbeH6icifRDc0kF55Hrm3LB7Srrfpv/EKPt15Y5fh7W6j+Vp
         IZwg==
X-Gm-Message-State: AOAM531QIT2oj43KM7XO25WeKMKDOVIvocu/yvIVSGdy2QE5qr6tf9FQ
        HtY31LSVkKQXGH3x7/gtBw8=
X-Google-Smtp-Source: ABdhPJwJpMNzVJpwqpGUESN/5Co8gxCcqD1N306uZYlkH7VRPncRr+WmEINitJRNk7nilX4rzwSinw==
X-Received: by 2002:adf:cd86:: with SMTP id q6mr27839488wrj.422.1627454956496;
        Tue, 27 Jul 2021 23:49:16 -0700 (PDT)
Received: from [10.30.0.16] ([188.241.83.98])
        by smtp.gmail.com with ESMTPSA id k6sm4495714wrm.10.2021.07.27.23.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 23:49:15 -0700 (PDT)
Subject: Re: [RFC] tcp: Initial support for RFC5925 auth option
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Salam Noureddine <noureddine@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <dima@arista.com>
References: <01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com>
 <e2215577-2dc5-9669-20b8-91c7700fa987@gmail.com>
 <CA+HUmGhtPHbT=aBLS_Ny_t802s3RWaE+tupd4T8U9x50eW3JXg@mail.gmail.com>
 <3afe618a-e848-83c3-2cc5-6ad66f3ef44b@gmail.com>
 <CA+HUmGgwvn7uPfoKqy1extwEksAXOcTf2trDX8dcYGtdeppebQ@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <d21b8b0a-fe9b-e5d1-674a-4f2ad6d0543e@gmail.com>
Date:   Wed, 28 Jul 2021 09:49:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+HUmGgwvn7uPfoKqy1extwEksAXOcTf2trDX8dcYGtdeppebQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/21 11:23 PM, Francesco Ruggeri wrote:
> On Tue, Jul 27, 2021 at 11:06 AM Leonard Crestez <cdleonard@gmail.com> wrote:

>> On 7/27/21 6:05 AM, Francesco Ruggeri wrote:
>>> Hi Leonard,
>>>
>>> thanks for taking on this task!
>>>
>>>> I'm especially interested in feedback regarding ABI and testing.
>>>
>>> I noticed that the TCP connection identifier is not part of the
>>> representation of the MKT (tcp_authopt_key_info).
>>> This could cause some issues if, for example 2 MKTs with different
>>> <remote IP, remote TCP port> in the TCP connection identifier but same
>>> KeyID (recv_id) are installed on a socket. In that case
>>> tcp_authopt_inbound_key_lookup() may not pick the correct MKT for the
>>> connection. Matching incoming segments only based on recv_id may not
>>> comply with the RFC.
>>> I think there may be other cases where TCP connection identifiers may
>>> be needed to resolve conflicts, but I have to look at your patch in
>>> more detail.
>>
>> The RFC doesn't specify what the "tcp connection identifier" needs to
>> contains so for this first version nothing was implemented.
>>
>> Looking at MD5 support in linux the initial commit only supported
>> binding keys to addresses and only relatively support was added for
>> address prefixes and interfaces. Remote ports still have no effect.
>>
>> I think adding explicit address binding for TCP-AO would be sufficient,
>> this can be enhanced later. The most typical usecase for TCP auth is to
>> connect with a BGP peer with a fixed IP address.
>>
>> As far as I understand this only actually matters for SYN packets where
>> you want a single listen socket to accept client using overlapping
>> keyids. For an active connection userspace can only add keys for the
>> upcoming destination.
> 
> The RFC does not seem to put any restrictions on the MKTs used with a
> TCP connection, except that every segment must match at most one MKT,
> where the matching is done on the socket pair and for incoming
> segments on the KeyID, and for outgoing segments by designating a
> desired MKT.
> If I understand what you suggest for the initial commit, socket pair
> matching would not be done, and user level (together with out-of-band
> coordination between peers) would be responsible for making sure that
> the segments' socket pairs are consistent with the implied socket
> pairs of the MKTs on the socket. Failure to do that would be
> considered a misconfiguration and would result in undefined behavior.
> Is that correct?

All MKTs are assigned to individual sockets via setsockopt, there is no 
sharing of keys. For an established connection the socket is already 
determined by linux TCP stack based on addr/port so no further matching 
on per-key address needs to be done.

The only interesting cases are:

1) Keys in SYN packets are possibly ambiguous. Current limitation is 
that a server socket needs all key ids to be different and this is 
indeed bad.
2) User is currently allowed to configure same keyid multiple times. RFC 
does not allow this and behavior is undefined.

> Even if the MKT's socket pair is not used in the initial commit, would
> it help having it in the API, to avoid future incompatibilities with
> user level? Or would it be understood that user level code using the
> initial commit may have to change with future commits?

The rules used to distinguish keys in SYN packets can be further 
elaborated by extending the uapi tcp_authopt_key structure. Increasing 
the size of a structure doesn't break ABI if you're careful with length 
checks.

--
Regards,
Leonard
