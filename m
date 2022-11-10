Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C2B6249FA
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 19:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiKJSwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 13:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiKJSwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 13:52:34 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E791CB30
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:52:33 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d3so1478082ils.1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXPql77ETR70D4+Ki5KPU2P7ku92c2gzNayHMoKl8vw=;
        b=fBIi7KiZ7dGs+2UZ2sHn8d/NPh4t2vA3a1cfy0a/cpcWfyHafxM/uzOGVaAOG8QO0y
         /drXsjbJJAm0AVkfp0gf7TvFJ9tjNhfquQdCTL0dMm5nx7rKkvntr6iGSx21xFM9Y2f2
         IW6jcSIDC1kq/3LnPoa1u9n2LhTOrzsrbGBXff+Gu7SRv6aD3p7S+ALixKXq01j9YmL5
         Y7c9bFZ/rDaicEWbkVTrSJH55S2wXzQLiXuQcrVOqt72bjmYnZGGzuN6JzbW3JTD1qm7
         Xug5uB7xHbVyJFiNIBAIzXwdgAFmae7Txx9ogOHjVre8Fk0UkK6nvd+8E8Snag1VxQmI
         i81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXPql77ETR70D4+Ki5KPU2P7ku92c2gzNayHMoKl8vw=;
        b=BABK6OOAg5ipGE5o4AvbhF8g4y0wb7inYW8C28RKAnf2/djT8MCPGkzaz3qsF8lunC
         0Gh4m+kpK2h99EUGXTdI+n73F6T5vpidk8rPHdUQPuBht+T3rge+m+7k9cOZDfK6A/Ks
         TJRsqzh3YViLLG7krrdHdxGdwAROZJQoN20CnAGPY+AhmqZ8icl5jmR6aMwm3toDNv1Z
         tRNngLzxwKJr+cn/Kjnt6KoAfU+hV2Et1PazbFu+sUVlK8XojHNOd6pWi2G1VTq0h+Sn
         wekDrb49K3EGUEoMVW2CLDW9eiDDCWIgGgGQs2IxugWUlXHayp/7pW/SvrPDXC/+A3wO
         lrAA==
X-Gm-Message-State: ACrzQf03/kiUGb02bLtueGy7i5kWQ3TFKVaiPgBx3xsEUTZVvMCaQwOu
        BkOklAEWbbhkD6dm9HlRi6+yazgnw13znzOMWvosYg==
X-Google-Smtp-Source: AMsMyM6NZanLtBx3PVRF0JjSsMtU6FszIa+kJp24LBB3TwNCDEtQB+3Li47y5a19tvOfQrYq50ShqVX0cwdi6H9dgpM=
X-Received: by 2002:a05:6e02:1542:b0:2ff:9e9f:6604 with SMTP id
 j2-20020a056e02154200b002ff9e9f6604mr3433933ilu.20.1668106352183; Thu, 10 Nov
 2022 10:52:32 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev> <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev> <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
 <87leokz8lq.fsf@toke.dk> <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
 <CAKH8qBsfVOoR1MNAFx3uR9Syoc0APHABsf97kb8SGpK+T1qcew@mail.gmail.com>
 <32f81955-8296-6b9a-834a-5184c69d3aac@linux.dev> <CAKH8qBuLMZrFmmi77Qbt7DCd1w9FJwdeK5CnZTJqHYiWxwDx6w@mail.gmail.com>
 <87y1siyjf6.fsf@toke.dk>
