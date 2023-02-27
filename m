Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C136A4EE8
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 23:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjB0WuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 17:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjB0WuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 17:50:05 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9145F28D1E;
        Mon, 27 Feb 2023 14:49:45 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s26so32197515edw.11;
        Mon, 27 Feb 2023 14:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9MUet1JhhQs4KY3/dY7MXiCmPNwf83GCMCfxm1tO1yU=;
        b=kVOYe+caSdUTsLJxQdZuB5EdnCxnRHVz/b8I6Gw91rdAXFoK0U+NNE7OEZ0QZieapx
         urpu3JIQZvmAA6bfQI/KF/xlkjLifCh0EgRnjVEMgb4nHwdaf6tvRKuA+hyVFm4y9W8t
         Hee1JUBiB7ehwN76q/xOZmkOLc46vD20QRAaRMBUlKnIR6g/WeAxG1JJNfayMavSK8bp
         YvUcr/ulYSjHZJO52AiFhpBlFcpyLRlv/Drh+5uu4HglzOWdqIrct/6Np4o9rDSkT6/n
         UNL0VDPLEuv97UpWE3zd7KkUsqxl4EQ+3ijFzC3Mn4mfcFkTCXjryiDkkyGUgxnvyp+w
         eIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MUet1JhhQs4KY3/dY7MXiCmPNwf83GCMCfxm1tO1yU=;
        b=x72jfmKkhKgwlHubWr/srhcdIEjtPqCyKDXW+OOEH/30mDvOqSxv4zfVezZZXQm/pd
         qhhM+Aj1kXyr2y8LWYxqcw/ZJJlPEjtLDIKkR12qh7jCbKPbYcPMVL7vG4+KKIgevYKa
         xxzPnJikdHD+EzPg/cFz/0Ds6YTyG1F16M0GN/0BDith3aOowCduw1zoQKCT1ZFV8/a9
         PbBGOFFMQ73icI4GzJUc+R5T5S2munGemUfkupCyIe3VyHAuYtYmGmaAHs8fXsC8ry3C
         oLbnsbzMhPdP54eYa42F8gfpM/68gQIPk37gnpuUmoTj7rque8VxvcEn1wFhtGW+YCO8
         oQbw==
X-Gm-Message-State: AO0yUKW/yLWbqPcYqFBkFsOcjN5qVEoio9unAyz8tdOzNE5HrrU9W02l
        VAxJ+QbLYy9Fqsv4Z79TCXQ0dl9UIEYb3L7ihK665R2r
X-Google-Smtp-Source: AK7set/PvuFAgmieogvOB2Q+RpfJEnR6S0rZitaqQHUdN1plKWB3mB7rhWMEq5dYZlEZfaQYnWFwbruaHmER+K9oEhg=
X-Received: by 2002:a17:907:60cd:b0:8b1:3540:7632 with SMTP id
 hv13-20020a17090760cd00b008b135407632mr7267277ejc.2.1677538183915; Mon, 27
 Feb 2023 14:49:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675245257.git.lorenzo@kernel.org> <a72609ef4f0de7fee5376c40dbf54ad7f13bfb8d.1675245258.git.lorenzo@kernel.org>
 <e519f15d-cdd0-9362-34f3-3e6b8c8a4762@meta.com> <CAEf4BzY0sHqEXaY8no0VgwEbNoPEaQz0h53Gav=T1DCsjsjo8A@mail.gmail.com>
 <6b008033-9c97-7f46-310f-1b1ad74a8af6@meta.com>
In-Reply-To: <6b008033-9c97-7f46-310f-1b1ad74a8af6@meta.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Feb 2023 14:49:31 -0800
Message-ID: <CAEf4BzbMKVj8bEfk_VnqcKOOd51-nqYGxfCMdGQA9LkZ0GNhSA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 5/8] libbpf: add API to get XDP/XSK supported features
To:     Yonghong Song <yhs@meta.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kuba@kernel.org,
        Martin KaFai Lau <martin.lau@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 2:05=E2=80=AFPM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 2/27/23 1:01 PM, Andrii Nakryiko wrote:
