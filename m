Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A6238DF66
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 04:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhEXCyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 22:54:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232108AbhEXCyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 22:54:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621824801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OHCpWszk2k0MKGSbz/oMp6Y4c3mTJaXAiLMSobPSgQg=;
        b=YvolKr8XsByZwrAg0qc56TH7IIweqwtpUZuVblSLmpXx9O3B6pDbrtmPi2q9eGpCxeL87K
        GL0o3HrXma0HnldMPIG2z4A32aFEHbgP9vNaw3tmStT8DDY7SALCKJ6wHjlJzbfk9rZg5p
        abxcGPncMDpyTHzwVgl4ScMmQUFUrbM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-TQrJ8BhhMnONoemK7LQrPw-1; Sun, 23 May 2021 22:53:18 -0400
X-MC-Unique: TQrJ8BhhMnONoemK7LQrPw-1
Received: by mail-pj1-f70.google.com with SMTP id q69-20020a17090a1b4bb029015d3adc1867so9095528pjq.1
        for <netdev@vger.kernel.org>; Sun, 23 May 2021 19:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OHCpWszk2k0MKGSbz/oMp6Y4c3mTJaXAiLMSobPSgQg=;
        b=ZDtSnY0aLWS4whGq6G03vu8CdZHgKHpj1GH7mDIMFnzupeSX6rwmHcKN1ZA925YPsj
         mJH+T73GzM5UbiXAqsG3s6sto0AJ5HNTo9cqXGt+qvFTmXLdp8Qnz2ut8boTfShpo/84
         bOACdeSE3GVEehmmH6ILsaxTyojRuuaZm3RVqoxv0BkTrqIViHkKi+Irsu+OoqRLzPU7
         MERZ295KDuT9JMsDwUjfvyqPmgwOQaD0SElDu43kQ16FLia2GtKJt1MY1saT3S++p+e4
         7/XCnfWxmlUH33QjiLXPjfTctGkrxn8DqaNp5wa7Co034gZQSrdKdDQJkmsouoPMqozB
         mmSQ==
X-Gm-Message-State: AOAM533U4ltFHztY72RcnufM9u4ND4JpbZUiLITEGggd9GC+6zLP7G+j
        yOXr1zsiA4M+OxeXyrwCfP4N+hzFVP9mulhUSVh9RR09QhgCBi8RoS9AuPEp7gPIZxCDhdY9hJU
        NygmPVTb2uiEeUpkT
X-Received: by 2002:a63:74e:: with SMTP id 75mr7415337pgh.200.1621824797359;
        Sun, 23 May 2021 19:53:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzP1ngdwvFX7GKxWKgZ4m6yITaZWeGU+YceEWcYXFbWXp51SlQUq1uR/X6gvfXsGOJdOyWhtQ==
X-Received: by 2002:a63:74e:: with SMTP id 75mr7415321pgh.200.1621824797107;
        Sun, 23 May 2021 19:53:17 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b9sm9335313pfo.107.2021.05.23.19.53.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 19:53:16 -0700 (PDT)
Subject: Re: virtio_net: BQL?
To:     Dave Taht <dave.taht@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        bloat <bloat@lists.bufferbloat.net>
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
 <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
 <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
 <CAA93jw7Vr_pFMsPCrPadqaLGu0BdC-wtCmW2iyHFkHERkaiyWQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a3a9b036-14d1-2f4f-52e6-f0aa1b187003@redhat.com>
Date:   Mon, 24 May 2021 10:53:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAA93jw7Vr_pFMsPCrPadqaLGu0BdC-wtCmW2iyHFkHERkaiyWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/18 上午5:48, Dave Taht 写道:
> On Mon, May 17, 2021 at 1:23 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>> On Mon, May 17, 2021 at 2:44 PM Dave Taht <dave.taht@gmail.com> wrote:
>>> Not really related to this patch, but is there some reason why virtio
>>> has no support for BQL?
>> There have been a few attempts to add it over the years.
>>
>> Most recently, https://lore.kernel.org/lkml/20181205225323.12555-2-mst@redhat.com/
>>
>> That thread has a long discussion. I think the key open issue remains
>>
>> "The tricky part is the mode switching between napi and no napi."
> Oy, vey.
>
> I didn't pay any attention to that discussion, sadly enough.
>
> It's been about that long (2018) since I paid any attention to
> bufferbloat in the cloud and my cloudy provider (linode) switched to
> using virtio when I wasn't looking. For over a year now, I'd been
> getting reports saying that comcast's pie rollout wasn't working as
> well as expected, that evenroute's implementation of sch_cake and sqm
> on inbound wasn't working right, nor pf_sense's and numerous other
> issues at Internet scale.
>
> Last week I ran a string of benchmarks against starlink's new services
> and was really aghast at what I found there, too. but the problem
> seemed deeper than in just the dishy...
>
> Without BQL, there's no backpressure for fq_codel to do its thing.
> None. My measurement servers aren't FQ-codeling
> no matter how much load I put on them. Since that qdisc is the default
> now in most linux distributions, I imagine that the bulk of the cloud
> is now behaving as erratically as linux was in 2011 with enormous
> swings in throughput and latency from GSO/TSO hitting overlarge rx/tx
> rings, [1], breaking various rate estimators in codel, pie and the tcp
> stack itself.
>
> See:
>
> http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_server_fq_codel.png
>
> See the swings in latency there? that's symptomatic of tx/rx rings
> filling and emptying.
>
> it wasn't until I switched my measurement server temporarily over to
> sch_fq that I got a rrul result that was close to the results we used
> to get from the virtualized e1000e drivers we were using in 2014.
>
> http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_server_fq.png
>
> While I have long supported the use of sch_fq for tcp-heavy workloads,
> it still behaves better with bql in place, and fq_codel is better for
> generic workloads... but needs bql based backpressure to kick in.
>
> [1] I really hope I'm overreacting but, um, er, could someone(s) spin
> up a new patch that does bql in some way even half right for this
> driver and help test it? I haven't built a kernel in a while.


I think it's time to obsolete skb_orphan() for virtio-net to get rid of 
a brunch of tricky codes in the current virtio-net driver.

Then we can do BQL on top.

I will prepare some patches to do this (probably with Michael's BQL patch).

Thanks


>
>
>>> On Mon, May 17, 2021 at 11:41 AM Xianting Tian
>>> <xianting.tian@linux.alibaba.com> wrote:
>>>> BUG_ON() uses unlikely in if(), which can be optimized at compile time.
>>>>
>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>>> ---
>>>>    drivers/net/virtio_net.c | 5 ++---
>>>>    1 file changed, 2 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index c921ebf3ae82..212d52204884 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -1646,10 +1646,9 @@ static int xmit_skb(struct send_queue *sq, struct
>>>> sk_buff *skb)
>>>>          else
>>>>                  hdr = skb_vnet_hdr(skb);
>>>>
>>>> -       if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
>>>> +       BUG_ON(virtio_net_hdr_from_skb(skb, &hdr->hdr,
>>>>                                      virtio_is_little_endian(vi->vdev), false,
>>>> -                                   0))
>>>> -               BUG();
>>>> +                                   0));
>>>>
>>>>          if (vi->mergeable_rx_bufs)
>>>>                  hdr->num_buffers = 0;
>>>> --
>>>> 2.17.1
>>>>
>>>
>>> --
>>> Latest Podcast:
>>> https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/
>>>
>>> Dave Täht CTO, TekLibre, LLC
>
>
> --
> Latest Podcast:
> https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/
>
> Dave Täht CTO, TekLibre, LLC
>

