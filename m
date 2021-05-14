Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CA7381426
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhENXQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENXQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:16:20 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CACCC06174A;
        Fri, 14 May 2021 16:15:08 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id v5so303795ljg.12;
        Fri, 14 May 2021 16:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKkuYFz+D7z9ALsJV2h5u+d4OHPvwCtJvVkQFBZnoxU=;
        b=J72ITAt5n5xqaKNyspcgrVTqLB5IPA/PLwytakAsQBXiDvjZ9D4xALUTk4hqiNPi+A
         DzsRk+1p4mAl1H3SB8x43304MEf1bXu+1DjGjg3vAzKgmBr4nkjnb+t/BufnvVThU7KV
         pOmQq59GzoA3LURHu4eKUT2m95FuJrUYt4YYlfi6OJckPOj78TqiT/Lc5w2cFwl9WoaH
         sKrpSlamUkx+u34WgWNT4kuqDUUqSP8q7pk1o92JWsqfWm5nMt6wuUItccM7rT0UK7Lr
         pjOubEAHKOor+lpfwqHgbE8FViXTl2AaPa5w0vAjOrP/GDMq2riCbtN+KGLlHSF+98Oc
         qBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LKkuYFz+D7z9ALsJV2h5u+d4OHPvwCtJvVkQFBZnoxU=;
        b=kiWIBOlaMIwRzniXlgakI8iQvZnV2Uo80GQM50cMQSV22bvfiZdQL7/5V4u6RO2ZpU
         QXSosUHvHLAifOVnLNdS3nEZeigZAwxBzKk7KE7hyQL5jyzjImTI0IVBbP2qXF0SyWie
         DAhlVLcrDONUWcBX52s4NAIsP9Q2lFYQnnj8wUy/ln/lowemlIzXcAy4awTh11cX8jWG
         Bt+sHWB/SM+6iDH0+6pI3EXauI4lH5HdXrxDe3tnHmt5GIF2HrSDNNrUeiXDzV15/a+o
         4xHjb8Crk16R4XdFXEuU/4Dxk0ZBkgx9G2NvccF7pR6qVjsLBZq4RnLU6o/h75t763Np
         3ldA==
X-Gm-Message-State: AOAM53249Alm+j5RkETV48XwQzeo5CJdpvxXem7UF7+QDdiEBPUGQPib
        2f1d5cfGZj/zlANabcb5uzht2OftiFygWIu9QmE=
X-Google-Smtp-Source: ABdhPJw9cnQ3Y5D9IHCvb9qbh1tYmXXFqH6uk+nEbqEheGVo4YeMIx10RHS5LdfvCGQgpvSFGRK6OhiZZsOfztUF420=
X-Received: by 2002:a2e:98d6:: with SMTP id s22mr38300373ljj.486.1621034107139;
 Fri, 14 May 2021 16:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210514180726.843157-1-andrii@kernel.org>
In-Reply-To: <20210514180726.843157-1-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 May 2021 16:14:55 -0700
Message-ID: <CAADnVQK7wM9g7_xjM1bLTS7fUWmiUVO1-S6qe1-zQptKV7z=ww@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: test ringbuf mmap read-only and
 read-write restrictions
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 1:11 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Extend ringbuf selftest to validate read/write and read-only restrictions on
> memory mapping consumer/producer/data pages. Ensure no "escalations" from
> PROT_READ to PROT_WRITE/PROT_EXEC is allowed. And test that mremap() fails to
> expand mmap()'ed area.
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Applied.
