Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16866235DC
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiKIVdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKIVdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:33:22 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D19D264BC
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 13:33:20 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id h206so14987672iof.10
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 13:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PyXyVL/Z+RUnZ+jmkHNbcIWBek0qjReCVML/hp+yGBY=;
        b=SyjyZwnppvgf/6k9LzLkEsh6tb8AEiPF6mvGtj0TxFlnTlTo5habksS8c50y2XeuYH
         hjwyUslbwYUesMaHdASNHygIGrKsla2NK/qYnD5WZKChe36gvpVV7EZ52HdevuGSBPfh
         r0I5ljntIkFhXN9ZXLly2Hde3wm7NLj4Diee2U/flpZOSQes+b9eXKbb5jKmGqz9JYYB
         wsD0RxZ0345QUaLmR6IGLUp17h7prI21i4vvXJh2/cB7d7x/4A5Gcu6BUnQto6KMMGlJ
         +ZkuYrCJ9VT2eqibuGykR+eaqA/OytBinJzIqIF71DAF3EXimAojX8FPDQvbX13HQ9nK
         +qqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PyXyVL/Z+RUnZ+jmkHNbcIWBek0qjReCVML/hp+yGBY=;
        b=u4h6eSsrRXDmbaK+xBUPw9/3oEjS3fs9qPra3CJ4osipOrcniurJ0HlFtzXMdN3FhW
         G6uOR9a2skmUR7k5OR1f5EbChuhKK6Zn60Ru8VSVCuIWBcN2/rVljupgB67tWi91jJcs
         3q8td6CeomtddYVEd3LbDTAm3/VQfZbmCgJItBC2hZdZoUCCm7xoFptBb1CsYY+7DZYF
         llZE2Ink7u3p4Fi9CU7OqU4LPVS7LHJNjymHJwUBQMqIfJwIFzdxUbV+qcZ2kxYvOQmu
         ysVPCrugyCE2Adk9cXV7V+/MfAav8h9zuGbsPF/e8vpMxu6Qw8RrGyklta4wYt2LkW8/
         YzzQ==
X-Gm-Message-State: ACrzQf2fn1QC6z/U//zY6za/BgPd1G6l+e6/Tyzg48Agp/BnZFdpHaYe
        yuG2wcPRFcQit54JyATbhB0vg1oeA5OrCg1zgTydgw==
X-Google-Smtp-Source: AMsMyM5cpFUZJn2dMV9xm4c81KxfmuHl38zlehFlqfkcBeU/lQHzWZuuCN6SB2xUbE+aysRupfUa9WLBo4MCI8gtWJQ=
X-Received: by 2002:a02:9401:0:b0:375:6e82:482b with SMTP id
 a1-20020a029401000000b003756e82482bmr25456380jai.84.1668029599385; Wed, 09
 Nov 2022 13:33:19 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev> <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev> <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
 <87leokz8lq.fsf@toke.dk> <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
In-Reply-To: <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 9 Nov 2022 13:33:08 -0800
Message-ID: <CAKH8qBsfVOoR1MNAFx3uR9Syoc0APHABsf97kb8SGpK+T1qcew@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
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

On Wed, Nov 9, 2022 at 10:22 AM Martin KaFai Lau <martin.lau@linux.dev> wro=
te:
>
> On 11/9/22 3:10 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Snipping a bit of context to reply to this bit:
> >
> >>>>> Can the xdp prog still change the metadata through xdp->data_meta? =
tbh, I am not
> >>>>> sure it is solid enough by asking the xdp prog not to use the same =
random number
> >>>>> in its own metadata + not to change the metadata through xdp->data_=
meta after
> >>>>> calling bpf_xdp_metadata_export_to_skb().
> >>>>
> >>>> What do you think the usecase here might be? Or are you suggesting w=
e
> >>>> reject further access to data_meta after
> >>>> bpf_xdp_metadata_export_to_skb somehow?
> >>>>
> >>>> If we want to let the programs override some of this
> >>>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add
> >>>> more kfuncs instead of exposing the layout?
> >>>>
> >>>> bpf_xdp_metadata_export_to_skb(ctx);
> >>>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
> >
> > There are several use cases for needing to access the metadata after
> > calling bpf_xdp_metdata_export_to_skb():
> >
> > - Accessing the metadata after redirect (in a cpumap or devmap program,
> >    or on a veth device)
> > - Transferring the packet+metadata to AF_XDP
> fwiw, the xdp prog could also be more selective and only stores one of th=
e hints
> instead of the whole 'struct xdp_to_skb_metadata'.
>
> > - Returning XDP_PASS, but accessing some of the metadata first (whether
> >    to read or change it)
> >
> > The last one could be solved by calling additional kfuncs, but that
> > would be less efficient than just directly editing the struct which
> > will be cache-hot after the helper returns.
>
> Yeah, it is more efficient to directly write if possible.  I think this s=
et
> allows the direct reading and writing already through data_meta (as a _u8=
 *).
