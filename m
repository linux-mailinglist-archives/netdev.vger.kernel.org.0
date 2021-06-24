Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73E93B2F60
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbhFXMxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFXMxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:53:52 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8327DC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:51:32 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id i189so7933443ioa.8
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1NADRoYj4pkavg5nclTouHCuX/m47VlJOzr5yXsfSrU=;
        b=PggHZu0KgJYPk58kheNpw/y+SP9Sf7/6hWST/SuhyV00YZSQydl70RI5nkPVGl7yV3
         sSh4lsEIE28HlSMbvdj0C5sfkYp3F6BhRgSt5Ib44H4ARIJqdmwfINC6C0YKCMI145Za
         O5a2wcCTSAXshGM1T8N935HDNP4ekLI/jhKpqZbeJg7regiPsOrRxx0HcW1v17FFxclq
         0w4lOuJVIVTXqSC2vmq1usosYMNc3ygSKfT7dEVnvClwl/yv38xMTSD/HmxLANKUF4Yt
         tCfm5l3Ip+L90b1+ladKPiOrzeQXaDHv0s9c0FKCmONccLTKeI1HslwoiX7xJ/hLvmDH
         5+LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1NADRoYj4pkavg5nclTouHCuX/m47VlJOzr5yXsfSrU=;
        b=FJdB8F11Fc3aVLwWWYunAOWH0MR8PV9rMp7Gsjq/A6SQofjQsyrnpDD/RZI36kCQml
         3z7qduqkMX0bglXHRdcQO1QaHY/b56CzGQIZ7Wicu8XNvWNEmeCLPtBEJEo4xL0o5Vwk
         RN0dUI3jk6wW5qYOdeq/+NeD1CCc+Cw+YnF0iufmd4fMVVfDqRzEHA/PK4frhviYY7Hi
         jQKyLqRFEx5IVSpfE8IYOjF+11F2fcQ58VL/5hKGHhLANG27UBcWteHOFpc0j4DQfNer
         SM9jdPl1Yx5+AJUzoxm/Lw+trkc6vF8qFxXUqK3x1CypG7NU581IQ2JLsqJ7USjgRl4L
         5Rig==
X-Gm-Message-State: AOAM531dIpy5PzSRtvHgJP8QADNgGyd3z/+h2ROqSElz9fuefom3cLwF
        yeQYV4SJ84caX+Gi8PqIZFL2bfauV/Q=
X-Google-Smtp-Source: ABdhPJwmPl8KYPfyORa7fCWDhK5UpKmsrgDK9ddze2ObgmXQHjl+iAjN4OuQOhdgmhS//DhMpnA/KA==
X-Received: by 2002:a6b:7e47:: with SMTP id k7mr4072726ioq.108.1624539091985;
        Thu, 24 Jun 2021 05:51:31 -0700 (PDT)
Received: from ?IPv6:2601:448:c580:1890:15b4:7430:b456:12c7? ([2601:448:c580:1890:15b4:7430:b456:12c7])
        by smtp.gmail.com with ESMTPSA id e14sm1752289ilq.32.2021.06.24.05.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 05:51:31 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: ICMPV6: add response to ICMPV6 RFC 8335
 PROBE messages
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
References: <7eb62f437120d8686f50811a2aebd7c0f7f73ced.1624358016.git.andreas.a.roeseler@gmail.com>
 <CA+FuTSethFwxSpqLhhdRMkQYnWcQ7YE6SDRQPza5Q72bZw3C3A@mail.gmail.com>
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
Message-ID: <f35779d9-5c8e-3b3c-2395-dcfb999bc1a3@gmail.com>
Date:   Thu, 24 Jun 2021 07:51:29 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSethFwxSpqLhhdRMkQYnWcQ7YE6SDRQPza5Q72bZw3C3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/2021 4:37 PM, Willem de Bruijn wrote:
> On Tue, Jun 22, 2021 at 11:39 AM Andreas Roeseler
> <andreas.a.roeseler@gmail.com> wrote:
>>
>> This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
>> and adds functionality to respond to ICMPV6 PROBE requests.
> 
> How come this was missing from the original patch series that
> introduced the same for IPv4? Did we miss that?

