Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245D1361CAE
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 11:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240929AbhDPJBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 05:01:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240814AbhDPJBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 05:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618563684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbXQJQ+eKOPY15XrfY8ykzys3QyLZZKF2BRvQh65MXg=;
        b=UMVUHYhafFLgPKHTQbn2QmwqOkEwuRI8+GsHhlXqwkr6lDOIjEmxOmRRYNuQqnvolpJmM0
        aJPcO9m0d+jm+51QIaTw6HYeDhXRClyh/dTxRJuu9BURzdRpTE0Pp9Wt0l8Xg8tg1dKsto
        RgANVRrSh8aOW2RLZzaaBuWEHUW+Ug8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-uA2i5sQyP5yFjUv_w10HaQ-1; Fri, 16 Apr 2021 05:01:23 -0400
X-MC-Unique: uA2i5sQyP5yFjUv_w10HaQ-1
Received: by mail-ed1-f72.google.com with SMTP id d2-20020aa7d6820000b0290384ee872881so2576929edr.10
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 02:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zbXQJQ+eKOPY15XrfY8ykzys3QyLZZKF2BRvQh65MXg=;
        b=sx+4vSDMfSpifohQick28KWmImknDVif3Z+Hw62r0qWcKbdljVaQdSEEL9tWDoJEFN
         aediRlRaLF2NgGNZlP4c2L7qwzz5d5udTmZzybHrXXXENhQgGl3hNLeEM5pfsVtWO1Ut
         GC9Nnx7V7PKRQctsp1x1K7dA/IDmg+om4wqn466j8VnDPAnnAIF3ryETHRj3xPVpsCSI
         cCX6lar0LImsUz0Hjez1ZudWjuCFAtJ7VyDNOTv7cG+bhvWZZAXPV0ltdAJdES24kZ6C
         yfnPywK0Brq4ziutRAn9C4rv80kUa1dkmbcksCXfVgymoqvM0ekzFjKCTzZ//ZXLV63I
         ZwVQ==
X-Gm-Message-State: AOAM531224lDZUB3jpHWFm+N71UXnw46Eyd4UZyoLHCK525rgHxyKK9u
        xAEdimGfKSNtw3X4Khu6BvfAATu20fKMyJT0mFCHShmJcL8APitn1IlmLdoaz2s/1mgvQvzNtaU
        cnvhZeF40S8oKMjqs
X-Received: by 2002:aa7:c90a:: with SMTP id b10mr1024238edt.276.1618563681834;
        Fri, 16 Apr 2021 02:01:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3Mk8VVoJkMYKYMFvVpt6gQQvuTzy/+9IKG39EuysJ13U7wU86mLTRTieGDyRmgZMxMBKLfw==
X-Received: by 2002:aa7:c90a:: with SMTP id b10mr1024196edt.276.1618563681558;
        Fri, 16 Apr 2021 02:01:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e16sm4803160edu.94.2021.04.16.02.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 02:01:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AFBB71806B2; Fri, 16 Apr 2021 11:01:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
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
In-Reply-To: <13e37535-51f2-bbc3-b9dd-2e1c450c2391@iogearbox.net>
References: <20210325120020.236504-4-memxor@gmail.com>
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
 <4b99d6c3-0281-f539-e6dc-0b307c5a7db3@iogearbox.net>
 <CAEf4BzZtivCFfMLa5vnu6QtNL75BC4WoreS=4v1TScsfVX1jQQ@mail.gmail.com>
 <848d7864-44f3-79a2-ad3c-80adee6aa27a@iogearbox.net>
 <CAEf4BzaHwiQLmXOHcDfDtuBuPF7HZgoDW-=u6eYhQ2svHuGAWw@mail.gmail.com>
 <13e37535-51f2-bbc3-b9dd-2e1c450c2391@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 16 Apr 2021 11:01:18 +0200
Message-ID: <87czuuiowx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 4/16/21 12:22 AM, Andrii Nakryiko wrote:
>> On Thu, Apr 15, 2021 at 3:10 PM Daniel Borkmann <daniel@iogearbox.net> w=
rote:
>>> On 4/15/21 1:58 AM, Andrii Nakryiko wrote:
>>>> On Wed, Apr 14, 2021 at 4:32 PM Daniel Borkmann <daniel@iogearbox.net>=
 wrote:
