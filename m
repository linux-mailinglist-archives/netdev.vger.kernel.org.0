Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE086229CD
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiKILLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiKILLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:11:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D56427B30
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667992248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gsb71n1h6Cbr7ylkFLs8iDxTM+VPffh6yh1errTP/LE=;
        b=Z8pP3tVZwegfWr1HXFWY7DKv3/18D/tssNhny5nFPquBFXZoD+pvqe5Zq0tEHKhLVh2sZh
        VTjqNCShSpYHLBOHx4hInDIQVaJkA0sN5sEmYPIFmkKx9bUTH/J5TyKTzfKI2+mDFibh+n
        paQrtMQa9gwoyG7/2lk1v/9/gv/uaPM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-156-pP_iz2tYPjKoy2CQlE0HLg-1; Wed, 09 Nov 2022 06:10:47 -0500
X-MC-Unique: pP_iz2tYPjKoy2CQlE0HLg-1
Received: by mail-ed1-f70.google.com with SMTP id m7-20020a056402430700b0045daff6ee5dso12449811edc.10
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:10:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gsb71n1h6Cbr7ylkFLs8iDxTM+VPffh6yh1errTP/LE=;
        b=7SAUcP/wGXF6qeFqMbRn2/mOgqOsOf1uXvNZ6B43iO1oxZFx4cUf5uPuDNOOAx4Q3T
         FIWCdRjv2XacOKHBFQebkVOQ2UkGcHnGyewsMwkxuEc/AWFaDomeDmisMVX4uRdBAHIs
         wV4PHYUyjRIAIgwrAFiSi5yW/UXhmvTkak+UBHBfgnTtOQtzI7dm+Biafm4U55CzNYCE
         tM3goYMs5ZhoK2qEjBUeBJQLpQAF8AuZUh3Hi+xbk38oK7F06Xwog48nC/4OWbmUeR7v
         wapKLSx5CqAd0FHD7je2FRvnt1+QhhCW6WiZcuo5m/D4f/TdClzD0VomlTna2K7Yp9nm
         Xd4Q==
X-Gm-Message-State: ANoB5pkfRFbUSX5SPGBhEMuhVKoRz1b88t1xTovRfnY3rLZBvqBaT8tv
        KZ91XAe135dpcedmJf99RTt4qcJdnk6i3L5dXIU4SNPawUyOcSw/dWUWADaL//EM8pMQxmPo7rJ
        w1uAoyU7Ujw6NQ1uI
X-Received: by 2002:a17:906:db03:b0:741:337e:3600 with SMTP id xj3-20020a170906db0300b00741337e3600mr14449693ejb.343.1667992244470;
        Wed, 09 Nov 2022 03:10:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6lpSarclObtW6sPWXbVALWHVeO2pKmCQeoIOnBd4JBHjB0n6B0sYsbykZed6AyVeFPo16Gbg==
X-Received: by 2002:a17:906:db03:b0:741:337e:3600 with SMTP id xj3-20020a170906db0300b00741337e3600mr14449614ejb.343.1667992243131;
        Wed, 09 Nov 2022 03:10:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b23-20020a17090630d700b007317f017e64sm5735115ejb.134.2022.11.09.03.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 03:10:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E56F4782506; Wed,  9 Nov 2022 12:10:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
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
In-Reply-To: <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 09 Nov 2022 12:10:41 +0100
Message-ID: <87leokz8lq.fsf@toke.dk>
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

Snipping a bit of context to reply to this bit:

>>>> Can the xdp prog still change the metadata through xdp->data_meta? tbh=
, I am not
>>>> sure it is solid enough by asking the xdp prog not to use the same ran=
dom number
>>>> in its own metadata + not to change the metadata through xdp->data_met=
a after
>>>> calling bpf_xdp_metadata_export_to_skb().
>>>
>>> What do you think the usecase here might be? Or are you suggesting we
>>> reject further access to data_meta after
>>> bpf_xdp_metadata_export_to_skb somehow?
>>>
>>> If we want to let the programs override some of this
>>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add
>>> more kfuncs instead of exposing the layout?
>>>
>>> bpf_xdp_metadata_export_to_skb(ctx);
>>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);

There are several use cases for needing to access the metadata after
calling bpf_xdp_metdata_export_to_skb():

