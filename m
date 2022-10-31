Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705FB614070
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 23:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJaWJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 18:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJaWJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 18:09:16 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2009588
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:09:15 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id o13so6921959ilc.7
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5PdO6ormBUtI8zTapMH9vc85PlwZpuP1HcZJzP21Hc=;
        b=CfjGAqZ+MDDiQRSMyJloRVioRZWYLVwI/eDNvUramVwXH3DSwtesvn+OhKlaQTvhHe
         FxjkJyqIlZ+lRpDjWL/rZ7l8fntGQy9tcN+m+QDipr/AWg+rKwZwnGhRQ7vuIcYS/0NC
         eiBEY8kpYrHdZnOaz1EJxpvtBBdMzxTMLkpbLQR3AWBmGusQbTi/gt9kpsfJKP4Hk4f0
         Ovw1po0L9dOllE1LSbJrNTdpr69UvE12Hts84Du6FF6VFBGy1gVV9m68seMIdQtzvpVX
         QIlyUa6vXes792hsZa1UKWaEUM0Ey4bfMJxmR2GQdiayGRGajK38eg3aH/42ogwq8fbF
         +Qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I5PdO6ormBUtI8zTapMH9vc85PlwZpuP1HcZJzP21Hc=;
        b=4drS0xsUEFLrWeI6hTOAnMzPAwcn1NmMCm3YQUB12QQqx2YhGygdyk4/9kWY/2vWpF
         Tlg0HNaiJ1uVOiaYkT/zNZXWYfX3JOWeuH8HBAcYQbB2DIFeRH1Y5FRqXoCP0iRlLmPX
         k9/o8mxeSvFY/Ez+KBGWJiwG255f94bH2Fn8AV+SojBCMJ7IJF2XhojSTFmGCeLDZ7qA
         Kq+CSishPwROA3LTdbeENp9m1sFmJDFKEF84KM1nQ0IsHqIj9Ue+PQ/rGyuWdpUKo7K6
         Q38KYUdLCgndJDwQN5B66z167LLuMlcOM2yVw/8xL3FgmFNaCJUz3293ATc9E2Keweh4
         yPGQ==
X-Gm-Message-State: ACrzQf0R3N/BUxGJT8N+tQO3zQTl8apH6M73zRLAa4AD0W1qg4cYUbLj
        WoezOnuZ8XDuGUGLiXJVjmUZm3FC7QtT1GLcbK77kA==
X-Google-Smtp-Source: AMsMyM7DI4lh8P7CQUkwCPgdvzBDesW0Rv9fKgoSdE4RLB8gGrhJTfJx3XSHQotaeZMjHyIWwkMOCewYrq+7yTWM65w=
X-Received: by 2002:a92:db03:0:b0:300:5dc4:d111 with SMTP id
 b3-20020a92db03000000b003005dc4d111mr7801454iln.257.1667254154446; Mon, 31
 Oct 2022 15:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org> <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk> <663fb4f4-04b7-5c1f-899c-bdac3010f073@meta.com>
