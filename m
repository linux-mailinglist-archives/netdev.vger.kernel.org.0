Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A654423F0
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhKAX1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhKAX1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 19:27:04 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E81DC061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 16:24:30 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so37639156ybe.3
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 16:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ggSHlCrQCs2wUhPdxNDjlfERNOIgIZzyh2NOuaU1Ts=;
        b=OVxuY9fOTGg+qApCC+TaxzcU/jD0JJznLcwzcqNusPBGBQcZ9N0aKrjvaL/QzA3pN1
         Z7q9OMazMHjyFZIvmwcFgIcpVRko9qK6tsG9cVx8OTNpX/hcqAtq0SgdgSjz934OYugC
         Vhw2930ZzjI/SOScVyi7ZebwxJH00JioPS0yN4HPuaE4EAN3USj+zCVUoGQaGV2mKPUF
         g5sP5qVLrOOv/SHdrE3CC9x78yqLymRUy1fUSHDUR8r7YNbijoj/eVDot8L5r1rxoCNo
         /pBR7DWm7WQ7ZzO5n7FyWZNH6DbSyHAcU0F86t+BPN3enMSjGkflTSX2skN6KJxBp/9H
         t+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ggSHlCrQCs2wUhPdxNDjlfERNOIgIZzyh2NOuaU1Ts=;
        b=4GV8ZcKPH4ZftbmtxUC9C4PuCgXprc30oydGEJhASG+qgsd6WU4DL+fL6gRgWY+2n8
         UeTc8iD85WKhj02oHsB1pkA7fzb1fxdVoEKRE1rgc3IahM6ks0DG9RBGUB1KZWu7AcyA
         nHk700mBqgnKerq3+tmqKJwB+SJ+7qtdfCve0qOERzZGKHEOlUj3MgbsHrBacsFPewOp
         ZJm1svnknXb842Cr42QmpVLgSIgD7Wt45QONN0J5C2R/T9OlMRcwauRU9itdSkWPqZ4c
         nBy85FgAX1zFwPeVqy0eT8FjlJCzpiwtI+/+N+w1zSDWi1zExWyd/XhyNBVcK1NelJD2
         9uOA==
X-Gm-Message-State: AOAM532jNmO09VZiyjeo+/4OVqS5yFTw4FimG9OUHVssUKJx5EYaonb7
        rxU0tIIZqprKL1tjclsohFfETXNX3DARVFEfot6vVw==
X-Google-Smtp-Source: ABdhPJzHaU9ML/TNh2KjnLTgymkY8gzN7MLN862Kj7BqMuXraXhyR2CD6s4ku+s0007894pG1QHsDlAtpH2e0IhR2fI=
X-Received: by 2002:a25:d010:: with SMTP id h16mr25468218ybg.225.1635809069055;
 Mon, 01 Nov 2021 16:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211031171353.4092388-1-eric.dumazet@gmail.com>
 <c735d5a9-cf60-13ba-83eb-86cbcd25685e@fb.com> <CANn89iLY7etQxhQa06ea2FThr6FyR=CNnQcig65H4NhE3fu0FQ@mail.gmail.com>
 <CAADnVQLLKF_44QabyEZ0xbj+LxSssT9_gd3ydjL036E4+erG9Q@mail.gmail.com>
In-Reply-To: <CAADnVQLLKF_44QabyEZ0xbj+LxSssT9_gd3ydjL036E4+erG9Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 1 Nov 2021 16:24:17 -0700
Message-ID: <CANn89iLhta9E+cucGOTDNLtqXF=Mrxem=Y6wthh2ODhnALrqoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add missing map_delete_elem method to bloom
 filter map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Joanne Koong <joannekoong@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 2:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:

> I rebased and patched it manually while applying.
> Thanks!

Excellent, thank you Alexei.
