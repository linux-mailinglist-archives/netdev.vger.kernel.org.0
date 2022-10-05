Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050B25F5A09
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 20:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiJESpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 14:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiJESpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 14:45:02 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB746814C5
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 11:43:02 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y15-20020aa78f2f000000b00562674456afso269474pfr.9
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 11:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LWoHnxwZ5YMv6UWo8LFZ+JnbPH00J+hdwCUgN3m2CC8=;
        b=iTmLqcvcyjA2UndngembIehCAIUpF4VV3gJtHSNlJzk55aUTEkBpv6mX5wuAqkXHLl
         bQB0SU+L5OmzYq994nUJlo6CtblENF8gr5GYL745aWKRA2fPgtBb4vQOZL3KBbyBnOov
         mMQ23tECX49z6TGmTHXEIC0isdSkJxYdhR0lnEnqkH2TQGi77GEPr/ShbNKgJwWdytc9
         uKQCXr4/wibEtDMfz43EcEP62+HLKx93QzmBrFgQyeDQ6xcEywm9aKIqWV9QRZCgOpdB
         W4OsCOTSjrMpRWY6XalgDHtuPxfnRKykRmJNiLFI5x90tywY0EJO8vPnHAbewMy/GBMs
         aYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWoHnxwZ5YMv6UWo8LFZ+JnbPH00J+hdwCUgN3m2CC8=;
        b=K1B4lrr7lkFnhZFvSxV8cU6VCpwRElqPxVMKfjVpw0XbLoGyjld2wXiElG2hKRdDJt
         V7j2L8NYaU5aI/0zu52cM9A0utSh6AcNFFWzL2POZXAQZMXgHinEta607coLAPiW7Poe
         QRRgFCX1zEhb5wqux7oLH/fmjCQkbprxvjk9WoZpfo+unWsAKFC1EA+nxIldhibyuA8M
         bgx/Yt+ENkU4E1dQS4E+KR0/o21yx+ZrWLTK6GjiaBBvhbr5bt//e6rZOX+wwRvnKhin
         S5bac98q3DFHpphoTBF5Hji4N6gNk63araQ+K+j4TDWPouu542mBqoNIA+N09af5Nbnk
         4B5w==
X-Gm-Message-State: ACrzQf2uuAEPbjmPVzuEj67KpkNOtw7c+4xJvuxXTtaXwGGp0b9o9hXY
        aTmXZL9AS6nRsPjoZ/zdC0E/rnM=
X-Google-Smtp-Source: AMsMyM5FoiOuhaCiandc5Gt+/xWG324mXluktP4GOzjHEKjFkX5poKV1r882AT0DmBY/v0RD+xWuSOY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2290:b0:541:f19:5197 with SMTP id
 f16-20020a056a00229000b005410f195197mr1166353pfe.42.1664995382119; Wed, 05
 Oct 2022 11:43:02 -0700 (PDT)
Date:   Wed, 5 Oct 2022 11:43:00 -0700
In-Reply-To: <982b9125-f849-5e1c-0082-7239b8c8eebf@redhat.com>
Mime-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com> <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com> <982b9125-f849-5e1c-0082-7239b8c8eebf@redhat.com>
Message-ID: <Yz3QNM7061WmXDHS@google.com>
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
From:   sdf@google.com
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05, Jesper Dangaard Brouer wrote:


