Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559FB368961
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbhDVXdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhDVXdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 19:33:32 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B664C061574;
        Thu, 22 Apr 2021 16:32:57 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id p202so9884651ybg.8;
        Thu, 22 Apr 2021 16:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUYhQZb4DbUxjuc8B4+AAWj+X4vv2BZE0tiPNRy591U=;
        b=RQNNNzmFPnewtoP/MY+sGn8LPLJW0ZjvQ+uwUtfha6l316pGtPFx9RX77uwmgoYy/H
         pMeCmgjX9lB92suKEZymtSobdu6LBm5y3LTGMi6cWGucGRTAVN9FQACgEEQsT+0kXYCc
         N7PGfym4HJJnmVzxdFG3FAW+XPmY6XIjGTjHpFC3Ebe8rBpATt2aUIWqMFdgfNapen6F
         EXWqcUisu0GxfV7Ho+dRSU/tKbyXkRmTEfrueuFtFOxAuwoQEvAuryiqPxml5Kjdi3D5
         j4VxRDPhFH402qoyOBMhA8plpHsfbSSCrVAAFYPK3ERMvP753HhqSNvVCgMl6EP+3cgo
         rc8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUYhQZb4DbUxjuc8B4+AAWj+X4vv2BZE0tiPNRy591U=;
        b=nJtx0fcrXjHrkltgZ/60wKE1/EQvDeJczfY1LTlL01QxNad2BE+8FSaMoRyxmUbm3S
         MPSxbBcPvJQYtuFnbI3yuN6zje/NDaFSD1RM0OVfDpdrhZ7Tu31LCtAfxl0HmIWRi6by
         4EI1sauH1x71sKks9VFCQwSyG8vSuieoVjak7RePbIHwb4vib55E4MB+lCGcIkuSwGo6
         XhXnNybSVL8TJj2POdjt146VJzuI3k1yK2tqX6WEuvdBMN4HFyLsRoHERsKp6ItyEYFP
         xxsA3PhJAxFfZu3F01bQiSbFUXyArIv/DigtH4EXvfnxAPMAZh2BSX5BXzGFn/Dv7pSe
         wTyg==
X-Gm-Message-State: AOAM533c7Dw91mnIghXH5FhcrwHBDl0k9/Kwn4R9Yg9odDWY2QicFXVu
        gR1udVS8rNCdc4LVSM6XW5Ec/Fy4zZtjk+KrOUQ=
X-Google-Smtp-Source: ABdhPJxQS8Zc8BSSSBUZFysgXa8+3Hmo90hhXn+7tZwrU53yUWNQPRl7KeBGUBiTSBmcNKHTWoRx4PlxXfbKkvD2lu0=
X-Received: by 2002:a25:9942:: with SMTP id n2mr1673942ybo.230.1619134376324;
 Thu, 22 Apr 2021 16:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-13-andrii@kernel.org>
 <d85c8d5a-7eaf-1d6b-afff-7fddd2083982@fb.com>
In-Reply-To: <d85c8d5a-7eaf-1d6b-afff-7fddd2083982@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 16:32:45 -0700
Message-ID: <CAEf4BzbROxCu83uAc3EHCfG8dd71Gbo_w63vE+keybbTuorOPg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 12/17] libbpf: support extern resolution for
 BTF-defined maps in .maps section
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

On Thu, Apr 22, 2021 at 3:56 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > Add extra logic to handle map externs (only BTF-defined maps are supported for
> > linking). Re-use the map parsing logic used during bpf_object__open(). Map
> > externs are currently restricted to always match complete map definition. So
> > all the specified attributes will be compared (down to pining, map_flags,
> > numa_node, etc). In the future this restriction might be relaxed with no
> > backwards compatibility issues. If any attribute is mismatched between extern
> > and actual map definition, linker will report an error, pointing out which one
> > mismatches.
> >
> > The original intent was to allow for extern to specify attributes that matters
> > (to user) to enforce. E.g., if you specify just key information and omit
> > value, then any value fits. Similarly, it should have been possible to enforce
> > map_flags, pinning, and any other possible map attribute. Unfortunately, that
> > means that multiple externs can be only partially overlapping with each other,
> > which means linker would need to combine their type definitions to end up with
> > the most restrictive and fullest map definition. This requires an extra amount
> > of BTF manipulation which at this time was deemed unnecessary and would
> > require further extending generic BTF writer APIs. So that is left for future
> > follow ups, if there will be demand for that. But the idea seems intresting
> > and useful, so I want to document it here.
> >
> > Weak definitions are also supported, but are pretty strict as well, just
> > like externs: all weak map definitions have to match exactly. In the follow up
> > patches this most probably will be relaxed, with __weak map definitions being
> > able to differ between each other (with non-weak definition always winning, of
> > course).
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> I think strict enforcement of extern/global map definitions is good.
> If library want people will use its maps, it may put the map definition
> into one of its headers and application can include and have
> exact the same definition.

In a lot of cases yes. But imagine I, as BPF library creator, started
out with just a typical hashmap definition, and then decided to add
pinning and maybe map_flags BPF_F_NO_PREALLOC. Why would that change
necessitate extern definition? But as you said, library provider can
(and should) provide extern definition that will be kept 100% in sync,
so this is not something that I urgently want to change.

>
> Acked-by: Yonghong Song <yhs@fb.com>
