Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F6D46CFF
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfFNXov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:44:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41303 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFNXou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:44:50 -0400
Received: by mail-pl1-f193.google.com with SMTP id s24so1605187plr.8
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=82Sipv6f+1SwoOOyCvdjLYNue6LpMCVG0JvtR3Nxujw=;
        b=d1xK6rEBk9KizmE45+OOsXReADgOKOOYclinaPrT1ruow517xEiAY28znfS/zh5OzT
         yQLDzFK5cPt7zvuSWGDpnv5sN2PZ4A2sBjPAQ7kg29Y3DiyRTPsbN+6PC0b4OmbZrWgp
         /31GzqKvpYKa9/N2KniDqsxRpR69qhxr4+I8BbFstgBILb01dNFCbxTpI19mOqY4/S9m
         K2HaphHEOxTwiI08+5e5X22mYfWeEc5O/mxWW2UXgxjuP1iKgG4PGXDgfKALSQfucJb/
         BuBrvhPQZVJQ3doJbzezb+nZAwJPFT/SVmeOQVnSAf66O9veM/qryzKB+qkDWol6tCAL
         AffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=82Sipv6f+1SwoOOyCvdjLYNue6LpMCVG0JvtR3Nxujw=;
        b=tELVxvVsZzCrFLpCVB8tSpXOuotK2yJHvt2d3q+Jk3o3KUVUhwHMdnpTRZz2QFmsOi
         Uf0l+hJy7GmJUBD6rDRZohUug9dF5enhEVfasNZzwKwIkJlaEixWLI4NDkB9J4mXTXBu
         Yaktufbg4VCryB96+U6KHBiLedr8G2UAFeRekB4cealbV2I0p0tIdO2WAsFRLykfyukX
         gZZM7g6M3QCOBG3scxusgcYltY7VA5s4aWr/uxuAe/mzxUl/xtxP5AB63lrEAnTXk/BZ
         RSleE0HvrgCTbX0dq/EiFfhEKNWxz0X/VOkES3xezV5RAYka2Lrk2zzJOeqeWoKWGkUv
         Qykw==
X-Gm-Message-State: APjAAAWrQ71JCmXxQ9RYDBjowrW5kZ0TmreImAh02Mi/Bu9XxoNcw62W
        u75be/LMSb/vqPaoI6KI/Xo=
X-Google-Smtp-Source: APXvYqxwLbP7kwbibWi0x6BCP2akNqoFtN6KF8KZznUJNyzvXXQGcsvJ1ck5u0UYpNxCE821CBjsuw==
X-Received: by 2002:a17:902:31a4:: with SMTP id x33mr66391673plb.331.1560555890152;
        Fri, 14 Jun 2019 16:44:50 -0700 (PDT)
Received: from [172.27.227.153] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id s5sm3759776pgj.60.2019.06.14.16.44.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 16:44:48 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/2] net: sched: add mpls manipulation actions
 to TC
To:     John Hurley <john.hurley@netronome.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
References: <1560524330-25721-1-git-send-email-john.hurley@netronome.com>
 <1560524330-25721-2-git-send-email-john.hurley@netronome.com>
 <24000ac2-a8b6-9908-d8a9-67a66f03b26d@gmail.com>
 <CAK+XE=nTcd+oB=UCe-gHMs7XNtS1w8GUWMwxgGQFtzp5CRz+LA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d6f09f3c-6643-fe2f-6b20-4275641f497f@gmail.com>
Date:   Fri, 14 Jun 2019 17:44:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAK+XE=nTcd+oB=UCe-gHMs7XNtS1w8GUWMwxgGQFtzp5CRz+LA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 5:22 PM, John Hurley wrote:
> On Fri, Jun 14, 2019 at 6:22 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 6/14/19 8:58 AM, John Hurley wrote:
>>> Currently, TC offers the ability to match on the MPLS fields of a packet
>>> through the use of the flow_dissector_key_mpls struct. However, as yet, TC
>>> actions do not allow the modification or manipulation of such fields.
>>>
>>> Add a new module that registers TC action ops to allow manipulation of
>>> MPLS. This includes the ability to push and pop headers as well as modify
>>> the contents of new or existing headers. A further action to decrement the
>>> TTL field of an MPLS header is also provided.
>>
>> you have this limited to a single mpls label. It would be more flexible
>> to allow push/pop of N-labels (push probably being the most useful).
>>
> 
> Hi David.
> Multiple push and pop actions can be done by piping them together.
> E.g. for a flower filter that pushes 2 labels to an IP packet you can do:
> 
> tc filter add dev eth0 protocol ip parent ffff: \
>         flower \
>         action mpls push protocol mpls_mc label 10 \
>         action mpls push protocol mpls_mc label 20 \
>         action mirred egress redirect dev eth1

ok, that seems reasonable.

>>> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
>>> new file mode 100644
>>> index 0000000..828a8d9
>>> --- /dev/null
>>> +++ b/net/sched/act_mpls.c
>> ...
>>
>>> +     switch (p->tcfm_action) {
>>> +     case TCA_MPLS_ACT_POP:
>>> +             if (unlikely(!eth_p_mpls(skb->protocol)))
>>> +                     goto out;
>>> +
>>> +             if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
>>> +                     goto drop;
>>> +
>>> +             skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
>>> +             memmove(skb->data + MPLS_HLEN, skb->data, ETH_HLEN);
>>> +
>>> +             __skb_pull(skb, MPLS_HLEN);
>>> +             skb_reset_mac_header(skb);
>>> +             skb_set_network_header(skb, ETH_HLEN);
>>> +
>>> +             tcf_mpls_set_eth_type(skb, p->tcfm_proto);
>>> +             skb->protocol = p->tcfm_proto;
>>
>> This is pop of a single label. It may or may not be the bottom label, so
>> it seems like this should handle both cases and may depend on the
>> packet. If it is the bottom label, then letting the user specify next
>> seems correct but it is not then the protocol needs to stay MPLS.
>>
> 
> Yes, the user is expected to indicate the next protocol after the pop
> even if another mpls label is next.
> We're trying to cater for supporting mpls_uc and mpls_mc ethtypes.
> So you could in theory pop the top mpls unicast header and set the
> next to multicast.
> We expect the user to know what the next header is so enforce that
> they give that information.
> Do you agree with this or should we add more checks around the BoS bit?

that's a tough one. tc filters are very advanced and users should
understand what they are doing. On the other hand, a mistake means
spewing packets that could cause problems elsewhere and best case are
just dropped. If this is inline with other actions (ability to generate
bogus packets on a mistake) then I guess it is fine.


