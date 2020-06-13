Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC07F1F80C1
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 05:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgFMDpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 23:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgFMDpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 23:45:10 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B250DC03E96F;
        Fri, 12 Jun 2020 20:45:10 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 23so5212723pfw.10;
        Fri, 12 Jun 2020 20:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=08H7c2856vXPBHxCfukV73+cjVEFVJ7Byba+IAoJiWQ=;
        b=B5P95fS8DQkB5ezZOpu/jiegMflrQkLT7wAupybYKM6E8fA0HvmaDJxPdWxKwBgHUi
         5B+ZICBe8sZsQjymoUuStOijUC25JC+1jTYHS3JWn3yR+j6OxFJcV/Su/aF0DTBGT/bt
         xn6K7rECZnrcNqwUvLmsnGjBVqG1xGFf96K59A7G2hX+YWDJ4vTGPfAXe6Mcnv8YG5rt
         umN9xNFDvk0gxSSGQ3EroV3OFQRJXvTu9ef2T9WawSgCrNmaOd/YKCJqGkyM5VeJEgtw
         N1bOzVcssMOGcuXdms/PvxHT0NLbgJGORcuqr4KT2+tg2lc14R/AytalBApRN6YiM06Y
         ARoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=08H7c2856vXPBHxCfukV73+cjVEFVJ7Byba+IAoJiWQ=;
        b=KPxRxGQwpw+GgEcHYJhgo65a/1r/ckHjBYpIwBIF0wrO7P0xTyc1PCjTxbWSatlu7C
         TSApOfCOxekMQCAW5+I36uS7YW7ZoVDBPGzhLwBMtPXbkdDrk1dxlhWvqaPZdPnNuJLf
         dS3UOTVNTtAUOcZXGfl2S8jUH4TMO5HFYVEFTy1T8oZaQL0IwZKLQ2I/kp3SyoTpaRTy
         56slo467ckDNKUO6mJGl8Pr6YGnWC08JyH2sht1o6eYqpNFQUHF+8vAmq0MvFxLUBo2R
         LS5Y7maQ4sHHJdUQmNue6znV4E6S4khd1NK9LFwP7VDcLmUUdEbENkJ0P6pTeDiycbBM
         OsIw==
X-Gm-Message-State: AOAM532EHjypZGqsX3x7yjuOLcuaAr7PD8MvTQRq11neT9BHGD4c0ofi
        x4rJ+gf2X3AeXOL5nbmvtc0=
X-Google-Smtp-Source: ABdhPJxjWOcNdjnPdHnDkxreXUWtexy/v3hOi/EQJilP42FjJoMmZkwwNbiFzGqMtBxnse7ELzUOIA==
X-Received: by 2002:aa7:9910:: with SMTP id z16mr13831845pff.53.1592019910249;
        Fri, 12 Jun 2020 20:45:10 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9709])
        by smtp.gmail.com with ESMTPSA id r20sm7854683pfc.101.2020.06.12.20.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 20:45:09 -0700 (PDT)
Date:   Fri, 12 Jun 2020 20:45:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: Re: [RFC PATCH bpf-next 8/8] tools/bpftool: show PIDs with FDs open
 against BPF map/prog/link/btf
Message-ID: <20200613034507.wjhd4z6dsda3pz7c@ast-mbp>
References: <20200612223150.1177182-1-andriin@fb.com>
 <20200612223150.1177182-9-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612223150.1177182-9-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 03:31:50PM -0700, Andrii Nakryiko wrote:
> Add bpf_iter-based way to find all the processes that hold open FDs against
> BPF object (map, prog, link, btf). Add new flag (-o, for "ownership", given
> -p is already taken) to trigger collection and output of these PIDs.
> 
> Sample output for each of 4 BPF objects:
> 
> $ sudo ./bpftool -o prog show
> 1992: cgroup_skb  name egress_alt  tag 9ad187367cf2b9e8  gpl
>         loaded_at 2020-06-12T14:18:10-0700  uid 0
>         xlated 48B  jited 59B  memlock 4096B  map_ids 2074
>         btf_id 460
>         pids: 913709,913732,913733,913734
> 2062: cgroup_device  tag 8c42dee26e8cd4c2  gpl
>         loaded_at 2020-06-12T14:37:52-0700  uid 0
>         xlated 648B  jited 409B  memlock 4096B
>         pids: 1
> 
> $ sudo ./bpftool -o map show
> 2074: array  name test_cgr.bss  flags 0x400
>         key 4B  value 8B  max_entries 1  memlock 8192B
>         btf_id 460
>         pids: 913709,913732,913733,913734
> 
> $ sudo ./bpftool -o link show
> 82: cgroup  prog 1992
>         cgroup_id 0  attach_type egress
>         pids: 913709,913732,913733,913734
> 86: cgroup  prog 1992
>         cgroup_id 0  attach_type egress
>         pids: 913709,913732,913733,913734

This is awesome.

Why extra flag though? I think it's so useful that everyone would want to see
this by default. Also the word 'pid' has kernel meaning or user space meaning?
Looks like kernel then bpftool should say 'tid'.
Could you capture comm as well and sort it by comm, like:

$ sudo ./bpftool link show
82: cgroup  prog 1992
        cgroup_id 0  attach_type egress
        systemd(1), firewall(913709 913732), logger(913733 913734)
