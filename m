Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C2A3D7D11
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhG0SGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 14:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhG0SGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 14:06:04 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFA5C061757;
        Tue, 27 Jul 2021 11:06:03 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id oz16so162928ejc.7;
        Tue, 27 Jul 2021 11:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rwwf0c1WwkkBjj8WtFWGbxOV7DMDAbh7hJuruUjtujE=;
        b=JfMhkmT0N/1OhAwQx0Hiktr2EeyzLPBSdxwW+GgPhcqSJFSDDcdhmzx7x67pEaDt2k
         e+bBgRm7uSA4btD5RwW+ZmMO4pl8z95w/tR6shdm2yvOay93Pt5ymP0hDVRO1TzqyXiK
         ghtm41uNzeGeFExTw2ECgG9NvcImVNMw+cB946qE+C1AT2pIreE82aPtzaqhAqQEo3ON
         9VJpVMqjldqMBBU6zydcknhiVE3ZzQLD1BrKWsl5yuIeotZerCHndeNpQQ4jXxJWiibc
         V0f3/CodRt2NtHYUA/T1XERGdu7ow3qK+EAxXEC9J1JCAv5eUXhm1xzh/GliXxGhU/gk
         4eDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rwwf0c1WwkkBjj8WtFWGbxOV7DMDAbh7hJuruUjtujE=;
        b=tnCs6nW7joqaqaD38hdX89OG0oQLGreUXiEEXRu6Y5VjjtgJjDOpmX+EDfAYP6pHEY
         bIlgreQPLmyTSjMUppBc84Xqo7q71FLLqmA5riM31GD/EH++CQxiX0AsYZN7g3V4GWrc
         rUG/vPuEAJZ5vgLq7a94lxfu9FiZ5cQbo7lqRqqYbkAsh42iV/zR+iQ9JJFyxknpIiZl
         MZpRsLty7RPglr5Bm2iYy30SxKREOtUDBfpwTQwirP3efrp0ogsOTxgricFHsQq26IxG
         iu8sHPRoR6sK2nNZ7dauWqbfVkMJfQ0cqAOrQ3SY4+Lc2qh+2SjfTdB6i1lAQaejoKT4
         OW7A==
X-Gm-Message-State: AOAM531XbowP+C7bOvXjMup2oKGchmgy67Fe1dSVU6ZvvJzxciHu9Tbb
        6ULw+unBy3XWuWVABp3Mc1E=
X-Google-Smtp-Source: ABdhPJyKgOighLlX16nMbxbkIu/SqKmCEyI4327xZ9rTr9FOolDDZ2NI8JTWzAWLWvpDSvN+dDRYXw==
X-Received: by 2002:a17:906:384c:: with SMTP id w12mr22919007ejc.445.1627409162463;
        Tue, 27 Jul 2021 11:06:02 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:e420:4472:3e7:c78d? ([2a04:241e:502:1d80:e420:4472:3e7:c78d])
        by smtp.gmail.com with ESMTPSA id gx11sm1146001ejc.33.2021.07.27.11.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 11:06:01 -0700 (PDT)
Subject: Re: [RFC] tcp: Initial support for RFC5925 auth option
To:     Francesco Ruggeri <fruggeri@arista.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
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
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <3afe618a-e848-83c3-2cc5-6ad66f3ef44b@gmail.com>
Date:   Tue, 27 Jul 2021 21:05:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+HUmGhtPHbT=aBLS_Ny_t802s3RWaE+tupd4T8U9x50eW3JXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/21 6:05 AM, Francesco Ruggeri wrote:
> Hi Leonard,
> 
> thanks for taking on this task!
> 
>> I'm especially interested in feedback regarding ABI and testing.
> 
> I noticed that the TCP connection identifier is not part of the
> representation of the MKT (tcp_authopt_key_info).
> This could cause some issues if, for example 2 MKTs with different
> <remote IP, remote TCP port> in the TCP connection identifier but same
> KeyID (recv_id) are installed on a socket. In that case
> tcp_authopt_inbound_key_lookup() may not pick the correct MKT for the
> connection. Matching incoming segments only based on recv_id may not
> comply with the RFC.
> I think there may be other cases where TCP connection identifiers may
> be needed to resolve conflicts, but I have to look at your patch in
> more detail.

The RFC doesn't specify what the "tcp connection identifier" needs to 
contains so for this first version nothing was implemented.

Looking at MD5 support in linux the initial commit only supported 
binding keys to addresses and only relatively support was added for 
address prefixes and interfaces. Remote ports still have no effect.

I think adding explicit address binding for TCP-AO would be sufficient, 
this can be enhanced later. The most typical usecase for TCP auth is to 
connect with a BGP peer with a fixed IP address.

As far as I understand this only actually matters for SYN packets where 
you want a single listen socket to accept client using overlapping 
keyids. For an active connection userspace can only add keys for the 
upcoming destination.

> It would be helpful if you could split your patch into smaller
> incremental chunks.

OK
