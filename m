Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA2339B46
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhCMCdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbhCMCdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 21:33:14 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED58BC061574;
        Fri, 12 Mar 2021 18:33:13 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id u3so27370365ybk.6;
        Fri, 12 Mar 2021 18:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhCFhzbiKA2mlAUj4Ovu5/MkFXN1mMvRNkUzf2/XxUc=;
        b=CztLwOEOVFlFwk9qn8RKcouRdGHbLE/7ydkyGqDM9Bqtw2s8uUmDVIqCqkzcsYinON
         lNiziQO56mB8lUvRXlnYx1llPePefMhlz4xYcQ6X94vyc+RdmyuWbvztda7qLL8nkA2c
         NAuy9WwG2lIrvHMVtsrPFLzRZlDQhE8axzIZUWS3y84/KzwC9Fpzp5D1xqZKab/P910U
         ilR8RGdwOpynwqMOjknOGjIKsEG9GqMKdQ86UHay8yu3lziNgmwFYQxRJI/0G7pRU8bi
         GwBE8qXMfu48vF17nCTSoJpK97mcVjpPNQDWuKD+22IAOMwJU/+FLDGJf5EjIY1KJmeQ
         IDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hhCFhzbiKA2mlAUj4Ovu5/MkFXN1mMvRNkUzf2/XxUc=;
        b=QfgBZsoWim+navgjHxM5U0aIX71eQVUECH+lQESJwGJ3O3XfTNVkEmZkNowgRrX5Nc
         fg+D2iBP/WlwoxD6OT75gb0mwCLyt4UQ6OXPZY8MO0r+zrjbunF8lQDn94AE5eEoRbfa
         4HCvb1U7Xr7eeS9H65h5CSXjqCES9WeiZO/Jvcrst2koyH2wJU81gSPJL8Hy/DJ1Rkmq
         lcoPWiFBJ+3ZeJaYYtlXbTSNLl2VGF62BieW9yA6XwxvQQmExmixFTCWdQWp+RDaZ8zs
         tmDFdSC22+aJTYuFhWusGuE5Y5orrpLjSqaUjSoKLDLGsloQyG228u6r6MeI2Ym6pW5s
         Ay7Q==
X-Gm-Message-State: AOAM530vxUljlKbVMoHumw2oNMy2yXZCKCZgM0GxCZ8jGOh+TJm/Im+Z
        ePxb1vjEyz4HyTPjhs9evbdyurQggip+Ruw8IiY=
X-Google-Smtp-Source: ABdhPJyng4dFKMH7ok4h7Kk/HxuGSp39pBIRK4g6fDS032zCLQotmol35wJMQPSmN9xpRfKXf5fxTe3fAGF9Zcc3hUY=
X-Received: by 2002:a25:874c:: with SMTP id e12mr22073648ybn.403.1615602792435;
 Fri, 12 Mar 2021 18:33:12 -0800 (PST)
MIME-Version: 1.0
References: <20210312214316.132993-1-sultan@kerneltoast.com>
 <CAEf4BzYBj254AtZxjMKdJ_yoP9Exvjuyotc8XZ7AUCLFG9iHLQ@mail.gmail.com> <YEwh2S3n8Ufgyovr@sultan-box.localdomain>
In-Reply-To: <YEwh2S3n8Ufgyovr@sultan-box.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Mar 2021 18:33:01 -0800
Message-ID: <CAEf4BzaSyg8XjT2SrwW+b+b+r571FuseziV6PniMv+b7pwgW5A@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Use the correct fd when attaching to perf events
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 6:22 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
>
> On Fri, Mar 12, 2021 at 05:31:14PM -0800, Andrii Nakryiko wrote:
> > On Fri, Mar 12, 2021 at 1:43 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
> > >
> > > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > >
> > > We should be using the program fd here, not the perf event fd.
> >
> > Why? Can you elaborate on what issue you ran into with the current code?
>
> bpf_link__pin() would fail with -EINVAL when using tracepoints, kprobes, or
> uprobes. The failure would happen inside the kernel, in bpf_link_get_from_fd()
> right here:
>         if (f.file->f_op != &bpf_link_fops) {
>                 fdput(f);
>                 return ERR_PTR(-EINVAL);
>         }

kprobe/tracepoint/perf_event attachments behave like bpf_link (so
libbpf uses user-space high-level bpf_link APIs for it), but they are
not bpf_link-based in the kernel. So bpf_link__pin() won't work for
such types of programs until we actually have bpf_link-backed
attachment support in the kernel itself. I never got to implementing
this because we already had auto-detachment properties from perf_event
FD itself. But it would be nice to have that done as a real bpf_link
in the kernel (with all the observability, program update,
force-detach support).

Looking for volunteers to make this happen ;)


>
> Since bpf wasn't looking for the perf event fd, I swapped it for the program fd
> and bpf_link__pin() worked.

But you were pinning the BPF program, not a BPF link. Which is not
what should have happen.

>
> Sultan
