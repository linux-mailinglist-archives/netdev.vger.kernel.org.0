Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96461493DE2
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352049AbiASP7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbiASP7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:59:54 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4A6C061574;
        Wed, 19 Jan 2022 07:59:53 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id v123so5959884wme.2;
        Wed, 19 Jan 2022 07:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+vOb5yHTUTgHDDJX2OrXL/1O2I+8ETIcPsDexqsYa1Y=;
        b=fYraz93MX4Xg4NtOpfPQ59K9zOTiqFaT0QfJNRUzZde4KwXyKNXQvByB6IiFd7oaIl
         hV5QVjpdZBq6KWaOnHRlZui/ponpmAj49JbWd1Q7uGx/4H9BsrNEyngiok+2pDjp7kPz
         A7+je10EtD2nsoGw0WQ7BxkzTCWskyvqecMmZbKAw9Z3bHd+uh0oDfxzDX1BKyFir8Da
         YqgQ3KvlO0VJwTsi7XrNWKoSU18rZGG2hOQ+AqqHiLZrl5eHZG6uTQC7fYzlOCCe4unT
         oH+djtM/VcPzktfiXU8ICsIsHRWVl2iRHUlW8cvM7sr0bXAgJZMr40qeyZsjqG0rWbRe
         oJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+vOb5yHTUTgHDDJX2OrXL/1O2I+8ETIcPsDexqsYa1Y=;
        b=eZ0e7c4lkujIK0pbYrDB7t8WdpPDJcnZ+OUJagCLVg60fQLYUnOkiyhWh7zaobEDak
         XjjA4069K5Nn5nYg8bjkbVDSdabjNTFYYdwaI2CEyMvo1N2uMTQKQtBrRqprLWuU+MCf
         brlrrwSSRBuyyZmzCzWpyn2ifhyvaMJOFRgv3mIcoPz24YZdkyzrdIAsptTM5v+REeCU
         QQ8o93tylFW6S7vHvwbRSNdayTgl97RdqsdDvj2rc/OC6l02O6L/6cJ4L10GDvrx0O/8
         ThkM9vT/8ZaHcuIIz61S+t4ZcaVpKVRWX+IXdT5F5Ph1yw0l3WTHtzTnT+nELu2QPkvG
         0sXQ==
X-Gm-Message-State: AOAM533xjBP3BXkWFDE4350gkmUlpRiPpJXk7TbzQ8mqoRlixjk8Ui6G
        RzKbpRlcsqjWgsvYCUXRSRoOJvP7oA16706r8wQ=
X-Google-Smtp-Source: ABdhPJxllMHmNdo+PnzLV4B/leNYKBD0RcLgdBJ9d7U41dzillp07VzmjbjOGDrtTBkD7GmO0emmpFkyrOxTSsLuAH0=
X-Received: by 2002:a1c:f70d:: with SMTP id v13mr4222288wmh.133.1642607992553;
 Wed, 19 Jan 2022 07:59:52 -0800 (PST)
MIME-Version: 1.0
References: <20220110165208.1826-1-jszhang@kernel.org> <Ydxljv2Q4YNDYRTx@xhacker>
 <CAJ+HfNiS7Ss0FJowPUrrKvuC+1Kn9gXb=VqNoqh3eWJDu=m4Mg@mail.gmail.com> <1b104397-8cb7-c5c2-92cb-11ce56c9a8de@iogearbox.net>
In-Reply-To: <1b104397-8cb7-c5c2-92cb-11ce56c9a8de@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 19 Jan 2022 16:59:40 +0100
Message-ID: <CAJ+HfNikH3OMH_b3=uvfSqAJZkjJabn9yipbYdnTxsh_=VDHOQ@mail.gmail.com>
Subject: Re: [PATCH riscv-next] riscv: bpf: Fix eBPF's exception tables
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, palmer@rivosinc.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tong Tiangen <tongtiangen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 at 16:42, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
[...]
> > AFAIK, Jisheng's extable work is still in Palmer's for-next tree.
> >
> > Daniel/Alexei: This eBPF must follow commit 1f77ed9422cb ("riscv:
> > switch to relative extable and other improvements"), which is in
> > Palmer's tree. It cannot go via bpf-next.
>
> Thanks for letting us know, then lets route this fix via Palmer. Maybe he=
 could
> also add Fixes tags when applying, so stable can pick it up later on.
>

It shouldn't have a fixes-tag, since it's a new feature for RV. This
was adapting to that new feature. It hasn't made it upstream yet (I
hope!).


Cheers,
Bj=C3=B6rn
