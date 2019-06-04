Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AEA34C43
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfFDPad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:30:33 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42390 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbfFDPad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:30:33 -0400
Received: by mail-pg1-f196.google.com with SMTP id e6so9307280pgd.9;
        Tue, 04 Jun 2019 08:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h8y9FTTLjHe+0h2Puf3tr7NFWmgEiBTwef6nPv6PjAc=;
        b=V+MQbyImXrl0FLiDWfLyVrsNBuZohhRCGubYoprpcAq9o45yLXsMjo4S+ePXwk+9sy
         6wjSjKQtpIvuYQEOXilQLSNw44fGRKBa5ydyvaIbUzMn78uAfN5Ig8hCVsm/U5hGzcx7
         9s68WSuCzBxnOfv7pua9raMuHcAXjeBW7vUF7rrOnL4hReq2eVg1IaBRMObET4RRELsZ
         aHNcgPoyBgSOnV8c7/pqUs0kJJHoZwTy3RlpybCna56eMCwecGOlY3CL3MKatpUl4D29
         CHU//hCpLhpngtA/FMpwgwcU/FmOsf9DTskrNQwqpF1nHP+SULgDzfuj64oHngmQUI+S
         aXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h8y9FTTLjHe+0h2Puf3tr7NFWmgEiBTwef6nPv6PjAc=;
        b=cF+vLNYshvfM3F6r1cRZC+OdYRMigjFBtC4SPT3tbNFhDTWdCUfyy2+A97FKNy/t9q
         orOtG6O1ArNTOpekuFxiEVOr5KPENuQqp+VCfg1+nnBu1NX2usMHCFcEpjNGQ0KfuXj2
         +8rIPqRmZbQ/pZLHMp6LRZYAl/wpTwu+juKvU8TQQYy0om8fpLIESa//Hq/qKch/qC/z
         B2nx5R/C/XbRZawhb2/uMtBEXTcsszjBAPCY+etyF9Z1P/pw1yxGDvs7nbNsAecA6+DA
         QfQG2/HeX8nOjUsaO5rCNp0T318hZ0+DAkBKtKPWl8itulS0h2XtNt7J7Ense/16ihDw
         0IvA==
X-Gm-Message-State: APjAAAXCZ12f00rzktEijQTMfOg1OGyaBlX39VRmf42muqXf8w60zqr4
        L2of8Ct+z8/tU8kI4SBpumt2ZSmU
X-Google-Smtp-Source: APXvYqx3YP6BKCnxaUMlAZV2mEtJQRxJYd9YFT42WZulGVCeij5UASVmYlaG5PBWCOQN1B9TinePTQ==
X-Received: by 2002:a63:5a1f:: with SMTP id o31mr11545537pgb.254.1559662232765;
        Tue, 04 Jun 2019 08:30:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::b813])
        by smtp.gmail.com with ESMTPSA id a22sm12228865pfn.173.2019.06.04.08.30.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 08:30:31 -0700 (PDT)
Date:   Tue, 4 Jun 2019 08:30:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "Dmitry V . Levin" <ldv@altlinux.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bpf: fix uapi bpf_prog_info fields alignment
Message-ID: <20190604153028.ysyzvmpxqaaln4v2@ast-mbp.dhcp.thefacebook.com>
References: <f42c7b44b3f694056c4216e9d9ba914b44e72ab9.1559648367.git.baruch@tkos.co.il>
 <CAADnVQJ1vRvqNFsWjvwmzSc_-OY51HTsVa13XhgK1v9NbYY2_A@mail.gmail.com>
 <CAMuHMdV-0s_ikRmCrEcMCfkAp57Fu8WTUnJsopGagbYa+GGpbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV-0s_ikRmCrEcMCfkAp57Fu8WTUnJsopGagbYa+GGpbA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 05:23:46PM +0200, Geert Uytterhoeven wrote:
> Hi Alexei,
> 
> On Tue, Jun 4, 2019 at 5:17 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Tue, Jun 4, 2019 at 4:40 AM Baruch Siach <baruch@tkos.co.il> wrote:
> > > Merge commit 1c8c5a9d38f60 ("Merge
> > > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
> > > fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> > > applications") by taking the gpl_compatible 1-bit field definition from
> > > commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> > > bpf_prog_info") as is. That breaks architectures with 16-bit alignment
> > > like m68k. Widen gpl_compatible to 32-bit to restore alignment of the
> > > following fields.
> >
> > The commit log is misleading and incorrect.
> > Since compiler makes it into 16-bit field, it's a compiler bug.
> > u32 in C should stay as u32 regardless of architecture.
> 
> C99 says (Section 6.7.2.1, Structure and union specifiers, Semantics)
> 
>     10  An implementation may allocate any addressable storage unit
>         large enough to hold a bit-field.
> 
> $ cat hello.c
> #include <stdio.h>
> #include <stdint.h>
> #include <stdlib.h>
> 
> struct x {
>         unsigned int bit : 1;
>         unsigned char byte;
> };
> 
> int main(int argc, char *argv[])
> {
>         struct x x;
> 
>         printf("byte is at offset %zu\n", (uintptr_t)&x.byte - (uintptr_t)&x);
>         printf("sizeof(x) = %zu\n", sizeof(x));
>         exit(0);
> }
> $ gcc -Wall hello.c -o hello && ./hello
> byte is at offset 1
> sizeof(x) = 4
> $ uname -m
> x86_64
> 
> So the compiler allocates a single byte, even on a 64-bit platform!
> The gap is solely determined by the alignment rule for the
> successive field.

argh. then we need something like this:
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7c6aef253173..a2ac0b961251 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3174,6 +3174,7 @@ struct bpf_prog_info {
        char name[BPF_OBJ_NAME_LEN];
        __u32 ifindex;
        __u32 gpl_compatible:1;
+       __u32 :31;
        __u64 netns_dev;
        __u64 netns_ino;
        __u32 nr_jited_ksyms;