>>>>> On 4/15/21 1:19 AM, Andrii Nakryiko wrote:
>>>>>> On Wed, Apr 14, 2021 at 3:51 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
>>>>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>>>>>>> On Wed, Apr 14, 2021 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
>>>>>>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>>>>>>>>> On Tue, Apr 6, 2021 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
>>>>>>>>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>>>>>>>>>>> On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
>>>>>>>>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>>>>>>>> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwi=
vedi wrote:
>>>>>>>>>>>>>> On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov w=
rote:
>>>>>>>>>>>>>>> On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <mem=
xor@gmail.com> wrote:
>>>>>>>>>>>>>>>> [...]
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> All of these things are messy because of tc legacy. bpf tri=
ed to follow tc style
>>>>>>>>>>>>>>> with cls and act distinction and it didn't quite work. cls =
with
>>>>>>>>>>>>>>> direct-action is the only
>>>>>>>>>>>>>>> thing that became mainstream while tc style attach wasn't r=
eally addressed.
>>>>>>>>>>>>>>> There were several incidents where tc had tens of thousands=
 of progs attached
>>>>>>>>>>>>>>> because of this attach/query/index weirdness described abov=
e.
>>>>>>>>>>>>>>> I think the only way to address this properly is to introdu=
ce bpf_link style of
>>>>>>>>>>>>>>> attaching to tc. Such bpf_link would support ingress/egress=
 only.
>>>>>>>>>>>>>>> direction-action will be implied. There won't be any index =
and query
>>>>>>>>>>>>>>> will be obvious.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Note that we already have bpf_link support working (without =
support for pinning
>>>>>>>>>>>>>> ofcourse) in a limited way. The ifindex, protocol, parent_id=
, priority, handle,
>>>>>>>>>>>>>> chain_index tuple uniquely identifies a filter, so we stash =
this in the bpf_link
>>>>>>>>>>>>>> and are able to operate on the exact filter during release.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Except they're not unique. The library can stash them, but so=
mething else
>>>>>>>>>>>>> doing detach via iproute2 or their own netlink calls will det=
ach the prog.
>>>>>>>>>>>>> This other app can attach to the same spot a different prog a=
nd now
>>>>>>>>>>>>> bpf_link__destroy will be detaching somebody else prog.
>>>>>>>>>>>>>
>>>>>>>>>>>>>>> So I would like to propose to take this patch set a step fu=
rther from
>>>>>>>>>>>>>>> what Daniel said:
>>>>>>>>>>>>>>> int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
>>>>>>>>>>>>>>> and make this proposed api to return FD.
>>>>>>>>>>>>>>> To detach from tc ingress/egress just close(fd).
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> You mean adding an fd-based TC API to the kernel?
>>>>>>>>>>>>>
>>>>>>>>>>>>> yes.
>>>>>>>>>>>>
>>>>>>>>>>>> I'm totally for bpf_link-based TC attachment.
>>>>>>>>>>>>
>>>>>>>>>>>> But I think *also* having "legacy" netlink-based APIs will all=
ow
>>>>>>>>>>>> applications to handle older kernels in a much nicer way witho=
ut extra
>>>>>>>>>>>> dependency on iproute2. We have a similar situation with kprob=
e, where
>>>>>>>>>>>> currently libbpf only supports "modern" fd-based attachment, b=
ut users
>>>>>>>>>>>> periodically ask questions and struggle to figure out issues o=
n older
>>>>>>>>>>>> kernels that don't support new APIs.
>>>>>>>>>>>
>>>>>>>>>>> +1; I am OK with adding a new bpf_link-based way to attach TC p=
rograms,
>>>>>>>>>>> but we still need to support the netlink API in libbpf.
>>>>>>>>>>>
>>>>>>>>>>>> So I think we'd have to support legacy TC APIs, but I agree wi=
th
>>>>>>>>>>>> Alexei and Daniel that we should keep it to the simplest and m=
ost
>>>>>>>>>>>> straightforward API of supporting direction-action attachments=
 and
