Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C465C20F93B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbgF3QQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbgF3QQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:16:35 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EDAC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:16:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id c1so2421031pja.5
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DdNevBVCcv2Dza8iIbtIA073E2FbcvI1ZC+/Q1375IE=;
        b=qybVw94q1nCqo3VBi2OHGzrHGGhwwiSlpfmMJmOUU0bahvyTXrLavEmaWgDhDpCra5
         0Eg+849dv8kK6r4mf6qokfjO9xGkB0/inNGQXlvx/Wq/X8h66RgXcyMmkNX3k95PmnpU
         Es7ZsT+COlyg0qEOvknjt4QvJDvRUzGgtbCFx6W99ira+x1TpJ0O2UphfbsorseMDfhE
         562FovGTIYnJFHxh4I8Ye/3aGxPQyjPYggPfXLxAD8FzpRTRkRgIQAyGRTQrZqMCJpKV
         XtqctqmQ3u/9fVpjE8y780C9jdwAa5BbD4Wfru8175oemcx/blxOspgNxv+2KkAb2sSW
         3hlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DdNevBVCcv2Dza8iIbtIA073E2FbcvI1ZC+/Q1375IE=;
        b=cxpXgd6SFNtrKLO/sEKc43A8EbZ/pJ5XgGW3SJfxPRu4BjVEqiFwHLOir0GDGK+EC6
         MdGCpmGXAQf5jdSP6Qv1hQcpDsQymG5qOr4otRPfMRA8xKjXwMCSBjtMb3MrLlmQRntr
         BK742EHHixJZDVlA6Szm6I5r7aSWNhT5QDV1LQZ4Ao7GAtZ6aYHy20Vj+K4TqMsUffip
         2xuMUEauZnISqOnNgmsJYwc5sofnXi0xHlX93lGQ2JV8CpQB77GkOjcslHYylo5ZjgVH
         KeXs4CtJ4oOnUursFjWHgoM1twHDZTnS7njakJNxM+DOBTZEhAxH3mBK7RbLi7d1HPRP
         KyBA==
X-Gm-Message-State: AOAM5306MfgcIphdGtcwUkOG6HdEjCZmKCHALZMQA8QMrPcnzYoq2LcM
        Yu+PZ+UI3lZHwG0lWbHrhfSN5W2t
X-Google-Smtp-Source: ABdhPJwoQ/4znRU+s5YS5Mn6x113nUVbraQGpYrpQag7V+Rl3UQu2rYSOR4uSZx41zyfmbY3OBJuwQ==
X-Received: by 2002:a17:902:9346:: with SMTP id g6mr16753271plp.77.1593533795018;
        Tue, 30 Jun 2020 09:16:35 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 193sm3100315pfz.85.2020.06.30.09.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 09:16:33 -0700 (PDT)
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Tom Herbert <tom@herbertland.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
 <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com>
 <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
 <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com>
 <CALx6S37vDy=0rCC7FPrgfi9NUr0w9dVvtRQ3LhiZ7GqoX4xBPw@mail.gmail.com>
 <CA+FuTSddo8Nsj4ri3gC0tDm7Oe4nrvCqyxkj14QWswUs4vNHLw@mail.gmail.com>
 <CAF=yD-JDvo=OB+f4Sg8MDxPSiUEe7FVN_pkOZ6EUfuZTr4eEwQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <322c9715-8ad0-a9b3-9970-087b53ecacdb@gmail.com>
