Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F70D35FE0F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhDNWwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:52:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233679AbhDNWwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618440702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtB6Wp5AVxplW2Z84nTCGyemptbqZUOzp8eUITEWE1E=;
        b=cWLIng26C0iVjI00iK1+cXLsOGlmA9hfIwk9c+yJ+WV+ybBOzyqYmyyz859DaGfH81zBnv
        zryk3p7lT1JVsewcYZ8r8YgsvSpDvktA+MPTHMPpLMjnItUbxUt+O2QQYAWsm417Eod9Qv
        Im3xqK9+i+Qbby0PocXbdqxRnWpPBEo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-QWGPcqtnM4mTA9hGTMSzvQ-1; Wed, 14 Apr 2021 18:51:41 -0400
X-MC-Unique: QWGPcqtnM4mTA9hGTMSzvQ-1
Received: by mail-ej1-f69.google.com with SMTP id x21-20020a1709064bd5b029037c44cb861cso310286ejv.4
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 15:51:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dtB6Wp5AVxplW2Z84nTCGyemptbqZUOzp8eUITEWE1E=;
        b=WpHVtktJtf+KVi9o9GJ3Hjhgnu/Mx3nCItPf9Sn7vSqbytOLpGBwtwFP3oTutxaYEg
         7TL/lbZX98eVb59fYcqb11JBdbx+8jDCo3yikhPSS44rmq51ShBG1kTkqPsl5Xm23FJK
         qXbj1K8/s2TowfjdRN9oRhC3U1nlR7nMyOk98o0sCUt23XoHeI7ZSZexJQd5cyLnDQLM
         VgoY/TQPs55Ez0wAtCppWgqej6TkY1WwShVbEQo+NzjrIzpeq1Up2kbhXElUdH3wyGuI
         VjomfU0UGsHSQpv3ayfKuCstgBVDsl0yKgPQ8omcDWtkFvdXl6cJSdSEmTIXYm6kvtuC
         5dwA==
X-Gm-Message-State: AOAM533Sa+i7RpNoqT5SUyRnlfxGaVmnKHSzJvd5D/hbPgQAD5kBs8Xi
        QCPBIgTnGVvk6nzTCCfN7ju8I9SFAjNcdTP9RwuFHGnA+EmuYUX00RORsElPHI8y44g8BaTm/KP
        Zw8zYLBkbBvzb1a0M
X-Received: by 2002:a05:6402:270c:: with SMTP id y12mr597497edd.284.1618440699757;
        Wed, 14 Apr 2021 15:51:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/Ha0YabHIRbKQeIodCU+bcTN5C7lPFVSR2jBVjzkZyW/0QqQvzy7nn33VIUTkoBF1km1Q8g==
X-Received: by 2002:a05:6402:270c:: with SMTP id y12mr597457edd.284.1618440699361;
        Wed, 14 Apr 2021 15:51:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k9sm126025eje.102.2021.04.14.15.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 15:51:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 087191806B3; Thu, 15 Apr 2021 00:51:38 +0200 (CEST)
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
In-Reply-To: <CAEf4BzaEkzPeAXqmm5aEdQxnCkrqJTHcSu7afnV11+697KgZTQ@mail.gmail.com>
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
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 15 Apr 2021 00:51:37 +0200
Message-ID: <87wnt4jx8m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Apr 14, 2021 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Tue, Apr 6, 2021 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >>
>> >> > On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
>> >> > <alexei.starovoitov@gmail.com> wrote:
>> >> >>
>> >> >> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwivedi =
wrote:
>> >> >> > On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wrote:
>> >> >> > > On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor=
@gmail.com> wrote:
>> >> >> > > > [...]
>> >> >> > >
>> >> >> > > All of these things are messy because of tc legacy. bpf tried =
to follow tc style
>> >> >> > > with cls and act distinction and it didn't quite work. cls with
>> >> >> > > direct-action is the only
>> >> >> > > thing that became mainstream while tc style attach wasn't real=
ly addressed.
>> >> >> > > There were several incidents where tc had tens of thousands of=
 progs attached
>> >> >> > > because of this attach/query/index weirdness described above.
>> >> >> > > I think the only way to address this properly is to introduce =
bpf_link style of
>> >> >> > > attaching to tc. Such bpf_link would support ingress/egress on=
ly.
>> >> >> > > direction-action will be implied. There won't be any index and=
 query
>> >> >> > > will be obvious.
>> >> >> >
>> >> >> > Note that we already have bpf_link support working (without supp=
ort for pinning
>> >> >> > ofcourse) in a limited way. The ifindex, protocol, parent_id, pr=
iority, handle,
>> >> >> > chain_index tuple uniquely identifies a filter, so we stash this=
 in the bpf_link
