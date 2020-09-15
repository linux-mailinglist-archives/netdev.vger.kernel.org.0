Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19CB26AD74
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgIOTYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbgIOTXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 15:23:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30649C061797
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 12:23:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j2so4488474wrx.7
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 12:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xaKrPrgrBMlaZS38zpubG0Tl9ZPTk+y0W+Heq7aSri0=;
        b=dcHWqN2/DpwqyJ5fhRCM5yW2IHn71hLOeS3/sZnQGLwIyf/rqUBIs0mMrs37jxjGsC
         aUJPjhHhH75YzNfcKKDhzSjWS9NroOCtTtDg4X86Jdcuck8eVhjYWVlC0uS2SijhVdZO
         kahp3K3RrtKDUAh9WJkNTOzneOz52ZNngoHCmWXhntdLPXlZwlqDA8OAHn2cnnSh/hws
         w0Lf8GyYxPBH8J6PlskI0Z6tLrR5zn1xFYiorSc6rvW6bz3mYY6Wi2qE3gfeAYdHRqhD
         vlpB94CQ7b3NmNoKWtNZh9+aho9deElmGArcuxe7Fpz3pwxNBwtEfQ9brq8TybDjSeE2
         wQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xaKrPrgrBMlaZS38zpubG0Tl9ZPTk+y0W+Heq7aSri0=;
        b=lXEHzunNdk7bKg/gJ/7yCG8+jUh0Z+WPKYLHoahnQlrwmU/JUGzcxv6HBj5RDqnM3A
         5zImplBFokrpZ6CUDOIOfXVU+LH0ILAHh/3PY2VTwRuETcnFyHPW5rSOlHhIm9/VAWmQ
         cfYb7qRC5b/y1i777ucPP5FwgqKqFmaz9QoLiixN5m4GLlceq8RH/IS4OUK6Rt1WiE50
         TJiUDl1u5hBA5BOeUQEzTmAMqu+xtwMmRoViguU7yod/HY8omogamNqy3wIII/volAF7
         t5MQiKWRDnGkGdAs75lkAF1Clb/rC6MiNhPx+THN/EcxhI1lo65MmABb1Ec7quUXkd7G
         UwYA==
X-Gm-Message-State: AOAM530E378clgz9Um2hH1vcdZrlHdGXw/KwllN9+rSUxl6f55UeNRfO
        51XHYL8TO5cqAqYh1NgKrZRWoA==
X-Google-Smtp-Source: ABdhPJxWQXdJLEG5oDeGFEeYUF/vrSRY9Tqwlwma5wZ2kLJYvIlIAvVSVcHO77MmmESpE8oFcvfKMA==
X-Received: by 2002:a5d:6283:: with SMTP id k3mr23754401wru.191.1600197795717;
        Tue, 15 Sep 2020 12:23:15 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id f23sm1651722wmc.3.2020.09.15.12.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 12:23:15 -0700 (PDT)
Date:   Tue, 15 Sep 2020 22:23:11 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
        Jiri Olsa <jolsa@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200915192311.GA124360@apalos.home>
References: <20200914160355.19179-1-ilias.apalodimas@linaro.org>
 <20200915131102.GA26439@willie-the-truck>
 <20200915135344.GA113966@apalos.home>
 <20200915141707.GB26439@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915141707.GB26439@willie-the-truck>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will, 

