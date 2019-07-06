Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7255760EA3
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 05:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfGFDsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 23:48:18 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46482 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGFDsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 23:48:18 -0400
Received: by mail-qk1-f194.google.com with SMTP id r4so9260150qkm.13;
        Fri, 05 Jul 2019 20:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DabwQXrOf2oSk9o/xQ+gP0B0AlkbZlu7q/sdN31xjis=;
        b=tnIbbYNqlUiXOkoJVIp5L+zugiOMBUOEu0BTZAJgKSL0HKHYyfH4e+XhiQW87JpFZ1
         rSCUw8tITMM+lPoMOpAm84s3SQ+kh8ibqTa0EOAkmCgMj9yp+o7lSO6HpcI4EiWa0bK1
         DI76jtbJ6NG6+JOCNCbfT2yrlmA9e1Rloyn+fukP6+6ovCYFsDSJbCqHg1I4XWP+3XwV
         dpigiKv2uoE6hlwMies0sRx5POOeCj7+JZTpLJSkFGumjRwjKzqBYeC4r42mVasZ6Nx4
         01ar2V0nG3OH1kGT5FM6Ee4qlst3S9ImLAeiFHnhfOjuCfI47Pq5EZYGz9cmv5ZfAq24
         fFMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DabwQXrOf2oSk9o/xQ+gP0B0AlkbZlu7q/sdN31xjis=;
        b=eAoYk9LhnIhqVBI0HjfJ24JaZ+AclRftNs8VlLFEOgtKaqzxH3iB+x9skDNg/+ixVp
         pAqHR8baPVGkgSeD50Wsu8k4cibREoY7ZZFljcR1zEdo1lLk6m4QR2jYDGENvP21UUxj
         NonmvskGI+p3KS3O33T7Meez9n23/Qi5baax6iSDQFaG3AUZd5lZFdNkpi2l4MWMq7FV
         Jk1Hnj1K90SuLk0UlrBQcmsMx1GS3Pi8L1qK/K+jQRlCOaYq4byG8j0/ew9fbudWQQZj
         HNSYdO1nR5x5sW3n97PCPtFVyXsJHuGPR69GqSEsf1AjSTV6AJ0D9XKFpiyho4yR/+Fk
         1lOQ==
X-Gm-Message-State: APjAAAWyfARYPzWHf4Ky+PnZbWfi7Fim/xXA82jiiStN4AqUI7iSfL1B
        Iq4exy9v5FGM8pbgRAijuTnSI9zvcLVCYWIuOeM=
X-Google-Smtp-Source: APXvYqy6TGGzqdcimhRpL+3xenOZdA7OvWjYYF7BhSMgL+gE6SBVVOohWE8w/Rnx1EN/6ckxfOf3ZrStlYvawlbG6W4=
X-Received: by 2002:a37:660d:: with SMTP id a13mr5809103qkc.36.1562384897466;
 Fri, 05 Jul 2019 20:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190701235903.660141-1-andriin@fb.com> <20190701235903.660141-5-andriin@fb.com>
 <5e494d84-5db9-3d57-ccb3-c619cbae7833@iogearbox.net> <CAEf4BzaHM5432VS-1wDxKJXr7U-9zkM+A_XsU+1p77YCd8VRgg@mail.gmail.com>
 <CAEf4BzaUeLDgwzBc0EbXnzahe8wxf9CNVFa_isgRp8rwJ0OSjQ@mail.gmail.com> <a24b3328-2d4a-17f2-3aa3-756af7432e6b@iogearbox.net>
In-Reply-To: <a24b3328-2d4a-17f2-3aa3-756af7432e6b@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Jul 2019 20:48:05 -0700
Message-ID: <CAEf4BzYxqrFSYi-o-510g8tsz76Zc-OBdwSfeZS8tjR+=mJOYQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 1:46 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 07/04/2019 02:57 AM, Andrii Nakryiko wrote:
> > On Wed, Jul 3, 2019 at 9:47 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> [...]
> >>   [1] https://lore.kernel.org/bpf/20190621045555.4152743-4-andriin@fb.com/T/#m6cfc141e7b57970bc948134bf671a46972b95134
> >>
> >>> with bpf_link with destructor looks good to me, but my feedback from back then was
> >>> that all the kprobe/uprobe/tracepoint/raw_tracepoint should be split API-wise, so
> >>> you'll end up with something like the below, that is, 1) a set of functions that
> >>> only /create/ the bpf_link handle /once/, and 2) a helper that allows /attaching/
> >>> progs to one or multiple bpf_links. The set of APIs would look like:
> >>>
> >>> struct bpf_link *bpf_link__create_kprobe(bool retprobe, const char *func_name);
> >>> struct bpf_link *bpf_link__create_uprobe(bool retprobe, pid_t pid,
> >>>                                          const char *binary_path,
> >>>                                          size_t func_offset);
> >>> int bpf_program__attach_to_link(struct bpf_link *link, struct bpf_program *prog);
> >>> int bpf_link__destroy(struct bpf_link *link);
> >>>
> >>> This seems much more natural to me. Right now you sort of do both in one single API.
> >>
> >> It felt that way for me as well, until I implemented it and used it in
> >> selftests. And then it felt unnecessarily verbose without giving any
> >> benefit. I still have a local patchset with that change, I can post it
> >> as RFC, if you don't trust my judgement. Please let me know.
> >>
> >>> Detangling the bpf_program__attach_{uprobe,kprobe}() would also avoid that you have
> >>> to redo all the perf_event_open_probe() work over and over in order to get the pfd
> >
> > So re-reading this again, I wonder if you meant that with separate
> > bpf_link (or rather bpf_hook in that case) creation and attachment
> > operations, one would be able to create single bpf_hook for same
> > kprobe and then attach multiple BPF programs to that single pfd
> > representing that specific probe.
> >
> > If that's how I should have read it, I agree that it probably would be
> > possible for some types of hooks, but not for every type of hook. But
> > furthermore, how often in practice same application attaches many
> > different BPF programs to the same hook? And it's also hard to imagine
> > that hook creation (i.e., creating such FD for BPF hook), would ever
> > be a bottleneck.
> >
> > So I still think it's not a strong reason to go with API that's harder
> > to use for typical use cases just because of hypothetical benefits in
> > some extreme cases.
>
> Was thinking along that lines, yes, as we run over an array of BPF progs,
> but I just double checked the kernel code again and the relationship of
> a BPF prog to perf_event is really just 1:1, just that the backing tp_event
> (trace_event_call) contains the shared array. Given that, all makes sense
> and there is no point in splitting. Therefore, applied, thanks!

Great, thanks a lot!