The original patch series added the constants for IPv4 and IPV6, but 
only the response side to IPv4 since the IPv6 handler wasn't complete at 
the time.

> 
> Anyway, makes sense to add to complete the feature.
> 
>> Add a sysctl to enable responses to PROBE messages, and as
>> specified by section 8 of RFC 8335, the sysctl defaults to disabled.
>>
>> Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
>> icmpv6_echo_reply handler.
>>
>> Modify icmpv6_echo_reply to build a PROBE response message based on the
>> queried interface.
>>
>> This patch has been tested using a branch of the iputils git repo which can
>> be found here: https://github.com/Juniper-Clinic-2020/iputils/tree/probe-request
>>
>> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
>> ---
>>   Documentation/networking/ip-sysctl.rst |   6 ++
>>   include/net/netns/ipv6.h               |   1 +
>>   net/ipv6/icmp.c                        | 129 ++++++++++++++++++++++++-
>>   3 files changed, 133 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
>> index b0436d3a4f11..c4bf6e297b64 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -2471,6 +2471,12 @@ echo_ignore_anycast - BOOLEAN
>>
>>          Default: 0
>>
>> +echo_ignore_all - BOOLEAN
>> +        If set to one, then the kernel will respond to RFC 8335 PROBE
>> +        requests sent to it over the IPv6 protocol.
>> +
>> +       Default: 0
>> +
> 
> Copied wrong comment, this should be icmp_echo_enable_probe?
> 
> Or are you suggesting adding both? IPv4 has an echo_ignore_all while
> IPv6 does not. But this feature does not require adding one? Unlike
> the enable_probe toggle.
> 
> Also, perhaps no need for a separate ipv6 version of the existing ipv4 sysctl.

I was originally thinking to have a sysctl for IPv4 and IPv6, but it 
does make sense to enable/disable both with only one sysctl.

