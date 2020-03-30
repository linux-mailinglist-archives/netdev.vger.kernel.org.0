Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9654198551
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgC3UUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:20:30 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43401 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgC3UU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:20:29 -0400
Received: by mail-qt1-f195.google.com with SMTP id a5so16334905qtw.10;
        Mon, 30 Mar 2020 13:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vS2C3MbY5tMk0coLAQlOdtOjhk1mTuk6IBG8Gr8DWBU=;
        b=HSJGJVcL59F5VpQRAHZbc/gpuGbSahqLxE1NZUKLJPib7GT1aEHlkn8udkzJcGeDVq
         cQKWInBMDOdsCbg85UzzwvOLgiz7S/i+D8tJsCKO67iMdoqUU9mzAULp1qDk0QNwoVXK
         xu+4Z+1IQmnWYOwWKzfowAsdHsnms/MGNUsJum8L0wxMi6ApQRT6PLkmVw5GuBzJyg83
         P+ThkTyKwdQsE2DjO0r5sd4Kv9y45YaVRtLUIRLDDhsRe1mFzK8u+8nR1ifEzhhF1Jd6
         5oppm4te42QNe42OjntciHFHSOGitQMhQ85wrFxKTNjUH1IuEN77fLIUOKCkak0DgUbW
         haBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vS2C3MbY5tMk0coLAQlOdtOjhk1mTuk6IBG8Gr8DWBU=;
        b=qRswa27JtTjSSeYcLF9zQAMsX2NBpbZaN2G5rFnEH9raeSjMZiHqwkuZeabxinx1x3
         SrD5KevKoxLX/gBtJCESVA8ectEnZ4F/bOOhHX5nfa/7mEYoQa/QXV02dOnH/ilwZVRg
         TdE4zyXd6KxVBCu0kLOofZkKqk/XedUbkKb+k+7vLpRp6A0ndKwVxQCCG2heKSe0SEGc
         lBTZvlEkXYSLq49k/Dv8m7ijQRm0L2I5NYF7uZpFW8PDkqFlfq7QYsnp9HvVZB0DLTRQ
         QlSbZBvb78aCcMiglLXeWemBy79uIIYdlPE5e0b26Lz4zgFThylAlk7nG13TiaBtvOys
         heCg==
X-Gm-Message-State: ANhLgQ1j2iaUgFqccd69X+U9MeagF4dABuVFKOd7arqFu74DBY1JsOL1
        R5yEV/T2BuCmPmi28eq6PBw+/nWZZ3WecBNEq0M=
X-Google-Smtp-Source: ADFU+vvZuzalQTFfonTq766RruJ8S/gNv9FtULqafPMengPxELONNU0tSm/ZBJEWp5r3x4DCBBnzuO5r54/bkkUnnZo=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr1793630qtk.171.1585599628158;
 Mon, 30 Mar 2020 13:20:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
In-Reply-To: <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Mar 2020 13:20:17 -0700
Message-ID: <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 7:49 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/29/20 8:59 PM, Andrii Nakryiko wrote:
> > bpf_link abstraction itself was formalized in [0] with justifications for why
> > its semantics is a good fit for attaching BPF programs of various types. This
> > patch set adds bpf_link-based BPF program attachment mechanism for cgroup BPF
> > programs.
> >
> > Cgroup BPF link is semantically compatible with current BPF_F_ALLOW_MULTI
> > semantics of attaching cgroup BPF programs directly. Thus cgroup bpf_link can
> > co-exist with legacy BPF program multi-attachment.
> >
> > bpf_link is destroyed and automatically detached when the last open FD holding
> > the reference to bpf_link is closed. This means that by default, when the
> > process that created bpf_link exits, attached BPF program will be
> > automatically detached due to bpf_link's clean up code. Cgroup bpf_link, like
> > any other bpf_link, can be pinned in BPF FS and by those means survive the
> > exit of process that created the link. This is useful in many scenarios to
> > provide long-living BPF program attachments. Pinning also means that there
> > could be many owners of bpf_link through independent FDs.
> >
> > Additionally, auto-detachmet of cgroup bpf_link is implemented. When cgroup is
> > dying it will automatically detach all active bpf_links. This ensures that
> > cgroup clean up is not delayed due to active bpf_link even despite no chance
> > for any BPF program to be run for a given cgroup. In that sense it's similar
> > to existing behavior of dropping refcnt of attached bpf_prog. But in the case
> > of bpf_link, bpf_link is not destroyed and is still available to user as long
> > as at least one active FD is still open (or if it's pinned in BPF FS).
> >
> > There are two main cgroup-specific differences between bpf_link-based and
> > direct bpf_prog-based attachment.
> >
> > First, as opposed to direct bpf_prog attachment, cgroup itself doesn't "own"
> > bpf_link, which makes it possible to auto-clean up attached bpf_link when user
> > process abruptly exits without explicitly detaching BPF program. This makes
> > for a safe default behavior proven in BPF tracing program types. But bpf_link
> > doesn't bump cgroup->bpf.refcnt as well and because of that doesn't prevent
> > cgroup from cleaning up its BPF state.
> >
> > Second, only owners of bpf_link (those who created bpf_link in the first place
> > or obtained a new FD by opening bpf_link from BPF FS) can detach and/or update
> > it. This makes sure that no other process can accidentally remove/replace BPF
> > program.
> >
> > This patch set also implements LINK_UPDATE sub-command, which allows to
> > replace bpf_link's underlying bpf_prog, similarly to BPF_F_REPLACE flag
> > behavior for direct bpf_prog cgroup attachment. Similarly to LINK_CREATE, it
> > is supposed to be generic command for different types of bpf_links.
> >
>
> The observability piece should go in the same release as the feature.

You mean LINK_QUERY command I mentioned before? Yes, I'm working on
adding it next, regardless if this patch set goes in right now or
later.
