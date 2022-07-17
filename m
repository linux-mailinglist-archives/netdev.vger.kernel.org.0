Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9315775C3
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 12:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiGQKbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 06:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiGQKbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 06:31:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4A413F6C;
        Sun, 17 Jul 2022 03:31:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id f2so12988662wrr.6;
        Sun, 17 Jul 2022 03:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=9ddRLBik4MFGeOslZ5bwLq8r/Qdveto4r9GUXq1G0SI=;
        b=b/7ie+lL+XpQ5PwBXUL9O/B8qkx9dGwKJ4dFecsiQ5iU6wDETdo3YILs35Q7MqjlxY
         SyT7zTC8ER3G8UA6mYhr5FxjQpgblLsSegsIIOL4dKi2HbvmXiNcwLn1aFHC/qFjj3/D
         Z99nQxzPEPmye+QYOyrmdFiJVxgSf6cmOqyspTlklxpC18AtrL1M5ghmKSTo5hR71ADV
         a9WCkryuTVWzkFETZNkOVWl8zWHnIF8RWPrhklzmJDH5NSMahK8VlYdYIngJs4JSpP1h
         n2Hq6E03EKjKumGN3EZQkEXYhc7D828I7yYPMJVibEkDJJctIxMI5rxQ2Q7jg/KoVj+U
         amVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=9ddRLBik4MFGeOslZ5bwLq8r/Qdveto4r9GUXq1G0SI=;
        b=gcO7/Kd2JVCpO/9yHdOUkWdN8R+80Za7u4h7WwcQ4aRpUM8W2Cykhq1QGpzpVvogXi
         ze1Sq3clP6ucWnmPuYEIxKVgocGGBneOFDyGaxjBZFKybgOO7D4kwNN+I6CVENfqq+dQ
         JXWN7KIJFWpuPhDaa/BQhd0z+PGNHRdz/OrMyDR765vdwpJ6Kt0LTa3mBYtD8ffmEID7
         L0xzwwEi/dlP4cdEBxSU++ulms9XcgJtXJbAxN2QPosqr9CSMHvjmemKLQScscUyeL+R
         xpSujvrxIG5aorGsVrkep/fr7uk4b7m1lnLsJyvzSnusgRTohpA071HL7uzPrDi10L4D
         rIFg==
X-Gm-Message-State: AJIora/hT1ThvLba0InBo+bh8W5Tc8KaoCuDLF5nvTnA6wNg1IRDM0WN
        fvdMcTOje7WiZfFp8s9BTDI=
X-Google-Smtp-Source: AGRyM1u2Yr4kpghsN7mWB/8PUlsy5Ed1gerb1fp1htfAeMIOhnTmM35Fh/IVIf7Rn8fx9QldxfRnWg==
X-Received: by 2002:adf:e112:0:b0:21d:7195:3a8d with SMTP id t18-20020adfe112000000b0021d71953a8dmr20299949wrz.371.1658053891292;
        Sun, 17 Jul 2022 03:31:31 -0700 (PDT)
Received: from [192.168.0.17] ([94.14.168.84])
        by smtp.gmail.com with ESMTPSA id q17-20020a5d6591000000b0021b829d111csm7895657wru.112.2022.07.17.03.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 03:31:30 -0700 (PDT)
Message-ID: <c110dcb5-cfd3-5abd-1533-4f9dc1d45531@gmail.com>
Date:   Sun, 17 Jul 2022 11:31:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Mike Manning <mvrmanning@gmail.com>
Subject: Re: [REGRESSION] connection timeout with routes to VRF
To:     Jan Luebbe <jluebbe@lasnet.de>, David Ahern <dsahern@kernel.org>,
        Robert Shearman <robertshearman@gmail.com>,
        Andy Roulin <aroulin@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        regressions@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de>
 <6410890e-333d-5f0e-52f2-1041667c80f8@kernel.org>
 <940fa370-08ce-1d39-d5cc-51de8e853b47@gmail.com>
 <a32428fa0f3811c25912cd313a6fe1fb4f0a4fac.camel@lasnet.de>
Content-Language: en-US
In-Reply-To: <a32428fa0f3811c25912cd313a6fe1fb4f0a4fac.camel@lasnet.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2022 19:49, Jan Luebbe wrote:
> On Sun, 2022-06-26 at 21:06 +0100, Mike Manning wrote:
> ...
>> Andy Roulin suggested the same fix to the same problem a few weeks back.
>> Let's do it along with a test case in fcnl-test.sh which covers all of
>> these vrf permutations.
>>
> Reverting 3c82a21f4320 would remove isolation between the default and other VRFs
> needed when no VRF route leaking has been configured between these: there may be
> unintended leaking of packets arriving on a device enslaved to an l3mdev due to
> the potential match on an unbound socket.
>
> Thanks for the explanation.
>
> VRF route leaking requires routes to be present for both ingress and egress
> VRFs,
> the testcase shown only has a route from default to red VRF. The implicit return
> path from red to default VRF due to match on unbound socket is no longer
> present.
>
>
> If there is a better configuration that makes this work in the general case
> without a change to the kernel, we'd be happy as well.
>
> In our full setup, the outbound TCP connection (from the default VRF) gets a
> local IP from the interface enslaved to the VRF. Before 3c82a21f4320, this would
> simply work.
>
> How would the return path route from the red VRF to the default VRF look in that
> case?

