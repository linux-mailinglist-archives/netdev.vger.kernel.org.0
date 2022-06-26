Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D198955B3F9
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 22:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiFZUG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 16:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiFZUGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 16:06:54 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500895FAD;
        Sun, 26 Jun 2022 13:06:53 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o16so10290704wra.4;
        Sun, 26 Jun 2022 13:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FTo+6T5cOGS/6r6fOb8WRRmId0zEZsn96kv36lWXteA=;
        b=bfbfHQb0EGLBVt55AaYEx0O5i8agrroLGP9/uH/T9AKQOFTnG7UIphqWIhoRPXLUUL
         9z1IbY6mia8q2outxOGXd3APbnWlbB3YrJC+di5Me97zZm26HinG7f4r1wlRlLOrInm/
         41hD4sSx5XhAZqlLAHFjlNIJpcwpojVn54soR6qVnKinpYYVfqdXayfYbL64VZcBwN7c
         DT/lJ6tC2s9Re1O3OZWxV8fSujNFE4x+/7pQlVnzo+7Of0RB02MP+33tmoDU0AbpZPCT
         ODdsWmkURfXWKCWX7br7AvBhkryaFxhDdX8oXVUxMp+ihD8WVZ8qfrBhLIf/cwSGmE+b
         dWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FTo+6T5cOGS/6r6fOb8WRRmId0zEZsn96kv36lWXteA=;
        b=jiseMtdadAndTMYFPufsohMYwdHy6ClkktT35niJuKuWoWfSgHu5bAMsiTZP8BCPsS
         kjP7/4WHKImdp/SzSi/8Uekk7mdjCMu/IVHfnUHhGnFytyEw4yyw/XqkHIz72cYJoF1C
         wcEQUX/rrjkCBTNYDjbO+yHvV2kljfQeP2aWwJ35E/Gj+3TnnCsb+VdbVsDsmgh5pYMs
         scobproSFFzmYfPUujtCxbe2/17G9GvePeHd3q619PwIj111ol5ilLKwpU2/G6ktvxr9
         j53x6vF/zcYt+wtT7Qm6gw8mH4FlhQL+S1DQC5iU5xJ+k3MJ277bpC0tOAeCZDK0XAP9
         zknQ==
X-Gm-Message-State: AJIora+WIJfOKNGbzoh4SUl4QG86b7MT8G0d6otNjMUMx2CIR03kxtl8
        8hhjzwE26LD1uwRxBD4Bdk8=
X-Google-Smtp-Source: AGRyM1sPH3ekwgKmoKEnXpmO/sL1oVu+JInUhznDLtFtEFcn+zHA2g2xbEoadbT2WjgraNDO8EvSZw==
X-Received: by 2002:a05:6000:10c5:b0:21b:9aed:47e3 with SMTP id b5-20020a05600010c500b0021b9aed47e3mr9490397wrx.570.1656274011704;
        Sun, 26 Jun 2022 13:06:51 -0700 (PDT)
Received: from [192.168.0.17] ([94.14.166.112])
        by smtp.gmail.com with ESMTPSA id m17-20020adfe0d1000000b0021b866397a7sm8602456wri.1.2022.06.26.13.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 13:06:51 -0700 (PDT)
Message-ID: <940fa370-08ce-1d39-d5cc-51de8e853b47@gmail.com>
Date:   Sun, 26 Jun 2022 21:06:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [REGRESSION] connection timeout with routes to VRF
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, Jan Luebbe <jluebbe@lasnet.de>,
        Robert Shearman <robertshearman@gmail.com>,
        Andy Roulin <aroulin@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        regressions@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de>
 <6410890e-333d-5f0e-52f2-1041667c80f8@kernel.org>
