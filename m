Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7236A34E4A7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 11:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhC3Jnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 05:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbhC3JnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 05:43:14 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CB8C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 02:43:13 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id n138so22848941lfa.3
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 02:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JMP8eDgEhkYe8HifK8hiZaQ+dPjG3XHyor02oL/kDAI=;
        b=MlwnLNsqgBxL8YUSWjm+MIxEqUOZf3gHDWgUjVZixnVpKX0TjBh6rwSeXh4NiWe3Ba
         2YfWjzuxp+xcUPiO7SF/G6WvOxIgDZ/uMVye3/HgZF8+Pk0AVP2Q+M8WacMfy0PT8dfA
         kykhZvNML3Xx94Xu9sHbrftYuRGr24ZUwsNF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JMP8eDgEhkYe8HifK8hiZaQ+dPjG3XHyor02oL/kDAI=;
        b=nQoe4qSeGUXCC1XZ71YqqcdvDTU3UeqsZgeZhBAIuhYATztaAhCXVeqptAgnm6EJLD
         GKpnPp+W3E4IdEQE2ZljS9GhMws3Dt1kyZt1/LRo96D/kZS8FYA30dZki0AgTLI+eMvQ
         RiwTeHCir1oNxSYeq9TuW1AZdmBW14BT02XDbrm/6EWPrsNgngd2iIyD7isjiQA5Rqhe
         4Y6yG25CwdJglworf01muTpW8yqToBA1ZTdkDiQ7cYeYW/a1xBDhfvVbh2BOBEQLa2Yi
         Pr0nLdOWDAF5mtc855niWvlqovTnVcEtMqBcvbNA1ugjWKSZGWuMYlVLCUDg0JTYausb
         MZ1A==
X-Gm-Message-State: AOAM5303EW7/jU0UPhUH9csglEJrO5+G110wgezXChNQNSNg2mxDZ+Kq
        iMb/RAliz3Fe7iTCYL0DLZNPPkrnm5wfaxxbPt2ehQ==
X-Google-Smtp-Source: ABdhPJzEQTFUznIaG0ADYbGDgvJk50ou2vGmKxTVWu6BgICvmUZ2b7dDC8Vm09470UJMQxH0V/sMwUEQbIsQkaUPstM=
X-Received: by 2002:ac2:5f5b:: with SMTP id 27mr1466084lfz.325.1617097392308;
 Tue, 30 Mar 2021 02:43:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com>
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 30 Mar 2021 10:43:01 +0100
Message-ID: <CACAyw9-N6FO67JVJsO=XTohf=4-uMwsSi+Ym2Nxj0+GpofJJHQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 at 01:52, Martin KaFai Lau <kafai@fb.com> wrote:
>
> This series adds support to allow bpf program calling kernel function.

I think there are more build problems with this. Has anyone hit this before?

$ CLANG=clang-12 O=../kbuild/vm ./tools/testing/selftests/bpf/vmtest.sh -j 7

  GEN-SKEL [test_progs-no_alu32] bind6_prog.skel.h
libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
  GEN-SKEL [test_progs-no_alu32] bind_perm.skel.h
libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
  GEN-SKEL [test_progs-no_alu32] bpf_cubic.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_dctcp.skel.h
  GEN-SKEL [test_progs-no_alu32] bpf_flow.skel.h
libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -2
Error: failed to open BPF object file: No such file or directory
make: *** [Makefile:453:
/home/lorenz/dev/kbuild/vm//no_alu32/bpf_cubic.skel.h] Error 255
make: *** Deleting file '/home/lorenz/dev/kbuild/vm//no_alu32/bpf_cubic.skel.h'
make: *** Waiting for unfinished jobs....
libbpf: failed to find BTF for extern 'tcp_reno_cong_avoid' [38] section: -2
Error: failed to open BPF object file: No such file or directory
make: *** [Makefile:451:
/home/lorenz/dev/kbuild/vm//no_alu32/bpf_dctcp.skel.h] Error 255
make: *** Deleting file '/home/lorenz/dev/kbuild/vm//no_alu32/bpf_dctcp.skel.h'

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