>>>>>>>>>>>> setting up qdisc transparently (if I'm getting all the termino=
logy
>>>>>>>>>>>> right, after reading Quentin's blog post). That coincidentally=
 should
>>>>>>>>>>>> probably match how bpf_link-based TC API will look like, so al=
l that
>>>>>>>>>>>> can be abstracted behind a single bpf_link__attach_tc() API as=
 well,
>>>>>>>>>>>> right? That's the plan for dealing with kprobe right now, btw.=
 Libbpf
>>>>>>>>>>>> will detect the best available API and transparently fall back=
 (maybe
>>>>>>>>>>>> with some warning for awareness, due to inherent downsides of =
legacy
>>>>>>>>>>>> APIs: no auto-cleanup being the most prominent one).
>>>>>>>>>>>
>>>>>>>>>>> Yup, SGTM: Expose both in the low-level API (in bpf.c), and mak=
e the
>>>>>>>>>>> high-level API auto-detect. That way users can also still use t=
he
>>>>>>>>>>> netlink attach function if they don't want the fd-based auto-cl=
ose
>>>>>>>>>>> behaviour of bpf_link.
>>>>>>>>>>
>>>>>>>>>> So I thought a bit more about this, and it feels like the right =
move
>>>>>>>>>> would be to expose only higher-level TC BPF API behind bpf_link.=
 It
>>>>>>>>>> will keep the API complexity and amount of APIs that libbpf will=
 have
>>>>>>>>>> to support to the minimum, and will keep the API itself simple:
>>>>>>>>>> direct-attach with the minimum amount of input arguments. By not
>>>>>>>>>> exposing low-level APIs we also table the whole bpf_tc_cls_attac=
h_id
>>>>>>>>>> design discussion, as we now can keep as much info as needed ins=
ide
>>>>>>>>>> bpf_link_tc (which will embed bpf_link internally as well) to su=
pport
>>>>>>>>>> detachment and possibly some additional querying, if needed.
>>>>>>>>>
>>>>>>>>> But then there would be no way for the caller to explicitly selec=
t a
>>>>>>>>> mechanism? I.e., if I write a BPF program using this mechanism ta=
rgeting
>>>>>>>>> a 5.12 kernel, I'll get netlink attachment, which can stick aroun=
d when
>>>>>>>>> I do bpf_link__disconnect(). But then if the kernel gets upgraded=
 to
>>>>>>>>> support bpf_link for TC programs I'll suddenly transparently get
>>>>>>>>> bpf_link and the attachments will go away unless I pin them. This
>>>>>>>>> seems... less than ideal?
>>>>>>>>
>>>>>>>> That's what we are doing with bpf_program__attach_kprobe(), though.
>>>>>>>> And so far I've only seen people (privately) saying how good it wo=
uld
>>>>>>>> be to have bpf_link-based TC APIs, doesn't seem like anyone with a
>>>>>>>> realistic use case prefers the current APIs. So I suspect it's not
>>>>>>>> going to be a problem in practice. But at least I'd start there and
>>>>>>>> see how people are using it and if they need anything else.
>>>>>>>
>>>>>>> *sigh* - I really wish you would stop arbitrarily declaring your ow=
n use
>>>>>>> cases "realistic" and mine (implied) "unrealistic". Makes it really=
 hard
>>>>>>> to have a productive discussion...
>>>>>>
>>>>>> Well (sigh?..), this wasn't my intention, sorry you read it this way.
>>>>>> But we had similar discussions when I was adding bpf_link-based XDP
>>>>>> attach APIs. And guess what, now I see that samples/bpf/whatever_xdp
>>>>>> is switched to bpf_link-based XDP, because that makes everything
>>>>>> simpler and more reliable. What I also know is that in production we
>>>>>> ran into multiple issues with anything that doesn't auto-detach on
>>>>>> process exit/crash (unless pinned explicitly, of course). And that
>>>>>> people that are trying to use TC right now are saying how having
>>>>>> bpf_link-based TC APIs would make everything *simpler* and *safer*. =
So
>>>>>> I don't know... I understand it might be convenient in some cases to
>>>>>> not care about a lifetime of BPF programs you are attaching, but then
>>>>>> there are usually explicit and intentional ways to achieve at least
>>>>>> similar behavior with safety by default.
>>>>>
>>>>> [...]
>>>>>
>>>>>    >>> There are many ways to skin this cat. I'd prioritize bpf_link-=
based TC
>>>>>    >>> APIs to be added with legacy TC API as a fallback.
>>>>>
>>>>> I think the problem here is though that this would need to be determi=
nistic
>>>>> when upgrading from one kernel version to another where we don't use =
the
>>>>> fallback anymore, e.g. in case of Cilium we always want to keep the p=
rogs
>>>>> attached to allow headless updates on the agent, meaning, traffic kee=
ps
>>>>> flowing through the BPF datapath while in user space, our agent resta=
rts
>>>>> after upgrade, and atomically replaces the BPF progs once up and runn=
ing
>>>>> (we're doing this for the whole range of 4.9 to 5.x kernels that we s=
upport).
>>>>> While we use the 'simple' api that is discussed here internally in Ci=
lium,
>>>>> this attach behavior would have to be consistent, so transparent fall=
back
>>>>> inside libbpf on link vs non-link availability won't work (at least i=
n our
>>>>> case).
>>>>
>>>> What about pinning? It's not exactly the same, but bpf_link could
>>>> actually pin a BPF program, if using legacy TC, and pin bpf_link, if
>>>> using bpf_link-based APIs. Of course before switching from iproute2 to
>>>> libbpf APIs you'd need to design your applications to use pinning
>>>> instead of relying implicitly on permanently attached BPF program.
>>>
>>> All the progs we load from Cilium in a K8s setting w/ Pods, we could ha=
ve easily
>>> over 100 loaded at the same time on a node, and we template the per Pod=
 ones, so