In-Reply-To: <663fb4f4-04b7-5c1f-899c-bdac3010f073@meta.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 31 Oct 2022 15:09:03 -0700
Message-ID: <CAKH8qBt=As5ON+CbH304tRanudvTF27bzeSnjH2GQR2TVx+mXw@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
To:     Yonghong Song <yhs@meta.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 12:36 PM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 10/31/22 8:28 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > "Bezdeka, Florian" <florian.bezdeka@siemens.com> writes:
> >
> >> Hi all,
> >>
> >> I was closely following this discussion for some time now. Seems we
> >> reached the point where it's getting interesting for me.
> >>
> >> On Fri, 2022-10-28 at 18:14 -0700, Jakub Kicinski wrote:
> >>> On Fri, 28 Oct 2022 16:16:17 -0700 John Fastabend wrote:
> >>>>>> And it's actually harder to abstract away inter HW generation
> >>>>>> differences if the user space code has to handle all of it.
> >>>>
> >>>> I don't see how its any harder in practice though?
> >>>
> >>> You need to find out what HW/FW/config you're running, right?
> >>> And all you have is a pointer to a blob of unknown type.
> >>>
> >>> Take timestamps for example, some NICs support adjusting the PHC
> >>> or doing SW corrections (with different versions of hw/fw/server
> >>> platforms being capable of both/one/neither).
> >>>
> >>> Sure you can extract all this info with tracing and careful
> >>> inspection via uAPI. But I don't think that's _easier_.
> >>> And the vendors can't run the results thru their validation
> >>> (for whatever that's worth).
> >>>
> >>>>> I've had the same concern:
> >>>>>
> >>>>> Until we have some userspace library that abstracts all these detai=
ls,
> >>>>> it's not really convenient to use. IIUC, with a kptr, I'd get a blo=
b
> >>>>> of data and I need to go through the code and see what particular t=
ype
> >>>>> it represents for my particular device and how the data I need is
> >>>>> represented there. There are also these "if this is device v1 -> us=
e
> >>>>> v1 descriptor format; if it's a v2->use this another struct; etc"
> >>>>> complexities that we'll be pushing onto the users. With kfuncs, we =
put
> >>>>> this burden on the driver developers, but I agree that the drawback
> >>>>> here is that we actually have to wait for the implementations to ca=
tch
> >>>>> up.
> >>>>
> >>>> I agree with everything there, you will get a blob of data and then
> >>>> will need to know what field you want to read using BTF. But, we
> >>>> already do this for BPF programs all over the place so its not a big
> >>>> lift for us. All other BPF tracing/observability requires the same
> >>>> logic. I think users of BPF in general perhaps XDP/tc are the only
> >>>> place left to write BPF programs without thinking about BTF and
> >>>> kernel data structures.
> >>>>
> >>>> But, with proposed kptr the complexity lives in userspace and can be
> >>>> fixed, added, updated without having to bother with kernel updates, =
etc.
> >>>>  From my point of view of supporting Cilium its a win and much prefe=
rred
> >>>> to having to deal with driver owners on all cloud vendors, distribut=
ions,
> >>>> and so on.
> >>>>
> >>>> If vendor updates firmware with new fields I get those immediately.
> >>>
> >>> Conversely it's a valid concern that those who *do* actually update
> >>> their kernel regularly will have more things to worry about.
> >>>
> >>>>> Jakub mentions FW and I haven't even thought about that; so yeah, b=
pf
> >>>>> programs might have to take a lot of other state into consideration
> >>>>> when parsing the descriptors; all those details do seem like they
> >>>>> belong to the driver code.
> >>>>
> >>>> I would prefer to avoid being stuck on requiring driver writers to
> >>>> be involved. With just a kptr I can support the device and any
> >>>> firwmare versions without requiring help.
> >>>
> >>> 1) where are you getting all those HW / FW specs :S
> >>> 2) maybe *you* can but you're not exactly not an ex-driver developer =
:S
> >>>
> >>>>> Feel free to send it early with just a handful of drivers implement=
ed;
> >>>>> I'm more interested about bpf/af_xdp/user api story; if we have som=
e
> >>>>> nice sample/test case that shows how the metadata can be used, that
> >>>>> might push us closer to the agreement on the best way to proceed.
> >>>>
> >>>> I'll try to do a intel and mlx implementation to get a cross section=
.
> >>>> I have a good collection of nics here so should be able to show a
> >>>> couple firmware versions. It could be fine I think to have the raw
> >>>> kptr access and then also kfuncs for some things perhaps.
> >>>>
> >>>>>> I'd prefer if we left the door open for new vendors. Punting descr=
iptor
> >>>>>> parsing to user space will indeed result in what you just said - m=
ajor
> >>>>>> vendors are supported and that's it.
> >>>>
> >>>> I'm not sure about why it would make it harder for new vendors? I th=
ink
> >>>> the opposite,
> >>>
> >>> TBH I'm only replying to the email because of the above part :)
> >>> I thought this would be self evident, but I guess our perspectives
> >>> are different.
> >>>
> >>> Perhaps you look at it from the perspective of SW running on someone
> >>> else's cloud, an being able to move to another cloud, without having
> >>> to worry if feature X is available in xdp or just skb.
> >>>
> >>> I look at it from the perspective of maintaining a cloud, with people
> >>> writing random XDP applications. If I swap a NIC from an incumbent to=
 a
