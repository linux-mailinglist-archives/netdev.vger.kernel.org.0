Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1899CA65
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 09:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbfHZH2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 03:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729925AbfHZH2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 03:28:54 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBB6C2A09A0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 07:28:53 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id f11so9069000edb.16
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 00:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DdSO2USv64eYSC6HI4qZiTe/SEXLb6QkOZq2LP5/MRk=;
        b=JVXY/nj4ox8EkHv+prVhbBAb7VEZSOXF9MbKFE456Ta3wSslRzqvhZV76eobx3ygUE
         ZAeaDQPq/W8Fzsi6esyejSsydWkGKxU6rzz0Y2SJpazSALNvaDuD+8/gKdiIG6WZj6Pg
         FTfC3kmgo2tkdlkFULipc4jUrHvrs9UYbhME0R0K1tdzxDZeOp1fSyUPZntqBTCSz+dq
         GLNM4ly5CFeahvHjjgNPorXVNPFmkxg+yN4BfjN8Zs9F1g9UV5RNmpdzksMWFHYmZVdx
         tOTsVPRQssAcD1ln/Af7SI9jjTEi8juFavpSe4jrskR2q8wbrDkZaqtw5BQTyLD3hDlr
         ji1Q==
X-Gm-Message-State: APjAAAXOLKMHYH2bWESL4NKv/QyTNUhPv4fUYxigT/bniPYDedXJPHHc
        xQW2UBtTl11oEo6pLrLAj8rIEJHaLuSKRg0VgCeZs+IByMQxWtNSr8Munt1fL1Ir5/OtsPvolBn
        bSN9GwwHl1HizGJtN
X-Received: by 2002:a17:907:2091:: with SMTP id pv17mr15213656ejb.157.1566804532541;
        Mon, 26 Aug 2019 00:28:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwPC3UtB1fTuC+zIQDOCT/LnBU0/COuV+1NpIGhJAtgp0DT5clXX0I5di7qIrxh7bEfrcJb4g==
X-Received: by 2002:a17:907:2091:: with SMTP id pv17mr15213645ejb.157.1566804532320;
        Mon, 26 Aug 2019 00:28:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id d3sm2729144ejp.77.2019.08.26.00.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 00:28:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D5DC4181C2E; Mon, 26 Aug 2019 09:28:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Akshat Kakkar <akshat.1984@gmail.com>
Cc:     Anton Danilov <littlesmilingcloud@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: Unable to create htb tc classes more than 64K
In-Reply-To: <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com> <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com> <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com> <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com> <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com> <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com> <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com> <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com> <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 26 Aug 2019 09:28:50 +0200
Message-ID: <87k1b0l70t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 8/25/19 7:52 PM, Cong Wang wrote:
>> On Wed, Aug 21, 2019 at 11:00 PM Akshat Kakkar <akshat.1984@gmail.com> wrote:
>>>
>>> On Thu, Aug 22, 2019 at 3:37 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>>> I am using ipset +  iptables to classify and not filters. Besides, if
>>>>> tc is allowing me to define qdisc -> classes -> qdsic -> classes
>>>>> (1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
>>>>> then how can those lowest child classes be actually used or consumed?
>>>>
>>>> Just install tc filters on the lower level too.
>>>
>>> If I understand correctly, you are saying,
>>> instead of :
>>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>>> 0x00000001 fw flowid 1:10
>>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>>> 0x00000002 fw flowid 1:20
>>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>>> 0x00000003 fw flowid 2:10
>>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>>> 0x00000004 fw flowid 2:20
>>>
>>>
>>> I should do this: (i.e. changing parent to just immediate qdisc)
>>> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000001
>>> fw flowid 1:10
>>> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000002
>>> fw flowid 1:20
>>> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000003
>>> fw flowid 2:10
>>> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000004
>>> fw flowid 2:20
>> 
>> 
>> Yes, this is what I meant.
>> 
>> 
>>>
>>> I tried this previously. But there is not change in the result.
>>> Behaviour is exactly same, i.e. I am still getting 100Mbps and not
>>> 100kbps or 300kbps
>>>
>>> Besides, as I mentioned previously I am using ipset + skbprio and not
>>> filters stuff. Filters I used just to test.
>>>
>>> ipset  -N foo hash:ip,mark skbinfo
>>>
>>> ipset -A foo 10.10.10.10, 0x0x00000001 skbprio 1:10
>>> ipset -A foo 10.10.10.20, 0x0x00000002 skbprio 1:20
>>> ipset -A foo 10.10.10.30, 0x0x00000003 skbprio 2:10
>>> ipset -A foo 10.10.10.40, 0x0x00000004 skbprio 2:20
>>>
>>> iptables -A POSTROUTING -j SET --map-set foo dst,dst --map-prio
>> 
>> Hmm..
>> 
>> I am not familiar with ipset, but it seems to save the skbprio into
>> skb->priority, so it doesn't need TC filter to classify it again.
>> 
>> I guess your packets might go to the direct queue of HTB, which
>> bypasses the token bucket. Can you dump the stats and check?
>
> With more than 64K 'classes' I suggest to use a single FQ qdisc [1], and
> an eBPF program using EDT model (Earliest Departure Time)
>
> The BPF program would perform the classification, then find a data structure
> based on the 'class', and then update/maintain class virtual times and skb->tstamp
>
> TBF = bpf_map_lookup_elem(&map, &classid);
>
> uint64_t now = bpf_ktime_get_ns();
> uint64_t time_to_send = max(TBF->time_to_send, now);
>
> time_to_send += (u64)qdisc_pkt_len(skb) * NSEC_PER_SEC / TBF->rate;
> if (time_to_send > TBF->max_horizon) {
>     return TC_ACT_SHOT;
> }
> TBF->time_to_send = time_to_send;
> skb->tstamp = max(time_to_send, skb->tstamp);
> if (time_to_send - now > TBF->ecn_horizon)
>     bpf_skb_ecn_set_ce(skb);
> return TC_ACT_OK;
>
> tools/testing/selftests/bpf/progs/test_tc_edt.c shows something similar.
>
>
> [1]  MQ + FQ if the device is multi-queues.
>
>    Note that this setup scales very well on SMP, since we no longer are forced
>  to use a single HTB hierarchy (protected by a single spinlock)

Wow, this is very cool! Thanks for that walk-through, Eric :)

-Toke
