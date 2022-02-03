Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ACB4A8A1D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352882AbiBCRcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiBCRcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:32:50 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857B5C061714;
        Thu,  3 Feb 2022 09:32:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id r59so3059200pjg.4;
        Thu, 03 Feb 2022 09:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MrjU+6E5BVPS++BhfoyxVPlHu4UEo5Emuq7dEluOgI=;
        b=k11E0xJ3TLkprJZZIkz2M6uxoAFQGPFMRdU7tQUMnmKBOPYdlMGEzzW58G2rgSxgMm
         oUmP9vaDVMu/xQcwko3sxazHaZFhu+ScV7gTqTiZdP4//HYjdychHqtyBSdIvrv0j5Ht
         Wd1q+E6jcmVHQO3R0IoT9ZG7q4aBSdMyvXEXi7/cPqZft/xkTvXHaH+DW6rs33B4h4Xg
         JMkP0LCT9RQMPgp8xmRXXEM8BaS2k33H1MwcEKMOf4y1NQNd8gJyHAUgcfk3fWZG3Ntv
         TY81mv6rINWLbVVWT6jxKdJgaHgBG8hRoGr1ZjNvfua7q9deLghFERrIxvXNfgOc0aIn
         H9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MrjU+6E5BVPS++BhfoyxVPlHu4UEo5Emuq7dEluOgI=;
        b=KrUpAhVDbVwEoELMSfnm9QZSdSXwDfK3rET43t8HQVaTAvrtUjjIWd58Jx94/OinTO
         mulnuKOGhmuBvVdhmuGbG3xiZIsax3Dhd3Wl1GjJLnAtwCHQwbDlOTZzOtRGzAlBjr5B
         e2fK1mc+DvWk3aOCwLZGZZ4kX+F6UdpXXHygK5faaUwc3j4AjxY9l39f8nU6BLm/Oua8
         wJtk5nNN7F6UVva0Hx4J23JTfezD4pZFjdf4ZKN3m6K7JvxJTnCNPDb0u2Z3BNf2V8EX
         pQh1K8/+pQa0qm72uQwJBiom77l2lYB/TB/ZkWMazEuExpGTvMk2qMLqNEUrFuEFwONV
         RFXQ==
X-Gm-Message-State: AOAM531UQUiiEsYCYdGnKIz6ZSKlKt3IqLCmEhmwktwpyjJ3fhIj01zw
        xnab7EgAxw7YX8GKyLXLJDG06SgYL2rZUcwrFuyNHxytQ1M=
X-Google-Smtp-Source: ABdhPJz3RqmPsOiP/l/YGnFKWapOPqnj8IPmZH+XVR4VmaUUEJJAlcXtP1jPZymMFStmOSH5kcaNkIEAFD9YdUzbCAo=
X-Received: by 2002:a17:90a:d203:: with SMTP id o3mr15032687pju.122.1643909569987;
 Thu, 03 Feb 2022 09:32:49 -0800 (PST)
MIME-Version: 1.0
References: <20220131183638.3934982-1-hch@lst.de> <20220131183638.3934982-4-hch@lst.de>
In-Reply-To: <20220131183638.3934982-4-hch@lst.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Feb 2022 09:32:38 -0800
Message-ID: <CAADnVQLiEQFzON5OEV_LVYzqJuZ68e0AnqhNC++vptbed6ioEw@mail.gmail.com>
Subject: Re: [PATCH 3/5] bpf, docs: Better document the legacy packet access instruction
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 10:36 AM Christoph Hellwig <hch@lst.de> wrote:
> +These instructions are used to access packet data and can only be used when
> +the interpreter context is a pointer to networking packet.  ``BPF_ABS``
...
> +These instructions have an implicit program exit condition as well. When an
> +eBPF program is trying to access the data beyond the packet boundary, the
> +interpreter will abort the execution of the program.

These two places make it sound like it's interpreter only behavior.
I've reworded it like:
-the interpreter context is a pointer to networking packet.  ``BPF_ABS``
+the program context is a pointer to networking packet.  ``BPF_ABS``

-interpreter will abort the execution of the program.
+program execution will be aborted.

and pushed to bpf-next with the rest of patches.
