Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CCE617176
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 00:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiKBXLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 19:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiKBXK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 19:10:59 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9B2DE86
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 16:10:58 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h18so226519ilq.9
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 16:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6i3l2ls630yIi3o75TApUSQtOr3lPDRY+XACXcmS2fw=;
        b=tYUy0H7+MJV+LuECUV327HtU7FoSWaNj+5OgOQiA2ERmz6WO2rYBbo6BShBeAhXbab
         kEbTBaGKi9gFJvakqoSRcz/0y9nY8aBimVAjqLFqs07iSwhGwstxOXcC/LIF+wiY+1rV
         /+wrMT2cgNsKSydxIu+Kwc5q9IWH1CFk2qfdv6ZUBciqE2wlfd1+84HoYsVppNvNLj1Q
         V3fApiyuPWWCH6Ie1F2fiuChoJTyrnGein88AidtNQ3xQQ6oBRTRGfs//AMsXbEvdFp/
         CGs0NL3MEaIUxuM3fC1Ki7rD3qeyjOOhlhLU8Pu4KSyIvt8iQuch1HU0IL+/U0tIX7R1
         47gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6i3l2ls630yIi3o75TApUSQtOr3lPDRY+XACXcmS2fw=;
        b=XDyTLVRxR55/kkNvntnpv4877oD+te1cyU+/txU90VDhrtzZk7qOxMpvGwLnVKii+n
         H3hgEPPtIr/K1XQBnj1IsfkMhCP0sjxIOO3xuMs06QtoTZyqFn8mCqronUxnMGO/43WQ
         zZbgfjFxG3tlIZ6aYli5yrlouRsO7mCzKq/Dv4yZZ2d4Urh0RbcuN6bMSDIHls05c6fm
         36ESjp95v+d4YAywaFpRu+HA38z9kYYnqovBpbizgNGDfAZflgf7rSco34ny7A9qCCxl
         yNDmPuCuR0ai5f/8r7OMazsriArWqv6hOw3y1MrDvu2rcb6yAqzPjVMW13tGsLbQmRbV
         1tLQ==
X-Gm-Message-State: ACrzQf2S5FFrzxaMazoC2eFMxn7rsZP4iGl1h2fCXwq+pKhvGEOsbK3b
        ikTP23i+Ob6UGBfoK0Wj0/d1UXs/v01Jwrd87CqjJA==
X-Google-Smtp-Source: AMsMyM6B5+gaE2TZlgZjuY4B2fe17fqqDk+mFKzudbUxGaL3qURYHzYXqV5xQcxeYtJpTxGz912FinKnWZB0ZWo93/Q=
X-Received: by 2002:a92:5204:0:b0:300:d0b8:5184 with SMTP id
 g4-20020a925204000000b00300d0b85184mr2980812ilb.118.1667430657771; Wed, 02
 Nov 2022 16:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org> <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk> <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev> <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
 <0c00ba33-f37b-dfe6-7980-45920ffa273b@linux.dev> <48ba6e77-1695-50b3-b27f-e82750ee70bb@redhat.com>
 <87iljx2ey4.fsf@toke.dk>
In-Reply-To: <87iljx2ey4.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 2 Nov 2022 16:10:46 -0700
Message-ID: <CAKH8qBt31WBpDWb+SkNpuzE1PuwC1O_v7seF9TMJfc6SvhN7MQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>, brouer@redhat.com,
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
        "ast@kernel.org" <ast@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
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

