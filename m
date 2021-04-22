Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98690368673
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbhDVSTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVSS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:18:57 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79EDC06174A;
        Thu, 22 Apr 2021 11:18:22 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id k73so46273535ybf.3;
        Thu, 22 Apr 2021 11:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tsP9Fom+CqbpV7TUqyr2PSI3ihbLHY5H7ckst9PCxsQ=;
        b=gHFkGEbxVaJb24O2OVUeDZPFHQB3laRCSb1hFvYzfo5c4KEM8lqePXTgLLToyqsP50
         tOaJ3nARl3PsEGe+JVttCAko16cZNpVNmND6v/D2Q2VCOaxRy6gAHq63zYusV450uV8c
         kp0giqNm43pQBNYzMaC9YIqWAfZA8aexAOJ354itqaylfxLko22/PaRln4awEudGpj55
         LarzA33SJpbIchnzqlLx7jK41IQmldF8KIyfa9/OCQEfqgCZTIwGObSj624dIeWnUmvx
         0KHZrBdp6PzqAuD9qhu6R/Sc0qIbgqQD5tllVPbJBBk6menUFlFQLrCJL3Y0Ap6ZVfjr
         jp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tsP9Fom+CqbpV7TUqyr2PSI3ihbLHY5H7ckst9PCxsQ=;
        b=N2ON2u1JShGszH9VOvpn/k8VwYDZM+CY2sYuPJon6ANkIX+a6FE/C1qzZaXUSxuf2v
         ZBq1RNdLkwJ+aCHLVMkyxJEEm6Lz1e4NM9s60Nc1HvqHFmnxresZ5J5bb2RTF5nF9Daj
         b51nVhiw6y05ohCrt+AkdAb7kSar0suPjo0mcOdTqvSq4RWK+3qbb32H0pdQMPkCKEMt
         4SczsK1kzEGIk4bdn32l/xVnZUN5zSotc868znqmUJKRB8dymwOg4uRP/ggzBaupT/MO
         hHC5/1BgUqYW7CAIDmjc19UXXor88FRUhvsFWIKvswE/rMh6XPkwyy2xWR93eLVyCsN0
         O+CA==
X-Gm-Message-State: AOAM530QjijnahMJO/yz8o2UOluLcapAPZmLGmCd3OmN6gpDBQeizIFd
        BMzhk9GPTqD64PXHGR5K4zveGcW0yWG3fO7sqNk=
X-Google-Smtp-Source: ABdhPJzHAWt+j1y1bH/O29WnPAsyJhhXnfEnX1Y6dSUjkFrduIjkvHP+NEII6LG+AH0C6cMAuWTM3Je9dpdjHRhisTk=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr6447397ybf.425.1619115502303;
 Thu, 22 Apr 2021 11:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-9-andrii@kernel.org>
 <e0ef3df5-6a29-843f-6a4c-b41c27aee720@fb.com>
In-Reply-To: <e0ef3df5-6a29-843f-6a4c-b41c27aee720@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 11:18:11 -0700
Message-ID: <CAEf4BzY69Mm4Sz85cRXJTReKba6BDD5NrSGnEkisAYsaaodCuw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 08/17] libbpf: make few internal helpers
 available outside of libbpf.c
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 9:19 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > Make skip_mods_and_typedefs(), btf_kind_str(), and btf_func_linkage() helpers
> > available outside of libbpf.c, to be used by static linker code.
> >
> > Also do few cleanups (error code fixes, comment clean up, etc) that don't
> > deserve their own commit.
>
> In general, a separate commit will be good. In this case, we already
> have quite some commits in the patch set. So it should be okay
> to add some minor cleanups here.
>

Yeah, that and it always feels like those minor clean ups that you
only ever discover as you work on some bigger feature would be a waste
of everyone's time, if submitted as individual patches.

> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Acked-by: Yonghong Song <yhs@fb.com>
