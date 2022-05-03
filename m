Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E58519078
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 23:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243066AbiECVq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 17:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiECVq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 17:46:57 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488AB2B1B8
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 14:43:23 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e2so25014062wrh.7
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 14:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=uy5Fap5RR/WBKFIkuBoAooqirYv43B4rsOc7Wy6ONxo=;
        b=FwhHFbHH7CeB5CqxLA3bblkThOeyd9b+Oz4OxpRzpnCL36rp2yVff4gUv430blZdUK
         meKx7UGEq7F/638J9PUYfGYXbYvbj4REBXX4saK+ZcBWeeK/M4hXn90YFaFYQZhxNBb+
         M7DBtMBl58ibxtSUC/zIaX8ZYfJ4XSqzJd0lQRHENpLF3juW14+FNI2WTKe59abH8x2E
         0DeukS7xuJky3hhRI28yA4prP3u+Ud6QgoN8eiKAGXbwLSxkhGcWH7pHcYbgZwQ4ntnS
         3TpHgl09zPwA6gOOi4fKiqSDyWudB91MnM9PNME8r4NUvJKyJ7qeIaejS1H1oyf7uEgi
         Djjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=uy5Fap5RR/WBKFIkuBoAooqirYv43B4rsOc7Wy6ONxo=;
        b=JfmYmiKa2zRUG3gN9w+z1kEYW0AI9vwm2fuXNG6ONaHT4YPH0il7iXwBeVPH1/JH0B
         CADwlP4fe5HJHePnXC5kWhL+9I/14EL8/6btGrTQTobtdCNlSa8LKRAHeTWl86qj6ph0
         PkF09FHlmJTy/HDtOZ2Lm4uJ5gzSeKhBvmGkPOhDdmTtcTL17c1ZP7wnXrXtet1m3ETm
         4/7irXmbHNvDXXDARCzso2Xgi3OZ82+AzalWKGtxU0V9vNu59v6rgWF2mgK/ibkpptwK
         jahkzlnibjpP09GDNQNOqCU3RgwNe7vxKRziLaD/vLlL3pPn/ZDhKxcYMo1nb96LMQPS
         +guw==
X-Gm-Message-State: AOAM532tPl6kpknEC4+JQXeF6GFgL5uHJEJkDy1Z0S7KdFyDa52j2keT
        aTE21W3+z/8umgwEkGH9S/hdvw==
X-Google-Smtp-Source: ABdhPJw5h1HjZ97You/3QSKl8KV/2f6gAxaDhOWZXi3Gr/syDFy2JPR69V8btFcDNn1ftkWX9ox9yg==
X-Received: by 2002:adf:f8cf:0:b0:20a:dfae:aadd with SMTP id f15-20020adff8cf000000b0020adfaeaaddmr14323214wrq.429.1651614201673;
        Tue, 03 May 2022 14:43:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:6419:6a6e:706d:bb0d? ([2a01:e0a:b41:c160:6419:6a6e:706d:bb0d])
        by smtp.gmail.com with ESMTPSA id f11-20020adfc98b000000b0020c5253d910sm10972495wrh.92.2022.05.03.14.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 14:43:20 -0700 (PDT)
Message-ID: <86fce02b-7485-ebfa-b4ba-da9ebf7a11b7@6wind.com>
Date:   Tue, 3 May 2022 23:43:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2] ping: fix address binding wrt vrf
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org
References: <20220429075659.9967-1-nicolas.dichtel@6wind.com>
 <20220429082021.10294-1-nicolas.dichtel@6wind.com>
 <1238b102-f491-a917-3708-0df344015a5b@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <1238b102-f491-a917-3708-0df344015a5b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 29/04/2022 à 16:31, David Ahern a écrit :
> On 4/29/22 2:20 AM, Nicolas Dichtel wrote:
>> When ping_group_range is updated, 'ping' uses the DGRAM ICMP socket,
>> instead of an IP raw socket. In this case, 'ping' is unable to bind its
>> socket to a local address owned by a vrflite.
>>
>> Before the patch:
>> $ sysctl -w net.ipv4.ping_group_range='0  2147483647'
>> $ ip link add blue type vrf table 10
>> $ ip link add foo type dummy
>> $ ip link set foo master blue
>> $ ip link set foo up
>> $ ip addr add 192.168.1.1/24 dev foo
>> $ ip vrf exec blue ping -c1 -I 192.168.1.1 192.168.1.2
>> ping: bind: Cannot assign requested address
>>
>> CC: stable@vger.kernel.org
>> Fixes: 1b69c6d0ae90 ("net: Introduce L3 Master device abstraction")
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> ---
>>
>> v1 -> v2:
>>  add the tag "Cc: stable@vger.kernel.org" for correct stable submission
>>
>>  net/ipv4/ping.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
> 
> please add a test case to fcnal-test.sh. Does ipv6 work ok?
Indeed, ipv6 is missing.

I will add some test cases.
Modifying the sysctl before the vrf tests produce a lot of failures:

With VRF

SYSCTL: net.ipv4.raw_l3mdev_accept=1

SYSCTL: net.ipv4.ping_group_range=0 2147483647

TEST: ping out, VRF bind - ns-B IP                                        [ OK ]
TEST: ping out, device bind - ns-B IP                                     [FAIL]
TEST: ping out, vrf device + dev address bind - ns-B IP                   [FAIL]
TEST: ping out, vrf device + dev address bind - ns-B IP                   [FAIL]
TEST: ping out, vrf device + vrf address bind - ns-B IP                   [FAIL]
TEST: ping out, VRF bind - ns-B loopback IP                               [ OK ]
TEST: ping out, device bind - ns-B loopback IP                            [FAIL]
TEST: ping out, vrf device + dev address bind - ns-B loopback IP          [FAIL]
TEST: ping out, vrf device + dev address bind - ns-B loopback IP          [FAIL]
TEST: ping out, vrf device + vrf address bind - ns-B loopback IP          [FAIL]


Regards,
Nicolas


