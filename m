Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83643348B3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfFDN3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:29:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37996 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfFDN3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:29:30 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so11992580pfa.5;
        Tue, 04 Jun 2019 06:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OvmpwQmZ7vaSfRzVlH8KlR7iv91xYx06/2zpz8A/i64=;
        b=RxxUL25ile36AS79KU0ALK8rtawvJ3STGBx1jEcaSxFD/Fseodel5K7VOtbXnOGT2Z
         mvTY75czFtcVYRsIEnU+g/kqdgHoNfe5s0Q3kGT/k+KlqrXRoydrMllmhuxmDBUhVkOu
         HXwfPjr+lrnmH8p/Y+rcjaB+PiSZFXisOnfC105Zhd6gdQtmqCCK5Yr8q00oj59rq188
         XM3cf0dOudvBs3ad9OmU/9I6aBRWWuDA8z+s6uNJZnowyZyMWrxGX++L5CTC52EElQp9
         eKfrL1OgbYSDzwLgPsAoQ/+o4ZFJ3XUxWTvuX9EJsnlnRlHLhUTOT1BjK5fTXM0XopOX
         e43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OvmpwQmZ7vaSfRzVlH8KlR7iv91xYx06/2zpz8A/i64=;
        b=CtJSYOVJBx8JC3qzfEzAS6MxTpHobslpvGAKG+2r/jU6th8jYLjFWG10VMfrnZp5iJ
         UH6t+HVAkKV5wIRVQjWFi9Q1NyVZCgsy700o7FJKEGvwJGqWi57dslh2gqoSwN8CRGc7
         KF09sItBSUPUZ8nl0a9XpUuZ74QTG0bcN6aouzw8qO8s375Rtwq1iwQW0iwA7AIop2hB
         xT3GSvBOHpjt804B3q8/NI6v0VRFjGI4YZAtAQtDtkJ3Fi2v9tlKN8qV5l531ehZ9RfF
         a3xOLCaN6wGl3AlmWb7BuWYp2lxiqawU/YSTST8tNDmTG19leF8DHn8T1Ap1EU8n0D+c
         oyIQ==
X-Gm-Message-State: APjAAAXEEHgw7VoSEDFXsXTYAOvJYhPL+FytXQGoEiOLJWMQ4EtaP12m
        qmV7ZO9ELdgBYnyCj9/1+Oo=
X-Google-Smtp-Source: APXvYqz4EZFSw7c2Xx0ENX/aS+uEaVrAI6Sxi0mKBxCMKecqhDNHSmPqiuLRaroPf4Sm7BJWHCWScA==
X-Received: by 2002:a63:2b8a:: with SMTP id r132mr34796570pgr.196.1559654969158;
        Tue, 04 Jun 2019 06:29:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id f21sm839417pjq.2.2019.06.04.06.29.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 06:29:28 -0700 (PDT)
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
To:     Yang Xiao <92siuyang@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
 <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
 <CAKgHYH1=aqmOEsbH-OuSjK4CJ=9FmocjuOg6tsyJNPLEOWVB-g@mail.gmail.com>
 <a0f08b20-41ef-db53-48df-4d8f5333b6af@gmail.com>
 <CAKgHYH0pH3Otj2izYwdcGKhJhjfovi1C-Ez1g2f7P5ahzQEfyw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <364063cb-2ab4-7474-fb73-6d570e8291d1@gmail.com>
Date:   Tue, 4 Jun 2019 06:29:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKgHYH0pH3Otj2izYwdcGKhJhjfovi1C-Ez1g2f7P5ahzQEfyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/19 11:59 PM, Yang Xiao wrote:
> Sorry, I don't get your point. Why is xfrm6_transport_output() buggy?
> The point is that there would be out-of-bound access in
> mip6_destopt_offset() and mip6_destopt_offset(), since there is no
> sanity check for offset.
> 
> There is chance that offset + sizeof(struct ipv6_opt_hdr) > packet_len.
> 
> As described in CVE-2017-9074:  "The IPv6 fragmentation implementation
> in the Linux kernel through 4.11.1 does not consider that the nexthdr
> field may be associated with an invalid option, which allows local
> users to cause a denial of service (out-of-bounds read and BUG)".
> 
> At the same time, there are bugs in  mip6_destopt_offset() and
> mip6_destopt_offset(), which is similar to CVE-2017-7542.
> 