From:   Mike Manning <mvrmanning@gmail.com>
In-Reply-To: <6410890e-333d-5f0e-52f2-1041667c80f8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/06/2022 17:44, David Ahern wrote:
> On 6/11/22 5:14 AM, Jan Luebbe wrote:
>> Hi,
>>
>> TL;DR: We think we have found a regression in the handling of VRF route leaking
>> caused by "net: allow binding socket in a VRF when there's an unbound socket"
>> (3c82a21f4320).
> This is the 3rd report in the past few months about this commit.
>
> ...
>
>> Our minimized test case looks like this:
>>  ip rule add pref 32765 from all lookup local
>>  ip rule del pref 0 from all lookup local
>>  ip link add red type vrf table 1000
>>  ip link set red up
>>  ip route add vrf red unreachable default metric 8192
>>  ip addr add dev red 172.16.0.1/24
>>  ip route add 172.16.0.0/24 dev red
>>  ip vrf exec red socat -dd TCP-LISTEN:1234,reuseaddr,fork SYSTEM:"echo connected" &
>>  sleep 1
>>  nc 172.16.0.1 1234 < /dev/null
>>
> ...
> Thanks for the detailed analysis and reproducer.
>
>> The partial revert
>> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
>> index 98e1ec1a14f0..41e7f20d7e51 100644
>> --- a/include/net/inet_hashtables.h
>> +++ b/include/net/inet_hashtables.h
>> @@ -310,8 +310,9 @@ static inline struct sock *inet_lookup_listener(struct net *net,
>>  #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
>>         (((__sk)->sk_portpair == (__ports))                     &&      \
>>          ((__sk)->sk_addrpair == (__cookie))                    &&      \
>> -        (((__sk)->sk_bound_dev_if == (__dif))                  ||      \
>> -         ((__sk)->sk_bound_dev_if == (__sdif)))                &&      \
>> +        (!(__sk)->sk_bound_dev_if      ||                              \
>> +          ((__sk)->sk_bound_dev_if == (__dif))                 ||      \
>> +          ((__sk)->sk_bound_dev_if == (__sdif)))               &&      \
>>          net_eq(sock_net(__sk), (__net)))
>>  #else /* 32-bit arch */
>>  #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
>> @@ -321,8 +322,9 @@ static inline struct sock *inet_lookup_listener(struct net *net,
>>         (((__sk)->sk_portpair == (__ports))             &&              \
>>          ((__sk)->sk_daddr      == (__saddr))           &&              \
>>          ((__sk)->sk_rcv_saddr  == (__daddr))           &&              \
>> -        (((__sk)->sk_bound_dev_if == (__dif))          ||              \
>> -         ((__sk)->sk_bound_dev_if == (__sdif)))        &&              \
>> +        (!(__sk)->sk_bound_dev_if      ||                              \
>> +          ((__sk)->sk_bound_dev_if == (__dif))         ||              \
>> +          ((__sk)->sk_bound_dev_if == (__sdif)))       &&              \
>>          net_eq(sock_net(__sk), (__net)))
>>  #endif /* 64-bit arch */
>>
>> restores the original behavior when applied on v5.18. This doesn't apply
>> directly on master, as the macro was replaced by an inline function in "inet:
>> add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()" (4915d50e300e).
>>
>> I have to admit I don't quite understand 3c82a21f4320, so I'm not sure how to
>> proceed. What would be broken by the partial revert above? Are there better ways
>> to configure routing into the VRF than simply "ip route add 172.16.0.0/24 dev
>> red" that still work?
>>
>> Thanks,
>> Jan
>>
>> #regzbot introduced: 3c82a21f4320
>>
>>
>>
> Andy Roulin suggested the same fix to the same problem a few weeks back.
> Let's do it along with a test case in fcnl-test.sh which covers all of
> these vrf permutations.
>
Reverting 3c82a21f4320 would remove isolation between the default and other VRFs
needed when no VRF route leaking has been configured between these: there may be
unintended leaking of packets arriving on a device enslaved to an l3mdev due to
the potential match on an unbound socket.

VRF route leaking requires routes to be present for both ingress and egress VRFs,
the testcase shown only has a route from default to red VRF. The implicit return
path from red to default VRF due to match on unbound socket is no longer present.

Match on unbound socket in all VRFs and not only in the default VRF should be
possible by setting this option (see
https://www.kernel.org/doc/Documentation/networking/vrf.txt):

sysctl net.ipv4.tcp_l3mdev_accept=1

However, for this to work a change similar to the following is needed (I have
shown the change to the macro for consistency with above, it is now an inline fn):

---
 include/net/inet_hashtables.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -300,9 +300,8 @@
 #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
        (((__sk)->sk_portpair == (__ports))                     &&      \
         ((__sk)->sk_addrpair == (__cookie))                    &&      \
-        (((__sk)->sk_bound_dev_if == (__dif))                  ||      \
-         ((__sk)->sk_bound_dev_if == (__sdif)))                &&      \
-        net_eq(sock_net(__sk), (__net)))
+        net_eq(sock_net(__sk), (__net))                        &&      \
+        inet_sk_bound_dev_eq((__net), (__sk)->sk_bound_dev_if, (__dif), (__sdif)))
 #else /* 32-bit arch */
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
        const int __name __deprecated __attribute__((unused))
@@ -311,9 +310,8 @@
        (((__sk)->sk_portpair == (__ports))             &&              \
         ((__sk)->sk_daddr      == (__saddr))           &&              \
         ((__sk)->sk_rcv_saddr  == (__daddr))           &&              \
-        (((__sk)->sk_bound_dev_if == (__dif))          ||              \
-         ((__sk)->sk_bound_dev_if == (__sdif)))        &&              \
-        net_eq(sock_net(__sk), (__net)))
+        net_eq(sock_net(__sk), (__net))                &&              \
+        inet_sk_bound_dev_eq((__net), (__sk)->sk_bound_dev_if, (__dif), (__sdif)))
 #endif /* 64-bit arch */

 /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need


This is to get the testcase to pass, I will leave it to others to comment on
the testcase validity in terms of testing forwarding using commands on 1 device.

The series that 3c82a21f4320 is part of were introduced into the kernel in 2018
by the Vyatta team, who regularly run an extensive test suite for routing protocols
for VRF functionality incl. all combinations of route leaking between default and
other VRFs, so there is no known issue in this regard. I will attempt to reach out
to them so as to advise them of this thread.

Thanks
Mike 
 





 
 



