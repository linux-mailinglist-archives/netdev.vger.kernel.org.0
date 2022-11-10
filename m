Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA61D624436
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiKJO1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiKJO1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:27:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FD52A424
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668090417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2BZ2IFuzrwdJ33pyeb2A6nSlMgVgYW/H8PD6/LrrWDo=;
        b=XKvEeZYm5q8zne2WvsgK5555osIaemQjW6SsRlnVFvGAqxubfBCyEXchW7Af0nGn27EKFV
        voHh9EOPY6X7Nj9yJlrSurWzpU7fgv5exU9yK7d7QVD7jHrNqVUcJ7qfkYV75olgVHBHQg
        ebR4MRVQwvziaeLpVpRBPKYcJSfm1ME=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-161-rH193K_WNJeOWrmmfrz2Fw-1; Thu, 10 Nov 2022 09:26:56 -0500
X-MC-Unique: rH193K_WNJeOWrmmfrz2Fw-1
Received: by mail-ej1-f71.google.com with SMTP id sd31-20020a1709076e1f00b007ae63b8d66aso1317626ejc.3
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:26:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2BZ2IFuzrwdJ33pyeb2A6nSlMgVgYW/H8PD6/LrrWDo=;
        b=v7yQhiLjuQSJ5dMXCU2iYiW/oE+SoaQ/bN14/XcGFKwxJ/8BcX9HldmoAfR/4zngdi
         7DeR17rUEnZvJR4xr2Mjcu50ZzkA/WKiF7wrrF5Q3NzSr7z3l4qzvK5PXkVHrpZM7SCf
         LHXV5Y5OQWzsm2kRDrb2GdHCLj44p2e5GHmgPuvVKAVlBgtHYXpeOPRvZY4vQgIIZ2b8
         8vXAAfxhZsUIcirfOfPsU/FRirbcyULWRevLEl3QFV/NzK9+6l+svvWNp0dPM6WYox49
         d72rbh2NFDFh/Y0BojaSSWrtkScG/r6UQVa8yKhQgEzjEUwbQ1fpsMC+tsWi1MtXCzj0
         Yhqw==
X-Gm-Message-State: ACrzQf35pk3e4ZV2mMifivM4Me/TwtljdbV7fNCuPtvfYlBnn6SGr6vT
        y2jeOqMWwd5K+8c4IZAQodUsjLUre2FW4B1jv2JWLTBMSfe/H7suLZOG9RWKcWUEgPdq8coTJWh
        DGHOfGKlKvyeZRjjn
X-Received: by 2002:a17:906:fcb0:b0:7ae:388:98c5 with SMTP id qw16-20020a170906fcb000b007ae038898c5mr38727089ejb.120.1668090414458;
        Thu, 10 Nov 2022 06:26:54 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6bdJIzC4EaJKAFFLq36MFXrIdU+S+ZjECU5p3I9JhW/7Xca6HP6b0RFM+LYr06DjA8BUuHqg==
X-Received: by 2002:a17:906:fcb0:b0:7ae:388:98c5 with SMTP id qw16-20020a170906fcb000b007ae038898c5mr38727048ejb.120.1668090413877;
        Thu, 10 Nov 2022 06:26:53 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id lb11-20020a170907784b00b0073dbaeb50f6sm7201155ejc.169.2022.11.10.06.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 06:26:53 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 34DBA7826D0; Thu, 10 Nov 2022 15:26:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
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
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
In-Reply-To: <CAKH8qBuLMZrFmmi77Qbt7DCd1w9FJwdeK5CnZTJqHYiWxwDx6w@mail.gmail.com>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev> <87leokz8lq.fsf@toke.dk>
 <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
 <CAKH8qBsfVOoR1MNAFx3uR9Syoc0APHABsf97kb8SGpK+T1qcew@mail.gmail.com>
 <32f81955-8296-6b9a-834a-5184c69d3aac@linux.dev>
 <CAKH8qBuLMZrFmmi77Qbt7DCd1w9FJwdeK5CnZTJqHYiWxwDx6w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Nov 2022 15:26:53 +0100
