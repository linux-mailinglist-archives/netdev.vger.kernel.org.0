Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196DD67EC4A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbjA0RSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbjA0RSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:18:32 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F96D38013
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 09:18:31 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m7-20020a17090a71c700b0022c0c070f2eso8567506pjs.4
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 09:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qtouv6Z6Gh5nIAaDvGdVmaZJMnuDScOHiRWBgSzL7vs=;
        b=PjAdEhrytMEw3NDmnzkGw1Ha9Tvj3WrOYvmJ/JxVPPndm1Eto9HncK/RgyZG10Ib1y
         gAuxnGwpLb1YAzBZhf6DMq7l2rKD12NP5F5Z2QwrLz+ddsMDKugz0uDkYpxCsg9cPGck
         ce6tlscI7EwqoY8T4tmzNrcI0qaXc3a1xnNyk8YVzk0Um2AcH9vlwG7SmOqfqJbHEDKJ
         gBeXDi13HKr8kDvKltX2mLHWGXkRLij7Zg2b6hq3GJ2dGYyM7ocCUxeA6k7Ct9sNcJ8E
         iHNj10fJndFoE9p6ISqSVpKJ9NjXTq4vXuXvIpJDzbalrGA87YXH354pwBXe0rACZuak
         3Sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qtouv6Z6Gh5nIAaDvGdVmaZJMnuDScOHiRWBgSzL7vs=;
        b=EXTkRJZnqFjBTqb2gC2ZK+QecVv9t9WS4YgUs6FzAofF+ugU5veFu+Cd+Vg7VXWWrO
         G90N/HGfYI18fyXGAJhSzi8+MgyKozpCl/31/VG6WE+u7VHySppySGNbULycd6WRjqqa
         dGemIGBjOo+YerDTNJEG4gxvjkHq7wvA0PQ1gMI3YaboKqxGqww8cc4y7HOPbRrWPel+
         vsMeAwBiwtio1jdAyW7KWEnjxrWY4Ny1YFzGzgFO2K/Xv5lv/GlVKQ/LSzzdwC9W9cYy
         GLLYUon56Wc4erZyN6URYCic3zO0oUNVMu2lTfL+gtg5GCghjfXTYp2RUcWE60E/XISB
         nVxg==
X-Gm-Message-State: AO0yUKUN/MECLvs8k0y3/YpbCPnXm/rMJvd7Gc+10ZQBRGxVvdSTslHN
        vv1efeqzphYNVSfIvux7Vw4Vi4Nq38+awhvdkiVing==
X-Google-Smtp-Source: AK7set/1hpxNVHlFIAFcnSPfgMcdJgv+C7gc3wU/4TGtqW8mjpZXmVYc0HKBp1hxQxUFwUzdaARiCeiMlJXlQofVbTk=
X-Received: by 2002:a17:902:82c6:b0:196:cca:a0b4 with SMTP id
 u6-20020a17090282c600b001960ccaa0b4mr2367989plz.20.1674839910675; Fri, 27 Jan
 2023 09:18:30 -0800 (PST)
MIME-Version: 1.0
References: <167482734243.892262.18210955230092032606.stgit@firesoul> <87cz70krjv.fsf@toke.dk>
In-Reply-To: <87cz70krjv.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 27 Jan 2023 09:18:19 -0800
Message-ID: <CAKH8qBtc0TRorF2zsD0dZjgredpzcmczK=KMgt1mpEX_mQG2Kg@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next RFC V1] selftests/bpf:
 xdp_hw_metadata clear metadata when -EOPNOTSUPP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, martin.lau@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        dsahern@gmail.com, willemb@google.com, void@manifault.com,
        kuba@kernel.org, xdp-hints@xdp-project.net
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

On Fri, Jan 27, 2023 at 5:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>
> > The AF_XDP userspace part of xdp_hw_metadata see non-zero as a signal o=
f
> > the availability of rx_timestamp and rx_hash in data_meta area. The
> > kernel-side BPF-prog code doesn't initialize these members when kernel
> > returns an error e.g. -EOPNOTSUPP.  This memory area is not guaranteed =
to
> > be zeroed, and can contain garbage/previous values, which will be read
> > and interpreted by AF_XDP userspace side.
> >
> > Tested this on different drivers. The experiences are that for most
> > packets they will have zeroed this data_meta area, but occasionally it
> > will contain garbage data.
> >
> > Example of failure tested on ixgbe:
> >  poll: 1 (0)
> >  xsk_ring_cons__peek: 1
> >  0x18ec788: rx_desc[0]->addr=3D100000000008000 addr=3D8100 comp_addr=3D=
8000
> >  rx_hash: 3697961069
> >  rx_timestamp:  9024981991734834796 (sec:9024981991.7348)
> >  0x18ec788: complete idx=3D8 addr=3D8000
> >
> > Converting to date:
> >  date -d @9024981991
> >  2255-12-28T20:26:31 CET
> >
> > I choose a simple fix in this patch. When kfunc fails or isn't supporte=
d
> > assign zero to the corresponding struct meta value.
> >
> > It's up to the individual BPF-programmer to do something smarter e.g.
> > that fits their use-case, like getting a software timestamp and marking
> > a flag that gives the type of timestamp.
> >
> > Another possibility is for the behavior of kfunc's
> > bpf_xdp_metadata_rx_timestamp and bpf_xdp_metadata_rx_hash to require
> > clearing return value pointer.
>
> I definitely think we should leave it up to the BPF programmer to react
> to failures; that's what the return code is there for, after all :)

+1

Maybe we can unconditionally memset(meta, sizeof(*meta), 0) in
tools/testing/selftests/bpf/progs/xdp_hw_metadata.c?
Since it's not a performance tool, it should be ok functionality-wise.

> -Toke
>
