Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03A934BA03
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 23:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhC0WyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 18:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhC0WyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 18:54:14 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8840BC0613B1;
        Sat, 27 Mar 2021 15:54:12 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u10so11602811lju.7;
        Sat, 27 Mar 2021 15:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CgWlNjrPODTixptkU4oFDJ02sxLo+m3Op7DKbeVRhkY=;
        b=cJzY89ZI8cXB2HVs7S0WKNUZlWrPhPZOZY8Kb+zsEie90LtRZ4Qig1MulJmcyRWpg4
         rvI4SlwSwglMF8ovyGly22hBeEsXZBLKXWb7BI4H+Q17HJ/O+4/h+ZtN2zXFLt/8vmqa
         AD3urTByTu+24Mw9DnDjC5ZFq+o7cEXC0WrAhcxXNgY9+LPg/XZAcngVk5hpbtSJ2qqA
         f0nxVleqLDOpOLgmnjGqxqkSh6TTyLbczvQE3GqTTGzuHIeMmW6+vUkQmFbYoBzA/qER
         YUY0AZgYsNM99pC3V6hA0K1iDyuZwd7mim4nD8tbo9YlNdsXkvTu84Ixb5IHxqYNyGwr
         Py1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CgWlNjrPODTixptkU4oFDJ02sxLo+m3Op7DKbeVRhkY=;
        b=SC3UKc7voSisCrhfBQKCjOaxdsUtHonB5pYTCSJW9++Ws6Y6pa+23HxzVSw5Y/qRdJ
         7px6avxYXkHEeFyRyz+Byi5YqArIkjHK2Tk7acDX51qV7BjaQPBz9nlecl1lDmcsKNIa
         olxhDYWuncMjucJG3jvjyBsr2ifgCnL1JOqEDsLpHJYEnvRb21OebgdVD0/1mZtv18/m
         ryPhCUBenVqEH9vrh9F++tUsuwOCIed/RutMR+rJGSHWv2vEsfNqWispR4gKlqRSGNGh
         WeQsHNGWf15b+S3tIeb2qr+bfXL5od09AClXETFX0z55/OuOgWdeDWjIyyS6ybzhK2u0
         oBVA==
X-Gm-Message-State: AOAM533Jba+ATgrFad14oH5oZcoVxqHMC+4V0q83ZSMzVhht2RnDcKNN
        fYPanv/XLtx5P2aVvSo+R1ZH/GDoGAmyxngtMgs=
X-Google-Smtp-Source: ABdhPJw1QM6oUuQrWrMYK9ugmztsMgGD6u3E5uFq4ysXRNd6fq0cNwRYXzaZyCrI3xJKs80wCGVOF+yUeDEYXWG6m5w=
X-Received: by 2002:a2e:900b:: with SMTP id h11mr13380136ljg.258.1616885645580;
 Sat, 27 Mar 2021 15:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com> <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
In-Reply-To: <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 27 Mar 2021 15:53:54 -0700
Message-ID: <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 3:08 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>   BTFIDS  vmlinux
> FAILED unresolved symbol cubictcp_state
> make: *** [Makefile:1199: vmlinux] Error 255
>
> I suspect it is related to the kernel config or linker version.
>
> # grep TCP_CONG .config
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> CONFIG_TCP_CONG_CUBIC=y
..
>
> # pahole --version
> v1.17

That is the most likely reason.
In lib/Kconfig.debug
we have pahole >= 1.19 requirement for BTF in modules.
Though your config has CUBIC=y I suspect something odd goes on.
Could you please try the latest pahole 1.20 ?
