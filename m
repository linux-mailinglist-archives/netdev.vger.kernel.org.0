Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E7415062E
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 13:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgBCM2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 07:28:48 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46960 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgBCM2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 07:28:48 -0500
Received: by mail-qk1-f194.google.com with SMTP id g195so13908470qke.13;
        Mon, 03 Feb 2020 04:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Bps9/ugZnw/LOkhCjhjvZvxvS5kO2i7OXxXUPo/WJGE=;
        b=jB9d7cw/PfiS8u8EbQs9pbNd5O2Hc7F0Au7RXWC+0X/zEoq8P5dW767fu/Sc/f/7Pg
         TiU8XRBuDYjCVjTZGWK5Swxp/mLNZj2/oaHXilAq2XR6lBRIOODl6O0rcsNhf0SQY8MI
         nz87gFswjm/HuWRFTDlNU5evHzM+3I19xI3EbPRaKCfgS3Jb3aYy00Hr8dLky8ttfHFg
         GXw5vY//jJdNKGf8EtGktjAegQM0PdkYkZgzkzTsVREXTq4NZzAGbrYvwjfmYWCmprYz
         I5pRwgT9sXGL9EBlBB4SXjWEM+Oenc+f/rLbVLh249ZtgwVBLieSDQ56YGIGAZ8OErYW
         bjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bps9/ugZnw/LOkhCjhjvZvxvS5kO2i7OXxXUPo/WJGE=;
        b=PDWdRI7QG+zDlNG1J6p2GPDzsxijj2Gmmc5KA30D/jB+dM4BmUHUcXysFVq0cNJkR+
         9RTRUbPZAp68RJXVUxcTJeLdGAHFRCSknT0+Zpwf6TBbWj6IUfkLrytI4zRQ5JQwgh0r
         /OdLHoAodilcekhPNEKH7RMC9LjuB7I2V5Oezlwpc60sHYjfTjOED9gm6IrD1FJGqj0y
         MCZgI12anv9GqIqyGvqAf3P3y52n8eO/uKLg3zA2sIE2un9D5t8NNWrHx4K5aumHXDMl
         YQHYlzWEDZ31vPp4OcuhWZP9Yb5M1xWXYdoosf3eYuORmVIBzHHba8necXD3PyDh0G1y
         RnZA==
X-Gm-Message-State: APjAAAV7/qhEmZdLI73FsrKT74yCuc/0qtjsBXL1roEfH1BGA7Gj3iCw
        l3GQKXAnd3wVq0WJFdpCaRRTKUtyOSYK8qfHGpo=
X-Google-Smtp-Source: APXvYqzFTVokDAvj4jM1EbkUWGFzCx3Rgz95Htz+3sKmmtcmARXUP7r9f9Tq9n+1DpqFFfKtylDEQ3g+9C6ZwMhwMic=
X-Received: by 2002:a37:8046:: with SMTP id b67mr23085188qkd.218.1580732927145;
 Mon, 03 Feb 2020 04:28:47 -0800 (PST)
MIME-Version: 1.0
References: <20191216091343.23260-1-bjorn.topel@gmail.com> <20191216091343.23260-7-bjorn.topel@gmail.com>
 <3f6d3495-efdf-e663-2a84-303fde947a1d@ghiti.fr>
In-Reply-To: <3f6d3495-efdf-e663-2a84-303fde947a1d@ghiti.fr>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 3 Feb 2020 13:28:35 +0100
Message-ID: <CAJ+HfNgOrx1D-tSxXsoZsMxZtHX-Ksdeg8bZFFPRPGChup4oFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] riscv, bpf: provide RISC-V specific JIT
 image alloc/free
To:     Alex Ghiti <alex@ghiti.fr>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>, Anup Patel <anup@brainfault.org>,
        vincent.chen@sifive.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Feb 2020 at 14:37, Alex Ghiti <alex@ghiti.fr> wrote:
>
[...]
>
> I think it would be better to completely avoid this patch and the
> definition of this
> new zone by using the generic implementation if we had the patch
> discussed here
> regarding modules memory allocation (that in any case we need to fix
> modules loading):
>
> https://lore.kernel.org/linux-riscv/d868acf5-7242-93dc-0051-f97e64dc4387@=
ghiti.fr/T/#m2be30cb71dc9aa834a50d346961acee26158a238
>

This patch is already upstream. I agree that when the module
allocation fix is upstream, the BPF image allocation can be folded
into the module allocation. IOW, I wont send any page table dumper
patch for BPF memory.

But keep in mind that the RV BPF JIT relies on having the kernel text
within the 32b range (as does modules)


Cheers,
Bj=C3=B6rn
