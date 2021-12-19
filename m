Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB77A47A255
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhLSV0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhLSV0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 16:26:49 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0362C061574;
        Sun, 19 Dec 2021 13:26:49 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x15so6137662plg.1;
        Sun, 19 Dec 2021 13:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hZPQgrCumR+wPgggdKtvv/iYIkjgp4YaFkeT/TzLZdo=;
        b=Hx4izuMBeuqkND1QIt+J3cZw8L12PQX/y8tTk7teym+rp5HzHimd1+U38OfJI9DxJs
         kBlSzhwKxPbZ0SBKcVz91IGO54CaAV1WGriCz8baBj/NYiT9MJ2AMPXXzhM/lZ6eEMsZ
         vpiYeTqzJvwiWAdH0h2h3nFCaTFc44773wWe5dVRLkKkNhFWy+UKxk58r8qY89cr98WB
         ehjA2+VtX1r41z9+y5V6KfHUuRaVxk/a0Cvjb/tP9awEXrNuE8tDMRfW9I76YcmANBmD
         ltDEwmsCQOQALMhoVaIOuLOP6DVsABktsG6l2FkInyN5AknugU+aNHhJlmRreHzCqwcx
         Py9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hZPQgrCumR+wPgggdKtvv/iYIkjgp4YaFkeT/TzLZdo=;
        b=fs3rRBOe8twg6d4xFZS+5UPbYla6GuX7Y0rpRLIgCDlX3xxHuvtA6KIpf5eg6Y50HU
         j6of4DHAaeeyyaXsWUmmuw8iUGTeIntJZgJvrRorIaXXtWOpdAxqT9CjOm/hJh2F5tai
         DDTpuBy5lwK1PoC9vG8yxyoOV7Q32BtCkef0pLVkO1aav5aeTv9w3pUOdaNdDIICPgA9
         auXFYf6Z1nIwtelGNTNQj5nOHAmwWB78wLNpMSpeAERdnuic2buyAsJYqSIoAr/lzHRs
         Qm97L/GaJopcIe0s6FekH67q8zA+I5cAcpuTo2m1lV2SH/mpGW7vfAZEf4HybPpZ3A78
         Hxkw==
X-Gm-Message-State: AOAM532wEwsGRCKHSrfef3eu9tZHtfErr2Oa/XQIalOsLFPlqdRslCF4
        Gf9ookCXuoYGNhPjtDejh5w=
X-Google-Smtp-Source: ABdhPJwqztK2nhU3P1/ziv8oAoxGGt7n4S43f++NP0Eg5Zbj3GnuYdWaIrbLN/1/5l2Loegc8L9hjQ==
X-Received: by 2002:a17:90a:7782:: with SMTP id v2mr16697127pjk.81.1639949209025;
        Sun, 19 Dec 2021 13:26:49 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:9874])
        by smtp.gmail.com with ESMTPSA id b22sm572285pfv.107.2021.12.19.13.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 13:26:48 -0800 (PST)
Date:   Sun, 19 Dec 2021 13:26:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20211219212645.5pqswdfay75vyify@ast-mbp>
References: <20211219022839.kdms7k3jte5ajubt@ast-mbp>
 <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
 <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
 <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
 <20211219052540.yuqbxldypj4quhhd@apollo.legion>
 <CAADnVQ+EtYjnH+=tZCOYX+ioyx=d4NAxFFpRpN2PVfvye6thTA@mail.gmail.com>
 <20211219181044.5s2bopdn5gk7wwhz@apollo.legion>
 <20211219190810.p3q52rrlchnokufo@ast-mbp>
 <20211219195603.pta666hynpz45xlf@apollo.legion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219195603.pta666hynpz45xlf@apollo.legion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 01:26:03AM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > The goal is clear now, but look at it differently:
> > struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> > if (ct) {
> >   struct nf_conn *master = ct->master;
> >   struct net *net = ct->ct_net.net;
> >
> >   bpf_ct_release(ct);
> >   master->status; // prevent this ?
> >   net->ifindex;   // but allow this ?
> 
> I think both will be prevented with the current logic, no?
> net will be ct + offset, so if mark_btf_ld_reg writes PTR_TO_BTF_ID to dst_reg
> for net, it will copy ct's reg's ref_obj_id to parent_ref_obj_id of dst_reg (net).
> Then on release of ct, net's reg gets killed too since reg[ct]->ref_obj_id
> matches its parent_ref_obj_id.

Excatly, but it should be allowed.
There is nothing wrong with 'net' access after ct_release.

> > }
> > The verifier cannot statically check this. That's why all such deref
> > are done via BPF_PROBE_MEM (which is the same as probe_read_kernel).
> > We must disallow use after free when it can cause a crash.
> > This case is not the one.
> 
> That is a valid point, this is certainly in 'nice to have/prevents obvious
> misuse' territory, but if this can be done without introducing too much
> complexity, I'd like us to do it.
> 
> A bit of a digression, but:
> I'm afraid this patch is going to be brought up again for a future effort
> related to XDP queueing that Toke is working on. We have a similar scenario
> there, when xdp_md (aliasing xdp_frame) is dequeued from the PIFO map, and
> PTR_TO_PACKET is obtained by reading xdp_md->data. The xdp_md is referenced, so
> we need to invalidate these pkt pointers as well, in addition to killing xdp_md
> copies. Also this parent_ref_obj_id state allows us to reject comparisons
> between pkt pointers pointing into different xdp_md's (when you dequeue more
> than one at once and form multiple pkt pointers pointing into different
> xdp_mds).

I cannot quite grasp the issue. Sounds orthogonal. The pkt pointers
are not ptr_to_btf_id like. There is no PROBE_MEM there.

> >   struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> >   struct nf_conn *master = ct->master;
> >   bpf_ct_release(master);
> > definitely has to be prevented, since it will cause a crash.
> >
> > As a follow up to this set would be great to allow ptr_to_btf_id
> > pointers persist longer than program execution.
> > Users already asked to allow the following:
> >   map_value = bpf_map_lookup_elem(...);
> >   struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> >   map_value->saved_ct = ct;
> > and some time later in a different or the same program:
> >   map_value = bpf_map_lookup_elem(...);
> >   bpf_ct_release(map_value->saved_ct);
> >
> > Currently folks work around this deficiency by storing some
> > sort of id and doing extra lookups while performance is suffering.
> > wdyt?
> 
> Very interesting idea! I'm guessing we'll need something akin to bpf_timer
> support, i.e. a dedicated type verified using BTF which can be embedded in
> map_value? I'll be happy to work on enabling this.

Thanks! Would be awesome.

> One thought though (just confirming):
> If user does map_value->saved_ct = ct, we have to ignore reference leak check
> for ct's ref_id, but if they rewrite saved_ct, we would also have to unignore
> it, correct?

We cannot just ignore it :)
I was thinking to borrow std::unique_ptr like semanitcs.

struct nf_conn *ct = bpf_xdp_ct_lookup(...); // here ref checking logic tracks it as normal
map_value->saved_ct = ct; // here it trasnfers the ref from Rx into map_value
ct->status; // cannot be access here.

It could look unnatural to typical C programmer, so we might need 
explicit std::move-like helper, so the assignment will be:
bpf_move_ptr(&map_value->saved_ct, &ct); // same as map_value->saved_ct = ct; ct = NULL;
...
bpf_move_ptr(&ct, &map_value->saved_ct); // would take the ownership back from the map
// and the ref checking logic tracks 'ct' again as normal

> I think we can make this tracking easier by limiting to one bpf_ptr_to_btf
> struct in map_value, then it can simply be part of ptr_to_map_value's reg_state.

Possible. Hopefully such limitiation will not be needed.