In-Reply-To: <87y1siyjf6.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 10 Nov 2022 10:52:21 -0800
Message-ID: <CAKH8qBsfzYmQ9SZXhFetf_zQPNmE_L=_H_rRxJEwZzNbqtoKJA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Nov 10, 2022 at 6:27 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Wed, Nov 9, 2022 at 4:13 PM Martin KaFai Lau <martin.lau@linux.dev> =
wrote:
> >>
> >> On 11/9/22 1:33 PM, Stanislav Fomichev wrote:
> >> > On Wed, Nov 9, 2022 at 10:22 AM Martin KaFai Lau <martin.lau@linux.d=
ev> wrote:
> >> >>
> >> >> On 11/9/22 3:10 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> >>> Snipping a bit of context to reply to this bit:
> >> >>>
> >> >>>>>>> Can the xdp prog still change the metadata through xdp->data_m=
eta? tbh, I am not
> >> >>>>>>> sure it is solid enough by asking the xdp prog not to use the =
same random number
> >> >>>>>>> in its own metadata + not to change the metadata through xdp->=
data_meta after
> >> >>>>>>> calling bpf_xdp_metadata_export_to_skb().
> >> >>>>>>
> >> >>>>>> What do you think the usecase here might be? Or are you suggest=
ing we
> >> >>>>>> reject further access to data_meta after
> >> >>>>>> bpf_xdp_metadata_export_to_skb somehow?
> >> >>>>>>
> >> >>>>>> If we want to let the programs override some of this
> >> >>>>>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can=
 add
> >> >>>>>> more kfuncs instead of exposing the layout?
> >> >>>>>>
> >> >>>>>> bpf_xdp_metadata_export_to_skb(ctx);
> >> >>>>>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
> >> >>>
> >> >>> There are several use cases for needing to access the metadata aft=
er
> >> >>> calling bpf_xdp_metdata_export_to_skb():
> >> >>>
> >> >>> - Accessing the metadata after redirect (in a cpumap or devmap pro=
gram,
> >> >>>     or on a veth device)
> >> >>> - Transferring the packet+metadata to AF_XDP
> >> >> fwiw, the xdp prog could also be more selective and only stores one=
 of the hints
> >> >> instead of the whole 'struct xdp_to_skb_metadata'.
> >> >>
> >> >>> - Returning XDP_PASS, but accessing some of the metadata first (wh=
ether
> >> >>>     to read or change it)
> >> >>>
> >> >>> The last one could be solved by calling additional kfuncs, but tha=
t
> >> >>> would be less efficient than just directly editing the struct whic=
h
> >> >>> will be cache-hot after the helper returns.
> >> >>
> >> >> Yeah, it is more efficient to directly write if possible.  I think =
this set
> >> >> allows the direct reading and writing already through data_meta (as=
 a _u8 *).
> >> >>
> >> >>>
> >> >>> And yeah, this will allow the XDP program to inject arbitrary meta=
data
> >> >>> into the netstack; but it can already inject arbitrary *packet* da=
ta
> >> >>> into the stack, so not sure if this is much of an additional risk?=
 If it
> >> >>> does lead to trivial crashes, we should probably harden the stack
> >> >>> against that?
> >> >>>
> >> >>> As for the random number, Jesper and I discussed replacing this wi=
th the
> >> >>> same BTF-ID scheme that he was using in his patch series. I.e., in=
stead
> >> >>> of just putting in a random number, we insert the BTF ID of the me=
tadata
> >> >>> struct at the end of it. This will allow us to support multiple
> >> >>> different formats in the future (not just changing the layout, but
> >> >>> having multiple simultaneous formats in the same kernel image), in=
 case
> >> >>> we run out of space.
> >> >>
> >> >> This seems a bit hypothetical.  How much headroom does it usually h=
ave for the
> >> >> xdp prog?  Potentially the hints can use all the remaining space le=
ft after the
> >> >> header encap and the current bpf_xdp_adjust_meta() usage?
> >> >>
> >> >>>
> >> >>> We should probably also have a flag set on the xdp_frame so the st=
ack
> >> >>> knows that the metadata area contains relevant-to-skb data, to gua=
rd
> >> >>> against an XDP program accidentally hitting the "magic number" (BT=
F_ID)
> >> >>> in unrelated stuff it puts into the metadata area.
> >> >>
> >> >> Yeah, I think having a flag is useful.  The flag will be set at xdp=
_buff and
> >> >> then transfer to the xdp_frame?
> >> >>
> >> >>>
> >> >>>> After re-reading patch 6, have another question. The 'void
> >> >>>> bpf_xdp_metadata_export_to_skb();' function signature. Should it =
at
> >> >>>> least return ok/err? or even return a 'struct xdp_to_skb_metadata=
 *'
> >> >>>> pointer and the xdp prog can directly read (or even write) it?
> >> >>>
> >> >>> Hmm, I'm not sure returning a failure makes sense? Failure to read=
 one
