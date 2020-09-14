Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240AB268C28
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgINNY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 09:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbgINNX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 09:23:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1445C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:23:55 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a9so25004wmm.2
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9KKAHd5EbHuuNc2bMZWefZ2QJ1kYaQRNhIokoyRDv7I=;
        b=AWHXc65nC76ZJ07Uekj/yaBkYFLpJmsZJwnwv60ov4DbxiEghNfiULexY+KkQ96BMt
         LYIwerzTExsN1HWP8OcWhdpddU4jIFCyDu/ey/Q8fK3El/O7MjDkU5hpdWIHvYSEBJYm
         wQVng0N7hnH8An20DqOLSYR9L18l094ndlyL655nA68OBX0YiAhyJue8p77Xudp739qk
         tub9HffaRQR/LpkRp56YvPKtDI4jQ3VhbVYTR2QXOngbdqMWv3DJK0RkH0+hDOEKZJ13
         7+UhBuav5mqtSEd4dckaPi5iVyRyjCFKErYoKW8L4RycAhIzckzG3jzq1KN8cqlo7aAa
         ++9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9KKAHd5EbHuuNc2bMZWefZ2QJ1kYaQRNhIokoyRDv7I=;
        b=heKnpWsiUC87oaEVUxGqzuZGfCgzxAOuUc28WtmiuOiiJq75BoFWCIZNa5A5Ueo8Rg
         pZ1cPCDC7AQCzpdvvsfihr3YHiT7dPgQybZsI/f5vMMBfFrxvijnqGPTUc+WV5JXsdr1
         KJIhFwo/hyk/672uiShMGMIeS7WMPaTQbJ4VAxrFduzU3X7Jlxr5OePVJiEiVVTB76OC
         GuI4M7yAvCMAlRQG4vx580NFhy1b6He0U0YktRm6Pt+ngnEN/CgGWZ5EpF5fIlkZx8Cw
         987vA6sM8oTiaVSegOY3ogzlSl+/1N7C9jhnzFKsDzBozop7wHwyug9LY0R1FlBYphqc
         8egg==
X-Gm-Message-State: AOAM532pASljXbsw/yeB9G++dYegXQZLZdsKESx2TI+E96KHqJOEPL1i
        uV8wxRbnsocKhO36hTXhWiUezw==
X-Google-Smtp-Source: ABdhPJzBeS/FWVDFZNGQu2g6+tjT96HdaLGMykxt2m78OmL3rcFW6brflSpcC2qSq1TCf30r8oS22A==
X-Received: by 2002:a7b:c3d0:: with SMTP id t16mr15150689wmj.169.1600089833911;
        Mon, 14 Sep 2020 06:23:53 -0700 (PDT)
Received: from apalos.home (athedsl-4483967.home.otenet.gr. [94.71.55.135])
        by smtp.gmail.com with ESMTPSA id o9sm20388713wrw.58.2020.09.14.06.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 06:23:53 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:23:50 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
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
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200914132350.GA126552@apalos.home>
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
 <20200914122042.GA24441@willie-the-truck>
 <20200914123504.GA124316@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914123504.GA124316@apalos.home>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

