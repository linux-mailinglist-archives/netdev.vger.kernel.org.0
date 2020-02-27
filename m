Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77F717166F
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 12:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgB0LzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 06:55:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57740 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728865AbgB0LzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 06:55:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582804520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pISu8CDqEJIgMiUxbezRRj+6x7kk8ktkrirr8izxN5o=;
        b=JfUOtrFIylx1qgKQi03+FdxSdFA4FN7q+5VSAjKsb5JFnDPzPtxAZEJbRbB0Z2MjzW0MsM
        o6UTC8Ol77OB2LlhZ9hUSPl7macdnDQm/ez2vJp7xVt89bKNYxwXJ85mdlPFvLpTmvgBZb
        BUvEQQUpP32yZ0lRQji+gZhG83l+xns=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-JT99rzw0NrCy-eTKpysgvA-1; Thu, 27 Feb 2020 06:55:19 -0500
X-MC-Unique: JT99rzw0NrCy-eTKpysgvA-1
Received: by mail-wm1-f72.google.com with SMTP id y7so910702wmd.4
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 03:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pISu8CDqEJIgMiUxbezRRj+6x7kk8ktkrirr8izxN5o=;
        b=UOOttIBOYgfPcRTycCELszEiFQ82+gEaUHi81APzvmGEjz008tcpnMywh3ZCH254HM
         w7AJjAv3lNAu5XSctO2qNyPJFW4sukSErP5dM46R4SGLTa8LxFlWRKiW8BR2CNB0l/uS
         aFXmGflEfF+VeUr4+WzQ8hhP8fAtuqSLvpyI8rjQ+YgCqIVy4ylGUGH19t5bqk2TJHd/
         0jUj4pNjwJ7ERu+YETHeUlAN9NH1tQ78lsAsDMxa6ejyDLWWSqwQ8TCqOHjmqKoinqE6
         In5FaC0Sta/aciunYFJOyapbHlatJndSwC3I+L2mZa/LMbrcc/N1vMVyIKFlKKdsCzrW
         pNCA==
X-Gm-Message-State: APjAAAXP+gcMb+dSHw8zXU2urIyGy4DTj8SJpRNQW0+3o9oivrd1GRyh
        p8mYGLiQSmuogDiml40iQBQQOTZC/LMDPY7ekDpb5UlvW506dvPJM1OrLHe2c6KO5PM/p26ONpv
        9fVM2xITwidc4U5dE
X-Received: by 2002:a5d:56ca:: with SMTP id m10mr4693056wrw.313.1582804517842;
        Thu, 27 Feb 2020 03:55:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqyz2npC8cPvJ9XPAlOm0U2NtLuwPU3kVFClqNO22fDLYtRc25fZt8Kfz2ZqEmQ4vYybLNBfxA==
X-Received: by 2002:a5d:56ca:: with SMTP id m10mr4693022wrw.313.1582804517596;
        Thu, 27 Feb 2020 03:55:17 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a5sm7426128wmb.37.2020.02.27.03.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 03:55:16 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 24B6A180362; Thu, 27 Feb 2020 12:55:16 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: Re: [PATCH RFC v4 bpf-next 00/11] Add support for XDP in egress path
In-Reply-To: <20200227032013.12385-1-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 27 Feb 2020 12:55:16 +0100
Message-ID: <87a754w8gr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dsahern@gmail.com>
>
> This series adds support for XDP in the egress path by introducing
> a new XDP attachment type, BPF_XDP_EGRESS, and adding an if_link API
> for attaching the program to a netdevice and reporting the program.
> The intent is to emulate the current RX path for XDP as much as
> possible to maintain consistency and symmetry in the 2 paths with
> their APIs and when the programs are run: at first touch in the Rx
> path and last touch in the Tx path.
>
> The intent is to be able to run bpf programs on all packets regardless
> of how they got to the xmit function of the netdevice - as an skb or a
> redirected xdp frame. This is a missing primitive for XDP allowing
> solutions to build small, targeted programs properly distributed in the
> networking path allowing for example an egress firewall / ACL / traffic
> verification or packet manipulation and encapping an entire ethernet
> frame whether it is locally generated traffic, forwarded via the slow
> path (ie., full stack processing) or xdp redirected frames.

I'm totally on board with these goals!

As for this:

> Attempting to tag the EGRESS path as yet another mode is inconsistent
> on a number of levels - from the current usage of XDP_FLAGS to options
> passed to the verifier for restricting xdp_md accesses. Using the API
> as listed above maintains consistency with all existing code.

You *are* effectively tagging the EGRESS path as another mode: You are
restricting which fields of the context object the program can access,
and you're restricting where the program can be attached. I am pretty
sure we will end up accumulating more differences, either in more
metadata that is only available in one mode (we've already discussed
exposing TX qlen on egress programs), or even helpers that only make
sense in one mode.

So it doesn't make sense to discuss whether egress programs are a
distinct type from ingress programs: They clearly are. What we are
discussing is how to encode this type difference. You are proposing to
encode it using expected_attach_type as a subtype identifier instead of
using a new type number. There is already precedence for this with the
tracing programs, and I do think it makes sense - ingress and egress XDP
programs are clearly related, just as (e.g.) fentry/fexit/freplace
programs are.

However, my issue with this encoding is that it is write-only: You can't
inspect a BPF program already loaded into the kernel and tell which type
it is. So my proposal would be to make it explicit: Expose the
expected_attach_type as a new field in bpf_prog_info so userspace can
query it, and clearly document it as, essentially, a program subtype
that can significantly affect how a program is treated by the kernel.

-Toke

