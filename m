Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89B9B463B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 06:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfIQEMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 00:12:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42699 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfIQEMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 00:12:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id f16so2416290qkl.9;
        Mon, 16 Sep 2019 21:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yZzOqidsjo85aSS4sastJYqRni/k6zjUrRu+ouhRS4U=;
        b=f5HaSEB5mb4x627zbUcF1RDiWpeIxa5U6vcPYImWyHyBds+Wzg2wGOs9jrw/JGXEec
         ZsFD1nhBNuiS8sEOWCsr1/RpRyMU9lpSZQ/vIVI0MYROAiKz/S401fExSIqqTsASNtbZ
         ibDZwuRORia+0K1gGBCRv87Sv+B1bsB4BjGyz13wnOxJASm9NMGWeJeXlTceaQnAYtgz
         Tl7XAPs+3dD8jnulAH7H2cpN5G8Oz/P8lzJfhTo2zps28+vORaiEDjjUWdkWqTWiyTmC
         Wztn+nW7chYOzH5beR5kLZyuUfMtsabgeEltuFgFSKYhzWAT0EupEMx8O2hrxFe2VyFw
         EfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yZzOqidsjo85aSS4sastJYqRni/k6zjUrRu+ouhRS4U=;
        b=jyK5TbjiqckwxuHEHGPR8O+oK1r5tG60HojSk91QQqCrCmRxk2W2yrks9hLA5LDnUC
         rx/59F4GZeAKPnEsCVtjfT2DwPrqwSxdrIkdQMJ8GHGiGS1N/Mjs99McWhgij9hqRRqL
         kScCXkxSyQeKXqrodLevYVthl1h+jY3AYh0bZSwo8ggXLd3UEFQrR3F2Q35b9y+jNVIS
         qrjp6ecc7YRxqc2WZr7pnDIPzs82HxkaHxdbv4UsZQ0fdgjtKBuAqCwLCDwLz8CVfeZ3
         MyHhth+b4bbQ4re3A4EGuPh8KEL8Nr/xLijqRsHpg7R6c70Z1Sxlqd7tdkR/jh6f+N8I
         hGoQ==
X-Gm-Message-State: APjAAAUJy35cklmWJbgwffUUfRDSyWy05f+oSpWMrnOGzyIFunKsy5KK
        vrKAFPJsKq35TD0z9ZeYbWlSHBNFCXis7zNMcQM=
X-Google-Smtp-Source: APXvYqwZSDge9O/o77NWbL3xsm+hUhFvt7SDF/Go533S0kmBVDWDg8bT9LLIDvRF8Y8np2/C30Gkogc1muKdFZ0YMIk=
X-Received: by 2002:ae9:dc87:: with SMTP id q129mr1762990qkf.92.1568693553793;
 Mon, 16 Sep 2019 21:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190916123342.49928-1-toke@redhat.com>
In-Reply-To: <20190916123342.49928-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 21:12:23 -0700
Message-ID: <CAEf4BzaX3OgTofrx2gwHXLXBpRV7ahdCPJUGkaPreJV-D=4dGQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2] libbpf: Remove getsockopt() check for XDP_OPTIONS
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 6:05 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> The xsk_socket__create() function fails and returns an error if it cannot
> get the XDP_OPTIONS through getsockopt(). However, support for XDP_OPTION=
S
> was not added until kernel 5.3, so this means that creating XSK sockets
> always fails on older kernels.
>
> Since the option is just used to set the zero-copy flag in the xsk struct=
,
> and that flag is not really used for anything yet, just remove the
> getsockopt() call until a proper use for it is introduced.
>
> Suggested-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
> v2:
>   - Remove the call entirely.
>
>  tools/lib/bpf/xsk.c | 11 -----------
>  1 file changed, 11 deletions(-)
>

Who doesn't like removal of code?.. :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