>
> >
> > And yeah, this will allow the XDP program to inject arbitrary metadata
> > into the netstack; but it can already inject arbitrary *packet* data
> > into the stack, so not sure if this is much of an additional risk? If i=
t
> > does lead to trivial crashes, we should probably harden the stack
> > against that?
> >
> > As for the random number, Jesper and I discussed replacing this with th=
e
> > same BTF-ID scheme that he was using in his patch series. I.e., instead
> > of just putting in a random number, we insert the BTF ID of the metadat=
a
> > struct at the end of it. This will allow us to support multiple
> > different formats in the future (not just changing the layout, but
> > having multiple simultaneous formats in the same kernel image), in case
> > we run out of space.
>
> This seems a bit hypothetical.  How much headroom does it usually have fo=
r the
> xdp prog?  Potentially the hints can use all the remaining space left aft=
er the
> header encap and the current bpf_xdp_adjust_meta() usage?
>
> >
> > We should probably also have a flag set on the xdp_frame so the stack
> > knows that the metadata area contains relevant-to-skb data, to guard
> > against an XDP program accidentally hitting the "magic number" (BTF_ID)
> > in unrelated stuff it puts into the metadata area.
>
> Yeah, I think having a flag is useful.  The flag will be set at xdp_buff =
and
> then transfer to the xdp_frame?
>
> >
> >> After re-reading patch 6, have another question. The 'void
> >> bpf_xdp_metadata_export_to_skb();' function signature. Should it at
> >> least return ok/err? or even return a 'struct xdp_to_skb_metadata *'
> >> pointer and the xdp prog can directly read (or even write) it?
> >
> > Hmm, I'm not sure returning a failure makes sense? Failure to read one
> > or more fields just means that those fields will not be populated? We
> > should probably have a flags field inside the metadata struct itself to
> > indicate which fields are set or not, but I'm not sure returning an
> > error value adds anything? Returning a pointer to the metadata field
> > might be convenient for users (it would just be an alias to the
> > data_meta pointer, but the verifier could know its size, so the program
> > doesn't have to bounds check it).
>
> If some hints are not available, those hints should be initialized to
> 0/CHECKSUM_NONE/...etc.  The xdp prog needs a direct way to tell hard fai=
lure
> when it cannot write the meta area because of not enough space.  Comparin=
g
> xdp->data_meta with xdp->data as a side effect is not intuitive.
>
> It is more than saving the bound check.  With type info of 'struct
> xdp_to_skb_metadata *', the verifier can do more checks like reading in t=
he
> middle of an integer member.  The verifier could also limit write access =
only to
> a few struct's members if it is needed.
>
> The returning 'struct xdp_to_skb_metadata *' should not be an alias to th=
e
> xdp->data_meta.  They should actually point to different locations in the
> headroom.  bpf_xdp_metadata_export_to_skb() sets a flag in xdp_buff.
> xdp->data_meta won't be changed and keeps pointing to the last
> bpf_xdp_adjust_meta() location.  The kernel will know if there is
> xdp_to_skb_metadata before the xdp->data_meta when that bit is set in the
> xdp_{buff,frame}.  Would it work?
>
> >
> >> A related question, why 'struct xdp_to_skb_metadata' needs
> >> __randomize_layout?
> >
> > The __randomize_layout thing is there to force BPF programs to use CO-R=
E
> > to access the field. This is to avoid the struct layout accidentally
> > ossifying because people in practice rely on a particular layout, even
> > though we tell them to use CO-RE. There are lots of examples of this
> > happening in other domains (IP header options, TCP options, etc), and
> > __randomize_layout seemed like a neat trick to enforce CO-RE usage :)
>
> I am not sure if it is necessary or helpful to only enforce __randomize_l=
ayout
> in 'struct xdp_to_skb_metadata'.  There are other CO-RE use cases (tracin=
g and
> non tracing) that already have direct access (reading and/or writing) to =
other
> kernel structures.
>
> It is more important for the verifier to see the xdp prog accessing it as=
 a