> On 04/10/2022 20.26, Stanislav Fomichev wrote:
> > On Tue, Oct 4, 2022 at 2:29 AM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> > >
> > >
> > > On 04/10/2022 01.55, sdf@google.com wrote:
> > > > On 09/07, Jesper Dangaard Brouer wrote:
> > > > > This patchset expose the traditional hardware offload hints to  
> XDP and
> > > > > rely on BTF to expose the layout to users.
> > > >
> > > > > Main idea is that the kernel and NIC drivers simply defines the  
> struct
> > > > > layouts they choose to use for XDP-hints. These XDP-hints structs  
> gets
> > > > > naturally and automatically described via BTF and implicitly  
> exported to
> > > > > users. NIC drivers populate and records their own BTF ID as the  
> last
> > > > > member in XDP metadata area (making it easily accessible by AF_XDP
> > > > > userspace at a known negative offset from packet data start).
> > > >
> > > > > Naming conventions for the structs (xdp_hints_*) is used such that
> > > > > userspace can find and decode the BTF layout and match against the
> > > > > provided BTF IDs. Thus, no new UAPI interfaces are needed for  
> exporting
> > > > > what XDP-hints a driver supports.
> > > >
> > > > > The patch "i40e: Add xdp_hints_union" introduce the idea of  
> creating a
> > > > > union named "xdp_hints_union" in every driver, which contains all
> > > > > xdp_hints_* struct this driver can support. This makes it  
> easier/quicker
> > > > > to find and parse the relevant BTF types.  (Seeking input before  
> fixing
> > > > > up all drivers in patchset).
> > > >
> > > >
> > > > > The main different from RFC-v1:
> > > > >    - Drop idea of BTF "origin" (vmlinux, module or local)
> > > > >    - Instead to use full 64-bit BTF ID that combine object+type ID
> > > >
> > > > > I've taken some of Alexandr/Larysa's libbpf patches and integrated
> > > > > those.
> > > >
> > > > > Patchset exceeds netdev usually max 15 patches rule. My excuse is  
> three
> > > > > NIC drivers (i40e, ixgbe and mvneta) gets XDP-hints support and  
> which
> > > > > required some refactoring to remove the SKB dependencies.
> > > >
> > > > Hey Jesper,
> > > >
> > > > I took a quick look at the series.
> > > Appreciate that! :-)
> > >
> > > > Do we really need the enum with the flags?
> > >
> > > The primary reason for using enum is that these gets exposed as BTF.
> > > The proposal is that userspace/BTF need to obtain the flags via BTF,
> > > such that they don't become UAPI, but something we can change later.
> > >
> > > > We might eventually hit that "first 16 bits are reserved" issue?
> > > >
> > > > Instead of exposing enum with the flags, why not solve it as  
> follows:
> > > > a. We define UAPI struct xdp_rx_hints with _all_ possible hints
> > >
> > > How can we know _all_ possible hints from the beginning(?).
> > >
> > > UAPI + central struct dictating all possible hints, will limit  
> innovation.
> >
> > We don't need to know them all in advance. The same way we don't know
> > them all for flags enum. That UAPI xdp_rx_hints can be extended any
> > time some driver needs some new hint offload. The benefit here is that
> > we have a "common registry" of all offloads and different drivers have
> > an opportunity to share.
> >
> > Think of it like current __sk_buff vs sk_buff. xdp_rx_hints is a fake
> > uapi struct (__sk_buff) and the access to it gets translated into
> > <device>_xdp_rx_hints offsets (sk_buff).
> >
> > > > b. Each device defines much denser <device>_xdp_rx_hints struct  
> with the
> > > >      metadata that it supports
> > >
> > > Thus, the NIC device is limited to what is defined in UAPI struct
> > > xdp_rx_hints.  Again this limits innovation.
> >
> > I guess what I'm missing from your series is the bpf/userspace side.
> > Do you have an example on the bpf side that will work for, say,
> > xdp_hints_ixgbe_timestamp?
> >
> > Suppose, you pass this custom hints btf_id via xdp_md as proposed,

> I just want to reiterate why we place btf_full_id at the "end inline".
> This makes it easily available for AF_XDP to consume.  Plus, we already
> have to write info into this metadata cache-line anyway, thus it's
> almost free.  Moving bpf_full_id into xdp_md, will require expanding
> both xdp_buff and xdp_frame (+ extra store for converting
> buff-to-frame). If AF_XDP need this btf_full_id the BPF-prog _could_
> move/copy it from xdp_md to metadata, but that will just waste cycles,
> why not just store it once in a known location.

> One option, for convenience, would be to map xdp_md->bpf_full_id to load
> the btf_full_id value from the metadata.  But that would essentially be
> syntax-sugar and adds UAPI.

> > what's the action on the bpf side to consume this?
> >
> > If (ctx_hints_btf_id == xdp_hints_ixgbe_timestamp_btf_id /* supposedly
> > populated at runtime by libbpf? */) {

> See e.g. bpf_core_type_id_kernel(struct xdp_hints_ixgbe_timestamp)
> AFAIK libbpf will make this a constant at load/setup time, and give us
> dead-code elimination.

Even with bpf_core_type_id_kernel() you still would have the following:

	if (ctx_hints_btf_id == bpf_core_type_id_kernel(struct xdp_hints_ixgbe)) {
	} else if (the same for every driver that has custom hints) {
	}

Toke has a good suggestion on hiding this behind a helper; either
pre-generated on the libbpf side or a kfunc. We should try to hide
this per-device logic if possible; otherwise we'll get to per-device
XDP programs that only work on some special deployments. OTOH, we'll
probably get there with the hints anyway?

> >    // do something with rx_timestamp
> >    // also, handle xdp_hints_ixgbe and then xdp_hints_common ?
> > } else if (ctx_hints_btf_id == xdp_hints_ixgbe) {
> >    // do something else
> >    // plus explicitly handle xdp_hints_common here?
> > } else {
> >    // handle xdp_hints_common
> > }

