Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E117A39A24A
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhFCNhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhFCNhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:37:39 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAAEC06174A;
        Thu,  3 Jun 2021 06:35:43 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dg27so7113812edb.12;
        Thu, 03 Jun 2021 06:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZYfxqngFwhkt1d7gs5XvlfRZD53yeD19HFe8Wc4Gag4=;
        b=jyaZFFHLwgK1/KZecrydPu6XdFCXv5NiKES/hZ438YC7o7toLRZjfz6FeSDkfPEn4W
         2oKo9xFMhdW0A50XsB2+FST9wWE2Pcv1lic3Ua0IBhaEiQrLggMo4CjI+hou178QJQyp
         d/oYxu3wjzw3QsfAnQ37B1Zolg8vIpYlMw4LIwuwuuMzjijqJIRSTemD8SNAhJd9ZK5R
         jFvktxsMMFpKoPV2+liW/hiqSBS8NlCkD2GMJHFVzqBFNW5BSp7VWKJm1hWTEWMDKwnZ
         n3aACxzetVe9ffFvouE61B/mfoO1BFuIDs/HSRutPI5UKEFRST+DaD1pfdDqxcG0iLEh
         B7Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZYfxqngFwhkt1d7gs5XvlfRZD53yeD19HFe8Wc4Gag4=;
        b=VuFRB35LQqWGm00Y1j5gJ0JJFUCTVx53qNK0kHTdmZo/XV+cXW33hXyYIHFO7C/RMO
         Xm/HnSgAhsuFlEVB34IP0SorxHzgcCceLJzXQFBJGm2MtLdWJPgvdbbBI3voazVyaDLt
         4LbPKdSKj+H8yEtLm9aDVKpFs/YKOYQdhvXOO+B5yZ8cUADgojOxWnNtUOoqCYji9uJI
         N4mcSJSVwYSc4PtgF2Q3xMjWfWeEuTRq5KyQ0AlTEWlmvEMlW9QAyNTw0guUY7TzuyVv
         7kqD8feBJ4+BUJ8LSQGtXJbeyvmM0K8SQt0E/4SgYz8QruW2Qtc1H3nGvu3dTkaNT3xw
         XRAA==
X-Gm-Message-State: AOAM531IhW7Y2617/RJ9qZyn2yHwqgBvikmeSbHweNtztA4IhnuDZm26
        hrjgQDiKf1cS8RmPCjoLJSVyllsmmgVsB3IpRf/gXw==
X-Google-Smtp-Source: ABdhPJxyNj99fNaDPBz0vv16pUJMVYNrlJW7dc9k+/2ABFB25EsV40zH2QVDS6gOTjvG4PK5CKqpSg==
X-Received: by 2002:a50:cb85:: with SMTP id k5mr39185003edi.170.1622727342192;
        Thu, 03 Jun 2021 06:35:42 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:c45a:f355:cc4:bbb0? ([2a04:241e:502:1d80:c45a:f355:cc4:bbb0])
        by smtp.gmail.com with ESMTPSA id c14sm1529377ejm.4.2021.06.03.06.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 06:35:41 -0700 (PDT)
Subject: Re: [RFCv2 3/3] tcp: Wait for sufficient data in tcp_mtu_probe
To:     Eric Dumazet <edumazet@google.com>,
        Matt Mathis <mattmathis@google.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1622025457.git.cdleonard@gmail.com>
 <e6dac4f513fa2ca96ccb4dcc5b11f96b3f9ddc40.1622025457.git.cdleonard@gmail.com>
 <CANn89iKT9-dsynbQaWywJ=+=mQmqU7uWesmT6iJBCjzyZMTXFg@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <79eaee0b-7046-d658-bfb1-a7df40ba4fe1@gmail.com>