> >>> (superior) startup, and cloud users are messing with raw descriptor -
> >>> I'd need to go find every XDP program out there and make sure it
> >>> understands the new descriptors.
> >>
> >> Here is another perspective:
> >>
> >> As AF_XDP application developer I don't wan't to deal with the
> >> underlying hardware in detail. I like to request a feature from the OS
> >> (in this case rx/tx timestamping). If the feature is available I will
> >> simply use it, if not I might have to work around it - maybe by fallin=
g
> >> back to SW timestamping.
> >>
> >> All parts of my application (BPF program included) should not be
> >> optimized/adjusted for all the different HW variants out there.
> >
> > Yes, absolutely agreed. Abstracting away those kinds of hardware
> > differences is the whole *point* of having an OS/driver model. I.e.,
> > it's what the kernel is there for! If people want to bypass that and ge=
t
> > direct access to the hardware, they can already do that by using DPDK.
> >
> > So in other words, 100% agreed that we should not expect the BPF
> > developers to deal with hardware details as would be required with a
> > kptr-based interface.
> >
> > As for the kfunc-based interface, I think it shows some promise.
> > Exposing a list of function names to retrieve individual metadata items
> > instead of a struct layout is sorta comparable in terms of developer UI
> > accessibility etc (IMO).
>
> Looks like there are quite some use cases for hw_timestamp.
> Do you think we could add it to the uapi like struct xdp_md?
>
> The following is the current xdp_md:
> struct xdp_md {
>          __u32 data;
>          __u32 data_end;
>          __u32 data_meta;
>          /* Below access go through struct xdp_rxq_info */
>          __u32 ingress_ifindex; /* rxq->dev->ifindex */
>          __u32 rx_queue_index;  /* rxq->queue_index  */
>
>          __u32 egress_ifindex;  /* txq->dev->ifindex */
> };
>
> We could add  __u64 hw_timestamp to the xdp_md so user
> can just do xdp_md->hw_timestamp to get the value.
> xdp_md->hw_timestamp =3D=3D 0 means hw_timestamp is not
> available.
>
> Inside the kernel, the ctx rewriter can generate code
> to call driver specific function to retrieve the data.

If the driver generates the code to retrieve the data, how's that
different from the kfunc approach?
The only difference I see is that it would be a more strong UAPI than
the kfuncs?

> The kfunc approach can be used to *less* common use cases?

What's the advantage of having two approaches when one can cover
common and uncommon cases?

> > There are three main drawbacks, AFAICT:
> >
> > 1. It requires driver developers to write and maintain the code that
> > generates the unrolled BPF bytecode to access the metadata fields, whic=
h
> > is a non-trivial amount of complexity. Maybe this can be abstracted awa=
y
> > with some internal helpers though (like, e.g., a
> > bpf_xdp_metadata_copy_u64(dst, src, offset) helper which would spit out
> > the required JMP/MOV/LDX instructions?
> >
> > 2. AF_XDP programs won't be able to access the metadata without using a
> > custom XDP program that calls the kfuncs and puts the data into the
> > metadata area. We could solve this with some code in libxdp, though; if
> > this code can be made generic enough (so it just dumps the available
> > metadata functions from the running kernel at load time), it may be
> > possible to make it generic enough that it will be forward-compatible
> > with new versions of the kernel that add new fields, which should
> > alleviate Florian's concern about keeping things in sync.
> >
> > 3. It will make it harder to consume the metadata when building SKBs. I
> > think the CPUMAP and veth use cases are also quite important, and that
> > we want metadata to be available for building SKBs in this path. Maybe
> > this can be resolved by having a convenient kfunc for this that can be
> > used for programs doing such redirects. E.g., you could just call
> > xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
> > would recursively expand into all the kfunc calls needed to extract the
> > metadata supported by the SKB path?
> >
> > -Toke
> >
