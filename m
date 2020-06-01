Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF921EB14D
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgFAVxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgFAVxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:53:02 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174D0C061A0E;
        Mon,  1 Jun 2020 14:53:02 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x22so4862617lfd.4;
        Mon, 01 Jun 2020 14:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGFRGjB8KlVMfwSTDSAUcjWqnVY9QFMY5Q7CDZwYx84=;
        b=YRi8fEyFRNi6j6tuvcquGxpn4l9y/Q66dfCQW/SEyRB2J5YiVTeWsAMZSEffJf3hyv
         Y4bjcBmLtN/H52fHcqSxZQHSOCnHByduajP2UzKyoYBAGd5J90D+YV7eIv6bZmmlQUeQ
         Zi9IX07cwFhYcyK4icduPnwVX5UzgEU+ks3xVcfV1+UA+pUtavoZ4iHYdctJMS/ozCxA
         K9GQXgdgH7h9S53saDAm7LY1QnD79ID4Bc9wPnKTLF+hFG1JYX7m/ZO5zx4fdcm53IP6
         o+q+pDuNa4PrQ9XoxHDnbdyCNMcC60ooc+FlVeY1Lv9/K0mCybeCwg1S4fFeHeqWkz8y
         JSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGFRGjB8KlVMfwSTDSAUcjWqnVY9QFMY5Q7CDZwYx84=;
        b=NYlPyHdTGFhhBKIQvwvBgIJjyLR77Yycdv2OCLGEhqf6oJzFtWKI2kuPD05rYjJTy3
         cHH6hee3YHmuK8/Ne/BDh3wuJm7S7k6dpSMYgjfWJD5TqBmx3BzxWEYDnvnVZiSN+vyT
         OM8tb2oMubczfIvXmPoRj5lABVc02hkkczgV0ewKR9Uiyx2uLUdri09p6mJVl1vBM7UN
         v7IR0tk8nNy4K8RAT85uPnqlF0auqJMW3jC7ofZ7gMlZVn2pzufL7wWIDhZb9bcRS/cP
         lMi0d78gVcEtmpN82S7WCR81Ij6ZcI0bMj7Nf64MFMaStBeOYlk5LUAYe4dZlh1p4kpR
         MF/A==
X-Gm-Message-State: AOAM530m4FoL0WONANt2jeT4q05FAC7+pVIkNT9tvwKywOD4TNk397w+
        zjWVKKOsgiQzyB0C7g8hz357+PuBhhBWRxelDGQpc4Wx
X-Google-Smtp-Source: ABdhPJylayFI/Y6i92Ue/tYvBnAXyW6msOz4enPLpMU0wrbPR5XRgDvppc2l82bICQJqf4+bCwnfpiwJM66FXRaNx8k=
X-Received: by 2002:a19:987:: with SMTP id 129mr12303056lfj.8.1591048380448;
 Mon, 01 Jun 2020 14:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200527195849.97118-1-zeil@yandex-team.ru> <CAADnVQJ9vD_qfBM21JS-=zdBwK8RoN2grUhaVd2oFmunD+0K_g@mail.gmail.com>
In-Reply-To: <CAADnVQJ9vD_qfBM21JS-=zdBwK8RoN2grUhaVd2oFmunD+0K_g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 14:52:48 -0700
Message-ID: <CAADnVQKrX4=A6Sv+mDG6WcK6UG-pSarrRRnQ7RotmRnd6he37A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] sock: move sock_valbool_flag to header
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 1:32 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, May 27, 2020 at 1:00 PM Dmitry Yakunin <zeil@yandex-team.ru> wrote:
> >
> > This is preparation for usage in bpf_setsockopt.
> >
> > Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
>
> Applied the set. Thanks

I had to drop it due to non-trivial conflict with net-next :(
Commit 71c48eb81c9e ("tcp: add tcp_sock_set_keepidle")
introduced __tcp_sock_set_keepidle() which is exactly the patch 2.
I didn't want to do such surgery.
Pls respin.
