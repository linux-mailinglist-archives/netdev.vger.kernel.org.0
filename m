Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697B31DEF8F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgEVS6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730840AbgEVS6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:58:35 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810A1C061A0E;
        Fri, 22 May 2020 11:58:35 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id i5so11686855qkl.12;
        Fri, 22 May 2020 11:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gpy0uHkIeQmpCnBOmw7IB3fvyPs5tQERo4inod6pNFc=;
        b=IhOgSoXLkCIJvCLmV/m6sF6m++0UII5dTW5RGAY4JS9hxMutg6J+qxjmtbtV3TZ5nd
         9WdeeguflL9LBQncNSPhvvGVwmJXpPU2nwueYiZEUGd1idmB/OLeH5J+4wacHGdolqxU
         NYpLnnzehH9hsIlD8YgQ6uX8qjIIUyJbHllB/F78JXMAyWQlLm+XE8ZbbqYGQ9p+rfgd
         ECnDF4qT0CQUlg8dvdPPcXNQgSggRJh/rhEL6NvvzJVbOCns5iwC8thpt69egVsqQ48Z
         4uKDqUYVHgaJRorwwedh7nOMwHJTXtot7rxJ4n9Q7e3PPFdlmS7EtEJ4ChuuTiaImX/u
         wVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gpy0uHkIeQmpCnBOmw7IB3fvyPs5tQERo4inod6pNFc=;
        b=XArbfxeM6qGwLTtHxh88lqehhYfUcvaYBEj+wPk4xAzTRjN5Qhkjsk1lNXGeNbL7pH
         YsoIlrdzD1TIArfk3DKrotqjnVdejTNaYcqpqF+iecR8k5Ed5MJ0hOEQzpqZru4w+NXA
         KnQsp/rMQgKNa668UemjPPpi+BFzLlGRNOvzrxdfhqChaiJmW6rB/YcJZciWSD7FDxLG
         yhUzvFXBTu8QVCO5DRwdSmt9dv7QILDgnorMMwul4tK0knJw6JCOLS348p/p/lCoCe68
         fwHUddnKGEIFK9p0Lop2TUtR/AeqoglKRNQOXgfGw36XHEuVCPEWMbVBS2mRSwJEZfgd
         tb7Q==
X-Gm-Message-State: AOAM530EcsuRQsxLPRYxfFCt6am9ZzyJREmocGoUFEB3nUXCODHKPj8i
        P/vWQJrHEOwUoyzIywYf7fBtKgRil7F9ie2ZSjc=
X-Google-Smtp-Source: ABdhPJxU/DEHIQc0KmmkRUdeR6DSacVYg35VEadwnuMPRsD2vrzsFWPOj+lIDMwAvCWdtDdarKve10T19QyWO2rsUa0=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr17475880qkg.437.1590173914774;
 Fri, 22 May 2020 11:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-6-andriin@fb.com>
 <20200522012034.sufpu7e62itcn2vg@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200522012034.sufpu7e62itcn2vg@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 May 2020 11:58:24 -0700
Message-ID: <CAEf4BzZy+iVMfVCHP-PT5hdeWwmjgqp5dpPvhzbz1bsateJN_Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/7] selftests/bpf: add BPF ringbuf selftests
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 6:20 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 17, 2020 at 12:57:25PM -0700, Andrii Nakryiko wrote:
> > diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
> > new file mode 100644
> > index 000000000000..7eb85dd9cd66
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
> > @@ -0,0 +1,77 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2019 Facebook
>
> oops ;)
>

heh, still living in good old 2019... :) fixing...

> > +
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +struct sample {
> > +     int pid;
> > +     int seq;
> > +     long value;
> > +     char comm[16];
> > +};
> > +
> > +struct ringbuf_map {
> > +     __uint(type, BPF_MAP_TYPE_RINGBUF);
> > +     __uint(max_entries, 1 << 12);
> > +} ringbuf1 SEC(".maps"),
> > +  ringbuf2 SEC(".maps");
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
> > +     __uint(max_entries, 4);
> > +     __type(key, int);
> > +     __array(values, struct ringbuf_map);
> > +} ringbuf_arr SEC(".maps") = {
> > +     .values = {
> > +             [0] = &ringbuf1,
> > +             [2] = &ringbuf2,
> > +     },
> > +};
>
> the tests look great. Very easy to understand the usage model.

great, thanks!
