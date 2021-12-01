Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1080465959
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353637AbhLAWjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353606AbhLAWjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 17:39:15 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515B6C061574;
        Wed,  1 Dec 2021 14:35:54 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id p2-20020a4adfc2000000b002c2676904fdso8274583ood.13;
        Wed, 01 Dec 2021 14:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aR6nqdM/vydgq6qDfEEr9BeTcrpq85WJhoLFzTKF01M=;
        b=RcUbS1boQiYqSykhzAsqltKp+aHjFfaKdIydgFxEoyskq29KoB0wm4pEkUFgLp5Wwh
         /PbHfQpjwZesa2NPKMLdKjtLAnoqmfXKFsB77s4ybwBuBaR78NeoAxj+DZ+57ygp1Yt6
         TABoebiwraKNfoTRK30+j8sXLA/uVeQzm6pi0VKDWRpFE2urbEoZT71XMWJ98oYk50Ae
         pn13DQKE32SGrUHscqux1h7x8siLb59MS7wdwCOIdFb71feMyG0CjCvG+sspJzffrKGP
         xWmyf7gcaAZNMvslj3zxJxPwV7zfxb1+dZuGxZmRGSNE8QUpLfruClQKqZ3cHo+mQwmF
         QSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aR6nqdM/vydgq6qDfEEr9BeTcrpq85WJhoLFzTKF01M=;
        b=YEY8QPFZmTp4lb4lgi6E/3GZeBe/9qfu84t49m7UtzlZ3GP7d7lkVL9JSsC4Yrs4jf
         kSbjACl7qmXfVAw165nTye7FnwK8RH/Hj4nClEpA1MNMa9wZqxkDEQex7psc5QXlPVdg
         UEkL2F8TmXtW/UsZO47OPYM07ppcA5mSIfqhPQwQTFAr+NK1VJh65wc3Qf7kODNjkrl1
         F6b49b/LDEYQWNefSGdv7tPcccGg9qKYX5Z887J9AnnKTykA+1Dvv1NArL3I6Wt+KBEx
         G/qieV6/FpUkhPeR+7mV04RiwQj5JesIHyzDJkSJkzH6mbgzr9Xcv+sW0Ck3p8a7qzvh
         PajA==
X-Gm-Message-State: AOAM532SNTdDqE7z0qhx9pa8OLy2apUEYnSZl3RtHJFPWrcnq9huA/Jm
        Ba69tJOcvcUNcYb1bg6QIi0=
X-Google-Smtp-Source: ABdhPJxZz2rIE36CCv540gJdfz2xnJhbK3KScVA2690elpnzWMQmFM2+1TF0I9dSWDib52/BRbkjFA==
X-Received: by 2002:a4a:c890:: with SMTP id t16mr6186170ooq.95.1638398153705;
        Wed, 01 Dec 2021 14:35:53 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l27sm439576ota.26.2021.12.01.14.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 14:35:53 -0800 (PST)
Message-ID: <66dc5bcb-633d-efe8-0ccc-dcb97d08769c@gmail.com>
Date:   Wed, 1 Dec 2021 15:35:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Martin KaFai Lau <kafai@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
 <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
 <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
 <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
 <974b266e-d224-97da-708f-c4a7e7050190@gmail.com>
 <20211201215157.kgqd5attj3dytfgs@kafai-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211201215157.kgqd5attj3dytfgs@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 2:51 PM, Martin KaFai Lau wrote:
> 
> To tx out dummy, I did:
> #> ip a add 10.0.0.1/24 dev dummy0
              ^^^^^^^^
> 
> #> ip -4 r
> 10.0.0.0/24 dev dummy0 proto kernel scope link src 10.0.0.1
> 
> #> ./send-zc -4 -D 10.0.0.(2) -t 10 udp
                     ^^^^^^^^^^

Pavel's commands have: 'send-zc -4 -D <dummy_ip_addr> -t 10 udp'

I read dummy_ip_addr as the address assigned to dummy0; that's an
important detail. You are sending to an address on that network, not the
address assigned to the device, in which case packets are created and
then dropped by the dummy driver - nothing actually makes it to the server.


> ip -s link show dev dummy0
> 2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 65535 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>    link/ether 82:0f:e0:dc:f7:e6 brd ff:ff:ff:ff:ff:ff
>    RX:    bytes packets errors dropped  missed   mcast
>               0       0      0       0       0       0
>    TX:    bytes packets errors dropped carrier collsns
>    140800890299 2150397      0       0       0       0
> 

