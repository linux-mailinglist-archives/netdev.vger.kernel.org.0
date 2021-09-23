Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6B415F11
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241153AbhIWNBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:01:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235776AbhIWNBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 09:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632401976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nj7KuKQYyiNPqoiOH3lAtPIlrtQ842d5NqTukqLDM40=;
        b=a51aGTvOvaWmpRMEgFLGmcJ/z4xJbDBG3MKojCv7rfoBjXL7B2uipLc7obsDrsVxnE0fL5
        yYhlupTYjuynUu0dIbGnkm7aMeWohGe+O1K+60d1rN4pLRYvgsf5oFCB4p8ytZzSTu884h
        samW0dWtdOEem2ge6CFXRiNGIWB6GQE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-rnYzs4RSPNCPoAF-MxgzoQ-1; Thu, 23 Sep 2021 08:59:35 -0400
X-MC-Unique: rnYzs4RSPNCPoAF-MxgzoQ-1
Received: by mail-ed1-f69.google.com with SMTP id q17-20020a50c351000000b003d81427d25cso6671984edb.15
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 05:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=nj7KuKQYyiNPqoiOH3lAtPIlrtQ842d5NqTukqLDM40=;
        b=EK0ou52EBfSTKsWx22B22U0gL6wjtdMXIjfCHwyl1rDf31ULk8zQKnwaQATk1tH26h
         /kfwhYdD0Qfj/ibpdhRqHBUc8/doXbEujKPo7W2eI9iwCAEI6EpAxM2DYCT9Uwvj96QV
         /TofhUKNieFSbg14r8Go7dfXXfMv3khsS0+7EZ5lYX8svSEyvKNuzAKWAz8kosA/bHFY
         cspv1kXER9C5/RoPrrcp8KRyNFWTRM+jDiQPBtxQkxlGoxS0PZeu0twOLx5Sono+HsR4
         zIhYvrAnz8nThIMeYbXwRbde/vE/SMw35jnrt/v1lE0UNAoGM5usYdNpCcIWlB/3i69f
         J7Fw==
X-Gm-Message-State: AOAM531MdX21RzP1qYYPucGT001bUwl12CaetYnN4k+ZQ7LkZqc/2ewS
        WHbMoHV2Cs03/kOWmTbx9mgihH6AzNAJgdt7NZkly22/TxvbFcrJduZhO2mOqqa88THqO8y3jGc
        PkvvaCpNWD4+GMj7r
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr4919133ejb.139.1632401972036;
        Thu, 23 Sep 2021 05:59:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSEtfMW1r8x50L+dOj8aW76eBRZceTqQrafMa7fbJkbDfsPJfnlypgYDX7Y7inLV8GPuGt/A==
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr4919025ejb.139.1632401970857;
        Thu, 23 Sep 2021 05:59:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u4sm2949465ejc.19.2021.09.23.05.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 05:59:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 28E06180274; Thu, 23 Sep 2021 14:59:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
In-Reply-To: <CACAyw99+KvsJGeqNE09VWHrZk9wKbQTg3h1h2LRmJADD5En2nQ@mail.gmail.com>
References: <87o88l3oc4.fsf@toke.dk>
 <CACAyw99+KvsJGeqNE09VWHrZk9wKbQTg3h1h2LRmJADD5En2nQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Sep 2021 14:59:29 +0200
Message-ID: <87tuibzbv2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer <lmb@cloudflare.com> writes:

