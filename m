Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF5465756
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245702AbhLAUtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353238AbhLAUrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:47:13 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B730C0613FC;
        Wed,  1 Dec 2021 12:42:53 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q3so32167310wru.5;
        Wed, 01 Dec 2021 12:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KQ8NRxkzw4Ji5ApiKgE9S4/8PNP5ghov5RAcRfL/Sok=;
        b=oQVD56VwAarF4NU478+1OhkWubWs/aFkN47kRjgEcxvVDtMHjgRzp+aRGjxeef2kld
         2X2mAJqECjI/lOiuEgppvZstICetmaGBwnoH6hAxTANGnE4Dc3XXZ96PRqi3TbQUhQYe
         vK4Efp+hpEovOwb/z4suwpbJgbilmLHz5xM0Arz9tNPPj3J1JwFdct+wOHbTzy+xcJWT
         uD7LmtyV6SPOnHtqEQzZEaoC5sssrtXqykpZ++qTC/5vjIE+D6GWT+SWv61U5XiTz2HB
         H7z5EgWRbEidcwnfAgDy9oae1TveinoSGC7uoght5LqLJlNkFON0A+ZzlGuA3TDIPKf4
         6vbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KQ8NRxkzw4Ji5ApiKgE9S4/8PNP5ghov5RAcRfL/Sok=;
        b=4YrYID1YC4feDwYo+0VU9QR/iTAple43VZa12JurwDo4V+s9nXEaPkhd7ZUyHtDeV9
         qZAWRYVdH8/ljHlBjnnq93/2jKqxS5bEteX6yC23nyw+tOqPhqLFudoa5BtE9gFus9CE
         dmdDjcDl04FF2Y3A2xaq68Ri/fghp+DT7XRwPAgZQtpEiXmpNHNpw0tmBRmF1M3J0uGj
         zWUxneQoJEVXwBhhtd0lUnLcc87SQva4zT3wLQ2mr+zvTbyyjWv6U5SCOq9ToT7bQGNb
         FXVaUeP3LQ4rRHNQY5iIYqatE2+nDkY5Y9Ik1s/UWSDzMG35HLZfMpznYDAij8n0xynw
         tR2w==
X-Gm-Message-State: AOAM532Xd4b3GbpQsIQ9kcy1znZPqhW8K+MfrlAPRFANeH9U346r7lUq
        a3ZD0nc/3J8xjyFFtl2T1zc=
X-Google-Smtp-Source: ABdhPJxuypQ0AA7s55SpcIUt9FKfoePxpPsC23iRiIqvXVRwi4o0FC6+6aBXpj7vSrg7628mjFtd/w==
X-Received: by 2002:adf:fd4c:: with SMTP id h12mr9647806wrs.429.1638391371833;
        Wed, 01 Dec 2021 12:42:51 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.129])
        by smtp.gmail.com with ESMTPSA id d188sm702045wmd.3.2021.12.01.12.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 12:42:51 -0800 (PST)
Message-ID: <5f470c2e-eff9-41b0-ac7a-6cb6ddd5a89c@gmail.com>
Date:   Wed, 1 Dec 2021 20:42:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 17:57, David Ahern wrote:
> On 12/1/21 8:32 AM, Pavel Begunkov wrote:
[...]
>>> mileage varies quite a bit.
>>
>> Interesting, any brief notes on the setup and the results? Dummy
> 
> VM on Chromebook. I just cloned your repos, built, install and test. As
> mentioned above, the skb_orphan_frags_rx change is missing from your
> repo and that is the key to your reported performance gains.

Just to clear misunderstandings if any, all the numbers in the
cover-letter were measured on the same kernel and during the same
boot, and it doesn't include the skb_orphan_frags_rx() change.
All double checked by looking at the traces.

When it's routed through the loopback paths (e.g. -D 127.0.0.1),
it's indeed slow for both msg_zerocopy and send-zc, and both
"benefit" in raw throughput from the hack.

-- 
Pavel Begunkov
