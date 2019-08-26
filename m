Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06389C975
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbfHZGc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:32:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36934 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfHZGc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:32:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id d16so14632194wme.2;
        Sun, 25 Aug 2019 23:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iOQM757QAYxCOX3hrCBVbTdwFWv0y68ZG1Z8cM2cfis=;
        b=YlqVEOnteRAXr3AyXxEvf5T8pIkl9Aqp5LydmGjEw+Kh9BFPlP5+6PPUU+baYGL/kW
         QHy/QL9HDZUuD9uKYurUKaB47D7CaCwJVexYZafYe6Bx86SdG4X9a5j6rNngwtxPwNeG
         28uDavKdKPhnBis6TnUUO/bIzMJTFW6oO+2BQZKplwQ3Ywao+NqzaX3kH22Y2dFvIDcq
         FAOWTn2yheq0H0br1S06jpiNk3Sep+qptt5vHoR7Kp2ivBsa8wFLRkxMm3wRstVbux1d
         DJvBQDAvbgvquFSDqKEE1sukGLR38norAhfKPq8y3c0nYXWPOxrrDczU6+RAwj7AZzOg
         5Mbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iOQM757QAYxCOX3hrCBVbTdwFWv0y68ZG1Z8cM2cfis=;
        b=PZkwHMW25NGYUZUacJQauj6LjTv2dt9XUGFQUPstzq9Psokup4mw2rJ/frJXNUgPdX
         s5x0n1DIZaYVoQ6s++FyG2mQBmzDgMlYXk6OZPJYtxVucUnD9W9VL62LtouUlPyZ3DF4
         jVzfFzpG9c5GpMysMzaSJ01FoZrAn0N4fsYtd6LDKcDu5afyv9T73pCus+IJzzo8efpl
         1Qk8EnvoAuwSEzD3gDF7jnCv11VhH5kQVC3PXYlORp9GjvxoIuCdGUkn/IEAxQXyBCI3
         1LMltCo8IFUyhOAvImgQA4TeLb0aqMful5IjAm4CmEifnD0+X1evkCf5SNTZn85VQxtb
         jzdg==
X-Gm-Message-State: APjAAAWhTvEzMM++H+egW9PlW0gd93q2uTq+qRNB05gnmaS+1J5L95n5
        ca2HfPhifP6A9bo4APR1ZBffLFrg
X-Google-Smtp-Source: APXvYqxzWGTL1Ib2g6Z45VuwB8hfXWkrKMAM+9711Hn+MeGsuyYvF5itQUsKOanHs+fMoJ4IBMH3WQ==
X-Received: by 2002:a05:600c:48b:: with SMTP id d11mr20559520wme.124.1566801172751;
        Sun, 25 Aug 2019 23:32:52 -0700 (PDT)
Received: from [192.168.8.147] (234.173.185.81.rev.sfr.net. [81.185.173.234])
        by smtp.gmail.com with ESMTPSA id l15sm9151503wru.56.2019.08.25.23.32.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 23:32:52 -0700 (PDT)
Subject: Re: Unable to create htb tc classes more than 64K
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Akshat Kakkar <akshat.1984@gmail.com>
Cc:     Anton Danilov <littlesmilingcloud@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
 <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
 <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com>
 <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com>
 <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
Date:   Mon, 26 Aug 2019 08:32:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/19 7:52 PM, Cong Wang wrote:
> On Wed, Aug 21, 2019 at 11:00 PM Akshat Kakkar <akshat.1984@gmail.com> wrote:
>>
>> On Thu, Aug 22, 2019 at 3:37 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>> I am using ipset +  iptables to classify and not filters. Besides, if
>>>> tc is allowing me to define qdisc -> classes -> qdsic -> classes
>>>> (1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
>>>> then how can those lowest child classes be actually used or consumed?
>>>
>>> Just install tc filters on the lower level too.
>>
>> If I understand correctly, you are saying,
>> instead of :
>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>> 0x00000001 fw flowid 1:10
>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>> 0x00000002 fw flowid 1:20
>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>> 0x00000003 fw flowid 2:10
>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>> 0x00000004 fw flowid 2:20
>>
>>
>> I should do this: (i.e. changing parent to just immediate qdisc)
>> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000001
>> fw flowid 1:10
>> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000002
>> fw flowid 1:20
>> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000003
>> fw flowid 2:10
>> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000004
>> fw flowid 2:20
> 
> 
> Yes, this is what I meant.
> 
> 
>>
>> I tried this previously. But there is not change in the result.
>> Behaviour is exactly same, i.e. I am still getting 100Mbps and not
>> 100kbps or 300kbps
>>
>> Besides, as I mentioned previously I am using ipset + skbprio and not
>> filters stuff. Filters I used just to test.
>>
>> ipset  -N foo hash:ip,mark skbinfo
>>
>> ipset -A foo 10.10.10.10, 0x0x00000001 skbprio 1:10
>> ipset -A foo 10.10.10.20, 0x0x00000002 skbprio 1:20
>> ipset -A foo 10.10.10.30, 0x0x00000003 skbprio 2:10
>> ipset -A foo 10.10.10.40, 0x0x00000004 skbprio 2:20
>>
>> iptables -A POSTROUTING -j SET --map-set foo dst,dst --map-prio
> 
> Hmm..
> 
> I am not familiar with ipset, but it seems to save the skbprio into
> skb->priority, so it doesn't need TC filter to classify it again.
> 
> I guess your packets might go to the direct queue of HTB, which
> bypasses the token bucket. Can you dump the stats and check?

With more than 64K 'classes' I suggest to use a single FQ qdisc [1], and
an eBPF program using EDT model (Earliest Departure Time)

The BPF program would perform the classification, then find a data structure
based on the 'class', and then update/maintain class virtual times and skb->tstamp

TBF = bpf_map_lookup_elem(&map, &classid);

uint64_t now = bpf_ktime_get_ns();
uint64_t time_to_send = max(TBF->time_to_send, now);

time_to_send += (u64)qdisc_pkt_len(skb) * NSEC_PER_SEC / TBF->rate;
if (time_to_send > TBF->max_horizon) {
    return TC_ACT_SHOT;
}
TBF->time_to_send = time_to_send;
skb->tstamp = max(time_to_send, skb->tstamp);
if (time_to_send - now > TBF->ecn_horizon)
    bpf_skb_ecn_set_ce(skb);
return TC_ACT_OK;

tools/testing/selftests/bpf/progs/test_tc_edt.c shows something similar.


[1]  MQ + FQ if the device is multi-queues.

   Note that this setup scales very well on SMP, since we no longer are forced
 to use a single HTB hierarchy (protected by a single spinlock)