Message-ID: <87y1siyjf6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Wed, Nov 9, 2022 at 4:13 PM Martin KaFai Lau <martin.lau@linux.dev> wr=
ote:
>>
>> On 11/9/22 1:33 PM, Stanislav Fomichev wrote:
>> > On Wed, Nov 9, 2022 at 10:22 AM Martin KaFai Lau <martin.lau@linux.dev=
> wrote:
>> >>
>> >> On 11/9/22 3:10 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >>> Snipping a bit of context to reply to this bit:
>> >>>
>> >>>>>>> Can the xdp prog still change the metadata through xdp->data_met=
a? tbh, I am not
>> >>>>>>> sure it is solid enough by asking the xdp prog not to use the sa=
me random number
>> >>>>>>> in its own metadata + not to change the metadata through xdp->da=
ta_meta after
>> >>>>>>> calling bpf_xdp_metadata_export_to_skb().
>> >>>>>>
>> >>>>>> What do you think the usecase here might be? Or are you suggestin=
g we
>> >>>>>> reject further access to data_meta after
>> >>>>>> bpf_xdp_metadata_export_to_skb somehow?
>> >>>>>>
>> >>>>>> If we want to let the programs override some of this
>> >>>>>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can a=
dd
>> >>>>>> more kfuncs instead of exposing the layout?
>> >>>>>>
>> >>>>>> bpf_xdp_metadata_export_to_skb(ctx);
>> >>>>>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
>> >>>
>> >>> There are several use cases for needing to access the metadata after
>> >>> calling bpf_xdp_metdata_export_to_skb():
>> >>>
>> >>> - Accessing the metadata after redirect (in a cpumap or devmap progr=
am,
>> >>>     or on a veth device)
>> >>> - Transferring the packet+metadata to AF_XDP
>> >> fwiw, the xdp prog could also be more selective and only stores one o=
f the hints
>> >> instead of the whole 'struct xdp_to_skb_metadata'.
>> >>
>> >>> - Returning XDP_PASS, but accessing some of the metadata first (whet=
her
>> >>>     to read or change it)
>> >>>
>> >>> The last one could be solved by calling additional kfuncs, but that
>> >>> would be less efficient than just directly editing the struct which
>> >>> will be cache-hot after the helper returns.
>> >>
>> >> Yeah, it is more efficient to directly write if possible.  I think th=
is set
>> >> allows the direct reading and writing already through data_meta (as a=
 _u8 *).
>> >>
>> >>>
>> >>> And yeah, this will allow the XDP program to inject arbitrary metada=
ta
>> >>> into the netstack; but it can already inject arbitrary *packet* data
>> >>> into the stack, so not sure if this is much of an additional risk? I=
f it
>> >>> does lead to trivial crashes, we should probably harden the stack
>> >>> against that?
>> >>>
>> >>> As for the random number, Jesper and I discussed replacing this with=
 the
>> >>> same BTF-ID scheme that he was using in his patch series. I.e., inst=
ead
>> >>> of just putting in a random number, we insert the BTF ID of the meta=
data
>> >>> struct at the end of it. This will allow us to support multiple
>> >>> different formats in the future (not just changing the layout, but
>> >>> having multiple simultaneous formats in the same kernel image), in c=
ase
>> >>> we run out of space.
>> >>
>> >> This seems a bit hypothetical.  How much headroom does it usually hav=
e for the
>> >> xdp prog?  Potentially the hints can use all the remaining space left=
 after the