> I added a BPF-helper that can tell us if layout if compatible with
> xdp_hints_common, which is basically the only UAPI the patchset  
> introduces.
> The handle xdp_hints_common code should be common.

> I'm not super happy with the BPF-helper approach, so suggestions are
> welcome.  E.g. xdp_md/ctx->is_hint_common could be one approach and
> ctx->has_hint (ctx is often called xdp so it reads xdp->has_hint).

> One feature I need from the BPF-helper is to "disable" the xdp_hints and
> allow the BPF-prog to use the entire metadata area for something else
> (avoiding it to be misintrepreted by next prog or after redirect).

As mentioned in the previous emails, let's try to have a bpf side
example/selftest for the next round? I also feel like xdp_hints_common is
a bit distracting. It makes the common case easy and it hides the
discussion/complexity about per-device hints. Maybe we can drop this
common case at all? Why can't every driver has a custom hints struct?
If we agree that naming/size will be the same across them (and review
catches/guaranteed that), why do we even care about having common
xdp_hints_common struct?

> > What I'd like to avoid is an xdp program targeting specific drivers.
> > Where possible, we should aim towards something like "if this device
> > has rx_timestamp offload -> use it without depending too much on
> > specific btf_ids.
> >

> I do understand your wish, and adding rx_timestamps to xdp_hints_common
> would be too easy (and IMHO wasting u64/8-bytes for all packets not
> needing this timestamp).  Hopefully we can come up with a good solution
> together.

> One idea would be to extend libbpf to lookup or translate struct name

>   struct xdp_hints_DRIVER_timestamp {
>     __u64 rx_timestamp;
>   } __attribute__((preserve_access_index));

> into e.g. xdp_hints_i40e_timestamp, if an ifindex was provided when  
> loading
> the XDP prog.  And the bpf_core_type_id_kernel() result of the struct
> returning id from xdp_hints_i40e_timestamp.

> But this ideas doesn't really work for the veth redirect use-case :-(
> As veth need to handle xdp_hints from other drivers.

Agreed. If we want redirect to work, then the parsing should be either
mostly pre-generated by libbpf to include all possible btf ids that
matter; or done similarly by a kfunc. The idea that we can pre-generate
per-device bpf program seems to be out of the window now?

> > > > c. The subset of fields in <device>_xdp_rx_hints should match the  
> ones from
> > > >      xdp_rx_hints (we essentially standardize on the field  
> names/sizes)
> > > > d. We expose <device>_xdp_rx_hints btf id via netlink for each  
> device
> > >
> > > For this proposed design you would still need more than one BTF ID or
> > > <device>_xdp_rx_hints struct's, because not all packets contains all
> > > hints. The most common case is HW timestamping, which some HW only
> > > supports for PTP frames.
> > >
> > > Plus, I don't see a need to expose anything via netlink, as we can  
> just
> > > use the existing BTF information from the module.  Thus, avoiding to
> > > creating more UAPI.
> >
> > See above. I think even with your series, that btf_id info should also
> > come via netlink so the programs can query it before loading and do
> > the required adjustments. Otherwise, I'm not sure I understand what I
> > need to do with a btf_id that comes via xdp_md/xdp_frame. It seems too
> > late? I need to know them in advance to at least populate those ids
> > into the bpf program itself?

> Yes, we need to know these IDs in advance and can.  I don't think we need
> the netlink interface, as we can already read out the BTF layout and IDs
> today.  I coded it up in userspace, where the intented consumer is AF_XDP
> (as libbpf already does this itself).

> See this code:
>   -  
> https://github.com/xdp-project/bpf-examples/blob/master/BTF-playground/btf_module_ids.c
>   -  
> https://github.com/xdp-project/bpf-examples/blob/master/BTF-playground/btf_module_read.c

SG, if we can have some convention on the names where we can reliably
parse out all possible structs with the hints, let's rely solely on
vmlinux+vmlinux module btf.

