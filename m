Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109B76A4CAC
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjB0VB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjB0VB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:01:58 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4601623C7F;
        Mon, 27 Feb 2023 13:01:57 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-536cb25982eso211710847b3.13;
        Mon, 27 Feb 2023 13:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gbSo0z69FDjg0xel2jPAZLJQhmNE/ROmdCWMSIdEckg=;
        b=mdEjCXEvLOL/rEEVRmRzy8OScWDk2rOQUmPNAuGAZa9b1MEWrf+dTIjqzaLDi8hiFc
         kCL5xTRPcrUJdHmZNxaLK/mYhm6TJdbUFHXQ1mJr1dmFHDpKg/WHxO4IE0GARYDIrhVB
         5kqv3+zBWpzI8XEc5L1KWUTYRQJKiHbswBUx8rQZjHS64FKLuZdMFlnEh5RpGnCox3d+
         fs0ghqRyR4Zdj7s9cyeCHJzIhFQHQAPbjLV5ABB9sbmEsL0gE7p29KmgRfnoy7AUVKI4
         OyhvPluMC+qk+uLil1g7K9FyKAjdysC7WZDD0BqqeuERzb4EXzlN2KGrb2M6Ldhe6+Wl
         4QOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gbSo0z69FDjg0xel2jPAZLJQhmNE/ROmdCWMSIdEckg=;
        b=YMaBs+/bhQF1U6OaxX6FjH7aoWlC0j4gTrhSwPF4bBxYeTedUWbXXfvSxehUuUC/GH
         i7yuvDxEITGJ0LID1hxuriSZzYWAtZuOlweO3EVB72yT6LGxiKTePM0qUqbZMf6ZtA1K
         naCyL5uUbRzt8wTtLZCQFsXvuxq2XwOTp+V3fOsFgy7Uaj0OD4BvTpOtxNSCsYFATTC0
         Cz651FJq8T5CHgHwjlCaSa52XBN+qtW5bH6pO1faVSlxveuWxs83a0AuC5QQTLwMWZkZ
         sOlc7YUV+ZOTNclcQ9ziYFBy22ZR3YHmm2BAzFMyobz+lUdZFsT3NH1kv1o+dRizgAHH
         POtg==
X-Gm-Message-State: AO0yUKUjd44zXxF5EeDYhdaqczRCAwSTbwhvzaWXDWFd71GX3qfiarT1
        nkkMAJNRH6QIrtStFuUgFJZgNvCatm0W0cTVPcw=
X-Google-Smtp-Source: AK7set8ZRJ/04QVuUtSfV8RQeBBA144qhMTpdVn4XUsVGLzPsABkW93ZtV1Kqj7ABcTchAe6t6KzJwwtc2mF1ainjQc=
X-Received: by 2002:a81:441c:0:b0:52e:f66d:b70f with SMTP id
 r28-20020a81441c000000b0052ef66db70fmr58937ywa.5.1677531716357; Mon, 27 Feb
 2023 13:01:56 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675245257.git.lorenzo@kernel.org> <a72609ef4f0de7fee5376c40dbf54ad7f13bfb8d.1675245258.git.lorenzo@kernel.org>
 <e519f15d-cdd0-9362-34f3-3e6b8c8a4762@meta.com>
In-Reply-To: <e519f15d-cdd0-9362-34f3-3e6b8c8a4762@meta.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Feb 2023 13:01:43 -0800
Message-ID: <CAEf4BzY0sHqEXaY8no0VgwEbNoPEaQz0h53Gav=T1DCsjsjo8A@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 5/8] libbpf: add API to get XDP/XSK supported features
To:     Yonghong Song <yhs@meta.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kuba@kernel.org,
        Martin KaFai Lau <martin.lau@kernel.org>
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

On Mon, Feb 27, 2023 at 12:39 PM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 2/1/23 2:24 AM, Lorenzo Bianconi wrote:
> > Extend bpf_xdp_query routine in order to get XDP/XSK supported features
> > of netdev over route netlink interface.
> > Extend libbpf netlink implementation in order to support netlink_generic
> > protocol.
> >
> > Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Co-developed-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   tools/lib/bpf/libbpf.h  |  3 +-
> >   tools/lib/bpf/netlink.c | 96 +++++++++++++++++++++++++++++++++++++++++
> >   tools/lib/bpf/nlattr.h  | 12 ++++++
> >   3 files changed, 110 insertions(+), 1 deletion(-)
> >
> [...]
> > +
> >   int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
> >   {
> >       struct libbpf_nla_req req = {
> > @@ -366,6 +433,10 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
> >               .ifinfo.ifi_family = AF_PACKET,
> >       };
> >       struct xdp_id_md xdp_id = {};
> > +     struct xdp_features_md md = {
> > +             .ifindex = ifindex,
> > +     };
> > +     __u16 id;
> >       int err;
> >
> >       if (!OPTS_VALID(opts, bpf_xdp_query_opts))
> > @@ -393,6 +464,31 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
> >       OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
> >       OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
> >
> > +     if (!OPTS_HAS(opts, feature_flags))
> > +             return 0;
> > +
> > +     err = libbpf_netlink_resolve_genl_family_id("netdev", sizeof("netdev"), &id);
> > +     if (err < 0)
> > +             return libbpf_err(err);
>
> Hi, Lorenzo,
>
> Using latest libbpf repo (https://github.com/libbpf/libbpf, sync'ed from
> source), looks like the above change won't work if the program is
> running on an old kernel, e.g., 5.12 kernel.
>
> In this particular combination, in user space, bpf_xdp_query_opts does
> have 'feature_flags' member, so the control can reach
> libbpf_netlink_resolve_genl_family_id(). However, the family 'netdev'
> is only available in latest kernel (after this patch set). So
> the error will return in the above.
>
> This breaks backward compatibility since old working application won't
> work any more with a refresh of libbpf.
>
> I could not come up with an easy solution for this. One thing we could
> do is to treat 'libbpf_netlink_resolve_genl_family_id()' as a probe, so
> return 0 if probe fails.
>
>    err = libbpf_netlink_resolve_genl_family_id("netdev",
> sizeof("netdev"), &id);
>    if (err < 0)
>         return 0;
>
> Please let me know whether my suggestion makes sense or there could be a
> better solution.
>

feature_flags is an output parameter and if the "netdev" family
doesn't exist then there are no feature flags to return, right?

Is there a specific error code that's returned when such a family
doesn't exist? If yes, we should check for it and return 0 for
feature_flags. If not, we'll have to do a generic < 0 check as
Yonghong proposes.


>
> > +
> > +     memset(&req, 0, sizeof(req));
> > +     req.nh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
> > +     req.nh.nlmsg_flags = NLM_F_REQUEST;
> > +     req.nh.nlmsg_type = id;
> > +     req.gnl.cmd = NETDEV_CMD_DEV_GET;
> > +     req.gnl.version = 2;
> > +
> > +     err = nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex, sizeof(ifindex));
> > +     if (err < 0)
> > +             return err;
> > +
> > +     err = libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
> > +                                    parse_xdp_features, NULL, &md);
> > +     if (err)
> > +             return libbpf_err(err);
> > +
> > +     opts->feature_flags = md.flags;
> > +
> >       return 0;
> >   }
> >
> [...]
