Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F292B9FA7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgKTBYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgKTBYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:24:54 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60C3C0613CF;
        Thu, 19 Nov 2020 17:24:54 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id k65so7072767ybk.5;
        Thu, 19 Nov 2020 17:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ah40vigWvHx80/jts0mUcwQLnYYbz60G2lH32o2aBaw=;
        b=E0J43rHrIaEXkGS8qhwWEWB8yuZk88awdK3LtqxWfkbvdxNKewRnveN7caEMuVGNfu
         xdN2jyu9DDQtzTYavLBQS8EqB7J5STQIm07+dD9iF7hcmWU269aU3D2VEFsniNuXEVyW
         FT8CIBrfbH4Nct5SlSYPAAoEuhouhKVO/6mQ6evSU0nZCc0ZWaGkFadVqRz+GNXvjrOZ
         CqbPj+BuUm9DjAtqlZORFBFXCngzk0Tsn21EpI+ZdFdw3TFEu3W+cskHvB+jVdPioIyz
         87ZnOcpFVH9Y+A2uA4+v1Xyw22GYAiJ4N6pGtCa2jqitzR4dPGgyGS8j6+6DRTGFfG0I
         vqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ah40vigWvHx80/jts0mUcwQLnYYbz60G2lH32o2aBaw=;
        b=Tp7o1QKHMx3MD05WlazhtBNJP5IyV4MllpD0JyFLVeEnz9x6x+8Ec+6AulD3ZOfGE1
         AuHzq0Y/g9Nu8+Sd4T/jnvixQWlFPQ/5hDJ01ubS1vnWkzpkXNLxoMlE7j5XVUGM2Wi6
         3gwkjQHCuN9vA/cMN2Telo/XK5NVx2skNWmwyMsa0nfCBapy6tcy2+JPALBPQLaT9CAJ
         nTnUf2lP187rwO9F3dDQbTNDDWcfrxH+xfAwjNPc8wuqiTm5laQ3Zv2mpY6czilqRqeA
         4m/v91qMs9CYqXc7Vly/4kUZolhYtxZyevltsZ7cUrJy7wLVO69S//iBJzq2UqwhbsEc
         /Avg==
X-Gm-Message-State: AOAM530q8MJALBHZCKDlGfhABzhJQ+0BlO+8zr+ZZS9TKKguWzLh9VO/
        IhTSCTTkjgLOHJoUmYyHzMtCvVnwYOlcC6D3cFU=
X-Google-Smtp-Source: ABdhPJyRoTGfGY35kjVUBfmWbYO0M0PIgZGa2ZXITyAmoI2eaRZdVbNJuGmo5sRFQ761graIw/OOF/nvFv5nJrYOAPA=
X-Received: by 2002:a25:585:: with SMTP id 127mr16348632ybf.425.1605835493960;
 Thu, 19 Nov 2020 17:24:53 -0800 (PST)
MIME-Version: 1.0
References: <20201119232244.2776720-1-andrii@kernel.org> <20201119232244.2776720-5-andrii@kernel.org>
 <20201120004624.GA25728@ranger.igk.intel.com>
In-Reply-To: <20201120004624.GA25728@ranger.igk.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Nov 2020 17:24:43 -0800
Message-ID: <CAEf4BzbZihTe74R_mHU=6S0QcrXaKEFoubByP5HVRq6O-t6c-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add kernel module BTF support for
 CO-RE relocations
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 4:55 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Thu, Nov 19, 2020 at 03:22:42PM -0800, Andrii Nakryiko wrote:
> > Teach libbpf to search for candidate types for CO-RE relocations across kernel
> > modules BTFs, in addition to vmlinux BTF. If at least one candidate type is
> > found in vmlinux BTF, kernel module BTFs are not iterated. If vmlinux BTF has
> > no matching candidates, then find all kernel module BTFs and search for all
> > matching candidates across all of them.
> >
> > Kernel's support for module BTFs are inferred from the support for BTF name
> > pointer in BPF UAPI.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.c | 185 ++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 172 insertions(+), 13 deletions(-)
> >
>
> [...]
>
> > +static int probe_module_btf(void)
> > +{
> > +     static const char strs[] = "\0int";
> > +     __u32 types[] = {
> > +             /* int */
> > +             BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),
> > +     };
> > +     struct bpf_btf_info info;
> > +     __u32 len = sizeof(info);
> > +     char name[16];
> > +     int fd, err;
> > +
> > +     fd = libbpf__load_raw_btf((char *)types, sizeof(types), strs, sizeof(strs));
> > +     if (fd < 0)
> > +             return 0; /* BTF not supported at all */
> > +
> > +     len = sizeof(info);
>
> nit: reinit of len
>

oops, right, I'll remove it


> > +     memset(&info, 0, sizeof(info));
>
> use len in memset

why?

>
> > +     info.name = ptr_to_u64(name);
> > +     info.name_len = sizeof(name);
> > +
> > +     /* check that BPF_OBJ_GET_INFO_BY_FD supports specifying name pointer;
> > +      * kernel's module BTF support coincides with support for
> > +      * name/name_len fields in struct bpf_btf_info.
> > +      */
> > +     err = bpf_obj_get_info_by_fd(fd, &info, &len);
> > +     close(fd);
> > +     return !err;
> > +}
>
> [...]