- Accessing the metadata after redirect (in a cpumap or devmap program,
  or on a veth device)
- Transferring the packet+metadata to AF_XDP
- Returning XDP_PASS, but accessing some of the metadata first (whether
  to read or change it)

The last one could be solved by calling additional kfuncs, but that
would be less efficient than just directly editing the struct which
will be cache-hot after the helper returns.

And yeah, this will allow the XDP program to inject arbitrary metadata
into the netstack; but it can already inject arbitrary *packet* data
into the stack, so not sure if this is much of an additional risk? If it
does lead to trivial crashes, we should probably harden the stack
against that?

As for the random number, Jesper and I discussed replacing this with the
same BTF-ID scheme that he was using in his patch series. I.e., instead
of just putting in a random number, we insert the BTF ID of the metadata
struct at the end of it. This will allow us to support multiple
different formats in the future (not just changing the layout, but
having multiple simultaneous formats in the same kernel image), in case
we run out of space.

We should probably also have a flag set on the xdp_frame so the stack
knows that the metadata area contains relevant-to-skb data, to guard
against an XDP program accidentally hitting the "magic number" (BTF_ID)
in unrelated stuff it puts into the metadata area.

> After re-reading patch 6, have another question. The 'void
> bpf_xdp_metadata_export_to_skb();' function signature. Should it at
> least return ok/err? or even return a 'struct xdp_to_skb_metadata *'
> pointer and the xdp prog can directly read (or even write) it?

Hmm, I'm not sure returning a failure makes sense? Failure to read one
or more fields just means that those fields will not be populated? We
should probably have a flags field inside the metadata struct itself to
indicate which fields are set or not, but I'm not sure returning an
error value adds anything? Returning a pointer to the metadata field
might be convenient for users (it would just be an alias to the
data_meta pointer, but the verifier could know its size, so the program
doesn't have to bounds check it).

> A related question, why 'struct xdp_to_skb_metadata' needs
> __randomize_layout?

The __randomize_layout thing is there to force BPF programs to use CO-RE
to access the field. This is to avoid the struct layout accidentally
ossifying because people in practice rely on a particular layout, even
though we tell them to use CO-RE. There are lots of examples of this
happening in other domains (IP header options, TCP options, etc), and
__randomize_layout seemed like a neat trick to enforce CO-RE usage :)

>>>> Does xdp_to_skb_metadata have a use case for XDP_PASS (like patch 7) o=
r the
>>>> xdp_to_skb_metadata can be limited to XDP_REDIRECT only?
>>>
>>> XDP_PASS cases where we convert xdp_buff into skb in the drivers right
>>> now usually have C code to manually pull out the metadata (out of hw
>>> desc) and put it into skb.
>>>
>>> So, currently, if we're calling bpf_xdp_metadata_export_to_skb() for
>>> XDP_PASS, we're doing a double amount of work:
>>> skb_metadata_import_from_xdp first, then custom driver code second.
>>>
>>> In theory, maybe we should completely skip drivers custom parsing when
>>> there is a prog with BPF_F_XDP_HAS_METADATA?
>>> Then both xdp->skb paths (XDP_PASS+XDP_REDIRECT) will be bpf-driven
>>> and won't require any mental work (plus, the drivers won't have to
>>> care either in the future).
>>> =C2=A0> WDYT?
>>=20
>>=20
>> Yeah, not sure if it can solely depend on BPF_F_XDP_HAS_METADATA but it =
makes=20
>> sense to only use the hints (if ever written) from xdp prog especially i=
f it=20
>> will eventually support xdp prog changing some of the hints in the futur=
e.=C2=A0 For=20
>> now, I think either way is fine since they are the same and the xdp prog=
 is sort=20
>> of doing extra unnecessary work anyway by calling=20
>> bpf_xdp_metadata_export_to_skb() with XDP_PASS and knowing nothing can b=
e=20
>> changed now.

I agree it would be best if the drivers also use the XDP metadata (if
present) on XDP_PASS. Longer term my hope is we can make the XDP
metadata support the only thing drivers need to implement (i.e., have
the stack call into that code even when no XDP program is loaded), but
for now just for consistency (and allowing the XDP program to update the
metadata), we should probably at least consume it on XDP_PASS.

-Toke

