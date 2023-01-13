Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E7766A202
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 19:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjAMS1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 13:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjAMS0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 13:26:45 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379ED49167;
        Fri, 13 Jan 2023 10:22:50 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id mp20so7586429ejc.7;
        Fri, 13 Jan 2023 10:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SwxEeoGBgqRIV/iTuXNna3YResob5aMiHbzkuhRkD6k=;
        b=qrUJyijRNovU1IU30Vqk0MDytJbYIrCDe+OrzY8r2B4HvjGDXaETA9j1xBZPQcrRyw
         lCQZ55u//NbIUmrKleGsDP742Lmxmdk5dSwrm9rFkHry5YqZQa2/CP5Ur6Da/a/iHqiP
         Sj0OAU9aYU3OC9HxwMV2FWdJicVaAY7KrwVCCjUe88QFVWHfoLG+G+IijWkdsKTQSgNI
         Vgq8HapnzEAqUXZ5b3B3TOScfQAuZT8jQgxizfPPowxJ/ocSti634/M+SH7jySsbBsVe
         +SnU8Pigbn6pL+U///bJs1il7DueHjH6vYVjQoR0qltcmxPeFiTuLdM4FpVwEpOm7a+X
         Dxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SwxEeoGBgqRIV/iTuXNna3YResob5aMiHbzkuhRkD6k=;
        b=IQmWoIuOjqqO/bXoJIpIvZCCBedD3X6TXVfSLQwYQGPfC/H15XVEbDgHKGrvAo1D06
         1BWOvk3DCd8VKgTpP34yJd05NF9HtL/ZkfnoO3QnA3r7iDjok5CsPXuPwCJQvRmmJsHX
         KblX9s83IZ8u6d67hj4PE810h/UD65DD2AWH2vmxc18pwe6GR8W8JxjWzwaMOwyL50hW
         Ojx5pA9PPiohbQEGDp3NWWg69r7GTQAKBQJXNcwA3iB6cCiDNRCarXdEVV28Ssjjw8uH
         kUPXmnkzABGvbT+pT9vlflZd/cR91efYwfS9ThNkRr43Gl/doTZrGlfulU5iDpZuHntJ
         /XCw==
X-Gm-Message-State: AFqh2krbWCAcIkKrXGF3OidnlKfvGWj63CgGPHLffRCP/FB2iis8yheZ
        5eyapFbaFAUKxk6oPkMWMY344Y+vb10Kb/sViF8=
X-Google-Smtp-Source: AMrXdXtDQ5zbeXxwiqexSN7tlDEbCSIXvSEfo9MUWeOCXq3VPu76R7iqDQmEY6zHzqbrZU0+ecj+i45QIdtFWZ+WGwc=
X-Received: by 2002:a17:906:75a:b0:855:d6ed:60d8 with SMTP id
 z26-20020a170906075a00b00855d6ed60d8mr1030695ejb.302.1673634169384; Fri, 13
 Jan 2023 10:22:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1671462950.git.lorenzo@kernel.org> <6cce9b15a57345402bb94366434a5ac5609583b8.1671462951.git.lorenzo@kernel.org>
 <CAEf4BzbOF-S3kjbNVXCZR-K=TGarfi06ZwG1cbNF=HSSodwEfg@mail.gmail.com> <Y72f1U2/dw8jo0/0@lore-desk>
In-Reply-To: <Y72f1U2/dw8jo0/0@lore-desk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Jan 2023 10:22:37 -0800
Message-ID: <CAEf4BzawqXs6q18U8e5GD5d+9v1_w2+QOJYqmEpNb9rZ40E1Tw@mail.gmail.com>
Subject: Re: [RFC bpf-next 6/8] libbpf: add API to get XDP/XSK supported features
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, grygorii.strashko@ti.com, mst@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 9:26 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Mon, Dec 19, 2022 at 7:42 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > >
> > > Add functions to get XDP/XSK supported function of netdev over route
> > > netlink interface. These functions provide functionalities that are
> > > going to be used in upcoming change.
> > >
> > > The newly added bpf_xdp_query_features takes a fflags_cnt parameter,
> > > which denotes the number of elements in the output fflags array. This
> > > must be at least 1 and maybe greater than XDP_FEATURES_WORDS. The
> > > function only writes to words which is min of fflags_cnt and
> > > XDP_FEATURES_WORDS.
> > >
> > > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > Co-developed-by: Marek Majtyka <alardam@gmail.com>
> > > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  tools/lib/bpf/libbpf.h   |  1 +
> > >  tools/lib/bpf/libbpf.map |  1 +
> > >  tools/lib/bpf/netlink.c  | 62 ++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 64 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index eee883f007f9..9d102eb5007e 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -967,6 +967,7 @@ LIBBPF_API int bpf_xdp_detach(int ifindex, __u32 flags,
> > >                               const struct bpf_xdp_attach_opts *opts);
> > >  LIBBPF_API int bpf_xdp_query(int ifindex, int flags, struct bpf_xdp_query_opts *opts);
> > >  LIBBPF_API int bpf_xdp_query_id(int ifindex, int flags, __u32 *prog_id);
> > > +LIBBPF_API int bpf_xdp_query_features(int ifindex, __u32 *fflags, __u32 *fflags_cnt);
> >
> > no need to add new API, just extend bpf_xdp_query()?
>
> Hi Andrii,
>
> AFAIK libbpf supports just NETLINK_ROUTE protocol. In order to connect with the
> genl family code shared by Jakub we need to add NETLINK_GENERIC protocol support
> to libbf. Is it ok to introduce a libmnl or libnl dependency in libbpf or do you
> prefer to add open code to just what we need?

I'd very much like to avoid any extra dependencies. But I also have no
clue how much new code we are talking about, tbh. Either way, the less
dependencies, the better, if the result is an acceptable amount of
extra code to maintain.

> I guess we should have a dedicated API to dump xdp features in this case since
> all the other code relies on NETLINK_ROUTE protocol. What do you think?
>

From API standpoint it looks like an extension to bpf_xdp_query()
family of APIs, which is already extendable through opts. Which is why
I suggested that there is no need for new API. NETLINK_ROUTE vs
NETLINK_GENERIC seems like an internal implementation detail (but
again, I spent literally zero time trying to understand what's going
on here).

> Regards,
> Lorenzo
>
> >
> > >
> > >  /* TC related API */
> > >  enum bpf_tc_attach_point {
> > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > index 71bf5691a689..9c2abb58fa4b 100644
> > > --- a/tools/lib/bpf/libbpf.map
> > > +++ b/tools/lib/bpf/libbpf.map
> > > @@ -362,6 +362,7 @@ LIBBPF_1.0.0 {
> > >                 bpf_program__set_autoattach;
> > >                 btf__add_enum64;
> > >                 btf__add_enum64_value;
> > > +               bpf_xdp_query_features;
> > >                 libbpf_bpf_attach_type_str;
> > >                 libbpf_bpf_link_type_str;
> > >                 libbpf_bpf_map_type_str;
> >
> > [...]
