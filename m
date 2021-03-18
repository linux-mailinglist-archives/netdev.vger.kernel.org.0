Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAB434110B
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhCRXaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhCRX3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:29:40 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D36FC06174A;
        Thu, 18 Mar 2021 16:29:40 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g8so77329lfv.12;
        Thu, 18 Mar 2021 16:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cy+rrkQs0Qr+vGmmlG1ZA0b+m1HoY6q+PPmRxSjpg/U=;
        b=QysK1h/FX1ErKlxnrkatR1e7plIVYHmb9UOfTirYlXnoq5kJl/Qe/WBPTJ0Zdjq2L/
         bMKXBe2oHiPlKAToLMG18SXzPceMCLKPUVwysj4U61lJB0+mocwk1WkeXiGyDBRcKb00
         uoLM5p77dl3fYykVYAXDEeIMQ2Esyd1nubu0q3UMqfdY7R1EU4cxFeKnjKULm3v22xqd
         RPSMVAuqTKxbsNOyaScnW1oXPBFGakqhGZJWtZ/MoSrqQ8miQ5GcgsTR+Tvl40eQz37V
         nvv3jMzF4zkl3BVXHPpXbeG7ZFSFBAhy+mvMKUnXU8A29gvthyKXPblcF80HwTLQ7DAg
         ljJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cy+rrkQs0Qr+vGmmlG1ZA0b+m1HoY6q+PPmRxSjpg/U=;
        b=mIdGpUnD0JdNiTfd3oIL2HDnDnbNWSNeUQyebtaYFh7OdlgrGpRy2uvrrKFdSbGxAK
         CfZtSWeAvlZRl8/AfLUV3e6MgMnUoANG3Wlb2fux5C6lAi7e5mYtoL7BII8b3+S2twN1
         SIhP13DO0yWvUEeCpzzNjf1y8XyqeBjzVfvOKk72O7VFGhBuM6fcTx3LfSq6tVpnjZJp
         9A68J7dv3rKZV2M0fUYdDuJYn3v5qhvurxvNN4jF5TBZbX3oQMAKuaMN1Q0jnTTeGklS
         6yAsyLy/j/RcGpN3rFGcY5pSS/JxZon6VTkU6Wcn2YzkhqO96ObO9pmKuj5EcQTee7Q3
         PlSg==
X-Gm-Message-State: AOAM532f303q2fjqZ7W0KdqqiFmSKbktr7p8hYMVQLj9TM4Jc6EbP2GL
        0afoSTuSGUTaPddZcFNalLy/JJidOSAJhJlKJbL9u+uZ
X-Google-Smtp-Source: ABdhPJwuxmJl7BoIQctVlbFFc3Y3g1W54VhDxhxTnR0jsayF+8mJggiR0NpqDfu3u/C+hRDYAcfzhy50RQ1nRLozTZE=
X-Received: by 2002:a05:6512:2254:: with SMTP id i20mr6871946lfu.534.1616110178838;
 Thu, 18 Mar 2021 16:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210318194036.3521577-1-andrii@kernel.org>
In-Reply-To: <20210318194036.3521577-1-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Mar 2021 16:29:27 -0700
Message-ID: <CAADnVQ+scK73Y194eUpRAJ9_gbOPgQ9Peo05F2NAkGv5EJAJ+g@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 00/12] BPF static linking
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 12:42 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> This patch set adds new libbpf APIs and their bpftool integration that allows
> to perform static linking of BPF object files. Currently no extern resolution
> across object files is performed. This is going to be the focus of the follow
> up patches. But, given amount of code and logic necessary to perform just
> basic functionality of linking together mostly independent BPF object files,
> it was decided to land basic BPF linker code and logic first and extend it
> afterwards.
>
> The motivation for BPF static linking is to provide the functionality that is
> naturally assumed for user-space development process: ability to structure
> application's code without artificial restrictions of having all the code and
> data (variables and maps) inside a single source code file.
>
> This enables better engineering practices of splitting code into
> well-encapsulated parts. It provides ability to hide internal state from other
> parts of the code base through static variables and maps. It is also a first
> steps towards having generic reusable BPF libraries.
>
> Please see individual patches (mostly #6 and #7) for more details. Patch #10
> passes all test_progs' individual BPF .o files through BPF static linker,
> which is supposed to be a no-op operation, so is essentially validating that
> BPF static linker doesn't produce corrupted ELF object files. Patch #11 adds
> Makefile infra to be able to specify multi-file BPF object files and adds the
> first multi-file test to validate correctness.
>
> v3->v4:
>   - fix Makefile copy/paste error of diff'ing invalid object files (Alexei);
>   - fix uninitialized obj_name variable that could lead to bogus object names
>     being used during skeleton generation (kernel-patches CI);

Applied.