On Mon, Sep 14, 2020 at 03:35:04PM +0300, Ilias Apalodimas wrote:
> On Mon, Sep 14, 2020 at 01:20:43PM +0100, Will Deacon wrote:
> > On Mon, Sep 14, 2020 at 11:36:21AM +0300, Ilias Apalodimas wrote:
> > > Running the eBPF test_verifier leads to random errors looking like this:
> > > 
> > > [ 6525.735488] Unexpected kernel BRK exception at EL1
> > > [ 6525.735502] Internal error: ptrace BRK handler: f2000100 [#1] SMP
> > > [ 6525.741609] Modules linked in: nls_utf8 cifs libdes libarc4 dns_resolver fscache binfmt_misc nls_ascii nls_cp437 vfat fat aes_ce_blk crypto_simd cryptd aes_ce_cipher ghash_ce gf128mul efi_pstore sha2_ce sha256_arm64 sha1_ce evdev efivars efivarfs ip_tables x_tables autofs4 btrfs blake2b_generic xor xor_neon zstd_compress raid6_pq libcrc32c crc32c_generic ahci xhci_pci libahci xhci_hcd igb libata i2c_algo_bit nvme realtek usbcore nvme_core scsi_mod t10_pi netsec mdio_devres of_mdio gpio_keys fixed_phy libphy gpio_mb86s7x
> > > [ 6525.787760] CPU: 3 PID: 7881 Comm: test_verifier Tainted: G        W         5.9.0-rc1+ #47
> > > [ 6525.796111] Hardware name: Socionext SynQuacer E-series DeveloperBox, BIOS build #1 Jun  6 2020
> > > [ 6525.804812] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=--)
> > > [ 6525.810390] pc : bpf_prog_c3d01833289b6311_F+0xc8/0x9f4
> > > [ 6525.815613] lr : bpf_prog_d53bb52e3f4483f9_F+0x38/0xc8c
> > > [ 6525.820832] sp : ffff8000130cbb80
> > > [ 6525.824141] x29: ffff8000130cbbb0 x28: 0000000000000000
> > > [ 6525.829451] x27: 000005ef6fcbf39b x26: 0000000000000000
> > > [ 6525.834759] x25: ffff8000130cbb80 x24: ffff800011dc7038
> > > [ 6525.840067] x23: ffff8000130cbd00 x22: ffff0008f624d080
> > > [ 6525.845375] x21: 0000000000000001 x20: ffff800011dc7000
> > > [ 6525.850682] x19: 0000000000000000 x18: 0000000000000000
> > > [ 6525.855990] x17: 0000000000000000 x16: 0000000000000000
> > > [ 6525.861298] x15: 0000000000000000 x14: 0000000000000000
> > > [ 6525.866606] x13: 0000000000000000 x12: 0000000000000000
> > > [ 6525.871913] x11: 0000000000000001 x10: ffff8000000a660c
> > > [ 6525.877220] x9 : ffff800010951810 x8 : ffff8000130cbc38
> > > [ 6525.882528] x7 : 0000000000000000 x6 : 0000009864cfa881
> > > [ 6525.887836] x5 : 00ffffffffffffff x4 : 002880ba1a0b3e9f
> > > [ 6525.893144] x3 : 0000000000000018 x2 : ffff8000000a4374
> > > [ 6525.898452] x1 : 000000000000000a x0 : 0000000000000009
> > > [ 6525.903760] Call trace:
> > > [ 6525.906202]  bpf_prog_c3d01833289b6311_F+0xc8/0x9f4
> > > [ 6525.911076]  bpf_prog_d53bb52e3f4483f9_F+0x38/0xc8c
> > > [ 6525.915957]  bpf_dispatcher_xdp_func+0x14/0x20
> > > [ 6525.920398]  bpf_test_run+0x70/0x1b0
> > > [ 6525.923969]  bpf_prog_test_run_xdp+0xec/0x190
> > > [ 6525.928326]  __do_sys_bpf+0xc88/0x1b28
> > > [ 6525.932072]  __arm64_sys_bpf+0x24/0x30
> > > [ 6525.935820]  el0_svc_common.constprop.0+0x70/0x168
> > > [ 6525.940607]  do_el0_svc+0x28/0x88
> > > [ 6525.943920]  el0_sync_handler+0x88/0x190
> > > [ 6525.947838]  el0_sync+0x140/0x180
> > > [ 6525.951154] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
> > > [ 6525.957249] ---[ end trace cecc3f93b14927e2 ]---
> > > 
> > > The reason seems to be the offset[] creation and usage ctx->offset[]
> > 
> > "seems to be"? Are you unsure?
> 
> Reading the history and other ports of the JIT implementation, I couldn't 
> tell if the decision on skipping the 1st entry was deliberate or not on 
> Aarch64. Reading through the mailist list didn't help either [1].
> Skipping the 1st entry seems indeed to cause the problem.
> I did run the patch though the BPF tests and showed no regressions + fixing 
> the error.

I'll correct myself here.
Looking into 7c2e988f400e ("bpf: fix x64 JIT code generation for jmp to 1st insn")
explains things a bit better.
Jumping back to the 1st insn wasn't allowed until eBPF bounded loops were 
introduced. That's what the 1st instruction was not saved in the original code.

> > 
> > No Fixes: tag?
> 
> I'll re-spin and apply one 
> 
Any suggestion on any Fixes I should apply? The original code was 'correct' and
broke only when bounded loops and their self-tests were introduced.

Thanks
/Ilias