On Tue, Sep 15, 2020 at 03:17:08PM +0100, Will Deacon wrote:
> On Tue, Sep 15, 2020 at 04:53:44PM +0300, Ilias Apalodimas wrote:
> > On Tue, Sep 15, 2020 at 02:11:03PM +0100, Will Deacon wrote:
> > > Hi Ilias,
> > > 
> > > On Mon, Sep 14, 2020 at 07:03:55PM +0300, Ilias Apalodimas wrote:
> > > > Running the eBPF test_verifier leads to random errors looking like this:
> > > > 
> > > > [ 6525.735488] Unexpected kernel BRK exception at EL1
> > > > [ 6525.735502] Internal error: ptrace BRK handler: f2000100 [#1] SMP
> > > 
> > > Does this happen because we poison the BPF memory with BRK instructions?
> > > Maybe we should look at using a special immediate so we can detect this,
> > > rather than end up in the ptrace handler.
> > 
> > As discussed offline this is what aarch64_insn_gen_branch_imm() will return for
> > offsets > 128M and yes replacing the handler with a more suitable message would 
> > be good.
> 
> Can you give the diff below a shot, please? Hopefully printing a more useful
> message will mean these things get triaged/debugged better in future.

[...]

The error print is going to be helpful imho. At least it will help
people notice something is wrong a lot faster than the previous one.


[  575.273203] BPF JIT generated an invalid instruction at bpf_prog_64e6f4ba80861823_F+0x2e4/0x9a4!
[  575.281996] Unexpected kernel BRK exception at EL1
[  575.286786] Internal error: BRK handler: f2000100 [#5] PREEMPT SMP
[  575.292965] Modules linked in: crct10dif_ce drm ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xor_neon zstd_compress raid6_pq nvme nvme_core realtek
[  575.307516] CPU: 21 PID: 11760 Comm: test_verifier Tainted: G      D W         5.9.0-rc3-01410-ged6d9b022813-dirty #1
[  575.318125] Hardware name: Socionext SynQuacer E-series DeveloperBox, BIOS build #1 Jun  6 2020
[  575.326825] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=--)
[  575.332396] pc : bpf_prog_64e6f4ba80861823_F+0x2e4/0x9a4
[  575.337705] lr : bpf_prog_d3e125b76c96daac+0x40/0xdec
[  575.342752] sp : ffff8000144e3ba0
[  575.346061] x29: ffff8000144e3bd0 x28: 0000000000000000
[  575.351371] x27: 00000085f19dc08d x26: 0000000000000000
[  575.356681] x25: ffff8000144e3ba0 x24: ffff800011fdf038
[  575.361991] x23: ffff8000144e3d20 x22: 0000000000000001
[  575.367301] x21: ffff800011fdf000 x20: ffff0009609d4740
[  575.372611] x19: 0000000000000000 x18: 0000000000000000
[  575.377921] x17: 0000000000000000 x16: 0000000000000000
[  575.383231] x15: 0000000000000000 x14: 0000000000000000
[  575.388540] x13: 0000000000000000 x12: 0000000000000000
[  575.393850] x11: 0000000000000000 x10: ffff8000000bc65c
[  575.399160] x9 : 0000000000000000 x8 : ffff8000144e3c58
[  575.404469] x7 : 0000000000000000 x6 : 0000000dd7ae967a
[  575.409779] x5 : 00ffffffffffffff x4 : 0007fabd6992cf96
[  575.415088] x3 : 0000000000000018 x2 : ffff8000000ba214
[  575.420398] x1 : 000000000000000a x0 : 0000000000000009
[  575.425708] Call trace:
[  575.428152]  bpf_prog_64e6f4ba80861823_F+0x2e4/0x9a4
[  575.433114]  bpf_prog_d3e125b76c96daac+0x40/0xdec
[  575.437822]  bpf_dispatcher_xdp_func+0x10/0x1c
[  575.442265]  bpf_test_run+0x80/0x240
[  575.445838]  bpf_prog_test_run_xdp+0xe8/0x190
[  575.450196]  __do_sys_bpf+0x8e8/0x1b00
[  575.453943]  __arm64_sys_bpf+0x24/0x510
[  575.457780]  el0_svc_common.constprop.0+0x6c/0x170
[  575.462570]  do_el0_svc+0x24/0x90
[  575.465883]  el0_sync_handler+0x90/0x19c
[  575.469802]  el0_sync+0x158/0x180
[  575.473118] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
[  575.479211] ---[ end trace 8cd54c7d5c0ffda4 ]---

Cheers
/Ilias
