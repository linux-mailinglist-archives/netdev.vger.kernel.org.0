Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7A32D6FD7
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 06:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395269AbgLKFr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 00:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390420AbgLKFq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 00:46:58 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BC3C0613CF;
        Thu, 10 Dec 2020 21:46:17 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id x23so9562736lji.7;
        Thu, 10 Dec 2020 21:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ABChMFm0ciTptYYwJ6yT4JbGITbinlmFb/EbA4cUWi0=;
        b=Q4E+Lr3ImTwPlqAZugEFnvC9bd0iiJJU17L0O6hQrD51ddLWFA6fpy7QyEpLEPlRI9
         0AND0luaYFZth2DYU1B2oITSvkXOB7985ww07dNhwmv2ax5aGSbIKLxMIbWKRgB5SA9a
         87K2DCpyZP/X8sHYeNLcgxDHmaHvoFzrbA97P78S8exXuoA0aYjP9kRcNO6BqVL4SFIG
         hKzwEY8DDRHcuXimPj3RkQSHhd4bvNVVgB5KewdHdmQJj6u4pN2tx13QZUmTtUQMJ4Nd
         ygcyv54Spjxz0+yCgNhRztJrQTzpBj/1GQ6G+Y53xO4boTHlLjvREccEyuwPLLQbFq7W
         /gYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ABChMFm0ciTptYYwJ6yT4JbGITbinlmFb/EbA4cUWi0=;
        b=dgNo9Ry7d+/WnZXvGm2qz+74agakD+aA9p3knzDgo2+RvqzMQecF/QI2eMyktnem1e
         mV/w0V20g9USHeoCh4xMLXfi1ILSQBywOsRa5IzukhJrEwbqaU5Tr1tvGr5S1njGOE0h
         cD+BYJICzB1F3ua1KFJTGQ/HADwSOH3wuDkpz1++qs/yd3ejjoNFBbg7tAq4t0QkkJ8r
         YRtEccsk2M1/6X/hR8I4+0kq8bTdFTd5qTkpba6gwC78bC6s8EntXGXp2rZO+Os/souc
         AhH949drigk0zI89pMYPkU1Nsvv920Me3Yzn7hgr5uNcAshWN3V4AKkdRYp+SBuYhXKG
         TSRg==
X-Gm-Message-State: AOAM530MYA7c/3Yi6Tz89vqIvKT+YJEzGkD0f4yIJWNALK+v/cde8nEU
        faz2WaUse0KCctUcn/jzDQiyJog+zlH75pz3e9hkNdke
X-Google-Smtp-Source: ABdhPJyw2TxXJoVoax0mOp4lma/UVyzAg7c1lI+cKENsXTr0jY8NiEgiWnlIxoJGWxd/2wklR2VSYI00l3RQ8W3kQZs=
X-Received: by 2002:a2e:8948:: with SMTP id b8mr4425112ljk.21.1607665576180;
 Thu, 10 Dec 2020 21:46:16 -0800 (PST)
MIME-Version: 1.0
References: <20201211015946.4062098-1-andrii@kernel.org>
In-Reply-To: <20201211015946.4062098-1-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Dec 2020 21:46:04 -0800
Message-ID: <CAADnVQ+=Liu0t35yn4LHD3GuFiz53KvL8Moair0E3CRD_iZs7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix bpf_testmod.ko recompilation logic
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 5:59 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> bpf_testmod.ko build rule declared dependency on VMLINUX_BTF, but the variable
> itself was initialized after the rule was declared, which often caused
> bpf_testmod.ko to not be re-compiled. Fix by moving VMLINUX_BTF determination
> sooner.
>
> Also enforce bpf_testmod.ko recompilation when we detect that vmlinux image
> changed by removing bpf_testmod/bpf_testmod.ko. This is necessary to generate
> correct module's split BTF. Without it, Kbuild's module build logic might
> determine that nothing changed on the kernel side and thus bpf_testmod.ko
> shouldn't be rebuilt, so won't re-generate module BTF, which often leads to
> module's BTF with wrong string offsets against vmlinux BTF. Removing .ko file
> forces Kbuild to re-build the module.
>
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Fixes: 9f7fa225894c ("selftests/bpf: Add bpf_testmod kernel module for testing")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Applied. Thanks