Date:   Thu, 3 Jun 2021 16:35:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANn89iKT9-dsynbQaWywJ=+=mQmqU7uWesmT6iJBCjzyZMTXFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/21 5:35 PM, Eric Dumazet wrote:
> On Wed, May 26, 2021 at 12:38 PM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
>> in order to accumulate enough data" but linux almost never does that.
>>
>> Implement this by returning 0 from tcp_mtu_probe if not enough data is
>> queued locally but some packets are still in flight. This makes mtu
>> probing more likely to happen for applications that do small writes.
>>
>> Only doing this if packets are in flight should ensure that writing will
>> be attempted again later. This is similar to how tcp_mtu_probe already
>> returns zero if the probe doesn't fit inside the receiver window or the
>> congestion window.
>>
>> Control this with a sysctl because this implies a latency tradeoff but
>> only up to one RTT.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   Documentation/networking/ip-sysctl.rst |  5 +++++
>>   include/net/netns/ipv4.h               |  1 +
>>   net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
>>   net/ipv4/tcp_ipv4.c                    |  1 +
>>   net/ipv4/tcp_output.c                  | 18 ++++++++++++++----
>>   5 files changed, 28 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
>> index 7ab52a105a5d..967b7fac35b1 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -349,10 +349,15 @@ tcp_mtu_probe_floor - INTEGER
>>          If MTU probing is enabled this caps the minimum MSS used for search_low
>>          for the connection.
>>
>>          Default : 48
>>
>> +tcp_mtu_probe_waitdata - BOOLEAN
>> +       Wait for enough data for an mtu probe to accumulate on the sender.
>> +
>> +       Default: 1
>> +
>>   tcp_mtu_probe_rack - BOOLEAN
>>          Try to use shorter probes if RACK is also enabled
>>
>>          Default: 1
>>
>> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
>> index b4ff12f25a7f..366e7b325778 100644
>> --- a/include/net/netns/ipv4.h
>> +++ b/include/net/netns/ipv4.h
>> @@ -112,10 +112,11 @@ struct netns_ipv4 {
>>   #ifdef CONFIG_NET_L3_MASTER_DEV
>>          u8 sysctl_tcp_l3mdev_accept;
>>   #endif
>>          u8 sysctl_tcp_mtu_probing;
>>          int sysctl_tcp_mtu_probe_floor;
>> +       int sysctl_tcp_mtu_probe_waitdata;
> 
> If this is a boolean, you should use u8, and place this field to avoid
> adding a hole.
> 
>>          int sysctl_tcp_mtu_probe_rack;
>>          int sysctl_tcp_base_mss;
>>          int sysctl_tcp_min_snd_mss;
>>          int sysctl_tcp_probe_threshold;
>>          u32 sysctl_tcp_probe_interval;
>> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
>> index 275c91fb9cf8..53868b812958 100644
>> --- a/net/ipv4/sysctl_net_ipv4.c
>> +++ b/net/ipv4/sysctl_net_ipv4.c
>> @@ -847,10 +847,17 @@ static struct ctl_table ipv4_net_table[] = {
>>                  .mode           = 0644,
>>                  .proc_handler   = proc_dointvec_minmax,
>>                  .extra1         = &tcp_min_snd_mss_min,
>>                  .extra2         = &tcp_min_snd_mss_max,
>>          },
>> +       {
>> +               .procname       = "tcp_mtu_probe_waitdata",
>> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_waitdata,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0644,
>> +               .proc_handler   = proc_dointvec,
> 
> If this is a boolean, please use proc_dou8vec_minmax, and SYSCTL_ZERO/SYSCTL_ONE
> 
>> +       },
>>          {
>>                  .procname       = "tcp_mtu_probe_rack",
>>                  .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_rack,
>>                  .maxlen         = sizeof(int),
>>                  .mode           = 0644,
>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>> index ed8af4a7325b..940df2ae4636 100644
>> --- a/net/ipv4/tcp_ipv4.c
>> +++ b/net/ipv4/tcp_ipv4.c
>> @@ -2892,10 +2892,11 @@ static int __net_init tcp_sk_init(struct net *net)
>>          net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
>>          net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>>          net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>>          net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
>>          net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
>> +       net->ipv4.sysctl_tcp_mtu_probe_waitdata = 1;
>>          net->ipv4.sysctl_tcp_mtu_probe_rack = 1;
>>
>>          net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
>>          net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
>>          net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index 362f97cfb09e..268e1bac001f 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -2394,14 +2394,10 @@ static int tcp_mtu_probe(struct sock *sk)
>>                   */
>>                  tcp_mtu_check_reprobe(sk);
>>                  return -1;
>>          }
>>
>> -       /* Have enough data in the send queue to probe? */
>> -       if (tp->write_seq - tp->snd_nxt < size_needed)
>> -               return -1;
>> -
>>          /* Can probe fit inside congestion window? */
>>          if (packets_needed > tp->snd_cwnd)
>>                  return -1;
>>
>>          /* Can probe fit inside receiver window? If not then skip probing.
>> @@ -2411,10 +2407,24 @@ static int tcp_mtu_probe(struct sock *sk)
>>           * clear below.
>>           */
>>          if (tp->snd_wnd < size_needed)
>>                  return -1;
>>
>> +       /* Have enough data in the send queue to probe? */
>> +       if (tp->write_seq - tp->snd_nxt < size_needed) {
>> +               /* If packets are already in flight it's safe to wait for more data to
>> +                * accumulate on the sender because writing will be triggered as ACKs
>> +                * arrive.
>> +                * If no packets are in flight returning zero can stall.
>> +                */
>> +               if (net->ipv4.sysctl_tcp_mtu_probe_waitdata &&
> 
> I have serious doubts about RPC traffic.
> Adding one RTT latency is going to make this unlikely to be used.
> 
>> +                   tcp_packets_in_flight(tp))
>> +                       return 0;
>> +               else
>> +                       return -1;
>> +       }
>> +

This could be measured with tcp_rr mode in netperf, right? I've been 
using iperf which is more focused on bandwidth. My expectation would be 
that the "maximum" latency would increase but not the average since MTU 
probing is a rare occurrence.

Another way to implement waiting would be to check sk_wmem_alloc > 
skb->size like autocork does and this would promise zero latency. But 
I'm not sure how to do that correctly. If it's up to tcp_mtu_probe to 
ensure that traffic does not stall then could it set the TSQ_THROTTLED flag?

--
Regards,
Leonard
