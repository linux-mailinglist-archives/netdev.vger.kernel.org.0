Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF1FD1C85
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbfJIXLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:11:22 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40607 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731542AbfJIXLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 19:11:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id y144so3840248qkb.7;
        Wed, 09 Oct 2019 16:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfYatyWZ6OuNj0Lfpjj++knmMhqGPfA3zINCAn34Cl0=;
        b=NqFSwAsij2oUUEpx2RukeuBRPoLXqsjyliC2emrCsXZ7ejOCYEoN5W8UrsSOeInYI5
         kDLc793rYkFH4vdzmIeOlqaPA3Mhvi1/VZNLeC7tZnTeaIpA8HFAtV5fXq1Jb9CEZ3+5
         o1DT8hB+66GvOKISF4xNOoNKBcer2I31Am0AyjcIyTKwybex5cYIO7fm1RWL7yq37Wbl
         is8lU6C9FfUErrAL+drIRzNBdyhkE8L8knBUL2t/uHGC2d1ofahrenWRDXLFBkXGZRVO
         NQl7gEXqsBxNCjOImh0e8N7fmtZCQC+qnupWilp1oghCsvjMpN+z+uY2xfgr/X5hwqLA
         aOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OfYatyWZ6OuNj0Lfpjj++knmMhqGPfA3zINCAn34Cl0=;
        b=SagXqsXUUbp/KCT6RuONqAJhmKG4wQ0t/6+YoyAvRcmpY2xwtQMlFoH5YVhcXkVPJ9
         /K3YYY8RaM0uiGyJ8visUHoDsq7npONY/Y/cHQz3+Rd304XoXDYZoNb610ylz4Pw/KSh
         WOxyp0wwn3vni7wbIo4dPF+PUjrFSGBTyt4QIrM72HTH40UBaooqva1lnExA5wxJ9008
         8MRnfmqNP+WmATsB1hJwDuIwy6cXtb302L/i6LfLzJYBn//jTGNvSV4c1/04IjboDlqs
         0mwGH/3ELhRBbR14S+KjXR+mxDrP/cAU3gCIrEIHCnD3MV5UmQZE8QWUNRZc0PxwJo+Y
         BSjg==
X-Gm-Message-State: APjAAAXKKkhC9ci/MXU5xCe+nS/iSOju4WUbZ2wJKNyW83ShM+pMfVDE
        udl8LrVFPu5Dt9fmnrZpTjrwe7rRBPdpcI9wBh8=
X-Google-Smtp-Source: APXvYqynnGYzP6VQ2pMuY4FZtPHGj0WHH5DSTkb9XDnDDuAVbJRhago5easgh6CXNENwZ+zGj5coFYVQe/dDhdkIrm4=
X-Received: by 2002:a37:4c13:: with SMTP id z19mr6556709qka.449.1570662679717;
 Wed, 09 Oct 2019 16:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191008231009.2991130-1-andriin@fb.com> <CAADnVQLYmzJhhkJknYHBaf0LEWq75VfT6cCg-QEj8UfcE8uBGg@mail.gmail.com>
In-Reply-To: <CAADnVQLYmzJhhkJknYHBaf0LEWq75VfT6cCg-QEj8UfcE8uBGg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Oct 2019 16:11:08 -0700
Message-ID: <CAEf4BzZ79SHkrRzw4sQjHEecY0tBQAvi=PcpPuK=SWU8CChmFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Fix BTF-to-C converter's padding generation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 3:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 8, 2019 at 4:12 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Fix BTF-to-C logic of handling padding at the end of a struct. Fix existing
> > test that should have captured this. Also move test_btf_dump into a test_progs
> > test to leverage common infrastructure.
>
> Applied.
> But I see some build weirdness.
> Probably due to some previous patches.
> Parallel build in selftests/bpf/ is not always succeeding.
> For this particular set. New progs/*.c files failed to build the first time.

I think it's another problem with test_attach_probe.c - it depends on
libbpf's auto-generated bpf_helper_defs.h, which is not enforced to
happen before progs/*.c are built. I think it's time to do some
selftests/bpf/Makefile overhaul, honestly. But I'll try to come up
with a quick fix for this particular issue as well.
