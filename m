Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90D3B68AC
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 20:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbhF1Ssy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 14:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhF1Ssx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 14:48:53 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB228C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 11:46:26 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id o6so8497672oic.9
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=InZ6O7P4i5PC2yCWQ8JPjNlO7eketdvgreaTAqCUTVs=;
        b=TRP1V81cCv+iSrCL5unNMBd3Pbi9HTbcsDHcXew8RouRseVd8bMqTUnfNzJX9sFw2l
         Sd3NJCMiRHazaqf39lGiJQCNf9nVW8Kutor5K7vGemdaqxLgCqvQ+aP6n5B4HqnmSMyK
         MGu341G5oHBr3na77HQ1ufbkE8T0hlBtHm9W5W1CDxDuGsFD+elyhYiUQ08PntUtpg+o
         u0Wto39zTUh84l2MjIBxaKmbNTcbBB3ZWdwV7O3bID3gX+sUHErKami1N1Wn5nm4D29h
         q2vGcb5Qr6CHX9BZKMTJ/YxlWUDW2F7lGBlJ7pkdRO/gQwF+NNaQU0uXF3HbScODcUq9
         9ryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=InZ6O7P4i5PC2yCWQ8JPjNlO7eketdvgreaTAqCUTVs=;
        b=s0zyVDkrgNvBCIJQ+4hEeihkzB09pUMptfuMBs3nG9EiRBPeM8VuSv/Rtd5MUKfWTZ
         x/413CDj61KF1nvpfjotTqfZNZlhgX9cnTlI6iQHumI7Y9S93gbWn+DmrZMP3wh9iuew
         JTvr4X1S7NSGiQbrhTisDX86b0wEUPSTrq6oi2D/gem8JSG7t4Et3aj/bxZekDLJNxcc
         zCahfEQtb8NrquHg1Ms1ekpIRQ6Kfz831Y8TDVa9LnarnTw0S1jLgGyd8IUwTdqqTOPd
         mSfnedWoE32xTdBgklcSnWXDY5/cnRPgJBGEbifzAnn00WPXfbJJZNYROOwKNXwwzZok
         f/Tg==
X-Gm-Message-State: AOAM530sbDKyi5g3HZbB/eGyY5DO8Nf/y/RRd3Yc/6TfqLeGx77in4Ve
        wt1Mso0jBmBOTAtha9pH2cA=
X-Google-Smtp-Source: ABdhPJxpISgtm375BY/lJkm2XwKIYy6Zkms9Do33RS2/ohPhTI4CqUsOzRUtwmmdU1stR9trmDXVkg==
X-Received: by 2002:aca:d50a:: with SMTP id m10mr6405785oig.27.1624905986345;
        Mon, 28 Jun 2021 11:46:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id k13sm3546078otl.50.2021.06.28.11.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 11:46:26 -0700 (PDT)
Subject: Re: [PATCH net-next 0/6] net: reset MAC header consistently across L3
 virtual devices
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Benc <jbenc@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        Andreas Schultz <aschultz@tpip.net>,
        Jonas Bonn <jonas@norrbonn.se>
References: <cover.1624572003.git.gnault@redhat.com>
 <84fe4ab5-4a80-abf8-675f-29a2f8389b1a@gmail.com>
 <20210626205323.GA7042@pc-32.home>
 <2547b53c-9c22-67ec-99fb-e7e2b403f9f1@gmail.com>
 <20210628150436.GA3495@pc-23.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <518fbc71-e3c7-b4d6-10af-c7b20b009a9b@gmail.com>
Date:   Mon, 28 Jun 2021 12:46:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628150436.GA3495@pc-23.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/21 9:04 AM, Guillaume Nault wrote:
> On Sun, Jun 27, 2021 at 09:56:53AM -0600, David Ahern wrote:
>> On 6/26/21 2:53 PM, Guillaume Nault wrote:
>>> On Sat, Jun 26, 2021 at 11:50:19AM -0600, David Ahern wrote:
>>>> On 6/25/21 7:32 AM, Guillaume Nault wrote:
>>>>> Some virtual L3 devices, like vxlan-gpe and gre (in collect_md mode),
>>>>> reset the MAC header pointer after they parsed the outer headers. This
>>>>> accurately reflects the fact that the decapsulated packet is pure L3
>>>>> packet, as that makes the MAC header 0 bytes long (the MAC and network
>>>>> header pointers are equal).
>>>>>
>>>>> However, many L3 devices only adjust the network header after
>>>>> decapsulation and leave the MAC header pointer to its original value.
>>>>> This can confuse other parts of the networking stack, like TC, which
>>>>> then considers the outer headers as one big MAC header.
>>>>>
>>>>> This patch series makes the following L3 tunnels behave like VXLAN-GPE:
>>>>> bareudp, ipip, sit, gre, ip6gre, ip6tnl, gtp.
>>>>>
>>>>> The case of gre is a bit special. It already resets the MAC header
>>>>> pointer in collect_md mode, so only the classical mode needs to be
>>>>> adjusted. However, gre also has a special case that expects the MAC
>>>>> header pointer to keep pointing to the outer header even after
>>>>> decapsulation. Therefore, patch 4 keeps an exception for this case.
>>>>>
>>>>> Ideally, we'd centralise the call to skb_reset_mac_header() in
>>>>> ip_tunnel_rcv(), to avoid manual calls in ipip (patch 2),
>>>>> sit (patch 3) and gre (patch 4). That's unfortunately not feasible
>>>>> currently, because of the gre special case discussed above that
>>>>> precludes us from resetting the MAC header unconditionally.
>>>>
>>>> What about adding a flag to ip_tunnel indicating if it can be done (or
>>>> should not be done since doing it is the most common)?
>>>
>>> That's feasible. I didn't do it here because I wanted to keep the
>>> patch series focused on L3 tunnels. Modifying ip_tunnel_rcv()'s
>>> prototype would also require updating erspan_rcv(), which isn't L3
>>> (erspan carries Ethernet frames). I was feeling such consolidation
>>> would be best done in a follow up patch series.
>>
>> I was thinking a flag in 'struct ip_tunnel'. It's the private data for
>> those netdevices, so a per-instance setting. I haven't walked through
>> the details to know if it would work.
> 
> I didn't think about that. Good idea, that looks perfectly doable. But
> I'd still prefer to centralise the skb_reset_mac_header() call in a
> dedicated patch set. I we did it here, we'd have to not reset the mac
> header by default, to guarantee that unrelated tunnels wouldn't be
> affected.
> However, I think that the default behaviour should be to reset the mac
> header and that only special cases, like the one in ip_gre, should
> explicitely turn that off. Therefore, we'd need a follow up patch
> anyway, to change the way this "reset_mac" flag would be set.
> 
> IMHO, the current approach has the advantage of clearly separating the
> new feature from the refactoring. But if you feel strongly about using
> a flag in struct ip_tunnel, I can rework this series.
> 

I am accustomed to doing refactoring first to add some new feature in
the simplest and clearest way.

