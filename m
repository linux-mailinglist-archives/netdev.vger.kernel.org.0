Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3793D3CCF
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbhGWPLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbhGWPLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:11:11 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C931EC061575;
        Fri, 23 Jul 2021 08:51:43 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id f26so3029855ybj.5;
        Fri, 23 Jul 2021 08:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vGxm0m2zr2iL2AsZWqmBCKIVJzF2ol8DfG9XrOwNFNo=;
        b=ZHbRBjU1IU1/PjcekQLq6qji7InSIp6EgJ2cCQxX7ZF0X7Y38Jk/PN8eOIahU6stut
         nQLCWNHcwjkENQ0K4VW4NQGkiBXH+vEbMJkLX03YyOCh4jQvQ0rVr/v1Yg9V8h6Uv2Oh
         yWOrg/v7uTIoJPZ43842v59LFvgbo7b9w8+ZTzTSu1vlejAB082ZUh7UfJimxJ2zRCBd
         LWdPL3TPv/lyVwKmTxVDB9SIBiG2c5F4x4FWw3RE9uHn90gYuD4RRXC12aMlZr8jUaFH
         lI9LCyXyIPGS6Ke6/EGYm99ncO63w9BfTo+WaibdhfhC/1vzFYImRggPGPODKandOlRg
         8Iaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vGxm0m2zr2iL2AsZWqmBCKIVJzF2ol8DfG9XrOwNFNo=;
        b=Le8UKwXOEDViUf0/3Ff73tyvUqLjnrEMFBo841efSKyztK6Trk6xiAj4Uu4eGi8VHm
         yCNvsPvZrzYGZw3JibTOTGtzl7lC31+xpzqnrg8mHaeiMWs6lkWs45geaCgQhUT049TI
         yzcMquirLXOWgK4UkbmaCoUDXugWG3dB1olmqh0iNo/gzFeCFqjrJl8dVKEMQqLlGyz7
         5uKinVnUs9GIWfz0A9bm3W5HymcFER49+V44Z7JQySM3cVqZxfF31kS4f9ggixGwT6gg
         YdmCsQjVJe8AV4x+/PQyabzefblvDJQcf+0Pl96AbzoLjj2ZANgP24/9PNKl/E/81HFa
         mebg==
X-Gm-Message-State: AOAM5323Bni9IwfDZTm6aoAVbhgPyH8A4ArWXQMbtHcRQSidnOdh5Daf
        Sn/B6rcNP4zWOYCBeud4h6HGowRDOmcf2ruAfTU=
X-Google-Smtp-Source: ABdhPJxzNnXSk5H00e7g6d6WpRaC5Oe/BSqnLiFgbzA2BqCv4rYhnE3e8WpvH3DbTAaEON+jjI+OiiD9g02UKNvRDxY=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr6958546ybf.425.1627055503113;
 Fri, 23 Jul 2021 08:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <CAEf4Bzb30BNeLgio52OrxHk2VWfKitnbNUnO0sAXZTA94bYfmg@mail.gmail.com>
 <CAEf4BzZZXx28w1y_6xfsue91c_7whvHzMhKvbSnsQRU4yA+RwA@mail.gmail.com> <82e61e60-e2e9-f42d-8e49-bbe416b7513d@isovalent.com>
In-Reply-To: <82e61e60-e2e9-f42d-8e49-bbe416b7513d@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Jul 2021 08:51:32 -0700
Message-ID: <CAEf4BzYpCr=Vdfc3moaapQqBxYV3SKfD72s0F=FAh_zLzSqxqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/5] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 2:58 AM Quentin Monnet <quentin@isovalent.com> wrot=
e:
>
> 2021-07-22 19:45 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Thu, Jul 22, 2021 at 5:58 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com>=
 wrote:
> >>>
> >>> As part of the effort to move towards a v1.0 for libbpf [0], this set
> >>> improves some confusing function names related to BTF loading from an=
d to
> >>> the kernel:
> >>>
> >>> - btf__load() becomes btf__load_into_kernel().
> >>> - btf__get_from_id becomes btf__load_from_kernel_by_id().
> >>> - A new version btf__load_from_kernel_by_id_split() extends the forme=
r to
> >>>   add support for split BTF.
> >>>
> >>> The old functions are not removed or marked as deprecated yet, there
> >>> should be in a future libbpf version.
> >>
> >> Oh, and I was thinking about this whole deprecation having to be done
> >> in two steps. It's super annoying to keep track of that. Ideally, we'd
> >> have some macro that can mark API deprecated "in the future", when
> >> actual libbpf version is >=3D to defined version. So something like
> >> this:
> >>
> >> LIBBPF_DEPRECATED_AFTER(V(0,5), "API that will be marked deprecated in=
 v0.6")
> >
> > Better:
> >
> > LIBBPF_DEPRECATED_SINCE(0, 6, "API that will be marked deprecated in v0=
.6")
>
> I was considering a very advanced feature called =E2=80=9Copening a new G=
itHub

Someone gotta track and ping people at the right time even with
issues, so yeah, it's suboptimal.

> issue=E2=80=9D to track this :). But the macro game sounds interesting, I=
'll
> look into it for next version.
>
> One nit with LIBBPF_DEPRECATED_SINCE() is that the warning mentions a
> version (here v0.6) that we are unsure will exist (say we jump from v0.5
> to v1.0). But I don't suppose that's a real issue.

There will always be a +0.1 version just to get deprecation activated.
This is for the reason I explained: we add replacement API in 0.X, but
can mark deprecated API in 0.(X+1), so we won't skip it, even if we
have to wait 2 extra months before 1.0. So I wouldn't worry about
this.

>
> Thanks for the feedback!
> Quentin
