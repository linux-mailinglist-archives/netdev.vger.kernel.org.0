Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74B85CD1E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfGBKA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:00:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38383 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGBKAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 06:00:55 -0400
Received: by mail-pl1-f194.google.com with SMTP id 9so117531ple.5
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 03:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gcpSo2zN747jEWG2nxHZ/JI8q6vz3s3mmrB7ZXpv6Yk=;
        b=tnnYOTAsHjg/CzlLK41jHssHNTw8jR8fAS8dnA1kdv1dxEbqXyZFnnufaL5sy+j9wC
         Oi5aJuy5YnuS6ECUBQaDmKv2Iw3/tL/VDBpti4U12/8UiTiaR/oYL4f4KQzUeWTpEhQo
         TlMlh+qT0/XhCpENdCD2M1ZDNPnfoe6WIEgI7x11v/eSJDjWf7qihJ7eSkf67kIU2ZyB
         mRRXKHywna0apP/IUvISB1tnhzviZa0FBhUlv/kSprxTrgr5PfFspQS6ECuLD5FSnkdF
         z2gxXwU6yOZNL88rGAiSB3SY2ahlRdFhPA0pUGfQJJJOqHbsZYvi6ott+Fsqjdku+JBE
         5ZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gcpSo2zN747jEWG2nxHZ/JI8q6vz3s3mmrB7ZXpv6Yk=;
        b=ugYFSm6i1oej49l40m0MCV/CWJk1Qg51+zXnIelUCWR119iHZlwmFO+O6Ta24SNlbS
         9kPHgW6BWXjyzOXjhuU3q7iSmeewORI0OiQinWo3cptenWVP09TV7QZKF+kGAnhxsPM3
         n0X5cLZ+bkcZmNoRUwppQs98tgx/1mv9NKeDvWOexJyP9tClqnsaHW/81EGHlzMEHwnA
         5HCkcRo2da4Xgtx5wu9zAq8N1gqKEL72iwyruP5q+Y7eM5uL/7vY0vm7fqgiuzi/RrEc
         gri58zIBzNVD7gPKMVjVoI1kYv//NuhpkEgClSj9eW6JMSDb1jaB+N5t6HTgIvFzv2OA
         4V9g==
X-Gm-Message-State: APjAAAWf2msA782IVnZVBPa+Bh2IvqQ2lv47YwNTA8wv3n0aMhZqrvSP
        Ut24am+YvqHd7QS5U87kO7c=
X-Google-Smtp-Source: APXvYqy6yZ1s1Cu2K46eHDEidHKoG1OH2LR9v97zt7QJm0j3xwR3LHNVZdmbbs3rt8lneGE6On6L/Q==
X-Received: by 2002:a17:902:7603:: with SMTP id k3mr34676335pll.245.1562061654761;
        Tue, 02 Jul 2019 03:00:54 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id a5sm123793pjv.21.2019.07.02.03.00.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 03:00:54 -0700 (PDT)
Subject: Re: [Bridge] VLAN tags in mac_len
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Jiri Pirko <jiri@mellanox.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Zahari Doychev <zahari.doychev@linux.com>, jhs@mojatatu.com,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <68c99662210c8e9e37f198ddf8cb00bccf301c4b.camel@sipsolutions.net>
 <20190615151913.cgrfyflwwnhym4u2@ast-mbp.dhcp.thefacebook.com>
 <e487656b854ca999d14eb8072e5553eb2676a9f4.camel@sipsolutions.net>
 <828a23fe-8466-ae65-7829-620f32aacead@gmail.com>
 <411e7717a68243fc775910ee01fa110c45ce0630.camel@sipsolutions.net>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <0860e598-b270-aee5-4e94-4193e4271356@gmail.com>
Date:   Tue, 2 Jul 2019 19:00:48 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <411e7717a68243fc775910ee01fa110c45ce0630.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/28 20:02, Johannes Berg wrote:
> On Mon, 2019-06-17 at 20:15 +0900, Toshiaki Makita wrote:
>> I'll try to explain the problem I see, which cannot be fixed by option 1...
>> The bug is in tcf_vlan_act(), and mainly in skb->data, not in mac_len.
>>
>> Consider about vlan packets from NIC, but non-hw-accelerated, where
>> vlan devices are configured to receive them.
>>
>> When __netif_receive_skb_core() is called, skb is like this.
>>
>> +-----+------+--------
>>> eth | vlan | TCP/IP
>>
>> +-----+------+--------
>>         ^
>>        data
>>
>> skb->data is at the beginning of the vlan header.
> 
> Right.
> 
>> This is reasonable because we did not process the vlan tag at this point.
> 
> I think with this simple sentence you just threw a whole new semantic
> issue into the mix, one that I at least hadn't considered.
>
> However, it's not clear to me whether we should consider a tag as
> processed or not when we push it.

