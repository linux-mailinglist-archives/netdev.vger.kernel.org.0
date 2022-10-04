Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071795F493D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 20:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJDS0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 14:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiJDS0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 14:26:39 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625C14D4FB
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 11:26:36 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e205so11175726iof.1
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 11:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=gRYUajJH2XYeinnw4ZdOwQypb66C3MJhg0f0J+7bVpo=;
        b=I+6Ozq/inY7X0iZUFQJNd8flF81GL7qcsGzd3mNAmMtjiY+mVcHRIISHWNLe3t+OEB
         kqx3PTwgHkOQnO/uhJpxj7oFBCP7DexRGtggYYpgPZO40qgE1hsMWzXuX+Bydv0ot62j
         C1pVsJff8PE67Zg0/siKVYhiIfZ2KSF+L0Zxg6pIfP6WKsECKPPFax3hl2adQhWRJYZ3
         c3yco6zzhYSa5UvuiNVWRdSxyq7iHVSFKOZ6icTDwabnA0UwqkQglAsBdyitMg3vD/Ls
         SSlyBQE7Dyu33scGuPIU0kvgjvBGfdI+6idxrz7wDwiGJ12MkcF3049FspkLeFZM7slq
         /seA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=gRYUajJH2XYeinnw4ZdOwQypb66C3MJhg0f0J+7bVpo=;
        b=IsrAFq2rrtvnw7ooKcGUZEioNheWhdf4KcRiEgFtRx2kb+gi8+nn1vJsWFuRZV1DGE
         y7RdtQroE8XERlvdvOcEvl7cRk2Jjxy4x2cpYFAiGud95afXHriFKWGDqqCWtDV1nNp8
         lUhuYBphKLvIArVAzKBaXr1eYEB0l19Im1D0017oJnrYAwZX3LxRRi/P+OmW+40ejlmq
         lSvvRKx3MdwITYAjhLj2XxQQyLrHGJOMWMVb/c/+l+JrVcgyYzbzFbJEhVXCYlgCarPT
         ZmMsq7Xu2cmF0nxVDyTV86xekD+4tcDN9/i/iVAbYbbkCH7VdwjmMj7jOFML/vjq2v8z
         KuEg==
X-Gm-Message-State: ACrzQf1ODqvjMngwGmXDtuEHI8wBlEhIOhP+3LtvWonSlHp2LRf4WYyy
        sXEvxdpzmTBsmCrv/HbhMN4s/iPnuNQFTeY5AplmDQ==
X-Google-Smtp-Source: AMsMyM66n8pn1uF0KFJJnE/9f0jYA328kb9Lypx761SNt0JKSzmD/uD6FshnqnXboaYSIXJrU06qzjwp6K8qXxmWKKM=
X-Received: by 2002:a05:6602:2a47:b0:6a2:a5d9:c5f2 with SMTP id
 k7-20020a0566022a4700b006a2a5d9c5f2mr11675249iov.131.1664907995422; Tue, 04
 Oct 2022 11:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com> <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
In-Reply-To: <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 4 Oct 2022 11:26:24 -0700
Message-ID: <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 2:29 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 04/10/2022 01.55, sdf@google.com wrote:
> > On 09/07, Jesper Dangaard Brouer wrote:
> >> This patchset expose the traditional hardware offload hints to XDP and
> >> rely on BTF to expose the layout to users.
> >
> >> Main idea is that the kernel and NIC drivers simply defines the struct
> >> layouts they choose to use for XDP-hints. These XDP-hints structs gets
> >> naturally and automatically described via BTF and implicitly exported to
> >> users. NIC drivers populate and records their own BTF ID as the last
> >> member in XDP metadata area (making it easily accessible by AF_XDP
> >> userspace at a known negative offset from packet data start).
> >
> >> Naming conventions for the structs (xdp_hints_*) is used such that
> >> userspace can find and decode the BTF layout and match against the
> >> provided BTF IDs. Thus, no new UAPI interfaces are needed for exporting
> >> what XDP-hints a driver supports.
> >
> >> The patch "i40e: Add xdp_hints_union" introduce the idea of creating a
> >> union named "xdp_hints_union" in every driver, which contains all
> >> xdp_hints_* struct this driver can support. This makes it easier/quicker
> >> to find and parse the relevant BTF types.  (Seeking input before fixing
> >> up all drivers in patchset).
> >
> >
> >> The main different from RFC-v1:
> >>   - Drop idea of BTF "origin" (vmlinux, module or local)
> >>   - Instead to use full 64-bit BTF ID that combine object+type ID
> >
> >> I've taken some of Alexandr/Larysa's libbpf patches and integrated
> >> those.
> >
> >> Patchset exceeds netdev usually max 15 patches rule. My excuse is three
> >> NIC drivers (i40e, ixgbe and mvneta) gets XDP-hints support and which
> >> required some refactoring to remove the SKB dependencies.
> >
> > Hey Jesper,
> >
> > I took a quick look at the series.
> Appreciate that! :-)
>
> > Do we really need the enum with the flags?
>
> The primary reason for using enum is that these gets exposed as BTF.
> The proposal is that userspace/BTF need to obtain the flags via BTF,
> such that they don't become UAPI, but something we can change later.
>
> > We might eventually hit that "first 16 bits are reserved" issue?
> >
> > Instead of exposing enum with the flags, why not solve it as follows:
> > a. We define UAPI struct xdp_rx_hints with _all_ possible hints
>
> How can we know _all_ possible hints from the beginning(?).
>
> UAPI + central struct dictating all possible hints, will limit innovation.

