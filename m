Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA90494655
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 05:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358419AbiATEOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 23:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiATEOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 23:14:24 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B855C061574;
        Wed, 19 Jan 2022 20:14:24 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id h13so3601512plf.2;
        Wed, 19 Jan 2022 20:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zqcxYy7iwV5OyiHjWlpjXU1fz5t8Ectzi2BZCfiFr48=;
        b=NPpNGnStIyLtNwudLCOWrB9SVyk7aXAePjqUCTYBIpieLDPxW7J3O0VAzEeKJj6VqT
         xVOo3G2lzfU4dl3CFtYGI+yn9q4LnjG64xvDsopACyfcNC8IYw2D/+lesz8S2fXoukpb
         tGTJ/yLCPFp30xrAdqljpKnWNG6H6PSXodelI3MiJexUcSAYEwGsQSJGrEe0s+TjDOwL
         WFJqpEWR0UXeg820LBx16vwthOmL25uLqqbf5aaYLqW8UDHJPETesL0fAFAQzqWyXyfI
         0fE5MU0dsGDviAaR0BrKHMkGMIb7yK7TR5jAboUgU0857L4PeLkFOMT0tIP3uv3A0D9v
         76ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zqcxYy7iwV5OyiHjWlpjXU1fz5t8Ectzi2BZCfiFr48=;
        b=u00S97hy7F5kqqV2uX8uNjI1CVS76XgHDb5aYk07ZMp7nVrKF8U3q8TmCXW0IfmPz7
         RY7zK5yBjiTFPwPdplBpBDDlcfnAHVeawXYrhNVeMIK4eoK//qi0/DrxDr6CQSPkZvXO
         OFwugMUsA9B+Bwk47gc6v1Ezbu7YusdA/Rft5fFZgo+FzCG4H1hMQleH5nzQOGmBhKfx
         wSKV9qw6jeXL9zU06MZscxDYNxNK1Vc+ameD5r/S4o/9Ns839Ys0SUKLULiL0ecyEJCg
         7o7zN3u9j9ytukJoQ7Xa/rTrAx6i+YiMeiU9jDjhODtA9wTiRx5mfxK8ljqOZyYQv9WR
         Zy5Q==
X-Gm-Message-State: AOAM531qiZYvEsW/LKGl7F7YB+MIRG4rE7wL8ShFcTH7FnFdAUM4A1NV
        HEOa8Qq4jQdAzl8PtwKInS+vHrU7jjM=
X-Google-Smtp-Source: ABdhPJx/6+T51kSBHTFIAG/qo2tXUq+bL9zi5JdIR/vs3U+aGteylj3/iM3tj5xvKjDSI9HSuqHkzg==
X-Received: by 2002:a17:90a:8b95:: with SMTP id z21mr8406149pjn.29.1642652063947;
        Wed, 19 Jan 2022 20:14:23 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9dc9])
        by smtp.gmail.com with ESMTPSA id nl17sm744986pjb.43.2022.01.19.20.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 20:14:23 -0800 (PST)
Date:   Wed, 19 Jan 2022 20:14:21 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, peterz@infradead.org,
        x86@kernel.org, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Message-ID: <20220120041421.ngrxukhb4t6b7tlq@ast-mbp.dhcp.thefacebook.com>
References: <20220119230620.3137425-1-song@kernel.org>
 <20220119230620.3137425-7-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119230620.3137425-7-song@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 03:06:19PM -0800, Song Liu wrote:
>  
> +/*
> + * BPF program pack allocator.
> + *
> + * Most BPF programs are pretty small. Allocating a hole page for each
> + * program is sometime a waste. Many small bpf program also adds pressure
> + * to instruction TLB. To solve this issue, we introduce a BPF program pack
> + * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
> + * to host BPF programs.
> + */
> +#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
> +#define BPF_PROG_MAX_PACK_PROG_SIZE	HPAGE_PMD_SIZE

We have a synthetic test with 1M bpf instructions. How did it JIT?
Are you saying we were lucky that every BPF insn was JITed to <2 bytes x86?
Did I misread the 2MB limit?