I suggest that you stop the nonsense.

As explained by Herbert, your patch is not needed at all.

If this was needed, then we would have to fix the callers, which you did not.

Citing arbitrary CVE is of no use, we do not copy/paste patches or CVE.



> On Sat, Jun 1, 2019 at 1:35 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 5/30/19 8:04 PM, Yang Xiao wrote:
>>> On Fri, May 31, 2019 at 1:17 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 5/30/19 8:28 AM, Young Xiao wrote:
>>>>> The fragmentation code tries to parse the header options in order
>>>>> to figure out where to insert the fragment option.  Since nexthdr points
>>>>> to an invalid option, the calculation of the size of the network header
>>>>> can made to be much larger than the linear section of the skb and data
>>>>> is read outside of it.
>>>>>
>>>>> This vulnerability is similar to CVE-2017-9074.
>>>>>
>>>>> Signed-off-by: Young Xiao <92siuyang@gmail.com>
>>>>> ---
>>>>>  net/ipv6/mip6.c | 24 ++++++++++++++----------
>>>>>  1 file changed, 14 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
>>>>> index 64f0f7b..30ed1c5 100644
>>>>> --- a/net/ipv6/mip6.c
>>>>> +++ b/net/ipv6/mip6.c
>>>>> @@ -263,8 +263,6 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>>>>>                              u8 **nexthdr)
>>>>>  {
>>>>>       u16 offset = sizeof(struct ipv6hdr);
>>>>> -     struct ipv6_opt_hdr *exthdr =
>>>>> -                                (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
>>>>>       const unsigned char *nh = skb_network_header(skb);
>>>>>       unsigned int packet_len = skb_tail_pointer(skb) -
>>>>>               skb_network_header(skb);
>>>>> @@ -272,7 +270,8 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>>>>>
>>>>>       *nexthdr = &ipv6_hdr(skb)->nexthdr;
>>>>>
>>>>> -     while (offset + 1 <= packet_len) {
>>>>> +     while (offset <= packet_len) {
>>>>> +             struct ipv6_opt_hdr *exthdr;
>>>>>
>>>>>               switch (**nexthdr) {
>>>>>               case NEXTHDR_HOP:
>>>>> @@ -299,12 +298,15 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>>>>>                       return offset;
>>>>>               }
>>>>>
>>>>> +             if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
>>>>> +                     return -EINVAL;
>>>>> +
>>>>> +             exthdr = (struct ipv6_opt_hdr *)(nh + offset);
>>>>>               offset += ipv6_optlen(exthdr);
>>>>>               *nexthdr = &exthdr->nexthdr;
>>>>> -             exthdr = (struct ipv6_opt_hdr *)(nh + offset);
>>>>>       }
>>>>>
>>>>> -     return offset;
>>>>> +     return -EINVAL;
>>>>>  }
>>>>>
>>>>
>>>>
>>>> Ok, but have you checked that callers have been fixed ?
>>>
>>> I've checked the callers. There are two callers:
>>> xfrm6_transport_output() and xfrm6_ro_output(). There are checks in
>>> both function.
>>>
>>> ------------------------------------------------------------------------------
>>>         hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
>>>         if (hdr_len < 0)
>>>                 return hdr_len;
>>> ------------------------------------------------------------------------------
>>>>
>>>> xfrm6_transport_output() seems buggy as well,
>>>> unless the skbs are linearized before entering these functions ?
>>> I can not understand what you mean about this comment.
>>> Could you explain it in more detail.
>>
>>
>> If we had a problem, then the memmove(ipv6_hdr(skb), iph, hdr_len);
>>  in xfrm6_transport_output() would be buggy, since iph could also point to freed memory.
>>
>>
>>
> 
> 