>> >> header encap and the current bpf_xdp_adjust_meta() usage?
>> >>
>> >>>
>> >>> We should probably also have a flag set on the xdp_frame so the stack
>> >>> knows that the metadata area contains relevant-to-skb data, to guard
>> >>> against an XDP program accidentally hitting the "magic number" (BTF_=
ID)
>> >>> in unrelated stuff it puts into the metadata area.
>> >>
>> >> Yeah, I think having a flag is useful.  The flag will be set at xdp_b=
uff and
>> >> then transfer to the xdp_frame?
>> >>
>> >>>
>> >>>> After re-reading patch 6, have another question. The 'void
>> >>>> bpf_xdp_metadata_export_to_skb();' function signature. Should it at
>> >>>> least return ok/err? or even return a 'struct xdp_to_skb_metadata *'
>> >>>> pointer and the xdp prog can directly read (or even write) it?
>> >>>
>> >>> Hmm, I'm not sure returning a failure makes sense? Failure to read o=
ne
>> >>> or more fields just means that those fields will not be populated? We
>> >>> should probably have a flags field inside the metadata struct itself=
 to
>> >>> indicate which fields are set or not, but I'm not sure returning an
>> >>> error value adds anything? Returning a pointer to the metadata field
>> >>> might be convenient for users (it would just be an alias to the
>> >>> data_meta pointer, but the verifier could know its size, so the prog=
ram
>> >>> doesn't have to bounds check it).
>> >>
>> >> If some hints are not available, those hints should be initialized to
>> >> 0/CHECKSUM_NONE/...etc.  The xdp prog needs a direct way to tell hard=
 failure
>> >> when it cannot write the meta area because of not enough space.  Comp=
aring
>> >> xdp->data_meta with xdp->data as a side effect is not intuitive.
>> >>
>> >> It is more than saving the bound check.  With type info of 'struct
>> >> xdp_to_skb_metadata *', the verifier can do more checks like reading =
in the
>> >> middle of an integer member.  The verifier could also limit write acc=
ess only to
>> >> a few struct's members if it is needed.
>> >>
>> >> The returning 'struct xdp_to_skb_metadata *' should not be an alias t=
o the
>> >> xdp->data_meta.  They should actually point to different locations in=
 the
>> >> headroom.  bpf_xdp_metadata_export_to_skb() sets a flag in xdp_buff.
>> >> xdp->data_meta won't be changed and keeps pointing to the last
>> >> bpf_xdp_adjust_meta() location.  The kernel will know if there is
>> >> xdp_to_skb_metadata before the xdp->data_meta when that bit is set in=
 the
>> >> xdp_{buff,frame}.  Would it work?
>> >>
>> >>>
>> >>>> A related question, why 'struct xdp_to_skb_metadata' needs
>> >>>> __randomize_layout?
>> >>>
>> >>> The __randomize_layout thing is there to force BPF programs to use C=
O-RE
>> >>> to access the field. This is to avoid the struct layout accidentally
>> >>> ossifying because people in practice rely on a particular layout, ev=
en
>> >>> though we tell them to use CO-RE. There are lots of examples of this
>> >>> happening in other domains (IP header options, TCP options, etc), and
>> >>> __randomize_layout seemed like a neat trick to enforce CO-RE usage :)
>> >>
>> >> I am not sure if it is necessary or helpful to only enforce __randomi=
ze_layout
>> >> in 'struct xdp_to_skb_metadata'.  There are other CO-RE use cases (tr=
acing and
>> >> non tracing) that already have direct access (reading and/or writing)=
 to other
>> >> kernel structures.
>> >>
>> >> It is more important for the verifier to see the xdp prog accessing i=
t as a
>> >> 'struct xdp_to_skb_metadata *' instead of xdp->data_meta which is a _=
_u8 * so
>> >> that the verifier can enforce the rules of access.
>> >>
>> >>>
>> >>>>>>> Does xdp_to_skb_metadata have a use case for XDP_PASS (like patc=
h 7) or the
>> >>>>>>> xdp_to_skb_metadata can be limited to XDP_REDIRECT only?
>> >>>>>>
>> >>>>>> XDP_PASS cases where we convert xdp_buff into skb in the drivers =
right
>> >>>>>> now usually have C code to manually pull out the metadata (out of=
 hw
>> >>>>>> desc) and put it into skb.
>> >>>>>>
>> >>>>>> So, currently, if we're calling bpf_xdp_metadata_export_to_skb() =
for
>> >>>>>> XDP_PASS, we're doing a double amount of work:
>> >>>>>> skb_metadata_import_from_xdp first, then custom driver code secon=
d.
>> >>>>>>
>> >>>>>> In theory, maybe we should completely skip drivers custom parsing=
 when
