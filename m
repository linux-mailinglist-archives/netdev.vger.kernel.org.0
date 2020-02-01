Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D925614F8C2
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgBAP73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 10:59:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38315 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726622AbgBAP73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 10:59:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580572767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RhGVBph3EiWI9rEcmsw/6wJiFN/YCf1DlcbskvcDNN4=;
        b=AVhdDquvRyJI/xNsy9fePEPbCJsVpyGu+P6MZF0M5oPKduI7Bi6ZZKeA5XALTUSJc07HAe
        J2d5CcONu0lM3MqyWEMSAnJEgyqKKcLQO47dYVwhOubkFy5NAoZ6ZkZKueHA//yIL4B45p
        hJE+dRZ6rWpp0oxZcp8z5mJHu5NVcJM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-Z7kftUFQMOmdrzLc6VI14g-1; Sat, 01 Feb 2020 10:59:25 -0500
X-MC-Unique: Z7kftUFQMOmdrzLc6VI14g-1
Received: by mail-lj1-f197.google.com with SMTP id z2so2534615ljh.16
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 07:59:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RhGVBph3EiWI9rEcmsw/6wJiFN/YCf1DlcbskvcDNN4=;
        b=dLHz0GkqJMsmBOPDgjSj4ctJrJ8WTOxqWjO705zJrH06Ptf1SQ21zFE0S42aGl/jD3
         8DT8MZd6mNSgFlg95jy+s/loDTabIhrGGLokycIrZb5QgdBPEqL50BznWIRxnRZbVklh
         DyKeFuxgkN1AqGVpJZSUaINTODBH78JAYpfLuTKoq0plnYMJRDYILnn0upi+Vxw+hyYL
         tkjz8iAw6JnLyG3VozlG1LV2iIq9lh+vj3GwjfoA21V3tXGlmtQoBisTjhyKNITRnbip
         lcQX5FSVhzkiHuaXy5kWgm72GvASs3ZhBdBaSDbk/qezxCTc7UWLd7L7JVSTYnH+V1lC
         J/aA==
X-Gm-Message-State: APjAAAXhiXkVfhLx3HpqmatjB3llJxKOSC9hRF9lkiBTKvCWhlUOA9q7
        qFey9LIMnUvUU4fGCuvHChVLMBw14tSzNvx59/5cYKzsF4bUYS13f4gWmy30ld+xu+zZA+U70su
        kgmtNBvVubHKThY7C
X-Received: by 2002:a05:651c:1183:: with SMTP id w3mr9405673ljo.232.1580572764368;
        Sat, 01 Feb 2020 07:59:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqxJSGF2htutWv0EMZtWKztdqRXNcMPaJ3BvIJtLVPZLjFg2wdnN8KJC2YzL6Nm6VVNTw5aTQA==
X-Received: by 2002:a05:651c:1183:: with SMTP id w3mr9405658ljo.232.1580572764044;
        Sat, 01 Feb 2020 07:59:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c27sm6153751lfh.62.2020.02.01.07.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 07:59:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DFAA71800A2; Sat,  1 Feb 2020 16:59:18 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 01 Feb 2020 16:59:18 +0100
Message-ID: <87o8uie1t5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 1/24/20 8:36 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>>=20
>>> On Thu, 23 Jan 2020 14:33:42 -0700, David Ahern wrote:
>>>> On 1/23/20 4:35 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>> David Ahern <dsahern@kernel.org> writes:
>>>>>> From: David Ahern <dahern@digitalocean.com>
>>>>>>
>>>>>> Add IFLA_XDP_EGRESS to if_link.h uapi to handle an XDP program attac=
hed
>>>>>> to the egress path of a device. Add rtnl_xdp_egress_fill and helpers=
 as