>> >> >> > and are able to operate on the exact filter during release.
>> >> >>
>> >> >> Except they're not unique. The library can stash them, but somethi=
ng else
>> >> >> doing detach via iproute2 or their own netlink calls will detach t=
he prog.
>> >> >> This other app can attach to the same spot a different prog and now
>> >> >> bpf_link__destroy will be detaching somebody else prog.
>> >> >>
>> >> >> > > So I would like to propose to take this patch set a step furth=
er from
>> >> >> > > what Daniel said:
>> >> >> > > int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
>> >> >> > > and make this proposed api to return FD.
>> >> >> > > To detach from tc ingress/egress just close(fd).
>> >> >> >
>> >> >> > You mean adding an fd-based TC API to the kernel?
>> >> >>
>> >> >> yes.
>> >> >
>> >> > I'm totally for bpf_link-based TC attachment.
>> >> >
>> >> > But I think *also* having "legacy" netlink-based APIs will allow
>> >> > applications to handle older kernels in a much nicer way without ex=
tra
>> >> > dependency on iproute2. We have a similar situation with kprobe, wh=
ere
>> >> > currently libbpf only supports "modern" fd-based attachment, but us=
ers
>> >> > periodically ask questions and struggle to figure out issues on old=
er
>> >> > kernels that don't support new APIs.
>> >>
>> >> +1; I am OK with adding a new bpf_link-based way to attach TC program=
s,
>> >> but we still need to support the netlink API in libbpf.
>> >>
>> >> > So I think we'd have to support legacy TC APIs, but I agree with
>> >> > Alexei and Daniel that we should keep it to the simplest and most
>> >> > straightforward API of supporting direction-action attachments and
>> >> > setting up qdisc transparently (if I'm getting all the terminology
>> >> > right, after reading Quentin's blog post). That coincidentally shou=
ld
>> >> > probably match how bpf_link-based TC API will look like, so all that
>> >> > can be abstracted behind a single bpf_link__attach_tc() API as well,
>> >> > right? That's the plan for dealing with kprobe right now, btw. Libb=
pf
>> >> > will detect the best available API and transparently fall back (may=
be
>> >> > with some warning for awareness, due to inherent downsides of legacy
>> >> > APIs: no auto-cleanup being the most prominent one).
>> >>
>> >> Yup, SGTM: Expose both in the low-level API (in bpf.c), and make the
>> >> high-level API auto-detect. That way users can also still use the
>> >> netlink attach function if they don't want the fd-based auto-close
>> >> behaviour of bpf_link.
>> >
>> > So I thought a bit more about this, and it feels like the right move
>> > would be to expose only higher-level TC BPF API behind bpf_link. It
>> > will keep the API complexity and amount of APIs that libbpf will have
>> > to support to the minimum, and will keep the API itself simple:
>> > direct-attach with the minimum amount of input arguments. By not
>> > exposing low-level APIs we also table the whole bpf_tc_cls_attach_id
>> > design discussion, as we now can keep as much info as needed inside
>> > bpf_link_tc (which will embed bpf_link internally as well) to support
>> > detachment and possibly some additional querying, if needed.
>>
>> But then there would be no way for the caller to explicitly select a
>> mechanism? I.e., if I write a BPF program using this mechanism targeting
>> a 5.12 kernel, I'll get netlink attachment, which can stick around when
>> I do bpf_link__disconnect(). But then if the kernel gets upgraded to
>> support bpf_link for TC programs I'll suddenly transparently get
>> bpf_link and the attachments will go away unless I pin them. This
>> seems... less than ideal?
>
> That's what we are doing with bpf_program__attach_kprobe(), though.
> And so far I've only seen people (privately) saying how good it would
> be to have bpf_link-based TC APIs, doesn't seem like anyone with a
> realistic use case prefers the current APIs. So I suspect it's not
> going to be a problem in practice. But at least I'd start there and
> see how people are using it and if they need anything else.

*sigh* - I really wish you would stop arbitrarily declaring your own use
cases "realistic" and mine (implied) "unrealistic". Makes it really hard
to have a productive discussion...

>> If we expose the low-level API I can elect to just use this if I know I
>> want netlink behaviour, but if bpf_program__attach_tc() is the only API
>> available it would at least need a flag to enforce one mode or the other
>> (I can see someone wanting to enforce kernel bpf_link semantics as well,
>> so a flag for either mode seems reasonable?).
>
> Sophisticated enough users can also do feature detection to know if
> it's going to work or not.

Sure, but that won't help if there's no API to pick the attach mode they
want.

> There are many ways to skin this cat. I'd prioritize bpf_link-based TC
> APIs to be added with legacy TC API as a fallback.

I'm fine with adding that; I just want the functions implementing the TC
API to also be exported so users can use those if they prefer...

-Toke