> >> >>> or more fields just means that those fields will not be populated?=
 We
> >> >>> should probably have a flags field inside the metadata struct itse=
lf to
> >> >>> indicate which fields are set or not, but I'm not sure returning a=
n
> >> >>> error value adds anything? Returning a pointer to the metadata fie=
ld
> >> >>> might be convenient for users (it would just be an alias to the
> >> >>> data_meta pointer, but the verifier could know its size, so the pr=
ogram
> >> >>> doesn't have to bounds check it).
> >> >>
> >> >> If some hints are not available, those hints should be initialized =
to
> >> >> 0/CHECKSUM_NONE/...etc.  The xdp prog needs a direct way to tell ha=
rd failure
> >> >> when it cannot write the meta area because of not enough space.  Co=
mparing
> >> >> xdp->data_meta with xdp->data as a side effect is not intuitive.
> >> >>
> >> >> It is more than saving the bound check.  With type info of 'struct
> >> >> xdp_to_skb_metadata *', the verifier can do more checks like readin=
g in the
> >> >> middle of an integer member.  The verifier could also limit write a=
ccess only to
> >> >> a few struct's members if it is needed.
> >> >>
> >> >> The returning 'struct xdp_to_skb_metadata *' should not be an alias=
 to the
> >> >> xdp->data_meta.  They should actually point to different locations =
in the
> >> >> headroom.  bpf_xdp_metadata_export_to_skb() sets a flag in xdp_buff=
.
> >> >> xdp->data_meta won't be changed and keeps pointing to the last
> >> >> bpf_xdp_adjust_meta() location.  The kernel will know if there is
> >> >> xdp_to_skb_metadata before the xdp->data_meta when that bit is set =
in the
> >> >> xdp_{buff,frame}.  Would it work?
> >> >>
> >> >>>
> >> >>>> A related question, why 'struct xdp_to_skb_metadata' needs
> >> >>>> __randomize_layout?
> >> >>>
> >> >>> The __randomize_layout thing is there to force BPF programs to use=
 CO-RE
> >> >>> to access the field. This is to avoid the struct layout accidental=
ly
> >> >>> ossifying because people in practice rely on a particular layout, =
even
> >> >>> though we tell them to use CO-RE. There are lots of examples of th=
is
> >> >>> happening in other domains (IP header options, TCP options, etc), =
and
> >> >>> __randomize_layout seemed like a neat trick to enforce CO-RE usage=
 :)
> >> >>
> >> >> I am not sure if it is necessary or helpful to only enforce __rando=
mize_layout
> >> >> in 'struct xdp_to_skb_metadata'.  There are other CO-RE use cases (=
tracing and
> >> >> non tracing) that already have direct access (reading and/or writin=
g) to other
> >> >> kernel structures.
> >> >>
> >> >> It is more important for the verifier to see the xdp prog accessing=
 it as a
> >> >> 'struct xdp_to_skb_metadata *' instead of xdp->data_meta which is a=
 __u8 * so
> >> >> that the verifier can enforce the rules of access.
> >> >>
> >> >>>
> >> >>>>>>> Does xdp_to_skb_metadata have a use case for XDP_PASS (like pa=
tch 7) or the
> >> >>>>>>> xdp_to_skb_metadata can be limited to XDP_REDIRECT only?
> >> >>>>>>
> >> >>>>>> XDP_PASS cases where we convert xdp_buff into skb in the driver=
s right
> >> >>>>>> now usually have C code to manually pull out the metadata (out =
of hw
> >> >>>>>> desc) and put it into skb.
> >> >>>>>>
> >> >>>>>> So, currently, if we're calling bpf_xdp_metadata_export_to_skb(=
) for
> >> >>>>>> XDP_PASS, we're doing a double amount of work:
> >> >>>>>> skb_metadata_import_from_xdp first, then custom driver code sec=
ond.
> >> >>>>>>
> >> >>>>>> In theory, maybe we should completely skip drivers custom parsi=
ng when
> >> >>>>>> there is a prog with BPF_F_XDP_HAS_METADATA?
> >> >>>>>> Then both xdp->skb paths (XDP_PASS+XDP_REDIRECT) will be bpf-dr=
iven
> >> >>>>>> and won't require any mental work (plus, the drivers won't have=
 to