> On Tue, 21 Sept 2021 at 17:06, Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Hi Lorenz (Cc. the other people who participated in today's discussion)
>>
>> Following our discussion at the LPC session today, I dug up my previous
>> summary of the issue and some possible solutions[0]. Seems no on
>> actually replied last time, which is why we went with the "do nothing"
>> approach, I suppose. I'm including the full text of the original email
>> below; please take a look, and let's see if we can converge on a
>> consensus here.
>
> Hi Toke,
>
> Thanks for looping me in again. A bit of context what XDP at
> Cloudflare looks like:
>
> * We have a chain of XDP programs attached to a real network device.
> This implements DDoS protection and L4 load balancing. This is
> maintained by the team I am on.
> * We have hundreds of network namespaces with veth that have XDP
> attached to them. Traffic is routed from the root namespace into
> these. This is maintained by the Magic Transit team, see this talk
> from last year's LPC [1]
> I'll try to summarise what I've picked up from the thread and add my
> own 2c. Options being considered:
>
> 1. Make sure mb-aware and mb-unaware programs don't mix.

I think I would rather state this as "make sure mb-unaware programs
never encounter an mb frame". The programs can mix just fine in a
single-buffer world since mb-aware programs are backwards compatible.
All the multibuf helpers will also do the right thing even if there's
only a single buffer in a given packet.

> This could either be in the form of a sysctl or a dynamic property
> similar to a refcount. We'd need to discern mb-aware from mb-unaware
> somehow, most easily via a new program type. This means recompiling
> existing programs (but then we expect that to be necessary anyways).

Small nit here: while in most cases this property will  probably be set
by recompilation, the loader can override it as well. So if you have a
non-mb-aware program that you know won't break in an mb-setting (because
it doesn't care about packet length, etc), your loader could just mark
it as 'mb-aware'.

Command-line loaders like xdp-loader and 'ip' would probably need a
manual override switch to do this for the case where you have an old XDP
program that you still want to run even though you've enabled MB mode.

> We'd also have to be able to indicate "mb-awareness" for freplace
> programs.
>
> The implementation complexity seems OK, but operator UX is not good:
> it's not possible to slowly migrate a system to mb-awareness, it has
> to happen in one fell swoop.

I don't think it has to be quite that bleak :)

Specifically, there is no reason to block mb-aware programs from loading
even when the multi-buffer mode is disabled. So a migration plan would
look something like:

1. Start out with the mb-sysctl toggled off. This will make the system
   behave like it does today, i.e., XDP programs won't load on
   interfaces with large MTUs.

2. Start porting all your XDP programs to make them mb-aware, and switch
   their program type as you do. In many cases this is just a matter of
   checking that the programs don't care about packet length. While this
   is ongoing you will have a mix of mb-aware and non-mb-aware programs
   running, but there will be no actual mb frames.

3. Once all your programs have been ported and marked as such, flip the
   sysctl. This will make the system start refusing to load any XDP
   programs that are not mb-aware.

4. Actually raise the MTU of your interfaces :)

> 2. Add a compatibility shim for mb-unaware programs receiving an mb frame.
>
> We'd still need a way to indicate "MB-OK", but it could be a piece of
> metadata on a bpf_prog. Whatever code dispatches to an XDP program
> would have to include a prologue that linearises the xdp_buff if
> necessary which implies allocating memory. I don't know how hard it is
> to implement this.

I think it would be somewhat non-trivial, and more importantly would
absolutely slaughter performance. And if you're using XDP, presumably
you care about that, so I'm not sure we're doing anyone any favours by
implementing such a compatibility layer?

> There is also the question of freplace: do we extend linearising to
> them, or do they have to support MB?

Well, today freplace programs just inherit the type of whatever they are
attaching to, so we'd have to go out of our way to block this. I think
logically it would be up to whatever loader is attaching freplace
programs, because that's the one that knows the semantics. E.g.,
something like libxdp that uses freplace to chain load programs would
have to make sure that the dispatcher program is only marked as mb-aware
if *all* the constituent programs are.

> You raised an interesting point: couldn't we hit programs that can't
> handle data_end - data being above a certain length? I think we (=3D
> Cloudflare) actually have one of those, since we in some cases need to
> traverse the entire buffer to calculate a checksum (we encapsulate
> UDPv4 in IPv6, don't ask). Turns out it's actually really hard to
> calculate the checksum on a variable length packet in BPF so we've had
> to introduce limits. However, this case isn't too important: we made
> this choice consciously, knowing that MTU changes would break it.

Yeah, for this I think you're on your own ;)

> Other than that I like this option a lot: mb-aware and mb-unaware
> programs can co-exist, at the cost of performance. This allows
> gradually migrating to our stack so that it can handle jumbo frames.

See above re: coexisting.

> 3. Make non-linearity invisible to the BPF program
>
> Something I've wished for often is that I didn't have to deal with
> nonlinearity at all, based on my experience with cls_redirect [2].
> It's really hard to write a BPF program that handles non-linear skb,
> especially when you have to call adjust_head, etc. which invalidates
> packet buffers. This is probably impossible, but maybe someone has a
> crazy idea? :)

With the other helpers that we started discussing, I don't think you
have to? I.e., with an xdp_load_bytes() or an xdp_data_pointer()-type
helper that works across fragment boundaries I think you'd be fine, no?

-Toke

