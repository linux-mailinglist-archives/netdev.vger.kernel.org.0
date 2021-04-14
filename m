Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0835FE77
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbhDNXcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:32:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:48406 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbhDNXcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 19:32:43 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lWoza-000Biz-62; Thu, 15 Apr 2021 01:32:18 +0200
Received: from [85.7.101.30] (helo=pc-6.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lWozZ-000AOe-Q6; Thu, 15 Apr 2021 01:32:17 +0200
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
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
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4b99d6c3-0281-f539-e6dc-0b307c5a7db3@iogearbox.net>
Date:   Thu, 15 Apr 2021 01:32:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzbb0ECMjhAvD-1wpp3qJJcrpgKr_=ONN4ZQmuNUgYrH4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26140/Wed Apr 14 13:10:01 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 1:19 AM, Andrii Nakryiko wrote:
> On Wed, Apr 14, 2021 at 3:51 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>> On Wed, Apr 14, 2021 at 3:58 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>>>> On Tue, Apr 6, 2021 at 3:06 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>>>>>> On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
>>>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>>> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwivedi wrote:
>>>>>>>>> On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wrote:
>>>>>>>>>> On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>>>>>>>>>>> [...]
>>>>>>>>>>
>>>>>>>>>> All of these things are messy because of tc legacy. bpf tried to follow tc style
>>>>>>>>>> with cls and act distinction and it didn't quite work. cls with
>>>>>>>>>> direct-action is the only
>>>>>>>>>> thing that became mainstream while tc style attach wasn't really addressed.
>>>>>>>>>> There were several incidents where tc had tens of thousands of progs attached
>>>>>>>>>> because of this attach/query/index weirdness described above.
>>>>>>>>>> I think the only way to address this properly is to introduce bpf_link style of
>>>>>>>>>> attaching to tc. Such bpf_link would support ingress/egress only.
>>>>>>>>>> direction-action will be implied. There won't be any index and query
>>>>>>>>>> will be obvious.
>>>>>>>>>
>>>>>>>>> Note that we already have bpf_link support working (without support for pinning
>>>>>>>>> ofcourse) in a limited way. The ifindex, protocol, parent_id, priority, handle,
>>>>>>>>> chain_index tuple uniquely identifies a filter, so we stash this in the bpf_link
>>>>>>>>> and are able to operate on the exact filter during release.
>>>>>>>>
>>>>>>>> Except they're not unique. The library can stash them, but something else
>>>>>>>> doing detach via iproute2 or their own netlink calls will detach the prog.
>>>>>>>> This other app can attach to the same spot a different prog and now
>>>>>>>> bpf_link__destroy will be detaching somebody else prog.
>>>>>>>>
>>>>>>>>>> So I would like to propose to take this patch set a step further from
>>>>>>>>>> what Daniel said:
>>>>>>>>>> int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
>>>>>>>>>> and make this proposed api to return FD.
>>>>>>>>>> To detach from tc ingress/egress just close(fd).
>>>>>>>>>
>>>>>>>>> You mean adding an fd-based TC API to the kernel?
>>>>>>>>
>>>>>>>> yes.
>>>>>>>
>>>>>>> I'm totally for bpf_link-based TC attachment.
>>>>>>>
>>>>>>> But I think *also* having "legacy" netlink-based APIs will allow
>>>>>>> applications to handle older kernels in a much nicer way without extra
>>>>>>> dependency on iproute2. We have a similar situation with kprobe, where
>>>>>>> currently libbpf only supports "modern" fd-based attachment, but users
>>>>>>> periodically ask questions and struggle to figure out issues on older
>>>>>>> kernels that don't support new APIs.
>>>>>>
>>>>>> +1; I am OK with adding a new bpf_link-based way to attach TC programs,
>>>>>> but we still need to support the netlink API in libbpf.
>>>>>>
>>>>>>> So I think we'd have to support legacy TC APIs, but I agree with
>>>>>>> Alexei and Daniel that we should keep it to the simplest and most
>>>>>>> straightforward API of supporting direction-action attachments and
>>>>>>> setting up qdisc transparently (if I'm getting all the terminology
>>>>>>> right, after reading Quentin's blog post). That coincidentally should
>>>>>>> probably match how bpf_link-based TC API will look like, so all that
>>>>>>> can be abstracted behind a single bpf_link__attach_tc() API as well,
>>>>>>> right? That's the plan for dealing with kprobe right now, btw. Libbpf
>>>>>>> will detect the best available API and transparently fall back (maybe
>>>>>>> with some warning for awareness, due to inherent downsides of legacy
>>>>>>> APIs: no auto-cleanup being the most prominent one).
>>>>>>
>>>>>> Yup, SGTM: Expose both in the low-level API (in bpf.c), and make the
>>>>>> high-level API auto-detect. That way users can also still use the
>>>>>> netlink attach function if they don't want the fd-based auto-close
>>>>>> behaviour of bpf_link.
>>>>>
>>>>> So I thought a bit more about this, and it feels like the right move
>>>>> would be to expose only higher-level TC BPF API behind bpf_link. It
>>>>> will keep the API complexity and amount of APIs that libbpf will have
>>>>> to support to the minimum, and will keep the API itself simple:
>>>>> direct-attach with the minimum amount of input arguments. By not
>>>>> exposing low-level APIs we also table the whole bpf_tc_cls_attach_id
>>>>> design discussion, as we now can keep as much info as needed inside
>>>>> bpf_link_tc (which will embed bpf_link internally as well) to support
>>>>> detachment and possibly some additional querying, if needed.
>>>>
>>>> But then there would be no way for the caller to explicitly select a
>>>> mechanism? I.e., if I write a BPF program using this mechanism targeting
>>>> a 5.12 kernel, I'll get netlink attachment, which can stick around when
>>>> I do bpf_link__disconnect(). But then if the kernel gets upgraded to
>>>> support bpf_link for TC programs I'll suddenly transparently get
>>>> bpf_link and the attachments will go away unless I pin them. This
>>>> seems... less than ideal?
>>>
>>> That's what we are doing with bpf_program__attach_kprobe(), though.
>>> And so far I've only seen people (privately) saying how good it would
>>> be to have bpf_link-based TC APIs, doesn't seem like anyone with a
>>> realistic use case prefers the current APIs. So I suspect it's not
>>> going to be a problem in practice. But at least I'd start there and
>>> see how people are using it and if they need anything else.
>>
>> *sigh* - I really wish you would stop arbitrarily declaring your own use
>> cases "realistic" and mine (implied) "unrealistic". Makes it really hard
>> to have a productive discussion...
> 
> Well (sigh?..), this wasn't my intention, sorry you read it this way.
> But we had similar discussions when I was adding bpf_link-based XDP
> attach APIs. And guess what, now I see that samples/bpf/whatever_xdp
> is switched to bpf_link-based XDP, because that makes everything
> simpler and more reliable. What I also know is that in production we
> ran into multiple issues with anything that doesn't auto-detach on
> process exit/crash (unless pinned explicitly, of course). And that
> people that are trying to use TC right now are saying how having
> bpf_link-based TC APIs would make everything *simpler* and *safer*. So
> I don't know... I understand it might be convenient in some cases to
> not care about a lifetime of BPF programs you are attaching, but then
> there are usually explicit and intentional ways to achieve at least
> similar behavior with safety by default.

[...]

 >>> There are many ways to skin this cat. I'd prioritize bpf_link-based TC
 >>> APIs to be added with legacy TC API as a fallback.

I think the problem here is though that this would need to be deterministic
when upgrading from one kernel version to another where we don't use the
fallback anymore, e.g. in case of Cilium we always want to keep the progs
attached to allow headless updates on the agent, meaning, traffic keeps
flowing through the BPF datapath while in user space, our agent restarts
after upgrade, and atomically replaces the BPF progs once up and running
(we're doing this for the whole range of 4.9 to 5.x kernels that we support).
While we use the 'simple' api that is discussed here internally in Cilium,
this attach behavior would have to be consistent, so transparent fallback
inside libbpf on link vs non-link availability won't work (at least in our
case).

> So I guess call me unconvinced (yet? still?). Give it another shot, though.
> 
>>>> If we expose the low-level API I can elect to just use this if I know I
>>>> want netlink behaviour, but if bpf_program__attach_tc() is the only API
>>>> available it would at least need a flag to enforce one mode or the other
>>>> (I can see someone wanting to enforce kernel bpf_link semantics as well,
>>>> so a flag for either mode seems reasonable?).
>>>
>>> Sophisticated enough users can also do feature detection to know if
>>> it's going to work or not.
>>
>> Sure, but that won't help if there's no API to pick the attach mode they
>> want.
> 
> I'm not intending to allow legacy kprobe APIs to be "chosen", for
> instance. Because I'm convinced it's a bad API that no one should use
> if they can use an FD-based one. It might be a different case for TC,
> who knows. I'd just start with safer APIs and then evaluate whether
> there is a real demand for less safe ones. It's just some minor
> refactoring and exposing more APIs, when/if we need them.
> 
>>> There are many ways to skin this cat. I'd prioritize bpf_link-based TC
>>> APIs to be added with legacy TC API as a fallback.
>>
>> I'm fine with adding that; I just want the functions implementing the TC
>> API to also be exported so users can use those if they prefer...
>>
>> -Toke

