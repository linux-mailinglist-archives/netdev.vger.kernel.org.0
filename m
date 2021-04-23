Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671B2368C33
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhDWEag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDWEag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:30:36 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CBEC061574;
        Thu, 22 Apr 2021 21:30:00 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i4so16606118ybe.2;
        Thu, 22 Apr 2021 21:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VNw6Y3HD8g44N+W+fbmSKir2llbxu/M6pfVUkwve3Ws=;
        b=ndxqgdj3xu2yc9H73/qz+QU3DBWml2A5OejZ/A7eX2+yB+zPpNTBtqLLqDAqtCmzWj
         BYVE28U6gOngZd5w/uiZmr8ZjbITijR/LQGwbqVXTuHNqDC27sVFNKIEoFuCW6LIw0R9
         f8vVMQGBtTm/vdeBakJ+Aqi5TSGYbWBh2PLt3SCjYp9tL7bLot8J3WQzGPkYqjV/EwL8
         uI0XpNU+4eEkNAD9rjaigmcCkUGzpKzJehkEbzJKyjO49etsc4gI7xRCd4tMVI12x1Yg
         aBvazPIPjo6ukCA1NUh4ebl3aUB+wrnM9S2HfxqjMEwO8ezrZzoAiJkOV1W2LOtwrFPq
         EPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VNw6Y3HD8g44N+W+fbmSKir2llbxu/M6pfVUkwve3Ws=;
        b=cf9locNIaMAQ7tVEdncu677wa2W5ToHpZDIujfICT//U8bU5r/GpXuHvM7nrwMSSqn
         L0/30DT/sZD9HtnfpL5MO5urXl7BEPsxD2Udn+FcBvQHVNhQGEGVZk/VX9GUssWNjSAP
         NZAxMcAmDfTjimmB/WyjQZPS/OFe3J3hciLe45/G4QC8EE1XxdBuj2wnl35t0Xqrm6MW
         bi/maRvXRXuje/ZodzRhsQM67D/leXAc+BvUpajLUnmOViy9oyPOwzGh0PZvR0gFPHG1
         yfkOI3smbbLlH583DL+pVXFCot+pkevYzw/PZXy/L8ijxr4XsZv7EqGXE+NVhlCzMAf8
         lU0w==
X-Gm-Message-State: AOAM532JrvoRRDPM3kDTFkLfLt4Ztl0DxUrn0K8DEvqgPwCSsGLdPBZK
        oMjx16QfmmattOsFnP6m4S+UtXDNgO0EU2Yn9Lj0i8Gg
X-Google-Smtp-Source: ABdhPJymSkzEqCu6UpPAO3Rz6rTn9dpVpai5fIyhncZ2ITxss+ON0MZSCg0fHs/iWVCndsG6mG/19DABEpogRrbsRMs=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr2598864ybg.459.1619152199957;
 Thu, 22 Apr 2021 21:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-16-andrii@kernel.org>
 <3947e6ff-0b73-995e-630f-4a1252f8694b@fb.com> <CAADnVQKjasq6sf_AFjGOkoWCeZ5_SJTYzuvWb_byHe32FHS5Vw@mail.gmail.com>
In-Reply-To: <CAADnVQKjasq6sf_AFjGOkoWCeZ5_SJTYzuvWb_byHe32FHS5Vw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 21:29:49 -0700
Message-ID: <CAEf4BzZQnX7DWBZTKqtk5v0apRoKy4rUMKTm5GXrbQc+q35a+g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 15/17] selftests/bpf: add function linking selftest
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 7:35 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 5:51 PM Yonghong Song <yhs@fb.com> wrote:
> > > +
> > > +/* weak and shared between two files */
> > > +const volatile int my_tid __weak = 0;
> > > +const volatile long syscall_id __weak = 0;
> >
> > Since the new compiler (llvm13) is recommended for this patch set.
> > We can simplify the above two definition with
> >    int my_tid __weak;
> >    long syscall_id __weak;
> > The same for the other file.
> >
> > But I am also okay with the current form
> > to *satisfy* llvm10 some people may still use.
>
> The test won't work with anything, but the latest llvm trunk,
> so " = 0" is useless.
> Let's remove it.
> Especially from the tests that rely on the latest llvm.
> No one can backport the latest llvm BPF backend to llvm10 front-end.

Sure, I'll drop = 0, just a habit by now.
