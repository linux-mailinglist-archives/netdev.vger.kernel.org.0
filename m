Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395205ACCA
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfF2SEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:04:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46328 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfF2SEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:04:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id x18so7726567qkn.13;
        Sat, 29 Jun 2019 11:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wc7vdXkRL3s9I8NCqR2l6LNhGGUGC9l/DzC8OWU13ZQ=;
        b=BXoAcj4VWyEk2THK8zjuqzcx5QfFx/3qeA1xJvzhv56dAKso0KPWWMkzcoFa0vId3P
         p8BE9eosl90gcGrAT32rPBNmrSaKf5in88uNvvqCz+11o8M9vo96fMvozUcoVVjbZDrx
         c66ZY6rPsWenFZu+YPZbDRJSJdxqU6DeD91gLCo0N7YZqmNz5g3fkYR5SIdYZeWMO7BQ
         XdgCs7r8YI4eEyhi6bqueS2jLieolCBZn26gFGPwGSnFblCsM0pKPEhas2wcOZZTR4Oc
         GoL+JhD/GcZmI0OTtjyupGBDxjWBJQcJgMJIXxMABpTrPYX6og95Yc1uLSz3G31ZWCOR
         TjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wc7vdXkRL3s9I8NCqR2l6LNhGGUGC9l/DzC8OWU13ZQ=;
        b=oAsxO2/5DCA4ShiiHuAX4uC9yqibXGuMaDuVaMIjWHOWoffDkEUabUI9ICsdKqa5+b
         cSh1db7ybzkozjCNNq4Rf5JaCMbqqdnVA4m+XLJA79rqxvHphTCnd1YRIaSyihycXob7
         5dWllA7pvbkZDEsO4ibB+VSTYpZyyBHV5Ij80tea0ncek0BtriVD3ncHjSU6u8V4KrXs
         nX2mcAFdOfJWg22gfBEioszxBayz7qZj5rmj/dUbkhk2dPQ2EAXjwnU61cw8KO1mKfWN
         qIrsRR8Lq2MiKtuJI1Pl92VF0jQS1Dm2CKIZq08x2f0FZbZXwSNaETw4PbBnlN3Ckcdj
         RSEQ==
X-Gm-Message-State: APjAAAWMAriDw+0UIBp/xYGQnM/9ir271i7sQv1Vb8221BH8LToB9vx9
        9bm+Oh+CJa2EoBNge0nuF1pUQExl7KfsFVyvOnQ=
X-Google-Smtp-Source: APXvYqzHoMOouhTrewwsp0e1ux2gvjd4q1ATTpGW71ix80x6l49mPQOTmNwwj1CINHokfNpRPGMQuFIhQ0fBWYJO9aA=
X-Received: by 2002:ae9:e40f:: with SMTP id q15mr12919825qkc.241.1561831469750;
 Sat, 29 Jun 2019 11:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <4fdda0547f90e96bd2ef5d5533ee286b02dd4ce2.1561819374.git.jbenc@redhat.com>
In-Reply-To: <4fdda0547f90e96bd2ef5d5533ee286b02dd4ce2.1561819374.git.jbenc@redhat.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 29 Jun 2019 11:04:18 -0700
Message-ID: <CAPhsuW4ncpfNCvbYHF36pb6ZEBJMX-iJP5sD0x3PbmAds+WGOQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix inlines in test_lwt_seg6local
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 7:43 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> Selftests are reporting this failure in test_lwt_seg6local.sh:
>
> + ip netns exec ns2 ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
> Error fetching program/map!
> Failed to parse eBPF program: Operation not permitted
>
> The problem is __attribute__((always_inline)) alone is not enough to prevent
> clang from inserting those functions in .text. In that case, .text is not
> marked as relocateable.
>
> See the output of objdump -h test_lwt_seg6local.o:
>
> Idx Name          Size      VMA               LMA               File off  Algn
>   0 .text         00003530  0000000000000000  0000000000000000  00000040  2**3
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>
> This causes the iproute bpf loader to fail in bpf_fetch_prog_sec:
> bpf_has_call_data returns true but bpf_fetch_prog_relo fails as there's no
> relocateable .text section in the file.
>
> Add 'static inline' to fix this.
>
> Fixes: c99a84eac026 ("selftests/bpf: test for seg6local End.BPF action")
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Maybe use "__always_inline" as most other tests do?

Thanks,
Song