It's clear that we always insert a tag as unprocessed in a single tag case.
The tag is inserted as hw-offloaded one, and hw-offloaded one is treated
as an unprocessed tag in __netif_receive_skb_core().
The single tag is the most common usage I think, so unprocessed should be
the expected behavior.

Also, tc vlan act was originally introduced to replace OVS vlan action.
It's in fact used as HW offload path of ovs-vswitchd, and should behave the same as
OVS push_vlan action. And push_vlan action inserts a tag as unprocessed one.

> In a sense, this means we should have two different VLAN tag push
> options - considering it processed or unprocessed. Or maybe it should
> always be considered unprocessed, but that's not what we do today.
>
>> Then after vlan_do_receive() (receive the skb on a vlan device), the skb is like this.
>>
>> +-----+--------
>>> eth | TCP/IP
>>
>> +-----+--------
>>         ^
>>        data
>>
>> Or if reorder_hdr is off (which does not remove vlan tags when receiving on vlan devices),
>>
>> +-----+------+--------
>>> eth | vlan | TCP/IP
>>
>> +-----+------+--------
>>                ^
>>               data
>>
>> Relying on this mechanism, we are currently able to handle multiple vlan tags.
>>
>> For example if we have 2 tags,
>>
>> - On __netif_receive_skb_core() invocation
>>
>> +-----+------+------+--------
>>> eth | vlan | vlan | TCP/IP
>>
>> +-----+------+------+--------
>>         ^
>>        data
>>
>> - After first vlan_do_receive()
>>
>> +-----+------+--------
>>> eth | vlan | TCP/IP
>>
>> +-----+------+--------
>>         ^
>>        data
>>
>> Or if reorder_hdr is off,
>>
>> +-----+------+------+--------
>>> eth | vlan | vlan | TCP/IP
>>
>> +-----+------+------+--------
>>                ^
>>               data
>>
>> When we process one tag, the data goes forward by one tag.
> 
> Right, that's a very good point.
> 
>> Now looking at TC vlan case...
>>
>> After it inserts two tags, the skb looks like:
>>
>> (The first tag is in vlan_tci)
>> +-----+------+--------
>>> eth | vlan | TCP/IP
>>
>> +-----+------+--------
>>                ^
>>               data
>>
>> The data pointer went forward before we process it.
>> This is apparently wrong. I think we don't want to (or cannot?) handle cases like this
>> after tcf_vlan_act(). This is why I said we should remember mac_len there.
> 
> Right, makes a lot of sense.
> 
> If you consider a tc VLAN pop, you'd argue that it should pop the next
> unprocessed tag I guess, since if it was processed then it doesn't
> really exist any more (semantically, you still see it if reorder_hdr is
> off), right?

Right.

>> So, my opinion is:
>> On ingress, data pointer can be at the end of vlan header and mac_len probably should
>> include vlan tag length, but only after the vlan tag is processed.
> 
> You're basically arguing for option (3), I think, making VLAN push/pop
> not manipulate mac_len since they can just push/pop *unprocessed* tags,
> right?

Ah, true, on the second thought (2b) is not an appropriate fix but (3) is.
(3) more correctly emulates already tagged packets from wire so it should
cause least confusion.

> I fear this will cause all kinds of trouble in other code. Perhaps we
> need to make this processed/unprocessed state more explicit.

But (3) makes mac_len the same as the already tagged packets from NICs.
If other code cannot handle the packets correctly, they need to be fixed anyway.

As you explained OVS MPLS seems to rely on mac_len adjustment by skb_vlan_push(), but
it means the OVS MPLS code cannot correctly handle double-tagged packets from NICs,
so it needs a fix anyway (use __vlan_get_protocol() to get the real mac_len?).

>> Bridge may need to handle mac_len that is not equal to ETH_HLEN but to me it's a
>> different problem.
> 
> Yes. Like I just said to Daniel, I think we should make bridge handle
> mac_len so that we can just exclude it from this whole discussion.
> Regardless of the mac_len and processed/unprocessed tags, it would just
> work as expected.

That's OK, it should help packets from vlan devices with reorder_hdr off.

Toshiaki Makita
