Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9767349CA11
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbiAZMu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:50:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234499AbiAZMu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 07:50:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643201457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e9hOV54Md4mkMW4fxi7kpJhvDxIQw3Di2qayJ9be2AQ=;
        b=DLSkFGgW2t4i1H8JMQrzOgXoTqD0KLaiDl8B6ei76G04jVzuUsDUNX+IqzeITKhcKNgMR5
        o/2OodU6UulwYgLWJ+lxqUJId0Vmj127SVFdlFLFcjNGueiIOSNBY4vp3t+LOqP8vkPdf8
        zpdi+P0ZKemknRoCVJ+zyxWAbIBSpps=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-bj-ansXcNNyov2rmDpCf9A-1; Wed, 26 Jan 2022 07:50:56 -0500
X-MC-Unique: bj-ansXcNNyov2rmDpCf9A-1
Received: by mail-ed1-f69.google.com with SMTP id ed6-20020a056402294600b004090fd8a936so2987258edb.23
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 04:50:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e9hOV54Md4mkMW4fxi7kpJhvDxIQw3Di2qayJ9be2AQ=;
        b=EGp956S/2PVX03ZUCYiATyGBLnSL34A5ILY6wdGap+phQ6Rc1B5ougpKurj8VQy2D6
         Vn+v9ypvLainx/7QZv9GS9BCfDoEfpy+O/JyyecpRBx/nyb9UxWA2K7fDfvA5IUMwOGx
         mp7I4mCnmYEQugX9p5EWOrIHUPrYjAHQCLwwYbgaSGEZkQqZ0XYEN6n6Qrk1rRM0k9OL
         f65M6eoW5evL/Jk/AdvBSdCyEHulvGxoojyUYhBmF0cBNEWNglOavOBUmwPJxwIu1Ym6
         dHAH0KGEjX0Zb8k7/Vie7iOa6ysOONuQ8wDikGv6NBbmrO5qCY4j0lMhNv4FWlbeinyq
         0woA==
X-Gm-Message-State: AOAM532z/VuAIhATUtaDEHKawDTrYHAefAqS4dXu/JKdrzbLtAJpy31h
        Hk/twDBJwfoDWkyayFmAXzv69xSa06Pzg8kscR7gXWw/BdVf43dImJzznkBVCzNA/q2W8dqUlko
        x+cV34p8UVA4T4EO+
X-Received: by 2002:a05:6402:4405:: with SMTP id y5mr12529180eda.223.1643201455155;
        Wed, 26 Jan 2022 04:50:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJymMzrQNTBr6KQtAAL2rYnA7z94zIvHXkQfemPJFKG3tbK1JiITdY/yWlO6BrrB0vG5KgMPIQ==
X-Received: by 2002:a05:6402:4405:: with SMTP id y5mr12529108eda.223.1643201454170;
        Wed, 26 Jan 2022 04:50:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a11sm9764879edv.76.2022.01.26.04.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 04:50:53 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E764A1805FA; Wed, 26 Jan 2022 13:50:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, memxor@gmail.com,
        andrii.nakryiko@gmail.com, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
In-Reply-To: <113d070a-6df1-66c2-1586-94591bc5aada@nvidia.com>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
 <YfEwLrB6JqNpdUc0@lore-desk>
 <113d070a-6df1-66c2-1586-94591bc5aada@nvidia.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Jan 2022 13:50:51 +0100
Message-ID: <878rv23bkk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nikolay Aleksandrov <nikolay@nvidia.com> writes:

> On 26/01/2022 13:27, Lorenzo Bianconi wrote:
>>> On 24/01/2022 19:20, Lorenzo Bianconi wrote:
>>>> Similar to bpf_xdp_ct_lookup routine, introduce
>>>> br_fdb_find_port_from_ifindex unstable helper in order to accelerate
>>>> linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
>>>> lookup in the associated bridge fdb table and it will return the
>>>> output ifindex if the destination address is associated to a bridge
>>>> port or -ENODEV for BOM traffic or if lookup fails.
>>>>
>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>> ---
>>>>  net/bridge/br.c         | 21 +++++++++++++
>>>>  net/bridge/br_fdb.c     | 67 +++++++++++++++++++++++++++++++++++------
>>>>  net/bridge/br_private.h | 12 ++++++++
>>>>  3 files changed, 91 insertions(+), 9 deletions(-)
>>>>
>>>
>>> Hi Lorenzo,
>> 
>> Hi Nikolay,
>> 
>> thx for the review.
>> 
>>> Please CC bridge maintainers for bridge-related patches, I've added Roopa and the
>>> bridge mailing list as well. Aside from that, the change is certainly interesting, I've been
>>> thinking about a similar helper for some time now, few comments below.
>> 
>> yes, sorry for that. I figured it out after sending the series out.
>> 
>>>
>>> Have you thought about the egress path and if by the current bridge state the packet would
>>> be allowed to egress through the found port from the lookup? I'd guess you have to keep updating
>>> the active ports list based on netlink events, but there's a lot of egress bridge logic that
>>> either have to be duplicated or somehow synced. Check should_deliver() (br_forward.c) and later
>>> egress stages, but I see how this is a good first step and perhaps we can build upon it.
>>> There are a few possible solutions, but I haven't tried anything yet, most obvious being
>>> yet another helper. :)
>> 
>> ack, right but I am bit worried about adding too much logic and slow down xdp
>> performances. I guess we can investigate first the approach proposed by Alexei
>> and then revaluate. Agree?
>> 
>
> Sure, that approach sounds very interesting, but my point was that
> bypassing the ingress and egress logic defeats most of the bridge
> features. You just get an fdb hash table which you can build today
> with ebpf without any changes to the kernel. :) You have multiple
> states, flags and options for each port and each vlan which can change
> dynamically based on external events (e.g. STP, config changes etc)
> and they can affect forwarding even if the fdbs remain in the table.

To me, leveraging all this is precisely the reason to have BPF helpers
instead of just replicating state in BPF maps: it's very easy to do that
and show a nice speedup, and then once you get all the corner cases
covered that the in-kernel code already deals with, you've chipped away
at that speedup and spent a lot of time essentially re-writing the
battle-tested code already in the kernel.

So I think figuring out how to do the state sync is the right thing to
do; a second helper would be fine for this, IMO, but I'm not really
familiar enough with the bridge code to really have a qualified opinion.

-Toke

