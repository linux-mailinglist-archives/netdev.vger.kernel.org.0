Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF4327DE8B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 04:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgI3CeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 22:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729470AbgI3CeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 22:34:17 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D2CC061755;
        Tue, 29 Sep 2020 19:34:17 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id j19so6713pjl.4;
        Tue, 29 Sep 2020 19:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JM+btoJd7ENQh4x4CzX1uA1slT1szaC5YkRVd2dg3Es=;
        b=SO4Khj6/BDZIh/7LEoVTd6EkhaMtqvLON0xorSdzNY9nq7XzUQJRBa9Jm9OgfJMPS0
         zeVVnwqQK/0vh0KCt/vlPyAKM+lfE3rJyrKCB3961Zoddxq4/QeATinU0GYtHMoRbWFg
         CCsC9PH1FryMFBpWAwUfSrmuZz/4AA8WeMW3FEE++mjoANxedr4KyBWc9Bu/sY1NeVhW
         owPqJnVo1ZIuFpfiqC2iLzErcu2tZpl9kjy6cgdxYEt3wd3qN8ecmu+YnePDibNFnOFX
         eaPXUvCOZyeZGTg5gDEusLaFn9Q2gVi3tqCuc71FdafOjZWQzsOjOFoMdzZ3DC7GWKGS
         9aDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JM+btoJd7ENQh4x4CzX1uA1slT1szaC5YkRVd2dg3Es=;
        b=JqpMiv5YvtSYRS/EXEjO+pMiNj/1oPQR8BGCFXG6O3JUk4whXMoWIJBFK6CdBcNfqg
         NyThbPdpVTWn+cxSCeZUmbZcN/pKHPaY+vFe6oy9Vo5ilYL4LcmBur+V2uxe1f/z41fo
         DRk3p0K8qygD6+n93zLA1sVpGzT/JnboS0QF8fCZVsMXZ43hheXjd4WwQZ9rUBOVWlv5
         H/OQr8A3vevsT5pDj8Ediy/PLAVuGkzsQy73aPI6bDtzwaKmtomgLyqHHxGWqtjgO7N6
         TbZIBFeTavbj8Z+6MVWEzShrNwAeEVfcRv1bAasjspyES7wFqd1UOQPUanKHAZKZV5fA
         7Scw==
X-Gm-Message-State: AOAM533PT70I6Xerld9zdppAfxQjnAR1DuYT8zm+aIz9sPiJhVTm4lP7
        W2TVrxzuKfqt2DoHHtQ2LBQ=
X-Google-Smtp-Source: ABdhPJzpJ5Q2HjoE/Kc+RcEhJK3mNCefvCyz06Qjau3VuFYQl3Pt6cikw7axJ2TrWM++WNQRyRnr0w==
X-Received: by 2002:a17:90b:3852:: with SMTP id nl18mr519796pjb.78.1601433257140;
        Tue, 29 Sep 2020 19:34:17 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w206sm112290pfc.1.2020.09.29.19.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 19:34:16 -0700 (PDT)
Date:   Wed, 30 Sep 2020 10:34:05 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: export bpf_object__reuse_map() to
 libbpf api
Message-ID: <20200930023405.GH2531@dhcp-12-153.nay.redhat.com>
References: <20200929031845.751054-1-liuhangbin@gmail.com>
 <CAEf4BzYKtPgSxKqduax1mW1WfVXKuCEpbGKRFvXv7yNUmUm_=A@mail.gmail.com>
 <20200929094232.GG2531@dhcp-12-153.nay.redhat.com>
 <CAEf4BzZy9=x0neCOdat-CWO4nM3QYgWOKaZpN31Ce5Uz9m_qfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZy9=x0neCOdat-CWO4nM3QYgWOKaZpN31Ce5Uz9m_qfg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 04:03:45PM -0700, Andrii Nakryiko wrote:
> > bpf_map__set_pin_path()
> > bpf_create_map_in_map()    <- create inner or outer map
> > bpf_map__reuse_fd(map, inner/outer_fd)
> > bpf_object__load(obj)
> >   - bpf_object__load_xattr()
> >     - bpf_object__create_maps()
> >       - if (map->fd >= 0)
> >           continue      <- this will skip pinning map
> 
> so maybe that's the part that needs to be fixed?..

Hmm...maybe, let me see

> 
> I'm still not sure. And to be honest your examples are still a bit too
> succinct for me to follow where the problem is exactly. Can you please
> elaborate a bit more?

Let's take iproute2 legacy map for example, if it's a map-in-map type with
pin path defined. In user space we could do like:

if (bpf_obj_get(pathname) < 0) {
	bpf_create_map_in_map();
	bpf_map__reuse_fd(map, map_fd);
}
bpf_map__set_pin_path(map, pathname);
bpf_object__load(obj)

So in libbpf we need

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 32dc444224d8..5412aa7169db 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4215,7 +4215,7 @@ bpf_object__create_maps(struct bpf_object *obj)
                if (map->fd >= 0) {
                        pr_debug("map '%s': skipping creation (preset fd=%d)\n",
                                 map->name, map->fd);
-                       continue;
+                       goto check_pin_path;
                }

                err = bpf_object__create_map(obj, map);
@@ -4258,6 +4258,7 @@ bpf_object__create_maps(struct bpf_object *obj)
                        map->init_slots_sz = 0;
                }

+check_pin_path:
                if (map->pin_path && !map->pinned) {
                        err = bpf_map__pin(map, NULL);
                        if (err) {


Do you think if this change be better?

Thanks
Hangbin