> >> >>>>>> care either in the future).
> >> >>>>>>    > WDYT?
> >> >>>>>
> >> >>>>>
> >> >>>>> Yeah, not sure if it can solely depend on BPF_F_XDP_HAS_METADATA=
 but it makes
> >> >>>>> sense to only use the hints (if ever written) from xdp prog espe=
cially if it
> >> >>>>> will eventually support xdp prog changing some of the hints in t=
he future.  For
> >> >>>>> now, I think either way is fine since they are the same and the =
xdp prog is sort
> >> >>>>> of doing extra unnecessary work anyway by calling
> >> >>>>> bpf_xdp_metadata_export_to_skb() with XDP_PASS and knowing nothi=
ng can be
> >> >>>>> changed now.
> >> >>>
> >> >>> I agree it would be best if the drivers also use the XDP metadata =
(if
> >> >>> present) on XDP_PASS. Longer term my hope is we can make the XDP
> >> >>> metadata support the only thing drivers need to implement (i.e., h=
ave
> >> >>> the stack call into that code even when no XDP program is loaded),=
 but
> >> >>> for now just for consistency (and allowing the XDP program to upda=
te the
> >> >>> metadata), we should probably at least consume it on XDP_PASS.
> >> >>>
> >> >>> -Toke
> >> >>>
> >> >
> >> > Not to derail the discussion (left the last message intact on top,
> >> > feel free to continue), but to summarize. The proposed changes seem =
to
> >> > be:
> >> >
> >> > 1. bpf_xdp_metadata_export_to_skb() should return pointer to "struct
> >> > xdp_to_skb_metadata"
> >> >    - This should let bpf programs change the metadata passed to the =
skb
> >> >
> >> > 2. "struct xdp_to_skb_metadata" should have its btf_id as the first
> >> > __u32 member (and remove the magic)
> >> >    - This is for the redirect case where the end users, including
> >> > AF_XDP, can parse this metadata from btf_id
> >>
> >> I think Toke's idea is to put the btf_id at the end of xdp_to_skb_meta=
data.  I
> >> can see why the end is needed for the userspace AF_XDP because, afaict=
, AF_XDP
> >> rx_desc currently cannot tell if there is metadata written by the xdp =
prog or
> >> not.  However, if the 'has_skb_metadata' bit can also be passed to the=
 AF_XDP
> >> rx_desc->options, the btf_id may as well be not needed now.  However, =
the btf_id
> >> and other future new members can be added to the xdp_to_skb_metadata l=
ater if
> >> there is a need.
> >>
> >> For the kernel and xdp prog, a bit in the xdp->flags should be enough =
to get to
> >> the xdp_to_skb_metadata.  The xdp prog will use CO-RE to access the me=
mbers in
> >> xdp_to_skb_metadata.
> >
> > Ack, good points on putting it at the end.
> > Regarding bit in desc->options vs btf_id: since it seems that btf_id
> > is useful anyway, let's start with that? We can add a bit later on if
> > it turns out using metadata is problematic otherwise.
>
> I think the bit is mostly useful so that the stack can know that the
> metadata has been set before consuming it (to guard against regular
> xdp_metadata usage accidentally hitting the "right" BTF ID). I don't
> think it needs to be exposed to the XDP programs themselves.

SG! A flag for xdp_buff/frame and a kfunc to query it for bpf.

> >> >    - This, however, is not all the metadata that the device can
> >> > support, but a much narrower set that the kernel is expected to use
> >> > for skb construction
> >> >
> >> > 3. __randomize_layout isn't really helping, CO-RE will trigger
> >> > regardless; maybe only the case where it matters is probably AF_XDP,
> >> > so still useful?
>
> Yeah, see my response to Martin, I think the randomisation is useful for
> AF_XDP transfer.

SG. Let's keep it for now. Worst case, if it hurts, we can remove it later.=
..

