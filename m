Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185C849D330
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiAZULb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiAZULa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:11:30 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F6C06161C;
        Wed, 26 Jan 2022 12:11:30 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id r144so980026iod.9;
        Wed, 26 Jan 2022 12:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iHNtswCZ20T9YzzMlWIKYcpHmw5B2cY7fU1N6zk6jhY=;
        b=MUUklsnuILZdwYcpoefRhuACqNULLEkCfTo9JO0Vwq3j4q7Wb3Wd1D6bkZIlVmHALE
         Z8M0HSaehqLJ/MwZnHdvaZUkxRnXqk5CbM87YXmHvRv/y1PIaV+D+HhEfn7CKuSqZzEK
         6qp5zNHb5fiFsCE0pxEkk3u141TDoVfdpp4DOwqNe538hgJdlXZfU5UwX83rFcGmO0dT
         ADzH0deDRnQYthSHtOlvgJAmUfE7WsDvs6ljDI1HSOkigW1O5Snot1imT1bLvXsRh7vQ
         Fq9BS2/tbSMHG2kHlJQ2JCsRaAkSQLI47J6jnw8jDH8g4yj7WiCQcRDiUHCa3NZtYbeh
         iohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iHNtswCZ20T9YzzMlWIKYcpHmw5B2cY7fU1N6zk6jhY=;
        b=gQfQgPlWbrG6GsCJq5pFpLYkxkr1uV7/LW+Gbmb28GdEPdbivFvmEAeg1KNEiSlNsr
         0sl43PrjtXLrhFaOWyuyr3XBl904vR7GEqrKckkGgJDLv+jOoLLF3hgV0VBISa5jrAZk
         1GFuwF14GhS0B6JWuNTiQC2XFF/LQDiCCfy/OsYuLnprbI124lFvuOdVYx6xPxcc6Cwj
         OWhi+zR/oYz1FISbaFSMhjGx4xcvv8xz0nZ2aiUmzogmEOz/4fOadikyRpirVHMgYyWf
         CjEZOfY+GE/Ncl17mt9Vo72P9ejkG6pRdcS3AhG8csNa/BSeFAx+IJytnhUCR6uEbZcY
         L6OA==
X-Gm-Message-State: AOAM530s+TIbvT2slAham571fSRZ3X+WSExXo5qz4WgXvl7VG89mr40D
        yd8QQZKj0rnLYj1WJ930cNwde6ff72aqwpBwzvOcqoeL1Q0=
X-Google-Smtp-Source: ABdhPJyv5AB5nanXtf5ZSvkcZs6a++KGKqOTEZ+RaQPMXJrIR6J417txQpGFOv+VG436pQuXhfXFTNcv65xYC5tOtUo=
X-Received: by 2002:a5e:8406:: with SMTP id h6mr154510ioj.144.1643227889490;
 Wed, 26 Jan 2022 12:11:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643044381.git.lorenzo@kernel.org> <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <878rv558fy.fsf@toke.dk> <YfEzl0wL+51wa6z7@lore-desk> <20220126120347.cp3xvuxkwyi2o5wx@apollo.legion>
In-Reply-To: <20220126120347.cp3xvuxkwyi2o5wx@apollo.legion>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Jan 2022 12:11:18 -0800
Message-ID: <CAEf4BzYfUb2fQeUAMcjfXdCyzAdGS6NtTkV87G8yOnrdMdOWqg@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable br_fdb_find_port_from_ifindex
 helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 4:05 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Jan 26, 2022 at 05:12:15PM IST, Lorenzo Bianconi wrote:
> > > [ snip to focus on the API ]
> > >
> > > > +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> > > > +                           struct bpf_fdb_lookup *opt,
> > > > +                           u32 opt__sz)
> > > > +{
> > > > + struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
> > > > + struct net_bridge_port *port;
> > > > + struct net_device *dev;
> > > > + int ret = -ENODEV;
> > > > +
> > > > + BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) != NF_BPF_FDB_OPTS_SZ);
> > > > + if (!opt || opt__sz != sizeof(struct bpf_fdb_lookup))
> > > > +         return -ENODEV;
> > >
> > > Why is the BUILD_BUG_ON needed? Or why is the NF_BPF_FDB_OPTS_SZ
> > > constant even needed?
> >
> > I added it to be symmetric with respect to ct counterpart
>
> But the constant needs to be an enum, not a define, otherwise it will not be
> emitted to BTF, I added it so that one could easily check the struct 'version'
> (because sizeof is not relocated in BPF programs).

Without reading the rest of the thread, bpf_core_type_size(struct
bpf_fdb_lookup) would be a CO-RE-relocatable way to get the actual
size of the type in the kernel.

>
> Yes, bpf_core_field_exists and would also work, but the size is fixed anyway and
> we need to check it, so it felt better to give it a name and also make it
> visible to BPF programs at the same time.
>
> >
> >  [...]
>
> --
> Kartikeya
