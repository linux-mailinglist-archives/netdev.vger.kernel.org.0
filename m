Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AD761855C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiKCQxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiKCQxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:53:47 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610441144
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 09:53:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso82519wms.4
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 09:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m2fOM7m78o4CAWPlVEeyBmVxnJecOkxduoPEfpTUoqM=;
        b=ioyOWN5wxkmdtgjrMU3HQuhRDXkmiVR2jfdYdiPdAnya20uE3ZzziwurTdTTtg2Q6H
         iK/iS1Ot0fAysBd1TEf9EyG7mDQXAO2YZc5lRILOJt8cLan9JrGk6ya8oYOGOgusQ8H/
         zByXf+gh2qNuq8mRpCdZD3XGBca153700LHJ09ENaBUy6iy1ECWDKkiE9WqE7hhpZWzH
         XbUJwGi/fq33ykisGTsxa7fpakEQWZIiK5mQtxw8NrKvdsRar7/FCXCLzZQ/BYt44D3s
         1uHglvTJ4BH9mhlMJHsfKlLiUaSlLKQZQ1rd5BZk44TZn3ZchVu8OrrjaElXHf/v4wsc
         x0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m2fOM7m78o4CAWPlVEeyBmVxnJecOkxduoPEfpTUoqM=;
        b=xO7xZPQEBBrpfuXHTl0CiNNzEWWNvLX8UF1For3tfZ156F6DyKDSexyjyWWcKzvILe
         8s0cz/aZRsdgFLHYBK8gnrAnZiDNQ5vlE9OGzUvN0z+53EfDBnQHP5yNNIeXX8myoH6o
         QQWWN4Lm3WvSu1vMBM8scM/gZfz5NngatR6z6qVD3C0dOfo2SpPTjTrHJW1g/9XNxN7T
         f3ErlSXNcEnqjUUGZkBifWUaRiAeYLXFRV6ICkktifn1QvePpJHxSXTq8TfOhBGuraZW
         QNw28ApGvvnl52l80Gpp2P91DGF42BaaDRGxlyIZaj9yDVrNclXurGQeRfrb3Jr52U/j
         RN4g==
X-Gm-Message-State: ACrzQf23HY0LxyFpXZHZOJO2JJ8Dg1Qo3Kf+z4cYlPiogjqfX2YMCefz
        y2bD2R2pt428iPAX/ATZJmEMUg==
X-Google-Smtp-Source: AMsMyM7/xaxHvv8sFAacrmC3C9kRoiHF/tQFY79ULG42XLdzn/0slDP53+/D8kN4hBRc1mIuFfg0Gw==
X-Received: by 2002:a05:600c:3d18:b0:3cf:4c1e:5812 with SMTP id bh24-20020a05600c3d1800b003cf4c1e5812mr30145636wmb.192.1667494424902;
        Thu, 03 Nov 2022 09:53:44 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c465200b003b497138093sm256033wmo.47.2022.11.03.09.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 09:53:44 -0700 (PDT)
Message-ID: <b053edbd-2dbd-f3f3-7f6c-c70d5b58a00d@arista.com>
Date:   Thu, 3 Nov 2022 16:53:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 2/2] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
References: <20221102211350.625011-1-dima@arista.com>
 <20221102211350.625011-3-dima@arista.com>
 <CANn89iLbOikuG9+Tna9M0Gr-diF2vFpfMV8MDP8rBuN49+Mwrg@mail.gmail.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <CANn89iLbOikuG9+Tna9M0Gr-diF2vFpfMV8MDP8rBuN49+Mwrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/22 21:25, Eric Dumazet wrote:
> On Wed, Nov 2, 2022 at 2:14 PM Dmitry Safonov <dima@arista.com> wrote:
[..]
>> @@ -337,11 +338,13 @@ EXPORT_SYMBOL(tcp_time_wait);
>>  void tcp_twsk_destructor(struct sock *sk)
>>  {
>>  #ifdef CONFIG_TCP_MD5SIG
>> -       if (static_branch_unlikely(&tcp_md5_needed)) {
>> +       if (static_branch_unlikely(&tcp_md5_needed.key)) {
>>                 struct tcp_timewait_sock *twsk = tcp_twsk(sk);
>>
>> -               if (twsk->tw_md5_key)
>> +               if (twsk->tw_md5_key) {
> 
> Orthogonal to this patch, but I wonder why we do not clear
> twsk->tw_md5_key before kfree_rcu()
> 
> It seems a lookup could catch the invalid pointer.
> 
>>                         kfree_rcu(twsk->tw_md5_key, rcu);
>> +                       static_branch_slow_dec_deferred(&tcp_md5_needed);
>> +               }
>>         }

I looked into that, it seems tcp_twsk_destructor() is called from
inet_twsk_free(), which is either called from:
1. inet_twsk_put(), protected by tw->tw_refcnt
2. sock_gen_put(), protected by the same sk->sk_refcnt

So, in result, if I understand correctly, lookups should fail on ref
counter check. Maybe I'm missing something, but clearing here seems not
necessary?

I can add rcu_assign_pointer() just in case the destruction path changes
in v2 if you think it's worth it :-)

Thanks,
          Dmitry
