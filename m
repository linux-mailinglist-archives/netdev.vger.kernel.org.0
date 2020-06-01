Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221DB1EB0C3
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgFAVM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbgFAVM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:12:58 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CC7C061A0E;
        Mon,  1 Jun 2020 14:12:58 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u16so4798743lfl.8;
        Mon, 01 Jun 2020 14:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bdfV7GUP5TCqvH7qv4yCi48eKDLW8o1xL5OiHDqPivc=;
        b=duZk6zb0VzaAqzxB2vTJ1E6/E7Uz1fmoj/2YDfQOb2fshthxhd7+SMfUS/R/shJCUF
         q1e0WLikhKk/vn6fSRg3fguGIgFlPxdXp2fTDAYvdDzPLmCofqXvzhlqHBDC59qcaXqo
         JqQI2zKfqubtKupOcaycZ5xmyZMxzmOpzmMo0YRRzjmRty4fxlG/gJI9pAgS8/HWyv5D
         KDpWBk4aP5bi8O9xtYuAMsnKb+9t6KahZEjttLOogXZ1YEV+z7yWuuxeuhXPDdiwJur0
         5FMsVOLJUsPTJt0nXpkX+5ODVRYoazMKOBb8UUwQJ24r3ol6ibfCGQmlCYDHJxgL6/OV
         iNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bdfV7GUP5TCqvH7qv4yCi48eKDLW8o1xL5OiHDqPivc=;
        b=AhfWOANpBtb+s4j8cAE10yxLDv2t/vj79r6I45fPQcHXfKhjC7uQe+B40WguuHIAnt
         tZJt/RavlpGChcJcwIBqllVjbp94XFgLFHUoMcVM864kCkcX/zMs+P2HRqwdhdtI6vtQ
         ej5C2zMkEF1nJbl0A/5GZ+3LJW/qHewlEnM4z8QzVE+2DouCTjGU9J5VwzlJDQwGjezl
         vnDHRUb4RcF//Y/Vu8HanTt/fOdqIehx0OZWSaTCZHQ4mcAZvzUw2GxYDN85QAWXBXR1
         WCPVN3ps69lqyYTIgaU1uMy3x2pYZBnjSNUSMN8/Q6g2+BkU1Nqe7+NXe/TvcBTB4m2z
         88hA==
X-Gm-Message-State: AOAM532CTmBhUzDs6gYodOu2tBHtdK0LfYUQTxC12d+p3vsyoIjt+FV0
        Ajt/k5AWDCgM+UCru92Gt7uS0x6kA23fjJMh8Zc=
X-Google-Smtp-Source: ABdhPJyFLv/wAOqjDSDPWR9AdT465ubtHE5HIqPjb1rQzLWG/5OPHNfGfnFqDASm8d2+XI/Ht5mgaofzIl1AnqgolGE=
X-Received: by 2002:ac2:5f82:: with SMTP id r2mr11720389lfe.119.1591045976691;
 Mon, 01 Jun 2020 14:12:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200529220716.75383-1-dsahern@kernel.org>
In-Reply-To: <20200529220716.75383-1-dsahern@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 14:12:45 -0700
Message-ID: <CAADnVQK1rzFfzcQX-EGW57=O2xnz2pjX5madnZGTiAsKnCmbHA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/5] bpf: Add support for XDP programs in
 DEVMAP entries
To:     David Ahern <dsahern@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 3:07 PM David Ahern <dsahern@kernel.org> wrote:
>
> Implementation of Daniel's proposal for allowing DEVMAP entries to be
> a device index, program fd pair.
>
> Programs are run after XDP_REDIRECT and have access to both Rx device
> and Tx device.
>
> v4
> - moved struct bpf_devmap_val from uapi to devmap.c, named the union
>   and dropped the prefix from the elements - Jesper
> - fixed 2 bugs in selftests

Applied.

In patch 5 I had to fix:
/data/users/ast/net-next/tools/testing/selftests/bpf/prog_tests/xdp_devmap_=
attach.c:
In function =E2=80=98test_neg_xdp_devmap_helpers=E2=80=99:
/data/users/ast/net-next/tools/testing/selftests/bpf/test_progs.h:106:3:
warning: =E2=80=98duration=E2=80=99 may be used uninitialized in this funct=
ion
[-Wmaybe-uninitialized]
  106 |   fprintf(stdout, "%s:PASS:%s %d nsec\n",   \
      |   ^~~~~~~
/data/users/ast/net-next/tools/testing/selftests/bpf/prog_tests/xdp_devmap_=
attach.c:79:8:
note: =E2=80=98duration=E2=80=99 was declared here
   79 |  __u32 duration;

and that selftest is imo too primitive.
It's only loading progs and not executing them.
Could you please add prog_test_run to it?
