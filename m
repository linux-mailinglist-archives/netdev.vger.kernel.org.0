Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9E665C9A4
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjACW12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbjACW0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:26:48 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247DC165A9
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 14:24:09 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id k137so16805447pfd.8
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 14:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a2SjNr3Z+L3Cp/DNbgmAZXuHJ6agN6FwcAp+3Hg5iyI=;
        b=XaVLfl+Uz2SAGMIm8MHnc1EOkdySdC0+p02dxb+6tSFKTC27IMm/WSDBzQVKM1r08V
         Lw32E0gUQLHLEFt8wFVV98f8PMp90YGhMzXksrwEW9oaLF2tQlpj2xsihveAvDJYWrIj
         A1oQMGAOZ6kW3IRmbgCMDtSl0uGbx3SEAE8EtlVeOiEsTHwnpsWO8KzGHLp8krAFoADo
         boX+EVA+t7hOmRETa5t+vj1S/PSpmxpaLrEbQRCs/3Og7ZGj6wVsf72AAsnd/8LuzwRD
         diRccQUZbx+hgK5rKDmSHD2EhqWZzC0UvLXJvUJk1Zy3zCC9hQLrep/877ofbA9QthGG
         Vo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a2SjNr3Z+L3Cp/DNbgmAZXuHJ6agN6FwcAp+3Hg5iyI=;
        b=DA8xfZGlfquq1SlekDAQfQNmj5ALtFCmnx3MkqoZDberSQW1Gr8klmNLRe9yb9xxn7
         Flv2K7/sgULmeRBp8jgtgB/HSljvInnX0mZK6yEL7F6dktZ5vl/KPc9IZ3xdC4Pe2Cwv
         iyF0k8M4ktkG3EXkwEZD45EcH+RBwDQ5hir9FphXI/vjEI83VBh+f5qfzHBvgOi9dvAh
         IZlmolfzUmS+5YSp5wUYba7SLlqLQDamhdIIMPNyno7JjCgIQfsbG5v2IqRtzuO3dofl
         +BZ84K3Jn+qA3AtrzPE8fTyBdCvey5hxmfNGvp0tDWL3SilgiL2rxDpjn5kJGEPQi+Fp
         2TYQ==
X-Gm-Message-State: AFqh2krDxc3XPdHMpXmBlL1MD2aoSgwXUJLGwf7+uR3qKY29lu4wCUly
        Pet5dQ4zt32REaM0CvjtxiJdduGd5GmrT40lWpy0ag==
X-Google-Smtp-Source: AMrXdXtxZlxStVXvaH//rng+QDYaVuAN8FmKPBh5ylM5uibagK+/VgEmrqQWvfUp+YW09kCcaPU6c2FM4Zu9FXLnA+Q=
X-Received: by 2002:a65:53c3:0:b0:478:b7ab:2f72 with SMTP id
 z3-20020a6553c3000000b00478b7ab2f72mr2625285pgr.186.1672784595474; Tue, 03
 Jan 2023 14:23:15 -0800 (PST)
MIME-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com> <20221220222043.3348718-2-sdf@google.com>
 <Y6x7+BL7eWERwpGy@maniforge.lan>
In-Reply-To: <Y6x7+BL7eWERwpGy@maniforge.lan>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 3 Jan 2023 14:23:03 -0800
Message-ID: <CAKH8qBs8+gUekdNDRKnU1hg8gCB4Q29eMBhF2NeTT7Y1pyitQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 01/17] bpf: Document XDP RX metadata
To:     David Vernet <void@manifault.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
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
        netdev@vger.kernel.org
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