I am unaware of your topology, can you add a route in the red VRF table
(see 'ip route ls vrf red'), so 'ip route add vrf red <prefix> via
<next-hop>'.

The isolation between default and other VRFs necessary for forwarding
purposes means that running a local process in the default VRF to access
another VRF no longer works since the change made in 2018 that you
identified. So in your example, 'ip vrf exec red nc ...' will work, but
I assume that this is of no use to you.


> Match on unbound socket in all VRFs and not only in the default VRF should be
> possible by setting this option (see
> https://www.kernel.org/doc/Documentation/networking/vrf.txt):
>
>
> Do you mean unbound as in listening socket not bound to an IP with bind()? Or as
> in a socket in the default VRF?

Unbound meaning a socket in the default VRF, as opposed to a a socket
set into a VRF context by binding it to a VRF master interface using
SO_BINDTODEVICE. One must also be able to bind to an appropriate IP
address with bind() regardless of whether the socket is in the default
or another VRF, but that is not relevant here.


> sysctl net.ipv4.tcp_l3mdev_accept=1
>
>
> The sysctl docs sound like this should only apply to listening sockets. In this
> case, we have an unconnected outbound socket.

With this option disabled (by default), any stream socket in a VRF is
only selected for packets in that VRF, this is done in the input path
see e.g. tcp_v4_rcv() for IPv4.


> However, for this to work a change similar to the following is needed (I have
> shown the change to the macro for consistency with above, it is now an inline
> fn):
>
>
> I can also test on master and only used the macro form only because I wasn't
> completely sure how to translate it to the inline function form.
>
> ---
>  include/net/inet_hashtables.h |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -300,9 +300,8 @@
>  #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif,
> __sdif) \
>         (((__sk)->sk_portpair == (__ports))                     &&      \
>          ((__sk)->sk_addrpair == (__cookie))                    &&      \
> -        (((__sk)->sk_bound_dev_if == (__dif))                  ||      \
> -         ((__sk)->sk_bound_dev_if == (__sdif)))                &&      \
> -        net_eq(sock_net(__sk), (__net)))
> +        net_eq(sock_net(__sk), (__net))                        &&      \
> +        inet_sk_bound_dev_eq((__net), (__sk)->sk_bound_dev_if, (__dif),
> (__sdif)))
>  #else /* 32-bit arch */
>  #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
>         const int __name __deprecated __attribute__((unused))
> @@ -311,9 +310,8 @@
>         (((__sk)->sk_portpair == (__ports))             &&              \
>          ((__sk)->sk_daddr      == (__saddr))           &&              \
>          ((__sk)->sk_rcv_saddr  == (__daddr))           &&              \
> -        (((__sk)->sk_bound_dev_if == (__dif))          ||              \
> -         ((__sk)->sk_bound_dev_if == (__sdif)))        &&              \
> -        net_eq(sock_net(__sk), (__net)))
> +        net_eq(sock_net(__sk), (__net))                &&              \
> +        inet_sk_bound_dev_eq((__net), (__sk)->sk_bound_dev_if, (__dif),
> (__sdif)))
>  #endif /* 64-bit arch */
>
>  /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need
>
> I can confirm that this gets my testcase working with 
> net.ipv4.tcp_l3mdev_accept=1.

I can submit this change to kernel-net (modified for latest code) if
David is ok with this approach. It should not have a significant
performance impact (due to the additional kernel parameter check) for
most use-cases, as typically sdif = 0 for the unbound case. I am not in
a position to carry out any performance testing.


> This is to get the testcase to pass, I will leave it to others to comment on
> the testcase validity in terms of testing forwarding using commands on 1 device.
>
> So a network-namespace-based testcase would be preferred? We used the simple
> setup because it seemed easier to understand.
>
> The series that 3c82a21f4320 is part of were introduced into the kernel in 2018
> by the Vyatta team, who regularly run an extensive test suite for routing
> protocols
> for VRF functionality incl. all combinations of route leaking between default
> and
> other VRFs, so there is no known issue in this regard. I will attempt to reach
> out
> to them so as to advise them of this thread.
>
> Are these testcases public? Perhaps I could use them find a better configuration
> that handles our use-case.

The test automation to bring up network topologies is not public, but
the test cases would not be readily transferable for general use in any
case. I have advised the Vyatta team of this thread.


> Thanks,
>
> Jan
>

