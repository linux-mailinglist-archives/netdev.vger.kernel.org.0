Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E8C79A98
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfG2VG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:06:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45418 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfG2VG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:06:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id x22so55987582qtp.12;
        Mon, 29 Jul 2019 14:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMS0bLtsmwmEpa1wC+excTg1r4uHM9EcfmdqUbZzBbE=;
        b=AMHkfkLER4gIIzHAL7Sqmcbn/TXgFVtz0zcjcWpMGezD81xS27OpA4QOEvxlWyqg2g
         jnqFkGVtVgxVAh4ejMZ+MAxn9PqibjGI3vpBfDxYEDbIlDs2a2bT0x2vB8cTuaZn2sZM
         I/36bFby1N0w+8RgvYMU23Kp/VMl7nO8XyeYVJScPNcsdiY8nlJ6J/scoG0oTTY73aBY
         4aUpNV076W7V1oyqkBdWaUWH226muFFwU3+iSEKiDSa6QmWGArACvZJ8RmKzKhkj4iDp
         tkd14HNcmXwnM13lVmWLIZ/motWo7xZhXCaUluWxcLtFfITU2jhePTvHB3FheTaEAWnA
         ZtDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMS0bLtsmwmEpa1wC+excTg1r4uHM9EcfmdqUbZzBbE=;
        b=GDALolDkQ+5x28tR9RPVsSaEQ3PBRhp8s+rvCw1RDdwl/Sbp/1+O/dFfqYvunmisWD
         rTkm1zm7TNM0o/25laXUr6lsAjvKbO4QvNuNCDf9MddzTouSFiFIyd4EVfCUSvA+OVfv
         hc/kHknGY/QOt1LoIc63f/VTArvR3up0ELRjXFYXWcrc9CGZieqyP7JBbnAppuFl5wB0
         t9I5EO2xLbHd8KpuzQ8RiaulJpfxw/1XIgiY5tvmXnA85sc1uWrSQxZXGMXF7bG0DX8r
         rD65oz+B/D7ukIzpcDsyzCS1I1VocU8gllTin3LRfrFjhqKtvB5bEXNBFpaIFjR+rK+1
         FPCw==
X-Gm-Message-State: APjAAAUgv7MY0mFGgFUlrY++N3RZBmtil/ZPDUnHM1bKrhppVJYRRujp
        MJI/VzBgoljxhkLdGl0DkVh7U9NP0gq1EyUHuTY=
X-Google-Smtp-Source: APXvYqxhYK1gl0y2gPhb9NpExWAXZwDavEc63qX4P1aCmUTRXzHBrJJjpkn+WKrOBlkQh9VJxlUIzoHl9+WLnmY6+Fk=
X-Received: by 2002:ac8:6a17:: with SMTP id t23mr76434949qtr.183.1564434417596;
 Mon, 29 Jul 2019 14:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-6-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-6-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 29 Jul 2019 14:06:46 -0700
Message-ID: <CAPhsuW6CJJHJF85w5MPzbVU7--hNZeBKOy1NhaB0L0Owbs1biQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/10] selftests/bpf: add CO-RE relocs nesting tests
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 1:33 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add a bunch of test validating correct handling of nested
> structs/unions.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