On Wed, Dec 28, 2022 at 9:25 AM David Vernet <void@manifault.com> wrote:
>
> On Tue, Dec 20, 2022 at 02:20:27PM -0800, Stanislav Fomichev wrote:
> > Document all current use-cases and assumptions.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  Documentation/networking/index.rst           |   1 +
> >  Documentation/networking/xdp-rx-metadata.rst | 107 +++++++++++++++++++
> >  2 files changed, 108 insertions(+)
> >  create mode 100644 Documentation/networking/xdp-rx-metadata.rst
> >
> > diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> > index 4f2d1f682a18..4ddcae33c336 100644
> > --- a/Documentation/networking/index.rst
> > +++ b/Documentation/networking/index.rst
> > @@ -120,6 +120,7 @@ Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
> >     xfrm_proc
> >     xfrm_sync
> >     xfrm_sysctl
> > +   xdp-rx-metadata
> >
> >  .. only::  subproject and html
> >
> > diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
> > new file mode 100644
> > index 000000000000..37e8192d9b60
> > --- /dev/null
> > +++ b/Documentation/networking/xdp-rx-metadata.rst
>
> Hey Stanislav,
>
> This is looking excellent. Left a few more minor comments and
> suggestions.
>
> > @@ -0,0 +1,107 @@
> > +===============
> > +XDP RX Metadata
> > +===============
> > +
> > +This document describes how an XDP program can access hardware metadata
>
> In similar fashion to LWN articles, can we spell out what XDP means the
> first time it's used, e.g.:
>
> ...describes how an eXpress Data Path (XDP) program...
>
> In general this applies to other acronyms unless they're super obvious,
> like "CPU" (thanks for already having done it for XSK).

Sure. Hopefully no need to explain RX below? Don't see anything else..
LMK if I missed something

> > +related to a packet using a set of helper functions, and how it can pass
> > +that metadata on to other consumers.
> > +
> > +General Design
> > +==============
> > +
> > +XDP has access to a set of kfuncs to manipulate the metadata in an XDP frame.
> > +Every device driver that wishes to expose additional packet metadata can
> > +implement these kfuncs. The set of kfuncs is declared in ``include/net/xdp.h``
> > +via ``XDP_METADATA_KFUNC_xxx``.
> > +
> > +Currently, the following kfuncs are supported. In the future, as more
> > +metadata is supported, this set will grow:
> > +
> > +- ``bpf_xdp_metadata_rx_timestamp`` returns a packet's RX timestamp
> > +- ``bpf_xdp_metadata_rx_hash`` returns a packet's RX hash
>
> So, I leave this up to you as to whether or not you want to do this, but
> there is a built-in mechanism in sphinx that converts doxygen comments
> to rendered documentation for a function, struct, etc, and also
> automatically links other places in documentation where the function is
> referenced. See [0] for an example of this in code, and [1] for an
> example of how it's rendered.
>
> [0]: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/Documentation/bpf/kfuncs.rst#n239
> [1]: https://docs.kernel.org/bpf/kfuncs.html#c.bpf_task_acquire
>
> So you would do something like add function headers to the kfuncs, and
> then do:
>
> .. kernel-doc:: net/core/xdp.c
>    :identifiers: bpf_xdp_metadata_rx_timestamp bpf_xdp_metadata_rx_hash
>
> At some point we will need a consistent story for how we document
> kfuncs. That's not set in stone yet, which is why I'm saying it's up to
> you whether or not you want to do this or just leave it as teletype with
> a written description next to it.  Later on when we settle on a
> documentation story for kfuncs, we can update all of them to be
> documented in the same way.

Let me try and see how it looks in the html doc. I like the idea of
referencing the code directly, hopefully less chance it goes stale.

> > +The XDP program can use these kfuncs to read the metadata into stack
>
> s/The/An

Ack, ty!

> > +variables for its own consumption. Or, to pass the metadata on to other
> > +consumers, an XDP program can store it into the metadata area carried
> > +ahead of the packet.
> > +
> > +Not all kfuncs have to be implemented by the device driver; when not
> > +implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
> > +
> > +Within the XDP frame, the metadata layout is as follows::
>
> s/the/an

Thx!

> > +
> > +  +----------+-----------------+------+
> > +  | headroom | custom metadata | data |
> > +  +----------+-----------------+------+
> > +             ^                 ^
> > +             |                 |
> > +   xdp_buff->data_meta   xdp_buff->data
> > +
> > +The XDP program can store individual metadata items into this data_meta
>
> Can we teletype ``data_meta``? Also, s/The XDP program/An XDP program