We don't need to know them all in advance. The same way we don't know
them all for flags enum. That UAPI xdp_rx_hints can be extended any
time some driver needs some new hint offload. The benefit here is that
we have a "common registry" of all offloads and different drivers have
an opportunity to share.

Think of it like current __sk_buff vs sk_buff. xdp_rx_hints is a fake
uapi struct (__sk_buff) and the access to it gets translated into
<device>_xdp_rx_hints offsets (sk_buff).

> > b. Each device defines much denser <device>_xdp_rx_hints struct with the
> >     metadata that it supports
>
> Thus, the NIC device is limited to what is defined in UAPI struct
> xdp_rx_hints.  Again this limits innovation.

I guess what I'm missing from your series is the bpf/userspace side.
Do you have an example on the bpf side that will work for, say,
xdp_hints_ixgbe_timestamp?

Suppose, you pass this custom hints btf_id via xdp_md as proposed,
what's the action on the bpf side to consume this?

If (ctx_hints_btf_id == xdp_hints_ixgbe_timestamp_btf_id /* supposedly
populated at runtime by libbpf? */) {
  // do something with rx_timestamp
  // also, handle xdp_hints_ixgbe and then xdp_hints_common ?
} else if (ctx_hints_btf_id == xdp_hints_ixgbe) {
  // do something else
  // plus explicitly handle xdp_hints_common here?
} else {
  // handle xdp_hints_common
}

What I'd like to avoid is an xdp program targeting specific drivers.
Where possible, we should aim towards something like "if this device
has rx_timestamp offload -> use it without depending too much on
specific btf_ids.

> > c. The subset of fields in <device>_xdp_rx_hints should match the ones from
> >     xdp_rx_hints (we essentially standardize on the field names/sizes)
> > d. We expose <device>_xdp_rx_hints btf id via netlink for each device
>
> For this proposed design you would still need more than one BTF ID or
> <device>_xdp_rx_hints struct's, because not all packets contains all
> hints. The most common case is HW timestamping, which some HW only
> supports for PTP frames.
>
> Plus, I don't see a need to expose anything via netlink, as we can just
> use the existing BTF information from the module.  Thus, avoiding to
> creating more UAPI.

See above. I think even with your series, that btf_id info should also
come via netlink so the programs can query it before loading and do
the required adjustments. Otherwise, I'm not sure I understand what I
need to do with a btf_id that comes via xdp_md/xdp_frame. It seems too
late? I need to know them in advance to at least populate those ids
into the bpf program itself?

> > e. libbpf will query and do offset relocations for
> >     xdp_rx_hints -> <device>_xdp_rx_hints at load time
> >
> > Would that work? Then it seems like we can replace bitfields with the
>
> I used to be a fan of bitfields, until I discovered that they are bad
> for performance, because compilers cannot optimize these.

Ack, good point, something to keep in mind.

