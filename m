Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04BD14E683
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 01:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgAaAVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 19:21:07 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33023 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbgAaAVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 19:21:06 -0500
Received: by mail-lf1-f68.google.com with SMTP id n25so3606123lfl.0;
        Thu, 30 Jan 2020 16:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YJl6wAbcLxvyPMiKfkvwF3k+eTQS8qulkoTKA0EzkyI=;
        b=G+akR26q27WNPIKhlJ/apbXJ69ZyWCA0DLukrbj91jTkF8ibRLJT7XGfcof6ETXhQj
         A2yCkdZP3hvCODMJm4icjJJv96/4O0oTX8SJ9dlkcTXXufbh9By9rkdJwoIFLCo/IKIP
         L2vjiYxC0Lg5UPhGIGUre2BNkfTQvICDdO27i0Wt94AjfFN7GzZGe49zhADEr2LUsRjG
         aYm7PKyHbFBbiqDE1DjzsEt3nz/P+TUo9r23+IXy4vB9cLs8PAEZ5fxLV99y/sM4pXDE
         5BiVHkC7p5diknYfIujh+4ss1WMHyf/ZGPnmGEj7d//uiBkObW+euoy7cevvpypwjoQV
         QJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YJl6wAbcLxvyPMiKfkvwF3k+eTQS8qulkoTKA0EzkyI=;
        b=PACoptP6kl2uG4dWu8pP+l0JH3CqX0fbPSFon2KZ+66n1CB0c5HMe1rLGkfvcPqbEs
         O2/oVNpUWkH27EyzrUToMTvB27Bbszstl1ApNiOXZavH81RWLqmEXXPvB2sSvcD9Ns6L
         xzi1DHfSOC+2XXNjqy3eFOH8dDOxBA1fNn7xtbQ5T5p7cButJxiFOt/B35Cg2kQZGwGb
         uKF6nLil4NwnpXc3f8VE4kgOJV4jD+SEbjf3Nm0s/UR4m9auDAsac0SWg7PkvQ3xG5XL
         //aoczBiWybsB1El6k1Xrqpxr/ZFKz8GSqlf5c1lW0XqYWOHkSF/HqGBHl63+aux9Qmb
         Zjsw==
X-Gm-Message-State: APjAAAWJiwpXZa7TWrxzRoqw47QsdDzoCW96HF1yQY2lFvGswU+o1zis
        XIozBz721VuasBh0cUukBIoj3KvLf62+6JjCtj4=
X-Google-Smtp-Source: APXvYqyxIhlLn1xAeJnO1JlpLRiUbZemvA7cXbmPXjb7fhZHJ1tUQLyquVsMnJxWqc68U2HuwUM4ofi4FZgMt+W+/lE=
X-Received: by 2002:a19:c3ce:: with SMTP id t197mr3875456lff.174.1580430064465;
 Thu, 30 Jan 2020 16:21:04 -0800 (PST)
MIME-Version: 1.0
References: <908498f794661c44dca54da9e09dc0c382df6fcb.1580425879.git.hex@fb.com>
In-Reply-To: <908498f794661c44dca54da9e09dc0c382df6fcb.1580425879.git.hex@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 30 Jan 2020 16:20:53 -0800
Message-ID: <CAADnVQLjsMWw0F8FJoBGLLs_Ab2WXc-T2Lfhks=sUKVTBu1veQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf] runqslower: fix Makefile
To:     Yulia Kartseva <hex@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 3:14 PM Yulia Kartseva <hex@fb.com> wrote:
>
> Fix undefined reference linker errors when building runqslower with
> gcc 7.4.0 on Ubuntu 18.04.
> The issue is with misplaced -lelf, -lz options in Makefile:
> $(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
>
> -lelf, -lz options should follow the list of target dependencies:
> $(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
> or after substitution
> cc -g -Wall runqslower.o libbpf.a -lelf -lz -o runqslower
>
> The current order of gcc params causes failure in libelf symbols resolution,
> e.g. undefined reference to `elf_memory'
>
> Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
> Signed-off-by: Julia Kartseva <hex@fb.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
