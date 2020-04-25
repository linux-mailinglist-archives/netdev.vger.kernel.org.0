Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35C41B82E2
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgDYAsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgDYAsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 20:48:37 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FF2C09B049;
        Fri, 24 Apr 2020 17:48:36 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u6so11806828ljl.6;
        Fri, 24 Apr 2020 17:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NsQavboMviC46TTE6iijTekGRHyX4NjoGpEvCT6wOYQ=;
        b=WMEkaXKkeMJ9u8VhnOJz/pr9wnJAgvaAgASHFXizR8jsWZS+X3SlhZkotj2DaGj39H
         RiX5YQO/nvtsTq6TqNycZITnLRPo306Y5HAURBthMeNE0gDaRDJs8DVZmEW6kW5N1Ius
         HTWggeo4vLHAJr2fIPyoaWkDCwUv2myV0jRo4AIBnlmtVlxdU4shwgM+mCDb6vY+liTP
         CDRBCkReipvRPMSjEE33VimM2TrdHna9dSr6anm/zkoW7qVys6yvljI3SRsyhMmIlJxk
         cqd3yNsWZs60nRKE5n2rMw4cXD1nE/xueJ71HU8mIVe/SBw/zPAoN2Inmj7O/4pGqwR/
         lnDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NsQavboMviC46TTE6iijTekGRHyX4NjoGpEvCT6wOYQ=;
        b=KjEyCnr9FVVUay1p9mT2//iBRXf3RWeqOueyrxQtehZfWc87EgzNg2xX9wALVA11w7
         0FNPNWwXEDOhOfYY6aWkUomRqShkYK4CBGz3ldFmN8FLlvypbmAMqFGsG6c2ATZw+cIX
         051jIu9+S+cRt1k6UsYioHJd1gYhUw86qWIfhMi6nNsxMMRJfxMf2ycnLdEnz/N2TUh1
         VjaVHhSydnLK/KI9skIa5PMwNEBS68lmpJlgtAPHaEaUJr8E3k7UmPIf3z4LHTNXd/DB
         27Jkp20cOCSO0dC+JC5GS/OUeJuhMMxm3E4xRiY98HQhwOOiRMDedmfesYTe9JsvlYl8
         VTYQ==
X-Gm-Message-State: AGi0Puauru4GVY3LqAyf7nUoMR1vn4y05uGIkUHyvvN3AunoWi5Kspxl
        K04ATu+pTw4CWGH9KH1dfF8bIe+uBrk8e7eLcPRv0A==
X-Google-Smtp-Source: APiQypLKx6g8Cdu6GHQ62qS4lIV/x/wfq8XXNAmItmf59Kc8eKy2kDvIE8xZDfHa9jxtGvVPsSz4jyJ6gRsUNKu4MRo=
X-Received: by 2002:a2e:a169:: with SMTP id u9mr7768079ljl.144.1587775714973;
 Fri, 24 Apr 2020 17:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200422003753.124921-1-sdf@google.com>
In-Reply-To: <20200422003753.124921-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Apr 2020 17:48:23 -0700
Message-ID: <CAADnVQL+p1XmSsUe1UZ99PbBy7x-w8rqND-5HzZ5MENZtNAEvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix a couple of broken test_btf cases
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 5:37 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
> introduced function linkage flag and changed the error message from
> "vlen != 0" to "Invalid func linkage" and broke some fake BPF programs.
>
> Adjust the test accordingly.
>
> AFACT, the programs don't really need any arguments and only look
> at BTF for maps, so let's drop the args altogether.
>
> Before:
> BTF raw test[103] (func (Non zero vlen)): do_test_raw:3703:FAIL expected
> err_str:vlen != 0
> magic: 0xeb9f
> version: 1
> flags: 0x0
> hdr_len: 24
> type_off: 0
> type_len: 72
> str_off: 72
> str_len: 10
> btf_total_size: 106
> [1] INT (anon) size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> [2] INT (anon) size=4 bits_offset=0 nr_bits=32 encoding=(none)
> [3] FUNC_PROTO (anon) return=0 args=(1 a, 2 b)
> [4] FUNC func type_id=3 Invalid func linkage
>
> BTF libbpf test[1] (test_btf_haskv.o): libbpf: load bpf program failed:
> Invalid argument
> libbpf: -- BEGIN DUMP LOG ---
> libbpf:
> Validating test_long_fname_2() func#1...
> Arg#0 type PTR in test_long_fname_2() is not supported yet.
> processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
> peak_states 0 mark_read 0
>
> libbpf: -- END LOG --
> libbpf: failed to load program 'dummy_tracepoint'
> libbpf: failed to load object 'test_btf_haskv.o'
> do_test_file:4201:FAIL bpf_object__load: -4007
> BTF libbpf test[2] (test_btf_newkv.o): libbpf: load bpf program failed:
> Invalid argument
> libbpf: -- BEGIN DUMP LOG ---
> libbpf:
> Validating test_long_fname_2() func#1...
> Arg#0 type PTR in test_long_fname_2() is not supported yet.
> processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
> peak_states 0 mark_read 0
>
> libbpf: -- END LOG --
> libbpf: failed to load program 'dummy_tracepoint'
> libbpf: failed to load object 'test_btf_newkv.o'
> do_test_file:4201:FAIL bpf_object__load: -4007
> BTF libbpf test[3] (test_btf_nokv.o): libbpf: load bpf program failed:
> Invalid argument
> libbpf: -- BEGIN DUMP LOG ---
> libbpf:
> Validating test_long_fname_2() func#1...
> Arg#0 type PTR in test_long_fname_2() is not supported yet.
> processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
> peak_states 0 mark_read 0
>
> libbpf: -- END LOG --
> libbpf: failed to load program 'dummy_tracepoint'
> libbpf: failed to load object 'test_btf_nokv.o'
> do_test_file:4201:FAIL bpf_object__load: -4007
>
> Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied to bpf tree. Thanks