> > following:
> >
> >    if (bpf_core_field_exists(struct xdp_rx_hints, vlan_tci)) {
> >      /* use that hint */
>
> Fairly often a VLAN will not be set in packets, so we still have to read
> and check a bitfield/flag if the VLAN value is valid. (Guess it is
> implicit in above code).

That's a fair point. Then we need two signals?

1. Whether this particular offload is supported for the device at all
(via that bpf_core_field_exists or something similar)
2. Whether this particular packet has particular metadata (via your
proposed flags)

if (device I'm attaching xdp to has vlan offload) { // via
bpf_core_field_exists?
  if (particular packet comes with a vlan tag) { // via your proposed
bitfield flags?
  }
}

Or are we assuming that (2) is fast enough and we don't care about
(1)? Because (1) can 'if (0)' the whole branch and make the verifier
remove that part.

> >    }
> >
> > All we need here is for libbpf to, again, do xdp_rx_hints ->
> > <device>_xdp_rx_hints translation before it evaluates
> > bpf_core_field_exists()?
> >
> > Thoughts? Any downsides? Am I missing something?
> >
>
> Well, the downside is primarily that this design limits innovation.
>
> Each time a NIC driver want to introduce a new hardware hint, they have
> to update the central UAPI xdp_rx_hints struct first.
>
> The design in the patchset is to open for innovation.  Driver can extend
> their own xdp_hints_<driver>_xxx struct(s).  They still have to land
> their patches upstream, but avoid mangling a central UAPI struct. As
> upstream we review driver changes and should focus on sane struct member
> naming(+size) especially if this "sounds" like a hint/feature that more
> driver are likely to support.  With help from BTF relocations, a new
> driver can support same hint/feature if naming(+size) match (without
> necessary the same offset in the struct).

The opposite side of this approach is that we'll have 'ixgbe_hints'
with 'rx_timestamp' and 'mvneta_hints' with something like
'rx_tstamp'.

> > Also, about the TX side: I feel like the same can be applied there,
> > the program works with xdp_tx_hints and libbpf will rewrite to
> > <device>_xdp_tx_hints. xdp_tx_hints might have fields like "has_tx_vlan:1";
> > those, presumably, can be relocatable by libbpf as well?
> >
>
> Good to think ahead for TX-side, even-though I think we should focus on
> landing RX-side first.
>
> I notice your naming xdp_rx_hints vs. xdp_tx_hints.  I have named the
> common struct xdp_hints_common, without a RX/TX direction indication.
> Maybe this is wrong of me, but my thinking was that most of the common
> hints can be directly used as TX-side hints.  I'm hoping TX-side
> xdp-hints will need to do little-to-non adjustment, before using the
> hints as TX "instruction".  I'm hoping that XDP-redirect will just work
> and xmit driver can use XDP-hints area.
>
> Please correct me if I'm wrong.
> The checksum fields hopefully translates to similar TX offload "actions".
> The VLAN offload hint should translate directly to TX-side.
>
> I can easily be convinced we should name it xdp_hints_rx_common from the
> start, but then I will propose that xdp_hints_tx_common have the
> checksum and VLAN fields+flags at same locations, such that we don't
> take any performance hint for moving them to "TX-side" hints, making
> XDP-redirect just work.