> 
>>          memcpy(&tmp_hdr, icmph, sizeof(tmp_hdr));
>> -       tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
>> +       if (probe)
>> +               tmp_hdr.icmp6_type = ICMPV6_EXT_ECHO_REPLY;
>> +       else
>> +               tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
> 
> Instead of this block repeated three times, can do replace the boolean
> probe variable with a type variable and pass that in all three cases
> unconditionally.
> 
>> +       if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST &&
>> +           net->ipv6.sysctl.icmpv6_echo_enable_probe)
>> +               goto build_probe_reply;
> 
> Cannot be reached, as the sysctl is already tested earlier in this function?
> 
>> +send_reply:
>>          if (ip6_append_data(sk, icmpv6_getfrag, &msg,
>>                              skb->len + sizeof(struct icmp6hdr),
>>                              sizeof(struct icmp6hdr), &ipc6, &fl6,
>> @@ -806,6 +833,89 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
>>          icmpv6_xmit_unlock(sk);
>>   out_bh_enable:
>>          local_bh_enable();
>> +       return;
>> +build_probe_reply:
>> +       /* We currently only support probing interfaces on the proxy node
>> +        * Check to ensure L-bit is set
>> +        */
>> +       if (!(ntohs(icmph->icmp6_dataun.u_echo.sequence) & 1))
>> +               goto out_dst_release;
>> +       /* Clear status bits in reply message */
>> +       tmp_hdr.icmp6_dataun.u_echo.sequence &= htons(0xFF00);
>> +       ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
>> +       /* Size of iio is class_type dependent.
>> +        * Only check header here and assign length based on ctype in the switch statement
>> +        */
>> +       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr), &_iio);
>> +       if (!ext_hdr || !iio)
>> +               goto send_mal_query;
>> +       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
>> +               goto send_mal_query;
>> +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
>> +       status = 0;
>> +       dev = NULL;
>> +       switch (iio->extobj_hdr.class_type) {
>> +       case ICMP_EXT_ECHO_CTYPE_NAME:
>> +               iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
>> +               if (ident_len >= IFNAMSIZ)
>> +                       goto send_mal_query;
>> +               memset(buff, 0, sizeof(buff));
>> +               memcpy(buff, &iio->ident.name, ident_len);
>> +               dev = dev_get_by_name(net, buff);
>> +               break;
>> +       case ICMP_EXT_ECHO_CTYPE_INDEX:
>> +               iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
>> +                                        sizeof(iio->ident.ifindex), &_iio);
>> +               if (ident_len != sizeof(iio->ident.ifindex))
>> +                       goto send_mal_query;
>> +               dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
>> +               break;
>> +       case ICMP_EXT_ECHO_CTYPE_ADDR:
>> +               if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
>> +                                iio->ident.addr.ctype3_hdr.addrlen)
>> +                       goto send_mal_query;
>> +               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
>> +               case ICMP_AFI_IP:
>> +                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
>> +                                                sizeof(struct in_addr), &_iio);
>> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
>> +                                        sizeof(struct in_addr))
>> +                               goto send_mal_query;
>> +                       dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
>> +                       break;
>> +               case ICMP_AFI_IP6:
>> +                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
>> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
>> +                                        sizeof(struct in6_addr))
>> +                               goto send_mal_query;
>> +                       dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
>> +                       if (dev)
>> +                               dev_hold(dev);
>> +                       break;
>> +               default:
>> +                       goto send_mal_query;
>> +               }
>> +               break;
>> +       default:
>> +               goto send_mal_query;
>> +       }
>> +       if (!dev) {
>> +               tmp_hdr.icmp6_code = ICMP_EXT_CODE_NO_IF;
>> +               goto send_reply;
>> +       }
>> +       /* Fill bits in reply message */
>> +       if (dev->flags & IFF_UP)
>> +               status |= ICMP_EXT_ECHOREPLY_ACTIVE;
>> +       if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)
>> +               status |= ICMP_EXT_ECHOREPLY_IPV4;
>> +       if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
>> +               status |= ICMP_EXT_ECHOREPLY_IPV6;
>> +       dev_put(dev);
>> +       tmp_hdr.icmp6_dataun.u_echo.sequence |= htons(status);
> 
> This whole block is copied almost (?) verbatim from icmp_echo. Can we
> avoid duplication?

It is copied because I was under the impression that it is generally 
good practice to keep the IPv4 and IPv6 code separate since they can be 
compiled modularly and exist independantly. If this isn't the case, 
where would be the best place to put a separate function to be called by 
both handlers? net/ipv4/icmp.c?

> 
>> +       goto send_reply;
>> +send_mal_query:
>> +       tmp_hdr.icmp6_code = ICMP_EXT_CODE_MAL_QUERY;
>> +       goto send_reply;
>>   }
>>
>>   void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
>> @@ -912,6 +1022,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
>>                          icmpv6_echo_reply(skb);
>>                  break;
>>
>> +       case ICMPV6_EXT_ECHO_REQUEST:
>> +               if (!net->ipv6.sysctl.icmpv6_echo_ignore_all)
>> +                       icmpv6_echo_reply(skb);
> 
> 
>> +               break;
>> +
>>          case ICMPV6_ECHO_REPLY:
>>                  success = ping_rcv(skb);
>>                  break;
>> @@ -1198,6 +1313,13 @@ static struct ctl_table ipv6_icmp_table_template[] = {
>>                  .mode           = 0644,
>>                  .proc_handler = proc_do_large_bitmap,
>>          },
>> +       {
>> +               .procname       = "echo_enable_probe",
>> +               .data           = &init_net.ipv6.sysctl.icmpv6_echo_enable_probe,
>> +               .maxlen         = sizeof(u8),
>> +               .mode           = 0644,
>> +               .proc_handler = proc_dou8vec_minmax,
> 
>                  .extra1         = SYSCTL_ZERO,
>                  .extra2         = SYSCTL_ONE
> 