>>>>>> the egress counterpart to the existing rtnl_xdp_fill. The expectation
>>>>>> is that going forward egress path will acquire the various levels of
>>>>>> attach - generic, driver and hardware.=20=20
>>>>>
>>>>> How would a 'hardware' attach work for this? As I said in my reply to
>>>>> the previous patch, isn't this explicitly for emulating XDP on the ot=
her
>>>>> end of a point-to-point link? How would that work with offloaded
>>>>> programs?
>>>>
>>>> Nothing about this patch set is limited to point-to-point links.
>>>
>>> I struggle to understand of what the expected semantics of this new
>>> hook are. Is this going to be run on all frames sent to the device
>>> from the stack? All frames from the stack and from XDP_REDIRECT?
>>>
>>> A little hard to figure out the semantics when we start from a funky
>>> device like tun :S
>>=20
>> Yes, that is also why I found this a bit weird. We have discussed plans
>> for an XDP TX hook before:
>> https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#x=
dp-hook-at-tx
>>=20
>> That TX hook would run for everything at TX, but it would be a separate
>> program type with its own metadata access. Whereas the idea with this
>> series (seemed to me) to be just to be able to "emulate" run a regular
>> RX-side XDP program on egress for devices where this makes sense.
>>=20
>> If this series is not meant to implement that "emulation", but rather be
>> usable for all devices, I really think we should go straight for the
>> full TX hook as discussed earlier...
>>=20
>
> The first patch set from Jason and Prashant started from the perspective
> of offloading XDP programs for a guest. Independently, I was looking at
> XDP in the TX path (now referred to as egress to avoid confusion with
> the XDP_TX return type). Jason and Prashant were touching some of the
> same code paths in the tun driver that I needed for XDP in the Tx path,
> so we decided to consolidate and have XDP egress done first and then
> offload of VMs as a followup. Offload in virtio_net can be done very
> similar to how it is done in nfp -- the program is passed to the host as
> a hardware level attach mode, and the driver verifies the program can be
> offloaded (e.g., does not contain helpers that expose host specific data
> like the fib lookup helper).
>
> At this point, you need to stop thinking solely from the perspective of
> tun or tap and VM offload; think about this from the ability to run an
> XDP program on egress path at an appropriate place in the NIC driver
> that covers both skbs and xdp_frames (e.g., on a REDIRECT). This has
> been discussed before as a need (e.g, Toke's reference above), and I am
> trying to get this initial support done.

Right, so what we're discussing here *is* the "full" egress hook we've
discussed earlier. I thought this was still the other thing, which is
why I was confused.

> I very much wanted to avoid copy-paste-modify for the entire XDP API for
> this. For the most part XDP means ebpf at the NIC driver / hardware
> level (obviously with the exception of generic mode). The goal is
> tempered with the need for the verifier to reject rx entries in the
> xdp_md context. Hence the reason for use of an attach_type - existing
> infrastructure to test and reject the accesses.
>
> That said, Martin's comment throws a wrench in the goal: if the existing
> code does not enforce expected_attach_type then that option can not be
> used in which case I guess I have to go with a new program type
> (BPF_PROG_TYPE_XDP_EGRESS) which takes a new context (xdp_egress_md),
> has different return codes, etc.

In any case an egress program will differ in:

- The context object (the RX-related fields will be invalid on egress,
  and we'll probably want to add new TX-related ones, such as HW
  TX-queue occupancy).
=20=20
- The return code semantics (even if XDP_TX becomes equivalent to
  XDP_PASS, that is still a semantic difference from the RX side; and
  it's not necessarily clear whether we'll want to support REDIRECT on
  the egress side either, is it?)

So we'll have to disambiguate between the two different types of
programs. Which means that what we're discussing is really whether that
disambiguation should be encoded in the program type, or in the attach
type. IMO, making it a separate program type is a clearer and more
explicit UAPI. The verifier could still treat the two program types as
basically equivalent except for those cases where there has to be a
difference anyway. So it seems to me that all you are saving by using
attach_type instead of program type is the need for a new enum value and
a bunch of additions to switch statements? Or am I wildly
underestimating the effort to add a new program type?

-Toke

