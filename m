Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4619A360F98
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhDOP6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:58:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233985AbhDOP54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618502253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+LsS0ftAjENjqdx8EBjDPwi/OUCdobBCtVY48zTQ40w=;
        b=MBocAMNt8NtX1v8n3wYr6HV7/T++rhu9i/SnIKXWkAoKl0koWtJZfVwG9UuM6vIZjoQIPr
        0BUfO59gmbDVz3n1v0dVNqY6Tr0C4bCWzBb3IRLOKi0tuqUZX2at6AP4rPf2z/uRVU2J3C
        fWyjBj8nTIuGcOJJu5jc+8NVQbUoQb0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-6r69XQrUNDSKVZBYRjhLEw-1; Thu, 15 Apr 2021 11:57:31 -0400
X-MC-Unique: 6r69XQrUNDSKVZBYRjhLEw-1
Received: by mail-ej1-f72.google.com with SMTP id r17-20020a1709069591b029037cf6a4a56dso1112472ejx.12
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 08:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+LsS0ftAjENjqdx8EBjDPwi/OUCdobBCtVY48zTQ40w=;
        b=Ac6Gi6gYVEfG7Na5AhZKl6gsatFKOrDlwAxEGZsQqiTzEq7n5SoD6hj8hu+KOYOlth
         WI218w84wh+0QjANO9oqy/5Fjdd8gx2KmwEdkKBaMJhlySYg5QvfrjkwM8JvwhH10eIS
         ANDY1lUs4KtvJPUCyp+USYYaMcFhChYsd2kJET3VmW44J+Kh+J+thZNIA5qbEokM5GvR
         dMvTicqLrPv7l8dMzEjJL5yg6zHKDY5Sz8kUOo682BOnOzcyKYkl2yfD4i5fiY743ymS
         0dLmUgnYIgcwVDhi/u2ROm+Isfsn2YUdW4YvqfcoEcy26jRAEhD4Sdsy12QYU1UKbuJj
         hlrQ==
X-Gm-Message-State: AOAM530vfMW2cYmh9Znz35NIMj4jqFwPYuUAj+jGnuDHvqHycDfzaeMU
        ZitrNase+NGRfw9FHsjkAYPZyzNCjcukVrBhtv2j+RzFfvEcPFRFg4y5XNcjI9uKgonqi7oLJjN
        atFrxJ8HwpwClrQmk
X-Received: by 2002:a17:906:7e53:: with SMTP id z19mr4151989ejr.422.1618502249509;
        Thu, 15 Apr 2021 08:57:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4N2v3zSfzaI8sojkPWLL/T2oIA/OEpL4yra5qcFBBjmH+et1M12PxSwhPmxWTUWs5xHO7Jw==
X-Received: by 2002:a17:906:7e53:: with SMTP id z19mr4151940ejr.422.1618502249016;
        Thu, 15 Apr 2021 08:57:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id qt10sm2285687ejb.34.2021.04.15.08.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 08:57:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5AEE91806B3; Thu, 15 Apr 2021 17:57:27 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
In-Reply-To: <CAEf4Bzbb0ECMjhAvD-1wpp3qJJcrpgKr_=ONN4ZQmuNUgYrH4A@mail.gmail.com>
References: <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
 <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net>
 <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
 <20210402190806.nhcgappm3iocvd3d@apollo>
 <20210403174721.vg4wle327wvossgl@ast-mbp>
 <CAEf4Bzaeu4apgEtwS_3q1iPuURjPXMs9H43cYUtJSmjPMU5M9A@mail.gmail.com>
 <87blar4ti7.fsf@toke.dk>
 <CAEf4BzaOJ-WD3A13B2uCrsE2yrctAL8QtJ8TuXHLeP+tm98pbA@mail.gmail.com>
 <874kg9m8t1.fsf@toke.dk>
 <CAEf4BzaEkzPeAXqmm5aEdQxnCkrqJTHcSu7afnV11+697KgZTQ@mail.gmail.com>
 <87wnt4jx8m.fsf@toke.dk>
 <CAEf4Bzbb0ECMjhAvD-1wpp3qJJcrpgKr_=ONN4ZQmuNUgYrH4A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 15 Apr 2021 17:57:27 +0200
Message-ID: <87v98nilqw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Apr 14, 2021 at 3:51 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Wed, Apr 14, 2021 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >>
>> >> > On Tue, Apr 6, 2021 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
>> >> >>
>> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >> >>
>> >> >> > On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
>> >> >> > <alexei.starovoitov@gmail.com> wrote:
>> >> >> >>
>> >> >> >> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwive=
di wrote:
>> >> >> >> > On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wr=
ote:
>> >> >> >> > > On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <mem=
xor@gmail.com> wrote:
>> >> >> >> > > > [...]
>> >> >> >> > >
>> >> >> >> > > All of these things are messy because of tc legacy. bpf tri=
ed to follow tc style
>> >> >> >> > > with cls and act distinction and it didn't quite work. cls =
with
>> >> >> >> > > direct-action is the only
>> >> >> >> > > thing that became mainstream while tc style attach wasn't r=
eally addressed.
>> >> >> >> > > There were several incidents where tc had tens of thousands=
 of progs attached
