Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8009751ECB8
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 11:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiEHJ5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 05:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiEHJ5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 05:57:16 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CBA10F4
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 02:53:26 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bv19so21761375ejb.6
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 02:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=5LvV3fpAUN8y3+l+kaRJmRVaviZFzhd845oRrQK9F8A=;
        b=e1auAmb8ignqsyLDU0FBhx+Y5x8efN8bKd6n0jaXZu1wtIn/gCrQ+fKNBIrbJc7tSz
         natE0IfhjI/VUVbN03KjSBUf76GQgDnYJ9zqgopwly6AL2IUXSNIha6IW2v4gfXbw8GH
         tSsCNEXrnNz2zkZZxXMV05xi2hfTIc47sE1GOcuAfLiywxp82nn+UkFfzBGqQq7krmiE
         ws2MurwyM36Dw+D1trSiKKUctKtrrV+Kxt8wVS2/4eKVfX6TPcjG8elt0yYFNGzSPCBw
         XMzmm+il3CSSuk7Oo+goNNIaCDj97VEzRWwES1xub+ZnszU/Zf9uZEM5z62ewO4t5uUk
         Y+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=5LvV3fpAUN8y3+l+kaRJmRVaviZFzhd845oRrQK9F8A=;
        b=7xG0ms8qICh5iURqmuxOl0142auXoQYLTRDbuJgNUD6bCJ7ezvqSR5ZQrRpJT2CHVI
         emEm0hA6QHiSBsA921gzxNPKzQjvwMTt5CVuidMXA0p5D351nqR7ctaYdbfGhN5ro2LH
         llEQdaTa8lx3QzCyi1a+AUwNLeE3L3QAMe4yyJNt8tPBQG7LUbNyOlEA9L6HS7vISSZq
         cS1h/7vUjNX6ZBtqubNeZg0wCbOsNvOMa3vl27g+Hi9g8ceZYJ6lKNe6O4Rjhmn1xmKC
         UR9Q0znoAa0nkt0Dg/xBZPXiVpUNdHl8PPvLVIle3Kt/ipiKU47vElwQSgpvXnuXd7ML
         VGzQ==
X-Gm-Message-State: AOAM532Q8RuVzHT8bRqDVQ9bBERQGUQ2bGSpKD0MHSzSI7A1MCBb1Fbi
        bcysF3qjTny/NkaflTV1zE8=
X-Google-Smtp-Source: ABdhPJwLM8m+0x64mzHqI2zMYF9AXEprVhw97hpSTgnIy+Jr/WqaD90o9L6ho6YREUFpfxglcWNFPQ==
X-Received: by 2002:a17:906:6a26:b0:6f4:6bf8:1efe with SMTP id qw38-20020a1709066a2600b006f46bf81efemr9923158ejc.208.1652003605404;
        Sun, 08 May 2022 02:53:25 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id p26-20020a056402045a00b0042617ba6388sm4698776edw.18.2022.05.08.02.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 02:53:24 -0700 (PDT)
Message-ID: <2c7e6c5f-1006-3f51-362d-249dd12b5547@gmail.com>
Date:   Sun, 8 May 2022 11:53:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com>
In-Reply-To: <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.05.2022 09:44, Rafał Miłecki wrote:
> On 5.05.2022 18:04, Andrew Lunn wrote:
>>> you'll see that most used functions are:
>>> v7_dma_inv_range
>>> __irqentry_text_end
>>> l2c210_inv_range
>>> v7_dma_clean_range
>>> bcma_host_soc_read32
>>> __netif_receive_skb_core
>>> arch_cpu_idle
>>> l2c210_clean_range
>>> fib_table_lookup
>>
>> There is a lot of cache management functions here. Might sound odd,
>> but have you tried disabling SMP? These cache functions need to
>> operate across all CPUs, and the communication between CPUs can slow
>> them down. If there is only one CPU, these cache functions get simpler
>> and faster.
>>
>> It just depends on your workload. If you have 1 CPU loaded to 100% and
>> the other 3 idle, you might see an improvement. If you actually need
>> more than one CPU, it will probably be worse.
> 
> It seems to lower my NAT speed from ~362 Mb/s to 320 Mb/s but it feels
> more stable now (lower variations). Let me spend some time on more
> testing.

For a context I test various kernel commits / configs using:
iperf -t 120 -i 10 -c 192.168.13.1


I did more testing with # CONFIG_SMP is not set

Good thing:
During a single iperf session I get noticably more stable speed.
With SMP: x ± 2,86%
Without SMP: x ± 0,96%

Bad thing:
Across kernel commits / config changes speed still varies.


So disabling CONFIG_SMP won't help me looking for kernel regressions.
