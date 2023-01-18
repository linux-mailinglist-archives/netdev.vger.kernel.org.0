Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324B06725A2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 18:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjARRzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 12:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjARRzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 12:55:44 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42884E52F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 09:55:43 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id v81so16808001vkv.5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 09:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gI5tmqxh4LXLtNT2ROOUZSkVdcevre1I5+FSwfIgMc8=;
        b=H5IYcWt7tp1sB/UfkvMNWKsSPuhroay931C8XBTxV5n0k4y/SVS6lzR6syJCOWAf6Y
         SzcyF6jrmYX/V3SmeNdv11sJhJP+54Jg4pviVLXiRgYpR1GPawQPOs1VRR4jYcrbsNOJ
         SP/TiUcpMMaz4uXbKzfqUqEZSnruvZgB28AcClNqCmA1H1CxEP+5G7OEb2lv/mZk4hOi
         aBQYcAIijDMA3NytE5NAOr4TEiYREkWHFXQ5/xFAFFGl7FcBYhjGGPYJd2U5yGnHnkQC
         M9udpPOxlEQc3EezbXpb6LDrV3E/lQHz1NLFFa4Az5YIpV6SuOKprbctArIGYydvk2kw
         uB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gI5tmqxh4LXLtNT2ROOUZSkVdcevre1I5+FSwfIgMc8=;
        b=pIMpGJdkyaDEJVoK8aYQAMJR1AFpdIsRfDZZAqvy/1cTKnIEVCvwkDvYlyc3NWeeMn
         C+sWOL509Q6i9HasK82/p5WRI8OQ6A0m3Zuy0FDjY1Y1miOyvi+G6jqBbeS4YFfZA7S6
         Fgp6GGlBo5agm+w3gu6EUq/CZdKekYMVunB4au8oCREBol7tmuttlmBuFo7YfPJmhKV+
         /ZgA48rfl/n8m/IlnaKDP5QM0zohtCjSDJSJSuN0oYGVB1YJ0YN9el+xIumfhL3akIwu
         8e2DuWLBSSkdRjSX25s2V6RjQ8M+8uw3Yzn+3XvMRzDR6iGZdg3laoniRNjsZ9WHSu9s
         EgGw==
X-Gm-Message-State: AFqh2krdjcNdYO3mi2V6A5F3XZRC9hylsJhchbjK+TOP8Ji8de36nRiD
        DBmS6/ekuznzpOAEepIDshPDmjaOxHBNcbNbcpLArw==
X-Google-Smtp-Source: AMrXdXvhlwkfbIQb4Zke2l6wU4S1JFiHXCOrYzwGkvURRsdvuPCrVFrTXAdw0ZZESyeLRw+noSicF8ZD5LeZGCYHsl4=
X-Received: by 2002:a1f:a017:0:b0:3db:14db:2cc6 with SMTP id
 j23-20020a1fa017000000b003db14db2cc6mr981661vke.17.1674064542793; Wed, 18 Jan
 2023 09:55:42 -0800 (PST)
MIME-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com> <20230112003230.3779451-2-sdf@google.com>
 <affeb1e3-69e6-9783-0012-6d917972ba30@redhat.com> <CAKH8qBuE5ipcncQ+=su_Ds1EHm5gUMG_od-+eqJHkuiV-Q6RhQ@mail.gmail.com>
 <27e552c4-e1cf-40d3-305c-e4a57ab87bcf@redhat.com>
In-Reply-To: <27e552c4-e1cf-40d3-305c-e4a57ab87bcf@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 18 Jan 2023 09:55:30 -0800
Message-ID: <CAKH8qBtSVr8CQfSnKC_GdL80KTgj-+kykZ8chXnhqJ1pcL6ZTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 01/17] bpf: Document XDP RX metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, David Vernet <void@manifault.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
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