> 'struct xdp_to_skb_metadata *' instead of xdp->data_meta which is a __u8 =
* so
> that the verifier can enforce the rules of access.
>
> >
> >>>>> Does xdp_to_skb_metadata have a use case for XDP_PASS (like patch 7=
) or the
> >>>>> xdp_to_skb_metadata can be limited to XDP_REDIRECT only?
> >>>>
> >>>> XDP_PASS cases where we convert xdp_buff into skb in the drivers rig=
ht
> >>>> now usually have C code to manually pull out the metadata (out of hw
> >>>> desc) and put it into skb.
> >>>>
> >>>> So, currently, if we're calling bpf_xdp_metadata_export_to_skb() for
> >>>> XDP_PASS, we're doing a double amount of work:
> >>>> skb_metadata_import_from_xdp first, then custom driver code second.
> >>>>
> >>>> In theory, maybe we should completely skip drivers custom parsing wh=
en
> >>>> there is a prog with BPF_F_XDP_HAS_METADATA?
> >>>> Then both xdp->skb paths (XDP_PASS+XDP_REDIRECT) will be bpf-driven
> >>>> and won't require any mental work (plus, the drivers won't have to
> >>>> care either in the future).
> >>>>   > WDYT?
> >>>
> >>>
> >>> Yeah, not sure if it can solely depend on BPF_F_XDP_HAS_METADATA but =
it makes
> >>> sense to only use the hints (if ever written) from xdp prog especiall=
y if it
> >>> will eventually support xdp prog changing some of the hints in the fu=
ture.  For
> >>> now, I think either way is fine since they are the same and the xdp p=
rog is sort
> >>> of doing extra unnecessary work anyway by calling
> >>> bpf_xdp_metadata_export_to_skb() with XDP_PASS and knowing nothing ca=
n be
> >>> changed now.
> >
> > I agree it would be best if the drivers also use the XDP metadata (if
> > present) on XDP_PASS. Longer term my hope is we can make the XDP
> > metadata support the only thing drivers need to implement (i.e., have
> > the stack call into that code even when no XDP program is loaded), but
> > for now just for consistency (and allowing the XDP program to update th=
e
> > metadata), we should probably at least consume it on XDP_PASS.
> >
> > -Toke
> >

Not to derail the discussion (left the last message intact on top,
feel free to continue), but to summarize. The proposed changes seem to
be:

1. bpf_xdp_metadata_export_to_skb() should return pointer to "struct
xdp_to_skb_metadata"
  - This should let bpf programs change the metadata passed to the skb

2. "struct xdp_to_skb_metadata" should have its btf_id as the first
__u32 member (and remove the magic)
  - This is for the redirect case where the end users, including
AF_XDP, can parse this metadata from btf_id
  - This, however, is not all the metadata that the device can
support, but a much narrower set that the kernel is expected to use
for skb construction

3. __randomize_layout isn't really helping, CO-RE will trigger
regardless; maybe only the case where it matters is probably AF_XDP,
so still useful?

4. The presence of the metadata generated by
bpf_xdp_metadata_export_to_skb should be indicated by a flag in
xdp_{buff,frame}->flags
  - Assuming exposing it via xdp_md->has_skb_metadata is ok?
  - Since the programs probably need to do the following:

  if (xdp_md->has_skb_metadata) {
    access/change skb metadata by doing struct xdp_to_skb_metadata *p
=3D data_meta;
  } else {
    use kfuncs
  }

5. Support the case where we keep program's metadata and kernel's
xdp_to_skb_metadata
  - skb_metadata_import_from_xdp() will "consume" it by mem-moving the
rest of the metadata over it and adjusting the headroom


I think the above solves all the cases Toke points to?

a) Accessing the metadata after redirect (in a cpumap or devmap
program, or on a veth device)
  - only a small xdp_to_skb_metadata subset will work out of the box
iff the redirecttor calls bpf_xdp_metadata_export_to_skb; for the rest
the progs will have to agree on the layout, right?

b) Transferring the packet+metadata to AF_XDP
  - here, again, the AF_XDP consumer will have to either expect
xdp_to_skb_metadata with a smaller set of skb-related metadata, or
will have to make sure the producer builds a custom layout using
kfuncs; there is also no flag to indicate whether xdp_to_skb_metadata
is there or not; the consumer will have to test btf_id at the right
offset

c) Returning XDP_PASS, but accessing some of the metadata first
(whether to read or change it)
  - can read via kfuncs, can change via
bpf_xdp_metadata_export_to_skb(); m->xyz=3Dabc;

Anything I'm missing?
