Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CC547A276
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbhLSVyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhLSVyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 16:54:08 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD9CC061574;
        Sun, 19 Dec 2021 13:54:08 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so11036917pja.1;
        Sun, 19 Dec 2021 13:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bpJ1tpZtIn/OH7Mx1PX+KRlqSM9aM2xKf/DJUcgWLQ4=;
        b=g6M2458CPZaZI9J81farCyN5tu7z1tAz0wF9qLy1EBqV+84h/sO5dPYl/LphME/GQk
         LVY9WExCne8IA0yUi3U+ePf1UzwWQxznTCMhh9pH+7MoyVN4CU4bUV/67v3G+bfYwGVC
         KwvKis+iCwuBELs50K2ACelY14hmib9mXBWp/09IaB6gJ9bDyTxF7CKzkw4dTazBU8QM
         fC+dgtHS6sejnDNMfmL9x2F09l8sCDIVaFVwHQpg74YFwHOYVDj8AA/iCeed1Xeh9klR
         geU5DXdgTaOYT6u/TRq/DV6coguZ98TSzQ7vlC35E9M3ztyZOmp+PlwNvZ1pWkR/Vt1M
         iNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bpJ1tpZtIn/OH7Mx1PX+KRlqSM9aM2xKf/DJUcgWLQ4=;
        b=xr0pg5lMMJK9oiFDCDFUbERqZBuuv3PP+OOioEk4hFMVKQavt4j2d31QMvJg7ZaT0o
         GDcqtMRBcywsx/mUBJtiBnKKmIVYcVRXk6r1NVCjMjTm04yKwz1Ei7RA8JDNHqN6XfT4
         eEGQYKehlFyYTFfLfPx+I0NGe5AvrVLeMgQQ1laNhd0MR+Kx3jvCYfhDKDroeZqCTuYe
         KZTT/NVyebDmJ9w/oYb42tNjvQQ72u6g4iCauF+k/ezWuyCWiSkGCqBjRvAjhLkKTLkm
         zfh45gpldri8/1Xmw5LlXulNPILfQ0eCrFADeEW9KbxHbqZRW2GTKR0E63U6pMuDKBQM
         307Q==
X-Gm-Message-State: AOAM530p10A7beemB8fq/JlRlaeERqwiI9BLEwz20L2gDgIkQX6Yq3hI
        snWa1GwpR2zM7bC755IVuhk=
X-Google-Smtp-Source: ABdhPJyf9PzYWXVb8NqCLpSpkaTqV36KmKXznPfzdAfkJTpE7clBirZEdcTtXHDXYUaRpcbN7salog==
X-Received: by 2002:a17:903:1103:b0:143:a593:dc41 with SMTP id n3-20020a170903110300b00143a593dc41mr13709234plh.5.1639950847613;
        Sun, 19 Dec 2021 13:54:07 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id z2sm16863166pfh.188.2021.12.19.13.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 13:54:07 -0800 (PST)
Date:   Mon, 20 Dec 2021 03:24:05 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 06/10] bpf: Track provenance for pointers
 formed from referenced PTR_TO_BTF_ID
Message-ID: <20211219215405.sf7xbzqhn5mcgpmq@apollo.legion>
References: <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
 <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
 <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
 <20211219052540.yuqbxldypj4quhhd@apollo.legion>
 <CAADnVQ+EtYjnH+=tZCOYX+ioyx=d4NAxFFpRpN2PVfvye6thTA@mail.gmail.com>
 <20211219181044.5s2bopdn5gk7wwhz@apollo.legion>
 <20211219190810.p3q52rrlchnokufo@ast-mbp>
 <20211219195603.pta666hynpz45xlf@apollo.legion>
 <20211219212645.5pqswdfay75vyify@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219212645.5pqswdfay75vyify@ast-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 02:56:45AM IST, Alexei Starovoitov wrote:
> On Mon, Dec 20, 2021 at 01:26:03AM +0530, Kumar Kartikeya Dwivedi wrote:
> > >
> > > The goal is clear now, but look at it differently:
> > > struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> > > if (ct) {
> > >   struct nf_conn *master = ct->master;
> > >   struct net *net = ct->ct_net.net;
> > >
> > >   bpf_ct_release(ct);
> > >   master->status; // prevent this ?
> > >   net->ifindex;   // but allow this ?
> >
> > I think both will be prevented with the current logic, no?
> > net will be ct + offset, so if mark_btf_ld_reg writes PTR_TO_BTF_ID to dst_reg
> > for net, it will copy ct's reg's ref_obj_id to parent_ref_obj_id of dst_reg (net).
> > Then on release of ct, net's reg gets killed too since reg[ct]->ref_obj_id
> > matches its parent_ref_obj_id.
>
> Excatly, but it should be allowed.
> There is nothing wrong with 'net' access after ct_release.
>

Ok, I see your point. I'll just drop this patch in v5, and we'll revisit the
other pkt pointer thing when the patch is posted.

> [...]
> > Very interesting idea! I'm guessing we'll need something akin to bpf_timer
> > support, i.e. a dedicated type verified using BTF which can be embedded in
> > map_value? I'll be happy to work on enabling this.
>
> Thanks! Would be awesome.
>
> > One thought though (just confirming):
> > If user does map_value->saved_ct = ct, we have to ignore reference leak check
> > for ct's ref_id, but if they rewrite saved_ct, we would also have to unignore
> > it, correct?
>
> We cannot just ignore it :)
> I was thinking to borrow std::unique_ptr like semanitcs.
>
> struct nf_conn *ct = bpf_xdp_ct_lookup(...); // here ref checking logic tracks it as normal
> map_value->saved_ct = ct; // here it trasnfers the ref from Rx into map_value
> ct->status; // cannot be access here.
>
> It could look unnatural to typical C programmer, so we might need
> explicit std::move-like helper, so the assignment will be:
> bpf_move_ptr(&map_value->saved_ct, &ct); // same as map_value->saved_ct = ct; ct = NULL;
> ...
> bpf_move_ptr(&ct, &map_value->saved_ct); // would take the ownership back from the map
> // and the ref checking logic tracks 'ct' again as normal
>

Agreed, normal assignment syntax having those side effects is indeed awkward.

> > I think we can make this tracking easier by limiting to one bpf_ptr_to_btf
> > struct in map_value, then it can simply be part of ptr_to_map_value's reg_state.
>
> Possible. Hopefully such limitiation will not be needed.

Thanks for your review and feedback, Alexei! I'll address all points.

--
Kartikeya
