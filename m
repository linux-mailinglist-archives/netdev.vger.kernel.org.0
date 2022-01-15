Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203A748F427
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 02:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiAOB34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 20:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiAOB34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 20:29:56 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8DBC061574;
        Fri, 14 Jan 2022 17:29:55 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id w7so9287955ioj.5;
        Fri, 14 Jan 2022 17:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GCZeq11EnvKAVKRXJ+Wljwr0enBfs9n5483mIDTDdOY=;
        b=Vz/uODpM9Be/LGmGZphd/faVAELhVJKHdhdJUYUDjlXwtHhA9Q1pXYvpKDAJ1VW7JC
         8zfjfVPqBpM4hjsLwhF+lA+2vSJz/vfDPnlBlijPhphfvxtJC96+A5QD5Jierl9blQ0r
         8xuR8yPXMBoT0aZk1u2vQUg6KNf55t+CzJ8IwE1d6/y3bOWvkYDkri09etCGg+VpiX7R
         xDuBmV102/pJDnGxpON+JKMCcDDmku2X7Kx9vbqxeIjtB1Z8TgzYXkX3ZFiFFj2J7Wkw
         bXhqM1ZudTQyxu48PHCf9oR3AqiWtKMzkR1ykfRAq1tzjQnrzB7ZREfCqvxS/cPNCson
         4NvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GCZeq11EnvKAVKRXJ+Wljwr0enBfs9n5483mIDTDdOY=;
        b=7CJfDBAy8R0ISxfC1SEirpKUzalQiOXoG2cGAxS4tf8lztDPq/q1XOe+9gEAosBnFy
         +kG/0gNmWZw6NN1zZKuQ+S1mGoQYWhHOcmv/ppXeQucLwm3WuwAqCOiep9Bg689IpmKu
         QuLuUoXP6V6vOVgAO60tiMYE2Uy//tlZB1AhUZIUgnf1XZJmWrHiD0DKD7ggoo4EiAFW
         tMHtOT0YKgHojCXSfS+MV0yrrFyGQlYWqL1lzGZpXDFGpqwTFGvVhBj/wzixM2IBSSbh
         JoATHCWM8EP9d2I8WDsiO6uhyrn35txOU7iaFOlt7PTR/tAdA3k++416q1XjHTKlnliN
         tCNA==
X-Gm-Message-State: AOAM532HIyX0sW6PDeN3U87FH+TovxrMo/beepRbJQjXvnDe1xB0AnqV
        TN1EQHXyUroHdZUgfUHa4LwDimGSLXDPX64fBBI=
X-Google-Smtp-Source: ABdhPJzb9ulZQ0BEYgTf+m/NE8souXe8oG3Lt0HK1RhGGcmIYBF5wqsLpy+zc1Wm7CpDkFgStZUV2UrzDqErgPlguls=
X-Received: by 2002:a02:bb8d:: with SMTP id g13mr5414980jan.103.1642210195208;
 Fri, 14 Jan 2022 17:29:55 -0800 (PST)
MIME-Version: 1.0
References: <20220113162228.5576-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220113162228.5576-1-jiapeng.chong@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 17:29:43 -0800
Message-ID: <CAEf4BzYiNbJAW4TJjvQR0mfFGtBXrqyqgoM2TuwDqSJG18cA0Q@mail.gmail.com>
Subject: Re: [PATCH] samples/bpf: xdpsock: Use swap() instead of open coding it
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 8:22 AM Jiapeng Chong
<jiapeng.chong@linux.alibaba.com> wrote:
>
> Clean the following coccicheck warning:
>
> ./samples/bpf/xdpsock_user.c:632:22-23: WARNING opportunity for swap().
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  samples/bpf/xdpsock_user.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index aa50864e4415..30065c703c77 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -626,11 +626,8 @@ static void swap_mac_addresses(void *data)
>         struct ether_header *eth =3D (struct ether_header *)data;
>         struct ether_addr *src_addr =3D (struct ether_addr *)&eth->ether_=
shost;
>         struct ether_addr *dst_addr =3D (struct ether_addr *)&eth->ether_=
dhost;
> -       struct ether_addr tmp;
>
> -       tmp =3D *src_addr;
> -       *src_addr =3D *dst_addr;
> -       *dst_addr =3D tmp;
> +       swap(*src_addr, *dst_addr);

Don't mindlessly apply any suggestion of any robot/script without at
least compile-testing:

/data/users/andriin/linux/samples/bpf/xdpsock_user.c: In function
=E2=80=98swap_mac_addresses=E2=80=99:
/data/users/andriin/linux/samples/bpf/xdpsock_user.c:630:2: warning:
implicit declaration of function =E2=80=98swap=E2=80=99; did you mean =E2=
=80=98mmap=E2=80=99?
[-Wimplicit-function-declaration]
  swap(*src_addr, *dst_addr);
  ^~~~
  mmap

I think this exact change was accidentally applied recently and backed
out. Please stop sending such "improvements".


>  }
>
>  static void hex_dump(void *pkt, size_t length, u64 addr)
> --
> 2.20.1.7.g153144c
>
