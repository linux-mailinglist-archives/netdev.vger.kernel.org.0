Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7975B417785
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 17:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347143AbhIXPaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 11:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhIXPai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 11:30:38 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8398DC061571;
        Fri, 24 Sep 2021 08:29:05 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y12so1338019edo.9;
        Fri, 24 Sep 2021 08:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CQ4WoixwfLVdKjcnesh6NOhR1rMTQv8BrkQ4NsoRsXs=;
        b=OXc/hyI9GTCK+r2jZvfkIM60vIrZpMtC9u++J3SvEMaAQRrQ5m7fIAlo1oqy7psWdO
         u6TWGc77Nr3VHocHKcnAevVn2p2Ub19oWQrRpnih7yfCyR8YsyBjXveqsyaW9btPh3qw
         0MeaQCqw1xFoZFMDAVMBFsEZqCH3XeJEXszzNBGLcbHVHgxaZtS9t97BwchXzjh87+pn
         2MpRjZntoZxlgwVhYUebJ+CoQS+E5fv7kZSqrX1AIV/GUKXcO7Qnr/FZevJAubjUj0oK
         bL/CYLX0y/VadO6EydhFGm/K8vc3FNw7CUjgzzH38+JvEJNSheR1d3ecPpSID0rfoASS
         Y+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CQ4WoixwfLVdKjcnesh6NOhR1rMTQv8BrkQ4NsoRsXs=;
        b=a8e8dpb8NCulhx58amf8EiGMikNarPes8QdPQFTq00HJ0so29vSeZrT6DWHCqLQEc1
         /kBudRmrx10RpLMqSp8qR4OsJoDXE5zROPFStOt6r3c5a5umyMRayhTHYpMmE0WLO43Y
         stJwkKmy4z5FD/X1V47lsclwXWanPgRCw0JmeeFSVmIltxUOs9zm8lnfjBZieSvcghJW
         vsoff9RiN6Fu/3HzPgWH04iCr91ssggPzr6MlxA8y/uiVurf0M2pRJU4e2klm6CjwZ78
         JkNjRmQGFtuQ0z/Gfldo3DKGIYXJBPKL1Avz/w1bwfMSop242/+0SzWQebLNOMrz/ME4
         bS1w==
X-Gm-Message-State: AOAM530vYj/TiCiOcGEOLiqkAabR2aryS0gZWgWqk344ZfSRl6Z2YqPt
        amZydyPQBMg9HkmD+vjeS5JbpQinsai5CmSGzrs=
X-Google-Smtp-Source: ABdhPJx9Y0/DcbZ4SRmB6bUv2OExliUvt7b048hk331CiDBjNZuDrACJzzX6fRthwZYVv1rbZUpHKUdHO7EpdHOvxOM=
X-Received: by 2002:a05:6402:21d0:: with SMTP id bi16mr1975909edb.124.1632497344106;
 Fri, 24 Sep 2021 08:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210924095542.33697-1-lmb@cloudflare.com> <20210924095542.33697-2-lmb@cloudflare.com>
In-Reply-To: <20210924095542.33697-2-lmb@cloudflare.com>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Fri, 24 Sep 2021 08:28:53 -0700
Message-ID: <CAB-e3NQNkzcv6hNW1ga0Zhi_DcUVr2Q88WaE1m+CCXtKhHQcmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: define bpf_jit_alloc_exec_limit for
 riscv JIT
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Expose the maximum amount of useable memory from the sparcv JIT.

sparcv -> riscv?

Otherwise lgtm!

Acked-by: Luke Nelson <luke.r.nels@gmail.com>
