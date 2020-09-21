Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058DF2732BA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgIUTYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgIUTYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 15:24:45 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E416C061755;
        Mon, 21 Sep 2020 12:24:45 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 133so3810132ybg.11;
        Mon, 21 Sep 2020 12:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dirujJNx2OldMnzfIghRqU/m1tYf3/gNs5npULLx71Q=;
        b=tYH6HN/uIeQNhOz0vr8WXxpXoaq0NU/YCiD9Dt3YMRKDqXG/XRYoMhtPyzXNmtFni+
         1HcjMedd75UKnNrXiPyWkfHPtBxXpDaYMnfENY2PSGjEjp/sCppTEPDjxO4mgnxCY9tA
         ciFWZcnfMheukqDJ4xVjAZloFjjoAgRPu08lIj5NVp6d9OTcxP0Do2AXA5nzsIpSda9r
         tY6+HJzYLw7ckm0AssDMzeLx1TyULKKPtX+4ps92Nf5X5OnuaKLjMk6ukWKQ2Qv9DW7w
         eygVS7PqU2wcOOitrJFtMO4ikcVbDVdqlfOgPbyAkXA0rKM9wEbY242iWjTuAemOi3KP
         JqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dirujJNx2OldMnzfIghRqU/m1tYf3/gNs5npULLx71Q=;
        b=Olc42TJN8PBWht1M6+6BTpfIeS6SAUmKNZWD2wsM6mk7UaT+Y7AeSQ3DDdFaPdfgCJ
         6pDF8/7P1rbg5cu2YmMx0bQhTFTbOhG1rV3VIRjmO3l6yM66KvzhOmHga61gCKs5xzAK
         ATo86TS2IoTal/RQgSl+BYmv41ItHY4BjF/pgewqMh4YSSz3wlD5Ki/Zm4YqmNK9kjge
         0ANomRFRcxpzOluYXdwQJVihY4uQkHE65qJVSh65kkI4fcgnoOGYpglJZu2W7l0k63LW
         88Ce3r6eUOGVIOlX80x1yz48dJZqMgmxH9h7fsKdmvw1004RJJVlIsN8p0WwH8SP7PXo
         XBsA==
X-Gm-Message-State: AOAM533cOrXB0qvXLmZid1EX2bLrWa0AQwnCorvhmlUY3COmmjYIOhgw
        5Dvbsp5SAnkVIraYBhO5s+JZDCmxWxlEuU0r9jc=
X-Google-Smtp-Source: ABdhPJw5diuWw+OSycrWLphIXP04/kx0dvYrQ8zOQpg94rQ6JDwJiKSjoyKMS0aMXuADDgoze+H9mYH1BvxCRDht5yw=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr1866901ybz.27.1600716284720;
 Mon, 21 Sep 2020 12:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600417359.git.Tony.Ambardar@gmail.com>
In-Reply-To: <cover.1600417359.git.Tony.Ambardar@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 12:24:34 -0700
Message-ID: <CAEf4BzaW2wS7N2YfH0=zNxvbbqmf9uqN-x1cZ2NebVJJTaq-4g@mail.gmail.com>
Subject: Re: [PATCH bpf v1 0/3] fix BTF usage on embedded systems
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 10:03 PM Tony Ambardar <tony.ambardar@gmail.com> wrote:
>
> Hello,
>
> I've been experimenting with BPF and BTF on small, emebedded platforms
> requiring cross-compilation to varying archs, word-sizes, and endianness.
> These environments are not the most common for the majority of eBPF users,
> and have exposed multiple problems with basic functionality. This patch
> series addresses some of these issues.
>
> Enabling BTF support in the kernel can sometimes result in sysfs export
> of /sys/kernel/btf/vmlinux as a zero-length file, which is still readable
> and seen to leak non-zero kernel data. Patch #1 adds a sanity-check to
> avoid this situation.
>
> Small systems commonly enable LD_DEAD_CODE_DATA_ELIMINATION, which causes
> the .BTF section data to be incorrectly removed and can trigger the problem
> above. Patch #2 preserves the BTF data.
>
> Even if BTF data is generated and embedded in the kernel, it may be encoded
> as non-native endianness due to another bug [1] currently being worked on.
> Patch #3 lets bpftool recognize the wrong BTF endianness rather than output
> a confusing/misleading ELF header error message.
>
> Patches #1 and #2 were first developed for Linux 5.4.x and should be
> backported if possible. Feedback and suggestions for improvement are
> welcome!
>
> Thanks,
> Tony
>
> [1] https://lore.kernel.org/bpf/CAPGftE8ipAacAnm9xMHFabXCL-XrCXGmOsX-Nsjvz9wnh3Zx-w@mail.gmail.com/
>
> Tony Ambardar (3):
>   bpf: fix sysfs export of empty BTF section
>   bpf: prevent .BTF section elimination
>   libbpf: fix native endian assumption when parsing BTF
>
>  include/asm-generic/vmlinux.lds.h | 2 +-
>  kernel/bpf/sysfs_btf.c            | 6 +++---
>  tools/lib/bpf/btf.c               | 6 ++++++
>  3 files changed, 10 insertions(+), 4 deletions(-)
>
> --
> 2.25.1
>

All fixes look good:

Acked-by: Andrii Nakryiko <andriin@fb.com>