Sure.

> > +area in whichever format it chooses. Later consumers of the metadata
> > +will have to agree on the format by some out of band contract (like for
> > +the AF_XDP use case, see below).
> > +
> > +AF_XDP
> > +======
> > +
> > +``AF_XDP`` use-case implies that there is a contract between the BPF program
> > +that redirects XDP frames into the ``AF_XDP`` socket (``XSK``) and the final
> > +consumer. Thus the BPF program manually allocates a fixed number of
>
> Can we have ``AF_XDP`` link to the ``AF_XDP`` docs page for any reader
> that's not familiar with it? I think you can just do the following and
> it should just work:
>
> s/``AF_XDP``/:doc:`af_xdp`

Will try.

> > +bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
> > +of kfuncs to populate it. The userspace ``XSK`` consumer computes
> > +``xsk_umem__get_data() - METADATA_SIZE`` to locate its metadata.
>
> s/to locate its metadata/to locate that metadata

SG.

> to make it clear that the consumer is consuming the metadata that was
> populated by bpf_xdp_adjust_meta()? It's pretty clear from context but I
> think "its metadata" may confuse some people as the metadata is not

[..]

> really owned by the consumer. Also, should we mention that
> xsk_umem__get_data() is defined in libxdp?

Add something like:

Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
``METADATA_SIZE`` is an application-specific constant.

?

> One other probably dumb question: is METADATA_SIZE static? If so, should
> we provide a libxdp wrapper to access it?

(added a note above)

> > +
> > +Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::
> > +
> > +  +----------+-----------------+------+
> > +  | headroom | custom metadata | data |
> > +  +----------+-----------------+------+
> > +                               ^
> > +                               |
> > +                        rx_desc->address
> > +
> > +XDP_PASS
> > +========
> > +
> > +This is the path where the packets processed by the XDP program are passed
> > +into the kernel. The kernel creates the ``skb`` out of the ``xdp_buff``
> > +contents. Currently, every driver has custom kernel code to parse
> > +the descriptors and populate ``skb`` metadata when doing this ``xdp_buff->skb``
> > +conversion, and the XDP metadata is not used by the kernel when building
> > +skbs. However, TC-BPF programs can access the XDP metadata area using
> > +the data_meta pointer.
>
> ``data_meta``

Ack.

> > +
> > +In the future, we'd like to support a case where an XDP program
> > +can override some of the metadata used for building skbs.
> > +
> > +bpf_redirect_map
> > +================
> > +
> > +``bpf_redirect_map`` can redirect the frame to a different device.
> > +Some devices (like virtual ethernet links) support running a second XDP
> > +program after the redirect. However, the final consumer doesn't have
> > +access to the original hardware descriptor and can't access any of
> > +the original metadata. The same applies to XDP programs installed
> > +into devmaps and cpumaps.
> > +
> > +This means that for redirected packets only custom metadata is
> > +currently supported, which has to be prepared by the initial XDP program
> > +before redirect. If the frame is eventually passed to the kernel, the
> > +skb created from such a frame won't have any hardware metadata populated
> > +in its skb. And if such a packet is later redirected into an ``XSK``,
>
> s/And if/If
>
> Also, can you add teletype ``skb`` in this paragraph?

Sure, thanks.

> > +that will also only have access to the custom metadata.
> > +
> > +
> > +bpf_tail_call
> > +=============
> > +
> > +Adding programs that access metadata kfuncs to the ``BPF_MAP_TYPE_PROG_ARRAY``
> > +is currently not supported.
> > +
> > +Example
> > +=======
> > +
> > +See ``tools/testing/selftests/bpf/progs/xdp_metadata.c`` and
> > +``tools/testing/selftests/bpf/prog_tests/xdp_metadata.c`` for an example of
> > +BPF program that handles XDP metadata.
> > --
> > 2.39.0.314.g84b9a713c41-goog
>
> Looks great otherwise, thanks.