> > > > e. libbpf will query and do offset relocations for
> > > >      xdp_rx_hints -> <device>_xdp_rx_hints at load time
> > > >
> > > > Would that work? Then it seems like we can replace bitfields with  
> the
> > >
> > > I used to be a fan of bitfields, until I discovered that they are bad
> > > for performance, because compilers cannot optimize these.
> >
> > Ack, good point, something to keep in mind.
> >
> > > > following:
> > > >
> > > >     if (bpf_core_field_exists(struct xdp_rx_hints, vlan_tci)) {
> > > >       /* use that hint */
> > >
> > > Fairly often a VLAN will not be set in packets, so we still have to  
> read
> > > and check a bitfield/flag if the VLAN value is valid. (Guess it is
> > > implicit in above code).
> >
> > That's a fair point. Then we need two signals?
> >
> > 1. Whether this particular offload is supported for the device at all
> > (via that bpf_core_field_exists or something similar)
> > 2. Whether this particular packet has particular metadata (via your
> > proposed flags)
> >
> > if (device I'm attaching xdp to has vlan offload) { // via
> > bpf_core_field_exists?
> >    if (particular packet comes with a vlan tag) { // via your proposed
> > bitfield flags?
> >    }
> > }
> >
> > Or are we assuming that (2) is fast enough and we don't care about
> > (1)? Because (1) can 'if (0)' the whole branch and make the verifier
> > remove that part.
> >
> > > >     }
> > > >
> > > > All we need here is for libbpf to, again, do xdp_rx_hints ->
> > > > <device>_xdp_rx_hints translation before it evaluates
> > > > bpf_core_field_exists()?
> > > >
> > > > Thoughts? Any downsides? Am I missing something?
> > > >
> > >
> > > Well, the downside is primarily that this design limits innovation.
> > >
> > > Each time a NIC driver want to introduce a new hardware hint, they  
> have
> > > to update the central UAPI xdp_rx_hints struct first.
> > >
> > > The design in the patchset is to open for innovation.  Driver can  
> extend
> > > their own xdp_hints_<driver>_xxx struct(s).  They still have to land
> > > their patches upstream, but avoid mangling a central UAPI struct. As
> > > upstream we review driver changes and should focus on sane struct  
> member
> > > naming(+size) especially if this "sounds" like a hint/feature that  
> more
> > > driver are likely to support.  With help from BTF relocations, a new
> > > driver can support same hint/feature if naming(+size) match (without
> > > necessary the same offset in the struct).
> >
> > The opposite side of this approach is that we'll have 'ixgbe_hints'
> > with 'rx_timestamp' and 'mvneta_hints' with something like
> > 'rx_tstamp'.

> Well, as I wrote reviewers should ask drivers to use the same member name.

SG!

> > > > Also, about the TX side: I feel like the same can be applied there,
> > > > the program works with xdp_tx_hints and libbpf will rewrite to
> > > > <device>_xdp_tx_hints. xdp_tx_hints might have fields  
> like "has_tx_vlan:1";
> > > > those, presumably, can be relocatable by libbpf as well?
> > > >
> > >
> > > Good to think ahead for TX-side, even-though I think we should focus  
> on
> > > landing RX-side first.
> > >
> > > I notice your naming xdp_rx_hints vs. xdp_tx_hints.  I have named the
> > > common struct xdp_hints_common, without a RX/TX direction indication.
> > > Maybe this is wrong of me, but my thinking was that most of the common
> > > hints can be directly used as TX-side hints.  I'm hoping TX-side
> > > xdp-hints will need to do little-to-non adjustment, before using the
> > > hints as TX "instruction".  I'm hoping that XDP-redirect will just  
> work
> > > and xmit driver can use XDP-hints area.
> > >
> > > Please correct me if I'm wrong.
> > > The checksum fields hopefully translates to similar TX  
> offload "actions".
> > > The VLAN offload hint should translate directly to TX-side.
> > >
> > > I can easily be convinced we should name it xdp_hints_rx_common from  
> the
> > > start, but then I will propose that xdp_hints_tx_common have the
> > > checksum and VLAN fields+flags at same locations, such that we don't
> > > take any performance hint for moving them to "TX-side" hints, making
> > > XDP-redirect just work.
> >
> > Might be good to think about this beforehand. I agree that most of the
> > layout should hopefully match. However once case that I'm interested
> > in is rx_timestamp vs tx_timestamp. For rx, I'm getting the timestamp
> > in the metadata; for tx, I'm merely setting a flag somewhere to
> > request it for async delivery later (I hope we plan to support that
> > for af_xdp?). So the layout might be completely different :-(
> >

> Yes, it is definitely in my plans to support handling at TX-completion
> time, so you can extract the TX-wire-timestamp.  This is easy for AF_XDP
> as it has the CQ (Completion Queue) step.

> I'm getting ahead of myself, but for XDP I imagine that driver will
> populate this xdp_tx_hint in DMA TX-completion function, and we can add
> a kfunc "not-a-real-hook" to xdp_return_frame that can run another XDP
> BPF-prog that can inspect the xdp_tx_hint in metadata.

Can we also place that xdp_tx_hint somewhere in the completion ring
for AF_XDP to consume?

> At this proposed kfunc xdp_return_frame call point, we likely cannot know
> what driver that produced the xdp_hints metadata either, and thus not lock
> our design or BTF-reloacations to assume which driver is it loaded on.

> [... cut ... getting too long]

> --Jesper

