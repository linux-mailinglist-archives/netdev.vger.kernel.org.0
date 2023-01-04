Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D4865D7CB
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbjADQCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjADQCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:02:51 -0500
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6792CB01;
        Wed,  4 Jan 2023 08:02:50 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id z12so27529950qtv.5;
        Wed, 04 Jan 2023 08:02:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwSsj6dKaBLyzBS+oljx3z67n7iA+If7j6wt5yj7OGk=;
        b=fgrZ6ee2emsMmV5mzuKTPj+vr4xNyvDPDSRQc4vaHvZ7pFPfOG3KbV08DVpoXMbNSR
         bjvGkQGMLQ3flRB6dmt75TpznlwgwcgkdnN1Qmin0LNxUDH/8bncGZINoNr8r3K4F2lf
         8FlSaG/hEjzMaQDEKN4RJ5ctDhACqEvHyb3YmONivmsisdJ2zerx3bIn3JkoTlbXFhYl
         zAJr3QfK9WQiSUmhrahxcvv4wAqDRo+gZte21fPcE+Z1HYmPoblaBvN6EfUFeM4XoWDX
         3gSvfVNWO2yb8q1ghMwqrNxPpvtqAoiai2Ss6VvQBuvVNo8GulPo22WYf3XjR1W7iHEQ
         XvWw==
X-Gm-Message-State: AFqh2kpdwWyetDEvW87cFrUwUGuXtjKQ6nCpup5Yo3IJdAk1QEHY95//
        YJDdZ9Q9KAJqrMz7BemjzVs=
X-Google-Smtp-Source: AMrXdXuMglJVXwPAb6rs5TQsBK2qJgPizgdczySE1YEsATFGWEriPNwr0oOzc96UlJ9LEqSbLw7X3w==
X-Received: by 2002:ac8:4a07:0:b0:3a5:8084:9f60 with SMTP id x7-20020ac84a07000000b003a580849f60mr67619083qtq.64.1672848169338;
        Wed, 04 Jan 2023 08:02:49 -0800 (PST)
Received: from maniforge.lan ([2620:10d:c091:480::1:7c6c])
        by smtp.gmail.com with ESMTPSA id t1-20020ac865c1000000b003a7e4129f83sm19996524qto.85.2023.01.04.08.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:02:48 -0800 (PST)
Date:   Wed, 4 Jan 2023 10:02:48 -0600
From:   David Vernet <void@manifault.com>
To:     Stanislav Fomichev <sdf@google.com>
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
Subject: Re: [PATCH bpf-next v5 01/17] bpf: Document XDP RX metadata
Message-ID: <Y7WjKNv10wt0GZ6y@maniforge.lan>
References: <20221220222043.3348718-1-sdf@google.com>
 <20221220222043.3348718-2-sdf@google.com>
 <Y6x7+BL7eWERwpGy@maniforge.lan>
 <CAKH8qBs8+gUekdNDRKnU1hg8gCB4Q29eMBhF2NeTT7Y1pyitQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBs8+gUekdNDRKnU1hg8gCB4Q29eMBhF2NeTT7Y1pyitQQ@mail.gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 02:23:03PM -0800, Stanislav Fomichev wrote:
> On Wed, Dec 28, 2022 at 9:25 AM David Vernet <void@manifault.com> wrote:
> >
> > On Tue, Dec 20, 2022 at 02:20:27PM -0800, Stanislav Fomichev wrote:
> > > Document all current use-cases and assumptions.
> > >
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: David Ahern <dsahern@gmail.com>
> > > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > > Cc: xdp-hints@xdp-project.net
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  Documentation/networking/index.rst           |   1 +
> > >  Documentation/networking/xdp-rx-metadata.rst | 107 +++++++++++++++++++
> > >  2 files changed, 108 insertions(+)
> > >  create mode 100644 Documentation/networking/xdp-rx-metadata.rst
> > >
> > > diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> > > index 4f2d1f682a18..4ddcae33c336 100644
> > > --- a/Documentation/networking/index.rst
> > > +++ b/Documentation/networking/index.rst
> > > @@ -120,6 +120,7 @@ Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
> > >     xfrm_proc
> > >     xfrm_sync
> > >     xfrm_sysctl
> > > +   xdp-rx-metadata
> > >
> > >  .. only::  subproject and html
> > >
> > > diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
> > > new file mode 100644
> > > index 000000000000..37e8192d9b60
> > > --- /dev/null
> > > +++ b/Documentation/networking/xdp-rx-metadata.rst
> >
> > Hey Stanislav,
> >
> > This is looking excellent. Left a few more minor comments and
> > suggestions.
> >
> > > @@ -0,0 +1,107 @@
> > > +===============
> > > +XDP RX Metadata
> > > +===============
> > > +
> > > +This document describes how an XDP program can access hardware metadata
> >
> > In similar fashion to LWN articles, can we spell out what XDP means the
> > first time it's used, e.g.:
> >
> > ...describes how an eXpress Data Path (XDP) program...
> >
> > In general this applies to other acronyms unless they're super obvious,
> > like "CPU" (thanks for already having done it for XSK).
> 
> Sure. Hopefully no need to explain RX below? Don't see anything else..
> LMK if I missed something

Yeah, I think we can forego RX.

> 
> > > +related to a packet using a set of helper functions, and how it can pass
> > > +that metadata on to other consumers.
> > > +
> > > +General Design
> > > +==============
> > > +
> > > +XDP has access to a set of kfuncs to manipulate the metadata in an XDP frame.
> > > +Every device driver that wishes to expose additional packet metadata can
> > > +implement these kfuncs. The set of kfuncs is declared in ``include/net/xdp.h``
> > > +via ``XDP_METADATA_KFUNC_xxx``.
> > > +
> > > +Currently, the following kfuncs are supported. In the future, as more
> > > +metadata is supported, this set will grow:
> > > +
> > > +- ``bpf_xdp_metadata_rx_timestamp`` returns a packet's RX timestamp
> > > +- ``bpf_xdp_metadata_rx_hash`` returns a packet's RX hash
> >
> > So, I leave this up to you as to whether or not you want to do this, but
> > there is a built-in mechanism in sphinx that converts doxygen comments
> > to rendered documentation for a function, struct, etc, and also
> > automatically links other places in documentation where the function is
> > referenced. See [0] for an example of this in code, and [1] for an
> > example of how it's rendered.
> >
> > [0]: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/Documentation/bpf/kfuncs.rst#n239
> > [1]: https://docs.kernel.org/bpf/kfuncs.html#c.bpf_task_acquire
> >
> > So you would do something like add function headers to the kfuncs, and
> > then do:
> >
> > .. kernel-doc:: net/core/xdp.c
> >    :identifiers: bpf_xdp_metadata_rx_timestamp bpf_xdp_metadata_rx_hash
> >
> > At some point we will need a consistent story for how we document
> > kfuncs. That's not set in stone yet, which is why I'm saying it's up to
> > you whether or not you want to do this or just leave it as teletype with
> > a written description next to it.  Later on when we settle on a
> > documentation story for kfuncs, we can update all of them to be
> > documented in the same way.
> 
> Let me try and see how it looks in the html doc. I like the idea of
> referencing the code directly, hopefully less chance it goes stale.

Sounds good!

[...]

Thanks for making all these changes.

- David