>>> the complexity of managing those pinned lifecycles from the agent and d=
ealing with
>>> the semantic/fallback differences between kernels feels probably not wo=
rth the
>>> gain. So if there would be a libbpf tc simplified attach API, I'd for t=
he time
>>> being stick to the existing aka legacy means.
>>=20
>> Sure. Then what do you think about keeping only low-level TC APIs, and
>> in the future add bpf_program__attach_tc(), which will use
>> bpf_link-based one. It seems like it's not worth it to pretend we have
>> bpf_link-based semantics with "legacy" current TC APIs. Similarly how
>> we have a low-level XDP attach API, and bpf_link-based (only)
>> bpf_program__attach_xdp().
>
> I think that's okay. I guess question is what do we define as initial sco=
pe for
> the low-level TC API. cls_bpf w/ fixed direct-action mode + fixed eth_p_a=
ll,
> allowing to flexibly specify handle / priority or a block_index feels rea=
sonable.

Sounds reasonable to me, with the addition of 'parent' to the things you
can specify.

So snipping a few bits from Kumar's patch and paring it down a bit, we'd
end up with something like this?

+struct bpf_tc_cls_opts {
+	size_t sz;
+	__u32 chain_index;
+	__u32 handle;
+	__u32 priority;
+	__u32 class_id;
+};
+#define bpf_tc_cls_opts__last_field class_id
+
+/* Acts as a handle for an attached filter */
+struct bpf_tc_cls_attach_id {
+	__u32 ifindex;
+	union {
+		__u32 block_index;
+		__u32 parent_id;
+	};
+	__u32 protocol;
+	__u32 chain_index;
+	__u32 handle;
+	__u32 priority;
+};
+
+struct bpf_tc_cls_info {
+	struct bpf_tc_cls_attach_id id;
+	__u32 class_id;
+	__u32 bpf_flags;
+	__u32 bpf_flags_gen;
+};
+
+LIBBPF_API int bpf_tc_cls_attach_dev(int fd, __u32 ifindex, __u32 parent_i=
d,
+				     const struct bpf_tc_cls_opts *opts,
+				     struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_detach_dev(const struct bpf_tc_cls_attach_id *id=
);
+LIBBPF_API int bpf_tc_cls_get_info_dev(int fd, __u32 ifindex, __u32 parent=
_id,
+				       const struct bpf_tc_cls_opts *opts,
+				       struct bpf_tc_cls_info *info);



What about change and replace? I guess we could do without those, right?

-Toke

