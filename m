Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D54FEB618
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfJaR1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:27:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41785 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbfJaR1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:27:24 -0400
Received: by mail-qk1-f196.google.com with SMTP id m125so7810172qkd.8;
        Thu, 31 Oct 2019 10:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iSUqkqDU/faH7JUBJ7EtgjdsgyN20noA3ne4iNgagfU=;
        b=HL1rCEoXI3ZE7uCXx4wHERSIV798yQnGNNqADhveQ7iWs6rKflQFHJOmeVVNSL7let
         UBSXvX528jKBESCZwiVJRRISm4FY0pJ1i3Q9luUFwhWELkvTKqZBsB8FywK0eG3mFSIp
         OwSSrz20bf1U+fvBJiEYRinWmAQ9pBtMvZeND+j2veSaHZmdVxaInl2q/sIDr4Jhenay
         hvF2iBMLXEOfENOe9Ppy1iOXVtZ5D/TadqYwJ0iA38J7U9YyRixLENVx2SGqTt/GbPNN
         eVZ31wMyKoGu/Y1Hy3ZIIvNQC5lAST2UiAVcdg4Qk35/UobpnhpbIxG2RGzZsapgLPcQ
         ShZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iSUqkqDU/faH7JUBJ7EtgjdsgyN20noA3ne4iNgagfU=;
        b=Cc7cYQv4klLwnli1PHy2C3HmeJ67/Ww+flLgAMOxcsqLyXz+5hAkj2ABE94ABGrxK3
         qK7Zs7vxx6FBM8zYsDBgKgejM0iSgVwJ9g2ZTtaB6qlNvL2JeAnBIwY5e95pjREh6EgB
         sRgKYxQpLZWNrveXxEb4VMEo1Ue1mStOjtMXrrq0JwLqq3gbZMuwK2gzg+mj9fXts5gH
         OXNQSVr58m13rU3APzkiz27UK8G930p25T3PgEn7yDy1dpEyFZBTlcVcMTjWmlrgn8zy
         6MPsbZ+yKmIQh06xmZnVCNsAPR3jy3QszTWSxlFAuDqpFMVL5yQUIdwR3JjRE284LXi9
         lYNg==
X-Gm-Message-State: APjAAAWd/f7fLEHMf+Q0L+x2X/6tRxegzXKmUiD9foALs9s4WebUqXzh
        g7qIMzqQ13kndsqe+J/ej29sYTVTwI467oEyyn0=
X-Google-Smtp-Source: APXvYqy6kbLgkJyURaQYfF1fdw/STSnhQvWvCgOE/TZK2rzQ7ZgPXpKV/RBRTfGAmlCI9x3SB77RPgiYNnkp+zgBxaM=
X-Received: by 2002:a37:8f83:: with SMTP id r125mr1631089qkd.36.1572542843511;
 Thu, 31 Oct 2019 10:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <157237796219.169521.2129132883251452764.stgit@toke.dk> <157237796564.169521.10850494774906637330.stgit@toke.dk>
In-Reply-To: <157237796564.169521.10850494774906637330.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 10:27:12 -0700
Message-ID: <CAEf4BzbKgZ_3MfF6YiN60Mbqrut-U8Ypyc6-=ZZCcwGL+Y74zQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/5] libbpf: Move directory creation into
 _pin() functions
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

On Tue, Oct 29, 2019 at 12:39 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The existing pin_*() functions all try to create the parent directory
> before pinning. Move this check into the per-object _pin() functions
> instead. This ensures consistent behaviour when auto-pinning is
> added (which doesn't go through the top-level pin_maps() function), at th=
e
> cost of a few more calls to mkdir().
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Makes sense, thanks.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c |   61 +++++++++++++++++++++++++++---------------=
------
>  1 file changed, 34 insertions(+), 27 deletions(-)
>

[...]
