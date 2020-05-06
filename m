Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F07A1C763A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgEFQ2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729414AbgEFQ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:28:00 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F393DC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 09:27:59 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id v4so5337023wme.1
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 09:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z9GqYI/IBZKFEzxBSgM2PHMggCxjCwKn/F7YB/gphik=;
        b=rtXjslCjcIN3FLJ3E+U/gk+3HXKvVu81KeSEL0OguhbE4r18V88R7xZizaprcMSrM1
         U12rPkuNJJNLkTn+HO/eVHeSb98jG3zL2AWmuanbRDUcYcamRe+GflIVL9D2ZFVaN4rK
         GfUH64eVPvHPgVeyGbebQCtuPNbvDxj6361XLhwMLUB0zrfvgGc8JQe3RWv0k/nfOgpG
         IhHJLzfhQUJ+fzOXnqTIxmjl7J0EvfepytRZ11JGPVtCkuaGZys1DxgkGT7naNSx8TTb
         VHLjVEED/LNR5ZzlWFu4WxO0OviZ4EmJmyzP66w1king41xwRWRBM6XBF0QCx02V2Bdv
         79cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9GqYI/IBZKFEzxBSgM2PHMggCxjCwKn/F7YB/gphik=;
        b=qYwKQWqnhrrgXN4h/UUZis2qkzXHNiRgMDL2wIFvRrwEhUMWHU9W6l1VBB2Mo4LhcA
         IzuiAsvp0slf+4tB0ZAXGmUx/60sg9vcsG4TfN9lcdrW+f15w059aUpRuWS8xYjjjv/X
         +C6NtkS7NK35Mp+aUSsmuZmZUm7WjnRB/oonYK/VghGTt2x8gYeiAG5ZZtacTKzoPdhf
         hssSK+MxH6bwO3bCFh+l0DfkQYkeDWekZXc55MsEcmRvBOzhunWvuzzcy4KNFLl/hjyA
         LgPllVULz1dnoac2u6Pqo5v1HNF3r8B+HD1IWFfOE9JBF02KTD/FBUxtGFaUfs4CAreM
         Zjlw==
X-Gm-Message-State: AGi0PuYdf7+HwVz8/hhzEiublvAhutOdknFrhgcr0JSA90k82BewvK5a
        EdNEyb9ZmIBWfRkyxI3Uel9+cWhWp7ul9wTlQHu5BHTc4uvBqg==
X-Google-Smtp-Source: APiQypJqiMfjKyhM54u2ivUuRMIe3pJn5OFgDDJwEIKVI8TxFXvzOTWros0E8WGcwS/LIzB9IdYd0hzZU+aw0dFW4hs=
X-Received: by 2002:a1c:80c3:: with SMTP id b186mr5762909wmd.117.1588782478299;
 Wed, 06 May 2020 09:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200506162115.172485-1-edumazet@google.com>
In-Reply-To: <20200506162115.172485-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Wed, 6 May 2020 12:27:22 -0400
Message-ID: <CACSApvbOY2NZPZRoLjiHH2bAMxxU6v+=Zj15=v6_rPCLcA4OhQ@mail.gmail.com>
Subject: Re: [PATCH net] selftests: net: tcp_mmap: fix SO_RCVLOWAT setting
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 12:21 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Since chunk_size is no longer an integer, we can not
> use it directly as an argument of setsockopt().
>
> This patch should fix tcp_mmap for Big Endian kernels.
>
> Fixes: 597b01edafac ("selftests: net: avoid ptl lock contention in tcp_mmap")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Arjun Roy <arjunroy@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  tools/testing/selftests/net/tcp_mmap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
> index 62171fd638c817dabe2d988f3cfae74522112584..4555f88252bafd31d6c225590316f03b08d3b132 100644
> --- a/tools/testing/selftests/net/tcp_mmap.c
> +++ b/tools/testing/selftests/net/tcp_mmap.c
> @@ -282,12 +282,14 @@ static void setup_sockaddr(int domain, const char *str_addr,
>  static void do_accept(int fdlisten)
>  {
>         pthread_attr_t attr;
> +       int rcvlowat;
>
>         pthread_attr_init(&attr);
>         pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
>
> +       rcvlowat = chunk_size;
>         if (setsockopt(fdlisten, SOL_SOCKET, SO_RCVLOWAT,
> -                      &chunk_size, sizeof(chunk_size)) == -1) {
> +                      &rcvlowat, sizeof(rcvlowat)) == -1) {
>                 perror("setsockopt SO_RCVLOWAT");
>         }
>
> --
> 2.26.2.526.g744177e7f7-goog
>