>> >> >> >> > > because of this attach/query/index weirdness described abov=
e.
>> >> >> >> > > I think the only way to address this properly is to introdu=
ce bpf_link style of
>> >> >> >> > > attaching to tc. Such bpf_link would support ingress/egress=
 only.
>> >> >> >> > > direction-action will be implied. There won't be any index =
and query
>> >> >> >> > > will be obvious.
>> >> >> >> >
>> >> >> >> > Note that we already have bpf_link support working (without s=
upport for pinning
>> >> >> >> > ofcourse) in a limited way. The ifindex, protocol, parent_id,=
 priority, handle,
>> >> >> >> > chain_index tuple uniquely identifies a filter, so we stash t=
his in the bpf_link
>> >> >> >> > and are able to operate on the exact filter during release.
>> >> >> >>
>> >> >> >> Except they're not unique. The library can stash them, but some=
thing else
>> >> >> >> doing detach via iproute2 or their own netlink calls will detac=
h the prog.
>> >> >> >> This other app can attach to the same spot a different prog and=
 now
>> >> >> >> bpf_link__destroy will be detaching somebody else prog.
>> >> >> >>
>> >> >> >> > > So I would like to propose to take this patch set a step fu=
rther from
>> >> >> >> > > what Daniel said:
>> >> >> >> > > int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
>> >> >> >> > > and make this proposed api to return FD.
>> >> >> >> > > To detach from tc ingress/egress just close(fd).
>> >> >> >> >
>> >> >> >> > You mean adding an fd-based TC API to the kernel?
>> >> >> >>
>> >> >> >> yes.
>> >> >> >
>> >> >> > I'm totally for bpf_link-based TC attachment.
>> >> >> >
>> >> >> > But I think *also* having "legacy" netlink-based APIs will allow
>> >> >> > applications to handle older kernels in a much nicer way without=
 extra
>> >> >> > dependency on iproute2. We have a similar situation with kprobe,=
 where
>> >> >> > currently libbpf only supports "modern" fd-based attachment, but=
 users
