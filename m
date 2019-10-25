Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CA8E41ED
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391590AbfJYDAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:00:32 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35885 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391491AbfJYDAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 23:00:32 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so1177960qto.3;
        Thu, 24 Oct 2019 20:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bHKg0eWYJUG+Fc0Bsd1BI5X7R49sURnA3NHe9WQ3b+0=;
        b=hIOkYKdj/E6UqW3l+irtpwTBkKav5BgxHrES69zvqKWbcvXlvLQxv5pNJU0qk+aqUg
         /56TmvrxwF6mxKKfENkpgjkAwphuwn02YKLw1mIYLNFMOj4vrtP7cIStNTvKWIkfpwfF
         x0m5x9+P3vXUXx/Sj6JOgS1AWDjYF18x7QEscHMi16o7ikzhuPshZZr0/Sh+np9K13yK
         0RiuUZKf1TJICf/Jdt0sooNEOJv/+XSBDdrRis7lFd4lukKxW7XDNarrogyiRjas8s4u
         CxVQGqInpmNX1fV64DpuTxhQxpzXMv8KYI1ySxBQkDMDcqyRGu58dn/OaAnQiqypfgyS
         p7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bHKg0eWYJUG+Fc0Bsd1BI5X7R49sURnA3NHe9WQ3b+0=;
        b=Z1fm+YVb11aM3/e3Evx+2iFciOqYEVsZxMFM/M0eGdPjA4gRx0fBINVVYv5uU+I3JC
         sHDxx+vKmLoqYzsUfml0hSf8QQeN5MRrmZobYcKzQZMGSyuB9PwXz7Hw6hL3BYAOIfu8
         U6K8NEcIvT3XWdH4UdaqW9Tnoeftvk9yYwu/r/cqNYI/Sa9udnMAGQZLWD9aXDhLM3es
         6HCcPJLabWQ6jGKryNQfLtCK0Xcw+N5m40F+xqslqI3l0B7pgMfOmx1tReuPyVljKN9E
         h0p4xq1j/yRZP+Hs0OSsyje+81nS1uA7+nhrvz+uxY9AZbWgBio3HKXIH3GutU+Bpqcq
         TrqQ==
X-Gm-Message-State: APjAAAUetsGdPOrRcrjkyjF+5xHgAnxDzU35E/jXIbnIgqkQO0cmdfyl
        Dr0kG3t28ZpQ55skvfc1LHmCLeaw74q7oxvnEhxOvdPf
X-Google-Smtp-Source: APXvYqwA0AZDXPh7XF66dkZhEP/sa/kwrKxwHK75YFio7ixiuKHZvEpEHuOCAfx1LgZGGouzG131WS25qpfyN62fQbs=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr912956qtj.171.1571972430698;
 Thu, 24 Oct 2019 20:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <157192269744.234778.11792009511322809519.stgit@toke.dk> <157192269965.234778.8724720580046668597.stgit@toke.dk>
In-Reply-To: <157192269965.234778.8724720580046668597.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Oct 2019 20:00:18 -0700
Message-ID: <CAEf4BzaXcNwYzkpsAmbVb10KaaSVcoci=qcVi4QcdU3oVGAR7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] libbpf: Store map pin path and status in
 struct bpf_map
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 6:11 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Support storing and setting a pin path in struct bpf_map, which can be us=
ed
> for automatic pinning. Also store the pin status so we can avoid attempts
> to re-pin a map that has already been pinned (or reused from a previous
> pinning).
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Looks good!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c   |  115 ++++++++++++++++++++++++++++++++++++----=
------
>  tools/lib/bpf/libbpf.h   |    3 +
>  tools/lib/bpf/libbpf.map |    3 +
>  3 files changed, 97 insertions(+), 24 deletions(-)
>
