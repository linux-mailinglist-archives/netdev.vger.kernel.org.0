Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B376627CE
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389215AbfGHR60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:58:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45018 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729052AbfGHR60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 13:58:26 -0400
Received: by mail-qt1-f193.google.com with SMTP id 44so15059000qtg.11;
        Mon, 08 Jul 2019 10:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DXpdoTfcMjqdZs/kMrwaOv0ehGSPPA6c8mOe+DaQM6A=;
        b=fK/eF7tTQHTpoWKBc82dbKoNvCfA3uxxH5nAW23leewCt0vW3JIgNJSEM0h9+edkAD
         hn5or9/VENE+iEZ3CTr0QCC4O9tYWsiNynwR2PfPy5PyzxDYpFbbSA+O/qZySDUgqe9M
         PyxJokqh6/N+Mn0AG/gk/5fWXL8PcGgzpcycCDu0o3jfXo6AtOszI5BzCPNlSE9+dWdI
         +mC1SCdUCR5BLG95nqMt+eMQdjqXqY1yL07D9Kw8c5E1gMeABFu2LSxRpZ9E4srOpfbn
         QZy084U1+WlJfEyCLohrVnEVVnBpc/zSpoIVqXLEwtv6vXW6LOnjiUCSy3dTezCuiFQf
         wNDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DXpdoTfcMjqdZs/kMrwaOv0ehGSPPA6c8mOe+DaQM6A=;
        b=ZlcESWpxD/AQamGlcl1PhS8zYiURwz38awIFps7D04Sbedsn05eeI/jUGbcDSSjEPi
         zItMtQdnLS+Lop+/y3DGP2XOnADQy8F8Pwo1cKMKC3FTpkSB9zx8m4ve4vsrYxJJTBU8
         XB5Lzrj6zaR4rw/HBKRQfXSfgY+Z3/yXvh11SiYjisKJqdipz5T+sRVKJ5Bp9mf/W8R2
         Pd0hm9T1WA/M94lwPOLD5urDJB18ruqmbQ+3jCNNLFcqTeUT4oyazPvfly3ci9uBzuEV
         dAw9iZlInvELmB++wkphQ82ZTTS2W1S5t4mPz35vcYu767tlAfqgFQe782jfVyXlBMcu
         BUwg==
X-Gm-Message-State: APjAAAWNpQFdP8s2iTV78JyMauaE0fuLBhl+5sX7PxlY7dzP5dgtItAy
        VK1PLJB5DjcTUFHsbJ1mJwQ6QNxzO8oyaCvFCfINUuozvUM5GVbd
X-Google-Smtp-Source: APXvYqxAEvi3WalOd9E7g982oDgX3nFv/Z84EKiOOXZxsmT9pYwmDis0TUBze2jaZ1celBz7+367c3Kct2TFEvw0hfU=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr14726137qty.141.1562608704941;
 Mon, 08 Jul 2019 10:58:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAH+k93FQkiwRXwgRGrUJEpmAGZBL03URKDmx8uVA9MnLrDKn0Q@mail.gmail.com>
In-Reply-To: <CAH+k93FQkiwRXwgRGrUJEpmAGZBL03URKDmx8uVA9MnLrDKn0Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Jul 2019 10:58:14 -0700
Message-ID: <CAEf4Bzb-EM41TLAkshQa=nVwiVuYnEYyhVL38gcaG=OaHoJJ6Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Matt Hart <matthew.hart@linaro.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 8:11 AM Matt Hart <matthew.hart@linaro.org> wrote:
>
> Hi all,
>
> I bisected a perf build error on ARMv7 to this patch:
> libbpf.c: In function =E2=80=98perf_event_open_probe=E2=80=99:
> libbpf.c:4112:17: error: cast from pointer to integer of different
> size [-Werror=3Dpointer-to-int-cast]
>   attr.config1 =3D (uint64_t)(void *)name; /* kprobe_func or uprobe_path =
*/
>                  ^
>
> Is this a known issue?

No, thanks for reporting!

It should be

attr.config1 =3D (uint64_t)(uintptr_t)(void *)name;

to avoid warning on 32-bit architectures.

I'll post a fix later today, but if you could verify this fixes
warning for you, I'd really appreciate that! Thanks!
