Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8620A39A253
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhFCNjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhFCNjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:39:12 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B270C06174A;
        Thu,  3 Jun 2021 06:37:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gb17so9265699ejc.8;
        Thu, 03 Jun 2021 06:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0U34XCf7Z6UY7gNvwBH2H99XRLQXoEj2LFoDREg120o=;
        b=cAWS+aBgAaeBFSWsR1u55pI/vEHI48buy7FPD5AeUWRQ/3K3Y6dbX9yMhtIL8ox7yL
         iO6meaDNtnFFhPpBPotqtIQDEByDuTVhurcgGrhFkhH5V8pBC0xh3MNCO4DOJdeAVB63
         ztWE0H/U/BfR3xzG1Ka7Mc5mZCfqDgaiTLEFhPVyb/+paWOz6AWdy/8iveR1XBCnzMNM
         iaR45TxYohhemggr79SSELsuUcBjwcrakmLI+JMGV/UQnJPyPWW4890KU/xIk0gZy7HB
         2wUBTXrS9t2c5lFHJF0HsmBnz1a+2UGJOOwxL7cgcmDFpju102dWN79vQDcmJ0oH1WE1
         pOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0U34XCf7Z6UY7gNvwBH2H99XRLQXoEj2LFoDREg120o=;
        b=eK2CWIJHX1DjML6twZ3Zu9eQGR30exVonNzSbnh+tcoXYVP2AloNakvnc3hzZyPHOU
         Cn2zCIHJu1DF9o05PNwpYmUert4J+wBTIRGa1SMgm/uFu6fraX5cGac9fqpAe6NMc+M7
         cX9kG243eAnoSkRtDdkGE+fTgfbDu5rgBN3hjF24tN1yLGsgCMM8A4HzSHyA9wmd6Gv1
         v2ZCMWZusJdhE17r1HPxNfJDeUhoonKQlBdzQYPU4YeQ1t/9bw/mnyiDEwkFZevObpHA
         jFlfiA3mMmOXF0wC0OkU8vwKPn3c3gXkhIVwM/O0lwBkQMLbZ7fBcwPBOLIpVipSvPls
         bpIg==
X-Gm-Message-State: AOAM5335aZpmjgm1RKtybi5zeZcdbyWU7ge3rh0p8IYrReQ1CHQX0na5
        eG1ATex22VMQKAZI5cJYJgK4YcwH2GrBQLzCd2Fy8w==
X-Google-Smtp-Source: ABdhPJygLKLl2SRZUz7RKv0nLgI2d6GY6ptu3TwvF5LEQsU2LCfLGXhdO11gSV/b/+M1Uqz/0sMX4g==
X-Received: by 2002:a17:906:714d:: with SMTP id z13mr10956917ejj.48.1622727433813;
        Thu, 03 Jun 2021 06:37:13 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:c45a:f355:cc4:bbb0? ([2a04:241e:502:1d80:c45a:f355:cc4:bbb0])
        by smtp.gmail.com with ESMTPSA id i12sm1766975edx.13.2021.06.03.06.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 06:37:13 -0700 (PDT)
Subject: Re: [RFCv2 1/3] tcp: Use smaller mtu probes if RACK is enabled
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Matt Mathis <mattmathis@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1622025457.git.cdleonard@gmail.com>
 <750563aba3687119818dac09fc987c27c7152324.1622025457.git.cdleonard@gmail.com>
 <CADVnQynoD=NF2hG6Bs44A0jrnKG=3f97OywS-tq-p-KQAsf5Fg@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <3251fc35-ef83-26fd-4b71-7d5d50945096@gmail.com>
