Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F5DF8340
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKKXHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:07:07 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33289 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfKKXHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 18:07:07 -0500
Received: by mail-pg1-f195.google.com with SMTP id h27so10481177pgn.0;
        Mon, 11 Nov 2019 15:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YfV29xOzJRJsIhGnFT3yvwsBBAXPSZ62YcmleMuOFxQ=;
        b=ggpzL9VeAgVbKszrRxanaj9wsojZw4HpSwcEN5K6cmGfDP7ZgN5VWQXvis28Kc/kwz
         C6hT/nIc1KE6ZH6rpI214x7MmWBRB6rwS78fh0Z3t7zcV+wUV39IYmugHsvcejqVEPNw
         q7dDCIBX5r5IEvDbaeqc0DoYwrXaKKNVNS/fSzuBoSlR9vB612fwwNOtNtrAW5lYjMlx
         jXV1scOMJXiuV6F0PlOGS7eoMw99ANR/BcosEB5YBkwCoVxRHBMTyV7hDpHV+nx1kh7O
         MrTQMFA0dwVSDqbjvhuZuwwgursCpfAD6pOymHgTzXquBuMyOVHTY2BGqKlLFe95DH7L
         t5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YfV29xOzJRJsIhGnFT3yvwsBBAXPSZ62YcmleMuOFxQ=;
        b=gqcb7RULkT45GxWvUvH1q5eFy9BE9ILpDJquHehEoRKFHqeTjYuDo6K66Cn/7Q5Naw
         xAQT/wsB3UYien2xVUeLaMXWqIPmPERlGdVMj0UVJYYss2VUWsislLmn4OtZGIRtq4Eh
         TvTvG8hwKc8qTrlDlvtFW9IcAb9HooWaLtH55bns/8Zx5hmb9a7zhAnMe0xTJ6604kP6
         uvRoWkZ8pMUU8TgPGFI01Mrm03JqMIZnWvOdOyOt5KpO7ZFP6AHI7lFUBSFzMU/UiAjS
         tXVNzTX0mVM3AveKe9QV43KjlD8pHZL18ezGjdXYQ0JPLRDnamSNK+/xR8B+uSMc9bK2
         0mww==
X-Gm-Message-State: APjAAAUDOON2nVc79HQP5UHVc8ZyIuY9K7tqr4qtnaf7Kxk0j6+nOTSZ
        vvIbJp5yKQ32poRQ1es4ThR7BxHc
X-Google-Smtp-Source: APXvYqwafBx6Q0EfhwjSfbBsFl/+zesRwmuTJf+hy0AjPbG46uGos0LgP48s72IeVtgxWQQ/aNsLVw==
X-Received: by 2002:a17:90a:ae01:: with SMTP id t1mr2108620pjq.32.1573513625515;
        Mon, 11 Nov 2019 15:07:05 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::a925])
        by smtp.gmail.com with ESMTPSA id j6sm15272890pfa.124.2019.11.11.15.07.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 15:07:04 -0800 (PST)
Date:   Mon, 11 Nov 2019 15:07:03 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 18/18] selftests/bpf: Add a test for
 attaching BPF prog to another BPF prog and subprog
Message-ID: <20191111230701.sviwbvh2ddx24sx6@ast-mbp.dhcp.thefacebook.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-19-ast@kernel.org>
 <CAEf4BzYt4L7pxKr0ES=-kUd92NMtBPabM2hZW=TrGNARsLnCJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYt4L7pxKr0ES=-kUd92NMtBPabM2hZW=TrGNARsLnCJA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 09:04:58AM -0800, Andrii Nakryiko wrote:
> On Thu, Nov 7, 2019 at 10:43 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > Add a test that attaches one FEXIT program to main sched_cls networking program
> > and two other FEXIT programs to subprograms. All three tracing programs
> > access return values and skb->len of networking program and subprograms.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> >  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 76 ++++++++++++++++
> >  .../selftests/bpf/progs/fexit_bpf2bpf.c       | 91 +++++++++++++++++++
> >  2 files changed, 167 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
> >
> 
> [...]
> 
> > +SEC("fexit/test_pkt_access_subprog2")
> > +int test_subprog2(struct args_subprog2 *ctx)
> > +{
> > +       struct sk_buff *skb = (void *)ctx->args[0];
> > +       __u64 ret;
> > +       int len;
> > +
> > +       bpf_probe_read(&len, sizeof(len),
> > +                      __builtin_preserve_access_index(&skb->len));
> 
> nit: we have bpf_core_read() for this, but I suspect you may have
> wanted __builtin spelled out explicitly

exactly. it should have been bpf_probe_read_kernel though. will fix.