> >> > 4. The presence of the metadata generated by
> >> > bpf_xdp_metadata_export_to_skb should be indicated by a flag in
> >> > xdp_{buff,frame}->flags
> >> >    - Assuming exposing it via xdp_md->has_skb_metadata is ok?
> >>
> >> probably __bpf_md_ptr(struct xdp_to_skb_metadata *, skb_metadata) and =
the type
> >> will be PTR_TO_BTF_ID_OR_NULL.
> >
> > Oh, that seems even better than returning it from
> > bpf_xdp_metadata_export_to_skb.
> > bpf_xdp_metadata_export_to_skb can return true/false and the rest goes
> > via default verifier ctx resolution mechanism..
> > (returning ptr from a kfunc seems to be a bit complicated right now)
>
> See my response to John in the other thread about mixing stable UAPI (in
> xdp_md) and unstable BTF structures in the xdp_md struct: I think this
> is confusing and would prefer a kfunc.

SG!

> >> >    - Since the programs probably need to do the following:
> >> >
> >> >    if (xdp_md->has_skb_metadata) {
> >> >      access/change skb metadata by doing struct xdp_to_skb_metadata =
*p
> >> > =3D data_meta;
> >>
> >> and directly access/change xdp->skb_metadata instead of using xdp->dat=
a_meta.
> >
> > Ack.
> >
> >> >    } else {
> >> >      use kfuncs
> >> >    }
> >> >
> >> > 5. Support the case where we keep program's metadata and kernel's
> >> > xdp_to_skb_metadata
> >> >    - skb_metadata_import_from_xdp() will "consume" it by mem-moving =
the
> >> > rest of the metadata over it and adjusting the headroom
> >>
> >> I was thinking the kernel's xdp_to_skb_metadata is always before the p=
rogram's
> >> metadata.  xdp prog should usually work in this order also: read/write=
 headers,
> >> write its own metadata, call bpf_xdp_metadata_export_to_skb(), and ret=
urn
> >> XDP_PASS/XDP_REDIRECT.  When it is XDP_PASS, the kernel just needs to =
pop the
> >> xdp_to_skb_metadata and pass the remaining program's metadata to the b=
pf-tc.
> >>
> >> For the kernel and xdp prog, I don't think it matters where the
> >> xdp_to_skb_metadata is.  However, the xdp->data_meta (program's metada=
ta) has to
> >> be before xdp->data because of the current data_meta and data comparis=
on usage
> >> in the xdp prog.
> >>
> >> The order of the kernel's xdp_to_skb_metadata and the program's metada=
ta
> >> probably only matters to the userspace AF_XDP.  However, I don't see h=
ow AF_XDP
> >> supports the program's metadata now.  afaict, it can only work now if =
there is
> >> some sort of contract between them or the AF_XDP currently does not us=
e the
> >> program's metadata.  Either way, we can do the mem-moving only for AF_=
XDP and it
> >> should be a no op if there is no program's metadata?  This behavior co=
uld also
> >> be configurable through setsockopt?
> >
> > Agreed on all of the above. For now it seems like the safest thing to
> > do is to put xdp_to_skb_metadata last to allow af_xdp to properly
> > locate btf_id.
> > Let's see if Toke disagrees :-)
>
> As I replied to Martin, I'm not sure it's worth the complexity to
> logically split the SKB metadata from the program's own metadata (as
> opposed to just reusing the existing data_meta pointer)?

I'd gladly keep my current requirement where it's either or, but not both :=
-)
We can relax it later if required?

> However, if we do, the layout that makes most sense to me is putting the
> skb metadata before the program metadata, like:
>
> --------------
> | skb_metadata
> --------------
> | data_meta
> --------------
> | data
> --------------
>
> Not sure if that's what you meant? :)

I was suggesting the other way around: |custom meta|skb_metadata|data|
(but, as Martin points out, consuming skb_metadata in the kernel
becomes messier)

af_xdp can check whether skb_metdata is present by looking at data -
offsetof(struct skb_metadata, btf_id).
progs that know how to handle custom metadata, will look at data -
sizeof(skb_metadata)

Otherwise, if it's the other way around, how do we find skb_metadata
in a redirected frame?
Let's say we have |skb_metadata|custom meta|data|, how does the final
program find skb_metadata?
All the progs have to agree on the sizeof(tc/custom meta), right?