>> >>>>>> there is a prog with BPF_F_XDP_HAS_METADATA?
>> >>>>>> Then both xdp->skb paths (XDP_PASS+XDP_REDIRECT) will be bpf-driv=
en
>> >>>>>> and won't require any mental work (plus, the drivers won't have to
>> >>>>>> care either in the future).
>> >>>>>>    > WDYT?
>> >>>>>
>> >>>>>
>> >>>>> Yeah, not sure if it can solely depend on BPF_F_XDP_HAS_METADATA b=
ut it makes
>> >>>>> sense to only use the hints (if ever written) from xdp prog especi=
ally if it
>> >>>>> will eventually support xdp prog changing some of the hints in the=
 future.  For
>> >>>>> now, I think either way is fine since they are the same and the xd=
p prog is sort
>> >>>>> of doing extra unnecessary work anyway by calling
>> >>>>> bpf_xdp_metadata_export_to_skb() with XDP_PASS and knowing nothing=
 can be
>> >>>>> changed now.
>> >>>
>> >>> I agree it would be best if the drivers also use the XDP metadata (if
>> >>> present) on XDP_PASS. Longer term my hope is we can make the XDP
>> >>> metadata support the only thing drivers need to implement (i.e., have
>> >>> the stack call into that code even when no XDP program is loaded), b=
ut
>> >>> for now just for consistency (and allowing the XDP program to update=
 the
>> >>> metadata), we should probably at least consume it on XDP_PASS.
>> >>>
>> >>> -Toke
>> >>>
>> >
>> > Not to derail the discussion (left the last message intact on top,
>> > feel free to continue), but to summarize. The proposed changes seem to
>> > be:
>> >
>> > 1. bpf_xdp_metadata_export_to_skb() should return pointer to "struct
>> > xdp_to_skb_metadata"
>> >    - This should let bpf programs change the metadata passed to the skb
>> >
>> > 2. "struct xdp_to_skb_metadata" should have its btf_id as the first
>> > __u32 member (and remove the magic)
>> >    - This is for the redirect case where the end users, including
>> > AF_XDP, can parse this metadata from btf_id
>>
>> I think Toke's idea is to put the btf_id at the end of xdp_to_skb_metada=
ta.  I
>> can see why the end is needed for the userspace AF_XDP because, afaict, =
AF_XDP
>> rx_desc currently cannot tell if there is metadata written by the xdp pr=
og or
>> not.  However, if the 'has_skb_metadata' bit can also be passed to the A=
F_XDP
>> rx_desc->options, the btf_id may as well be not needed now.  However, th=
e btf_id
>> and other future new members can be added to the xdp_to_skb_metadata lat=
er if
>> there is a need.
>>
>> For the kernel and xdp prog, a bit in the xdp->flags should be enough to=
 get to
>> the xdp_to_skb_metadata.  The xdp prog will use CO-RE to access the memb=
ers in
>> xdp_to_skb_metadata.
>
> Ack, good points on putting it at the end.
> Regarding bit in desc->options vs btf_id: since it seems that btf_id
> is useful anyway, let's start with that? We can add a bit later on if
> it turns out using metadata is problematic otherwise.

I think the bit is mostly useful so that the stack can know that the
metadata has been set before consuming it (to guard against regular
xdp_metadata usage accidentally hitting the "right" BTF ID). I don't
think it needs to be exposed to the XDP programs themselves.

