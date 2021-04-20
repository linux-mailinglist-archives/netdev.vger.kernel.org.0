Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1341736613E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhDTU5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:57:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233769AbhDTU5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:57:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618952221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jaUBjKAkpa//MM0yQNbkSJ9iNCCsC84Gfu+QxFXy1fQ=;
        b=JT7anWQUmSulAfa60HVnm6utvdwVY9LK33svISn2EflEhCM4gBnWqoEn9d/MGrR+yYL8Fh
        UpVfXC3U4mOAaudgYlugsSrr0PKih1dnVtsXvUW9c4swcfst3584h4Kzg9GAq2nzal5VfZ
        ZOZJyfW9OtittpXC9TjgIq8vujH5Fas=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-ju6xtYuROCWDDoC1_JoDIw-1; Tue, 20 Apr 2021 16:56:59 -0400
X-MC-Unique: ju6xtYuROCWDDoC1_JoDIw-1
Received: by mail-ej1-f69.google.com with SMTP id j25-20020a1709060519b029037cb8ca241aso5234660eja.19
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 13:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jaUBjKAkpa//MM0yQNbkSJ9iNCCsC84Gfu+QxFXy1fQ=;
        b=jzyaL1vL5AHoJRYGfRbhbr3Thv+RzSPQa2qali5cP41K3FE02iPah5kXCIGOi5G/OW
         ymE4RN978YOBlXlBmzS0PfsbjKXTQvlEI5tf1wTi+cz5WLyNvR910q2MumhnsLy7uzbW
         mqxyTT7q1yrPdOEqY0AidVlAdg26zxcV1D/x6Q8WijI916lPVkpVV8TQhOa9AwrXHcng
         PMz32z261UDruriCluoP+zVb0dw8ozQUyuL8vZ/7uybS7qGQIuXb2Ac+FuWSFT6lh/LZ
         +G9sbuFUPC+t0XjgAZOSkMbh0rG+eMx2+O44lIld2SJDo8y40+SrFGm1V4KJ6yyPhp6g
         QX1w==
X-Gm-Message-State: AOAM532xRzW5dEWH61tRCsEiNWlIqzMeETk9KJ1CwHW3V8H9B4od5MP9
        sjfLbZjCYnjOz05xjC5trkASR5xxI5fNpJOX1OADqo2R+vSrT0UZn7FpFlk8aZGPzgebqmCKEJ+
        1cxRL6tnqnHZY7i6Z
X-Received: by 2002:a05:6402:42d1:: with SMTP id i17mr33576665edc.131.1618952218011;
        Tue, 20 Apr 2021 13:56:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTrTCH9Yrw9i8jpig06/5MVIkPXQ98967ofiZhgDvEis+3uowhLeyQe2Umw2AbDnM4TIStvQ==
X-Received: by 2002:a05:6402:42d1:: with SMTP id i17mr33576627edc.131.1618952217597;
        Tue, 20 Apr 2021 13:56:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n11sm284913edo.15.2021.04.20.13.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 13:56:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3363A1804E5; Tue, 20 Apr 2021 22:56:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>, Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>
Subject: Re: [PATCHv8 bpf-next 1/4] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
In-Reply-To: <20210420182854.rsis4npditizm5pu@kafai-mbp.dhcp.thefacebook.com>
References: <20210415135320.4084595-1-liuhangbin@gmail.com>
 <20210415135320.4084595-2-liuhangbin@gmail.com>
 <20210420182854.rsis4npditizm5pu@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 20 Apr 2021 22:56:56 +0200
Message-ID: <87o8e8ektj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Thu, Apr 15, 2021 at 09:53:17PM +0800, Hangbin Liu wrote:
>> From: Jesper Dangaard Brouer <brouer@redhat.com>
>> 
>> This changes the devmap XDP program support to run the program when the
>> bulk queue is flushed instead of before the frame is enqueued. This has
>> a couple of benefits:
>> 
>> - It "sorts" the packets by destination devmap entry, and then runs the
>>   same BPF program on all the packets in sequence. This ensures that we
>>   keep the XDP program and destination device properties hot in I-cache.
>> 
>> - It makes the multicast implementation simpler because it can just
>>   enqueue packets using bq_enqueue() without having to deal with the
>>   devmap program at all.
>> 
>> The drawback is that if the devmap program drops the packet, the enqueue
>> step is redundant. However, arguably this is mostly visible in a
>> micro-benchmark, and with more mixed traffic the I-cache benefit should
>> win out. The performance impact of just this patch is as follows:
>> 
>> When bq_xmit_all() is called from bq_enqueue(), another packet will
>> always be enqueued immediately after, so clearing dev_rx, xdp_prog and
>> flush_node in bq_xmit_all() is redundant. Move the clear to __dev_flush(),
>> and only check them once in bq_enqueue() since they are all modified
>> together.

(side note, while we're modifying the commit message, this paragraph
should probably be moved to the end)

>> Using 10Gb i40e NIC, do XDP_DROP on veth peer, with xdp_redirect_map in
>> sample/bpf, send pkts via pktgen cmd:
>> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
>> 
>> There are about +/- 0.1M deviation for native testing, the performance
>> improved for the base-case, but some drop back with xdp devmap prog attached.
>> 
>> Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
>> 5.12 rc4         | xdp_redirect_map   i40e->i40e  |    1.9M |   9.6M |  8.4M
>> 5.12 rc4         | xdp_redirect_map   i40e->veth  |    1.7M |  11.7M |  9.8M
>> 5.12 rc4 + patch | xdp_redirect_map   i40e->i40e  |    1.9M |   9.8M |  8.0M
>> 5.12 rc4 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  12.0M |  9.4M
> Based on the discussion in v7, a summary of what still needs to be
> addressed will be useful.

That's fair. How about we add a paragraph like this (below the one I
just suggested above that we move to the end):

This change also has the side effect of extending the lifetime of the
RCU-protected xdp_prog that lives inside the devmap entries: Instead of
just living for the duration of the XDP program invocation, the
reference now lives all the way until the bq is flushed. This is safe
because the bq flush happens at the end of the NAPI poll loop, so
everything happens between a local_bh_disable()/local_bh_enable() pair.
However, this is by no means obvious from looking at the call sites; in
particular, some drivers have an additional rcu_read_lock() around only
the XDP program invocation, which only confuses matters further.
Clearing this up will be done in a separate patch series.