On Wed, Jan 18, 2023 at 6:28 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 17/01/2023 21.33, Stanislav Fomichev wrote:
> > On Mon, Jan 16, 2023 at 5:09 AM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> >>
> >> On 12/01/2023 01.32, Stanislav Fomichev wrote:
> >>> Document all current use-cases and assumptions.
> >>>
> [...]
> >>> Acked-by: David Vernet <void@manifault.com>
> >>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >>> ---
> >>>    Documentation/networking/index.rst           |   1 +
> >>>    Documentation/networking/xdp-rx-metadata.rst | 108 +++++++++++++++=
++++
> >>>    2 files changed, 109 insertions(+)
> >>>    create mode 100644 Documentation/networking/xdp-rx-metadata.rst
> >>>
> >>> diff --git a/Documentation/networking/index.rst b/Documentation/netwo=
rking/index.rst
> >>> index 4f2d1f682a18..4ddcae33c336 100644
> >>> --- a/Documentation/networking/index.rst
> >>> +++ b/Documentation/networking/index.rst
> [...cut...]
> >>> +AF_XDP
> >>> +=3D=3D=3D=3D=3D=3D
> >>> +
> >>> +:doc:`af_xdp` use-case implies that there is a contract between the =
BPF
> >>> +program that redirects XDP frames into the ``AF_XDP`` socket (``XSK`=
`) and
> >>> +the final consumer. Thus the BPF program manually allocates a fixed =
number of
> >>> +bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
> >>> +of kfuncs to populate it. The userspace ``XSK`` consumer computes
> >>> +``xsk_umem__get_data() - METADATA_SIZE`` to locate that metadata.
> >>> +Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
> >>> +``METADATA_SIZE`` is an application-specific constant.
> >>
> >> The main problem with AF_XDP and metadata is that, the AF_XDP descript=
or
> >> doesn't contain any info about the length METADATA_SIZE.
> >>
> >> The text does says this, but in a very convoluted way.
> >> I think this challenge should be more clearly spelled out.
> >>
> >> (p.s. This was something that XDP-hints via BTF have a proposed soluti=
on
> >> for)
> >
> > Any suggestions on how to clarify it better? I have two hints:
> > 1. ``METADATA_SIZE`` is an application-specific constant
> > 2. note missing ``data_meta`` pointer
> >
> > Do you prefer I also add a sentence where I spell it out more
> > explicitly? Something like:
> >
> > Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
> > ``METADATA_SIZE`` is an application-specific constant (``AF_XDP``
> > receive descriptor does _not_ explicitly carry the size of the
> > metadata).
>
> That addition works for me.
> (Later we can hopefully come up with a solution for this)
>
> >>> +
> >>> +Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` p=
ointer)::
> >>
> >> The "note" also hint to this issue.
> >
> > This seems like an explicit design choice of the AF_XDP? In theory, I
> > don't see why we can't have a v2 receive descriptor format where we
> > return the size of the metadata?
>
> (Cc. Magnus+Bj=C3=B8rn)
> Yes, it was a design choice from AF_XDP not to include the metadata lengt=
h.
>
> The AF_XDP descriptor, see struct  xdp_desc (below) from
> /include/uapi/linux/if_xdp.h.
>
>   /* Rx/Tx descriptor */
>   struct xdp_desc {
>         __u64 addr;
>         __u32 len;
>         __u32 options;
>   };
>
> Does contain a 'u32 options' field, that we could use.
>
> In previous discussions, the proposed solution (from Bj=C3=B8rn+Magnus) w=
as
> to use some bits in the 'options' field to say metadata is present, and
> xsk_umem__get_data minus 4 (or 8) bytes contain a BTF_ID.  The AF_XDP
> programmer can then get the metadata length by looking up the BTF_ID.

Yeah, that's one way to do it. Instead of BTF_ID, we can just put the
size of the metadata.
But it wasn't needed for the use-cases described in this patchset.
For redirect use-case, I agree, we might carry some extra information
about the layout, up to you.

> >>> +
> >>> +  +----------+-----------------+------+
> >>> +  | headroom | custom metadata | data |
> >>> +  +----------+-----------------+------+
> >>> +                               ^
> >>> +                               |
> >>> +                        rx_desc->address
> >>> +
> >>> +XDP_PASS
> >>> +=3D=3D=3D=3D=3D=3D=3D=3D
> >>> +
> >>> +This is the path where the packets processed by the XDP program are =
passed
> >>> +into the kernel. The kernel creates the ``skb`` out of the ``xdp_buf=
f``
> >>> +contents. Currently, every driver has custom kernel code to parse
> >>> +the descriptors and populate ``skb`` metadata when doing this ``xdp_=
buff->skb``
> >>> +conversion, and the XDP metadata is not used by the kernel when buil=
ding
> >>> +``skbs``. However, TC-BPF programs can access the XDP metadata area =
using
> >>> +the ``data_meta`` pointer.
> >>> +
> >>> +In the future, we'd like to support a case where an XDP program
> >>> +can override some of the metadata used for building ``skbs``.
> >>
> >> Happy this is mentioned as future work.
> >
> > As mentioned in a separate email, if you prefer to focus on that, feel
>
> Yes, I'm going to work on PoC code that explore this area.
>
> > free to drive it since I'm gonna look into the TX side first.
>
> Happy to hear you are going to look into TX-side.
> Are your use case related to TX timestamping?

Yes, I'll try to start with a tx timestamp. But looking (briefly) at
the code, that seems like a more invasive addition.
If we want to return that tx timstamp via the original umem, some
completion mechanism has to be added (besides the existing one it).
LMK if you have some pointers to the previous discussions. Or maybe
Bj=C3=B8rn/Magnus had some plans/ideas about that?

> --Jesper
>