Date:   Thu, 3 Jun 2021 16:37:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CADVnQynoD=NF2hG6Bs44A0jrnKG=3f97OywS-tq-p-KQAsf5Fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/21 3:11 PM, Neal Cardwell wrote:
> On Wed, May 26, 2021 at 6:38 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> RACK allows detecting a loss in rtt + min_rtt / 4 based on just one
>> extra packet. If enabled use this instead of relying of fast retransmit.
> 
> IMHO it would be worth adding some more text to motivate the change,
> to justify the added complexity and risk from the change. The
> substance of the change seems to be decreasing the requirement for
> PMTU probing from needing roughly 5 packets worth of data to needing
> roughly 3 packets worth of data. It's not clear to me as a reader of
> this patch by itself that there are lots of applications that very
> often only have 3-4 packets worth of data to send and yet can benefit
> greatly from PMTU discovery.
> 
>> Suggested-by: Neal Cardwell <ncardwell@google.com>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   Documentation/networking/ip-sysctl.rst |  5 +++++
>>   include/net/netns/ipv4.h               |  1 +
>>   net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
>>   net/ipv4/tcp_ipv4.c                    |  1 +
>>   net/ipv4/tcp_output.c                  | 26 +++++++++++++++++++++++++-
>>   5 files changed, 39 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
>> index a5c250044500..7ab52a105a5d 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -349,10 +349,15 @@ tcp_mtu_probe_floor - INTEGER
>>          If MTU probing is enabled this caps the minimum MSS used for search_low
>>          for the connection.
>>
>>          Default : 48
>>
>> +tcp_mtu_probe_rack - BOOLEAN
>> +       Try to use shorter probes if RACK is also enabled
>> +
>> +       Default: 1
> 
> I  would vote to not have a sysctl for this. If we think it's a good
> idea to allow MTU probing with a smaller amount of data if RACK is
> enabled (which seems true to me), then this is a low-risk enough
> change that we should just change the behavior.
> 
>>   tcp_min_snd_mss - INTEGER
>>          TCP SYN and SYNACK messages usually advertise an ADVMSS option,
>>          as described in RFC 1122 and RFC 6691.
>>
>>          If this ADVMSS option is smaller than tcp_min_snd_mss,
>> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
>> index 746c80cd4257..b4ff12f25a7f 100644
>> --- a/include/net/netns/ipv4.h
>> +++ b/include/net/netns/ipv4.h
>> @@ -112,10 +112,11 @@ struct netns_ipv4 {
>>   #ifdef CONFIG_NET_L3_MASTER_DEV
>>          u8 sysctl_tcp_l3mdev_accept;
>>   #endif
>>          u8 sysctl_tcp_mtu_probing;
>>          int sysctl_tcp_mtu_probe_floor;
>> +       int sysctl_tcp_mtu_probe_rack;
>>          int sysctl_tcp_base_mss;
>>          int sysctl_tcp_min_snd_mss;
>>          int sysctl_tcp_probe_threshold;
>>          u32 sysctl_tcp_probe_interval;
>>
>> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
>> index 4fa77f182dcb..275c91fb9cf8 100644
>> --- a/net/ipv4/sysctl_net_ipv4.c
>> +++ b/net/ipv4/sysctl_net_ipv4.c
>> @@ -847,10 +847,17 @@ static struct ctl_table ipv4_net_table[] = {
>>                  .mode           = 0644,
>>                  .proc_handler   = proc_dointvec_minmax,
>>                  .extra1         = &tcp_min_snd_mss_min,
>>                  .extra2         = &tcp_min_snd_mss_max,
>>          },
>> +       {
>> +               .procname       = "tcp_mtu_probe_rack",
>> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_rack,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0644,
>> +               .proc_handler   = proc_dointvec,
>> +       },
>>          {
>>                  .procname       = "tcp_probe_threshold",
>>                  .data           = &init_net.ipv4.sysctl_tcp_probe_threshold,
>>                  .maxlen         = sizeof(int),
>>                  .mode           = 0644,
>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>> index 4f5b68a90be9..ed8af4a7325b 100644
>> --- a/net/ipv4/tcp_ipv4.c
>> +++ b/net/ipv4/tcp_ipv4.c
>> @@ -2892,10 +2892,11 @@ static int __net_init tcp_sk_init(struct net *net)
>>          net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
>>          net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>>          net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>>          net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
>>          net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
>> +       net->ipv4.sysctl_tcp_mtu_probe_rack = 1;
>>
>>          net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
>>          net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
>>          net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
>>
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index bde781f46b41..9691f435477b 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -2311,10 +2311,19 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
>>          }
>>
>>          return true;
>>   }
>>
>> +/* Check if rack is supported for current connection */
>> +static int tcp_mtu_probe_is_rack(const struct sock *sk)
>> +{
>> +       struct net *net = sock_net(sk);
>> +
>> +       return (net->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION &&
>> +                       net->ipv4.sysctl_tcp_mtu_probe_rack);
>> +}
> 
> You may want to use the existing helper, tcp_is_rack(), by moving it
> to include/net/tcp.h

OK, for this and other comments.

Initially I though that maybe a more elaborate check is required but it 
seems to be only up to the sender to keep individual timeouts.

--
Regards,
Leonard