>> >    - This, however, is not all the metadata that the device can
>> > support, but a much narrower set that the kernel is expected to use
>> > for skb construction
>> >
>> > 3. __randomize_layout isn't really helping, CO-RE will trigger
>> > regardless; maybe only the case where it matters is probably AF_XDP,
>> > so still useful?

Yeah, see my response to Martin, I think the randomisation is useful for
AF_XDP transfer.

>> > 4. The presence of the metadata generated by
>> > bpf_xdp_metadata_export_to_skb should be indicated by a flag in
>> > xdp_{buff,frame}->flags
>> >    - Assuming exposing it via xdp_md->has_skb_metadata is ok?
>>
>> probably __bpf_md_ptr(struct xdp_to_skb_metadata *, skb_metadata) and th=
e type
>> will be PTR_TO_BTF_ID_OR_NULL.
>
> Oh, that seems even better than returning it from
> bpf_xdp_metadata_export_to_skb.
> bpf_xdp_metadata_export_to_skb can return true/false and the rest goes
> via default verifier ctx resolution mechanism..
> (returning ptr from a kfunc seems to be a bit complicated right now)

See my response to John in the other thread about mixing stable UAPI (in
xdp_md) and unstable BTF structures in the xdp_md struct: I think this
is confusing and would prefer a kfunc.

>> >    - Since the programs probably need to do the following:
>> >
>> >    if (xdp_md->has_skb_metadata) {
>> >      access/change skb metadata by doing struct xdp_to_skb_metadata *p
>> > =3D data_meta;
>>
>> and directly access/change xdp->skb_metadata instead of using xdp->data_=
meta.
>
> Ack.
>
>> >    } else {
>> >      use kfuncs
>> >    }
>> >
>> > 5. Support the case where we keep program's metadata and kernel's
>> > xdp_to_skb_metadata
>> >    - skb_metadata_import_from_xdp() will "consume" it by mem-moving the
>> > rest of the metadata over it and adjusting the headroom
>>
>> I was thinking the kernel's xdp_to_skb_metadata is always before the pro=
gram's
>> metadata.  xdp prog should usually work in this order also: read/write h=
eaders,
>> write its own metadata, call bpf_xdp_metadata_export_to_skb(), and return
>> XDP_PASS/XDP_REDIRECT.  When it is XDP_PASS, the kernel just needs to po=
p the
>> xdp_to_skb_metadata and pass the remaining program's metadata to the bpf=
-tc.
>>
>> For the kernel and xdp prog, I don't think it matters where the
>> xdp_to_skb_metadata is.  However, the xdp->data_meta (program's metadata=
) has to
>> be before xdp->data because of the current data_meta and data comparison=
 usage
>> in the xdp prog.
>>
>> The order of the kernel's xdp_to_skb_metadata and the program's metadata
>> probably only matters to the userspace AF_XDP.  However, I don't see how=
 AF_XDP
>> supports the program's metadata now.  afaict, it can only work now if th=
ere is
>> some sort of contract between them or the AF_XDP currently does not use =
the
>> program's metadata.  Either way, we can do the mem-moving only for AF_XD=
P and it
>> should be a no op if there is no program's metadata?  This behavior coul=
d also
>> be configurable through setsockopt?
>
> Agreed on all of the above. For now it seems like the safest thing to
> do is to put xdp_to_skb_metadata last to allow af_xdp to properly
> locate btf_id.
> Let's see if Toke disagrees :-)

As I replied to Martin, I'm not sure it's worth the complexity to
logically split the SKB metadata from the program's own metadata (as
opposed to just reusing the existing data_meta pointer)?

However, if we do, the layout that makes most sense to me is putting the
skb metadata before the program metadata, like:

--------------
| skb_metadata
--------------
| data_meta
--------------
| data
--------------

Not sure if that's what you meant? :)

-Toke

