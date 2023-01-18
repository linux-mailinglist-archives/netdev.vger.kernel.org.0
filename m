Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6671D671150
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjARCrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 21:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjARCrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:47:19 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063E54FC23;
        Tue, 17 Jan 2023 18:47:19 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id d10so16418479ilc.12;
        Tue, 17 Jan 2023 18:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m1oh72pr5Je6LjMuI02aOI0LbZGIHuBgAU9KYLW46Nw=;
        b=bXcCY8JtgtuPmI/CjQLiYnMu6hvGsdzsQIJKP68c6upgWfNvqSg59LAs5FEquglHoO
         PziJBLLqH8N5RaLuz30l16KlYluTF7RtrhznQAh8ku3rhJIj9hUFodaRsJva+4FFzqMN
         jPqGjGdgeAT6pFZ+C6T1YileP1EK8tfPEkPhPbKqPmtWpybTDhIoqfbMksT3p6WqVzDz
         kpjYywiB0Qz4htxaSMECqgG3Vt+gGgO/tNRcAeCBttAzWXfRv5RtgPTXyU4qTwSzfNTk
         Rp9S54ccJ3si5MMMPwiZe1hxKIVLSC1fkpPZja3jPPL62SCE+IYJvJCUqY00igSE8TpN
         iQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m1oh72pr5Je6LjMuI02aOI0LbZGIHuBgAU9KYLW46Nw=;
        b=nR0WEe8PxuHZ6GYvlpBy4jrLBzy3R570Ad2yzcFIhCQLTLENkdSq09dSG26QND439t
         GXFxICcoGCNWfjw3cHddWHxre247AVyz4UGACuU8W/ooH6tAamYW2O0Ih4mpEyCnfAIP
         RhRmj0MwNZ8gPSHDcLcgkVraJIMdpBP5qjER/nvcf6/I67rIdNAyDNozA8/jxl5uxoPU
         04jF0yHjRU8ii2YPGQyA+dU/LSKfDbpUhBIEuFqDL3XxAJO8yX0pkx4/SdhhRXFhPZjh
         wYqoysQeJ28v5TX/RjE7MVK38pN4GWf8H3k2Fs/aDj3F1a9O9+fPlutwPVwnp/G6b0av
         04Mw==
X-Gm-Message-State: AFqh2kogqgHSY5iSQU/ZIJbYoDtZPWNT7r3mqpTwh37AeRxpHAEK8blY
        fHoshzl6T/F+COzc+Mrml7Y=
X-Google-Smtp-Source: AMrXdXucQ8f9FPR67c3mvitX7U1DEv5oVJw7/PdEtI05I8Lx1vZw17rtbCPCIs7NUIjNdrG4cfclUg==
X-Received: by 2002:a92:cc52:0:b0:30c:1b36:73af with SMTP id t18-20020a92cc52000000b0030c1b3673afmr4432802ilq.25.1674010038384;
        Tue, 17 Jan 2023 18:47:18 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:3dc4:7b4f:e5b1:e4d8? ([2601:282:800:7ed0:3dc4:7b4f:e5b1:e4d8])
        by smtp.googlemail.com with ESMTPSA id s8-20020a056e0210c800b0030eebef5d1dsm3511747ilj.12.2023.01.17.18.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 18:47:17 -0800 (PST)
Message-ID: <54d89f4a-c7ca-2226-64dd-adc81ebbc314@gmail.com>
Date:   Tue, 17 Jan 2023 19:47:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 06/10] cipso_ipv4: use iph_set_totlen in
 skbuff_setattr
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1673666803.git.lucien.xin@gmail.com>
 <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
 <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
 <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com>
 <CADvbK_cR5paEunENmWd62XfXtMSf+MHhhc-S1z_gLWp_dUx=8w@mail.gmail.com>
 <CAHC9VhSk8pYtOJHCZ1uNvv1SJiazWkJVd1BCfyiLCXPMPKe_Pg@mail.gmail.com>
 <CADvbK_ds4ixHgPGA4iKb1kkFc=SF8SXPM-ZL-kb-ZA0B-70Xqg@mail.gmail.com>
 <CAHC9VhR4_ae=QzrUUM=1MZTWJ9MQom0fEAME3b+z+uBrA8PpcQ@mail.gmail.com>
 <CAHC9VhSRgQuyPgio7d9ZNbs53oCvpq3KQJ9gG5rKX67Wn+P6kw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CAHC9VhSRgQuyPgio7d9ZNbs53oCvpq3KQJ9gG5rKX67Wn+P6kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/23 3:46 PM, Paul Moore wrote:
>>
>> In the BIG TCP case, when is the IPv4 header zero'd out?  Currently
>> cipso_v4_skbuff_setattr() is called in the NF_INET_LOCAL_OUT and
>> NF_INET_FORWARD chains, is there an easy way to distinguish between a
>> traditional segmentation offload mechanism, e.g. GSO, and BIG TCP?  If
>> BIG TCP allows for arbitrarily large packets we can just grow the
>> skb->len value as needed and leave the total length field in the IPv4
>> header untouched/zero, but we would need to be able to distinguish
>> between a segmentation offload and BIG TCP.
> 
> Keeping the above questions as they still apply, rather I could still
> use some help understanding what a BIG TCP packet would look like
> during LOCAL_OUT and FORWARD.

skb->len > 64kb. you don't typically look at the IP / IPv6 header and
its total length field and I thought the first patch in the series added
a handler for doing that.

> 
>>>> In the GRO case, is it safe to grow the packet such that skb->len is
>>>> greater than 64k?  I presume that the device/driver is going to split
>>>> the packet anyway and populate the IPv4 total length fields in the
>>>> header anyway, right?  If we can't grow the packet beyond 64k, is
>>>> there some way to signal to the driver/device at runtime that the
>>>> largest packet we can process is 64k minus 40 bytes (for the IPv4
>>>> options)?
>>>
>>> at runtime, not as far as I know.
>>> It's a field of the network device that can be modified by:
>>> # ip link set dev eth0 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
>>
>> I need to look at the OVS case above, but one possibility would be to
>> have the kernel adjust the GSO size down by 40 bytes when
>> CONFIG_NETLABEL is enabled, but that isn't a great option, and not
>> something I consider a first (or second) choice.
> 
> Looking more at the GSO related code, this isn't likely to work.
> 

icsk_ext_hdr_len is adjusted by cipso for its options. Does that not
cover what is needed?

