Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E511BCADA
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbgD1Sw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730357AbgD1SgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 14:36:11 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71670C03C1AB;
        Tue, 28 Apr 2020 11:36:11 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 23so17990922qkf.0;
        Tue, 28 Apr 2020 11:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ye8oRp8nY6XL0iCqRfZxx53RkmGrqoGXsu0NWeMV+aw=;
        b=Aq61hdD/dS9jdmRCEXKTi2qL885T5WsrEk2jCIN6SfdxbbTl92gXMJw1/g4wS2drSM
         02Fb0WXzeFeJZZhFJbvFAaD2PO+LlQ6kmjrf0CRocEZ0hT9s8n1pFab8EsPVIjHAPia6
         zcENCMmivcsZw8LYijSz1yflV+jNT8C6+D8sZCm45D7QpBqu6yy6/0D5ptsCp4jBNrNk
         si2IrA2Y6jZ98o2DYVEYt7fjseu+FjPUA4E8jcsC4kn1myAeWcSaHRhct+DFTQ1qJfYq
         EAQ5Qz/uhGl1cCg8soeMY1dgnKCIzEpXZkwH4fvitGtPtLtdIllj50S69X5UwvI9E3AU
         fy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ye8oRp8nY6XL0iCqRfZxx53RkmGrqoGXsu0NWeMV+aw=;
        b=qfEvcIKCVPeEyN4Uqs+1D6QtDfYggRab+KlHLixKdET9C5C8wTv8iETWs5TgJnypTC
         XUt0RhD4OTE4vI2t2ly0u7jsz6Mbd3qCh5tqv/eS2rZ/q81ybBbT4vAjSLusRlUlSbmn
         HZsBytzNv8sURh0cf7wrSvkXLRxXktHwVBWzegMbzFQgTUo60CnLAXWWpFBkaaD10phR
         MEx+48RbZHKSZOkbdnRLHuXmjKu5IPUChLuAPDkpHL/goiSvwtEhd7nMdQ9Yu9L2aePA
         yAV4a1zHU2HyC9OaiTA7B5k21RiNmiwlODPA+8pbmQif7bnyK8+zOXUcEKMg1yngpvZT
         rjLw==
X-Gm-Message-State: AGi0PuaWhgaf83zjESAWn5eVZzqkYPqKh8hxd4Fet4X624psGmXe2+nS
        AQrdsfUundnIZtvxxGHBDqZ1nq2QboJJTazIjU0=
X-Google-Smtp-Source: APiQypLhAPIhj7Pf33hJ8bphiWoIOxhiKTgNrOF4DV9IcTow3nK3/6gVQwQRpEs/V+HILAzwaq8ZXhFFFiSEb8qZSiU=
X-Received: by 2002:a37:787:: with SMTP id 129mr28678669qkh.92.1588098970657;
 Tue, 28 Apr 2020 11:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200428064140.122796-1-andriin@fb.com> <20200428064140.122796-4-andriin@fb.com>
 <20200428180336.b26olfmjb7ntipvb@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200428180336.b26olfmjb7ntipvb@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 11:35:59 -0700
Message-ID: <CAEf4BzaZvVCfk3Enhak4C4LFvHSBCPCkZNUUBtrOp-NnGSAj0A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/3] libbpf: add BTF-defined map-in-map support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:03 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 27, 2020 at 11:41:39PM -0700, Andrii Nakryiko wrote:
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 60aad054eea1..e3a6e9a1f5b4 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -12,6 +12,7 @@
> >
> >  #define __uint(name, val) int (*name)[val]
> >  #define __type(name, val) typeof(val) *name
> > +#define __inner(name, val) typeof(val) *name[]
> ...
> > +++ b/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
> > @@ -0,0 +1,76 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* Copyright (c) 2020 Facebook */
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +struct inner_map {
> > +     __uint(type, BPF_MAP_TYPE_ARRAY);
> > +     __uint(max_entries, 1);
> > +     __type(key, int);
> > +     __type(value, int);
> > +} inner_map1 SEC(".maps"),
> > +  inner_map2 SEC(".maps");
> > +
> > +struct outer_arr {
> > +     __uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
> > +     __uint(max_entries, 3);
> > +     __uint(key_size, sizeof(int));
> > +     __uint(value_size, sizeof(int));
> > +     /* it's possible to use anonymous struct as inner map definition here */
> > +     __inner(values, struct {
> > +             __uint(type, BPF_MAP_TYPE_ARRAY);
> > +             /* changing max_entries to 2 will fail during load
> > +              * due to incompatibility with inner_map definition */
> > +             __uint(max_entries, 1);
> > +             __type(key, int);
> > +             __type(value, int);
> > +     });
>
> How about renaming it s/__inner/__array/ ?
> Because that's what it defines from BTF pov.

Sounds good, will update.
