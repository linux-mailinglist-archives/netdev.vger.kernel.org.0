Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0509B342E7D
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 18:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCTRBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 13:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTRBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 13:01:09 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68231C061574;
        Sat, 20 Mar 2021 10:01:09 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id j198so1726750ybj.11;
        Sat, 20 Mar 2021 10:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NDKaUYr9y+PSt4ii1Ca9BfrsR+8chbZ7+ZB91jt7Qcg=;
        b=S1s6igB0TLqNbT3u4qnr+dj+HtfMpd6SSCilR8l15dFd6eWIZqzpzHVUoBtI9DJjTK
         7hhAXWbPZoAOqb+Hsp7XGKYp3zFZpjvP3FdtW3e/Oz7E4fiH030Ec8w45mpHsMtj+7Sl
         TieSVZSCh71nX1acB+JBIHUYF+nfCQ606NWtI+42vsaS3Db+9qnKKuRsq1UveISYpxeF
         VvfTsDUh2iQ8bi47wIYzSTb7CcW9EuRxA5gNhZXrZPxdGSk3mKwEp6Kc3yEcoR4MlbJa
         YpgaJqI9fxNlJK0ng1vtvun5tazHDJtLKwRARyJQGPKJbzYhoTqC+jPBXGTp24vriVWm
         3keA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NDKaUYr9y+PSt4ii1Ca9BfrsR+8chbZ7+ZB91jt7Qcg=;
        b=MYfa6auJHgIGb2AvzdNL6Pi4QF0R3tlQSAL7vbq5Rqx8gXCTMh7iH4BFX/RakRX7hq
         DDNfBD29p1KUAIZtNd3xF/2a6Xw88kdLJrfSbcZNoOuyEPHXcuYJh3ciURDxL24zq9aa
         dAF3g9tOE4Kfo4a+N2TuDnEFTAFYKOjWBsMUPNX+x4RiD+rtwhzVUsUbqjznu0ZwnunN
         OTNPJJcxbCZm5QRVjcFND1YWSGLOIoLx6n7XslUvSTjOnzsLx/2gdoItmx5AdYrr74XJ
         TZqyD+X2dqSFg68ewcx8MUCg6lqlHA7rjRLsjFbKholo+Y9GquQMdGNH8K3Q60qzMxse
         aNTw==
X-Gm-Message-State: AOAM531qdHylhYV6YuV7MmODSmrRTYoDCzCcx5DJQbA1k4/eHiMgHWlJ
        ljr4Onm3qxNd/8B11R98mPFTLN9fvjIgyfAKfBg=
X-Google-Smtp-Source: ABdhPJw++ANOlQPN2cL/iRkYyqM4rzcLqbWY/feGOgv7IL4g7RJg4KnR57oxIKPX8tBAT86FFgYjPN8CFMwXckx+as4=
X-Received: by 2002:a25:9942:: with SMTP id n2mr13443941ybo.230.1616259668507;
 Sat, 20 Mar 2021 10:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210319205909.1748642-1-andrii@kernel.org> <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp>
In-Reply-To: <20210320022156.eqtmldxpzxkh45a7@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 20 Mar 2021 10:00:57 -0700
Message-ID: <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 7:22 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Mar 19, 2021 at 01:59:09PM -0700, Andrii Nakryiko wrote:
> > Add ability to skip BTF generation for some BPF object files. This is done
> > through using a convention of .nobtf.c file name suffix.
> >
> > Also add third statically linked file to static_linked selftest. This file has
> > no BTF, causing resulting object file to have only some of DATASEC BTF types.
> > It also is using (from BPF code) global variables. This tests both libbpf's
> > static linking logic and bpftool's skeleton generation logic.
>
> I don't like the long term direction of patch 1 and 3.
> BTF is mandatory for the most bpf kernel features added in the last couple years.
> Making user space do quirks for object files without BTF is not something
> we should support or maintain. If there is no BTF the linker and skeleton
> generation shouldn't crash, of course, but they should reject such object.

I don't think tools need to enforce any policies like that. They are
tools and should be unassuming about the way they are going to be used
to the extent possible. If BTF is useful it will happen naturally that
everyone will use it (and it's mostly the case already). But I don't
think crippling tools for the sake of enforcing BTF is the right
direction.

And it's not much of a quirk what bpftool is doing. If you prefer, I
can generate `void *` field for memory-mapped pointer. Patch #3 just
allows me to validate that there are no crashes.
