Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D556E2D4000
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgLIKdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:33:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729808AbgLIKdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:33:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607509924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cOGqBzHVVKEnqwg2bfVwU3p+w6oB2N4Q9f8QqmS+U5M=;
        b=Lf9CG+Vp/uBxqTpShhNXHeA8AJ5R5Lx1v7rKqtVCjBBoG3Z1eZ+gfsefWjTJNBtzxptZc6
        5aKgo3SGjHb7CcGg5Q78grm6i+Zsri0A3lJF6s5XxqM9l/9QoYbQ/o5fnIvDjbN7/0lMIk
        KzYwEB09FS8SVkjTrUOHZpBhPX+zGWU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-LOmHKdF8PPSTwGEeswy5hg-1; Wed, 09 Dec 2020 05:32:03 -0500
X-MC-Unique: LOmHKdF8PPSTwGEeswy5hg-1
Received: by mail-wr1-f71.google.com with SMTP id r11so477921wrs.23
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 02:32:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=cOGqBzHVVKEnqwg2bfVwU3p+w6oB2N4Q9f8QqmS+U5M=;
        b=TLiLVaKsxiMcTifZDa+1fb8c6OslBDglsX42gyjingMa49V4EwDlg3FrA3eTUIr36A
         MKQoI6kHm9E3ir1ARPQezu/iY2iGXTtvK5LdOVbHkDDaXGbcaHa5fYniCggBnjpBijkS
         OpSemscU7ScSaXcsgYGqSz2upDPdMgNLzKL+awfoVEfzfsvmDaVvXSdee7cRelabn6D5
         jzqffGnGRDltjv4PKRYH6Ct2Mn6XXt+VON20C+lMCk0boPmubUomoRwG8FOkaggLTDxv
         XSMpyhnYuD0clfA5qQKhrLLkxmbp+bzZPCapd9NATsieRtGmcyz+PmsE+m1Zd/kq22jH
         pqxg==
X-Gm-Message-State: AOAM533IKzJPTbL0k1l7VXuejEBELB1wjNOwK4pRCqLnWsljXkR5tldm
        HbCwOe4ak8CHQeBBSjAyW67lhjBpdvmPdvz+DIdA9E96zljH0L7AmF2vc93AVf9gsTXU4s/UGJM
        M2HVSluK8h5wbA1dh
X-Received: by 2002:a1c:3c09:: with SMTP id j9mr2031873wma.180.1607509922326;
        Wed, 09 Dec 2020 02:32:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBiILwRPyHO+wjb6cs5eMg3G3ifBjCTwNJrVuvV0WYJad0N/7Pn/n3Xy9E+xVdIVFcx5tcYg==
X-Received: by 2002:a1c:3c09:: with SMTP id j9mr2031846wma.180.1607509922100;
        Wed, 09 Dec 2020 02:32:02 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h204sm2493607wme.17.2020.12.09.02.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 02:32:01 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A39B8180003; Wed,  9 Dec 2020 11:26:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        David Ahern <dsahern@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
In-Reply-To: <5fd065a1479c4_50ce208b1@john-XPS-13-9370.notmuch>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk> <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <431a53bd-25d7-8535-86e1-aa15bf94e6c3@gmail.com>
 <20201208092803.05b27db3@carbon> <87lfe8ik5c.fsf@toke.dk>
 <5fd065a1479c4_50ce208b1@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 09 Dec 2020 11:26:19 +0100
Message-ID: <87ft4fp96c.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>>=20
>> > On Mon, 7 Dec 2020 18:01:00 -0700
>> > David Ahern <dsahern@gmail.com> wrote:
>> >
>> >> On 12/7/20 1:52 PM, John Fastabend wrote:
>> >> >>
>> >> >> I think we need to keep XDP_TX action separate, because I think th=
at
>> >> >> there are use-cases where the we want to disable XDP_TX due to end=
-user
>> >> >> policy or hardware limitations.=20=20
>> >> >=20
>> >> > How about we discover this at load time though.=20
>> >
>> > Nitpick at XDP "attach" time. The general disconnect between BPF and
>> > XDP is that BPF can verify at "load" time (as kernel knows what it
>> > support) while XDP can have different support/features per driver, and
>> > cannot do this until attachment time. (See later issue with tail calls=
).
>> > (All other BPF-hooks don't have this issue)
>> >
>> >> > Meaning if the program
>> >> > doesn't use XDP_TX then the hardware can skip resource allocations =
for
>> >> > it. I think we could have verifier or extra pass discover the use of
>> >> > XDP_TX and then pass a bit down to driver to enable/disable TX caps.
>> >> >=20=20=20
>> >>=20
>> >> This was discussed in the context of virtio_net some months back - it=
 is
>> >> hard to impossible to know a program will not return XDP_TX (e.g., va=
lue
>> >> comes from a map).
>> >
>> > It is hard, and sometimes not possible.  For maps the workaround is
>> > that BPF-programmer adds a bound check on values from the map. If not
>> > doing that the verifier have to assume all possible return codes are
>> > used by BPF-prog.
>> >
>> > The real nemesis is program tail calls, that can be added dynamically
>> > after the XDP program is attached.  It is at attachment time that
>> > changing the NIC resources is possible.  So, for program tail calls the
>> > verifier have to assume all possible return codes are used by BPF-prog.
>>=20
>> We actually had someone working on a scheme for how to express this for
>> programs some months ago, but unfortunately that stalled out (Jesper
>> already knows this, but FYI to the rest of you). In any case, I view
>> this as a "next step". Just exposing the feature bits to userspace will
>> help users today, and as a side effect, this also makes drivers declare
>> what they support, which we can then incorporate into the core code to,
>> e.g., reject attachment of programs that won't work anyway. But let's
>> do this in increments and not make the perfect the enemy of the good
>> here.
>>=20
>> > BPF now have function calls and function replace right(?)  How does
>> > this affect this detection of possible return codes?
>>=20
>> It does have the same issue as tail calls, in that the return code of
>> the function being replaced can obviously change. However, the verifier
>> knows the target of a replace, so it can propagate any constraints put
>> upon the caller if we implement it that way.
>
> OK I'm convinced its not possible to tell at attach time if a program
> will use XDP_TX or not in general. And in fact for most real programs it
> likely will not be knowable. At least most programs I look at these days
> use either tail calls or function calls so seems like a dead end.
>
> Also above somewhere it was pointed out that XDP_REDIRECT would want
> the queues and it seems even more challenging to sort that out.

Yeah. Doesn't mean that all hope is lost for "reject stuff that doesn't
work". We could either do pessimistic return code detection (if we don't
know for sure assume all codes are used), or we could add metadata where
the program declares what it wants to do...

-Toke