>> >> >> > periodically ask questions and struggle to figure out issues on =
older
>> >> >> > kernels that don't support new APIs.
>> >> >>
>> >> >> +1; I am OK with adding a new bpf_link-based way to attach TC prog=
rams,
>> >> >> but we still need to support the netlink API in libbpf.
>> >> >>
>> >> >> > So I think we'd have to support legacy TC APIs, but I agree with
>> >> >> > Alexei and Daniel that we should keep it to the simplest and most
>> >> >> > straightforward API of supporting direction-action attachments a=
nd
>> >> >> > setting up qdisc transparently (if I'm getting all the terminolo=
gy
>> >> >> > right, after reading Quentin's blog post). That coincidentally s=
hould
>> >> >> > probably match how bpf_link-based TC API will look like, so all =
that
>> >> >> > can be abstracted behind a single bpf_link__attach_tc() API as w=
ell,
>> >> >> > right? That's the plan for dealing with kprobe right now, btw. L=
ibbpf
>> >> >> > will detect the best available API and transparently fall back (=
maybe
>> >> >> > with some warning for awareness, due to inherent downsides of le=
gacy
>> >> >> > APIs: no auto-cleanup being the most prominent one).
>> >> >>
>> >> >> Yup, SGTM: Expose both in the low-level API (in bpf.c), and make t=
he
>> >> >> high-level API auto-detect. That way users can also still use the
>> >> >> netlink attach function if they don't want the fd-based auto-close
>> >> >> behaviour of bpf_link.
>> >> >
>> >> > So I thought a bit more about this, and it feels like the right move
>> >> > would be to expose only higher-level TC BPF API behind bpf_link. It
>> >> > will keep the API complexity and amount of APIs that libbpf will ha=
ve
>> >> > to support to the minimum, and will keep the API itself simple:
>> >> > direct-attach with the minimum amount of input arguments. By not
>> >> > exposing low-level APIs we also table the whole bpf_tc_cls_attach_id
>> >> > design discussion, as we now can keep as much info as needed inside
>> >> > bpf_link_tc (which will embed bpf_link internally as well) to suppo=
rt
>> >> > detachment and possibly some additional querying, if needed.
>> >>
>> >> But then there would be no way for the caller to explicitly select a
>> >> mechanism? I.e., if I write a BPF program using this mechanism target=
ing
>> >> a 5.12 kernel, I'll get netlink attachment, which can stick around wh=
en
>> >> I do bpf_link__disconnect(). But then if the kernel gets upgraded to
>> >> support bpf_link for TC programs I'll suddenly transparently get
>> >> bpf_link and the attachments will go away unless I pin them. This
>> >> seems... less than ideal?
>> >
>> > That's what we are doing with bpf_program__attach_kprobe(), though.
>> > And so far I've only seen people (privately) saying how good it would
>> > be to have bpf_link-based TC APIs, doesn't seem like anyone with a
>> > realistic use case prefers the current APIs. So I suspect it's not
>> > going to be a problem in practice. But at least I'd start there and
>> > see how people are using it and if they need anything else.
>>
>> *sigh* - I really wish you would stop arbitrarily declaring your own use
>> cases "realistic" and mine (implied) "unrealistic". Makes it really hard
>> to have a productive discussion...
>
> Well (sigh?..), this wasn't my intention, sorry you read it this way.
> But we had similar discussions when I was adding bpf_link-based XDP
> attach APIs.

Great, thank you! And yeah, we did discuss exactly this before, which is
where my mental sigh came from - I feel like we already covered this
ground and that I'm just being dismissed with "that is not a real use
case". But OK, I'll give it another shot, see below.

> And guess what, now I see that samples/bpf/whatever_xdp is switched to
> bpf_link-based XDP, because that makes everything simpler and more
> reliable. What I also know is that in production we ran into multiple
> issues with anything that doesn't auto-detach on process exit/crash
> (unless pinned explicitly, of course). And that people that are trying
> to use TC right now are saying how having bpf_link-based TC APIs would
> make everything *simpler* and *safer*. So I don't know... I understand
> it might be convenient in some cases to not care about a lifetime of
> BPF programs you are attaching, but then there are usually explicit
> and intentional ways to achieve at least similar behavior with safety
> by default.
>
> So I guess call me unconvinced (yet? still?). Give it another shot,
> though.

I'm not arguing against adding bpf_link support, and I'm even fine with
making it the default. As you say, there are plenty of use cases where
the bpf_link semantics make sense, and the XDP programs in samples all
fall in this category. So sure, let's add this support and make this
convenient to use.

But there are also use cases where the BPF program lifetime absolutely
shouldn't follow that of the userspace application. This includes both
applications that don't have a long-running daemon at all (like a
firewall that just loads a ruleset at boot; xdp-filter is such an
application in the BPF world, but I'm sure there are others). And
daemons that use BPF as a data path and want the packets to keep flowing
even when they restart, like Cilium as Daniel mentioned.

So the latter category of applications need their BPF programs to be
permanently attached to the interface. And sure, this can sorta be done
by pinning the bpf_link; but not really, because then:

- You incur a new dependency on bpffs, so you have to make sure that is
  mounted and that you can get at the particular fs instance you're
  using; the latter is especially painful if you switch namespaces.

- Your BPF program lifetime is no longer tied to the interface, so you
  have to deal with garbage collecting your pinned files somehow. This
  is especially painful if you don't have a daemon.

Together, these issues make bpf_link a much less compelling proposition,
to the point where it's no longer the better API for these use cases,
IMO. And I know that because I had to work around just these issues with
bpf_link for xdp-tools.

But I'm not even asking for the netlink API to be the default, I'm
fine with bpf_link being the default and encouraged API. I'm just asking
for a way to make it *possible* to select which attach mode I want.
Either by a flag to bpf_program__attach_tc(), or by exposing the
low-level bpf_tc_cls_*() netlink functions, like we do for XDP.

>> >> If we expose the low-level API I can elect to just use this if I know=
 I
>> >> want netlink behaviour, but if bpf_program__attach_tc() is the only A=
PI
>> >> available it would at least need a flag to enforce one mode or the ot=
her
>> >> (I can see someone wanting to enforce kernel bpf_link semantics as we=
ll,
>> >> so a flag for either mode seems reasonable?).
>> >
>> > Sophisticated enough users can also do feature detection to know if
>> > it's going to work or not.
>>
>> Sure, but that won't help if there's no API to pick the attach mode they
>> want.
>
> I'm not intending to allow legacy kprobe APIs to be "chosen", for
> instance. Because I'm convinced it's a bad API that no one should use
> if they can use an FD-based one.

I'd tend to agree with you for the tracing APIs, actually. But a
BPF-based data plane is different, as I tried to explain above.

> It might be a different case for TC, who knows. I'd just start with
> safer APIs and then evaluate whether there is a real demand for less
> safe ones. It's just some minor refactoring and exposing more APIs,
> when/if we need them.

There you go again with the "real demand" argument. How can I read this
in any other way than that you don't consider my use case "real" (as you
just assured me above was not the case)? What do you consider "real
demand"?

-Toke