Date:   Tue, 30 Jun 2020 09:16:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-JDvo=OB+f4Sg8MDxPSiUEe7FVN_pkOZ6EUfuZTr4eEwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/20 6:57 AM, Willem de Bruijn wrote:
> On Mon, Jun 29, 2020 at 10:19 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>
>> On Mon, Jun 29, 2020 at 8:37 PM Tom Herbert <tom@herbertland.com> wrote:
>>>
>>> On Mon, Jun 29, 2020 at 4:07 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 6/29/20 2:30 PM, Willem de Bruijn wrote:
>>>>> On Mon, Jun 29, 2020 at 5:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 6/29/20 9:57 AM, Willem de Bruijn wrote:
>>>>>>> From: Willem de Bruijn <willemb@google.com>
>>>>>>>
>>>>>>> ICMP messages may include an extension structure after the original
>>>>>>> datagram. RFC 4884 standardized this behavior.
>>>>>>>
>>>>>>> It introduces an explicit original datagram length field in the ICMP
>>>>>>> header to delineate the original datagram from the extension struct.
>>>>>>>
>>>>>>> Return this field when reading an ICMP error from the error queue.
>>>>>>
>>>>>> RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
>>>>>> second word of icmp header.
>>>>>>
>>>>>> Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?
>>>>>>
>>>>>> Should we add an element in the union to make this a little bit more explicit/readable ?
>>>>>>
>>>>>> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
>>>>>> index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
>>>>>> --- a/include/uapi/linux/icmp.h
>>>>>> +++ b/include/uapi/linux/icmp.h
>>>>>> @@ -76,6 +76,7 @@ struct icmphdr {
>>>>>>                 __be16  sequence;
>>>>>>         } echo;
>>>>>>         __be32  gateway;
>>>>>> +       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
>>>>>>         struct {
>>>>>>                 __be16  __unused;
>>>>>>                 __be16  mtu;
>>>>>
>>>>> Okay. How about a variant of the existing struct frag?
>>>>>
>>>>> @@ -80,6 +80,11 @@ struct icmphdr {
>>>>>                 __be16  __unused;
>>>>>                 __be16  mtu;
>>>>>         } frag;
>>>>> +       struct {
>>>>> +               __u8    __unused;
>>>>> +               __u8    length;
>>>>> +               __be16  mtu;
>>>>> +       } rfc_4884;
>>>>>         __u8    reserved[4];
>>>>>    } un;
>>>>>
>>>>
>>>> Sure, but my point was later in the code :
>>>>
>>>>>>> +     if (inet_sk(sk)->recverr_rfc4884)
>>>>>>> +             info = ntohl(icmp_hdr(skb)->un.gateway);
>>>>>>
>>>>>> ntohl(icmp_hdr(skb)->un.second_word);
>>>>
>>>> If you leave there "info = ntohl(icmp_hdr(skb)->un.gateway)" it is a bit hard for someone
>>>> reading linux kernel code to understand why we do this.
>>>>
>>> It's also potentially problematic. The other bits are Unused, which
>>> isn't the same thing as necessarily being zero. Userspace might assume
>>> that info is the length without checking its bounded.
>>
>> It shouldn't. The icmp type and code are passed in sock_extended_err
>> as ee_type and ee_code. So it can demultiplex the meaning of the rest
>> of the icmp header.
>>
>> It just needs access to the other 32-bits, which indeed are context
>> sensitive. It makes more sense to me to let userspace demultiplex this
>> in one place, rather than demultiplex in the kernel and define a new,
>> likely no simpler, data structure to share with userspace.
>>
>> Specific to RFC 4884, the 8-bit length field coexists with the
>> 16-bit mtu field in case of ICMP_FRAG_NEEDED, so we cannot just pass
>> the first as ee_info in RFC 4884 mode. sock_extended_err additionally
>> has ee_data, but after that we're out of fields, too, so this approach
>> is not very future proof to additional ICMP extensions.
>>
>> On your previous point, it might be useful to define struct rfc_4884
>> equivalent outside struct icmphdr, so that an application can easily
>> cast to that. RFC 4884 itself does not define any extension objects.
>> That is out of scope there, and in my opinion, here. Again, better
>> left to userspace. Especially because as it describes, it standardized
>> the behavior after observing non-compliant, but existing in the wild,
>> proprietary extension variants. Users may have to change how they
>> interpret the fields based on what they have deployed.
> 
> As this just shares the raw icmp header data, I should probably
> change the name to something less specific to RFC 4884.
> 
> Since it would also help with decoding other extensions, such as
> the one you mention in  draft-ietf-6man-icmp-limits-08.
> 
> Unfortunately I cannot simply reserve IP_RECVERR with integer 2.
> Perhaps IP_RECVERR_EXINFO.
> 

Perhaps let the icmp header as is, but provides the extra information
as an explicit ancillary message in ip_recv_error() ?

Really this is all about documentation and providing stable API.

Possible alternative would be to add an union over ee_pad

Legacy applications would always get 0 for ee_pad/ee_length, while
applications enabling IP_RECVERR_RFC4884 would access the wire value.


diff --git a/include/uapi/linux/errqueue.h b/include/uapi/linux/errqueue.h
index ca5cb3e3c6df745aa4c886ba7b4f88179fa22d86..509a5a6ccc555705ef867d7580553d289d559786 100644
--- a/include/uapi/linux/errqueue.h
+++ b/include/uapi/linux/errqueue.h
@@ -10,7 +10,10 @@ struct sock_extended_err {
        __u8    ee_origin;
        __u8    ee_type;
        __u8    ee_code;
-       __u8    ee_pad;
+       union {
+               __u8    ee_pad;
+               __u8    ee_length; /* RFC 4884 (see IP_RECVERR_RFC4884) */
+       };
        __u32   ee_info;
        __u32   ee_data;
 };