Might be good to think about this beforehand. I agree that most of the
layout should hopefully match. However once case that I'm interested
in is rx_timestamp vs tx_timestamp. For rx, I'm getting the timestamp
in the metadata; for tx, I'm merely setting a flag somewhere to
request it for async delivery later (I hope we plan to support that
for af_xdp?). So the layout might be completely different :-(

On Tue, Oct 4, 2022 at 2:29 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 04/10/2022 01.55, sdf@google.com wrote:
> > On 09/07, Jesper Dangaard Brouer wrote:
> >> This patchset expose the traditional hardware offload hints to XDP and
> >> rely on BTF to expose the layout to users.
> >
> >> Main idea is that the kernel and NIC drivers simply defines the struct
> >> layouts they choose to use for XDP-hints. These XDP-hints structs gets
> >> naturally and automatically described via BTF and implicitly exported to
> >> users. NIC drivers populate and records their own BTF ID as the last
> >> member in XDP metadata area (making it easily accessible by AF_XDP
> >> userspace at a known negative offset from packet data start).
> >
> >> Naming conventions for the structs (xdp_hints_*) is used such that
> >> userspace can find and decode the BTF layout and match against the
> >> provided BTF IDs. Thus, no new UAPI interfaces are needed for exporting
> >> what XDP-hints a driver supports.
> >
> >> The patch "i40e: Add xdp_hints_union" introduce the idea of creating a
> >> union named "xdp_hints_union" in every driver, which contains all
> >> xdp_hints_* struct this driver can support. This makes it easier/quicker
> >> to find and parse the relevant BTF types.  (Seeking input before fixing
> >> up all drivers in patchset).
> >
> >
> >> The main different from RFC-v1:
> >>   - Drop idea of BTF "origin" (vmlinux, module or local)
> >>   - Instead to use full 64-bit BTF ID that combine object+type ID
> >
> >> I've taken some of Alexandr/Larysa's libbpf patches and integrated
> >> those.
> >
> >> Patchset exceeds netdev usually max 15 patches rule. My excuse is three
> >> NIC drivers (i40e, ixgbe and mvneta) gets XDP-hints support and which
> >> required some refactoring to remove the SKB dependencies.
> >
> > Hey Jesper,
> >
> > I took a quick look at the series.
> Appreciate that! :-)
>
> > Do we really need the enum with the flags?
>
> The primary reason for using enum is that these gets exposed as BTF.
> The proposal is that userspace/BTF need to obtain the flags via BTF,
> such that they don't become UAPI, but something we can change later.
>
> > We might eventually hit that "first 16 bits are reserved" issue?
> >
> > Instead of exposing enum with the flags, why not solve it as follows:
> > a. We define UAPI struct xdp_rx_hints with _all_ possible hints
>
> How can we know _all_ possible hints from the beginning(?).
>
> UAPI + central struct dictating all possible hints, will limit innovation.
>
> > b. Each device defines much denser <device>_xdp_rx_hints struct with the
> >     metadata that it supports
>
> Thus, the NIC device is limited to what is defined in UAPI struct
> xdp_rx_hints.  Again this limits innovation.
>
> > c. The subset of fields in <device>_xdp_rx_hints should match the ones from
> >     xdp_rx_hints (we essentially standardize on the field names/sizes)
> > d. We expose <device>_xdp_rx_hints btf id via netlink for each device
>
> For this proposed design you would still need more than one BTF ID or
> <device>_xdp_rx_hints struct's, because not all packets contains all
> hints. The most common case is HW timestamping, which some HW only
> supports for PTP frames.
>
> Plus, I don't see a need to expose anything via netlink, as we can just
> use the existing BTF information from the module.  Thus, avoiding to
> creating more UAPI.
>
> > e. libbpf will query and do offset relocations for
> >     xdp_rx_hints -> <device>_xdp_rx_hints at load time
> >
> > Would that work? Then it seems like we can replace bitfields with the
>
> I used to be a fan of bitfields, until I discovered that they are bad
> for performance, because compilers cannot optimize these.
>
> > following:
> >
> >    if (bpf_core_field_exists(struct xdp_rx_hints, vlan_tci)) {
> >      /* use that hint */
>
> Fairly often a VLAN will not be set in packets, so we still have to read
> and check a bitfield/flag if the VLAN value is valid. (Guess it is
> implicit in above code).
>
> >    }
> >
> > All we need here is for libbpf to, again, do xdp_rx_hints ->
> > <device>_xdp_rx_hints translation before it evaluates
> > bpf_core_field_exists()?
> >
> > Thoughts? Any downsides? Am I missing something?
> >
>
> Well, the downside is primarily that this design limits innovation.
>
> Each time a NIC driver want to introduce a new hardware hint, they have
> to update the central UAPI xdp_rx_hints struct first.
>
> The design in the patchset is to open for innovation.  Driver can extend
> their own xdp_hints_<driver>_xxx struct(s).  They still have to land
> their patches upstream, but avoid mangling a central UAPI struct. As
> upstream we review driver changes and should focus on sane struct member
> naming(+size) especially if this "sounds" like a hint/feature that more
> driver are likely to support.  With help from BTF relocations, a new
> driver can support same hint/feature if naming(+size) match (without
> necessary the same offset in the struct).
>
> > Also, about the TX side: I feel like the same can be applied there,
> > the program works with xdp_tx_hints and libbpf will rewrite to
> > <device>_xdp_tx_hints. xdp_tx_hints might have fields like "has_tx_vlan:1";
> > those, presumably, can be relocatable by libbpf as well?
> >
>
> Good to think ahead for TX-side, even-though I think we should focus on
> landing RX-side first.
>
> I notice your naming xdp_rx_hints vs. xdp_tx_hints.  I have named the
> common struct xdp_hints_common, without a RX/TX direction indication.
> Maybe this is wrong of me, but my thinking was that most of the common
> hints can be directly used as TX-side hints.  I'm hoping TX-side
> xdp-hints will need to do little-to-non adjustment, before using the
> hints as TX "instruction".  I'm hoping that XDP-redirect will just work
> and xmit driver can use XDP-hints area.
>
> Please correct me if I'm wrong.
> The checksum fields hopefully translates to similar TX offload "actions".
> The VLAN offload hint should translate directly to TX-side.
>
> I can easily be convinced we should name it xdp_hints_rx_common from the
> start, but then I will propose that xdp_hints_tx_common have the
> checksum and VLAN fields+flags at same locations, such that we don't
> take any performance hint for moving them to "TX-side" hints, making
> XDP-redirect just work.
>
> --Jesper
>