> > On Mon, Feb 27, 2023 at 12:39 PM Yonghong Song <yhs@meta.com> wrote:
> >>
> >>
> >>
> >> On 2/1/23 2:24 AM, Lorenzo Bianconi wrote:
> >>> Extend bpf_xdp_query routine in order to get XDP/XSK supported featur=
es
> >>> of netdev over route netlink interface.
> >>> Extend libbpf netlink implementation in order to support netlink_gene=
ric
> >>> protocol.
> >>>
> >>> Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >>> Co-developed-by: Marek Majtyka <alardam@gmail.com>
> >>> Signed-off-by: Marek Majtyka <alardam@gmail.com>
> >>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >>> ---
> >>>    tools/lib/bpf/libbpf.h  |  3 +-
> >>>    tools/lib/bpf/netlink.c | 96 +++++++++++++++++++++++++++++++++++++=
++++
> >>>    tools/lib/bpf/nlattr.h  | 12 ++++++
> >>>    3 files changed, 110 insertions(+), 1 deletion(-)
> >>>
> >> [...]
> >>> +
> >>>    int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query=
_opts *opts)
> >>>    {
> >>>        struct libbpf_nla_req req =3D {
> >>> @@ -366,6 +433,10 @@ int bpf_xdp_query(int ifindex, int xdp_flags, st=
ruct bpf_xdp_query_opts *opts)
> >>>                .ifinfo.ifi_family =3D AF_PACKET,
> >>>        };
> >>>        struct xdp_id_md xdp_id =3D {};
> >>> +     struct xdp_features_md md =3D {
> >>> +             .ifindex =3D ifindex,
> >>> +     };
> >>> +     __u16 id;
> >>>        int err;
> >>>
> >>>        if (!OPTS_VALID(opts, bpf_xdp_query_opts))
> >>> @@ -393,6 +464,31 @@ int bpf_xdp_query(int ifindex, int xdp_flags, st=
ruct bpf_xdp_query_opts *opts)
> >>>        OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
> >>>        OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
> >>>
> >>> +     if (!OPTS_HAS(opts, feature_flags))
> >>> +             return 0;
> >>> +
> >>> +     err =3D libbpf_netlink_resolve_genl_family_id("netdev", sizeof(=
"netdev"), &id);
> >>> +     if (err < 0)
> >>> +             return libbpf_err(err);
> >>
> >> Hi, Lorenzo,
> >>
> >> Using latest libbpf repo (https://github.com/libbpf/libbpf, sync'ed fr=
om
> >> source), looks like the above change won't work if the program is
> >> running on an old kernel, e.g., 5.12 kernel.
> >>
> >> In this particular combination, in user space, bpf_xdp_query_opts does
> >> have 'feature_flags' member, so the control can reach
> >> libbpf_netlink_resolve_genl_family_id(). However, the family 'netdev'
> >> is only available in latest kernel (after this patch set). So
> >> the error will return in the above.
> >>
> >> This breaks backward compatibility since old working application won't
> >> work any more with a refresh of libbpf.
> >>
> >> I could not come up with an easy solution for this. One thing we could
> >> do is to treat 'libbpf_netlink_resolve_genl_family_id()' as a probe, s=
o
> >> return 0 if probe fails.
> >>
> >>     err =3D libbpf_netlink_resolve_genl_family_id("netdev",
> >> sizeof("netdev"), &id);
> >>     if (err < 0)
> >>          return 0;
> >>
> >> Please let me know whether my suggestion makes sense or there could be=
 a
> >> better solution.
> >>
> >
> > feature_flags is an output parameter and if the "netdev" family
> > doesn't exist then there are no feature flags to return, right?
> >
> > Is there a specific error code that's returned when such a family
> > doesn't exist? If yes, we should check for it and return 0 for
> > feature_flags. If not, we'll have to do a generic < 0 check as
> > Yonghong proposes.
>
> We can check -ENOENT.
>
>          err =3D libbpf_netlink_resolve_genl_family_id("netdev",
> sizeof("netdev"), &id);
> -       if (err < 0)
> +       if (err < 0) {
> +               if (err =3D=3D -ENOENT)
> +                       return 0;
>                  return libbpf_err(err);
> +       }
>
> Let me propose a patch for this.

we might add more options beyond feature_flags, so these early returns
are a bit error-prone, let's convert this code to if () { } else?

>
> >
> >
> >>
> >>> +
> >>> +     memset(&req, 0, sizeof(req));
> >>> +     req.nh.nlmsg_len =3D NLMSG_LENGTH(GENL_HDRLEN);
> >>> +     req.nh.nlmsg_flags =3D NLM_F_REQUEST;
> >>> +     req.nh.nlmsg_type =3D id;
> >>> +     req.gnl.cmd =3D NETDEV_CMD_DEV_GET;
> >>> +     req.gnl.version =3D 2;
> >>> +
> >>> +     err =3D nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex, sizeof=
(ifindex));
> >>> +     if (err < 0)
> >>> +             return err;
> >>> +
> >>> +     err =3D libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
> >>> +                                    parse_xdp_features, NULL, &md);
> >>> +     if (err)
> >>> +             return libbpf_err(err);
> >>> +
> >>> +     opts->feature_flags =3D md.flags;
> >>> +
> >>>        return 0;
> >>>    }
> >>>
> >> [...]