On Wed, Nov 2, 2022 at 3:02 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>
> > On 01/11/2022 18.05, Martin KaFai Lau wrote:
> >> On 10/31/22 6:59 PM, Stanislav Fomichev wrote:
> >>> On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau
> >>> <martin.lau@linux.dev> wrote:
> >>>>
> >>>> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
> >>>>>> 2. AF_XDP programs won't be able to access the metadata without
> >>>>>> using a
> >>>>>> custom XDP program that calls the kfuncs and puts the data into th=
e
> >>>>>> metadata area. We could solve this with some code in libxdp,
> >>>>>> though; if
> >>>>>> this code can be made generic enough (so it just dumps the availab=
le
> >>>>>> metadata functions from the running kernel at load time), it may b=
e
> >>>>>> possible to make it generic enough that it will be forward-compati=
ble
> >>>>>> with new versions of the kernel that add new fields, which should
> >>>>>> alleviate Florian's concern about keeping things in sync.
> >>>>>
> >>>>> Good point. I had to convert to a custom program to use the kfuncs =
:-(
> >>>>> But your suggestion sounds good; maybe libxdp can accept some extra
> >>>>> info about at which offset the user would like to place the metadat=
a
> >>>>> and the library can generate the required bytecode?
> >>>>>
> >>>>>> 3. It will make it harder to consume the metadata when building
> >>>>>> SKBs. I
> >>>>>> think the CPUMAP and veth use cases are also quite important, and =
that
> >>>>>> we want metadata to be available for building SKBs in this path. M=
aybe
> >>>>>> this can be resolved by having a convenient kfunc for this that ca=
n be
> >>>>>> used for programs doing such redirects. E.g., you could just call
> >>>>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and tha=
t
> >>>>>> would recursively expand into all the kfunc calls needed to extrac=
t
> >>>>>> the
> >>>>>> metadata supported by the SKB path?
> >>>>>
> >>>>> So this xdp_copy_metadata_for_skb will create a metadata layout tha=
t
> >>>>
> >>>> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
> >>>> Not sure where is the best point to specify this prog though.
> >>>> Somehow during
> >>>> bpf_xdp_redirect_map?
> >>>> or this prog belongs to the target cpumap and the xdp prog
> >>>> redirecting to this
> >>>> cpumap has to write the meta layout in a way that the cpumap is
> >>>> expecting?
> >>>
> >>> We're probably interested in triggering it from the places where xdp
> >>> frames can eventually be converted into skbs?
> >>> So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW=
,
> >>> anything that's not XDP_DROP / AF_XDP redirect).
> >>> We can probably make it magically work, and can generate
> >>> kernel-digestible metadata whenever data =3D=3D data_meta, but the
> >>> question - should we?
> >>> (need to make sure we won't regress any existing cases that are not
> >>> relying on the metadata)
> >>
> >> Instead of having some kernel-digestible meta data, how about calling
> >> another bpf prog to initialize the skb fields from the meta area after
> >> __xdp_build_skb_from_frame() in the cpumap, so
> >> run_xdp_set_skb_fileds_from_metadata() may be a better name.
> >>
> >
> > I very much like this idea of calling another bpf prog to initialize th=
e
> > SKB fields from the meta area. (As a reminder, data need to come from
> > meta area, because at this point the hardware RX-desc is out-of-scope).
> > I'm onboard with xdp_copy_metadata_for_skb() populating the meta area.
> >
> > We could invoke this BPF-prog inside __xdp_build_skb_from_frame().
> >
> > We might need a new BPF_PROG_TYPE_XDP2SKB as this new BPF-prog
> > run_xdp_set_skb_fields_from_metadata() would need both xdp_buff + SKB a=
s
> > context inputs. Right?  (Not sure, if this is acceptable with the BPF
> > maintainers new rules)
> >
> >> The xdp_prog@rx sets the meta data and then redirect.  If the
> >> xdp_prog@rx can also specify a xdp prog to initialize the skb fields
> >> from the meta area, then there is no need to have a kfunc to enforce a
> >> kernel-digestible layout.  Not sure what is a good way to specify this
> >> xdp_prog though...
> >
> > The challenge of running this (BPF_PROG_TYPE_XDP2SKB) BPF-prog inside
> > __xdp_build_skb_from_frame() is that it need to know howto decode the
> > meta area for every device driver or XDP-prog populating this (as veth
> > and cpumap can get redirected packets from multiple device drivers).
>
> If we have the helper to copy the data "out of" the drivers, why do we
> need a second BPF program to copy data to the SKB?
>
> I.e., the XDP program calls xdp_copy_metadata_for_skb(); this invokes
> each of the kfuncs needed for the metadata used by SKBs, all of which
> get unrolled. The helper takes the output of these metadata-extracting
> kfuncs and stores it "somewhere". This "somewhere" could well be the
> metadata area; but in any case, since it's hidden away inside a helper
> (or kfunc) from the calling XDP program's PoV, the helper can just stash
> all the data in a fixed format, which __xdp_build_skb_from_frame() can
> then just read statically. We could even make this format match the
> field layout of struct sk_buff, so all we have to do is memcpy a
> contiguous chunk of memory when building the SKB.

+1

I'm currently doing exactly what you're suggesting (minus matching skb layo=
ut):

struct xdp_to_skb_metadata {
  u32 magic; // randomized at boot
  ... skb-consumable-metadata in fixed format
} __randomize_layout;

bpf_xdp_copy_metadata_for_skb() does bpf_xdp_adjust_meta(ctx,
-sizeof(struct xdp_to_skb_metadata)) and then calls a bunch of kfuncs
to fill in the actual data.

Then, at __xdp_build_skb_from_frame time, I'm having a regular kernel
C code that parses that 'struct xdp_to_skb_metadata'.
(To be precise, I'm trying to parse the metadata from
skb_metadata_set; it's called from __xdp_build_skb_from_frame, but not
100% sure that's the right place).
(I also randomize the layout and magic to make sure userspace doesn't
depend on it because nothing stops this packet to be routed into xsk
socket..)

> > Sure, using a common function/helper/macro like
> > xdp_copy_metadata_for_skb() could help reduce this multiplexing, but
> > we want to have maximum flexibility to extend this without having to
> > update the kernel, right.
>
> The extension mechanism is in which kfuncs are available to XDP programs
> to extract metadata. The kernel then just becomes another consumer of
> those kfuncs, by way of the xdp_copy_metadata_for_skb(); but there could
> also be other kfuncs added that are not used for skbs (even
> vendor-specific ones if we want to allow that).
>
> -Toke
>
