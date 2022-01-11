Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D841F48B17A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343568AbiAKQAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243724AbiAKQAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:00:43 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB57C06173F;
        Tue, 11 Jan 2022 08:00:42 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id l25so22970927wrb.13;
        Tue, 11 Jan 2022 08:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=z1ex1ZxABsRXp/rPR+OVpQZtaHaI+kiKsq7GHCUqCKY=;
        b=QS8x1RpHwLgdNOzNlAXTdd3wgN+Sr2biQcXw86WVibyEtMYIR5fiP11FkksEE3X9KH
         Vy8g8mbmPpskChnlRvN6QR2QGO13LagrRxDgwrJvBKNicGMk2JWNamzzrsObkdZ8Q/11
         rwER7fuYYdvj2GPOgVp4AKg6cu8OsRACp0Us2aKJ89qqKGKF6YQ3NRNm9l2lQwROOfsU
         K3FE1YgR6YiIx8KkzbIigVCYszYhziZfu9kjEt3SPLV0Pqa3sEyb0/a4KTCiPzy106vj
         f0K+Nvnr+M4+nfGK9FFd9KDXdx0K3wNGqjMCP1glG8waYYydHIp/tbu/mqUN12wfzrW/
         R7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z1ex1ZxABsRXp/rPR+OVpQZtaHaI+kiKsq7GHCUqCKY=;
        b=s1oPxr8DHPdlig6dIk9DzyxAcxw8Q/bHntbIN7sxy0mwhGehBpExvCMJn5hXoj2pxc
         reOoech8hrGLeQ+z3DeNA176kDT4FzOBKZSjRRKqOFz5HywMIgM+hRXU92urMKr0ObIY
         EutyFOfo+w1fRCu3XC67jc17jnoKP2f4aENjLmYPNhKDJuoXoFJZ5x3tXU56a3Rsxge0
         zY9g8hk1tgQnZUz+HE0LinJbYNskMNbIWf4dQjKLnGr+A4CaEbvmL2RRTLiUtOBAwXgb
         EGUZA90AnO0zwbxXM8baufcqlRSNddQMCWBQzIRb37cDjrc1G9oX49HvShLA3rUASjXw
         ZM4Q==
X-Gm-Message-State: AOAM531ECSbKMYLmXoPiZgX3VxSXc7BodKmgsx65L7JZhqfubY6tx8C/
        HU+L/J/eX37ncx88+KWhP34=
X-Google-Smtp-Source: ABdhPJxdXExuqi+hXs3I6AWGuNvzvZPLK4cCuOcyHY0iJstOqhzvSZc7j1zHr7ElMyBNOj2/SSBKtg==
X-Received: by 2002:a05:6000:2aa:: with SMTP id l10mr4548402wry.518.1641916841256;
        Tue, 11 Jan 2022 08:00:41 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id u12sm9507394wrf.60.2022.01.11.08.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 08:00:40 -0800 (PST)
Message-ID: <0b7d2c38-8c76-6e29-1dd0-c5eeee8e2377@gmail.com>
Date:   Tue, 11 Jan 2022 15:57:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 09/14] ipv6: hand dst refs to cork setup
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <cover.1641863490.git.asml.silence@gmail.com>
 <07031c43d3e5c005fbfc76b60a58e30c66d7c620.1641863490.git.asml.silence@gmail.com>
 <CA+FuTSdJYwN=vxpj4nkpSxdyJ5_47PZuPTjQkRphYvLt47KdjQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CA+FuTSdJYwN=vxpj4nkpSxdyJ5_47PZuPTjQkRphYvLt47KdjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 15:39, Willem de Bruijn wrote:
> On Mon, Jan 10, 2022 at 8:25 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> During cork->dst setup, ip6_make_skb() gets an additional reference to
>> a passed in dst. However, udpv6_sendmsg() doesn't need dst after calling
>> ip6_make_skb(), and so we can save two additional atomics by passing
>> dst references to ip6_make_skb(). udpv6_sendmsg() is the only caller, so
>> it's enough to make sure it doesn't use dst afterwards.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
> 
> There are two patches 9/14

Weird, thanks for letting know

> 
>>   net/ipv6/ip6_output.c | 9 ++++++---
>>   net/ipv6/udp.c        | 3 ++-
>>   2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>> index 0cc490f2cfbf..6a7bba4dd04d 100644
>> --- a/net/ipv6/ip6_output.c
>> +++ b/net/ipv6/ip6_output.c
>> @@ -1356,6 +1356,8 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
>>          unsigned int mtu;
>>          struct ipv6_txoptions *nopt, *opt = ipc6->opt;
>>
>> +       cork->base.dst = &rt->dst;
>> +
> 
> Is there a reason to move this up from its original location next to
> the other cork initialization assignments?

ip6_setup_cork() consumes a dst ref now even in error cases, moved
it to not patch up all error returns in there. On the other hand
I can add dst_release() to callers when it failed.


> That the reference is taken in ip6_append_data for corked requests
> (once, in setup cork branch) and inherited from udpv6_send_skb
> otherwise is non-trivial. Worth a comment.

Will update in v2, thanks

-- 
Pavel Begunkov
